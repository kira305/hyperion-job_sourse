<?php

/*
 * This file is part of EC-CUBE
 *
 * Copyright(c) 2000-2012 LOCKON CO.,LTD. All Rights Reserved.
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
 * 会員情報修正 のページクラス.
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id$
 */
class LC_Page_Admin_Customer_Client extends LC_Page_Admin_Ex {

    /**
     * Page を初期化する.
     *
     * @return void
     */
    public function init() {
        parent::init();
        $this->tpl_mainpage = 'customer/client.tpl';
        $this->tpl_mainno = 'customer';
        $this->tpl_subno = 'client';
        $this->tpl_pager = 'pager.tpl';
        $this->tpl_maintitle = '会員管理';
        $this->tpl_subtitle = '取引先登録';

        $masterData = new SC_DB_MasterData_Ex();
        $this->arrPref = $masterData->getMasterData('mtb_pref');
        $this->arrPageMax = $masterData->getMasterData('mtb_page_max');
        $this->arrEmploymentStatus = $masterData->getMasterData('mtb_employment_status');

        $objDate = new SC_Date_Ex(BIRTH_YEAR);
        $this->arrYear = $objDate->getYear();
        $this->arrMonth = $objDate->getMonth();
        $this->arrDay = $objDate->getDay();
    }

    /**
     * Page のプロセス.
     *
     * @return void
     */
    public function process() {
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
        // 検索引き継ぎ用パラメーター管理クラス
        $objFormSearchParam = new SC_FormParam_Ex();

        $this->lfInitParam($objFormParam);
        if ($this->getMode() != 'edit_search') {
            $objFormParam->setParam($_POST);
            $objFormParam->convParam();
            if (count($_POST) > 0)
                $this->arrErr = $this->lfCheckError($objFormParam);
            $this->arrForm = $objFormParam->getHashArray();
        }

        $this->lfInitSearchParam($objFormSearchParam);
        if ($this->getMode() != 'edit_search')
            $objFormSearchParam->setParam($objFormParam->getValue('search_data'));
        else
            $objFormSearchParam->setParam($_REQUEST);
        $this->arrSearchErr = $this->lfCheckErrorSearchParam($objFormSearchParam);
        $this->arrSearchData = $objFormSearchParam->getSearchArray();

        if (!SC_Utils_Ex::isBlank($this->arrErr) or ! SC_Utils_Ex::isBlank($this->arrSearchErr))
            return;

        // モードによる処理切り替え
        switch ($this->getMode()) {
            case 'edit_search':
                // 検索引き継ぎ用パラメーター処理
                if (!SC_Utils_Ex::isBlank($this->arrSearchErr)) {
                    return;
                }
                $objQuery = & SC_Query_Ex::getSingletonInstance();
                $ret = $objQuery->select('*', 'dtb_client', 'client_id=?', array($objFormSearchParam->getValue('edit_client_id')));
                list($ret[0]['contract_year'], $ret[0]['contract_month'], $ret[0]['contract_day']) = explode('-', $ret[0]['contract_date']);
                $ret[0]['employment_status'] = explode(' ', $ret[0]['employment_status']);
                $objFormParam->setParam($ret[0]);
                $this->arrForm = $objFormParam->getHashArray();
                break;
            case 'confirm':
                $this->tpl_mainpage = 'customer/client_confirm.tpl';
                break;
            case 'complete':
                $this->lfRegistData($objFormParam);
                $this->tpl_mainpage = 'customer/client_complete.tpl';
                break;
            case 'return':
            case 'complete_return':
                break;
            default:
                break;
        }
    }

