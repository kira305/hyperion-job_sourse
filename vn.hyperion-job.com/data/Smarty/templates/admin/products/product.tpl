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
<link rel="stylesheet" href="<!--{$TPL_URLPATH}-->jquery.multiselect2side/css/jquery.multiselect2side.css" type="text/css" media="screen" />
<style>
    #products label {
        white-space: normal;
        display: inline-block;
    }
</style>

<script type="text/javascript" src="<!--{$TPL_URLPATH}-->jquery.multiselect2side/js/jquery.multiselect2side.js" ></script>
<script type="text/javascript">
    // 表示非表示切り替え
    function lfDispSwitch(id){
        var obj = document.getElementById(id);
        if (obj.style.display == 'none') {
            obj.style.display = '';
        } else {
            obj.style.display = 'none';
        }
    }

    // 求人種別によってダウンロード求人のフォームの表示非表示を切り替える
    function toggleDownloadFileForms(value) {
        if (value == '2') {
            $('.type-download').show('fast');
        } else {
            $('.type-download').hide('fast');
        }
    }

    $(function(){
        var form_product_type = $('input[name=product_type_id]');
        form_product_type.click(function(){
            toggleDownloadFileForms(form_product_type.filter(':checked').val());
        });
        toggleDownloadFileForms(form_product_type.filter(':checked').val());
        
        $('#selection_process').multiselect2side({
            selectedPosition: 'right',
            moveOptions: true,
            labelsx: '出力しない項目',
            labeldx: '出力する項目',
            labelTop: '一番上',
            labelBottom: '一番下',
            labelUp: '一つ上',
            labelDown: '一つ下',
            labelSort: '項目順序'
        });
        // multiselect2side の初期選択を解除
        $('.ms2side__div select').val(null);
        // [Sort] ボタンは混乱防止のため非表示
        // FIXME 選択・非選択のボタンと比べて、位置ズレしている
        $('.ms2side__div .SelSort').hide();
        
        $('select[name=region]').change(function(){
            $("select[name=city]").find('option').not(':first').remove();
            if($(this).val() !== '' && $(this).val() > 0){
                <!--{foreach key=key item=item from=$arrCityByRegion}-->
                    if($(this).val() == <!--{$key}-->){
                        <!--{foreach key=c_key item=c_item  from=$item}-->
                            $("select[name=city]").append( $("<option>")
                                .val("<!--{$c_key}-->")
                                .html("<!--{$c_item}-->")
                            );
                        <!--{/foreach}-->
                    }
                <!--{/foreach}-->
                
            }
        });
              
        var targetId = 0;
        if($('input[name=target]:checked').length > 0){
            targetId = $('input[name=target]:checked').val();
        }
                
        var employmentStatus = $('input[name=employment_status]').closest('span');
        $('input[name=target]').change(function(){
            if(targetId > 0 && targetId != $(this).val() || targetId == 0 && $(this).val() == 2){
                var employmentStatusId = 0;
                if($('input[name=employment_status]:checked').length > 0){
                    employmentStatusId = $('input[name=employment_status]:checked').val();
                }
                employmentStatus.html('');
                <!--{foreach key=key item=item from=$arrEmploymentStatusByTarget}-->
                    if($(this).val() == <!--{$key}-->){
                        <!--{foreach key=c_key item=c_item  from=$item}-->
                            var label = $('<label />', { text: '<!--{$c_item}-->' });
                            var input = $('<input />', { type: 'radio', name: 'employment_status', value: <!--{$c_key}--> });
                            label.prepend(input);
                            employmentStatus.append(label);
                            employmentStatus.append('&nbsp;&nbsp;');
                        <!--{/foreach}-->
                    }
                <!--{/foreach}-->
                targetId = $(this).val();
                if(employmentStatusId > 0){
                    $('input[name=employment_status][value=' + employmentStatusId + ']').prop('checked', 'checked');
                }
            }
        });
        
        var prevTarget = 0;
        if(parseInt('<!--{$arrForm.employment_status}-->', 10) == 1)  {
            prevTarget = 2;
        } else if (parseInt('<!--{$arrForm.employment_status}-->', 10) == 2 || parseInt('<!--{$arrForm.employment_status}-->', 10) == 3) {
            prevTarget = 1;
        }
        
        var salaryType = $('input[name=salary_type]').closest('span');
        var currency = $('input[name=currency]').closest('span');
        var categoryId = $('input[name="category_id[]"]').closest('span');
        $("body").on("click", "input[name=employment_status]", function (e) {
            if( $(this).val() == 2 || $(this).val() == 3 ){
                $("input[name='position']").closest('tr').find('th span').hide();
                $("textarea[name='salary']").closest('tr').find('th span').hide();
            } else {
                $("input[name='position']").closest('tr').find('th span').show();
                $("textarea[name='salary']").closest('tr').find('th span').show();
            }
        
            var target = detectTargetByEmpStatus();
            if(prevTarget != target){
                salaryType.html('');
                currency.html('');
                categoryId.html('');
                <!--{foreach key=key item=item from=$arrSalaryTypeByTarget}-->
                    if(target == <!--{$key}-->){
                        <!--{foreach key=c_key item=c_item  from=$item}-->
                            var label = $('<label />', { text: '<!--{$c_item}-->' });
                            var input = $('<input />', { type: 'radio', name: 'salary_type', value: <!--{$c_key}--> });
                            label.prepend(input);
                            salaryType.append(label);
                            salaryType.append('&nbsp;&nbsp;');
                        <!--{/foreach}-->
                    }
                <!--{/foreach}-->
                <!--{foreach key=key item=item from=$arrCurrencyByTarget}-->
                    if(target == <!--{$key}-->){
                        <!--{foreach key=c_key item=c_item  from=$item}-->
                            var label = $('<label />', { text: '<!--{$c_item}-->' });
                            var input = $('<input />', { type: 'radio', name: 'currency', value: <!--{$c_key}--> });
                            label.prepend(input);
                            currency.append(label);
                            currency.append('&nbsp;&nbsp;');
                        <!--{/foreach}-->
                    }
                <!--{/foreach}-->
                <!--{foreach key=key item=item from=$arrCategoryByTarget}-->
                    if(target == <!--{$key}-->){
                        <!--{foreach key=c_key item=c_item  from=$item}-->
                            var label = $('<label />', { text: '<!--{$c_item}-->' });
                            var input = $('<input />', { type: 'checkbox', name: 'category_id[]', value: <!--{$c_key}--> });
                            label.prepend(input);
                            categoryId.append(label);
                            categoryId.append('&nbsp;&nbsp;');
                        <!--{/foreach}-->
                    }
                <!--{/foreach}-->
                prevTarget = target;
            }
        });
        
        function detectTargetByEmpStatus(){
            var target = 0;
            <!--{foreach key=key item=item  from=$arrTargetByEmploymentStatus}-->
                if($('input[name="employment_status"]:checked').val() == <!--{$key}-->){
                    target = '<!--{$item}-->';
                }
            <!--{/foreach}-->
            return target;
        }
    })
