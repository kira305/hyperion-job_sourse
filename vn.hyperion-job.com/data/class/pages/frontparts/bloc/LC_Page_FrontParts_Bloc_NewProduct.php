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
 * Recommend のページクラス.
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id: LC_Page_FrontParts_Bloc_NewProduct $
 */
class LC_Page_FrontParts_Bloc_NewProduct extends LC_Page_FrontParts_Bloc_Ex {

    /**
     * Page を初期化する.
     *
     * @return void
     */
    public function init() {
        parent::init();

        $masterData = new SC_DB_MasterData_Ex();
        $this->arrStatus = $masterData->getMasterData('mtb_status');
        $this->arrRegion = $masterData->getMasterData('mtb_region');
        $this->arrCity = $masterData->getMasterData('mtb_city');
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
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $objQuery->setOrder("create_date DESC");

        $cols = 'product_id, currency, salary_type, salary_min, salary_max, region, city, work_location_vn, name_vn, main_list_comment_vn';
        $from = 'dtb_products';
        $where = 'del_flg = 0 AND status = 1 AND target = ?';

        $this->page = 'index';
        $uri = explode('/', $_SERVER['REQUEST_URI']);
        if(count($uri) > 2)
            $this->page = 'noindex';
        
        if ($this->page == 'index') {
            $objQuery->setLimit(5);
            $this->arrFirstColumnProducts = $objQuery->select($cols, $from, $where, array(2));
            $objQuery->setLimit(5);
            $this->arrSecondColumnProducts = $objQuery->select($cols, $from, $where, array(1));
        } else {
            $targetId = 1;
            if (strpos($_SERVER['REQUEST_URI'], '/user_data/vietnam.php') !== false)
                $targetId = 2;

            $where .= ' AND product_id IN (select product_id from dtb_product_status where product_status_id = ?)';
            $objQuery->setLimit(5);
            $this->arrFirstColumnProducts = $objQuery->select($cols, $from, $where, array($targetId, 1));
            $objQuery->setLimit(5);
            $this->arrSecondColumnProducts = $objQuery->select($cols, $from, $where, array($targetId, 2));
        }
        
        SC_Product_Ex::setBriefSalaryToProducts($this->arrFirstColumnProducts);
        SC_Product_Ex::setBriefSalaryToProducts($this->arrSecondColumnProducts);
    }

}
