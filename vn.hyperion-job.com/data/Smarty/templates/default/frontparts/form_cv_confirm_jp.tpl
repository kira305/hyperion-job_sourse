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

<!--{strip}-->
<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <td class="alignC">
            <!--{assign var=key value="image"}-->
            <!--{if $arrForm.arrFile[$key].filepath != ""}-->
                <img src="<!--{$arrForm.arrFile[$key].filepath}-->" alt="<!--{$customer_data.name01|h}--><!--{$customer_data.name02|h}-->" style="max-width: 150px; max-height: 150px;" />
            <!--{/if}-->
        </td>
        <td>
            Tên của bạn：<!--{$customer_data.name01|h}-->&nbsp;<!--{$customer_data.name02|h}--><br />
            Giới tính：<!--{$arrSex[$customer_data.sex]|h}--><br />
            Ngày sinh：<!--{if strlen($customer_data.year) > 0 && strlen($customer_data.month) > 0 && strlen($customer_data.day) > 0}-->
            <!--{$customer_data.day|h}-->/<!--{$customer_data.month|h}-->/<!--{$customer_data.year|h}-->
            <!--{else}-->
            Chưa đăng ký
            <!--{/if}--><br />
            Email：<!--{$customer_data.email|h}-->
        </td>
    </tr>
</table>

<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>Tình trạng hôn nhân</th>
        <td><!--{$arrMaritalStatus[$arrForm.marital_status]|h}--></td>
    </tr>
    <tr>
        <th>Nơi ở hiện tại</th>
        <td><!--{$arrTarget[$arrForm.current_address]|h}--></td>
    </tr> 
    <tr <!--{if $arrForm.current_address != 1}-->style="display: none"<!--{/if}-->>
        <th>Mã bưu điện</th>
        <td>〒 <!--{$arrForm.zip01|h}--> - <!--{$arrForm.zip02|h}--></td>
    </tr>
    <tr>
        <th>Tỉnh/Thành phố</th>
        <td><!--{$arrPref[$arrForm.pref]|h}--></td>
    </tr>
    <tr>
        <th>Quận/Huyện</th>
        <td><!--{$arrForm.addr01|h}--></td>
    </tr>
    <tr>
        <th>Địa chỉ</th>
        <td><!--{$arrForm.addr02|h}--></td>
    </tr>
    <tr>
        <th>Bậc học</th>
        <td><!--{$arrEducation[$arrForm.education]|h}--></td>
    </tr>
    <tr>
        <th>Tên trường</th>
        <td><!--{$arrForm.school_name|h}--></td>
    </tr>
    <tr>
        <th>Chuyên ngành</th>
        <td><!--{$arrForm.major|h}--></td>
    </tr>
    <tr>
        <th>Kinh nghiệm làm việc</th>
        <td><!--{$arrWorkExperience[$arrForm.work_experience]|h}--></td>
    </tr>
</table>

<!--{if $arrForm.work_experience == 1}-->
    <h2>Kinh nghiệm làm việc</h2>
    <table class="list" id="career_list">
        <tr>
            <th style="width: 20%">Thời gian</th>
            <th style="width: 5%">Số năm</th>
            <th style="width: 22%">Công ty</th>
            <th style="width: 23%">Địa chỉ</th>
            <th style="width: 30%">Nội dung công việc</th>
        </tr>
        <!--{section name=cnt loop=5}-->
            <!--{assign var=index value="`$smarty.section.cnt.index`"}-->
            <!--{if $arrForm.working_company_name[$index] != ''}-->
        <tr>
            <td>
                <!--{if strlen($arrForm.start_year[$index]) > 0 && strlen($arrForm.start_month[$index]) > 0}--><!--{$arrForm.start_month[$index]|h}-->/<!--{$arrForm.start_year[$index]|h}--><!--{else}-->Chưa đăng ký<!--{/if}--> ~ 
                <!--{if strlen($arrForm.end_year[$index]) > 0 && strlen($arrForm.end_month[$index]) > 0}--><!--{$arrForm.end_month[$index]|h}-->/<!--{$arrForm.end_year[$index]|h}--><!--{else}-->Chưa đăng ký<!--{/if}-->
            </td>
            <td><!--{$arrForm.working_year[$index]|h}--></td>
            <td><!--{$arrForm.working_company_name[$index]|h}--></td>
            <td><!--{$arrForm.company_addr[$index]|h}--></td>
            <td><!--{$arrForm.job_description[$index]|h}--></td>
        </tr>
            <!--{/if}-->
        <!--{/section}-->
    </table>
<!--{/if}-->
    
<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>Công việc mong muốn</th>
        <td>
            <!--{foreach from=$arrForm.desired_work item=status}-->
                <!--{if $status != ""}-->
                    <!--{$arrCategory[$status]}--><br />
                <!--{/if}-->
            <!--{/foreach}-->
        </td>
    </tr>
    <tr>
        <th>Vị trí mong muốn</th>
        <td>
            <!--{foreach from=$arrForm.desired_position item=status}-->
                <!--{if $status != ""}-->
                    <!--{$arrPosition[$status]}--><br />
                <!--{/if}-->
            <!--{/foreach}-->
        </td>
    </tr>
    <tr>
        <th>Mức lương hiện tại</th>
        <td><!--{if strlen($arrForm.current_salary) >= 1}--><!--{$arrForm.current_salary|h}--> Yên<!--{/if}--></td>
    </tr>
    <tr>
        <th>Mức lương mong muốn</th>
        <td><!--{if strlen($arrForm.desired_salary) >= 1}--><!--{$arrForm.desired_salary|h}--> Yên<!--{/if}--></td>
    </tr>
    <tr>
        <th>Nơi làm việc mong muốn</th>
        <td>
            <!--{foreach from=$arrForm.desired_region item=status}-->
                <!--{if $status != ""}-->
                    <!--{$arrRegion[$status]}--><br />
                <!--{/if}-->
            <!--{/foreach}-->
        </td>
    </tr>
</table>
    
<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>Tiếng Nhật</th>
        <td>JLPT：<!--{$arrJLPT[$arrForm.jp_level]|h}--><br />Khác：<!--{$arrForm.jp_other|h|default:"無し"}--></td>
    </tr>
    <tr>
        <th>Tiếng anh</th>
        <td>TOEIC：<!--{$arrForm.toeic|h}--><br />IELTS：<!--{$arrForm.ielts|h}--><br />Khác：<!--{$arrForm.eng_other|h|default:"無し"}--></td>
    </tr>
    <tr>
        <th>Ngoại ngữ khác</th>
        <td><!--{$arrForm.other_language|h|nl2br|default:"未登録"}--></td>
    </tr>
</table>
        
<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>Chứng chỉ</th>
        <td><!--{$arrForm.qualification|h|nl2br|default:"未登録"}--></td>
    </tr>
    <tr>
        <th>Kỹ năng</th>
        <td><!--{$arrForm.skill|h|nl2br|default:"未登録"}--></td>
    </tr>
    <tr>
        <th>PR bản thân</th>
        <td><!--{$arrForm.self_pr|h|nl2br|default:"未登録"}--></td>
    </tr>
</table>
<!--{/strip}-->