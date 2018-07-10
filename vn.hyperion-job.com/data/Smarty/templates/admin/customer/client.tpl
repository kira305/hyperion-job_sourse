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
    function fnReturn() {
        document.search_form.action = './client_search.php';
        document.search_form.submit();
        return false;
    }
//-->
</script>

<form name="search_form" id="search_form" method="post" action="">
    <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
    <input type="hidden" name="mode" value="search" />

    <!--{foreach from=$arrSearchData key="key" item="item"}-->
        <!--{if $key ne "client_id" && $key ne "mode" && $key ne "edit_client_id" && $key ne $smarty.const.TRANSACTION_ID_NAME}-->
            <!--{if is_array($item)}-->
                <!--{foreach item=c_item from=$item}-->
                    <input type="hidden" name="<!--{$key|h}-->[]" value="<!--{$c_item|h}-->" />
                <!--{/foreach}-->
            <!--{else}-->
                <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item|h}-->" />
            <!--{/if}-->
        <!--{/if}-->
    <!--{/foreach}-->
</form>

<form name="form1" id="form1" method="post" action="?" autocomplete="off">
    <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
    <input type="hidden" name="mode" value="<!--{if $page == 'input'}-->confirm<!--{else}-->complete<!--{/if}-->" />
    <input type="hidden" name="client_id" value="<!--{$arrForm.client_id|h}-->" />

    <!-- 検索条件の保持 -->
    <!--{foreach from=$arrSearchData key="key" item="item"}-->
        <!--{if $key ne "client_id" && $key ne "mode" && $key ne "edit_client_id" && $key ne $smarty.const.TRANSACTION_ID_NAME}-->
            <!--{if is_array($item)}-->
                <!--{foreach item=c_item from=$item}-->
                    <input type="hidden" name="<!--{$key|h}-->[]" value="<!--{$c_item|h}-->" />
                <!--{/foreach}-->
            <!--{else}-->
                <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item|h}-->" />
            <!--{/if}-->
        <!--{/if}-->
    <!--{/foreach}-->

    <div id="customer" class="contents-main">
        <table class="form">
            <!--{if $arrForm.client_id}-->
            <tr>
                <th>取引先ID</th>
                <td><!--{$arrForm.client_id|h}--></td>
            </tr>
            <!--{/if}-->
            <tr>
                <th>取引先名<span class="attention"> *</span></th>
                <td>
                    <span class="attention"><!--{$arrErr.name}--></span>
                    <input type="text" name="name" value="<!--{$arrForm.name|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.name != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60" />
                </td>
            </tr>
            <tr>
                <th>取引先名（カナ）</th>
                <td>
                    <span class="attention"><!--{$arrErr.kana}--></span>
                    <input type="text" name="kana" value="<!--{$arrForm.kana|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.kana != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60" />
                </td>
            </tr>
            <tr>
                <th>代表者名</th>
                <td>
                    <span class="attention"><!--{$arrErr.owner_name01}--><!--{$arrErr.owner_name02}--></span>
                    性 <input type="text" name="owner_name01" value="<!--{$arrForm.owner_name01|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.owner_name01 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="30" class="box30" />
                    名 <input type="text" name="owner_name02" value="<!--{$arrForm.owner_name02|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.owner_name02 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="30" class="box30" />
                </td>
            </tr>
            <tr>
                <th>郵便番号</th>
                <td>
                    <span class="attention"><!--{$arrErr.zip01}--><!--{$arrErr.zip02}--></span>
                    〒&nbsp;<input type="text" name="zip01" value="<!--{$arrForm.zip01|h}-->" maxlength="<!--{$smarty.const.ZIP01_LEN}-->" <!--{if $arrErr.zip01 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="6" class="box6" /> - <input type="text" name="zip02" value="<!--{$arrForm.zip02|h}-->" maxlength="<!--{$smarty.const.ZIP02_LEN}-->" <!--{if $arrErr.zip02 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="6" class="box6" />
                    <a class="btn-normal" href="javascript:;" name="address_input" onclick="eccube.getAddress('<!--{$smarty.const.INPUT_ZIP_URLPATH}-->', 'zip01', 'zip02', 'pref', 'addr01'); return false;">住所入力</a>
                </td>
            </tr>
            <tr>
                <th>住所</th>
                <td>
                    <span class="attention"><!--{$arrErr.pref}--><!--{$arrErr.addr01}--></span>
                    <select name="pref" <!--{if $arrErr.pref != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                        <option value="" selected="selected">都道府県を選択</option>
                        <!--{html_options options=$arrPref selected=$arrForm.pref}-->
                    </select><br />
                    <input type="text" name="addr01" value="<!--{$arrForm.addr01|h}-->" <!--{if $arrErr.addr01 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60" /><br />
                    <!--{$smarty.const.SAMPLE_ADDRESS1}-->
                </td>
            </tr>
            <tr>
                <th>TEL</th>
                <td>
                    <span class="attention"><!--{$arrErr.tel}--></span>
                    <input type="text" name="tel" value="<!--{$arrForm.tel|h}-->" <!--{if $arrErr.tel != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60" />
                </td>
            </tr>
            <tr>
                <th>FAX</th>
                <td>
                    <span class="attention"><!--{$arrErr.fax}--></span>
                    <input type="text" name="fax" value="<!--{$arrForm.fax|h}-->" <!--{if $arrErr.fax != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60" />
                </td>
            </tr>
            <tr>
                <th>基本契約締結日</th>
                <td>
                    <span class="attention"><!--{$arrErr.contract_year}--><!--{$arrErr.contract_month}--><!--{$arrErr.contract_day}--></span>
                    <select name="contract_year" <!--{if $arrErr.contract_year != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                        <!--{html_options options=$arrYear selected=$arrForm.contract_year|default:""}-->
                    </select>年
                    <select name="contract_month" <!--{if $arrErr.contract_month != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                        <!--{html_options options=$arrMonth selected=$arrForm.contract_month|default:""}-->
                    </select>月
                    <select name="contract_day" <!--{if $arrErr.contract_day != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                        <!--{html_options options=$arrDay selected=$arrForm.contract_day|default:""}-->
                    </select>日
                </td>
            </tr>
            <tr>
                <th>採用担当者名</th>
                <td>
                    <span class="attention"><!--{$arrErr.hr_charger_name01}--><!--{$arrErr.hr_charger_name02}--></span>
                    性 <input type="text" name="hr_charger_name01" value="<!--{$arrForm.hr_charger_name01|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.hr_charger_name01 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="30" class="box30" />
                    名 <input type="text" name="hr_charger_name02" value="<!--{$arrForm.hr_charger_name02|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.hr_charger_name02 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="30" class="box30" />
                </td>
            </tr>
            <tr>
                <th>採用担当者連絡先</th>
                <td>
                    <span class="attention"><!--{$arrErr.hr_charger_tel}--></span>
                    <input type="text" name="hr_charger_tel" value="<!--{$arrForm.hr_charger_tel|h}-->" <!--{if $arrErr.hr_charger_tel != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60" />
                </td>
            </tr>
            <tr>
                <th>採用担当者メールアドレス</th>
                <td>
                    <span class="attention"><!--{$arrErr.hr_charger_email}--></span>
                    <input type="text" name="hr_charger_email" value="<!--{$arrForm.hr_charger_email|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.hr_charger_email != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60" />
                </td>
            </tr>
            <tr>
                <th>雇用形態</th>
                <td>
                    <span class="attention"><!--{$arrErr.employment_status}--></span>
                    <!--{html_checkboxes name="employment_status" options=$arrEmploymentStatus selected=$arrForm.employment_status separator='&nbsp;&nbsp;'}-->
                </td>
            </tr>
            <tr>
                <th>備考（メモ）</th>
                <td>
                    <span class="attention"><!--{$arrErr.memo}--></span>
                    <textarea name="memo" cols="60" rows="8" class="area60" maxlength="99999"><!--{$arrForm.memo|h}--></textarea>
                </td>
            </tr>
            <tr>
                <th>設立年月日</th>
                <td>
                    <span class="attention"><!--{$arrErr.establishment_date}--></span>
                    <input type="text" name="establishment_date" value="<!--{$arrForm.establishment_date|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.establishment_date != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60 top" />
                    <br />
                    <span class="attention"><!--{$arrErr.establishment_date_vn}--></span>
                    <input type="text" name="establishment_date_vn" value="<!--{$arrForm.establishment_date_vn|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.establishment_date_vn != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60 vn_field" />
                </td>
            </tr>
            <tr>
                <th>資本金</th>
                <td>
                    <span class="attention"><!--{$arrErr.capital}--></span>
                    <input type="text" name="capital" value="<!--{$arrForm.capital|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.capital != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60 top" />
                    <br />
                    <span class="attention"><!--{$arrErr.capital_vn}--></span>
                    <input type="text" name="capital_vn" value="<!--{$arrForm.capital_vn|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.capital_vn != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60 vn_field" />
                </td>
            </tr>
            <tr>
                <th>会社の規模</th>
                <td>
                    <span class="attention"><!--{$arrErr.scale}--></span>
                    <input type="text" name="scale" value="<!--{$arrForm.scale|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.scale != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60 top" />
                    <br />
                    <span class="attention"><!--{$arrErr.scale_vn}--></span>
                    <input type="text" name="scale_vn" value="<!--{$arrForm.scale_vn|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" <!--{if $arrErr.scale_vn != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60 vn_field" />
                </td>
            </tr>
            <tr>
                <th>事業部の簡単な情報</th>
                <td>
                    <span class="attention"><!--{$arrErr.introduction}--></span>
                    <textarea name="introduction" cols="60" rows="8" class="area60 top" maxlength="99999"><!--{$arrForm.introduction|h}--></textarea>
                    <br />
                    <span class="attention"><!--{$arrErr.introduction_vn}--></span>
                    <textarea name="introduction_vn" cols="60" rows="8" class="area60 vn_field" maxlength="99999"><!--{$arrForm.introduction_vn|h}--></textarea>
                </td>
            </tr>
        </table>

        <div class="btn-area">
            <ul>
                <li><a class="btn-action" href="javascript:;" onclick="return fnReturn();"><span class="btn-prev">検索画面に戻る</span></a></li>
                <li>
                    <a class="btn-action" href="javascript:;" onclick="fnSetFormSubmit('form1', 'mode', 'confirm');return false;">
                        <span class="btn-next">確認ページへ</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</form>