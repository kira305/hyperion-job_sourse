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
            <!--{if $arrForm.arrFile[$key].base64_image != ""}-->
                <img src="<!--{$arrForm.arrFile[$key].base64_image}-->" alt="<!--{$customer_data.name01|h}--><!--{$customer_data.name02|h}-->" style="max-width: 150px; max-height: 150px;" />
            <!--{else}-->
                <img src="<!--{$smarty.const.IMAGE_SAVE_URLPATH}-->avatar_default.png" alt="<!--{$arrProduct.name|h}-->" class="picture" /></a>
            <!--{/if}-->
        </td>
        <td>
            お名前：<!--{$customer_data.name01|h}-->&nbsp;<!--{$customer_data.name02|h}--><br />
            性別：<!--{$arrSex[$customer_data.sex]|h}--><br />
            生年月日：<!--{if strlen($customer_data.year) > 0 && strlen($customer_data.month) > 0 && strlen($customer_data.day) > 0}-->
            <!--{$customer_data.year|h}-->年<!--{$customer_data.month|h}-->月<!--{$customer_data.day|h}-->日
            <!--{else}-->
            未登録
            <!--{/if}--><br />
            メールアドレス：<!--{$customer_data.email|h}--><br>
            電話番号：<!--{$customer_data.tel01|h}-->-<!--{$customer_data.tel02|h}-->-<!--{$customer_data.tel03|h}-->
        </td>
    </tr>
</table>

<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>配偶者</th>
        <td><!--{$arrMaritalStatus[$arrForm.marital_status]|h}--></td>
    </tr>
    <tr>
        <th>現住所</th>
        <td><!--{$arrTarget[$arrForm.current_address]|h}--></td>
    </tr> 
    <tr <!--{if $arrForm.current_address != 1}-->style="display: none"<!--{/if}-->>
        <th>郵便番号</th>
        <td>〒 <!--{$arrForm.zip01|h}--> - <!--{$arrForm.zip02|h}--></td>
    </tr>
    <tr>
        <th>都道府県</th>
        <td><!--{$arrPref[$arrForm.pref]|h}--></td>
    </tr>
    <tr>
        <th>市区町村</th>
        <td><!--{$arrForm.addr01|h}--></td>
    </tr>
    <tr>
        <th>住所</th>
        <td><!--{$arrForm.addr02|h}--></td>
    </tr>
    <tr>
        <th>最終学歴</th>
        <td><!--{$arrEducation[$arrForm.education]|h}--></td>
    </tr>
    <tr>
        <th>学校名</th>
        <td><!--{$arrForm.school_name|h}--></td>
    </tr>
    <tr>
        <th>専攻</th>
        <td><!--{$arrForm.major|h}--></td>
    </tr>
    <tr>
        <th>卒業年月日</th>
        <td>
            <!--{if strlen($arrForm.graduation_year) > 0 && strlen($arrForm.graduation_month) > 0 && strlen($arrForm.graduation_day) > 0}-->
            <!--{$arrForm.graduation_year|h}-->年<!--{$arrForm.graduation_month|h}-->月<!--{$arrForm.graduation_day|h}-->日
            <!--{else}-->
            未登録
            <!--{/if}-->
        </td>
    </tr>
    <tr>
        <th>職歴</th>
        <td><!--{$arrWorkExperience[$arrForm.work_experience]|h}--></td>
    </tr>
</table>

