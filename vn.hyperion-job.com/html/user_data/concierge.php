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
        $this->arrTarget = $masterData->getMasterData('mtb_object');
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
        $ret = false;

        if (SC_Utils_Ex::sfIsInt($_GET['id'])) {
            $objQuery = & SC_Query_Ex::getSingletonInstance();
            $objQuery->setOrder("workplace DESC");
            $cols = '*';
            $from = 'dtb_member';
            $where = 'del_flg = 0 AND authority = 2';
            $concierges = $objQuery->select($cols, $from, $where);

            $this->currentConcierge = array();
            $this->arrConcierge = array();
            foreach ($concierges as $concierge) {
                if ($concierge['member_id'] == $_GET['id'])
                    $this->currentConcierge = $concierge;
                else
                    $this->arrConcierge[] = $concierge;
            }

            if (count($this->currentConcierge) == 0)
                $ret = true;
        } else
            $ret = true;

        if ($ret) {
            SC_Response_Ex::sendRedirect('/');
            SC_Response_Ex::actionExit();
        }
    }

}

$objPage = new LC_Page_User();
$objPage->init();
$objPage->process();
