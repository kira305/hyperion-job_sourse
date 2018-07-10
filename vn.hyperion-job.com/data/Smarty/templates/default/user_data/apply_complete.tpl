<div id="undercolumn">
    <h2 class="title margn">Ứng tuyển</h2>
    <div id="complete_area">
        <p class="message">Ứng tuyển thành công.</p>
        <p>Chúng tôi sẽ sớm liên hệ lại với bạn.</p>

        <br />
        <div class="btn_area">
            <ul>
                <li>
                    <a href="<!--{if $smarty.session.lastListUrl != ''}--><!--{$smarty.session.lastListUrl}--><!--{else}--><!--{$smarty.const.ROOT_URLPATH}-->products/list.php<!--{/if}-->" class="bttn">Đến trang danh sách công việc</a>
                </li>
                <li>
                    <a href="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$applyProductId|u}-->" class="bttn">Đến trang thông tin công việc</a>
                </li>
            </ul>
        </div>
    </div>
</div>