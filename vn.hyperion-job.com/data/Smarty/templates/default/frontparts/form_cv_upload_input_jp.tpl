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
<script type="text/javascript">
    $(function(){
        $('input[type=file][name=down_file]').change(function(e){
            eccube.setModeAndSubmit('upload_down', '', '');
        });
    });
</script>
<table>
    <col width="30%" />
    <col width="70%" />
    <tr class="type-download">
        <!--{assign var=key value="down_file"}-->
        <th>履歴書ファイルアップロード</th>
        <td>
            <a name="<!--{$key}-->"></a>
            <span class="attention"><!--{$arrErr[$key]}--><!--{$arrErr.cv}--></span>
            <!--{if $arrForm.cv != ""}-->
                <!--{$arrForm.cv_name|h}-->
                <input type="hidden" name="cv" value="<!--{$arrForm.cv|h}-->">
                <input type="hidden" name="cv_name" value="<!--{$arrForm.cv_name|h}-->">
                <a href="" onclick="eccube.setModeAndSubmit('delete_down', '', ''); return false;">[ファイルの取り消し]</a><br />
            <!--{/if}-->
            <input type="file" name="<!--{$key}-->" size="40" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" />
            <br />登録可能拡張子：<!--{$smarty.const.DOWNLOAD_EXTENSION}-->
        </td>
    </tr>
</table>
    
<!--{/strip}-->
