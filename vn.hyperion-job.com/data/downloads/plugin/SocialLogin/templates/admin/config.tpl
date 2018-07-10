<!--{*
/*
 * This file is part of SocialLogin
 *
 * Copyright(c) 2012 Cyber-Will Inc. All Rights Reserved.
 *
 * http://www.cyber-will.co.jp/
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
*}-->
<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_header.tpl"}-->
<script type="text/javascript">
</script>

<h2><!--{$tpl_subtitle}--></h2>
<form name="form1" id="form1" method="post" action="<!--{$smarty.server.REQUEST_URI|h}-->">
<input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
<input type="hidden" name="mode" value="edit">
<table border="0" cellspacing="1" cellpadding="8" summary=" ">
    <!--{foreach from=$arrForm.name key=key item=name}-->
    <tr>
        <td bgcolor="#f3f3f3">
            <!--{$name}-->
            <input type="hidden" name="name[<!--{$key}-->]" value="<!--{$name}-->">
        </td>
        <td>
            <!--{if $arrErr.enabled[$key]}--><span class="red"><!--{$arrErr.enabled[$key]}--></span><br /><!--{/if}-->
            <input type="radio" name="enabled[<!--{$key}-->]" value="1" <!--{if $arrForm.enabled[$key] == "1"}-->checked<!--{/if}--> />有効<br />
            <input type="radio" name="enabled[<!--{$key}-->]" value="0" <!--{if $arrForm.enabled[$key] == "0"}-->checked<!--{/if}--> />無効
        </td>
        <td>
            <!--{if $arrErr.id[$key]}--><span class="red"><!--{$arrErr.id[$key]}--></span><br /><!--{/if}-->
            API ID/Key : <input type="text" name="id[<!--{$key}-->]" value="<!--{$arrForm.id[$key]}-->" size="30" class="box30" /><br />
            App Secret : <!--{if $arrErr.secret[$key]}--><span class="red"><!--{$arrErr.secret[$key]}--></span><br /><!--{/if}-->
            <input type="text" name="secret[<!--{$key}-->]" value="<!--{$arrForm.secret[$key]}-->" size="30" class="box30" />
        </td>
    </tr>
    <!--{/foreach}-->
</table>

<div class="btn-area">
    <ul>
        <li>
            <a class="btn-action" href="javascript:;" onclick="document.form1.submit();return false;"><span class="btn-next">この内容で登録する</span></a>
        </li>
    </ul>
</div>

</form>
<!--{include file="`$smarty.const.TEMPLATE_ADMIN_REALDIR`admin_popup_footer.tpl"}-->
