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
class LC_Page_User extends LC_Page_Ex
{
    /**
     * Page を初期化する.
     *
     * @return void
     */
    function init()
    {
        parent::init();
    }

    /**
     * Page のプロセス.
     *
     * @return void
     */
    function process()
    {
        parent::process();
        $this->action();
        $this->sendResponse();
    }

    /**
     * Page のアクション.
     *
     * @return void
     */
    function action()
    {
        $objCustomer = new SC_Customer_Ex();
        $customer_id = $objCustomer->getValue('customer_id');
        $this->customer_data = SC_Helper_Customer_Ex::sfGetCustomerData($customer_id);
        if (!empty($this->customer_data['image']) && file_exists(IMAGE_SAVE_DIR_COMMON . $this->customer_data['image'])) {
            $this->customer_data['image'] = SC_Utils_Ex::sfGetBase64ImageData(IMAGE_SAVE_DIR_COMMON . $this->customer_data['image']);
        } else {
            $this->customer_data['image'] = IMAGE_SAVE_URLPATH.'avatar_default.png';
        }
        $this->page = '';
        if($this->applyProductEmploymentStatus > 1)
            $this->page = 'complete';
        
        $cv_type = '';
        $this->url = '';
        if(count($_POST) > 0 && $_POST['mode'] == 'finish'){
            switch ($_POST['apply_type']) {
                case 2:
                case 3:
                    $this->page = 'complete';
                    if($_POST['apply_type'] == 2)
                        $cv_type = 2;
                    else
                        $cv_type = 1;
                    break;
                case 1:
                    $this->url = '/entry/cv.php';
                    break;
                case 4:
                    $this->url = '/entry/cv_upload.php';
                    break;
                default:
                    break;
            }
        }
        
        if($this->page == 'complete'){
            $objPurchase = new SC_Helper_Purchase_Ex();
            $objPurchase->finishOrder($this, $cv_type);
        }
    }
}

$objPage = new LC_Page_User();
$objPage->init();
$objPage->process();
