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
<!--{include file="`$smarty.const.TEMPLATE_REALDIR`popup_header.tpl" subtitle="パスワードを忘れた方(完了ページ)"}-->

<div id="window_area">
    <h2 class="title">Quên mật khẩu</h2>
    <p class="information">Mật khẩu của bạn đã được cấp lại. Vui lòng sử dụng mật khẩu này để đăng nhập.<br />
        ※Để thay đổi mật khẩu vui lòng vào phần thay đổi thông tin cá nhân tại [Trang cá nhân]</p>
    <form action="?" method="post" name="form1">
        <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
        <div id="forgot">
            <!--{if $smarty.const.FORGOT_MAIL != 1}-->
                    <p><span class="attention"><!--{$arrForm.new_password}--></span></p>
            <!--{else}-->
            <p><span class="attention">Mật khẩu mới đã được gửi vào email đăng ký của bạn</span></p>
            <!--{/if}-->
        </div>
        <div class="btn_area">
            <ul>
                <li><a href="javascript:window.close()" class="bttn">Đóng</a></li>
            </ul>
        </div>
    </form>
</div>

<!--{include file="`$smarty.const.TEMPLATE_REALDIR`popup_footer.tpl"}-->
