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
<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_header.tpl"}-->

<script type="text/javascript">
<!--
self.moveTo(20,20);self.focus();

$(function(){
    $('#authority').on('change', function(){
        if($(this).val() == 2) {
            $('#concierge_info').show();
        } else {
            $('#concierge_info').hide();
        }
    });
});
//-->
</script>

<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
    <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
    <input type="hidden" name="mode" value="<!--{$tpl_mode|h}-->" />
    <input type="hidden" name="member_id" value="<!--{$tpl_member_id|h}-->" />
    <input type="hidden" name="pageno" value="<!--{$tpl_pageno|h}-->" />
    <input type="hidden" name="old_login_id" value="<!--{$tpl_old_login_id|h}-->" />
    <!--{foreach key=key item=item from=$arrForm.arrHidden}-->
    <input type="hidden" name="<!--{$key}-->" value="<!--{$item|h}-->" />
    <!--{/foreach}-->

    <h2>メンバー登録/編集</h2>

    <table>
        <col width="30%" />
        <col width="70%" />
        <tr>
            <th>名前<span class="attention"> ※</span></th>
            <td>
                <!--{if $arrErr.name}--><span class="attention"><!--{$arrErr.name}--></span><!--{/if}-->
                <input type="text" name="name" size="30" class="box30" value="<!--{$arrForm.name|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr.name|sfGetErrorColor}-->" />
            </td>
        </tr>
        <tr>
            <th>所属</th>
            <td>
                <!--{if $arrErr.department}--><span class="attention"><!--{$arrErr.department}--></span><!--{/if}-->
                <input type="text" name="department" size="30" class="box30" value="<!--{$arrForm.department|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr.department|sfGetErrorColor}-->" />
            </td>
        </tr>
        <tr>
            <th>ログインＩＤ<span class="attention"> ※</span></th>
            <td>
                <!--{if $arrErr.login_id}--><span class="attention"><!--{$arrErr.login_id}--></span><!--{/if}-->
                <input type="text" name="login_id" size="20" class="box20" value="<!--{$arrForm.login_id|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr.login_id|sfGetErrorColor}-->" />
                ※半角英数字<!--{$smarty.const.ID_MIN_LEN}-->～<!--{$smarty.const.ID_MAX_LEN}-->文字（記号可）
            </td>
        </tr>
        <tr>
            <th>パスワード<span class="attention"> ※</span></th>
            <td>
                <!--{if $arrErr.password}--><span class="attention"><!--{$arrErr.password}--><!--{$arrErr.password02}--></span><!--{/if}-->
                <input type="password" name="password" size="20" class="box20" value="<!--{$arrForm.password}-->" onfocus="<!--{$tpl_onfocus}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr.password|sfGetErrorColor}-->" />
                ※半角英数字<!--{$smarty.const.ID_MIN_LEN}-->～<!--{$smarty.const.ID_MAX_LEN}-->文字（記号可）
                <br />
                <input type="password" name="password02" size="20" class="box20" value="<!--{$arrForm.password02}-->" onfocus="<!--{$tpl_onfocus}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr.password02|sfGetErrorColor}-->" />
                <p><span class="attention mini">確認のために2度入力してください。</span></p>
            </td>
        </tr>
        <tr>
            <th>稼働/非稼働<span class="attention"> ※</span></th>
            <td>
                <!--{if $arrErr.work}--><span class="attention"><!--{$arrErr.work}--></span><!--{/if}-->
                <!--{assign var=key value="work"}-->
                <span style="<!--{$arrErr.work|sfGetErrorColor}-->">
                <input type="radio" id="<!--{$key}-->_1" name="<!--{$key}-->" value="1" <!--{$arrForm.work|sfGetChecked:1}--> /><label for="<!--{$key}-->_1"><!--{$arrWORK.1}--></label>
                <input type="radio" id="<!--{$key}-->_0" name="<!--{$key}-->" value="0" <!--{$arrForm.work|sfGetChecked:0}--> /><label for="<!--{$key}-->_0"><!--{$arrWORK.0}--></label>
                </span>
            </td>
        </tr>
        <tr>
            <th>権限<span class="attention"> ※</span></th>
            <td>
                <!--{if $arrErr.authority}--><span class="attention"><!--{$arrErr.authority}--></span><!--{/if}-->
                <select name="authority" id="authority" style="<!--{$arrErr.authority|sfGetErrorColor}-->">
                    <option value="">選択してください</option>
                    <!--{html_options options=$arrAUTHORITY selected=$arrForm.authority}-->
                </select>
            </td>
        </tr>
    </table>
                
    
    <div id="concierge_info" <!--{if $arrForm.authority != 2}-->style='display: none'<!--{/if}--> >
        <h2>コンシェルジュ紹介</h2>
        <table>
            <col width="30%" />
            <col width="70%" />
            <tr>
                <th>電話番号</th>
                <td>
                    <!--{if $arrErr.tel}--><span class="attention"><!--{$arrErr.tel}--></span><!--{/if}-->
                    <input type="text" name="tel" size="30" class="box30" value="<!--{$arrForm.tel|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr.tel|sfGetErrorColor}-->" />
                </td>
            </tr>
            <tr>
                <th>E-mail</th>
                <td>
                    <!--{if $arrErr.email}--><span class="attention"><!--{$arrErr.email}--></span><!--{/if}-->
                    <input type="text" name="email" size="30" class="box30" value="<!--{$arrForm.email|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr.email|sfGetErrorColor}-->" />
                </td>
            </tr>
            <tr>
                <th>職場</th>
                <td>
                    <!--{if $arrErr.workplace}--><span class="attention"><!--{$arrErr.workplace}--></span><!--{/if}-->
                    <!--{html_radios name="workplace" options=$arrTarget selected=$arrForm.workplace separator='&nbsp;&nbsp;'}-->
                </td>
            </tr>
            <tr>
                <th>経歴</th>
                <td>
                    <!--{if $arrErr.career}--><span class="attention"><!--{$arrErr.career}--></span><!--{/if}-->
                    <textarea name="career" cols="40" rows="6" class="area40" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.career|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.career|h}--></textarea><br />
                    <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                </td>
            </tr>
            <tr>
                <th>メッセージ</th>
                <td>
                    <!--{if $arrErr.message}--><span class="attention"><!--{$arrErr.message}--></span><!--{/if}-->
                    <textarea name="message" cols="40" rows="6" class="area40" maxlength="<!--{$smarty.const.MLTEXT_LEN}-->" style="<!--{$arrErr.message|sfGetErrorColor}-->"><!--{"\n"}--><!--{$arrForm.message|h}--></textarea><br />
                    <span class="attention"> (上限<!--{$smarty.const.MLTEXT_LEN}-->文字)</span>
                </td>
            </tr>
            <tr>
                <th>写真</th>
                <td>
                    <!--{assign var=key value="image"}-->
                    <!--{if $arrErr[$key]}--><span class="attention"><!--{$arrErr[$key]}--></span><!--{/if}-->
                    <!--{if $arrForm.arrFile[$key].filepath != ""}-->
                    <img src="<!--{$arrForm.arrFile[$key].filepath}-->" alt="<!--{$arrForm.name|h}-->" />　<a href="" onclick="eccube.setModeAndSubmit('delete_image', '', ''); return false;">[画像の取り消し]</a><br />
                    <!--{/if}-->
                    <input type="file" name="image" size="40" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" />
                    <a class="btn-normal" href="javascript:;" name="btn" onclick="eccube.setModeAndSubmit('upload_image', '', ''); return false;">アップロード</a>
                </td>
            </tr>
        </table>
    </div>

    <div class="btn-area">
        <ul>
            <li><a class="btn-action" href="javascript:;" onclick="if (!eccube.doConfirm()) return false; eccube.fnFormModeSubmit('form1', '<!--{$tpl_mode|h}-->', '', ''); return false;"><span class="btn-next">この内容で登録する</span></a></li>
        </ul>
    </div>
</form>

<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_footer.tpl"}-->
