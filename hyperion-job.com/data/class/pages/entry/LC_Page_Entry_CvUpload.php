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
 * @version $Id:LC_Page_Entry_CvUpload.php 15532 2007-08-31 14:39:46Z nanasess $
 */
class LC_Page_Entry_CvUpload extends LC_Page_Ex
{
    /**
     * Page を初期化する.
     * @return void
     */
    public function init()
    {
        parent::init();
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
        $objCustomer = new SC_Customer_Ex();
        $customer_id = $objCustomer->getValue('customer_id');
        $this->customer_data = SC_Helper_Customer_Ex::sfGetCustomerData($customer_id);

        // mobile用（戻るボタンでの遷移かどうかを判定）
        if (!empty($_POST['return'])) {
            $_REQUEST['mode'] = 'return';
        }

        // パラメーター管理クラス,パラメーター情報の初期化
        $objFormParam = new SC_FormParam_Ex();
        SC_Helper_Customer_Ex::sfCustomerCvParam($objFormParam);
        SC_Helper_Customer_Ex::sfCustomerResumeParam($objFormParam);
        $objFormParam->setParam($_POST);    // POST値の取得

        // ダウンロード販売ファイル情報の初期化
        $objCvFile = new SC_UploadFile_Ex(DOWN_TEMP_DIR_COMMON, DOWN_SAVE_DIR_COMMON);
        $objCvFile->addFile('履歴書ファイル', 'down_file', explode(',', DOWNLOAD_EXTENSION), DOWN_SIZE, true, 0, 0);
        $objCvFile->setHiddenFileList($_POST);

        // create file resume info
        $objResumeFile = new SC_UploadFile_Ex(DOWN_TEMP_DIR_COMMON, DOWN_SAVE_DIR_COMMON);
        $objResumeFile->addFile(' 職務履歴書ファイル', 'resume_file', explode(',', DOWNLOAD_EXTENSION), DOWN_SIZE, true, 0, 0);
        $objResumeFile->setHiddenFileList($_POST);

        switch ($this->getMode()) {
            case 'confirm':
                $this->arrErr = $objCvFile->checkExists();

                // 入力エラーなし
                if (empty($this->arrErr)) {
                    $this->tpl_mainpage = 'entry/cv_upload_confirm.tpl';
                    $this->tpl_subtitle = '履歴書ファイルアップロード(確認ページ)';
                }
                break;
            // 会員登録と完了画面
            case 'complete':
                $this->arrErr = array_merge((array)$objCvFile->checkExists(), (array)$objResumeFile->checkExists());
                $arrErrCV = (array)$objCvFile->checkExists();
                $arrErrResume = (array)$objResumeFile->checkExists();
                // 入力エラーなし
                if (empty($arrErrCV) || empty($arrErrResume)) {
                    $val = $objFormParam->getDbArray();
                    if (empty($arrErrCV)) {
                        $sqlval['cv'] = $val['cv'];
                        $sqlval['cv_name'] = $val['cv_name'];
                        $objCvFile->moveTempDownFile();
                    }
                    if (empty($arrErrResume)) {
                        $sqlval['resume'] = $val['resume'];
                        $sqlval['resume_name'] = $val['resume_name'];
                        $objResumeFile->moveTempDownFile();
                    }
                    SC_Helper_Customer_Ex::sfEditCustomerData($sqlval, $customer_id);
                    //セッション情報を最新の状態に更新する
                    $objCustomer->updateSession();
                    // 完了ページに移動させる。
                    if ($this->applyProductId > 0) {
                        $objPurchase = new SC_Helper_Purchase_Ex();
                        $objPurchase->finishOrder($this, 1);
                        $this->tpl_mainpage = 'entry/cv_complete_with_obo.tpl';
                    } else {
                        SC_Response_Ex::sendRedirect('cv_upload_complete.php');
                    }
                }
                break;
            // 確認ページからの戻り
            case 'return':
                // quiet.
                break;
            // upload cv
            case 'upload_down':
                //delete cv
            case 'delete_down':
                switch ($this->getMode()) {
                    case 'upload_down':
                        // ファイルを一時ディレクトリにアップロード
                        $this->arrErr['down_file'] = $objCvFile->makeTempDownFile();
                        if ($this->arrErr['down_file'] == null) {
                            $arrayForm = $objFormParam->getHashArray();
                            $tempfileName = $arrayForm['cv'];
                            $objCvFile->deleteTempFile($tempfileName);
                            $objFormParam->setParam(array('cv_name' => $_FILES['down_file']['name']));
                        }
                        break;
                    case 'delete_down':
                        // ファイル削除
                        $objCvFile->deleteFile('down_file');
                        $objFormParam->setParam(array('cv' => ''));
                        break;
                    default:
                        break;
                }
                break;
            // upload resume
            case 'resume_file':
                //delete cv
            case 'delete_down_resume':
                switch ($this->getMode()) {
                    case 'resume_file':
                        // ファイルを一時ディレクトリにアップロード
                        $this->arrErr['resume_file'] = $objResumeFile->makeTempDownFile('resume_file');
                        if ($this->arrErr['resume_file'] == null) {
                            $arrayForm = $objFormParam->getHashArray();
                            $tempfileName = $arrayForm['resume'];
                            $objCvFile->deleteTempFile($tempfileName);
                            $objFormParam->setParam(array('resume_name' => $_FILES['resume_file']['name']));
                        }
                        break;
                    case 'delete_down_resume':
                        // ファイル削除
                        $objResumeFile->deleteFile('resume_file');
                        $objFormParam->setParam(array('resume' => ''));
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

        $this->setUploadFile($objCvFile, $objResumeFile, $this->arrForm);
    }

    public function setUploadFile(&$objCvFile, &$objResumeFile, &$arrForm)
    {
        $objCvFile->setDBDownFile($arrForm);
        $objResumeFile->setDBDownFile($arrForm, 'resume');
        $arrHiddenCv = $objCvFile->getHiddenFileList();
        $arrHiddenRs = $objResumeFile->getHiddenFileList();
        $arrForm['arrHidden'] = array_merge((array)$arrHiddenCv, (array)$arrHiddenRs);
        $arrForm['cv'] = $objCvFile->getFormDownFile();
        $arrForm['resume'] = $objResumeFile->getFormDownFile();
    }
}
