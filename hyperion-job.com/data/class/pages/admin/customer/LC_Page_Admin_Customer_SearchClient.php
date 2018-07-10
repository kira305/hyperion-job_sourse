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
 * LC_Page_Admin_Customer_SearchClient のページクラス.
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id$
 */
class LC_Page_Admin_Customer_SearchClient extends LC_Page_Admin_Ex
{
    /**
     * Page を初期化する.
     *
     * @return void
     */
    public function init()
    {
        parent::init();
        $this->tpl_mainpage = 'customer/search_client.tpl';
        $this->tpl_subtitle = '会員検索';
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
        // パラメーター設定
        $this->lfInitParam($objFormParam);
        $objFormParam->setParam($_POST);
        $objFormParam->convParam();
        // パラメーター読み込み
        $this->arrForm = $objFormParam->getFormParamList();
        // 入力パラメーターチェック
        $this->arrErr = $objFormParam->checkError();
        if (SC_Utils_Ex::isBlank($this->arrErr)) {
            // POSTのモードがsearchなら会員検索開始
            switch ($this->getMode()) {
                case 'search':
                    list($this->tpl_linemax, $this->arrClient, $this->objNavi) = $this->lfDoSearch($objFormParam->getHashArray());
                    $this->tpl_strnavi = $this->objNavi->strnavi;
                    break;
                default:
                    break;
            }
        }
        $this->setTemplate($this->tpl_mainpage);
    }

    /**
     * パラメーター情報の初期化
     *
     * @param  SC_FormParam_Ex $objFormParam フォームパラメータークラス
     * @return void
     */
    public function lfInitParam(&$objFormParam)
    {
        $objFormParam->addParam('企業ID', 'search_client_id', ID_MAX_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('企業名', 'search_name', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
    }

    /**
     * 会員一覧を検索する処理
     *
     * @param  array  $arrParam 検索パラメーター連想配列
     * @return array( integer 全体件数, mixed 会員データ一覧配列, mixed SC_PageNaviオブジェクト)
     */
    public function lfDoSearch($arrRet)
    {
        $where = "del_flg = 0";
        $arrval = array();
        foreach ($arrRet as $key => $val) {
            if ($val == "") {
                continue;
            }
            switch ($key) {
                case 'search_client_id':
                    $where .= " AND client_id = ?";
                    $arrval[] = $val;
                    break;
                case 'search_name':
                    $where .= " AND name ILIKE ?";
                    $arrval[] = "%$val%";
                    break;
            }
        }
        
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $linemax = $objQuery->count('dtb_client', $where, $arrval);
        if (is_numeric($arrRet['search_page_max']))
            $page_max = $arrRet['search_page_max'];
        else
            $page_max = SEARCH_PMAX;
        $objNavi = new SC_PageNavi($arrRet['search_pageno'], $linemax, $page_max, "fnNaviSearchPage", NAVI_PMAX);
        $startno = $objNavi->start_row;
        $this->arrPagenavi = $objNavi->arrPagenavi;
        $objQuery->setlimitoffset($page_max, $startno);
        $arrResults = $objQuery->select('client_id, name', 'dtb_client', $where, $arrval);
        return array($linemax, $arrResults, $objNavi);
    }
}
