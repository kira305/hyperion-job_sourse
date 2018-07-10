<div id="undercolumn">
    <h2 class="title margn"><!--{$tpl_title|h}--></h2>
    <div class="mylist_navi">
        <a href="/entry/cv.php" class="bttn">オンラインで履歴書記入</a>
        <a href="/entry/cv_upload.php" class="bttn">履歴書ファイルUpload</a>
    </div>
    
    <form name="form1" id="form1" method="post" action="/user_data/apply.php">
        <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
        <input type="hidden" name="mode" value="finish" />
        
        <!--{if $arrForm.cv == "" && $arrForm.current_address == ""}-->
            You have to regist or upload your CV in order to apply job.
            <br />
            <div class="btn_area">
                <ul>
                    <!--{if $applyProductId > 0}-->
                    <li>
                        <a href="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$applyProductId|u}-->" class="bttn">仕事詳細に戻る</a>
                    </li>
                    <!--{/if}-->
                </ul>
            </div>
        <!--{else}-->
            <!--{if $arrForm.cv != ""}-->
                <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_cv_upload_confirm.tpl" flgFields=3 emailMobile=true prefix=""}-->
            <!--{/if}-->
            <!--{if $arrForm.current_address != ""}-->
                <!--{include file="`$smarty.const.TEMPLATE_REALDIR`frontparts/form_cv_confirm.tpl" flgFields=3 emailMobile=true prefix=""}-->
            <!--{/if}-->
            <br />
            <div class="btn_area">
                <ul>
                    <!--{if $applyProductId > 0}-->
                    <li>
                        <a href="#" class="bttn" onClick="eccube.setModeAndSubmit('finish', '', '');">応募を完了する</a>
                    </li>
                    <li>
                        <a href="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$applyProductId|u}-->" class="bttn">仕事詳細に戻る</a>
                    </li>
                    <!--{/if}-->
                </ul>
            </div>
        <!--{/if}-->
    </form>
</div>