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
        <p>Nếu đồng ý với các thông tin dưới đây, vui lòng ấn nút Gửi<br />
            các thông tin của bạn sẽ được gửi đi</p>

        <form name="form1" id="form1" method="post" action="?" enctype="multipart/form-data">
            <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
            <input type="hidden" name="mode" value="<!--{if $content == 'info'}-->complete<!--{else}-->cv_complete<!--{/if}-->" />
            <input type="hidden" name="customer_id" value="<!--{$arrForm.customer_id.value|h}-->" />
            <!--{foreach key=key item=item from=$arrForm.arrHidden}-->
                <input type="hidden" name="<!--{$key}-->" value="<!--{$item|h}-->" />
            <!--{/foreach}-->
            <!--{foreach from=$arrForm key=key item=item}-->
                <!--{if $key ne "mode" && $key ne "subm"}-->
                    <!--{if is_array($item)}-->
                        <!--{foreach item=statusVal from=$item}-->
                            <input type="hidden" name="<!--{$key}-->[]" value="<!--{$statusVal|h}-->" />
                        <!--{/foreach}-->
                    <!--{else}-->
                        <input type="hidden" name="<!--{$key|h}-->" value="<!--{$item|h}-->" />
                    <!--{/if}-->
                <!--{/if}-->
            <!--{/foreach}-->
            
            <!--{if $content == 'info'}-->
                <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_cv_confirm.tpl" flgFields=3 emailMobile=true prefix=""}-->
            <!--{else}-->
                <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_cv_upload_confirm.tpl"}-->
            <!--{/if}-->

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