</script>
<style>.ms2side__options, .ms2side__updown { width: 60px !important; }</style>

<form name="form1" id="form1" method="post" action="?" enctype="multipart/form-data">
<input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
<!--{foreach key=key item=item from=$arrSearchHidden}-->
    <!--{if is_array($item)}-->
        <!--{foreach item=c_item from=$item}-->
        <input type="hidden" name="<!--{$key|h}-->[]" value="<!--{$c_item|h}-->" />
        <!--{/foreach}-->
    <!--{else}-->
        <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item|h}-->" />
    <!--{/if}-->
<!--{/foreach}-->
<input type="hidden" name="mode" value="edit" />
<input type="hidden" name="image_key" value="" />
<input type="hidden" name="down_key" value="" />
<input type="hidden" name="product_id" value="<!--{$arrForm.product_id|h}-->" />
<input type="hidden" name="product_class_id" value="<!--{$arrForm.product_class_id|h}-->" />
<input type="hidden" name="copy_product_id" value="<!--{$arrForm.copy_product_id|h}-->" />
<input type="hidden" name="anchor_key" value="" />
<input type="hidden" name="select_recommend_no" value="" />
<input type="hidden" name="has_product_class" value="<!--{$arrForm.has_product_class|h}-->" />
<input type="hidden" name="edit_client_id" value="" />
<!--{foreach key=key item=item from=$arrForm.arrHidden}-->
<input type="hidden" name="<!--{$key}-->" value="<!--{$item|h}-->" />
<!--{/foreach}-->
<div id="products" class="contents-main">
    <h2>基本情報</h2>

    <table class="form">
        <tr>
            <th>求人ID</th>
            <td><!--{$arrForm.product_id|h}--></td>
        </tr>
        <tr>
            <th>ダミーフラグ<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.dummy_flg}--></span>
                <span <!--{if $arrErr.dummy_flg != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                    <!--{html_radios name="dummy_flg" options=$arrDummyFlg selected=$arrForm.dummy_flg separator='&nbsp;&nbsp;'}-->
                </span>
            </td>
        </tr>
        <tr>
            <th>仕事名<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.name}--><!--{$arrErr.name_vn}--></span>
                <input type="text" name="name" value="<!--{$arrForm.name|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{if $arrErr.name != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->" size="60" class="box60 top" />
                <span class="attention"> (上限<!--{$smarty.const.STEXT_LEN}-->文字)</span>
                <br />
                <input type="text" name="name_vn" value="<!--{$arrForm.name_vn|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{if $arrErr.name_vn != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->" size="60" class="box60 vn_field" />
                <span class="attention"> (上限<!--{$smarty.const.STEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th><span class="attention2">求人ステータス</span></th>
            <td>
                <!--{html_checkboxes name="product_status" options=$arrSTATUS selected=$arrForm.product_status separator='&nbsp;&nbsp;'}-->
            </td>
        </tr>
        <tr>
            <th>公開・非公開<span class="attention"> *</span></th>
            <td>
                <!--{html_radios name="status" options=$arrDISP selected=$arrForm.status separator='&nbsp;&nbsp;'}-->
            </td>
        </tr>
        <!--{if $arrForm.has_product_class == false}-->
        <input type="hidden" name="product_type_id" value="<!--{$arrForm.product_type_id}-->" />
        <input type="hidden" name="price02" value="0" />
        <input type="hidden" name="stock_unlimited" value="1" />
        <!--{/if}-->
        <input type="hidden" name="point_rate" value="0" />
        <tr>
            <th>検索ワード<br />※複数の場合は、カンマ( , )区切りで入力して下さい</th>
            <td>
                <span class="attention"><!--{$arrErr.comment3}--></span>
                <textarea name="comment3" cols="60" rows="8" class="area60" maxlength="<!--{$smarty.const.LLTEXT_LEN}-->" style="<!--{$arrErr.comment3|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.comment3|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.LLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <!--{assign var=key value="main_large_image"}-->
            <th>画像<br />[<!--{$smarty.const.LARGE_IMAGE_WIDTH}-->×<!--{$smarty.const.LARGE_IMAGE_HEIGHT}-->]</th>
            <td>
                <a name="<!--{$key}-->"></a>
                <span class="attention"><!--{$arrErr[$key]}--></span>
                <!--{if $arrForm.arrFile[$key].filepath != ""}-->
                <img src="<!--{$arrForm.arrFile[$key].filepath}-->" alt="<!--{$arrForm.name|h}-->" />　<a href="" onclick="eccube.setModeAndSubmit('delete_image', 'image_key', '<!--{$key}-->'); return false;">[画像の取り消し]</a><br />
                <!--{/if}-->
                <input type="file" name="<!--{$key}-->" size="40" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" />
                <a class="btn-normal" href="javascript:;" name="btn" onclick="eccube.setModeAndSubmit('upload_image', 'image_key', '<!--{$key}-->'); return false;">アップロード</a>
            </td>
        </tr>
        <tr>
            <th>掲載終了日</th>
            <td>
                <span class="attention"><!--{$arrErr.end_year}--></span>
                <select name="end_year" <!--{if $arrErr.end_year != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> >
                    <option value="" selected="selected">------</option>
                    <!--{html_options options=$arrEndYear selected=$arrForm.end_year}-->
                </select>年
                <select name="end_month" <!--{if $arrErr.end_year != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> >
                    <option value="" selected="selected">----</option>
                    <!--{html_options options=$arrMonth selected=$arrForm.end_month}-->
                </select>月
                <select name="end_day" <!--{if $arrErr.end_year != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> >
                    <option value="" selected="selected">----</option>
                    <!--{html_options options=$arrDay selected=$arrForm.end_day}-->
                </select>日
            </td>
        </tr>
        <tr>
            <th>求人数<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.offer_number}--></span>
                <input type="text" name="offer_number" value="<!--{$arrForm.offer_number|h}-->" size="6" class="box6" style="<!--{if $arrErr.offer_number != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->"/>
                <span class="attention"> (半角数字で入力)</span>
            </td>
        </tr>
        <tr>
            <th>対象<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.target}--></span>
                <span <!--{if $arrErr.target != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                    <!--{html_radios name="target" options=$arrTarget selected=$arrForm.target separator='&nbsp;&nbsp;'}-->
                </span>
            </td>
        </tr>
        <tr>
            <th>雇用形態<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.employment_status}--></span>
                <span <!--{if $arrErr.employment_status != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                    <!--{if $arrForm.target != '' && $arrForm.target > 0}-->
                        <!--{html_radios name="employment_status" options=$arrEmploymentStatusByTarget[$arrForm.target] selected=$arrForm.employment_status separator='&nbsp;&nbsp;'}-->
                    <!--{else}-->
                        <!--{html_radios name="employment_status" options=$arrEmploymentStatus selected=$arrForm.employment_status separator='&nbsp;&nbsp;'}-->
                    <!--{/if}-->
                </span>
            </td>
        </tr>
        <tr>
            <th>ポジション<span class="attention" <!--{if $arrForm.employment_status == 2 || $arrForm.employment_status == 3}-->style='display: none'<!--{/if}-->> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.position}--></span>
                <span <!--{if $arrErr.position != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                    <!--{html_radios name="position" options=$arrPosition selected=$arrForm.position separator='&nbsp;&nbsp;'}-->
                </span>
            </td>
        </tr>
        <!--{assign var=targetId value="0"}-->
        <!--{if $arrForm.employment_status == 1}-->
            <!--{assign var=targetId value="2"}-->
        <!--{else if $arrForm.employment_status == 2 || $arrForm.employment_status == 3}-->
            <!--{assign var=targetId value="1"}-->
        <!--{/if}-->
        <tr>
            <th>給与区分<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.salary_type}--></span>
                <span <!--{if $arrErr.salary_type != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                    <!--{if $targetId > 0}-->
                        <!--{html_radios name="salary_type" options=$arrSalaryTypeByTarget[$targetId] selected=$arrForm.salary_type separator='&nbsp;&nbsp;'}-->
                    <!--{else}-->
                        <!--{html_radios name="salary_type" options=$arrSalaryType selected=$arrForm.salary_type separator='&nbsp;&nbsp;'}-->
                    <!--{/if}-->
                </span>
            </td>
        </tr>
        <tr>
            <th>通貨<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.currency}--></span>
                <span <!--{if $arrErr.currency != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                    <!--{html_radios name="currency" options=$arrCurrency selected=$arrForm.currency separator='&nbsp;&nbsp;'}-->
                </span>
            </td>
        </tr>
        <tr>
            <th>給与上限<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.salary_min}--></span>
                <input type="text" name="salary_min" value="<!--{$arrForm.salary_min|h}-->" size="60" class="box60" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{if $arrErr.salary_min != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->"/>
            </td>
        </tr>
        <tr>
            <th>給与下限<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.salary_max}--></span>
                <input type="text" name="salary_max" value="<!--{$arrForm.salary_max|h}-->" size="60" class="box60" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{if $arrErr.salary_max != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->"/>
            </td>
        </tr>
        <tr>
            <th>給与詳細<span class="attention" <!--{if $arrForm.employment_status == 2 || $arrForm.employment_status == 3}-->style='display: none'<!--{/if}-->> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.salary}--><!--{$arrErr.salary_vn}--></span>
                <textarea name="salary" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.salary|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.salary|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="salary_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.salary_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.salary_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>為替相場</th>
            <td>
                <span class="attention"><!--{$arrErr.exchange_rate}--></span>
                <input type="text" name="exchange_rate" value="<!--{$arrForm.exchange_rate|h}-->" size="60" class="box60" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{if $arrErr.exchange_rate != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->"/>
            </td>
        </tr>
        <tr>
            <th>職種<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.category_id}--></span>
                <span <!--{if $arrErr.category_id != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                    <!--{if $targetId > 0}-->
                        <!--{html_checkboxes name="category_id" options=$arrCategoryByTarget[$targetId] selected=$arrForm.category_id separator='&nbsp;&nbsp;'}-->
                    <!--{else}-->
                        <!--{html_checkboxes name="category_id" options=$arrCategory selected=$arrForm.category_id separator='&nbsp;&nbsp;'}-->
                    <!--{/if}-->
                </span>
            </td>
        </tr>
        <tr>
            <th>勤務地<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.region}--><!--{$arrErr.city}--><!--{$arrErr.work_location}--><!--{$arrErr.work_location_vn}--></span>
                <select class="top" name="region" <!--{if $arrErr.region != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> >
                    <option value="" selected="selected">都道府県を選択</option>
                    <!--{html_options options=$arrRegion selected=$arrForm.region}-->
                </select> &nbsp; 
                <select class="top" name="city" <!--{if $arrErr.city != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> >
                    <option value="">市区町村を選択</option>
                    <!--{if $arrForm.region > 0}-->
                        <!--{html_options options=$arrCityByRegion[$arrForm.region] selected=$arrForm.city}-->
                    <!--{/if}-->
                </select>
                <br />
                <input type="text" name="work_location" value="<!--{$arrForm.work_location|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{if $arrErr.work_location != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->" size="60" class="box60 top" />
                <br />
                <input type="text" name="work_location_vn" value="<!--{$arrForm.work_location_vn|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{if $arrErr.work_location_vn != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->" size="60" class="box60 vn_field" />
            </td>
        </tr>
        <tr>
            <th>交通アクセス</th>
            <td>
                <span class="attention"><!--{$arrErr.traffic_access}--><!--{$arrErr.traffic_access_vn}--></span>
                <textarea name="traffic_access" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.traffic_access|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.traffic_access|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="traffic_access_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.traffic_access_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.traffic_access_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>勤務時間<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.working_hour}--><!--{$arrErr.working_hour_vn}--></span>
                <textarea name="working_hour" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.working_hour|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.working_hour|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="working_hour_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.working_hour_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.working_hour_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>勤務曜日<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.working_day}--><!--{$arrErr.working_day_vn}--></span>
                <textarea name="working_day" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.working_day|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.working_day|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="working_day_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.working_day_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.working_day_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>昼休み時間<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.lunch_time}--><!--{$arrErr.lunch_time_vn}--></span>
                <textarea name="lunch_time" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.lunch_time|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.lunch_time|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="lunch_time_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.lunch_time_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.lunch_time_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>試用期間</th>
            <td>
                <span class="attention"><!--{$arrErr.trial_period}--><!--{$arrErr.trial_period_vn}--></span>
                <textarea name="trial_period" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.trial_period|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.trial_period|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="trial_period_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.trial_period_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.trial_period_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>簡単な仕事情報<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.main_list_comment}--><!--{$arrErr.main_list_comment_vn}--></span>
                <textarea name="main_list_comment" maxlength="<!--{$smarty.const.MTEXT_LEN}-->" style="<!--{if $arrErr.main_list_comment != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->" cols="60" rows="8" class="area60 top"><!--{"\n"}--><!--{$arrForm.main_list_comment|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="main_list_comment_vn" maxlength="<!--{$smarty.const.MTEXT_LEN}-->" style="<!--{if $arrErr.main_list_comment_vn != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->" cols="60" rows="8" class="area60 vn_field"><!--{"\n"}--><!--{$arrForm.main_list_comment_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>仕事詳細<span class="attention">(タグ許可)*</span></th>
            <td>
                <span class="attention"><!--{$arrErr.main_comment}--><!--{$arrErr.main_comment_vn}--></span>
                <textarea name="main_comment" maxlength="<!--{$smarty.const.LLTEXT_LEN}-->" style="<!--{if $arrErr.main_comment != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->" cols="60" rows="8" class="area60 top"><!--{"\n"}--><!--{$arrForm.main_comment|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.LLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="main_comment_vn" maxlength="<!--{$smarty.const.LLTEXT_LEN}-->" style="<!--{if $arrErr.main_comment_vn != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->" cols="60" rows="8" class="area60 vn_field"><!--{"\n"}--><!--{$arrForm.main_comment_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.LLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>性別</th>
            <td>
                <!--{html_checkboxes name="sex" options=$arrSex selected=$arrForm.sex separator='&nbsp;&nbsp;'}-->
            </td>
        </tr>
        <tr>
            <th>資格<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.qualification}--><!--{$arrErr.qualification_vn}--></span>
                <textarea name="qualification" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.qualification|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.qualification|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="qualification_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.qualification_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.qualification_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>性格</th>
            <td>
                <span class="attention"><!--{$arrErr.personality}--><!--{$arrErr.personality_vn}--></span>
                <textarea name="personality" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.personality|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.personality|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="personality_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.personality_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.personality_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>経験・スキルの詳細<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.skill}--><!--{$arrErr.skill_vn}--></span>
                <textarea name="skill" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.skill|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.skill|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="skill_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.skill_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.skill_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>昇給</th>
            <td>
                <span class="attention"><!--{$arrErr.payrise}--><!--{$arrErr.payrise_vn}--></span>
                <textarea name="payrise" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.payrise|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.payrise|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="payrise_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.payrise_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.payrise_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>賞与</th>
            <td>
                <span class="attention"><!--{$arrErr.bonus}--><!--{$arrErr.bonus_vn}--></span>
                <textarea name="bonus" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.bonus|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.bonus|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="bonus_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.bonus_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.bonus_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>保険</th>
            <td>
                <span class="attention"><!--{$arrErr.insurance}--><!--{$arrErr.insurance_vn}--></span>
                <textarea name="insurance" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.insurance|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.insurance|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="insurance_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.insurance_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.insurance_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>福利</th>
            <td>
                <!--{html_checkboxes name="welfare" options=$arrWelfare selected=$arrForm.welfare separator='&nbsp;&nbsp;'}-->
            </td>
        </tr>
        <tr>
            <th>その他の福利</th>
            <td>
                <span class="attention"><!--{$arrErr.other_welfare}--><!--{$arrErr.other_welfare_vn}--></span>
                <textarea name="other_welfare" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.other_welfare|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.other_welfare|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="other_welfare_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.other_welfare_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.other_welfare_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>健康診断</th>
            <td>
                <span class="attention"><!--{$arrErr.medical_checkup}--><!--{$arrErr.medical_checkup_vn}--></span>
                <textarea name="medical_checkup" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.medical_checkup|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.medical_checkup|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="medical_checkup_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.medical_checkup_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.medical_checkup_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>応募方法<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.applicate_method}--><!--{$arrErr.applicate_method_vn}--></span>
                <textarea name="applicate_method" cols="60" rows="8" class="area60 top" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.applicate_method|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.applicate_method|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                <br />
                <textarea name="applicate_method_vn" cols="60" rows="8" class="area60 vn_field" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.applicate_method_vn|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.applicate_method_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>選考プロセス<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.selection_process}--></span>
                <select multiple="multiple" name="selection_process[]" style="<!--{$arrErr.selection_process|sfGetErrorColor}-->;" id="selection_process" size="10">
                    <!--{html_options options=$arrProcess selected=$arrForm.selection_process}-->
                </select>
            </td>
        </tr>
        <tr>
            <th>コンシェルジュ</th>
            <td>
                <span class="attention"><!--{$arrErr.concierge}--></span>
                <select name="concierge" <!--{if $arrErr.concierge != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> >
                    <option value="" selected="selected">------</option>
                    <!--{html_options options=$arrConcierge selected=$arrForm.concierge}-->
                </select>
            </td>
        </tr>
    </table>
                
    <h2>企業情報 <a class="btn-normal" href="javascript:;" name="address_input" onclick="eccube.openWindow('<!--{$smarty.const.ROOT_URLPATH}--><!--{$smarty.const.ADMIN_DIR}-->customer/search_client.php','search','600','650',{resizable:'no',focus:false}); return false;">企業検索</a></h2>

    <a name="client_area"></a>
    <table class="form">
        <tr>
            <th>企業ID<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.client_id}--></span>
                <!--{if $arrForm.client_id.value > 0}-->
                    <!--{$arrForm.client_id.value|h}-->
                    <input type="hidden" name="client_id" value="<!--{$arrForm.client_id.value|h}-->" />
                <!--{else}-->
                    (非会員)
                <!--{/if}-->
            </td>
        </tr>
        <tr>
            <th>会社紹介<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.client_introduction}--><!--{$arrErr.client_introduction_vn}--></span>
                <textarea name="client_introduction" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{if $arrErr.client_introduction != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->" cols="60" rows="8" class="area60 top"><!--{"\n"}--><!--{$arrForm.client_introduction|h}--></textarea>
                <br />
                <textarea name="client_introduction_vn" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{if $arrErr.client_introduction_vn != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->" cols="60" rows="8" class="area60 vn_field"><!--{"\n"}--><!--{$arrForm.client_introduction_vn|h}--></textarea><br />
                <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
            </td>
        </tr>
        <tr>
            <th>企業の本社住所<span class="attention"> *</span></th>
            <td>
                <span class="attention"><!--{$arrErr.client_zip01}--><!--{$arrErr.client_zip02}--><!--{$arrErr.client_pref}--><!--{$arrErr.client_addr01}--></span>
                〒&nbsp;<input type="text" name="client_zip01" value="<!--{$arrForm.client_zip01|h}-->" maxlength="<!--{$smarty.const.ZIP01_LEN}-->" <!--{if $arrErr.client_zip01 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="6" class="box6" /> - <input type="text" name="client_zip02" value="<!--{$arrForm.client_zip02|h}-->" maxlength="<!--{$smarty.const.ZIP02_LEN}-->" <!--{if $arrErr.client_zip02 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="6" class="box6" />
                <a class="btn-normal" href="javascript:;" name="address_input" onclick="eccube.getAddress('<!--{$smarty.const.INPUT_ZIP_URLPATH}-->', 'client_zip01', 'client_zip02', 'client_pref', 'client_addr01'); return false;">住所入力</a><br />
                <select name="client_pref" <!--{if $arrErr.client_pref != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                    <option value="" selected="selected">都道府県を選択</option>
                    <!--{html_options options=$arrPref selected=$arrForm.client_pref}-->
                </select><br />
                <input type="text" name="client_addr01" value="<!--{$arrForm.client_addr01|h}-->" <!--{if $arrErr.client_addr01 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> size="60" class="box60" /><br />
                <!--{$smarty.const.SAMPLE_ADDRESS1}-->
            </td>
        </tr>
    </table>

    <!--{* オペビルダー用 *}-->
    <!--{if "sfViewAdminOpe"|function_exists === TRUE}-->
    <!--{include file=`$smarty.const.MODULE_REALDIR`mdl_opebuilder/admin_ope_view.tpl}-->
    <!--{/if}-->

    <div class="btn-area">
        <!--{if count($arrSearchHidden) > 0}-->
        <!--▼検索結果へ戻る-->
        <ul>
            <li><a class="btn-action" href="javascript:;" onclick="eccube.changeAction('<!--{$smarty.const.ADMIN_PRODUCTS_URLPATH}-->'); eccube.setModeAndSubmit('search','',''); return false;"><span class="btn-prev">検索画面に戻る</span></a></li>
        <!--▲検索結果へ戻る-->
        <!--{/if}-->
            <li><a class="btn-action" href="javascript:;" onclick="document.form1.submit(); return false;"><span class="btn-next">確認ページへ</span></a></li>
        </ul>
    </div>
</div>
</form>