<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>希望職種</th>
        <td>
            <!--{foreach from=$arrForm.desired_work item=status}-->
                <!--{if $status != ""}-->
                    <!--{$arrCategory[$status]}--><br />
                <!--{/if}-->
            <!--{/foreach}-->
        </td>
    </tr>
    <tr>
        <th>直近年収</th>
        <td><!--{if strlen($arrForm.current_salary) >= 1}--><!--{$arrForm.current_salary|h}--> 万円<!--{/if}--></td>
    </tr>
    <tr>
        <th>希望年収</th>
        <td><!--{if strlen($arrForm.desired_salary) >= 1}--><!--{$arrForm.desired_salary|h}--> 万円<!--{/if}--></td>
    </tr>
    <tr>
        <th>希望勤務地</th>
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
        <th>日本語レベル</th>
        <td>JLPT：<!--{$arrJLPT[$arrForm.jp_level]|h}--><br />その他：<!--{$arrForm.jp_other|h|default:"無し"}--></td>
    </tr>
    <tr>
        <th>英語レベル</th>
        <td>TOEIC：<!--{$arrForm.toeic|h}--><br />IELTS：<!--{$arrForm.ielts|h}--><br />その他：<!--{$arrForm.eng_other|h|default:"無し"}--></td>
    </tr>
    <tr>
        <th>他の言語</th>
        <td><!--{$arrForm.other_language|h|nl2br|default:"未登録"}--></td>
    </tr>
</table>
        
<table>
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>資格</th>
        <td><!--{$arrForm.qualification|h|nl2br|default:"未登録"}--></td>
    </tr>
    <tr>
        <th>スキル</th>
        <td><!--{$arrForm.skill|h|nl2br|default:"未登録"}--></td>
    </tr>
    <tr>
        <th>自己PR</th>
        <td><!--{$arrForm.self_pr|h|nl2br|default:"未登録"}--></td>
    </tr>
</table>

<!--{if $arrForm.work_experience == 1}-->
    <h2>職歴</h2>
    <table id="career_list" style="table-layout: fixed;">
        <tr>
            <th style="width: 120px">開始日 ～ 終了日</th>
            <th style="width: 36px;">年間</th>
            <th style="width: 440px;" colspan="2">会社情報</th>
            <th style="width: 320px;">仕事概要</th>
        </tr>
        <!--{section name=cnt loop=10}-->
            <!--{assign var=index value="`$smarty.section.cnt.index`"}-->
            <!--{if $arrForm.working_company_name[$index] != ''}-->
        <tr>
            <td>
                <!--{if strlen($arrForm.start_year[$index]) > 0 && strlen($arrForm.start_month[$index]) > 0}--><!--{$arrForm.start_year[$index]|h}-->年<!--{$arrForm.start_month[$index]|h}-->月<!--{else}-->未登録<!--{/if}--> 
                <br><br>~<br><br>
                <!--{if strlen($arrForm.end_year[$index]) > 0 && strlen($arrForm.end_month[$index]) > 0}--><!--{$arrForm.end_year[$index]|h}-->年<!--{$arrForm.end_month[$index]|h}-->月<!--{else}-->未登録<!--{/if}-->
            </td>
            <td><!--{$arrForm.working_year[$index]|h}--></td>
            <td style="vertical-align:top;overflow-wrap:break-word; width:220px;">
                <label style="background-color:#f2f2f2; width:100%">会社名</label><br>
                <!--{$arrForm.working_company_name[$index]|h}--><br><br><br>
                <label style="background-color:#f2f2f2; width:100%">住所</label><br>
                <!--{$arrForm.company_addr[$index]|h}-->
            </td>
            <td style="vertical-align:top;overflow-wrap:break-word;">
                <label style="background-color:#f2f2f2; width:100%">従業員数</label><br>
                <!--{$arrForm.working_member_num[$index]|h}--><br>
                <label style="background-color:#f2f2f2; width:100%">雇用形態</label><br>
                <!--{$arrForm.working_status[$index]|h}--><br>
                <label style="background-color:#f2f2f2; width:100%">部署・役職</label><br>
                <!--{$arrForm.working_position[$index]|h}--><br>
                <label style="background-color:#f2f2f2; width:100%">業種</label><br>
                <!--{$arrForm.working_type[$index]|h}--><br>
                <label style="background-color:#f2f2f2; width:100%">経験職種</label><br>
                <!--{$arrForm.working_experience[$index]|h}-->
            </td>
            <td style="vertical-align:top;overflow-wrap:break-word;"><!--{$arrForm.job_description[$index]|h}--></td>
        </tr>
            <!--{/if}-->
        <!--{/section}-->
    </table>
<!--{/if}-->
<!--{/strip}-->