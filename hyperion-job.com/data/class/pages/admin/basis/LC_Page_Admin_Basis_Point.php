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
 * ポイント設定 のページクラス.
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id$
 */
class LC_Page_Admin_Basis_Point extends LC_Page_Admin_Ex {

    /**
     * Page を初期化する.
     *
     * @return void
     */
    public function init() {
        parent::init();
        $this->tpl_mainpage = 'basis/point.tpl';
        $this->tpl_subno = 'point';
        $this->tpl_mainno = 'basis';
        $this->tpl_maintitle = '基本情報管理';
        $this->tpl_subtitle = 'ポイント設定';
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
//        $objQuery = & SC_Query_Ex::getSingletonInstance();

//        $dtb = array(
//            'dtb_best_products' => array('pk' => 'best_id', 'cols' => 'comment'),
//            'dtb_client' => array('pk' => 'client_id', 'cols' => 'establishment_date,capital,scale,introduction'),
//            'dtb_kiyaku' => array('pk' => 'kiyaku_id', 'cols' => 'kiyaku_title,kiyaku_text'),
//            'dtb_news' => array('pk' => 'news_id', 'cols' => 'news_title,news_comment'),
//            'dtb_pagelayout' => array('pk' => array('device_type_id', 'page_id'), 'cols' => 'page_name'),
//            'dtb_products' => array('pk' => 'product_id', 'cols' => 'name,comment3,main_list_comment,main_comment,client_introduction,salary,work_location,traffic_access,working_hour,working_day,lunch_time,trial_period,qualification,personality,skill,payrise,bonus,insurance,other_welfare,medical_checkup,applicate_method'));
//        foreach ($dtb as $table => $scheme) {
//            $pk = $scheme['pk'];
//            if (is_array($scheme['pk']))
//                $pk = implode(',', $scheme['pk']);
//            $arrResult = $objQuery->select($pk . ',' . $scheme['cols'], $table);
//            if (count($arrResult) > 0) {
//                foreach ($arrResult as $result) {
//                    $arrCols = explode(',', $scheme['cols']);
//                    $arrUpd = array();
//                    foreach ($arrCols as $col)
//                        $arrUpd[$col . '_vn'] = $result[$col];
//                    if (is_array($scheme['pk']))
//                        $objQuery->update($table, $arrUpd, $scheme['pk'][0] . ' = ? AND ' . $scheme['pk'][1] . ' = ?', array($result[$scheme['pk'][0]], $result[$scheme['pk'][1]]));
//                    else
//                        $objQuery->update($table, $arrUpd, $pk . ' = ?', array($result[$pk]));
//                }
//            }
//        }
//
//        $mtb = array('mtb_category', 'mtb_currency', 'mtb_education', 'mtb_employment_status', 'mtb_mail_magazine_type', 'mtb_marital_status', 'mtb_object', 'mtb_position', 'mtb_pref', 'mtb_process', 'mtb_reminder', 'mtb_salary_type', 'mtb_welfare');
//        $arrUpd = array();
//        foreach ($mtb as $table) {
//            $arrResult = $objQuery->select('id, name', $table);
//            if (count($arrResult) > 0) {
//                foreach ($arrResult as $result) {
//                    $arrUpd['name_vn'] = $result['name'];
//                    $objQuery->update($table, $arrUpd, 'id = ?', array($result['id']));
//                }
//            }
//        }


        $objDb = new SC_Helper_DB_Ex();
        // パラメーター管理クラス
        $objFormParam = new SC_FormParam_Ex();
        // パラメーター情報の初期化
        $this->lfInitParam($objFormParam);
        // POST値の取得
        $objFormParam->setParam($_POST);

        if ($objDb->sfGetBasisExists()) {
            $this->tpl_mode = 'update';
        } else {
            $this->tpl_mode = 'insert';
        }

        if (!empty($_POST)) {
            // 入力値の変換
            $objFormParam->convParam();
            $this->arrErr = $objFormParam->checkError();

            if (count($this->arrErr) == 0) {
                switch ($this->getMode()) {
                    case 'update':
                        $this->lfUpdateData($objFormParam->getHashArray()); // 既存編集
                        break;
                    case 'insert':
                        $this->lfInsertData($objFormParam->getHashArray()); // 新規作成
                        break;
                    default:
                        break;
                }
                // 再表示
                $this->tpl_onload = "window.alert('ポイント設定が完了しました。');";
            }
        } else {
            $arrRet = $objDb->sfGetBasisData();
            $objFormParam->setParam($arrRet);
        }
        $this->arrForm = $objFormParam->getFormParamList();
    }

    /* パラメーター情報の初期化 */

    /**
     * @param SC_FormParam_Ex $objFormParam
     */
    public function lfInitParam(&$objFormParam) {
        $objFormParam->addParam('ポイント付与率', 'point_rate', PERCENTAGE_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam('会員登録時付与ポイント', 'welcome_point', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'));
    }

    public function lfUpdateData($post) {
        // 入力データを渡す。
        $sqlval = $post;
        $sqlval['update_date'] = 'CURRENT_TIMESTAMP';
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        // UPDATEの実行
        $objQuery->update('dtb_baseinfo', $sqlval);
    }

    public function lfInsertData($post) {
        // 入力データを渡す。
        $sqlval = $post;
        $sqlval['id'] = 1;
        $sqlval['update_date'] = 'CURRENT_TIMESTAMP';
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        // INSERTの実行
        $objQuery->insert('dtb_baseinfo', $sqlval);
    }

}
