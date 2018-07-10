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

<form name="form1" id="form1" method="post" action="?" enctype="multipart/form-data">
<input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
<input type="hidden" name="mode" value="complete" />
<!--{foreach key=key item=item from=$arrSearchHidden}-->
    <!--{if is_array($item)}-->
        <!--{foreach item=c_item from=$item}-->
            <input type="hidden" name="<!--{$key|h}-->[]" value="<!--{$c_item|h}-->" />
        <!--{/foreach}-->
    <!--{else}-->
        <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item|h}-->" />
    <!--{/if}-->
<!--{/foreach}-->
<!--{foreach key=key item=item from=$arrForm}-->
    <!--{if $key == 'category_id' || $key == 'product_status' || $key == 'sex' || $key == 'welfare' || $key == 'selection_process'}-->
        <!--{foreach item=statusVal from=$item}-->
            <input type="hidden" name="<!--{$key}-->[]" value="<!--{$statusVal|h}-->" />
        <!--{/foreach}-->
    <!--{elseif $key == 'arrFile'}-->
        <!--{* nop *}-->
    <!--{else}-->
        <input type="hidden" name="<!--{$key}-->" value="<!--{$item|h}-->" />
    <!--{/if}-->
<!--{/foreach}-->
<div id="products" class="contents-main">

    <table>
        <tr>
            <th>ダミーフラグ</th>
            <td>
                <!--{$arrDummyFlg[$arrForm.dummy_flg]|h}-->
            </td>
        </tr>
        <tr>
            <th>求人名</th>
            <td>
                <!--{$arrForm.name|h}--><br /><span class="vn_value"><!--{$arrForm.name_vn|h}--></span>
            </td>
        </tr>
        <tr>
            <th>求人ステータス</th>
            <td>
                <!--{foreach from=$arrForm.product_status item=status}-->
                    <!--{if $status != ""}-->
                        <!--{$arrSTATUS[$status]}--> &nbsp; 
                    <!--{/if}-->
                <!--{/foreach}-->
            </td>
        </tr>
        <tr>
            <th>公開・非公開</th>
            <td>
                <!--{$arrDISP[$arrForm.status]}-->
            </td>
        </tr>
        <tr>
            <th>検索ワード</th>
            <td>
                <!--{$arrForm.comment3|h}-->
            </td>
        </tr>
        <tr>
            <th>備考欄(SHOP専用)</th>
            <td>
                <!--{$arrForm.note|h|nl2br}-->
            </td>
        </tr>
        <tr>
            <th>画像</th>
            <td>
                <!--{assign var=key value="main_large_image"}-->
                <!--{if $arrForm.arrFile[$key].filepath != ""}-->
                    <img src="<!--{$arrForm.arrFile[$key].filepath}-->" alt="<!--{$arrForm.name|h}-->" /><br />
                <!--{/if}-->
            </td>
        </tr>
        <tr>
            <th>ポジション</th>
            <td>
                <!--{$arrPosition[$arrForm.position]|h}-->
            </td>
        </tr>
        <tr>
            <th>掲載終了日</th>
            <td>
                <!--{if strlen($arrForm.end_year) > 0 && strlen($arrForm.end_month) > 0 && strlen($arrForm.end_day) > 0}--><!--{$arrForm.end_year|h}-->年<!--{$arrForm.end_month|h}-->月<!--{$arrForm.end_day|h}-->日<!--{else}-->未登録<!--{/if}-->
            </td>
        </tr>
        <tr>
            <th>求人数</th>
            <td>
                <!--{$arrForm.offer_number|h}-->
            </td>
        </tr>
        <tr>
            <th>対象</th>
            <td>
                <!--{$arrTarget[$arrForm.target]|h}-->
            </td>
        </tr>
        <tr>
            <th>雇用形態</th>
            <td>
                <!--{$arrEmploymentStatus[$arrForm.employment_status]|h}-->
            </td>
        </tr>
        <tr>
            <th>給与区分</th>
            <td>
                <!--{$arrSalaryType[$arrForm.salary_type]|h}-->
            </td>
        </tr>
        <tr>
            <th>通貨</th>
            <td>
                <!--{$arrCurrency[$arrForm.currency]|h}-->
            </td>
        </tr>
        <tr>
            <th>給与上限</th>
            <td>
                <!--{$arrForm.salary_min|h}-->
            </td>
        </tr>
        <tr>
            <th>給与下限</th>
            <td>
                <!--{$arrForm.salary_max|h}-->
            </td>
        </tr>
        <tr>
            <th>給与詳細</th>
            <td>
                <!--{$arrForm.salary|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.salary_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>為替相場</th>
            <td>
                <!--{$arrForm.exchange_rate|h}-->
            </td>
        </tr>
        <tr>
            <th>職種</th>
            <td>
                <!--{foreach from=$arrForm.category_id item=status}-->
                    <!--{if $status != ""}-->
                        <!--{$arrCategory[$status]}--> &nbsp; 
                    <!--{/if}-->
                <!--{/foreach}-->
            </td>
        </tr>
        <tr>
            <th>勤務地</th>
            <td>
                <!--{$arrRegion[$arrForm.region]|h}--> <!--{$arrCityByRegion[$arrForm.region][$arrForm.city]|h}--><br />
                <!--{$arrForm.work_location|h}--><br /><span class="vn_value"><!--{$arrForm.work_location_vn|h}--></span>
            </td>
        </tr>
        <tr>
            <th>交通アクセス</th>
            <td>
                <!--{$arrForm.traffic_access|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.traffic_access_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>勤務時間</th>
            <td>
                <!--{$arrForm.working_hour|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.working_hour_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>勤務曜日</th>
            <td>
                <!--{$arrForm.working_day|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.working_day_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>昼休み時間</th>
            <td>
                <!--{$arrForm.lunch_time|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.lunch_time_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>試用期間</th>
            <td>
                <!--{$arrForm.trial_period|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.trial_period_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>簡単な仕事情報</th>
            <td>
                <!--{$arrForm.main_list_comment|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.main_list_comment_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>仕事詳細</th>
            <td>
                <!--{$arrForm.main_comment|nl2br_html}--><br /><span class="vn_value"><!--{$arrForm.main_comment_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>性別</th>
            <td>
                <!--{foreach from=$arrForm.sex item=status}-->
                    <!--{if $status != ""}-->
                        <!--{$arrSex[$status]}--> &nbsp; 
                    <!--{/if}-->
                <!--{/foreach}-->
            </td>
        </tr>
        <tr>
            <th>資格</th>
            <td>
                <!--{$arrForm.qualification|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.qualification_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>性格</th>
            <td>
                <!--{$arrForm.personality|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.personality_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>経験・スキルの詳細</th>
            <td>
                <!--{$arrForm.skill|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.skill_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>昇給</th>
            <td>
                <!--{$arrForm.payrise|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.payrise_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>賞与</th>
            <td>
                <!--{$arrForm.bonus|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.bonus_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>保険</th>
            <td>
                <!--{$arrForm.insurance|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.insurance_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>福利</th>
            <td>
                <!--{foreach from=$arrForm.welfare item=status}-->
                    <!--{if $status != ""}-->
                        <!--{$arrWelfare[$status]}--> &nbsp; 
                    <!--{/if}-->
                <!--{/foreach}-->
            </td>
        </tr>
        <tr>
            <th>その他の福利</th>
            <td>
                <!--{$arrForm.other_welfare|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.other_welfare_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>健康診断</th>
            <td>
                <!--{$arrForm.medical_checkup|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.medical_checkup_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>応募方法</th>
            <td>
                <!--{$arrForm.applicate_method|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.applicate_method_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>選考プロセス</th>
            <td>
                <!--{foreach from=$arrForm.selection_process item=status}-->
                    <!--{if $status != ""}-->
                        <!--{$arrProcess[$status]}--><br /> 
                    <!--{/if}-->
                <!--{/foreach}-->
            </td>
        </tr>
        <tr>
            <th>コンシェルジュ</th>
            <td>
                <!--{$arrConcierge[$arrForm.concierge]|h}-->
            </td>
        </tr>
        <tr>
            <th>企業ID</th>
            <td>
                <!--{$arrForm.client_id|h}-->
            </td>
        </tr>
        <tr>
            <th>会社紹介</th>
            <td>
                <!--{$arrForm.client_introduction|h|nl2br}--><br /><span class="vn_value"><!--{$arrForm.client_introduction_vn|h|nl2br}--></span>
            </td>
        </tr>
        <tr>
            <th>企業の本社住所</th>
            <td>
                〒 <!--{$arrForm.client_zip01|h}--> - <!--{$arrForm.client_zip02|h}--><br />
                <!--{$arrPref[$arrForm.client_pref]|h}--><!--{$arrForm.client_addr01|h}-->
            </td>
        </tr>

        <!--{* オペビルダー用 *}-->
        <!--{if "sfViewAdminOpe"|function_exists === TRUE}-->
            <!--{include file=`$smarty.const.MODULE_REALDIR`mdl_opebuilder/admin_ope_view.tpl}-->
        <!--{/if}-->
    </table>

    <div class="btn-area">
        <ul>
            <li><a class="btn-action" href="javascript:;" onclick="eccube.setModeAndSubmit('confirm_return','',''); return false;"><span class="btn-prev">前のページに戻る</span></a></li>
            <li><a class="btn-action" href="javascript:;" onclick="document.form1.submit(); return false;"><span class="btn-next">この内容で登録する</span></a></li>
        </ul>
    </div>
</div>
</form>
