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

/**
 * 会員情報の登録・編集・検索ヘルパークラス.
 *
 *
 * @package Helper
 * @author Hirokazu Fukuda
 * @version $Id$
 */
class SC_Helper_Customer {

    /**
     * 会員情報の登録・編集処理を行う.
     *
     * @param array $arrData     登録するデータの配列（SC_FormParamのgetDbArrayの戻り値）
     * @param array $customer_id nullの場合はinsert, 存在する場合はupdate
     * @access public
     * @return integer 登録編集したユーザーのcustomer_id
     */
    public function sfEditCustomerData($arrParams, $customer_id = null) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $objQuery->begin();

        $old_version_flag = false;

        $arrData = $objQuery->extractOnlyColsOf('dtb_customer', $arrParams);
        $arrData['update_date'] = 'CURRENT_TIMESTAMP';    // 更新日
        // salt値の生成(insert時)または取得(update時)。
        if (is_numeric($customer_id)) {
            $salt = $objQuery->get('salt', 'dtb_customer', 'customer_id = ? ', array($customer_id));

            // 旧バージョン(2.11未満)からの移行を考慮
            if (strlen($salt) === 0) {
                $old_version_flag = true;
            }
        } else {
            $salt = SC_Utils_Ex::sfGetRandomString(10);
            $arrData['salt'] = $salt;
        }
        //-- パスワードの更新がある場合は暗号化
        if ($arrData['password'] == DEFAULT_PASSWORD or $arrData['password'] == '') {
            //更新しない
            unset($arrData['password']);
        } else {
            // 旧バージョン(2.11未満)からの移行を考慮
            if ($old_version_flag) {
                $is_password_updated = true;
                $salt = SC_Utils_Ex::sfGetRandomString(10);
                $arrData['salt'] = $salt;
            }

            $arrData['password'] = SC_Utils_Ex::sfGetHashString($arrData['password'], $salt);
        }
        //-- 秘密の質問の更新がある場合は暗号化
        if ($arrData['reminder_answer'] == DEFAULT_PASSWORD or $arrData['reminder_answer'] == '') {
            //更新しない
            unset($arrData['reminder_answer']);

            // 旧バージョン(2.11未満)からの移行を考慮
            if ($old_version_flag && $is_password_updated) {
                // パスワードが更新される場合は、平文になっている秘密の質問を暗号化する
                $reminder_answer = $objQuery->get('reminder_answer', 'dtb_customer', 'customer_id = ? ', array($customer_id));
                $arrData['reminder_answer'] = SC_Utils_Ex::sfGetHashString($reminder_answer, $salt);
            }
        } else {
            // 旧バージョン(2.11未満)からの移行を考慮
            if ($old_version_flag && !$is_password_updated) {
                // パスワードが更新されない場合は、平文のままにする
                unset($arrData['salt']);
            } else {
                $arrData['reminder_answer'] = SC_Utils_Ex::sfGetHashString($arrData['reminder_answer'], $salt);
            }
        }

        //デフォルト国IDを追加
        if (FORM_COUNTRY_ENABLE == false) {
            $arrData['country_id'] = DEFAULT_COUNTRY_ID;
        }

        unset($arrData['save_image']);
        unset($arrData['temp_image']);
        //-- 編集登録実行
        if (is_numeric($customer_id)) {
            // 編集
            $objQuery->update('dtb_customer', $arrData, 'customer_id = ? ', array($customer_id));
        } else {
            // 新規登録
            // 会員ID
            $customer_id = $objQuery->nextVal('dtb_customer_customer_id');
            $arrData['customer_id'] = $customer_id;
            // 作成日
            if (is_null($arrData['create_date'])) {
                $arrData['create_date'] = 'CURRENT_TIMESTAMP';
            }
            $objQuery->insert('dtb_customer', $arrData);
        }

        if (isset($arrParams['working_company_name'])) {
            $objQuery->delete('dtb_customer_career', 'customer_id = ?', array($customer_id));
            $arrCareer = array();
            $arrCareer['customer_id'] = $customer_id;
            foreach ($arrParams['working_company_name'] as $index => $working_company_name) {
                if ($working_company_name != '') {
                    $start_month = $arrParams['start_month'][$index];
                    if ($start_month < 10)
                        $start_month = '0' . $start_month;
                    $end_month = $arrParams['end_month'][$index];
                    if ($end_month < 10)
                        $end_month = '0' . $end_month;

                    $arrCareer['working_company_name'] = $working_company_name;
                    $arrCareer['start_date'] = $arrParams['start_year'][$index] . '-' . $start_month . '-01';
                    $arrCareer['end_date'] = $arrParams['end_year'][$index] . '-' . $end_month . '-01';
                    $arrCareer['company_addr'] = $arrParams['company_addr'][$index];
                    $arrCareer['working_member_num'] = $arrParams['working_member_num'][$index];
                    $arrCareer['working_status'] = $arrParams['working_status'][$index];
                    $arrCareer['working_position'] = $arrParams['working_position'][$index];
                    $arrCareer['working_type'] = $arrParams['working_type'][$index];
                    $arrCareer['working_experience'] = $arrParams['working_experience'][$index];
                    $arrCareer['job_description'] = $arrParams['job_description'][$index];
                    $arrCareer['working_year'] = SC_Helper_Customer_Ex::sfCalcWorkingYear($arrParams['start_year'][$index], $arrParams['start_month'][$index], $arrParams['end_year'][$index], $arrParams['end_month'][$index]);
                    $objQuery->insert('dtb_customer_career', $arrCareer);
                }
            }
        }

        $objQuery->commit();

