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

<script type="text/javascript">//<![CDATA[
    $(function(){
        $('.more').click(function(){
            var filterArea = $(this).parent().next();
            if($(this).text() == '＋'){
                $(this).text('ー');
                var labelCount = filterArea.find('label:visible').size();
                var labelHeight = filterArea.find('label:eq(0)').outerHeight();
                filterArea.animate({"max-height": labelCount * labelHeight + "px"}, 1000);
            } else {
                $(this).text('＋');
                var hgt = 125;
                var isRegionArea = $(this).parent().next().find('input[name="region[]"]').length;
                if(isRegionArea > 0){
                    var addHgt = 0;
                    $(this).parent().next().find('div:visible').each(function(){
                        addHgt = addHgt + $(this).height();
                    });
                    hgt = hgt + addHgt;
                }
                filterArea.animate({"max-height": hgt + "px"}, 1000);
            }
        });
        
        $('.filter_area input[name="region[]"]').change(function(){
            var cities = $(this).parent().next();
            if($(this).is(':checked')){
                cities.find('input').prop('checked', 'checked');
                var hgt = $(this).closest('.filter_area').height() + cities.height();
            } else {
                cities.find('input').prop('checked', '');
                var hgt = $(this).closest('.filter_area').height() - cities.height();
            }
            cities.slideToggle('slow');
            $(this).closest('.filter_area').animate({"max-height": hgt + "px"}, 1000);
        });
        
        var prevTarget = <!--{$target}-->;
        $('input[name="employment_status[]"]').change(function() {
            var target = detectTargetByEmpStatus();
            
            if(prevTarget != target){
                $("#salary_range").hide();
                $("#salary_type").html('');
                $("#currency").html('');
                $("#category_id").html('');
                if(target == 0){
                    <!--{foreach key=key item=item from=$arrSalaryType}-->
                        var input = $('<input />', { type: 'radio', name: 'salary_type', value: '<!--{$key}-->' });
                        $("#salary_type").append( $('<label />', { text: '<!--{$item}-->' }).prepend(input) );
                    <!--{/foreach}-->
                    <!--{foreach key=key item=item from=$arrCurrency}-->
                        var input = $('<input />', { type: 'radio', name: 'currency', value: '<!--{$key}-->' });
                        $("#currency").append( $('<label />', { text: '<!--{$item}-->' }).prepend(input) );
                    <!--{/foreach}-->
                    <!--{foreach key=key item=item from=$arrCategory}-->
                        var input = $('<input />', { type: 'checkbox', name: 'category_id[]', value: '<!--{$key}-->' });
                        $("#category_id").append( $('<label />', { text: '<!--{$item}-->' }).prepend(input) );
                    <!--{/foreach}-->
                } else {
                    <!--{foreach key=key item=item from=$arrSalaryTypeByTarget}-->
                        if(target == <!--{$key}-->){
                            <!--{foreach key=c_key item=c_item  from=$item}-->
                                var input = $('<input />', { type: 'radio', name: 'salary_type', value: '<!--{$c_key}-->' });
                                $("#salary_type").append( $('<label />', { text: '<!--{$c_item}-->' }).prepend(input) );
                            <!--{/foreach}-->
                        }
                    <!--{/foreach}-->
                    <!--{foreach key=key item=item from=$arrCurrencyByTarget}-->
                        if(target == <!--{$key}-->){
                            <!--{foreach key=c_key item=c_item  from=$item}-->
                                var input = $('<input />', { type: 'radio', name: 'currency', value: '<!--{$c_key}-->' });
                                $("#currency").append( $('<label />', { text: '<!--{$c_item}-->' }).prepend(input) );
                            <!--{/foreach}-->
                        }
                    <!--{/foreach}-->
                    <!--{foreach key=key item=item from=$arrCategoryByTarget}-->
                        if(target == <!--{$key}-->){
                            <!--{foreach key=c_key item=c_item  from=$item}-->
                                var input = $('<input />', { type: 'checkbox', name: 'category_id[]', value: '<!--{$c_key}-->' });
                                $("#category_id").append( $('<label />', { text: '<!--{$c_item}-->' }).prepend(input) );
                            <!--{/foreach}-->
                        }
                    <!--{/foreach}-->
                    if(target == 1){
                        $("input[name=currency][value=1]").attr('checked', 'checked');
                    } else {
                        $("input[name=salary_type][value=3]").attr('checked', 'checked');
                    }
                }
                prevTarget = target;
            }
        });
        
        function detectTargetByEmpStatus(){
            var target = 0;
            if($('input[name="employment_status[]"]:checked').length > 0){
                var tempTarget;
                $('input[name="employment_status[]"]:checked').each(function(){
                    tempTarget = getTargetByEmpStatus($(this).val());
                    if(target == 0){
                        target = tempTarget;
                    } else if(target != tempTarget){
                        target = 0;
                        return false;
                    }
                });
            }
            return target;
        }
        
        function getTargetByEmpStatus(empId){
            var target = 0;
            <!--{foreach key=key item=item  from=$arrTargetByEmploymentStatus}-->
                if(empId == <!--{$key}-->){
                    target = '<!--{$item}-->';
                }
            <!--{/foreach}-->
            return target;
        }
        
        $("body").on("change", "input[name=salary_type], input[name=currency]", function () {
            $("#salary_range .filter_area").html('');
            var salaryType = $("input[name=salary_type]:checked").val();
            var currency = $("input[name=currency]:checked").val();
            
            if($(this).attr('name') == 'salary_type' && typeof $("input[name=employment_status]:checked").val() === "undefined"){
                $("#currency").html('');
                if(salaryType == 1 || salaryType == 2){
                    <!--{foreach key=key item=item from=$arrCurrencyByTarget}-->
                        if(<!--{$key}--> == 1){
                            <!--{foreach key=c_key item=c_item  from=$item}-->
                                var input = $('<input />', { type: 'radio', name: 'currency', value: '<!--{$c_key}-->' });
                                $("#currency").append( $('<label />', { text: '<!--{$c_item}-->' }).prepend(input) );
                            <!--{/foreach}-->
                        }
                    <!--{/foreach}-->
                    $("input[name=currency][value=1]").attr('checked', 'checked');
                } else {
                    <!--{foreach key=key item=item from=$arrCurrency}-->
                        var input = $('<input />', { type: 'radio', name: 'currency', value: '<!--{$key}-->' });
                        $("#currency").append( $('<label />', { text: '<!--{$item}-->' }).prepend(input) );
                    <!--{/foreach}-->
                    $("input[name=currency][value=" + currency + "]").attr('checked', 'checked');
                }
            }
            currency = $("input[name=currency]:checked").val();
            
            if(typeof salaryType !== "undefined" && typeof currency !== "undefined"){
                $('#salary_range').show();
                <!--{foreach key=key item=item from=$arrSalaryRangeByTypeAndCurrency}-->
                    if(salaryType == <!--{$key}-->){
                        <!--{foreach key=t_key item=t_item  from=$item}-->
                            if(currency == <!--{$t_key}-->){
                                <!--{foreach key=c_key item=c_item  from=$t_item}-->
                                    var input = $('<input />', { type: 'checkbox', name: 'salary_range', value: '<!--{$c_key}-->' });
                                    $("#salary_range .filter_area").append( $('<label />', { text: '<!--{$c_item}-->' }).prepend(input) );
                                <!--{/foreach}-->
                            }
                        <!--{/foreach}-->
                    }
                <!--{/foreach}-->
            } else {
                $('#salary_range').hide();
            }
        });
    });
