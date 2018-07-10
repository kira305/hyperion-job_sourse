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

<div id="mypagecolumn">
    <h2 class="title"><!--{$tpl_subtitle|h}--></h2>
    <div id="mycontents_area">    
        <!--{if $smarty.post.mode != ''}-->
        <p>Vui lòng nhập thông tin vào những mục dưới đây.「<span class="attention">※</span>」là những mục bắt buộc phải nhập.<br />
            Sau khi nhập đầy đủ thông tin, ấn nút Lưu ở bên dưới.</p>
        <!--{/if}-->

        <form name="form1" id="form1" method="post" action="?">
            <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
            <input type="hidden" name="mode" value="confirm" />
            <input type="hidden" name="customer_id" value="<!--{$arrForm.customer_id.value|h}-->" />
            <table summary="会員登録内容変更 " class="delivname">
                <!--{if $smarty.post.mode == ''}-->
                    <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_personal_confirm.tpl" flgFields=3 emailMobile=false prefix=""}-->
                <!--{else}-->
                    <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_personal_input.tpl" flgFields=3 emailMobile=false prefix=""}-->
                <!--{/if}-->
            </table>
            <div class="btn_area">
                <ul>
                    <!--{if $smarty.post.mode == ''}-->
                    <li>
                        <input type="button" class="bttn" value="Chỉnh sửa" onClick="eccube.setModeAndSubmit('edit', '', '');" />
                    </li>
                    <!--{else}-->
                    <li>
                        <input type="submit" name="confirm" value="Lưu" />
                    </li>
                    <li>
                        <input type="button" class="bttn back" value="Bỏ qua" onClick="eccube.setModeAndSubmit('profile', '', '');" />
                    </li>
                    <!--{/if}-->
                </ul>
            </div>
        </form>
    </div>
</div>