    /**
     * パラメーター情報の初期化
     *
     * @param array $objFormParam フォームパラメータークラス
     * @return void
     */
    function lfInitParam(&$objFormParam) {
        $objFormParam->addParam('取引先ID', 'client_id', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam('取引先名', 'name', STEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('取引先名（カナ）', 'kana', STEXT_LEN, 'KVCa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK', 'KANA_CHECK'));
        $objFormParam->addParam('代表者名1', 'owner_name01', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('代表者名2', 'owner_name02', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('郵便番号1', 'zip01', ZIP01_LEN, 'n', array('SPTAB_CHECK', 'NUM_CHECK', 'NUM_COUNT_CHECK'));
        $objFormParam->addParam('郵便番号2', 'zip02', ZIP02_LEN, 'n', array('SPTAB_CHECK', 'NUM_CHECK', 'NUM_COUNT_CHECK'));
        $objFormParam->addParam('本社住所', 'pref', INT_LEN, 'n', array('MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam('本社住所1', 'addr01', MTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('TEL', 'tel', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('FAX', 'fax', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('基本契約締結年', 'contract_year', 4, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('基本契約締結月', 'contract_month', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('基本契約締結日', 'contract_day', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('採用担当者名1', 'hr_charger_name01', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('採用担当者名2', 'hr_charger_name02', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('採用担当者連絡先', 'hr_charger_tel', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('採用担当者メールアドレス', 'hr_charger_email', null, 'a', array('NO_SPTAB', 'EMAIL_CHECK', 'SPTAB_CHECK', 'EMAIL_CHAR_CHECK'));
        $objFormParam->addParam('雇用形態', 'employment_status', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('備考（メモ）', 'memo', MLTEXT_LEN, 'KVa', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam('設立年月日', 'establishment_date', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('資本金', 'capital', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('会社の規模', 'scale', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('事業部の簡単な情報', 'introduction', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('設立年月日_VN', 'establishment_date_vn', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('資本金_VN', 'capital_vn', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('会社の規模_VN', 'scale_vn', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('事業部の簡単な情報_VN', 'introduction_vn', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('検索用データ', 'search_data', '', '', array(), '', false);
        $objFormParam->addParam('', 'search_pageno', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'), '', false);
    }

    /**
     * 検索パラメーター引き継ぎ用情報の初期化
     *
     * @param array $objFormParam フォームパラメータークラス
     * @return void
     */
    function lfInitSearchParam(&$objFormParam) {
        $objFormParam->addParam('取引先ID', 'search_client_id', ID_MAX_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('取引先名', 'search_name', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('代表者名', 'search_owner_name', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('担当者', 'search_hr_charger_name', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('TEL', 'search_tel', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('雇用形態', 'search_employment_status', INT_LEN, 'n', array('MAX_LENGTH_CHECK'));

        $objFormParam->addParam('表示件数', 'search_page_max', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'), 1, false);
        $objFormParam->addParam('ページ番号', 'search_pageno', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'), 1, false);
        $objFormParam->addParam('edit_client_id', 'edit_client_id', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
    }

    /**
     * 検索パラメーターエラーチェック
     *
     * @param array $objFormParam フォームパラメータークラス
     * @return array エラー配列
     */
    function lfCheckErrorSearchParam(&$objFormParam) {
        $arrErr = $objFormParam->checkError();
        return $arrErr;
    }

    /**
     * フォーム入力パラメーターエラーチェック
     *
     * @param array $objFormParam フォームパラメータークラス
     * @return array エラー配列
     */
    function lfCheckError(&$objFormParam) {
        $arrForm = $objFormParam->getHashArray();
        $objErr = new SC_CheckError_Ex($arrForm);
        $objErr->arrErr = $objFormParam->checkError();
        $objErr->doFunc(array('基本契約締結日', 'contract_year', 'contract_month', 'contract_day'), array('CHECK_DATE'));
        return $objErr->arrErr;
    }

    /**
     * 登録処理
     *
     * @param array $objFormParam フォームパラメータークラス
     * @return array エラー配列
     */
    function lfRegistData(&$objFormParam) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $arrData = $objFormParam->getDbArray();

        if ($arrData['contract_year'] > 0)
            $arrData['contract_date'] = $arrData['contract_year'] . '-' . $arrData['contract_month'] . '-' . $arrData['contract_day'];
        unset($arrData['contract_year']);
        unset($arrData['contract_month']);
        unset($arrData['contract_day']);
        $arrData['employment_status'] = implode(" ", $arrData['employment_status']);

        if (is_numeric($arrData['client_id'])) {
            $arrData['update_date'] = 'CURRENT_TIMESTAMP';
            $objQuery->update('dtb_client', $arrData, 'client_id = ? ', array($arrData['client_id']));
        } else {
            $arrData['create_date'] = 'CURRENT_TIMESTAMP';
            $objQuery->insert('dtb_client', $arrData);
        }

        $objQuery->commit();
    }

}
