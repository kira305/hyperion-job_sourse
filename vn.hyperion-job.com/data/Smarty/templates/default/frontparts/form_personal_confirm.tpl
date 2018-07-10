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
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>Tên của bạn</th>
        <td>
            <!--{assign var=key1 value="`$prefix`name01"}-->
            <!--{assign var=key2 value="`$prefix`name02"}-->
            <!--{$arrForm[$key1].value|h}-->&nbsp;
            <!--{$arrForm[$key2].value|h}-->
        </td>
    </tr>
    <tr>
        <th>Tên của bạn</th>
        <td>
            <!--{assign var=key1 value="`$prefix`kana01"}-->
            <!--{assign var=key2 value="`$prefix`kana02"}-->
            <!--{$arrForm[$key1].value|h}-->&nbsp;
            <!--{$arrForm[$key2].value|h}-->
        </td>
    </tr>
    <tr>
        <th>Giới tính</th>
        <td>
            <!--{assign var=key1 value="`$prefix`sex"}-->
            <!--{assign var="sex_id" value=$arrForm[$key1].value}-->
            <!--{$arrSex[$sex_id]|h}-->
        </td>
    </tr>
    <tr>
        <th>Ngày sinh</th>
        <td>
            <!--{assign var=key1 value="`$prefix`year"}-->
            <!--{assign var=key2 value="`$prefix`month"}-->
            <!--{assign var=key3 value="`$prefix`day"}-->
            <!--{if strlen($arrForm[$key1].value) > 0 && strlen($arrForm[$key2].value) > 0 && strlen($arrForm[$key3].value) > 0}-->
            <!--{$arrForm[$key3].value|h}-->/<!--{$arrForm[$key2].value|h}-->/<!--{$arrForm[$key1].value|h}-->
            <!--{else}-->
            Chưa đăng ký
            <!--{/if}-->
        </td>
    </tr>
    <tr>
        <th>Số điện thoại</th>
        <td>
            <!--{assign var=key1 value="`$prefix`tel01"}-->
            <!--{assign var=key2 value="`$prefix`tel02"}-->
            <!--{assign var=key3 value="`$prefix`tel03"}-->
            <!--{$arrForm[$key1].value|h}--> - <!--{$arrForm[$key2].value|h}--> - <!--{$arrForm[$key3].value|h}-->
        </td>
    </tr>
    <tr>
        <th>Email</th>
        <td>
            <!--{assign var=key1 value="`$prefix`email"}-->
            <a href="mailto:<!--{$arrForm[$key1].value|escape:'hex'}-->"><!--{$arrForm[$key1].value|escape:'hexentity'}--></a>
        </td>
    </tr>
    <!--{if $emailMobile}-->
        <tr>
            <th>Địa chỉ email trên điện thoại</th>
            <td>
                <!--{assign var=key1 value="`$prefix`email_mobile"}-->
                <!--{if strlen($arrForm[$key1].value) > 0}-->
                    <a href="mailto:<!--{$arrForm[$key1].value|escape:'hex'}-->"><!--{$arrForm[$key1].value|escape:'hexentity'}--></a>
                <!--{else}-->
                    Chưa đăng ký
                <!--{/if}-->
            </td>
        </tr>
    <!--{/if}-->
    <tr>
        <th>Mật khẩu</th>
        <td><!--{$passlen}--></td>
    </tr>
    <tr>
        <th>Gợi ý khi bạn quên mật khẩu</th>
        <td>
            <!--{assign var=key1 value="`$prefix`reminder"}-->
            <!--{assign var=key2 value="`$prefix`reminder_answer"}-->
            <!--{assign var="reminder_id" value=$arrForm[$key1].value}-->
            Câu hỏi：<!--{$arrReminder[$reminder_id]|h}--><br />
            Câu trả lời：<!--{$arrForm[$key2].value|h}-->
        </td>
    </tr>
    <tr>
        <th>Nhận thông báo qua email</th>
        <td>
            <!--{assign var=key1 value="`$prefix`mailmaga_flg"}-->
            <!--{assign var="mailmaga_flg_id" value=$arrForm[$key1].value}-->
            <!--{$arrMAILMAGATYPE[$mailmaga_flg_id]|h}-->
        </td>
    </tr>
<!--{/strip}-->
