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
<script type="text/javascript" src="<!--{$smarty.const.ROOT_URLPATH}-->js/chosen.jquery.js"></script>
<script type="text/javascript" src="<!--{$smarty.const.ROOT_URLPATH}-->js/prism.js"></script>
<link rel="stylesheet" href="<!--{$TPL_URLPATH}-->css/chosen.css" type="text/css" media="all" />
<script type="text/javascript">
    $(function(){
        $(".chosen-select").chosen({'search_contains':true});
        
        $('input[name=current_address]').change(function(){
            var zipRow = $('input[name=zip01]').closest('tr');
            if($(this).val() == 1){
                zipRow.show();
            } else {
                zipRow.hide();
            }
            $("select[name=pref]").find('option').not(':first').remove();
            <!--{foreach key=key item=item from=$arrPrefByTarget}-->
                if($(this).val() == <!--{$key}-->){
                    <!--{foreach key=c_key item=c_item  from=$item}-->
                        $("select[name=pref]").append( $("<option>").val("<!--{$c_key}-->").html("<!--{$c_item}-->") );
                    <!--{/foreach}-->
                }
            <!--{/foreach}-->
            $(".chosen-select").trigger("chosen:updated");
            
            var categoryList = $("input[name='desired_work[]']").closest('.checkList');
            categoryList.html('');
            categoryList.prev().text('Chọn công việc mong muốn');
            <!--{foreach key=key item=item from=$arrCategoryByTarget}-->
                if($(this).val() == <!--{$key}-->){
                    <!--{foreach key=c_key item=c_item  from=$item}-->
                        var label = $('<label />', { text: '<!--{$c_item}-->' });
                        var input = $('<input />', { type: 'checkbox', name: 'desired_work[]', value: <!--{$c_key}--> });
                        label.prepend(input);
                        categoryList.append(label);
                    <!--{/foreach}-->
                }
            <!--{/foreach}-->
        });
        
        $('input[name=work_experience]').on('change', function(){
            if($(this).val() == 1) {
                $('#career_area').show();
            } else {
                $('#career_area').hide();
            }
        });
        
        $('.facialPhoto').click(function(e){
            e.preventDefault();
            $(this).parent().find('input[type=file]').trigger('click');
        });
        $('input[type=file][name=image]').change(function(e){
            eccube.setModeAndSubmit('upload_image', '', '');
        });
        
        $('#career_list select').change(function(){
            var regExp = /\[([^)]+)\]/;
            var matches = regExp.exec($(this).attr('name'));
            var index = matches[1];
            
            var sy = parseInt($("select[name='start_year[" + index + "]']").val());
            var sm = parseInt($("select[name='start_month[" + index + "]']").val());
            var ey = parseInt($("select[name='end_year[" + index + "]']").val());
            var em = parseInt($("select[name='end_month[" + index + "]']").val());
            
            var diff = '';
            if( sy > 0 && sm > 0 && ey > 0 && em > 0 && (sy < ey || sy == ey && sm < em) ){
                if(sm > em){
                    ey = ey - 1;
                    em = em + 12;
                }
                var ydiff = ey - sy;
                var mdiff = em - sm;
                diff = Math.round( (ydiff + mdiff / 12) *10)/10;
            }
            $("#working_year_" + index).text(diff);
            $("input[name='working_year[" + index + "]']").val(diff);
        });
    });
</script>
<style>
    .facialPhoto { cursor: pointer }
</style>

<!--{strip}-->
<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <td class="alignC">
            <!--{assign var=key value="image"}-->
            <span class="attention"><!--{$arrErr[$key]}--></span>
            <!--{if $arrForm.arrFile[$key].base64_image != ""}-->
                <img class="facialPhoto" src="<!--{$arrForm.arrFile[$key].base64_image}-->" alt="<!--{$customer_data.name01|h}--><!--{$customer_data.name02|h}-->" style="max-width: 150px; max-height: 150px;" />
                <br /><a href="" onclick="eccube.setModeAndSubmit('delete_image', '', ''); return false;">[Xóa ảnh]</a>
            <!--{else}-->
                <a class="facialPhoto" href="#" style="display: inline-block; text-align: center; padding: 60px 0; width: 150px; border: 2px solid #666; color: #666;">Ảnh đại diện<br />（Tải lên）</a>
            <!--{/if}-->
            <input type="file" style='display: none' name="image" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" />
        </td>
        <td>
            Họ và Tên：<!--{$customer_data.name01|h}-->&nbsp;<!--{$customer_data.name02|h}--><br />
            Giới tính：<!--{$arrSex[$customer_data.sex]|h}--><br />
            Ngày sinh：<!--{if strlen($customer_data.year) > 0 && strlen($customer_data.month) > 0 && strlen($customer_data.day) > 0}-->
            <!--{$customer_data.day|h}-->/<!--{$customer_data.month|h}-->/<!--{$customer_data.year|h}-->
            <!--{else}-->
            Chưa đăng ký
            <!--{/if}--><br />
            E-mail：<!--{$customer_data.email|h}--><br />
            Tel：<!--{$customer_data.tel01|h}-->-<!--{$customer_data.tel02|h}-->-<!--{$customer_data.tel03|h}-->
        </td>
    </tr>
