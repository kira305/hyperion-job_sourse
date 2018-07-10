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

<div id="mynavi_area">
    <!--{strip}-->
    
        <div class="mylist_navi">
            <!--{* 会員状態 *}-->
            <!--{if $tpl_login}-->
                <a href="/mypage/change.php" class="bttn <!--{if $tpl_mypageno == 'change'}-->active<!--{/if}-->">プロフィール</a>
                <a href="/mypage/cv.php" class="bttn <!--{if $tpl_mypageno == 'cv'}-->active<!--{/if}-->">履歴書</a>
                <a href="/user_data/mylist.php?l=keep" class="bttn <!--{if $tpl_mypageno == 'keep'}-->active<!--{/if}-->">キープしたお仕事</a>
                <a href="/user_data/mylist.php?l=viewed" class="bttn <!--{if $tpl_mypageno == 'viewed'}-->active<!--{/if}-->">閲覧したお仕事</a>
                <a href="/user_data/mylist.php?l=applied" class="bttn <!--{if $tpl_mypageno == 'applied'}-->active<!--{/if}-->">応募したお仕事</a>
            <!--{* 退会状態 *}-->
            <!--{else}-->
                <a href="/user_data/mylist.php?l=keep" class="bttn <!--{if $tpl_mypageno == 'keep'}-->active<!--{/if}-->">キープしたお仕事</a>
                <a href="/user_data/mylist.php?l=viewed" class="bttn <!--{if $tpl_mypageno == 'viewed'}-->active<!--{/if}-->">閲覧したお仕事</a>
            <!--{/if}-->
        </div>
        
    <!--{/strip}-->

</div>
<!--▲NAVI-->
