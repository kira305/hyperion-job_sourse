<!--{*
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
 *}-->
<script>
    $(function(){
        $('#show_more_condition').on('click', function(){
            $('#more_condition').toggle();
            return false;
        });
        
        var prevTarget = <!--{$target}-->;
        $('select[name=employment_status]').change(function() {
            var target = detectTargetByEmpStatus($(this).val());
            if(prevTarget != target){
                $("select[name=salary_type]").find('option').not(':first').remove();
                $("select[name=currency]").find('option').not(':first').remove();
                $("select[name=salary_range]").find('option').not(':first').remove();
                var categoryList = $("input[name='category_id[]']").closest('.checkList');
                categoryList.html('');
                categoryList.prev().text('Lựa chọn ngành nghề');

                if(target == 0){
                    <!--{foreach key=key item=item from=$arrSalaryType}-->
                        $("select[name=salary_type]").append( $("<option>").val("<!--{$key}-->").html("<!--{$item}-->") );
                    <!--{/foreach}-->
                    <!--{foreach key=key item=item from=$arrCurrency}-->
                        $("select[name=currency]").append( $("<option>").val("<!--{$key}-->").html("<!--{$item}-->") );
                    <!--{/foreach}-->
                    <!--{foreach key=key item=item from=$arrCategory}-->
                        var label = $('<label />', { text: '<!--{$item}-->' });
                        var input = $('<input />', { type: 'checkbox', name: 'category_id[]', value: <!--{$key}--> });
                        label.prepend(input);
                        categoryList.append(label);
                    <!--{/foreach}-->
                } else {
                    <!--{foreach key=key item=item from=$arrSalaryTypeByTarget}-->
                        if(target == <!--{$key}-->){
                            <!--{foreach key=c_key item=c_item  from=$item}-->
                                $("select[name=salary_type]").append( $("<option>").val("<!--{$c_key}-->").html("<!--{$c_item}-->") );
                            <!--{/foreach}-->
                        }
                    <!--{/foreach}-->
                    <!--{foreach key=key item=item from=$arrCurrencyByTarget}-->
                        if(target == <!--{$key}-->){
                            <!--{foreach key=c_key item=c_item  from=$item}-->
                                $("select[name=currency]").append( $("<option>").val("<!--{$c_key}-->").html("<!--{$c_item}-->") );
                            <!--{/foreach}-->
                        }
                    <!--{/foreach}-->
                    <!--{foreach key=key item=item from=$arrCategoryByTarget}-->
                        if(target == <!--{$key}-->){
                            <!--{foreach key=c_key item=c_item  from=$item}-->
                                var label = $('<label />', { text: '<!--{$c_item}-->' });
                                var input = $('<input />', { type: 'checkbox', name: 'category_id[]', value: <!--{$c_key}--> });
                                label.prepend(input);
                                categoryList.append(label);
                            <!--{/foreach}-->
                        }
                    <!--{/foreach}-->
                    if(target == 1){
                        $("select[name=currency]").val('1');
                    } else {
                        $("select[name=salary_type]").val('3');
                    }
                    $(this).blur(); 
                }
                prevTarget = target;
            }
        });
        
        function detectTargetByEmpStatus(empId){
            var target = 0;
            <!--{foreach key=key item=item  from=$arrTargetByEmploymentStatus}-->
                if(empId == <!--{$key}-->){
                    target = '<!--{$item}-->';
                }
            <!--{/foreach}-->
            return target;
        }

        $('select[name=salary_type], select[name=currency]').change(function(){
            $("select[name=salary_range]").find('option').not(':first').remove();
            var salaryType = $("select[name=salary_type]").val();
            var currency = $("select[name=currency]").val();
            
            if($(this).attr('name') == 'salary_type' && $('select[name=employment_status]').val() == ''){
                $("select[name=currency]").find('option').not(':first').remove();
                if(salaryType == 1 || salaryType == 2){
                    <!--{foreach key=key item=item from=$arrCurrencyByTarget}-->
                        if(<!--{$key}--> == 1){
                            <!--{foreach key=c_key item=c_item  from=$item}-->
                                $("select[name=currency]").append( $("<option>").val("<!--{$c_key}-->").html("<!--{$c_item}-->") );
                            <!--{/foreach}-->
                        }
                    <!--{/foreach}-->
                    $("select[name=currency]").val(1);
                } else {
                    <!--{foreach key=key item=item from=$arrCurrency}-->
                        $("select[name=currency]").append( $("<option>").val("<!--{$key}-->").html("<!--{$item}-->") );
                    <!--{/foreach}-->
                    $("select[name=currency]").val(currency);
                }
            }
            
            currency = $("select[name=currency]").val();
            if(salaryType != '' && salaryType > 0 && currency != '' && currency > 0){
                <!--{foreach key=key item=item from=$arrSalaryRangeByTypeAndCurrency}-->
                    if(salaryType == <!--{$key}-->){
                        <!--{foreach key=t_key item=t_item  from=$item}-->
                            if(currency == <!--{$t_key}-->){
                                <!--{foreach key=c_key item=c_item  from=$t_item}-->
                                    $("select[name=salary_range]").append( $("<option>").val("<!--{$c_key}-->").html("<!--{$c_item}-->") );
                                <!--{/foreach}-->
                            }
                        <!--{/foreach}-->
                    }
                <!--{/foreach}-->
            }
        });
    });
