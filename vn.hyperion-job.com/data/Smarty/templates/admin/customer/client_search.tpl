<!--{*
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
*}-->

<script type="text/javascript">
<!--

    function fnDelete(client_id) {
        if (confirm('この取引先を削除しても宜しいですか？')) {
            document.form1.mode.value = "delete"
            document.form1['edit_client_id'].value = client_id;
            document.form1.submit();
            return false;
        }
    }

    function fnEdit(client_id) {
        document.form1.action = './client.php';
        document.form1.mode.value = "edit_search";
        document.form1['edit_client_id'].value = client_id;
        document.form1.search_pageno.value = 1;
        document.form1.submit();
        return false;
    }
//-->
</script>


<div id="customer" class="contents-main">
    <form name="search_form" id="search_form" method="post" action="?">
        <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
        <input type="hidden" name="mode" value="search" />

        <h2>検索条件設定</h2>
        
        <!--検索条件設定テーブルここから-->
        <table class="form">
            <tr>
                <th>取引先ID</th>
                <td>
                    <!--{assign var=key value="search_client_id"}-->
                    <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><br /><!--{/if}-->
                    <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="30" class="box30" <!--{if $arrErr[$key]}--><!--{sfSetErrorStyle}--><!--{/if}--> />
                </td>
                <th>取引先名</th>
                <td>
                    <!--{assign var=key value="search_name"}-->
                    <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><br /><!--{/if}-->
                    <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="30" class="box30" <!--{if $arrErr[$key]}--><!--{sfSetErrorStyle}--><!--{/if}--> /></td>
                </td>
            </tr>
            <tr>
                <th>TEL</th>
                <td>
                    <!--{assign var=key value="search_tel"}-->
                    <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><br /><!--{/if}-->
                    <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="30" class="box30" />
                </td>
                <th>雇用形態</th>
                <td>
                    <!--{assign var=key value="search_employment_status"}-->
                    <span class="attention"><!--{$arrErr[$key]|h}--></span>
                    <!--{html_checkboxes name="$key" options=$arrEmploymentStatus selected=$arrForm[$key].value}-->
                </td>
            </tr>
            <tr>
                <th>代表者名</th>
                <td>
                    <!--{assign var=key value="search_owner_name"}-->
                    <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><br /><!--{/if}-->
                    <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="30" class="box30" <!--{if $arrErr[$key]}--><!--{sfSetErrorStyle}--><!--{/if}--> />
                </td>
                <th>担当者</th>
                <td>
                    <!--{assign var=key value="search_hr_charger_name"}-->
                    <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><br /><!--{/if}-->
                    <input type="text" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" value="<!--{$arrForm[$key].value|h}-->" size="30" class="box30" <!--{if $arrErr[$key]}--><!--{sfSetErrorStyle}--><!--{/if}--> />
                </td>
            </tr>
        </table>
        <div class="btn">
            <p class="page_rows">検索結果表示件数
            <select name="search_page_max">
                <!--{html_options options=$arrPageMax selected=$arrForm.search_page_max}-->
            </select> 件</p>
            <div class="btn-area">
                <ul>
                    <li><a class="btn-action" href="javascript:;" onclick="eccube.fnFormModeSubmit('search_form', 'search', '', ''); return false;"><span class="btn-next">この条件で検索する</span></a></li>
                </ul>
            </div>
        </div>
    </form>
    <!--{if count($arrErr) == 0 and ($smarty.post.mode == 'search' or $smarty.post.mode == 'delete')}-->

    <!--★★検索結果一覧★★-->
    <form name="form1" id="form1" method="post" action="?">
        <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
        <input type="hidden" name="mode" value="search" />
        <input type="hidden" name="edit_client_id" value="" />
        <!--{foreach key=key item=item from=$arrHidden}-->
            <!--{if is_array($item)}-->
                <!--{foreach item=c_item from=$item}-->
                    <input type="hidden" name="<!--{$key|h}-->[]" value="<!--{$c_item|h}-->" />
                <!--{/foreach}-->
            <!--{else}-->
                <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item|h}-->" />
            <!--{/if}-->
        <!--{/foreach}-->

        <h2>検索結果一覧</h2>
        <div class="btn">
            <span class="attention"><!--検索結果数--><!--{$tpl_linemax}-->件</span>&nbsp;が該当しました。
        </div>
        <!--{if count($arrData) > 0}-->

        <!--{include file=$tpl_pager}-->

        <!--検索結果表示テーブル-->
        <table class="list" id="customer-search-result">
            <col width="20%" />
            <col width="22%" />
            <col width="14%" />
            <col width="20%" />
            <col width="7%" />
            <col width="7%" />
            <col width="10%" />
            <tr>
                <th>取引先ID</th>
                <th>取引先名</th>
                <th>TEL</th>
                <th rowspan="2">担当者</th>
                <th rowspan="2">編集</th>
                <th rowspan="2">削除</th>
            </tr>
            <tr>
                <th>都道府県</th>
                <th>代表者名</th>
                <th>FAX</th>
            </tr>
            <!--{foreach from=$arrData item=row}-->
            <tr>
                <td><!--{$row.client_id|h}--></td>
                <td><!--{$row.name|h}--></td>
                <td class="center"><!--{$row.tel}--></td>
                <td rowspan="2"><!--{$row.hr_charger_name01|h}--> <!--{$row.hr_charger_name02|h}--></td>
                <td class="center" rowspan="2"><span class="icon_edit"><a href="#" onclick="return fnEdit('<!--{$row.client_id|h}-->');">編集</a></span></td>
                <td class="center" rowspan="2"><span class="icon_delete"><a href="#" onclick="return fnDelete('<!--{$row.client_id|h}-->');">削除</a></span></td>
            </tr>
            <tr>
                <td><!--{assign var=pref value=$row.pref}--><!--{$arrPref[$pref]}--></td>
                <td><!--{$row.owner_name01}--> <!--{$row.owner_name02}--></td>
                <td class="center"><!--{$row.fax}--></td>
            </tr>
            <!--{/foreach}-->
        </table>
        <!--検索結果表示テーブル-->

        <!--{/if}-->
    </form>
    <!--★★検索結果一覧★★-->

    <!--{/if}-->
</div>
