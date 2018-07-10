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
<!--{include file="`$smarty.const.TEMPLATE_REALDIR`popup_header.tpl" subtitle="パスワードを忘れた方(入力ページ)"}-->

<div id="window_area">
    <h2>Cấp lại địa chỉ email</h2>
    <p class="information">Bạn vui lòng nhập địa chỉ email (để nhận thông tin), họ tên đã sử dụng để đăng nhập, số điện thoại và ngày tháng năm sinh</p>
    
    <p class='information attention'><!--{$msg}--></p>
    
    <form action="?" method="post" name="form1">
        <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
        <input type="hidden" name="mode" value="confirm" />
        
        <table>
            <col width="30%" />
            <col width="70%" />
            <tr>
                <th>Tên của bạn</th>
                <td>
                    <!--{assign var=key1 value="name01"}-->
                    <!--{assign var=key2 value="name02"}-->
                    <!--{if $arrErr[$key1] || $arrErr[$key2]}-->
                        <div class="attention"><!--{$arrErr[$key1]}--><!--{$arrErr[$key2]}--></div>
                    <!--{/if}-->
                    Họ&nbsp;<input type="text" name="<!--{$key1}-->" value="<!--{$arrForm[$key1]|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->; ime-mode: active;" class="box120" />&nbsp;
                    Tên&nbsp;<input type="text" name="<!--{$key2}-->" value="<!--{$arrForm[$key2]|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr[$key2]|sfGetErrorColor}-->; ime-mode: active;" class="box120" />
                </td>
            </tr>
            <tr>
                <th>Email<br />（để nhận thông tin）</th>
                <td>
                    <!--{assign var=key1 value="email"}-->
                    <!--{if $arrErr[$key1]}--><div class="attention"><!--{$arrErr[$key1]}--></div><!--{/if}-->
                    <input type="text" name="<!--{$key1}-->" value="<!--{$arrForm[$key1]|h}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->; ime-mode: disabled;" class="box300" /><br />
                </td>
            </tr>
            <tr>
                <th>Điện thoại</th>
                <td>
                    <!--{assign var=key1 value="tel01"}-->
                    <!--{assign var=key2 value="tel02"}-->
                    <!--{assign var=key3 value="tel03"}-->
                    <!--{if $arrErr[$key1] || $arrErr[$key2] || $arrErr[$key3]}-->
                        <div class="attention"><!--{$arrErr[$key1]}--><!--{$arrErr[$key2]}--><!--{$arrErr[$key3]}--></div>
                    <!--{/if}-->
                    <input type="text" name="<!--{$key1}-->" value="<!--{$arrForm[$key1]|h}-->" maxlength="<!--{$smarty.const.TEL_ITEM_LEN}-->" style="<!--{$arrErr[$key1]|sfGetErrorColor}-->; ime-mode: disabled;" class="box60" />&nbsp;-&nbsp;<input type="text" name="<!--{$key2}-->" value="<!--{$arrForm[$key2]|h}-->" maxlength="<!--{$smarty.const.TEL_ITEM_LEN}-->" style="<!--{$arrErr[$key2]|sfGetErrorColor}-->; ime-mode: disabled;" class="box60" />&nbsp;-&nbsp;<input type="text" name="<!--{$key3}-->" value="<!--{$arrForm[$key3]|h}-->" maxlength="<!--{$smarty.const.TEL_ITEM_LEN}-->" style="<!--{$arrErr[$key3]|sfGetErrorColor}-->; ime-mode: disabled;" class="box60" />
                </td>
            </tr>
            <tr>
                <th>Ngày sinh</th>
                <td>
                    <!--{assign var=key1 value="year"}-->
                    <!--{assign var=key2 value="month"}-->
                    <!--{assign var=key3 value="day"}-->
                    <!--{assign var=errBirth value="`$arrErr.$key1``$arrErr.$key2``$arrErr.$key3`"}-->
                    <!--{if $errBirth}-->
                        <div class="attention"><!--{$errBirth}--></div>
                    <!--{/if}-->
                    Ngày&nbsp;<select name="<!--{$key3}-->" style="<!--{$errBirth|sfGetErrorColor}-->">
                        <!--{html_options options=$arrDay selected=$arrForm[$key3]|default:''}-->
                    </select>&nbsp;
                    Tháng&nbsp;<select name="<!--{$key2}-->" style="<!--{$errBirth|sfGetErrorColor}-->">
                        <!--{html_options options=$arrMonth selected=$arrForm[$key2]|default:''}-->
                    </select>&nbsp;
                    Năm&nbsp;<select name="<!--{$key1}-->" style="<!--{$errBirth|sfGetErrorColor}-->">
                        <!--{html_options options=$arrYear selected=$arrForm[$key1]|default:''}-->
                    </select>&nbsp;
                    
                   
                </td>
            </tr>
        </table>
                    
        <div class="btn_area">
            <ul>
                <li><input type="submit" class="bttn" value="Tới trang xác nhận" name="confirm" id="confirm" /></li>
            </ul>
        </div>
    </form>
</div>
<!--{include file="`$smarty.const.TEMPLATE_REALDIR`popup_footer.tpl"}-->

