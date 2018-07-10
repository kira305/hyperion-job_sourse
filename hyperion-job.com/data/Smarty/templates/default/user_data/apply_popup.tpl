<style>
    #container { width: 100% }
    #topcolumn { display: none; }
</style>

<script>
    $(function(){
        <!--{if $url != ''}-->
        parent.$.colorbox.close();
        window.parent.location.href = '<!--{$url}-->';
        <!--{/if}-->
        
        $('.bttn.back').click(function(){
            parent.$.colorbox.close();
        });
    });
</script>

<div id="apply_popup">
    <form name="form1" id="form1" method="post" action="?">
        <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
        <input type="hidden" name="mode" value="" />
        <div id="concierge_area">
            <div id="concierge_photo">
                <img src="<!--{$customer_data.image}-->" alt="<!--{$customer_data.name01}--> <!--{$customer_data.name02}-->" />
            </div>
            <div id="concierge_info">
                <div class="concierge_name"><!--{$customer_data.name01}--> <!--{$customer_data.name02}--></div>
                メール：<!--{$customer_data.email}--><br />
                電話番号：<!--{$customer_data.tel01}--><!--{$customer_data.tel02}--><!--{$customer_data.tel03}--><br />
            </div>
        </div>
        <!--{if $page == 'complete'}-->
        <div id="complete_area">
            <p>応募を完了いたしました。</p>
            <p>担当者からの連絡をお待ちしてください。</p>
        </div>
        <!--{else}-->
        <div id="cv_area">
            <!--{if $customer_data.current_address == ""}-->
            <label><input type="radio" name="apply_type" value="1" />オンラインで履歴書記入</label>
            <!--{else}-->
            <label><input type="radio" name="apply_type" value="2" />登録した履歴書を使用する</label>
            <!--{/if}-->
            
            <!--{if $customer_data.cv != ""}-->
            <label><input type="radio" name="apply_type" value="3" />アップロードした履歴書ファイルを使用する</label>
            <!--{/if}-->
            
            <label><input type="radio" name="apply_type" value="4" />新しい履歴書ファイルをアップロードする</label>
        </div>
        <div class="btn_area">
            <ul>
                <li>
                    <a href="#" data-url="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$applyProductId|u}-->" class="bttn back">仕事詳細に戻る</a>
                </li>
                <li>
                    <a href="#" class="bttn" onClick="eccube.setModeAndSubmit('finish', '', '');">応募する</a>
                </li>
            </ul>
        </div>
        <!--{/if}-->
    </form>
</div>