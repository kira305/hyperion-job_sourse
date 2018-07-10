<!--{*
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
*}-->

<div id="home">
    <!--{* メインエリア *}-->
    <div id="home-main">
        <form name="form1" id="form1" method="post" action="#">
            <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
            <!--{* 直近の状況ここから *}-->
            <h2>直近の状況</h2>
            <table summary="直近の状況" class="shop-info">
                <tr>
                    <th>現在の会員数</th>
                    <td><!--{$customer_cnt|default:"0"|n2s}-->名</td>
                </tr>
                <tr>
                    <th>現在の求人数</th>
                    <td><!--{$job_cnt|default:"0"|n2s}-->件</td>
                </tr>
            </table>
            <!--{* 直近の状況ここまで *}-->

            <!--{* 新規受付一覧ここから *}-->
            <h2>応募一覧</h2>
            <table summary="新規受付一覧" id="home-order">
                <col width="5%" />
                <col width="15%" />
                <col width="10%" />
                <col width="8%" />
                <col width="8%" />
                <col width="7%" />
                <tr>
                    <th class="center" rowspan="2">仕事ID</th>
                    <th class="center" rowspan="2">仕事名称</th>
                    <th class="center" rowspan="2">職種</th>
                    <th class="center" rowspan="2">雇用形態</th>
                    <th class="center" >お名前</th>
                    <th class="center" rowspan="2">応募日</th>
                </tr>
                <tr>
                    <th class="center">ID</th>
                </tr>
                <!--{section name=i loop=$arrNewOrder}-->
                <tr>
                    <td rowspan="2"><!--{$arrNewOrder[i].product_id|h}--></td>
                    <td rowspan="2"><!--{$arrNewOrder[i].job_name|h}--></td>
                    <td rowspan="2"><!--{$arrNewOrder[i].category_name}--></td>
                    <td rowspan="2"><!--{$arrNewOrder[i].employment_status|h}--></td>
                    <td ><!--{$arrNewOrder[i].customer_name|h}--> </td>
                    <td rowspan="2"><!--{$arrNewOrder[i].create_date}--></td>
                </tr>
                <tr>
                    <td><!--{$arrNewOrder[i].customer_id}--></td>
                </tr>
                <!--{/section}-->
            </table>
            <!--{* 新規受付一覧ここまで *}-->

        </form>
    </div>
    <!--{* メインエリア *}-->

</div>
