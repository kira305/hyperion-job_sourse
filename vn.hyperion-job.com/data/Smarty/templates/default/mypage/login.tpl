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

<div id="undercolumn">
    <h2 class="title">Trang cá nhân (Đăng nhập)</h2>
    <div id="undercolumn_login">
        <form name="login_mypage" id="login_mypage" method="post" action="<!--{$smarty.const.HTTPS_URL}-->frontparts/login_check.php" onsubmit="return eccube.checkLoginFormInputted('login_mypage')">
            <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
            <input type="hidden" name="mode" value="login" />
            <input type="hidden" name="url" value="<!--{if $applyProductId > 0}-->/products/detail.php?product_id=<!--{$applyProductId}--><!--{else}--><!--{$smarty.server.REQUEST_URI|h}--><!--{/if}-->" />

            <div class="login_area">
                <h3>Đăng nhập nếu bạn đã có tài khoản</h3>
                <p class="inputtext">Trường hợp đã đăng ký thành viên, vui lòng nhập mail và mật khẩu để đăng nhập</p>
                <div class="inputbox">
                    <dl class="formlist clearfix">
                        <!--{assign var=key value="login_email"}-->
                        <dt>Email&nbsp;：</dt>
                        <dd>
                            <span class="attention"><!--{$arrErr[$key]}--></span>
                            <input type="text" name="<!--{$key}-->" value="<!--{$tpl_login_email|h}-->" maxlength="<!--{$arrForm[$key].length}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->; ime-mode: disabled;" class="box300" />
                            <p class="login_memory">
                                <!--{assign var=key value="login_memory"}-->
                                <input type="checkbox" name="<!--{$key}-->" value="1"<!--{$tpl_login_memory|sfGetChecked:1}--> id="login_memory" />
                                <label for="login_memory">Cho phép máy tính lưu địa chỉ email</label>
                            </p>
                        </dd>
                    </dl>
                    <dl class="formlist clearfix">
                        <!--{assign var=key value="login_pass"}-->
                        <dt>
                            Mật khẩu&nbsp;：
                        </dt>
                        <dd>
                            <span class="attention"><!--{$arrErr[$key]}--></span>
                            <input type="password" name="<!--{$key}-->" maxlength="<!--{$arrForm[$key].length}-->" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" class="box300" />
                        </dd>
                    </dl>
                    <div class="btn_area">
                        <ul>
                            <li style="vertical-align: top;">
                                <input type="submit" value="Đăng nhập" name="log" id="log" />
                            </li>
                            <li>
                                <div class="fb-login-button" data-max-rows="1" data-size="medium" data-button-type="login_with" data-show-faces="false" data-auto-logout-link="true" data-use-continue-as="false"></div>
                            </li>
                        </ul>
                    </div>
                </div>
                <p>
                    ※Trường hợp quên mật khẩu vui lòng nhấp vào <a href="<!--{$smarty.const.HTTPS_URL}-->forgot/<!--{$smarty.const.DIR_INDEX_PATH}-->" onclick="eccube.openWindow('<!--{$smarty.const.HTTPS_URL}-->forgot/<!--{$smarty.const.DIR_INDEX_PATH}-->','forget','600','460',{scrollbars:'no',resizable:'no'}); return false;" target="_blank">đây</a><br />
                    ※Trường hợp quên địa chỉ email hoặc gặp khó khăn khi đăng nhập vui lòng liên hệ với chúng tôi từ <a href="<!--{$smarty.const.HTTPS_URL}-->forgot/mail.php" onclick="eccube.openWindow('<!--{$smarty.const.HTTPS_URL}-->forgot/mail.php','forget','600','470',{scrollbars:'no',resizable:'no'}); return false;" target="_blank">trang liên hệ</a>
                </p>
            </div>

            <div class="login_area">
                <h3>Đăng ký nếu bạn chưa có tài khoản</h3>
                <p class="inputtext">Sau khi đăng ký thành viên, bạn có thể truy cập vào trang Cá nhân<br />
                    Chúng tôi có thể giới thiệu công việc theo mong muốn của bạn
                </p>
                <div class="inputbox">
                    <div class="btn_area">
                        <ul>
                            <li>
                                <a href="<!--{$smarty.const.ROOT_URLPATH}-->entry/kiyaku.php" class="bttn">Đăng ký</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
