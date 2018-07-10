<div id="undercolumn">
    <h2 class="title margn"><!--{$tpl_title|h}--></h2>
    <div id="complete_area">
        <p class="message">応募手続きは完了しました。</p>
        <p>担当者からの連絡をお待ちください。</p>

        <br />
        <div class="btn_area">
            <ul>
                <li>
                    <a href="<!--{if $smarty.session.lastListUrl != ''}--><!--{$smarty.session.lastListUrl}--><!--{else}--><!--{$smarty.const.ROOT_URLPATH}-->products/list.php<!--{/if}-->" class="bttn">仕事リストに戻る</a>
                </li>
                <li>
                    <a href="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$applyProductId|u}-->" class="bttn">仕事詳細に戻る</a>
                </li>
            </ul>
        </div>
    </div>
</div>