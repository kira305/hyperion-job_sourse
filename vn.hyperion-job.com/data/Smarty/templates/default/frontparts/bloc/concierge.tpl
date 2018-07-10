<!--{strip}-->
    <div class="block_outer">
        <div id="concierge_list_area">
            <h2>Tư vấn viên</h2>
            <!--{foreach from=$arrConcierges item=concierge}-->
            <div class="concierge_list_block">
                <a href="/user_data/concierge.php?id=<!--{$concierge.member_id}-->">
                    <img src="<!--{$smarty.const.IMAGE_SAVE_URLPATH}--><!--{$concierge.image}-->" alt="<!--{$concierge.name}-->" />
                    <p class="name"><!--{$concierge.name}--></p>
                    <p>Tư vấn việc làm</p>
                </a>
            </div>
            <!--{/foreach}-->
        </div>
    </div>
<!--{/strip}-->