        return $customer_id;
    }

    public function sfCalcWorkingYear($sy, $sm, $ey, $em) {
        $diff = '';
        if ($sy > 0 && $sm > 0 && $ey > 0 && $em > 0 && ($sy < $ey || $sy == $ey && $sm < $em)) {
            if ($sm > $em) {
                $ey = $ey - 1;
                $em = $em + 12;
            }
            $diff = round(($ey - $sy) + ($em - $sm) / 12, 1);
        }
        return $diff;
    }

    /**
     * 注文番号、利用ポイント、加算ポイントから最終ポイントを取得する.
     *
     * @param  integer $order_id  注文番号
     * @param  integer $use_point 利用ポイント
     * @param  integer $add_point 加算ポイント
     * @return array   最終ポイントの配列
     */
    public function sfGetCustomerPoint($order_id, $use_point, $add_point) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();

        $arrRet = $objQuery->select('customer_id', 'dtb_order', 'order_id = ?', array($order_id));
        $customer_id = $arrRet[0]['customer_id'];
        if ($customer_id != '' && $customer_id >= 1) {
            if (USE_POINT !== false) {
                $arrRet = $objQuery->select('point', 'dtb_customer', 'customer_id = ?', array($customer_id));
                $point = $arrRet[0]['point'];
                $total_point = $arrRet[0]['point'] - $use_point + $add_point;
            } else {
                $total_point = 0;
                $point = 0;
            }
        } else {
            $total_point = '';
            $point = '';
        }

        return array($point, $total_point);
    }

    /**
     * emailアドレスから、登録済み会員や退会済み会員をチェックする
     *
     * XXX SC_CheckError からしか呼び出されず, 本クラスの中で SC_CheckError を呼び出している
     *
     * @param  string  $email メールアドレス
     * @return integer 0:登録可能     1:登録済み   2:再登録制限期間内削除ユーザー  3:自分のアドレス
     */
    public function sfCheckRegisterUserFromEmail($email) {
        $objCustomer = new SC_Customer_Ex();
        $objQuery = & SC_Query_Ex::getSingletonInstance();

        // ログインしている場合、すでに登録している自分のemailの場合
        if ($objCustomer->isLoginSuccess(true) && SC_Helper_Customer_Ex::sfCustomerEmailDuplicationCheck($objCustomer->getValue('customer_id'), $email)) {
            // 自分のアドレス
            return 3;
        }

        $arrRet = $objQuery->select('email, update_date, del_flg', 'dtb_customer', 'email = ? OR email_mobile = ? ORDER BY del_flg', array($email, $email));

        if (count($arrRet) > 0) {
            // 会員である場合
            if ($arrRet[0]['del_flg'] != '1') {
                // 登録済み
                return 1;
            } else {
                // 退会した会員である場合
                $leave_time = SC_Utils_Ex::sfDBDatetoTime($arrRet[0]['update_date']);
                $now_time = time();
                $pass_time = $now_time - $leave_time;
                // 退会から何時間-経過しているか判定する。
                $limit_time = ENTRY_LIMIT_HOUR * 3600;
                if ($pass_time < $limit_time) {
                    // 再登録制限期間内削除ユーザー
                    return 2;
                }
            }
        }

        // 登録可能
        return 0;
    }

    /**
     * ログイン時メールアドレス重複チェック.
     *
     * 会員の保持する email, mobile_email が, 引数 $email と一致するかチェックする
     *
     * @param  integer $customer_id チェック対象会員の会員ID
     * @param  string  $email       チェック対象のメールアドレス
     * @return boolean メールアドレスが重複する場合 true
     */
    public function sfCustomerEmailDuplicationCheck($customer_id, $email) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();

        $arrResults = $objQuery->getRow('email, email_mobile', 'dtb_customer', 'customer_id = ?', array($customer_id));
        $return = strlen($arrResults['email']) >= 1 && $email === $arrResults['email'] || strlen($arrResults['email_mobile']) >= 1 && $email === $arrResults['email_mobile']
        ;

        return $return;
    }

    /**
     * customer_idから会員情報を取得する
     *
     * @param mixed $customer_id
     * @param boolean $mask_flg
     * @access public
     * @return array 会員情報の配列を返す
     */
    public function sfGetCustomerData($customer_id, $mask_flg = true) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();

        // 会員情報DB取得
        $ret = $objQuery->select('*', 'dtb_customer', 'customer_id=?', array($customer_id));
        $objQuery->setOrder('start_date ASC');
        $career = $objQuery->select('start_date, end_date, working_company_name, company_addr, working_member_num, working_status, working_position, working_type, working_experience, job_description, working_year', 'dtb_customer_career', 'customer_id=?', array($customer_id));
        $arrForm = $arrErr = array_merge($ret[0], (array) SC_Utils_Ex::sfSwapArray($career));


        // 確認項目に複製
        $arrForm['email02'] = $arrForm['email'];
        $arrForm['email_mobile02'] = $arrForm['email_mobile'];

        // 誕生日を年月日に分ける
        if (isset($arrForm['birth'])) {
            $birth = explode(' ', $arrForm['birth']);
            list($arrForm['year'], $arrForm['month'], $arrForm['day']) = explode('-', $birth[0]);
        }
        // 卒業日を年月日に分ける
        if (isset($arrForm['graduation_date'])) {
            $graduation_date = explode(' ', $arrForm['graduation_date']);
            list($arrForm['graduation_year'], $arrForm['graduation_month'], $arrForm['graduation_day']) = explode('-', $graduation_date[0]);
        }
        foreach ($arrForm['start_date'] as $i => $date) {
            if (isset($date))
                list($arrForm['start_year'][$i], $arrForm['start_month'][$i], $a) = explode('-', $date);
            if (isset($arrForm['end_date'][$i]))
                list($arrForm['end_year'][$i], $arrForm['end_month'][$i], $b) = explode('-', $arrForm['end_date'][$i]);
        }

        $arrForm['desired_work'] = explode(' ', $arrForm['desired_work']);
        $arrForm['desired_position'] = explode(' ', $arrForm['desired_position']);
        $arrForm['desired_region'] = explode(' ', $arrForm['desired_region']);

        if ($mask_flg) {
            $arrForm['password'] = DEFAULT_PASSWORD;
            $arrForm['password02'] = DEFAULT_PASSWORD;
            $arrForm['reminder_answer'] = DEFAULT_PASSWORD;
        }

        return $arrForm;
    }

    /**
     * 会員ID指定またはwhere条件指定での会員情報取得(単一行データ)
     *
     * TODO: sfGetCustomerDataと統合したい
     *
     * @param integer $customer_id 会員ID (指定無しでも構わないが、Where条件を入れる事)
     * @param string  $add_where   追加WHERE条件
     * @param string[]   $arrAddVal   追加WHEREパラメーター
     * @access public
     * @return array 対象会員データ
     */
    public function sfGetCustomerDataFromId($customer_id, $add_where = '', $arrAddVal = array()) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();

        if ($add_where == '') {
            $where = 'customer_id = ?';
            $arrData = $objQuery->getRow('*', 'dtb_customer', $where, array($customer_id));
        } else {
            $where = $add_where;
            if (SC_Utils_Ex::sfIsInt($customer_id)) {
                $where .= ' AND customer_id = ?';
                $arrAddVal[] = $customer_id;
            }
            $arrData = $objQuery->getRow('*', 'dtb_customer', $where, $arrAddVal);
        }

        return $arrData;
    }

    /**
     * 重複しない会員登録キーを発行する。
     *
     * @access public
     * @return string 会員登録キーの文字列
     */
    public function sfGetUniqSecretKey() {
        $objQuery = & SC_Query_Ex::getSingletonInstance();

        do {
            $uniqid = SC_Utils_Ex::sfGetUniqRandomId('r');
            $exists = $objQuery->exists('dtb_customer', 'secret_key = ?', array($uniqid));
        } while ($exists);

        return $uniqid;
    }

    /**
     * 会員登録キーから会員IDを取得する.
     *
     * @param string  $uniqid       会員登録キー
     * @param boolean $check_status 本会員のみを対象とするか
     * @access public
     * @return integer 会員ID
     */
    public function sfGetCustomerId($uniqid, $check_status = false) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();

        $where = 'secret_key = ?';

        if ($check_status) {
            $where .= ' AND status = 1 AND del_flg = 0';
        }

        return $objQuery->get('customer_id', 'dtb_customer', $where, array($uniqid));
    }

    /**
     * 会員登録キーから会員の履歴書情報を取得する.
     *
    　* @param integer $customer_id 会員ID
     * @access public
     * @return void
     */
    public function sfGetCVInfo($customer_id) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();

        $col = "cv, cv_name";
        $from = "dtb_customer";
        $where = 'customer_id = ?';
        $objQuery = new SC_Query_Ex();
        $arrRet = $objQuery->select($col, $from, $where, array($customer_id));

        if (!empty($arrRet[0]["cv"])) {
            return $arrRet[0];
        }
        return false;
    }

    public function sfGetResumeInfo($customer_id) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();

        $col = "resume, resume_name";
        $from = "dtb_customer";
        $where = 'customer_id = ?';
        $objQuery = new SC_Query_Ex();
        $arrRet = $objQuery->select($col, $from, $where, array($customer_id));

        if (!empty($arrRet[0]["resume"])) {
            return $arrRet[0];
        }
        return false;
    }

    /**
     * 会員登録時フォーム初期化
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @param boolean      $isAdmin      true:管理者画面 false:会員向け
     * @access public
     * @return void
     */
    public function sfCustomerEntryParam(&$objFormParam, $isAdmin = false) {
        SC_Helper_Customer_Ex::sfCustomerCommonParam($objFormParam, '', $isAdmin);
        if ($isAdmin) {
            SC_Helper_Customer_Ex::sfCustomerRegisterParam($objFormParam, $isAdmin);
            $objFormParam->addParam('Mã thành viên', 'customer_id', INT_LEN, 'n', array('NUM_CHECK'));
            $objFormParam->addParam('Địa chỉ Email trên điện thoại', 'email_mobile', null, 'a', array('NO_SPTAB', 'EMAIL_CHECK', 'SPTAB_CHECK', 'EMAIL_CHAR_CHECK', 'MOBILE_EMAIL_CHECK'));
            $objFormParam->addParam('Trạng thái thành viên', 'status', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam('Điểm tích lũy', 'note', LTEXT_LEN, 'KVa', array('MAX_LENGTH_CHECK'));
            $objFormParam->addParam('Ghi chú', 'point', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK'), 0);
        }

        if (SC_Display_Ex::detectDevice() == DEVICE_TYPE_MOBILE) {
            // 登録確認画面の「戻る」ボタンのためのパラメーター
            $objFormParam->addParam('Quay lại', 'return', '', '', array(), '', false);
        }
    }

    /**
     * 会員情報変更フォーム初期化
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @access public
     * @return void
     */
    public function sfCustomerMypageParam(&$objFormParam) {
//        SC_Helper_Customer_Ex::sfCustomerCommonParam($objFormParam, '', false, true);
        SC_Helper_Customer_Ex::sfCustomerRegisterParam($objFormParam, false, true);
        if (SC_Display_Ex::detectDevice() !== DEVICE_TYPE_MOBILE) {
            $objFormParam->addParam('Địa chỉ Email trên điện thoại', 'email_mobile', null, 'a', array('NO_SPTAB', 'EMAIL_CHECK', 'SPTAB_CHECK', 'EMAIL_CHAR_CHECK', 'MOBILE_EMAIL_CHECK'));
            $objFormParam->addParam('Địa chỉ Email trên điện thoại (Xác nhận)', 'email_mobile02', null, 'a', array('NO_SPTAB', 'EMAIL_CHECK', 'SPTAB_CHECK', 'EMAIL_CHAR_CHECK', 'MOBILE_EMAIL_CHECK'), '', false);
        } else {
            $objFormParam->addParam('Địa chỉ Email trên điện thoại', 'email_mobile', null, 'a', array('EXIST_CHECK', 'NO_SPTAB', 'EMAIL_CHECK', 'SPTAB_CHECK', 'EMAIL_CHAR_CHECK', 'MOBILE_EMAIL_CHECK'));
            $objFormParam->addParam('Địa chỉ Email', 'email', null, 'a', array('NO_SPTAB', 'EMAIL_CHECK', 'SPTAB_CHECK', 'EMAIL_CHAR_CHECK'));
        }
    }

    /**
     * 会員・顧客・お届け先共通
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @param string       $prefix       キー名にprefixを付ける場合に指定
     * @access public
     * @return void
     */
    public function sfCustomerCommonParam(&$objFormParam, $prefix = '', $isAdmin = false, $is_mypage = false) {
        $objFormParam->addParam('Họ', $prefix . 'name01', STEXT_LEN, 'aKV', array('EXIST_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Tên', $prefix . 'name02', STEXT_LEN, 'aKV', array('EXIST_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Tên công ty', $prefix . 'company_name', STEXT_LEN, 'aKV', array('MAX_LENGTH_CHECK', 'SPTAB_CHECK'));
        $objFormParam->addParam('Họ', $prefix . 'kana01', STEXT_LEN, 'CKV', array('NO_SPTAB', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK', 'KANA_CHECK'));
        $objFormParam->addParam('Tên', $prefix . 'kana02', STEXT_LEN, 'CKV', array('NO_SPTAB', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK', 'KANA_CHECK'));

        $objFormParam->addParam('Giới tính', $prefix . 'sex', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Năm', $prefix . 'year', 4, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'), '', false);
        $objFormParam->addParam('Tháng', $prefix . 'month', 2, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'), '', false);
        $objFormParam->addParam('Ngày', $prefix . 'day', 2, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'), '', false);
//        $objFormParam->addParam('電話番号', $prefix . 'tel', STEXT_LEN, 'aKV', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('ô 1 số điện thoại', $prefix . 'tel01', TEL_ITEM_LEN, 'n', array('EXIST_CHECK', 'SPTAB_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('ô 2 số điện thoại', $prefix . 'tel02', TEL_ITEM_LEN, 'n', array('EXIST_CHECK', 'SPTAB_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('ô 3 số điện thoại', $prefix . 'tel03', TEL_ITEM_LEN, 'n', array('EXIST_CHECK', 'SPTAB_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        if (SC_Display_Ex::detectDevice() !== DEVICE_TYPE_MOBILE) {
            $objFormParam->addParam('Địa chỉ email', $prefix . 'email', null, 'a', array('NO_SPTAB', 'EXIST_CHECK', 'EMAIL_CHECK', 'SPTAB_CHECK', 'EMAIL_CHAR_CHECK'));
            $objFormParam->addParam('Mât khẩu (Xác nhận)', $prefix . 'password02', PASSWORD_MAX_LEN, '', array('EXIST_CHECK', 'SPTAB_CHECK', 'GRAPH_CHECK'), '', false);
            if (!$isAdmin) {
                $objFormParam->addParam('Địa chỉ email (Xác nhận)', $prefix . 'email02', null, 'a', array('NO_SPTAB', 'EXIST_CHECK', 'EMAIL_CHECK', 'SPTAB_CHECK', 'EMAIL_CHAR_CHECK'), '', false);
            }
        } else {
            if (!$is_mypage) {
                $objFormParam->addParam('Địa chỉ email', $prefix . 'email', null, 'a', array('EXIST_CHECK', 'EMAIL_CHECK', 'NO_SPTAB', 'EMAIL_CHAR_CHECK', 'MOBILE_EMAIL_CHECK'));
            }
        }
        $objFormParam->addParam('Mật khẩu', $prefix . 'password', PASSWORD_MAX_LEN, '', array('EXIST_CHECK', 'SPTAB_CHECK', 'GRAPH_CHECK'));
        $objFormParam->addParam('Tự động gửi email', $prefix . 'mailmaga_flg', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Câu trả lời xác nhận mật khẩu', $prefix . 'reminder_answer', STEXT_LEN, '', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Câu hỏi xác nhận mật khẩu', $prefix . 'reminder', STEXT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
    }

    /**
     * 会員登録共通
     *
     * @param  SC_FormParam $objFormParam SC_FormParam インスタンス
     * @param  boolean      $isAdmin      true:管理者画面 false:会員向け
     * @param  boolean      $is_mypage    マイページの場合 true
     * @param  string       $prefix       キー名にprefixを付ける場合に指定
     * @return void
     */
    public function sfCustomerRegisterParam(&$objFormParam, $isAdmin = false, $is_mypage = false, $prefix = '') {
        if (FORM_COUNTRY_ENABLE === false) {
            $objFormParam->addParam('ô 1 mã bưu chính', $prefix . 'zip01', ZIP01_LEN, 'n', array('SPTAB_CHECK', 'NUM_CHECK', 'NUM_COUNT_CHECK'));
            $objFormParam->addParam('ô 2 mã bưu chính', $prefix . 'zip02', ZIP02_LEN, 'n', array('SPTAB_CHECK', 'NUM_CHECK', 'NUM_COUNT_CHECK'));
            $objFormParam->addParam('Quốc gia', $prefix . 'country_id', INT_LEN, 'n', array('NUM_CHECK'));
            $objFormParam->addParam('Tỉnh/Thành phố', $prefix . 'pref', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK'));
        } else {
            $objFormParam->addParam('ô 1 mã bưu chính', $prefix . 'zip01', ZIP01_LEN, 'n', array('SPTAB_CHECK', 'NUM_CHECK', 'NUM_COUNT_CHECK'));
            $objFormParam->addParam('ô 2 mã bưu chính', $prefix . 'zip02', ZIP02_LEN, 'n', array('SPTAB_CHECK', 'NUM_CHECK', 'NUM_COUNT_CHECK'));
            $objFormParam->addParam('Quốc gia', $prefix . 'country_id', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK'));
            $objFormParam->addParam('ZIPCODE', $prefix . 'zipcode', STEXT_LEN, 'n', array('NO_SPTAB', 'SPTAB_CHECK', 'GRAPH_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam('Tỉnh/Thành phố', $prefix . 'pref', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK'));
        }
        $objFormParam->addParam('Quận/Huyện', $prefix . 'addr01', MTEXT_LEN, 'aKV', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Địa chỉ liên lạc', $prefix . 'addr02', MTEXT_LEN, 'aKV', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('ô 1 số FAX', $prefix . 'fax01', TEL_ITEM_LEN, 'n', array('SPTAB_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('ô 2 số FAX', $prefix . 'fax02', TEL_ITEM_LEN, 'n', array('SPTAB_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('ô 3 số FAX', $prefix . 'fax03', TEL_ITEM_LEN, 'n', array('SPTAB_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Nghề nghiệp', $prefix . 'job', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));

        $objFormParam->addParam('save_image', 'save_image', '', '', array());
        $objFormParam->addParam('temp_image', 'temp_image', '', '', array());
        $objFormParam->addParam('Tình trạng hôn nhân', $prefix . 'marital_status', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Nơi ở hiện tại', $prefix . 'current_address', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Tỉnh/Thành phố', $prefix . 'pref_by_text', STEXT_LEN, 'aKV', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Trình độ học vấn', $prefix . 'education', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Tên trường học', $prefix . 'school_name', STEXT_LEN, 'aKV', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Chuyên ngành', $prefix . 'major', STEXT_LEN, 'aKV', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));

        $objFormParam->addParam('Năm tốt nghiệp', $prefix . 'graduation_year', 4, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Tháng tốt nghiệp', $prefix . 'graduation_month', 2, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Ngày tốt nghiệp', $prefix . 'graduation_day', 2, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Ngành nghề mong muốn', $prefix . 'desired_work', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        //$objFormParam->addParam('Vị trí mong muốn', $prefix . 'desired_position', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Mức lương hiện tại', $prefix . 'current_salary', PRICE_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK', 'ZERO_START'));
        $objFormParam->addParam('Mức lương mong muốn', $prefix . 'desired_salary', PRICE_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK', 'ZERO_START'));
        $objFormParam->addParam('Nơi làm việc mong muốn', $prefix . 'desired_region', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('JLPT', $prefix . 'jp_level', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Chứng chỉ tiếng Nhật khác', $prefix . 'jp_other', STEXT_LEN, 'aKV', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('TOEIC', $prefix . 'toeic', STEXT_LEN, '', array('MAX_LENGTH_CHECK', 'NUM_POINT_CHECK'));
        $objFormParam->addParam('IELTS', $prefix . 'ielts', STEXT_LEN, '', array('MAX_LENGTH_CHECK', 'NUM_POINT_CHECK'));
        $objFormParam->addParam('Chứng chỉ tiếng anh khác', $prefix . 'eng_other', STEXT_LEN, 'aKV', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Ngoại ngữ khác', $prefix . 'other_language', LLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Chứng chỉ', $prefix . 'qualification', LLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Kỹ năng', $prefix . 'skill', LLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('PR bản thân', $prefix . 'self_pr', LLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Kinh nghiệm làm việc', $prefix . 'work_experience', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Năm bắt đầu', $prefix . 'start_year', 4, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Tháng bắt đầu', $prefix . 'start_month', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Năm kết thúc', $prefix . 'end_year', 4, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Tháng kết thúc', $prefix . 'end_month', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Tên công ty', $prefix . 'working_company_name', STEXT_LEN, 'aKV', array('MAX_LENGTH_CHECK', 'SPTAB_CHECK'));
        $objFormParam->addParam('Địa chỉ', $prefix . 'company_addr', MTEXT_LEN, 'aKV', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Số lượng nhân viên', $prefix . 'working_member_num', MTEXT_LEN, 'aKV', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Hình thức hợp đồng', $prefix . 'working_status', MTEXT_LEN, 'aKV', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Bộ phận/Chức vụ', $prefix . 'working_position', MTEXT_LEN, 'aKV', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Nghiệp vụ', $prefix . 'working_type', MTEXT_LEN, 'aKV', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Công việc đảm nhận', $prefix . 'working_experience', MTEXT_LEN, 'aKV', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Khái quát công việc', $prefix . 'job_description', LLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Số năm', $prefix . 'working_year');
    }

    public function sfCustomerCvParam(&$objFormParam) {
        $objFormParam->addParam('Tên tệp tải xuống', 'cv', MTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Tên tệp tải xuống', 'cv_name');
        $objFormParam->addParam('temp_down_file', 'temp_down_file', '', '', array());
        $objFormParam->addParam('save_down_file', 'save_down_file', '', '', array());
    }

    public function sfCustomerResumeParam(&$objFormParam) {
        $objFormParam->addParam('Tên tệp lịch sử công việc tải xuống', 'resume', MTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('Tên tệp lịch sử công việc tải xuống', 'resume_name');
        $objFormParam->addParam('temp_resume_file', 'temp_resume_file', '', '', array());
        $objFormParam->addParam('save_resume_file', 'save_resume_file', '', '', array());
    }

    /**
     * 会員登録エラーチェック
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @access public
     * @return array エラーの配列
     */
    public function sfCustomerEntryErrorCheck(&$objFormParam) {
        $objErr = SC_Helper_Customer_Ex::sfCustomerCommonErrorCheck($objFormParam);
        $objErr = SC_Helper_Customer_Ex::sfCustomerRegisterErrorCheck($objErr);

        /*
         * sfCustomerRegisterErrorCheck() では, ログイン中の場合は重複チェック
         * されないので, 再度チェックを行う
         */
        $objCustomer = new SC_Customer_Ex();
        if ($objCustomer->isLoginSuccess(true) && SC_Helper_Customer_Ex::sfCustomerEmailDuplicationCheck($objCustomer->getValue('customer_id'), $objFormParam->getValue('email'))) {
            $objErr->arrErr['email'] .= '※ Email đã được sử dụng để đăng ký trước đó.<br />';
        }
        if ($objCustomer->isLoginSuccess(true) && SC_Helper_Customer_Ex::sfCustomerEmailDuplicationCheck($objCustomer->getValue('customer_id'), $objFormParam->getValue('email_mobile'))) {
            $objErr->arrErr['email_mobile'] .= '※ Email đã được sử dụng để đăng ký trước đó.<br />';
        }

        return $objErr->arrErr;
    }

    /**
     * 会員情報変更エラーチェック
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @param boolean      $isAdmin      管理画面チェック時:true
     * @access public
     * @return array エラーの配列
     */
    public function sfCustomerMypageErrorCheck(&$objFormParam, $isAdmin = false) {
        $objFormParam->toLower('email_mobile');
        $objFormParam->toLower('email_mobile02');

        $objErr = SC_Helper_Customer_Ex::sfCustomerCommonErrorCheck($objFormParam);
        $objErr = SC_Helper_Customer_Ex::sfCustomerRegisterErrorCheck($objErr, $isAdmin);

        if (isset($objErr->arrErr['password']) && $objFormParam->getValue('password') == DEFAULT_PASSWORD) {
            unset($objErr->arrErr['password']);
            unset($objErr->arrErr['password02']);
        }
        if (isset($objErr->arrErr['reminder_answer']) && $objFormParam->getValue('reminder_answer') == DEFAULT_PASSWORD) {
            unset($objErr->arrErr['reminder_answer']);
        }

        $arrValues = $objFormParam->getHashArray();
        $arrErr = array();

        if ($arrValues['work_experience'] == 1) {
            $objError1 = new SC_CheckError_Ex(array(
                'start_year' => $arrValues['start_year'][0],
                'start_month' => $arrValues['start_month'][0],
                'end_year' => $arrValues['end_year'][0],
                'end_month' => $arrValues['end_month'][0],
                'working_company_name' => $arrValues['working_company_name'][0],
                'company_addr' => $arrValues['company_addr'][0],
                'working_member_num' => $arrValues['working_member_num'][0],
                'working_status' => $arrValues['working_status'][0],
                'working_position' => $arrValues['working_position'][0],
                'working_type' => $arrValues['working_type'][0],
                'working_experience' => $arrValues['working_experience'][0],
                'job_description' => $arrValues['job_description'][0]
            ));
            $objError1->doFunc(array('Năm bắt đầu', 'start_year'), array('EXIST_CHECK'));
            $objError1->doFunc(array('Tháng bắt đầu', 'start_month'), array('EXIST_CHECK'));
            $objError1->doFunc(array('Năm kết thúc', 'end_year'), array('EXIST_CHECK'));
            $objError1->doFunc(array('Tháng kết thúc', 'end_month'), array('EXIST_CHECK'));
            $objError1->doFunc(array('Tên công ty', 'working_company_name'), array('EXIST_CHECK'));
            $objError1->doFunc(array('Địa chỉ', 'company_addr'), array('EXIST_CHECK'));
            $objError1->doFunc(array('Số lượng nhân viên', 'working_member_num'), array('EXIST_CHECK'));
            $objError1->doFunc(array('Hình thức hợp đồng', 'working_status'), array('EXIST_CHECK'));
            $objError1->doFunc(array('Bộ phận/Chức vụ', 'working_position'), array('EXIST_CHECK'));
            $objError1->doFunc(array('Nghiệp vụ', 'working_type'), array('EXIST_CHECK'));
            $objError1->doFunc(array('Công việc đảm nhận', 'working_experience'), array('EXIST_CHECK'));
            $objError1->doFunc(array('Khái quát công việc', 'job_description'), array('EXIST_CHECK'));
            if (count($objError1->arrErr) > 0) {
                $arrErr['start_year'][0] = $objError1->arrErr['start_year'];
                $arrErr['start_month'][0] = $objError1->arrErr['start_month'];
                $arrErr['end_year'][0] = $objError1->arrErr['end_year'];
                $arrErr['end_month'][0] = $objError1->arrErr['end_month'];
                $arrErr['working_company_name'][0] = $objError1->arrErr['working_company_name'];
                $arrErr['company_addr'][0] = $objError1->arrErr['company_addr'];
                $arrErr['working_member_num'][0] = $objError1->arrErr['working_member_num'];
                $arrErr['working_status'][0] = $objError1->arrErr['working_status'];
                $arrErr['working_position'][0] = $objError1->arrErr['working_position'];
                $arrErr['working_type'][0] = $objError1->arrErr['working_type'];
                $arrErr['working_experience'][0] = $objError1->arrErr['working_experience'];
                $arrErr['job_description'][0] = $objError1->arrErr['job_description'];
            }
        }

        foreach ($arrValues['start_year'] as $key_index => $start_year) {
            $start_month = $arrValues['start_month'][$key_index];
            $end_year = $arrValues['end_year'][$key_index];
            $end_month = $arrValues['end_month'][$key_index];

            $objError = new SC_CheckError_Ex(array('start_year' => $start_year, 'start_month' => $start_month, 'end_year' => $end_year, 'end_month' => $end_month));
            $objError->doFunc(array('Năm bắt đầu', 'start_year', 'start_month'), array('CHECK_DATE3'));
            $objError->doFunc(array('Năm kết thúc', 'end_year', 'end_month'), array('CHECK_DATE3'));
            $objError->doFunc(array('Ngày vào công ty', 'Ngày thôi việc', 'start_year', 'start_month', 'end_year', 'end_month'), array('CHECK_SET_TERM3'));
            if (count($objError->arrErr) > 0) {
                if (!isset($arrErr['start_year'][$key_index]))
                    $arrErr['start_year'][$key_index] = $objError->arrErr['start_year'];
                if (!isset($arrErr['end_year'][$key_index]))
                    $arrErr['end_year'][$key_index] = $objError->arrErr['end_year'];
            }
        }
        $objErr->arrErr = array_merge($objErr->arrErr, $arrErr);

        return $objErr->arrErr;
    }

    /**
     * 会員エラーチェック共通
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @param string       $prefix       キー名にprefixを付ける場合に指定
     * @access public
     * @return SC_CheckError_Ex エラー情報の配列
     */
    public function sfCustomerCommonErrorCheck(&$objFormParam, $prefix = '') {
        $objFormParam->convParam();
        $objFormParam->toLower($prefix . 'email');
        $objFormParam->toLower($prefix . 'email02');
        $arrParams = $objFormParam->getHashArray();

        // 入力データを渡す。
        $objErr = new SC_CheckError_Ex($arrParams);
        $objErr->arrErr = $objFormParam->checkError();

        $objErr->doFunc(array('Số điện thoại', $prefix . 'tel01', $prefix . 'tel02', $prefix . 'tel03'), array('TEL_CHECK'));
        $objErr->doFunc(array('Số FAX', $prefix . 'fax01', $prefix . 'fax02', $prefix . 'fax03'), array('TEL_CHECK'));
        $objErr->doFunc(array('Mã bưu chính', $prefix . 'zip01', $prefix . 'zip02'), array('ALL_EXIST_CHECK'));
        if ($arrParams['current_address'] == 1)
            $objErr->doFunc(array('Mã bưu chính', $prefix . 'zip01', $prefix . 'zip02'), array('EXIST_CHECK'));

        return $objErr;
    }

    /**
     * 会員登録編集共通の相関チェック
     *
     * @param  SC_CheckError $objErr  SC_CheckError インスタンス
     * @param  boolean       $isAdmin 管理画面チェック時:true
     * @return SC_CheckError $objErr エラー情報
     */
    public function sfCustomerRegisterErrorCheck(&$objErr, $isAdmin = false) {
        $objErr->doFunc(array('Ngày sinh', 'year', 'month', 'day'), array('CHECK_BIRTHDAY'));
        $objErr->doFunc(array('Mật khẩu', 'password', PASSWORD_MIN_LEN, PASSWORD_MAX_LEN), array('NUM_RANGE_CHECK'));

        if (SC_Display_Ex::detectDevice() !== DEVICE_TYPE_MOBILE) {
            if (!$isAdmin) {
                $objErr->doFunc(array('Địa chỉ email', 'Địa chỉ email (xác nhận)', 'email', 'email02'), array('EQUAL_CHECK'));
            }
            $objErr->doFunc(array('Mật khẩu', 'Mật khẩu (xác nhận)', 'password', 'password02'), array('EQUAL_CHECK'));
        }

        if (!$isAdmin) {
            // 現会員の判定 → 現会員もしくは仮登録中は、メアド一意が前提になってるので同じメアドで登録不可
            $objErr->doFunc(array('Địa chỉ Email', 'email'), array('CHECK_REGIST_CUSTOMER_EMAIL'));
            $objErr->doFunc(array('Địa chỉ Email trên điện thoại', 'email_mobile'), array('CHECK_REGIST_CUSTOMER_EMAIL', 'MOBILE_EMAIL_CHECK'));
        }

        if (!isset($objErr->arrErr['jp_level']) && isset($objErr->arrErr['jp_other']))
            unset($objErr->arrErr['jp_other']);
        if (isset($objErr->arrErr['jp_level']) && !isset($objErr->arrErr['jp_other']))
            unset($objErr->arrErr['jp_level']);


        return $objErr;
    }

    /**
     * 会員検索パラメーター（管理画面用）
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @access public
     * @return void
     */
    public function sfSetSearchParam(&$objFormParam) {
        $objFormParam->addParam('会員ID', 'search_customer_id', ID_MAX_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('お名前', 'search_name', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('お名前(フリガナ)', 'search_kana', STEXT_LEN, 'CKV', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK', 'KANABLANK_CHECK'));
        $objFormParam->addParam('都道府県', 'search_pref', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('誕生日(開始年)', 'search_b_start_year', 4, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('誕生日(開始月)', 'search_b_start_month', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('誕生日(開始日)', 'search_b_start_day', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));

        $objFormParam->addParam('誕生日(終了年)', 'search_b_end_year', 4, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('誕生日(終了月)', 'search_b_end_month', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('誕生日(終了日)', 'search_b_end_day', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('誕生月', 'search_birth_month', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('メールアドレス', 'search_email', MTEXT_LEN, 'a', array('SPTAB_CHECK', 'EMAIL_CHAR_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('携帯メールアドレス', 'search_email_mobile', MTEXT_LEN, 'a', array('SPTAB_CHECK', 'EMAIL_CHAR_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('電話番号', 'search_tel', TEL_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('購入金額(開始)', 'search_buy_total_from', PRICE_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('購入金額(終了)', 'search_buy_total_to', PRICE_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('購入回数(開始)', 'search_buy_times_from', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('購入回数(終了)', 'search_buy_times_to', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('登録・更新日(開始年)', 'search_start_year', 4, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('登録・更新日(開始月)', 'search_start_month', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('登録・更新日(開始日)', 'search_start_day', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('登録・更新日(終了年)', 'search_end_year', 4, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('登録・更新日(終了月)', 'search_end_month', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('登録・更新日(終了日)', 'search_end_day', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('表示件数', 'search_page_max', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'), SEARCH_PMAX, false);
        $objFormParam->addParam('ページ番号', 'search_pageno', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'), 1, false);
        $objFormParam->addParam('最終購入日(開始年)', 'search_buy_start_year', 4, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('最終購入日(開始月)', 'search_buy_start_month', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('最終購入日(開始日)', 'search_buy_start_day', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('最終購入日(終了年)', 'search_buy_end_year', 4, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('最終購入日(終了月)', 'search_buy_end_month', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('最終購入日(終了日)', 'search_buy_end_day', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('購入商品コード', 'search_buy_product_code', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('購入商品名', 'search_buy_product_name', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('カテゴリ', 'search_category_id', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('性別', 'search_sex', INT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam('会員状態', 'search_status', INT_LEN, 'n', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam('職業', 'search_job', INT_LEN, 'n', array('MAX_LENGTH_CHECK'));
    }

    /**
     * 会員検索パラメーター　エラーチェック（管理画面用）
     *
     * @param SC_FormParam $objFormParam SC_FormParam インスタンス
     * @access public
     * @return array エラー配列
     */
    public function sfCheckErrorSearchParam(&$objFormParam) {
        // パラメーターの基本チェック
        $arrErr = $objFormParam->checkError();
        // エラーチェック対象のパラメータ取得
        $array = $objFormParam->getHashArray();
        // 拡張エラーチェック初期化
        $objErr = new SC_CheckError_Ex($array);
        // 拡張エラーチェック
        $objErr->doFunc(array('誕生日(開始日)', 'search_b_start_year', 'search_b_start_month', 'search_b_start_day'), array('CHECK_DATE'));
        $objErr->doFunc(array('誕生日(終了日)', 'search_b_end_year', 'search_b_end_month', 'search_b_end_day'), array('CHECK_DATE'));

        $objErr->doFunc(array('誕生日(開始日)', '誕生日(終了日)', 'search_b_start_year', 'search_b_start_month', 'search_b_start_day', 'search_b_end_year', 'search_b_end_month', 'search_b_end_day'), array('CHECK_SET_TERM'));
        $objErr->doFunc(array('登録・更新日(開始日)', 'search_start_year', 'search_start_month', 'search_start_day'), array('CHECK_DATE'));
        $objErr->doFunc(array('登録・更新日(終了日)', 'search_end_year', 'search_end_month', 'search_end_day'), array('CHECK_DATE'));
        $objErr->doFunc(array('登録・更新日(開始日)', '登録・更新日(終了日)', 'search_start_year', 'search_start_month', 'search_start_day', 'search_end_year', 'search_end_month', 'search_end_day'), array('CHECK_SET_TERM'));
        $objErr->doFunc(array('最終購入日(開始)', 'search_buy_start_year', 'search_buy_start_month', 'search_buy_start_day'), array('CHECK_DATE'));
        $objErr->doFunc(array('最終購入日(終了)', 'search_buy_end_year', 'search_buy_end_month', 'search_buy_end_day'), array('CHECK_DATE'));
        // 開始 > 終了 の場合はエラーとする
        $objErr->doFunc(array('最終購入日(開始)', '最終購入日(終了)', 'search_buy_start_year', 'search_buy_start_month', 'search_buy_start_day', 'search_buy_end_year', 'search_buy_end_month', 'search_buy_end_day'), array('CHECK_SET_TERM'));

        if (SC_Utils_Ex::sfIsInt($array['search_buy_total_from']) && SC_Utils_Ex::sfIsInt($array['search_buy_total_to']) && $array['search_buy_total_from'] > $array['search_buy_total_to']
        ) {
            $objErr->arrErr['search_buy_total_from'] .= '※ 購入金額の指定範囲が不正です。';
        }

        if (SC_Utils_Ex::sfIsInt($array['search_buy_times_from']) && SC_Utils_Ex::sfIsInt($array['search_buy_times_to']) && $array['search_buy_times_from'] > $array['search_buy_times_to']
        ) {
            $objErr->arrErr['search_buy_times_from'] .= '※ 購入回数の指定範囲が不正です。';
        }
        if (!SC_Utils_Ex::isBlank($objErr->arrErr)) {
            $arrErr = array_merge($arrErr, $objErr->arrErr);
        }

        return $arrErr;
    }

    /**
     * 会員一覧検索をする処理（ページング処理付き、管理画面用共通処理）
     *
     * @param  array  $arrParam  検索パラメーター連想配列
     * @param  string $limitMode ページングを利用するか判定用フラグ
     * @return array( integer 全体件数, mixed 会員データ一覧配列, mixed SC_PageNaviオブジェクト)
     */
    public function sfGetSearchData($arrParam, $limitMode = '') {
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $objSelect = new SC_CustomerList_Ex($arrParam, 'customer');

        $page_max = SC_Utils_Ex::sfGetSearchPageMax($arrParam['search_page_max']);
        $disp_pageno = $arrParam['search_pageno'];
        if ($disp_pageno == 0) {
            $disp_pageno = 1;
        }
        $offset = intval($page_max) * (intval($disp_pageno) - 1);
        if ($limitMode == '') {
            $objQuery->setLimitOffset($page_max, $offset);
        }
        $arrData = $objQuery->getAll($objSelect->getListforSearch(), $objSelect->arrVal);

        foreach ($arrData as $key => $obj) {
            // check cv exist
            if(!empty($obj['cv']))
            {
                if(file_exists(DOWN_SAVE_DIR_COMMON.$obj["cv"]))
                    $arrData[$key]['existsCv'] = true;
                else
                    $arrData[$key]['existsCv'] = false;
            }else
            {
                $arrData[$key]['existsCv'] = false;
            }
            // check resume exist
            if(!empty($obj['resume']))
            {

                if(file_exists(DOWN_SAVE_DIR_COMMON.$obj["resume"]))
                    $arrData[$key]['existsResume'] = true;
                else
                    $arrData[$key]['existsResume'] = false;
            }else
            {
                $arrData[$key]['existsResume'] = false;
            }
        }
        // 該当全体件数の取得
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $linemax = $objQuery->getOne($objSelect->getListCount(), $objSelect->arrVal);

        // ページ送りの取得
        $objNavi = new SC_PageNavi_Ex($arrParam['search_pageno'], $linemax, $page_max, 'eccube.moveSearchPage', NAVI_PMAX);

        return array($linemax, $arrData, $objNavi);
    }

    /**
     * 仮会員かどうかを判定する.
     *
     * @param  string  $login_email メールアドレス
     * @return boolean 仮会員の場合 true
     */
    public function checkTempCustomer($login_email) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();

        $where = 'email = ? AND status = 1 AND del_flg = 0';
        $exists = $objQuery->exists('dtb_customer', $where, array($login_email));

        return $exists;
    }

    /**
     * 会員を削除する処理
     *
     * @param  integer $customer_id 会員ID
     * @return boolean true:成功 false:失敗
     */
    public static function delete($customer_id) {
        $arrData = SC_Helper_Customer_Ex::sfGetCustomerDataFromId($customer_id, 'del_flg = 0');
        if (SC_Utils_Ex::isBlank($arrData)) {
            //対象となるデータが見つからない。
            return false;
        }
        // XXXX: 仮会員は物理削除となっていたが論理削除に変更。
        $arrVal = array(
            'del_flg' => '1',
        );
        SC_Helper_Customer_Ex::sfEditCustomerData($arrVal, $customer_id);

        return true;
    }

}
