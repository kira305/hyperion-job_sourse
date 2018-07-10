<?php

/*
 * This file is part of EC-CUBE
 *
 * Copyright(c) 2000-2014 LOCKON CO.,LTD. All Rights Reserved.
 *
 * http://www.lockon.co.jp/
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

require_once CLASS_EX_REALDIR . 'page_extends/LC_Page_Ex.php';

/**
 * パスワード発行 のページクラス.
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id$
 */
class LC_Page_Forgot_Mail extends LC_Page_Ex {

    /** フォームパラメーターの配列 */
    public $objFormParam;

    /** 秘密の質問の答え */
    public $arrReminder;

    /** 変更後パスワード */
    public $temp_password;

    /** エラーメッセージ */
    public $errmsg;

    /**
     * Page を初期化する.
     *
     * @return void
     */
    public function init() {
        $this->skip_load_page_layout = true;
        parent::init();
        $this->tpl_title = 'メールアドレスの再発行';
        $this->tpl_mainpage = 'forgot/mail.tpl';
        $this->tpl_mainno = '';

        $this->device_type = SC_Display_Ex::detectDevice();
        $this->httpCacheControl('nocache');

        $objDate = new SC_Date_Ex(BIRTH_YEAR, date('Y', strtotime('now')));
        $this->arrYear = $objDate->getYear('', START_BIRTH_YEAR, '');
        $this->arrMonth = $objDate->getMonth(true);
        $this->arrDay = $objDate->getDay(true);
    }

    /**
     * Page のプロセス.
     *
     * @return void
     */
    public function process() {
        parent::process();
        $this->action();
        $this->sendResponse();
    }

    /**
     * Page のアクション.
     *
     * @return void
     */
    public function action() {
        // パラメーター管理クラス
        $objFormParam = new SC_FormParam_Ex();

        switch ($this->getMode()) {
            case 'confirm':
                $this->lfInitParam($objFormParam);
                $objFormParam->setParam($_POST);
                $objFormParam->convParam();
                $objFormParam->toLower('email');
                $this->arrForm = $objFormParam->getHashArray();
                $this->arrErr = $objFormParam->checkError();
                if (SC_Utils_Ex::isBlank($this->arrErr)) {
                    $ownEmail = $this->getMemberByInfo($this->arrForm);
                    if ($ownEmail != '') {
                        $this->tpl_mainpage = 'forgot/mail_complete.tpl';
                        $this->arrForm['own_mail'] = $ownEmail;
                        $this->lfSendMail($this->arrForm);
                    } else {
                        $this->msg = '入力した情報の一致する会員が見つかりませんでした。<br />入力した内容をもう一度ご確認ください。';
                    }
                }
                break;
            default:
                break;
        }

        // ポップアップ用テンプレート設定
        if ($this->device_type == DEVICE_TYPE_PC) {
            $this->setTemplate($this->tpl_mainpage);
        }
    }

