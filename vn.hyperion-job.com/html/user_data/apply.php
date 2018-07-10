<?php

require_once '../require.php';
require_once CLASS_EX_REALDIR . 'page_extends/LC_Page_Ex.php';

/**
 * ユーザーカスタマイズ用のページクラス
 *
 * 管理画面から自動生成される
 *
 * @package Page
 */
class LC_Page_User extends LC_Page_Ex {

    /**
     * Page を初期化する.
     *
     * @return void
     */
    function init() {
        parent::init();

        $masterData = new SC_DB_MasterData_Ex();
        $this->arrPref = $masterData->getMasterData('mtb_pref');
        $this->arrSex = $masterData->getMasterData('mtb_sex');
        $this->arrMaritalStatus = $masterData->getMasterData('mtb_marital_status');
        $this->arrTarget = $masterData->getMasterData('mtb_object');
        $this->arrEducation = $masterData->getMasterData('mtb_education');
        $this->arrPosition = $masterData->getMasterData('mtb_position');
        $this->arrRegion = $masterData->getMasterData('mtb_region');
        $this->arrJLPT = $masterData->getMasterData('mtb_jlpt');
        $this->arrWorkExperience = array(1 => '経験あり', 0 => '未経験');

        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $arrPref = $objQuery->select('*', 'mtb_pref');
        $this->arrPrefByTarget = array();
        foreach ($arrPref as $pref)
            $this->arrPrefByTarget[$pref['object_id']][$pref['id']] = $pref['name'];

        $objDb = new SC_Helper_DB_Ex();
        $this->arrCatList = $objDb->sfGetCategoryList('', false, '');

        // 日付プルダウン設定
        $objDate = new SC_Date_Ex(BIRTH_YEAR);
        $this->arrYear = $objDate->getYear();
        $this->arrMonth = $objDate->getMonth();
        $this->arrDay = $objDate->getDay();

        $objDate = new SC_Date_Ex(RELEASE_YEAR);
        $this->arrReleaseYear = $objDate->getYear();
    }

    /**
     * Page のプロセス.
     *
     * @return void
     */
    function process() {
        parent::process();
        $this->action();
        $this->sendResponse();
    }

    /**
     * Page のアクション.
     *
     * @return void
     */
    function action() {
        $objCustomer = new SC_Customer_Ex();

        switch ($this->getMode()) {
            case 'finish':
                $objCartSess = new SC_CartSession_Ex();
                $objSiteSess = new SC_SiteSession_Ex();
                $objPurchase = new SC_Helper_Purchase_Ex();
                $objQuery = & SC_Query_Ex::getSingletonInstance();
                $objHelperMail = new SC_Helper_Mail_Ex();
                $objHelperMail->setPage($this);

                $this->tpl_uniqid = $objSiteSess->getUniqId();
                $objPurchase->verifyChangeCart($this->tpl_uniqid, $objCartSess);
                $this->cartKey = $objCartSess->getKey();
                $arrForm = $objCartSess->calculate($this->cartKey, $objCustomer);
                $arrForm['update_date'] = 'CURRENT_TIMESTAMP';
                $arrForm['order_id'] = $objQuery->nextval('dtb_order_order_id');
                $_SESSION['order_id'] = $arrForm['order_id'];
                $arrForm['order_temp_id'] = $this->tpl_uniqid;
                $objPurchase->saveOrderTemp($this->tpl_uniqid, $arrForm, $objCustomer);
                $objSiteSess->setRegistFlag();
                $objPurchase->completeOrder(ORDER_NEW);
                $template_id = SC_Display_Ex::detectDevice() == DEVICE_TYPE_MOBILE ? 2 : 1;
                $objHelperMail->sfSendOrderMail($arrForm['order_id'], $template_id);

                $this->tpl_mainpage = 'user_data/apply_complete.tpl';
                break;
            default:
                $customer_id = $objCustomer->getValue('customer_id');
                $this->arrForm = SC_Helper_Customer_Ex::sfGetCustomerData($customer_id);
                $this->customer_data = $this->arrForm;

                // アップロードファイル情報の初期化
                $objUpFile = new SC_UploadFile_Ex(IMAGE_TEMP_REALDIR, IMAGE_SAVE_REALDIR);
                $objUpFile->addFile('写真', 'image', array('jpg', 'gif', 'png'), IMAGE_SIZE, false, LARGE_IMAGE_WIDTH, LARGE_IMAGE_HEIGHT);
                $objUpFile->setHiddenFileList($_POST);

                $objDownFile = new SC_UploadFile_Ex(DOWN_TEMP_REALDIR, DOWN_SAVE_REALDIR);
                $objDownFile->addFile('履歴書ファイル', 'down_file', explode(',', DOWNLOAD_EXTENSION), DOWN_SIZE, true, 0, 0);
                $objDownFile->setHiddenFileList($_POST);

                $this->setUploadFile($objUpFile, $objDownFile, $this->arrForm);
                break;
        }
    }

    public function setUploadFile(&$objUpFile, &$objDownFile, &$arrForm) {        
        $objUpFile->setDBFileList($arrForm);
        $objDownFile->setDBDownFile($arrForm);
        $arrHidden = $objUpFile->getHiddenFileList();
        $arrForm['arrHidden'] = array_merge((array) $arrHidden, (array) $objDownFile->getHiddenFileList());
        $arrForm['arrFile'] = $objUpFile->getFormFileList(IMAGE_TEMP_URLPATH, IMAGE_SAVE_URLPATH);
        $arrForm['cv'] = $objDownFile->getFormDownFile();
    }

}

$objPage = new LC_Page_User();
$objPage->init();
$objPage->process();
