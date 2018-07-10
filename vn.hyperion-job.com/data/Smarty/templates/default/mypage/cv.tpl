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
<style>
    div.mycontents_area {
        border: 4px solid #CCC;
        padding: 20px;
    }
    p#separator{
        text-align: center;
        color: #000;
        margin: 30px 0;
        padding: 5px 0;
        font-size: 20px;
    }
</style>

<div id="mypagecolumn">
    <form name="form1" id="form1" method="post" action="?" enctype="multipart/form-data">
        <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
        <input type="hidden" name="mode" value="confirm" />
        <input type="hidden" name="customer_id" value="<!--{$arrForm.customer_id.value|h}-->" />
        <!--{foreach key=key item=item from=$arrForm.arrHidden}-->
            <input type="hidden" name="<!--{$key}-->" value="<!--{$item|h}-->" />
        <!--{/foreach}-->

        <!--{if $tpl_subtitle == 'Hồ sơ'}-->

        <h2 class="title"><!--{$tpl_subtitle|h}--></h2>
        <div id="mycontents_area">
            <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_cv_upload_confirm.tpl"}-->
            <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_cv_confirm.tpl" flgFields=3 emailMobile=true prefix=""}-->
            <div class="btn_area">
                <ul>
                    <!--{if $arrForm.current_address != ''}-->
                    <!--<li>
                        <input type="button" class="bttn" value="Tải hồ sơ đính kèm" onClick="eccube.setModeAndSubmit('pdf', '', '');" />
                    </li>-->
                    <!--{/if}-->
                    <li>
                        <input type="button" class="bttn" value="Chỉnh sửa" onClick="eccube.setModeAndSubmit('edit', '', '');" />
                    </li>
                </ul>
            </div>
        </div>

        <!--{else}-->

        <div class="mycontents_area">
            <h2 class="title">Tải hồ sơ trực tuyến</h2>
            <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_cv_upload_input.tpl"}-->
            <div class="btn_area">
                <ul>
                    <li>
                        <button class="bttn" type="button" onClick="eccube.setModeAndSubmit('cv_complete', '', '');"><span>Lưu</span></button>
                    </li>
                </ul>
            </div>
        </div>

        <div class="mycontents_area">
            <h2 class="title"><!--{$tpl_subtitle|h}--></h2>
            <p>Vui lòng nhập thông tin vào những mục dưới đây.「<span class="attention">※</span>」là những mục bắt buộc phải nhập<br />
                Sau khi nhập đầy đủ thông tin, ấn nút Lưu ở bên dưới</p>
            <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_cv_input.tpl" flgFields=3 emailMobile=true prefix=""}-->
            <div class="btn_area">
                <ul>
                    <li>
                        <input type="submit" name="confirm" value="Lưu" />
                    </li>
                    <li>
                        <input type="button" class="bttn back" value="Không lưu" onClick="eccube.setModeAndSubmit('cv', '', '');" />
                    </li>
                </ul>
            </div>
        </div>

        <!--{/if}-->

    </form>
</div>
