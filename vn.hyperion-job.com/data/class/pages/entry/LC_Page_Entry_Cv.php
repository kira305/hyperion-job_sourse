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
 * 会員登録のページクラス.
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id:LC_Page_Entry_Cv.php 15532 2007-08-31 14:39:46Z nanasess $
 */
class LC_Page_Entry_Cv extends LC_Page_Ex
{
    /**
     * Page を初期化する.
     * @return void
     */
    public function init()
    {
        parent::init();
        $masterData = new SC_DB_MasterData_Ex();
        $this->arrSex = $masterData->getMasterData('mtb_sex');
        $this->arrMaritalStatus = $masterData->getMasterData('mtb_marital_status');
        $this->arrTarget = $masterData->getMasterData('mtb_object');
        $this->arrEducation = $masterData->getMasterData('mtb_education');
        $this->arrPosition = $masterData->getMasterData('mtb_position');
        $this->arrRegion = $masterData->getMasterData('mtb_region');
        $this->arrJLPT = $masterData->getMasterData('mtb_jlpt');
        $this->arrWorkExperience = array(1 => 'Có kinh nghiệm', 0 => 'Chưa có kinh nghiệm');
        
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $this->arrPref = $masterData->getMasterData('mtb_pref');
        $arrPref = $objQuery->select('*', 'mtb_pref');
        $this->arrPrefByTarget = array();
        foreach ($arrPref as $pref)
            $this->arrPrefByTarget[$pref['object_id']][$pref['id']] = $pref['name_vn'];
        
        $this->arrCategory = $masterData->getMasterData('mtb_category');
        $arrCategory = $objQuery->select('*', 'mtb_category');
        $this->arrCategoryByTarget = array();
        foreach ($arrCategory as $category){
            if($category['object_id'] != '' && $category['object_id'] > 0)
                $this->arrCategoryByTarget[$category['object_id']][$category['id']] = $category['name_vn'];
            else{
                $this->arrCategoryByTarget[1][$category['id']] = $category['name_vn'];
                $this->arrCategoryByTarget[2][$category['id']] = $category['name_vn'];
            }
        }

        // 日付プルダウン設定
        $objDate = new SC_Date_Ex(BIRTH_YEAR);
        $this->arrYear = $objDate->getYear();
        $this->arrMonth = $objDate->getMonth();
        $this->arrDay = $objDate->getDay();
        
        $objDate = new SC_Date_Ex(RELEASE_YEAR, DATE('Y'));
        $this->arrReleaseYear = $objDate->getYear();

        $this->httpCacheControl('nocache');
    }

    /**
     * Page のプロセス.
     *
     * @return void
     */
    public function process()
    {
        parent::process();
        $this->action();
        $this->sendResponse();
    }

