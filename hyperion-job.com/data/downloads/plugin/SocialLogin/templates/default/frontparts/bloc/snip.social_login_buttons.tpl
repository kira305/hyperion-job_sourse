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
<input type="hidden" name="provider" value="" />
<!--{foreach from=$providers key=name item=provider}-->
    <!--{if $provider.enabled == true}-->
        <a href="#" onclick="document.header_login_form.action = '<!--{$smarty.const.PLUGIN_HTML_URLPATH}-->SocialLogin/login_with_openid.php';fnSetFormSubmit('header_login_form', 'provider', '<!--{$name}-->');"><!--{$name}--> でログイン</a>
    <!--{/if}-->
<!--{/foreach}-->