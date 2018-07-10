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

<div id="undercolumn">
    <div id="undercolumn_entry">
        <h2 class="title"><!--{$tpl_title|h}--></h2>
        <p>Bạn có đồng ý gửi nội dung như bên dưới hay không?<br />
            Nếu đồng ý vui lòng nhấn nút <!--{if $applyProductId > 0}-->Ứng tuyển<!--{else}-->Hoàn thành<!--{/if}-->&nbsp;để hoàn thành</p>
        <form name="form1" id="form1" method="post" action="?" enctype="multipart/form-data">
            <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
            <input type="hidden" name="mode" value="complete">
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
            <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_cv_confirm.tpl" flgFields=3 emailMobile=true prefix=""}-->

            <div class="btn_area">
                <ul>
                    <li>
                        <a href="?" onclick="eccube.setModeAndSubmit('return', '', ''); return false;" class="bttn back">Quay lại</a>
                    </li>
                    <li>
                        <!--{if $applyProductId > 0}-->
                        <input type="submit" name="send" id="send" value="Ứng tuyển" />
                        <!--{else}-->
                        <input type="submit" name="send" id="send" value="Hoàn thành" />
                        <!--{/if}-->
                    </li>
                </ul>
            </div>

        </form>
    </div>
</div>