</table>

<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>Tình trạng hôn nhân<span class="attention"> *</span></th>
        <td>
            <span class="attention"><!--{$arrErr.marital_status}--></span>
            <span <!--{if $arrErr.marital_status != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                <!--{html_radios name="marital_status" options=$arrMaritalStatus separator=" " selected=$arrForm.marital_status}-->
            </span>
        </td>
    </tr>
    <tr>
        <th>Nơi ở hiện tại<span class="attention"> *</span></th>
        <td>
            <span class="attention"><!--{$arrErr.current_address}--></span>
            <span <!--{if $arrErr.current_address != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                <!--{html_radios name="current_address" options=$arrTarget separator=" " selected=$arrForm.current_address}-->
            </span>
        </td>
    </tr>
    <tr <!--{if $arrForm.current_address != 1}-->style="display: none"<!--{/if}-->>
        <th>Mã bưu điện<span class="attention"> *</span></th>
        <td>
            <span class="attention"><!--{$arrErr.zip01}--><!--{$arrErr.zip02}--></span>
            〒 <input type="text" name="zip01" value="<!--{$arrForm.zip01|h}-->" maxlength="<!--{$smarty.const.ZIP01_LEN}-->" class="box60" <!--{if $arrErr.zip01 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> /> - <input type="text" name="zip02" value="<!--{$arrForm.zip02|h}-->" maxlength="<!--{$smarty.const.ZIP02_LEN}-->" class="box60" <!--{if $arrErr.zip02 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> /> &nbsp;
            <a href="<!--{$smarty.const.ROOT_URLPATH}-->input_zip.php" onclick="eccube.getAddress('<!--{$smarty.const.INPUT_ZIP_URLPATH}-->', 'zip01', 'zip02', 'pref', 'addr01'); return false;" target="_blank" class="bttn back" >Tự động nhập địa chỉ</a>
        </td>
    </tr>
    <tr>
        <th>Tỉnh/Thành phố<span class="attention"> *</span></th>
        <td>
            <span class="attention"><!--{$arrErr.pref}--></span>
            <select class="chosen-select box240" name="pref" <!--{if $arrErr.pref != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                <option class="top" value="" selected="selected">Chọn tỉnh/thành phố</option>
                <!--{if $arrForm.current_address}-->
                    <!--{html_options options=$arrPrefByTarget[$arrForm.current_address] selected=$arrForm.pref}-->
                <!--{else}-->
                    <!--{html_options options=$arrPref selected=$arrForm.pref}-->
                <!--{/if}-->
            </select>
        </td>
    </tr>
    <tr>
        <th>Quận/Huyện<span class="attention"> *</span></th>
        <td>
            <span class="attention"><!--{$arrErr.addr01}--></span>
            <input type="text" name="addr01" value="<!--{$arrForm.addr01|h}-->" class="box300" <!--{if $arrErr.addr01 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> /><br />
        </td>
    </tr>
    <tr>
        <th>Địa chỉ</th>
        <td>
            <span class="attention"><!--{$arrErr.addr02}--></span>
            <input type="text" name="addr02" value="<!--{$arrForm.addr02|h}-->" class="box300" <!--{if $arrErr.addr02 != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> /><br />
        </td>
    </tr>
    <tr>
        <th>Trình độ học vấn<span class="attention"> *</span></th>
        <td>
            <span class="attention"><!--{$arrErr.education}--></span>
            <span <!--{if $arrErr.education != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                <!--{html_radios name="education" options=$arrEducation separator=" " selected=$arrForm.education}-->
            </span>
        </td>
    </tr>
    <tr>
        <th>Tên trường<span class="attention"> *</span></th>
        <td>
            <span class="attention"><!--{$arrErr.school_name}--></span>
            <input type="text" name="school_name" value="<!--{$arrForm.school_name|h}-->" class="box300" <!--{if $arrErr.school_name != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> /><br />
        </td>
    </tr>
    <tr>
        <th>Chuyên ngành<span class="attention"> *</span></th>
        <td>
            <span class="attention"><!--{$arrErr.major}--></span>
            <input type="text" name="major" value="<!--{$arrForm.major|h}-->" class="box300" <!--{if $arrErr.major != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> />
        </td>
    </tr>
    <tr>
        <th>Ngày tốt nghiệp<span class="attention"> *</span></th>
        <td>
            Ngày&nbsp;
            <select name="graduation_day" style="<!--{$graduation_day|sfGetErrorColor}-->">
                <!--{html_options options=$arrDay selected=$arrForm.graduation_day|default:''}-->
            </select>
            &nbsp;Tháng&nbsp;
            <select name="graduation_month" style="<!--{$graduation_month|sfGetErrorColor}-->">
                <!--{html_options options=$arrMonth selected=$arrForm.graduation_month|default:''}-->
            </select>
            &nbsp;Năm&nbsp;
            <select name="graduation_year" style="<!--{$graduation_year|sfGetErrorColor}-->">
                <!--{html_options options=$arrYear selected=$arrForm.graduation_year|default:''}-->
            </select>
        </td>
    </tr>
    <tr>
        <th>Kinh nghiệm làm việc<span class="attention"> *</span></th>
        <td>
            <span class="attention"><!--{$arrErr.work_experience}--></span>
            <span <!--{if $arrErr.work_experience != ""}--><!--{sfSetErrorStyle}--><!--{/if}-->>
                <!--{html_radios name="work_experience" options=$arrWorkExperience separator=" " selected=$arrForm.work_experience}-->
            </span>
            <br>
            <span class="attention">※　Trường hợp [Có kinh nghiệm] thì xin vui lòng nhập thông tin chi tiết ở phần [Lịch sử làm việc]</span>
        </td>
    </tr>
</table>
<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>Ngành nghề mong muốn<span class="attention"> *</span></th>
        <td>
            <span class="attention"><!--{$arrErr.desired_work}--></span>
            <div class="checkInsideSelect">
                <!--{assign var=count value=$arrForm.desired_work|@count}-->
                <!--{assign var=first value=$arrForm.desired_work[0]}-->
                <a href="#"><!--{if $arrForm.desired_work[0] == ''}-->Lựa chọn nghề nghiệp<!--{elseif $count == 1}--><!--{$arrCategory[$first]}--><!--{else}--><!--{$count}--><span> lựa chọn</span><!--{/if}--></a>
                <div class="checkList">
                    <!--{if $arrForm.current_address}-->
                        <!--{html_checkboxes name="desired_work" options=$arrCategoryByTarget[$arrForm.current_address] selected=$arrForm.desired_work separator=''}-->
                    <!--{else}-->
                        <!--{html_checkboxes name="desired_work" options=$arrCategory selected=$arrForm.desired_work separator=''}-->
                    <!--{/if}-->
                </div>
            </div>
        </td>
    </tr>
    <tr>
        <th>Mức lương hiện tại</th>
        <td>
            <span class="attention"><!--{$arrErr.current_salary}--></span>
            <input type="text" name="current_salary" value="<!--{$arrForm.current_salary|h}-->" class="box60" maxlength="<!--{$smarty.const.PRICE_LEN}-->" style="<!--{if $arrErr.current_salary != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->"/>Vạn Yên
        </td>
    </tr>
    <tr>
        <th>Mức lương mong muốn</th>
        <td>
            <span class="attention"><!--{$arrErr.desired_salary}--></span>
            <input type="text" name="desired_salary" value="<!--{$arrForm.desired_salary|h}-->" class="box60" maxlength="<!--{$smarty.const.PRICE_LEN}-->" style="<!--{if $arrErr.desired_salary != ""}-->background-color: <!--{$smarty.const.ERR_COLOR}-->;<!--{/if}-->"/>Vạn Yên
        </td>
    </tr>
    <tr>
        <th>Nơi làm việc mong muốn</th>
        <td>
            <!--{html_checkboxes name="desired_region" options=$arrRegion selected=$arrForm.desired_region separator='&nbsp;&nbsp;'}-->
        </td>
    </tr>
</table>
    
<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>Trình độ Tiếng Nhật<span class="attention"> *</span></th>
        <td>
            <span class="attention"><!--{$arrErr.jp_level}--><!--{$arrErr.jp_other}--></span>
            JLPT <select name="jp_level" class="box100" <!--{if $arrErr.jp_level != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> >
                <option value="" selected="selected">----</option>
                <!--{html_options options=$arrJLPT selected=$arrForm.jp_level}-->
            </select> &nbsp; 
            Khác <input type="text" name="jp_other" value="<!--{$arrForm.jp_other|h}-->" class="box300" <!--{if $arrErr.jp_other != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> />
        </td>
    </tr>
    <tr>
        <th>Trình độ Tiếng Anh</th>
        <td>
            <span class="attention"><!--{$arrErr.toeic}--><!--{$arrErr.ielts}--><!--{$arrErr.eng_other}--></span>
            TOEIC <input type="text" name="toeic" value="<!--{$arrForm.toeic|h}-->" class="box100" <!--{if $arrErr.toeic != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> /> &nbsp; 
            IELTS <input type="text" name="ielts" value="<!--{$arrForm.ielts|h}-->" class="box100" <!--{if $arrErr.ielts != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> /><br />
            Khác <input type="text" name="eng_other" value="<!--{$arrForm.eng_other|h}-->" class="box300" <!--{if $arrErr.eng_other != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> />
        </td>
    </tr>
    <tr>
        <th>Trình độ Ngoại ngữ khác</th>
        <td>
            <span class="attention"><!--{$arrErr.other_language}--></span>
            <textarea name="other_language" maxlength="<!--{$smarty.const.LTEXT_LEN}-->" <!--{if $arrErr.other_language != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> cols="60" rows="8" class="area60"><!--{"\n"}--><!--{$arrForm.other_language|h}--></textarea>
        </td>
    </tr>
</table>
        
<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>Chứng chỉ</th>
        <td>
            <span class="attention"><!--{$arrErr.qualification}--></span>
            <textarea name="qualification" maxlength="<!--{$smarty.const.LTEXT_LEN}-->" <!--{if $arrErr.qualification != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> cols="60" rows="8" class="area60"><!--{"\n"}--><!--{$arrForm.qualification|h}--></textarea>
        </td>
    </tr>
    <tr>
        <th>Kỹ năng</th>
        <td>
            <span class="attention"><!--{$arrErr.skill}--></span>
            <textarea name="skill" maxlength="<!--{$smarty.const.LTEXT_LEN}-->" <!--{if $arrErr.skill != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> cols="60" rows="8" class="area60"><!--{"\n"}--><!--{$arrForm.skill|h}--></textarea>
        </td>
    </tr>
    <tr>
        <th>PR bản thân</th>
        <td>
            <span class="attention"><!--{$arrErr.self_pr}--></span>
            <textarea name="self_pr" maxlength="<!--{$smarty.const.LTEXT_LEN}-->" <!--{if $arrErr.self_pr != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> cols="60" rows="8" class="area60"><!--{"\n"}--><!--{$arrForm.self_pr|h}--></textarea>
        </td>
    </tr>
</table>
<div id="career_area" <!--{if $arrForm.work_experience != 1}-->style='display: none'<!--{/if}--> >
    <h2>Lịch sử làm việc</h2>
    <table class="list" id="career_list">
        <tr>
            <th style="width: 160px;">Từ ngày<br>~<br>Đến ngày</th>
            <th style="width: 36px;">T.Gian</th>
            <th style="width: 440px;" colspan="2">Thông tin khái quát về Công ty</th>
            <th>Khái quát công việc</th>
        </tr>
        <!--{section name=cnt loop=10}-->
        <!--{assign var=index value="`$smarty.section.cnt.index`"}-->
        <tr>
            <td>
                <span class="attention" style="font-size: 10px;"><!--{$arrErr.start_year[$index]}--></span>
                <select name="start_month[<!--{$index}-->]" <!--{if $arrErr.start_year[$index] != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> >
                    <option value="" selected="selected">----</option>
                    <!--{html_options options=$arrMonth selected=$arrForm.start_month[$index]}-->
                </select>/
                <select name="start_year[<!--{$index}-->]" <!--{if $arrErr.start_year[$index] != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> >
                    <option value="" selected="selected">------</option>
                    <!--{html_options options=$arrReleaseYear selected=$arrForm.start_year[$index]}-->
                </select>
                
                <br><br>
                ~
                <br><br>
                <span class="attention" style="font-size: 10px;"><!--{$arrErr.end_year[$index]}--></span>
                <select name="end_month[<!--{$index}-->]" <!--{if $arrErr.end_year[$index] != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> >
                    <option value="" selected="selected">----</option>
                    <!--{html_options options=$arrMonth selected=$arrForm.end_month[$index]}-->
                </select>/
                <select name="end_year[<!--{$index}-->]" <!--{if $arrErr.end_year[$index] != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> >
                    <option value="" selected="selected">------</option>
                    <!--{html_options options=$arrReleaseYear selected=$arrForm.end_year[$index]}-->
                </select>
            </td>
            <td>
                <span id="working_year_<!--{$index}-->"><!--{$arrForm.working_year[$index]|h}--></span>
                <input type="hidden" name="working_year[<!--{$index}-->]" value="<!--{$arrForm.working_year[$index]|h}-->" />
            </td>
            <td>
                <label>Tên Công ty</label><br>
                <span class="attention" style="font-size: 10px;"><!--{$arrErr.working_company_name[$index]}--></span>
                <input type="text" name="working_company_name[<!--{$index}-->]"  maxlength="<!--{$smarty.const.STEXT_LEN}-->" value="<!--{$arrForm.working_company_name[$index]|h}-->" class="box200" <!--{if $arrErr.$arrErr.working_company_name[$index] != ""}--><!--{/if}--> /><br />
                <label>Địa chỉ</label><br>
                <span class="attention" style="font-size: 10px;"><!--{$arrErr.company_addr[$index]}--></span>
                <textarea style="resize: none;" name="company_addr[<!--{$index}-->]" maxlength="<!--{$smarty.const.MTEXT_LEN}-->" <!--{if $arrErr.$arrErr.company_addr[$index] != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> cols="24" rows="10"><!--{"\n"}--><!--{$arrForm.company_addr[$index]|h}--></textarea>
            </td>
            <td>
                <label>Số lượng nhân viên</label><br>
                <span class="attention" style="font-size: 10px;"><!--{$arrErr.working_member_num[$index]}--></span>
                <input type="text" placeholder="VD：40 người" name="working_member_num[<!--{$index}-->]"  maxlength="20" value="<!--{$arrForm.working_member_num[$index]|h}-->" class="box200" <!--{if $arrForm.working_company_employess_num[$index] != ""}--><!--{/if}--> /><br />
                <label>Hình thức hợp đồng</label><br>
                <span class="attention" style="font-size: 10px;"><!--{$arrErr.working_status[$index]}--></span>
                <input type="text" placeholder="VD：Chính thức, Bán thời gian, Phái cử"  name="working_status[<!--{$index}-->]"  maxlength="20" value="<!--{$arrForm.working_status[$index]|h}-->" class="box200" <!--{if $arrForm.working_position[$index] != ""}--><!--{/if}--> /><br />
                <label>Bộ phận/Chức vụ</label><br>
                <span class="attention" style="font-size: 10px;"><!--{$arrErr.working_position[$index]}--></span>
                <input type="text" placeholder="VD：Tổng giám đốc"  name="working_position[<!--{$index}-->]"  maxlength="20" value="<!--{$arrForm.working_position[$index]|h}-->" class="box200" <!--{if $arrForm.working_position[$index] != ""}--><!--{/if}--> /><br />
                <label>Nghiệp vụ</label><br>
                <span class="attention" style="font-size: 10px;"><!--{$arrErr.working_type[$index]}--></span>
                <input type="text" placeholder="VD：Phát triền EC-Site"  name="working_type[<!--{$index}-->]" maxlength="20" value="<!--{$arrForm.working_type[$index]|h}-->" class="box200" <!--{if $arrForm.working_position[$index] != ""}--><!--{/if}--> /><br />
                <label>Công việc đảm nhận</label><br>
                <span class="attention" style="font-size: 10px;"><!--{$arrErr.working_experience[$index]}--></span>
                <input type="text" placeholder="VD：Phát triển hệ thống"  name="working_experience[<!--{$index}-->]"  maxlength="20" value="<!--{$arrForm.working_experience[$index]|h}-->" class="box200" <!--{if $arrForm.working_position[$index] != ""}--><!--{/if}--> /><br />
            </td>
            <td>
                <span class="attention" style="font-size: 10px;"><!--{$arrErr.job_description[$index]}--></span>
                <textarea style="resize: none;" name="job_description[<!--{$index}-->]" maxlength="<!--{$smarty.const.MTEXT_LEN}-->" <!--{if $arrErr.$arrErr.job_description[$index] != ""}--><!--{sfSetErrorStyle}--><!--{/if}--> cols="28" rows="14"><!--{"\n"}--><!--{$arrForm.job_description[$index]|h}--></textarea>
            </td>
        </tr>
        <!--{/section}-->
    </table>
</div>
<!--{/strip}-->
