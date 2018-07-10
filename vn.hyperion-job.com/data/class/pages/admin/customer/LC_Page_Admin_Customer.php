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

require_once CLASS_EX_REALDIR . 'page_extends/admin/LC_Page_Admin_Ex.php';

/**
 * 会員管理 のページクラス.
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id$
 */
class LC_Page_Admin_Customer extends LC_Page_Admin_Ex
{
    /**
     * Page を初期化する.
     *
     * @return void
     */
    public function init()
    {
        parent::init();
        $this->tpl_mainpage = 'customer/index.tpl';
        $this->tpl_mainno = 'customer';
        $this->tpl_subno = 'index';
        $this->tpl_pager = 'pager.tpl';
        $this->tpl_maintitle = '会員管理';
        $this->tpl_subtitle = '会員マスター';

        $masterData = new SC_DB_MasterData_Ex();
        $this->arrPref = $masterData->getMasterData('mtb_pref');
        $this->arrJob = $masterData->getMasterData('mtb_job');
        $this->arrJob['不明'] = '不明';
        $this->arrSex = $masterData->getMasterData('mtb_sex');
        $this->arrPageMax = $masterData->getMasterData('mtb_page_max');
        $this->arrStatus = $masterData->getMasterData('mtb_customer_status');
        $this->arrMagazineType = $masterData->getMasterData('mtb_magazine_type');

        // 日付プルダウン設定
        $objDate = new SC_Date_Ex();
        // 登録・更新日検索用
        $objDate->setStartYear(RELEASE_YEAR);
        $objDate->setEndYear(DATE('Y'));
        $this->arrRegistYear = $objDate->getYear();
        // 生年月日検索用
        $objDate->setStartYear(BIRTH_YEAR);
        $objDate->setEndYear(DATE('Y'));
        $this->arrBirthYear = $objDate->getYear();
        // 月日の設定
        $this->arrMonth = $objDate->getMonth();
        $this->arrDay = $objDate->getDay();

        // カテゴリ一覧設定
        $objDb = new SC_Helper_DB_Ex();
        $this->arrCatList = $objDb->sfGetCategoryList();

        $this->httpCacheControl('nocache');
    }

    /**
     * Page のプロセス.
     *
     * @return void
     */
    public function process()
    {
        $this->action();
        $this->sendResponse();
    }

    /**
     * Page のアクション.
     *
     * @return void
     */
    public function action()
    {
        // パラメーター管理クラス
        $objFormParam = new SC_FormParam_Ex();

        //customer helper
        $objCustomerHelper = new SC_Helper_Customer_Ex();

        // パラメーター設定
        $this->lfInitParam($objFormParam);
        $objFormParam->setParam($_POST);
        $objFormParam->convParam();
        // パラメーター読み込み
        $this->arrForm = $objFormParam->getFormParamList();
        // 検索ワードの引き継ぎ
        $this->arrHidden = $objFormParam->getSearchArray();

        // 入力パラメーターチェック
        $this->arrErr = $this->lfCheckError($objFormParam);
        if (!SC_Utils_Ex::isBlank($this->arrErr)) {
            return;
        }

        // モードによる処理切り替え
        switch ($this->getMode()) {
            case 'downloadCv':
                $cvInfo = $objCustomerHelper->sfGetCVInfo($objFormParam->getValue('edit_customer_id'));
                $file_path=DOWN_SAVE_DIR_COMMON.$cvInfo["cv"];
                $this->lfDownloadCV($file_path, $cvInfo["cv_name"], 'text/plain');
                break;
            case 'downloadResume':
                $resumeInfo = $objCustomerHelper->sfGetResumeInfo($objFormParam->getValue('edit_customer_id'));
                $file_path=DOWN_SAVE_DIR_COMMON.$resumeInfo["resume"];
                $this->lfDownloadCV($file_path, $resumeInfo["resume_name"], 'text/plain');
                break;
            case 'delete':
                $this->is_delete = $this->lfDoDeleteCustomer($objFormParam->getValue('edit_customer_id'));
                list($this->tpl_linemax, $this->arrData, $this->objNavi) = $this->lfDoSearch($objFormParam->getHashArray());
                $this->arrPagenavi = $this->objNavi->arrPagenavi;
                break;
            case 'resend_mail':
                $this->is_resendmail = $this->lfDoResendMail($objFormParam->getValue('edit_customer_id'));
                list($this->tpl_linemax, $this->arrData, $this->objNavi) = $this->lfDoSearch($objFormParam->getHashArray());
                $this->arrPagenavi = $this->objNavi->arrPagenavi;
                break;
            case 'search':
                list($this->tpl_linemax, $this->arrData, $this->objNavi) = $this->lfDoSearch($objFormParam->getHashArray());
                $this->arrPagenavi = $this->objNavi->arrPagenavi;
                break;
            case 'csv':
                $this->lfDoCSV($objFormParam->getHashArray());
                SC_Response_Ex::actionExit();
                break;
            default:
                break;
        }

    }

    /**
     * パラメーター情報の初期化
     *
     * @param  SC_FormParam_Ex $objFormParam フォームパラメータークラス
     * @return void
     */
    public function lfInitParam(&$objFormParam)
    {
        SC_Helper_Customer_Ex::sfSetSearchParam($objFormParam);
        $objFormParam->addParam('編集対象会員ID', 'edit_customer_id', INT_LEN, 'n', array('NUM_CHECK','MAX_LENGTH_CHECK'));
    }

