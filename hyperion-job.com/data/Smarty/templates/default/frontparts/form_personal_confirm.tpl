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

<!--{strip}-->
    <col width="30%" />
    <col width="70%" />
    <tr>
        <th>お名前</th>
        <td>
            <!--{assign var=key1 value="`$prefix`name01"}-->
            <!--{assign var=key2 value="`$prefix`name02"}-->
            <!--{$arrForm[$key1].value|h}-->&nbsp;
            <!--{$arrForm[$key2].value|h}-->
        </td>
    </tr>
    <tr>
        <th>お名前(フリガナ)</th>
        <td>
            <!--{assign var=key1 value="`$prefix`kana01"}-->
            <!--{assign var=key2 value="`$prefix`kana02"}-->
            <!--{$arrForm[$key1].value|h}-->&nbsp;
            <!--{$arrForm[$key2].value|h}-->
        </td>
    </tr>
    <tr>
        <th>性別</th>
        <td>
            <!--{assign var=key1 value="`$prefix`sex"}-->
            <!--{assign var="sex_id" value=$arrForm[$key1].value}-->
            <!--{$arrSex[$sex_id]|h}-->
        </td>
    </tr>
    <tr>
        <th>生年月日</th>
        <td>
            <!--{assign var=key1 value="`$prefix`year"}-->
            <!--{assign var=key2 value="`$prefix`month"}-->
            <!--{assign var=key3 value="`$prefix`day"}-->
            <!--{if strlen($arrForm[$key1].value) > 0 && strlen($arrForm[$key2].value) > 0 && strlen($arrForm[$key3].value) > 0}-->
            <!--{$arrForm[$key1].value|h}-->年<!--{$arrForm[$key2].value|h}-->月<!--{$arrForm[$key3].value|h}-->日
            <!--{else}-->
            未登録
            <!--{/if}-->
        </td>
    </tr>
    <tr>
        <th>電話番号</th>
        <td>
            <!--{assign var=key1 value="`$prefix`tel01"}-->
            <!--{assign var=key2 value="`$prefix`tel02"}-->
            <!--{assign var=key3 value="`$prefix`tel03"}-->
            <!--{$arrForm[$key1].value|h}--> - <!--{$arrForm[$key2].value|h}--> - <!--{$arrForm[$key3].value|h}-->
        </td>
    </tr>
    <tr>
        <th>メールアドレス</th>
        <td>
            <!--{assign var=key1 value="`$prefix`email"}-->
            <a href="mailto:<!--{$arrForm[$key1].value|escape:'hex'}-->"><!--{$arrForm[$key1].value|escape:'hexentity'}--></a>
        </td>
    </tr>
    <!--{if $emailMobile}-->
        <tr>
            <th>携帯メールアドレス</th>
            <td>
                <!--{assign var=key1 value="`$prefix`email_mobile"}-->
                <!--{if strlen($arrForm[$key1].value) > 0}-->
                    <a href="mailto:<!--{$arrForm[$key1].value|escape:'hex'}-->"><!--{$arrForm[$key1].value|escape:'hexentity'}--></a>
                <!--{else}-->
                    未登録
                <!--{/if}-->
            </td>
        </tr>
    <!--{/if}-->
    <tr>
        <th>希望するパスワード</th>
        <td><!--{$passlen}--></td>
    </tr>
    <tr>
        <th>パスワードを忘れた時のヒント</th>
        <td>
            <!--{assign var=key1 value="`$prefix`reminder"}-->
            <!--{assign var=key2 value="`$prefix`reminder_answer"}-->
            <!--{assign var="reminder_id" value=$arrForm[$key1].value}-->
            質問：<!--{$arrReminder[$reminder_id]|h}--><br />
            答え：<!--{$arrForm[$key2].value|h}-->
        </td>
    </tr>
    <tr>
        <th>メールマガジン</th>
        <td>
            <!--{assign var=key1 value="`$prefix`mailmaga_flg"}-->
            <!--{assign var="mailmaga_flg_id" value=$arrForm[$key1].value}-->
            <!--{$arrMAILMAGATYPE[$mailmaga_flg_id]|h}-->
        </td>
    </tr>
<!--{/strip}-->
