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
        $('input[type=file][name=resume_file]').change(function(e){
            eccube.setModeAndSubmit('resume_file', '', '');
        });
    });
</script>
<style>
    h1.title_text {
        color: #666;
        padding-bottom: 2px;
        border-bottom: 1px solid #7a7b80;
        margin-bottom: 4px;
    }

    .m-t-10 {
        margin-top: 10px;
    }
</style>
<table>
    <col width="30%" />
    <col width="70%" />
    <tr class="type-download">

        <th>履歴書ファイルアップロード</th>
        <td>
            <!--{assign var=key value="down_file"}-->
            <h1 class="title_text">履歴書</h1>
            <a name="<!--{$key}-->"></a>
            <span class="attention"><!--{$arrErr[$key]}--><!--{$arrErr.cv}--></span>
            <!--{if $arrForm.cv != ""}-->
                <!--{$arrForm.cv_name|h}-->
                <input type="hidden" name="cv" value="<!--{$arrForm.cv|h}-->">
                <input type="hidden" name="cv_name" value="<!--{$arrForm.cv_name|h}-->">
                <a href="" onclick="eccube.setModeAndSubmit('delete_down', '', ''); return false;">[削除]</a><br />
            <!--{/if}-->
            <input type="file" name="<!--{$key}-->" size="40" style="<!--{$arrErr[$key]|sfGetErrorColor}-->" />
            <br />登録可能拡張子：<!--{$smarty.const.DOWNLOAD_EXTENSION}-->

            <!--{assign var= key2 value="resume_file"}-->
            <h1 class="title_text m-t-10">職務履歴書</h1>
            <a name="<!--{$key2}-->"></a>
            <span class="attention"><!--{$arrErr[$key2]}--><!--{$arrErr.resume}--></span>
            <!--{if $arrForm.resume != ""}-->
            <!--{$arrForm.resume_name|h}-->
            <input type="hidden" name="resume" value="<!--{$arrForm.resume|h}-->">
            <input type="hidden" name="resume_name" value="<!--{$arrForm.resume_name|h}-->">
            <a href="" onclick="eccube.setModeAndSubmit('delete_down_resume', '', ''); return false;">[削除]</a><br />
            <!--{/if}-->
            <input type="file" name="<!--{$key2}-->" size="40" style="<!--{$arrErr[$key2]|sfGetErrorColor}-->" />
            <br />登録可能拡張子：<!--{$smarty.const.DOWNLOAD_EXTENSION}-->
        </td>
    </tr>
</table>
    
<!--{/strip}-->