//]]></script>

<!--{strip}-->
    <div class="block_outer">
        <div id="category_area">
            <h2>検索条件</h2>
            <div class="block_body">
                <form name="search_form" id="search_form" method="get" action="<!--{$smarty.const.ROOT_URLPATH}-->products/list.php">
                    <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
                    <input type="hidden" name="mode" value="search" />
                    <input type="hidden" name="prevPage" value="<!--{$prevPage}-->">
                    <h3>雇用形態</h3>
                    <div class="filter_area">
                        <!--{if $page > 0}-->
                            <!--{html_checkboxes name="employment_status" options=$arrEmploymentStatusByTarget[$page] selected=$smarty.get.employment_status separator=''}-->
                        <!--{else}-->
                            <!--{html_checkboxes name="employment_status" options=$arrEmploymentStatus selected=$smarty.get.employment_status separator=''}-->
                        <!--{/if}-->
                    </div>
                    <h3>職種<span class="more">＋</span></h3>
                    <div class="filter_area" id="category_id">
                        <!--{if $target > 0}-->
                            <!--{html_checkboxes name="category_id" options=$arrCategoryByTarget[$target] selected=$smarty.get.category_id separator=''}-->
                        <!--{else}-->
                            <!--{html_checkboxes name="category_id" options=$arrCategory selected=$smarty.get.category_id separator=''}-->
                        <!--{/if}-->
                    </div>
                    <h3>勤務地<span class="more">＋</span></h3>
                    <div class="filter_area">
                        <!--{foreach key=key item=item from=$arrRegion}-->
                            <label><input type="checkbox" name="region[]" value="<!--{$key}-->" <!--{if in_array($key,$smarty.get.region)}-->checked="checked"<!--{/if}-->><!--{$item}--></label>
                            <div <!--{if !in_array($key,$smarty.get.region)}-->style='display: none'<!--{/if}-->><!--{html_checkboxes name="city" options=$arrCityByRegion[$key] selected=$smarty.get.city separator=''}--></div>
                        <!--{/foreach}-->
                    </div>
                    <h3>給与区分</h3>
                    <div class="filter_area noListFilter" id="salary_type">
                        <!--{if $target > 0}-->
                            <!--{html_radios name="salary_type" options=$arrSalaryTypeByTarget[$target] selected=$smarty.get.salary_type}-->
                        <!--{else}-->
                            <!--{html_radios name="salary_type" options=$arrSalaryType selected=$smarty.get.salary_type}-->
                        <!--{/if}-->
                    </div>
                    <h3>通貨</h3>
                    <div class="filter_area noListFilter" id="currency">
                        <!--{if $target > 0}-->
                            <!--{html_radios name="currency" options=$arrCurrencyByTarget[$target] selected=$smarty.get.currency}-->
                        <!--{else}-->
                            <!--{html_radios name="currency" options=$arrCurrency selected=$smarty.get.currency}-->
                        <!--{/if}-->
                    </div>
                    <div id="salary_range" <!--{if $smarty.get.salary_type == '' || $smarty.get.currency == ''}-->style="display: none"<!--{/if}-->>
                        <h3>金額<span class="more">＋</span></h3>
                        <div class="filter_area">
                            <!--{html_checkboxes name="salary_range" options=$arrSalaryRangeByTypeAndCurrency[$smarty.get.salary_type][$smarty.get.currency] selected=$smarty.get.salary_range}-->
                        </div>
                    </div>
                    <h3>こだわり条件<span class="more">＋</span></h3>
                    <div class="filter_area">
                        <!--{html_checkboxes name="welfare" options=$arrWelfare selected=$smarty.get.welfare separator=''}-->
                    </div>
                    <h3>キーワード</h3>
                    <div class="filter_area">
                        <textarea name="name" placeholder="フリーワード"><!--{$smarty.get.name|h}--></textarea>
                    </div>
                    <div class="alignC">
                        <input type="submit" value="この条件で検索" name="search" />
                    </div>
                </form>
            </div>
        </div>
    </div>
<!--{/strip}-->
