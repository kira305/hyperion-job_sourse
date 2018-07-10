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

require_once CLASS_EX_REALDIR . 'page_extends/frontparts/bloc/LC_Page_FrontParts_Bloc_Ex.php';

/**
 * 検索ブロック のページクラス.
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id:LC_Page_FrontParts_Bloc_SearchProducts.php 15532 2007-08-31 14:39:46Z nanasess $
 */
class LC_Page_FrontParts_Bloc_SearchProducts extends LC_Page_FrontParts_Bloc_Ex {

    /**
     * Page を初期化する.
     *
     * @return void
     */
    public function init() {
        parent::init();
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
        $masterData = new SC_DB_MasterData_Ex();
        $this->arrRegion = $masterData->getMasterData('mtb_region');
        $this->arrWelfare = $masterData->getMasterData('mtb_welfare');

        $this->arrEmploymentStatus = $masterData->getMasterData('mtb_employment_status');
        $this->arrEmploymentStatusByTarget[1] = array(1 => $this->arrEmploymentStatus[1], 2 => $this->arrEmploymentStatus[2], 3 => $this->arrEmploymentStatus[3]);
        $this->arrEmploymentStatusByTarget[2] = array(1 => $this->arrEmploymentStatus[1]);
        $this->arrTargetByEmploymentStatus = array(1 => 2, 2 => 1, 3 => 1);
        $this->arrSalaryType = $masterData->getMasterData('mtb_salary_type');
        $this->arrSalaryTypeByTarget[1] = array(1 => $this->arrSalaryType[1], 2 => $this->arrSalaryType[2]);
        $this->arrSalaryTypeByTarget[2] = array(3 => $this->arrSalaryType[3]);
        $this->arrCurrency = $masterData->getMasterData('mtb_currency');
        $this->arrCurrencyByTarget[1] = array(1 => $this->arrCurrency[1]);
        $this->arrCurrencyByTarget[2] = $this->arrCurrency;

        $this->arrCity = $masterData->getMasterData('mtb_city');
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $arrCity = $objQuery->select('*', 'mtb_city');
        $this->arrCityByRegion = array();
        foreach ($arrCity as $city)
            $this->arrCityByRegion[$city['region_id']][$city['id']] = $city['name_vn'];

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

        $arrSalaryRange = $objQuery->select('*', 'mtb_salary_range');
        $arrSalaryRangeByTypeAndCurrency = array();
        foreach ($arrSalaryRange as $range) {
            $type = substr($range['id'], 0, 1);
            $arrSalaryRangeByTypeAndCurrency[$type][$range['currency_id']][$range['id']] = SC_Utils_Ex::sfBriefPrice($range['name'], $this->arrCurrency[$range['currency_id']]);
        }
        $this->arrSalaryRangeByTypeAndCurrency = array();
        foreach ($arrSalaryRangeByTypeAndCurrency as $type => $arr1) {
            foreach ($arr1 as $currencyId => $arr2) {
                $k = 0;
                foreach ($arr2 as $id => $value) {
                    $k++;
                    if ($k == 1)
                        $this->arrSalaryRangeByTypeAndCurrency[$type][$currencyId][$id . '0'] = 'Dưới '.$value ;
                    if ($k == count($arr2))
                        $this->arrSalaryRangeByTypeAndCurrency[$type][$currencyId][$id . '00'] ='Trên '.$value;
                    else
                        $this->arrSalaryRangeByTypeAndCurrency[$type][$currencyId][$id] = $value . '〜' . $arrSalaryRangeByTypeAndCurrency[$type][$currencyId][$id + 1];
                }
            }
        }

        $this->prevPage = $_SERVER['REQUEST_URI'];
        if (isset($_GET['prevPage']))
            $this->prevPage = $_GET['prevPage'];
        $this->page = 0;
        $this->target = 0;

        if ($this->prevPage == '/user_data/vietnam.php') {
            $this->page = 2;
            $this->target = 2;
        } else if ($this->prevPage == '/user_data/japan.php')
            $this->page = 1;

        if ($_REQUEST['employment_status'][0] == 1)
            $this->target = 2;
        else if ($_REQUEST['employment_status'] == 2 || $_REQUEST['employment_status'] == 3)
            $this->target = 1;
    }

}