</script>
<!--{strip}-->
    <div class="block_outer">
        <div id="search_area">
        <h2>Tìm kiếm công việc</h2>
            <div class="block_body">
                <!--検索フォーム-->
                <form name="search_form" id="search_form" method="get" action="<!--{$smarty.const.ROOT_URLPATH}-->products/list.php">
                    <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
                    <input type="hidden" name="mode" value="search" />
                    <input type="hidden" name="prevPage" value="<!--{$prevPage}-->">
                    <dl>
                        <dt>Từ khóa</dt>
                        <dd>
                            <input type="text" name="name" class="box380" maxlength="50" value="<!--{$smarty.get.name|h}-->" placeholder="Nhập từ khóa" />
                        </dd>
                    </dl>
                    <dl>
                        <dt>Loại công việc</dt>
                        <dd>
                            <select name="employment_status" class="box240">
                                <!--{if $page != 2}-->
                                    <option label="Lựa chọn công việc" value="">Lựa chọn công việc</option>
                                <!--{/if}-->
                                <!--{if $page > 0}-->
                                    <!--{html_options options=$arrEmploymentStatusByTarget[$page] selected=$smarty.get.employment_status}-->
                                <!--{else}-->
                                    <!--{html_options options=$arrEmploymentStatus selected=$smarty.get.employment_status}-->
                                <!--{/if}-->
                            </select>
                        </dd>
                    </dl>
                    <dl>
                        <dt>Ngành nghề</dt>
                        <dd>
                            <div class="checkInsideSelect">
                                <!--{assign var=count value=$smarty.get.category_id|@count}-->
                                <!--{assign var=first value=$smarty.get.category_id[0]}-->
                                <a href="#"><!--{if $count == 0}-->Lựa chọn ngành nghề<!--{elseif $count == 1}--><!--{$arrCatList[$first]}--><!--{else}-->選択条件<!--{$count}--><!--{/if}--></a>
                                <div class="checkList">
                                    <!--{if $target > 0}-->
                                        <!--{html_checkboxes name="category_id" options=$arrCategoryByTarget[$target] selected=$smarty.get.category_id separator=''}-->
                                    <!--{else}-->
                                        <!--{html_checkboxes name="category_id" options=$arrCategory selected=$smarty.get.category_id separator=''}-->
                                    <!--{/if}-->
                                </div>
                            </div>
                        </dd>
                    </dl>
                    <dl>
                        <dt>Địa điểm làm việc</dt>
                        <dd>
                            <div class="checkInsideSelect">
                                <!--{assign var=count value=$smarty.get.region|@count}-->
                                <!--{assign var=first value=$smarty.get.region[0]}-->
                                <a href="#"><!--{if $count == 0}-->Lựa chọn địa điểm làm việc<!--{elseif $count == 1}--><!--{$arrRegion[$first]}--><!--{else}-->選択条件<!--{$count}--><!--{/if}--></a>
                                <div class="checkList" id="regionCheckList">
                                    <!--{foreach key=key item=item from=$arrRegion}-->
                                    <label><input type="checkbox" name="region[]" value="<!--{$key}-->" <!--{if in_array($key,$smarty.get.region)}-->checked="checked"<!--{/if}-->><!--{$item}--></label>
                                    <div <!--{if !in_array($key,$smarty.get.region)}-->style='display: none'<!--{/if}-->><!--{html_checkboxes name="city" options=$arrCityByRegion[$key] selected=$smarty.get.city separator=''}--></div>
                                    <!--{/foreach}-->
                                </div>
                            </div>
                        </dd>
                    </dl>
                    <div id="more_condition" style="<!--{if $smarty.get.salary_type == '' && $smarty.get.currency == '' && $smarty.get.salary_range == '' && $smarty.get.welfare|@count == 0}-->display: none<!--{/if}-->">
                        <dl>
                            <dt>Lương</dt>
                            <dd>
                                <select name="salary_type" class="box150">
                                    <!--{if $target != 2}-->
                                        <option label="Lựa chọn hình thức trả lương" value="">Lựa chọn hình thức trả lương</option>
                                    <!--{/if}-->
                                    <!--{if $target > 0}-->
                                        <!--{html_options options=$arrSalaryTypeByTarget[$target] selected=$smarty.get.salary_type}-->
                                    <!--{else}-->
                                        <!--{html_options options=$arrSalaryType selected=$smarty.get.salary_type}-->
                                    <!--{/if}-->
                                </select> &nbsp; 
                                <select name="currency" class="box100">
                                    <!--{if $target != 1}-->
                                        <option label="Lựa chọn loại tiền tệ" value="">Lựa chọn loại tiền tệ</option>
                                    <!--{/if}-->
                                    <!--{if $target > 0}-->
                                        <!--{html_options options=$arrCurrencyByTarget[$target] selected=$smarty.get.currency}-->
                                    <!--{else}-->
                                        <!--{html_options options=$arrCurrency selected=$smarty.get.currency}-->
                                    <!--{/if}-->
                                </select> &nbsp; 
                                <select name="salary_range" class="box150">
                                    <option label="Chọn mức lương" value="">Chọn mức lương</option>
                                    <!--{if $smarty.get.salary_type > 0 && $smarty.get.currency > 0}-->
                                        <!--{html_options options=$arrSalaryRangeByTypeAndCurrency[$smarty.get.salary_type][$smarty.get.currency] selected=$smarty.get.salary_range}-->
                                    <!--{/if}-->
                                </select>
                            </dd>
                        </dl>
                        <dl>
                            <dt>Điều kiện khác</dt>
                            <dd>
                                <div class="checkInsideSelect">
                                    <!--{assign var=count value=$smarty.get.welfare|@count}-->
                                    <!--{assign var=first value=$smarty.get.welfare[0]}-->
                                    <a href="#"><!--{if $count == 0}-->Lựa chọn điều kiện khác<!--{elseif $count == 1}--><!--{$arrWelfare[$first]}--><!--{else}-->選択条件<!--{$count}--><!--{/if}--></a>
                                    <div class="checkList">
                                        <!--{html_checkboxes name="welfare" options=$arrWelfare selected=$smarty.get.welfare separator=''}-->
                                    </div>
                                </div>
                            </dd>
                        </dl>
                    </div>
                    <p class="alignL"><a href="#" id="show_more_condition">≫ Tìm kiếm nâng cao</a></p>
                    <p class="btn"><input type="submit" value="TÌM KIẾM" name="search" /><br /></p>
                </form>
            </div>
        </div>
    </div>
<!--{/strip}-->