    /**
     * Page のプロセス
     * @return void
     */
    public function action()
    {
        //決済処理中ステータスのロールバック
        $objPurchase = new SC_Helper_Purchase_Ex();
        $objPurchase->cancelPendingOrder(PENDING_ORDER_CANCEL_FLAG);
        
        $objCustomer = new SC_Customer_Ex();
        $customer_id = $objCustomer->getValue('customer_id');
        $this->customer_data = SC_Helper_Customer_Ex::sfGetCustomerData($customer_id);

        $objFormParam = new SC_FormParam_Ex();
        SC_Helper_Customer_Ex::sfCustomerMypageParam($objFormParam);
        $objFormParam->setParam($_POST);
        
        // アップロードファイル情報の初期化
        $objUpFile = new SC_UploadFile_Ex(IMAGE_TEMP_REALDIR, IMAGE_SAVE_REALDIR);
        $objUpFile->addFile('写真', 'image', array('jpg', 'gif', 'png'), IMAGE_SIZE, false, LARGE_IMAGE_WIDTH, LARGE_IMAGE_HEIGHT);
        $objUpFile->setHiddenFileList($_POST);

        // mobile用（戻るボタンでの遷移かどうかを判定）
        if (!empty($_POST['return'])) {
            $_REQUEST['mode'] = 'return';
        }

        switch ($this->getMode()) {
            case 'confirm':
                //-- 確認
                $this->arrErr = SC_Helper_Customer_Ex::sfCustomerEntryErrorCheck($objFormParam);
                $this->arrErr = array_merge((array) $this->arrErr, (array) $objUpFile->checkExists());
                unset($this->arrErr['password']);
                
                // 入力エラーなし
                if (empty($this->arrErr)) {
                    $this->tpl_mainpage = 'entry/cv_confirm.tpl';
                    $this->tpl_title    = 'Tạo hồ sơ trực tuyến (Trang xác nhận)';
                }
                break;
            case 'complete':
                //-- 会員登録と完了画面
                $this->arrErr = SC_Helper_Customer_Ex::sfCustomerEntryErrorCheck($objFormParam);
                $this->arrErr = array_merge((array) $this->arrErr, (array) $objUpFile->checkExists());
                unset($this->arrErr['password']);
                
                if (empty($this->arrErr)) {
                    $uniqid = $this->lfRegistCustomerData($objFormParam, $customer_id, $objUpFile);
                    
                    $objCustomer->updateSession();

                    if($this->applyProductId > 0){
                        $objPurchase = new SC_Helper_Purchase_Ex();
                        $objPurchase->finishOrder($this, 2);
                        $this->tpl_mainpage = 'entry/cv_complete_with_obo.tpl';
                    }
                    else
                        SC_Response_Ex::sendRedirect('cv_complete.php');
                }
                break;
            case 'return':
                // quiet.
                break;
            // 画像のアップロード
            case 'upload_image':
            case 'delete_image':
                switch ($this->getMode()) {
                    case 'upload_image':
                        $this->arrErr['image'] = $objUpFile->makeTempFile('image', IMAGE_RENAME);
                        break;
                    case 'delete_image':
                        $this->lfDeleteTempFile($objUpFile, 'image');
                        break;
                    default:
                        break;
                }
                break;
            default:
                $this->arrForm = $this->customer_data;
                break;
        }
        if ($this->getMode() != '')
            $this->arrForm = $objFormParam->getHashArray();

        $this->setUploadFile($objUpFile, $this->arrForm);
    }

    /**
     * 会員情報の登録
     *
     * @access private
     * @return uniqid
     */
    public function lfRegistCustomerData(&$objFormParam, $customer_id, $objUpFile)
    {
        $sqlval = $objFormParam->getDbArray();

        $sqlval['desired_work'] = implode(" ", $sqlval['desired_work']);
        $sqlval['desired_position'] = implode(" ", $sqlval['desired_position']);
        $sqlval['desired_region'] = implode(" ", $sqlval['desired_region']);

        $arrRet = $objUpFile->getDBFileList();
        $sqlval = array_merge($sqlval, $arrRet);
        $this->lfSaveUploadFiles($objUpFile);

        SC_Helper_Customer_Ex::sfEditCustomerData($sqlval, $customer_id);
    }

    public function lfSaveUploadFiles(&$objUpFile) {
        // TODO: SC_UploadFile::moveTempFileの画像削除条件見直し要
        $objImage = new SC_Image_Ex($objUpFile->temp_dir);
        $arrTempFile = $objUpFile->temp_file;
        foreach ($arrTempFile as $temp_file) {
            if ($temp_file) {
                $objImage->moveTempImage($temp_file, $objUpFile->save_dir);
            }
        }
    }

    public function setUploadFile(&$objUpFile, &$arrForm) {
        $objUpFile->setDBFileList($arrForm);
        $arrForm['arrHidden'] = $objUpFile->getHiddenFileList();
        $arrForm['arrFile'] = $objUpFile->getFormFileList(IMAGE_TEMP_URLPATH, IMAGE_SAVE_URLPATH);
    }

    public function lfDeleteTempFile(&$objUpFile, $image_key) {
        // TODO: SC_UploadFile::deleteFileの画像削除条件見直し要
        $arrTempFile = $objUpFile->temp_file;
        $arrKeyName = $objUpFile->keyname;

        foreach ($arrKeyName as $key => $keyname) {
            if ($keyname != $image_key)
                continue;

            if (!empty($arrTempFile[$key])) {
                $temp_file = $arrTempFile[$key];
                $arrTempFile[$key] = '';

                if (!in_array($temp_file, $arrTempFile)) {
                    $objUpFile->deleteFile($image_key);
                } else {
                    $objUpFile->temp_file[$key] = '';
                    $objUpFile->save_file[$key] = '';
                }
            } else {
                $objUpFile->temp_file[$key] = '';
                $objUpFile->save_file[$key] = '';
            }
        }
    }
    
}