    /**
     * エラーチェック
     *
     * @param  SC_FormParam_Ex $objFormParam フォームパラメータークラス
     * @return array エラー配列
     */
    public function lfCheckError(&$objFormParam)
    {
        return SC_Helper_Customer_Ex::sfCheckErrorSearchParam($objFormParam);
    }

    /**
     * 会員を削除する処理
     *
     * @param  integer $customer_id 会員ID
     * @return boolean true:成功 false:失敗
     */
    public function lfDoDeleteCustomer($customer_id)
    {
        return SC_Helper_Customer_Ex::delete($customer_id);
    }

    /**
     * 会員に登録メールを再送する処理
     *
     * @param  integer $customer_id 会員ID
     * @return boolean true:成功 false:失敗
     */
    public function lfDoResendMail($customer_id)
    {
        $arrData = SC_Helper_Customer_Ex::sfGetCustomerDataFromId($customer_id);
        if (SC_Utils_Ex::isBlank($arrData) or $arrData['del_flg'] == 1) {
            //対象となるデータが見つからない、または削除済み
            return false;
        }
        //仮登録メール再送
        $resend_flg = true; 
        // 登録メール再送
        $objHelperMail = new SC_Helper_Mail_Ex();
        $objHelperMail->setPage($this);
        $objHelperMail->sfSendRegistMail($arrData['secret_key'], $customer_id, null, $resend_flg);
        return true;
    }

    /**
     * 会員一覧を検索する処理
     *
     * @param  array  $arrParam 検索パラメーター連想配列
     * @return array( integer 全体件数, mixed 会員データ一覧配列, mixed SC_PageNaviオブジェクト)
     */
    public function lfDoSearch($arrParam)
    {
        return SC_Helper_Customer_Ex::sfGetSearchData($arrParam);
    }

    /**
     * 会員一覧CSVを検索してダウンロードする処理
     *
     * @param  array   $arrParam 検索パラメーター連想配列
     * @return boolean|string true:成功 false:失敗
     */
    public function lfDoCSV($arrParam)
    {
        $objSelect = new SC_CustomerList_Ex($arrParam, 'customer');
        $objCSV = new SC_Helper_CSV_Ex();

        $order = 'update_date DESC, customer_id DESC';

        list($where, $arrVal) = $objSelect->getWhere();

        return $objCSV->sfDownloadCsv('2', $where, $arrVal, $order, true);
    }

    public function lfDownloadCV($file, $name, $mime_type='')
    {
        if(!is_readable($file)) die('Error');

        $size = filesize($file);
        $name = rawurldecode($name);
        $known_mime_types=array(
        "pdf" => "application/pdf",
        "txt" => "text/plain",
        "html" => "text/html",
        "htm" => "text/html",
        "exe" => "application/octet-stream",
        "zip" => "application/zip",
        "doc" => "application/msword",
        "xls" => "application/vnd.ms-excel",
        "ppt" => "application/vnd.ms-powerpoint",
        "gif" => "image/gif",
        "png" => "image/png",
        "jpeg"=> "image/jpg",
        "jpg" => "image/jpg",
        "php" => "text/plain"
        );
        if($mime_type==''){
        $file_extension = strtolower(substr(strrchr($file,"."),1));
        if(array_key_exists($file_extension, $known_mime_types)){
        $mime_type=$known_mime_types[$file_extension];
        } else {
        $mime_type="application/force-download";
        };
        };

        @ob_end_clean();


        if(ini_get('zlib.output_compression'))
        ini_set('zlib.output_compression', 'Off');
        header('Content-Type: ' . $mime_type);
        header('Content-Disposition: attachment; filename="'.$name.'"');
        header("Content-Transfer-Encoding: binary");
        header('Accept-Ranges: bytes');
        header("Cache-control: private");
        header('Pragma: private');
        header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
        if(isset($_SERVER['HTTP_RANGE']))
        {
        list($a, $range) = explode("=",$_SERVER['HTTP_RANGE'],2);
        list($range) = explode(",",$range,2);
        list($range, $range_end) = explode("-", $range);
        $range=intval($range);
        if(!$range_end) {
        $range_end=$size-1;
        } else {
        $range_end=intval($range_end);
        }
        $new_length = $range_end-$range+1;
        header("HTTP/1.1 206 Partial Content");
        header("Content-Length: $new_length");
        header("Content-Range: bytes $range-$range_end/$size");
        } else {
        $new_length=$size;
        header("Content-Length: ".$size);
        }
        $chunksize = 1*(1024*1024);
        $bytes_send = 0;
        if ($file = fopen($file, 'r'))
        {
        if(isset($_SERVER['HTTP_RANGE']))
        fseek($file, $range);

        while(!feof($file) &&
        (!connection_aborted()) &&
        ($bytes_send<$new_length)
        )
        {
        $buffer = fread($file, $chunksize);
        print($buffer);
        flush();
        $bytes_send += strlen($buffer);
        }
        fclose($file);
        } else

        die('Error - can not open file.');
        die();
    }

}
