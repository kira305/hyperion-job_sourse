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

 <script type="text/javascript">//<![CDATA[
    $(function(){
        $('.finishOrder').click(function(){
            $.colorbox({href:"<!--{$smarty.const.ROOT_URLPATH}--><!--{$smarty.const.USER_DIR}-->apply_popup.php", iframe:true, fastIframe:false, width:"600px", height:"360px", transition:"fade", scrolling:false});
        });
    });
//]]></script>

<div id="undercolumn">
    <div id="undercolumn_entry">
        <h2 class="title"><!--{$tpl_title|h}--></h2>
        <div id="complete_area">
            <p class="message">会員登録を完了いたしました。</p>
            <p>●　アルバイトを探している方はそのままお仕事をお探しし応募してください。<br />
●　正社員の仕事をお探しの方は「履歴書記入」または「履歴書ファイルupload」を選び、手続きをすすめてください。<br />
登録後にも情報を修正することが出来ます。</p>

            <br />
            <form name="form1" id="form1" method="post" action="/user_data/apply.php">
                <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
                <input type="hidden" name="mode" value="finish" />
                <div class="btn_area">
                    <ul>
                        <li>
                            <a href="/entry/cv.php" class="bttn">履歴書記入</a>
                        </li>
                        <li>
                            <a href="/entry/cv_upload.php" class="bttn">履歴書ファイルupload</a>
                        </li>
                        <!--{if $applyProductId > 0}-->
                            <!--{if $applyProductEmploymentStatus > 1}-->
                            <li>
                                <a href="#" class="bttn finishOrder">応募を完了する</a>
                            </li>
                            <!--{/if}-->
                            <li>
                                <a href="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$applyProductId|u}-->" class="bttn">仕事詳細に戻る</a>
                            </li>
                        <!--{else}-->
                            <li>
                                <a href="<!--{$smarty.const.ROOT_URLPATH}-->products/list.php" class="bttn">仕事情報一覧へ</a>
                            </li>
                        <!--{/if}-->
                    </ul>
                </div>
            </form>
        </div>
    </div>
</div>
