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

    function func_return() {
        document.form1.mode.value = "return";
        document.form1.submit();
    }

//-->
</script>


<form name="form1" id="form1" method="post" action="?">
    <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
    <input type="hidden" name="mode" value="complete" />

    <!--{foreach from=$arrForm key=key item=item}-->
        <!--{if $key ne "mode" && $key ne "subm" && $key ne $smarty.const.TRANSACTION_ID_NAME}-->
            <!--{if $key == 'employment_status'}-->
                <!--{foreach item=statusVal from=$item}-->
                    <input type="hidden" name="<!--{$key}-->[]" value="<!--{$statusVal|h}-->" />
                <!--{/foreach}-->
            <!--{else}-->
                <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item|h}-->" />
            <!--{/if}-->
        <!--{/if}-->
    <!--{/foreach}-->

    <!-- 検索条件の保持 -->
    <!--{foreach from=$arrSearchData key="key" item="item"}-->
        <!--{if $key ne "client_id" && $key ne "mode" && $key ne "edit_client_id" && $key ne $smarty.const.TRANSACTION_ID_NAME}-->
            <!--{if is_array($item)}-->
                <!--{foreach item=c_item from=$item}-->
                    <input type="hidden" name="search_data[<!--{$key|h}-->][]" value="<!--{$c_item|h}-->" />
                <!--{/foreach}-->
            <!--{else}-->
                <input type="hidden" name="search_data[<!--{$key|h}-->]" value="<!--{$item|h}-->" />
            <!--{/if}-->
        <!--{/if}-->
    <!--{/foreach}-->

    <div id="customer" class="contents-main">
        <table class="form">
            <tr>
                <th>取引先ID</th>
                <td><!--{$arrForm.client_id|h}--></td>
            </tr>
            <tr>
                <th>取引先名</th>
                <td><!--{$arrForm.name|h}--></td>
            </tr>
            <tr>
                <th>取引先名（カナ）</th>
                <td><!--{$arrForm.kana|h}--></td>
            </tr>
            <tr>
                <th>代表者名</th>
                <td><!--{$arrForm.owner_name01|h}--><!--{$arrForm.owner_name02|h}-->　様</td>
            </tr>
            <tr>
                <th>郵便番号</th>
                <td>〒 <!--{$arrForm.zip01|h}--> - <!--{$arrForm.zip02|h}--></td>
            </tr>
            <tr>
                <th>本社住所</th>
                <td><!--{$arrPref[$arrForm.pref]|h}--><!--{$arrForm.addr01|h}--><!--{$arrForm.addr02|h}--></td>
            </tr>
            <tr>
                <th>TEL</th>
                <td><!--{$arrForm.tel|h}--></td>
            </tr>
            <tr>
                <th>FAX</th>
                <td><!--{$arrForm.fax|h}--></td>
            </tr>
            <tr>
                <th>基本契約締結日</th>
                <td><!--{if strlen($arrForm.contract_year) > 0 && strlen($arrForm.contract_month) > 0 && strlen($arrForm.contract_day) > 0}--><!--{$arrForm.contract_year|h}-->年<!--{$arrForm.contract_month|h}-->月<!--{$arrForm.contract_day|h}-->日<!--{else}-->未登録<!--{/if}--></td>
            </tr>
            <tr>
                <th>採用担当者名</th>
                <td><!--{$arrForm.hr_charger_name01|h}--><!--{$arrForm.hr_charger_name02|h}-->　様</td>
            </tr>
            <tr>
                <th>採用担当者連絡先</th>
                <td><!--{$arrForm.hr_charger_tel|h}--></td>
            </tr>
            <tr>
                <th>採用担当者メールアドレス</th>
                <td><!--{$arrForm.hr_charger_email|h}--></td>
            </tr>
            <tr>
                <th>お探しの人材</th>
                <td>
                    <!--{foreach from=$arrForm.employment_status item=status}-->
                        <!--{if $status != ""}-->
                            <!--{$arrEmploymentStatus[$status]}--> &nbsp; 
                        <!--{/if}-->
                    <!--{/foreach}-->
                </td>
            </tr>
            <tr>
                <th>備考（メモ）</th>
                <td><!--{$arrForm.memo|h|nl2br|default:"未登録"}--></td>
            </tr>
            <tr>
                <th>設立年月日</th>
                <td><!--{$arrForm.establishment_date|h}--><br /><span class="vn_value"><!--{$arrForm.establishment_date_vn|h}--></span></td>
            </tr>
            <tr>
                <th>資本金</th>
                <td><!--{$arrForm.capital|h}--><br /><span class="vn_value"><!--{$arrForm.capital_vn|h}--></span></td>
            </tr>
            <tr>
                <th>会社の規模</th>
                <td><!--{$arrForm.scale|h}--><br /><span class="vn_value"><!--{$arrForm.scale_vn|h}--></span></td>
            </tr>
            <tr>
                <th>事業部の簡単な情報</th>
                <td><!--{$arrForm.introduction|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.introduction_vn|h}--></span></td>
            </tr>
        </table>
        <div class="btn-area">
            <ul>
                <li><a class="btn-action" href="javascript:;" onclick="func_return(); return false;"><span class="btn-prev">編集画面に戻る</span></a></li>
                <li><a class="btn-action" href="javascript:;" onclick="eccube.fnFormModeSubmit('form1', 'complete', '', ''); return false;"><span class="btn-next">この内容で登録する</span></a></li>
            </ul>
        </div>
    </div>
</form>