    /**
     * メールアドレス確認におけるパラメーター情報の初期化
     *
     * @param  SC_FormParam_Ex $objFormParam フォームパラメータークラス
     * @param  array $device_type  デバイスタイプ
     * @return void
     */
    public function lfInitParam(&$objFormParam) {
        $objFormParam->addParam('お名前(姓)', 'name01', STEXT_LEN, 'aKV', array('EXIST_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('お名前(名)', 'name02', STEXT_LEN, 'aKV', array('EXIST_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('メールアドレス', 'email', null, 'a', array('NO_SPTAB', 'EXIST_CHECK', 'EMAIL_CHECK', 'SPTAB_CHECK', 'EMAIL_CHAR_CHECK'));
        $objFormParam->addParam('お電話番号1', 'tel01', TEL_ITEM_LEN, 'n', array('EXIST_CHECK', 'SPTAB_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('お電話番号2', 'tel02', TEL_ITEM_LEN, 'n', array('EXIST_CHECK', 'SPTAB_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('お電話番号3', 'tel03', TEL_ITEM_LEN, 'n', array('EXIST_CHECK', 'SPTAB_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('年', 'year', 4, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'), '', false);
        $objFormParam->addParam('月', 'month', 2, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'), '', false);
        $objFormParam->addParam('日', 'day', 2, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'), '', false);
        return;
    }

    public function getMemberByInfo($arrForm) {
        $ret = '';

        $birth = $arrForm['year'] . '-';
        if ($arrForm['month'] < 10)
            $birth .= '0';
        $birth .= $arrForm['month'] . '-';
        if ($arrForm['day'] < 10)
            $birth .= '0';
        $birth .= $arrForm['day'];
        $birth .= ' 00:00:00';

        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $where = 'name01 = ? AND name02 = ? AND tel01 = ? AND tel02 = ? AND tel03 = ? AND birth = ?';
        $arrVal = array();
        $arrVal[] = $arrForm['name01'];
        $arrVal[] = $arrForm['name02'];
        $arrVal[] = $arrForm['tel01'];
        $arrVal[] = $arrForm['tel02'];
        $arrVal[] = $arrForm['tel03'];
        $arrVal[] = $birth;
        $arrCustomer = $objQuery->select('email', 'dtb_customer', $where, $arrVal);
        if (count($arrCustomer))
            $ret = $arrCustomer[0]['email'];

        return $ret;
    }

    /**
     * パスワード変更お知らせメールを送信する.
     *
     * @param  array  $CONF          店舗基本情報の配列
     * @param  string $email         送信先メールアドレス
     * @param  string $customer_name 送信先氏名
     * @param  string $new_password  変更後の新パスワード
     * @return void
     *
     * FIXME: メールテンプレート編集の方に足すのが望ましい
     */
    public function lfSendMail($arrForm) {
        $objDb = new SC_Helper_DB_Ex();
        $CONF = $objDb->sfGetBasisData();

        $mail_body = '※本メールは自動配信メールです。
　等幅フォント(MSゴシック12ポイント、Osaka-等幅など)で
　最適にご覧になれます。

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
　※本メールは、
　' . $CONF["shop_name"] . 'より、お問い合わせをされた方に
　お送りしています。
　もしお心当たりが無い場合は、このままこのメールを破棄してください。
　またその旨、 ' . $CONF["email02"] . ' まで
　ご連絡いただければ幸いです。
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

' . $arrForm["name01"] . ' ' . $arrForm["name02"] . '様

以下のリクエストを受付致しました。
';

        $toCustomerMail = $mail_body . $arrForm["name01"] . ' ' . $arrForm["name02"] . '様のメールアドレスは' . $arrForm["own_mail"] . 'でございます。';
        $toAdminMail = $mail_body . '確認次第ご連絡いたしますので、少々お待ちください。
■お名前　： ' . $arrForm["name01"] . ' ' . $arrForm["name02"] . '様
■メールアドレス（返信用）： ' . $arrForm["email"] . '
■電話番号： ' . $arrForm["tel01"] . '-' . $arrForm["tel02"] . '-' . $arrForm["tel03"] . '
■生年月日： ' . $arrForm["year"] . '年' . $arrForm["month"] . '月' . $arrForm["day"] . '日';

        $objHelperMail = new SC_Helper_Mail_Ex();
        $objHelperMail->setPage($this);
        $subject = $objHelperMail->sfMakeSubject('メールアドレスの再発行');

        // メール送信オブジェクトによる送信処理
        $objMail = new SC_SendMail_Ex();
        $objMail->setItem(
                '', //宛先
                $subject,
                $toCustomerMail,
                $CONF['email03'], //配送元アドレス
                $CONF['shop_name'], // 配送元名
                $CONF['email03'], // reply to
                $CONF['email04'], //return_path
                $CONF['email04'] // errors_to
        );
        $objMail->setTo($arrForm['email'], $arrForm['name01'] . ' ' . $arrForm['name02'] . ' 様');
        $objMail->sendMail();

        $objMail = new SC_SendMail_Ex();
        $objMail->setItem(
                '', //宛先
                $subject,
                $toAdminMail,
                $arrForm['email'], //配送元アドレス
                $arrForm['name01'] . ' ' . $arrForm['name02'] // 配送元名
        );
        $objMail->setTo($CONF['email03'], $CONF['shop_name']);
        $objMail->sendMail();
        return;
    }

}
