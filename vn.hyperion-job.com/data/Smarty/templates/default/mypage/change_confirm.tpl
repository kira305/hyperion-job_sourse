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
        <p>Bạn có đồng ý gửi nội dung như bên dưới hay không?<br />
           Nếu đồng ý, vui lòng nhấn nút Gửi để tiếp tục.</p>

        <form name="form1" id="form1" method="post" action="?">
            <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
            <input type="hidden" name="mode" value="complete" />
            <input type="hidden" name="customer_id" value="<!--{$arrForm.customer_id.value|h}-->" />
            <!--{foreach from=$arrForm key=key item=item}-->
                <!--{if $key ne "mode" && $key ne "subm"}-->
                <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item.value|h}-->" />
                <!--{/if}-->
            <!--{/foreach}-->
            <table summary=" " class="delivname">
                <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_personal_confirm.tpl" flgFields=3 emailMobile=false prefix=""}-->
            </table>

            <div class="btn_area">
                <ul>
                    <li>
                        <a href="?" onclick="eccube.setModeAndSubmit('return', '', ''); return false;" class="bttn back">Quay lại</a>
                    </li>
                    <li>
                        <input type="submit" value="Gửi" name="complete" id="complete" />
                    </li>
                </ul>
            </div>
        </form>
    </div>
</div>
