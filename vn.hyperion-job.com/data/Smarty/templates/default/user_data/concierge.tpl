<h2 class="title margn"><!--{$tpl_title|h}--></h2>
<div id="concierge_detail_area" class="table">
    <div class="table_cell">
        <div id="concierge_detail">
            <div>
                <img src="<!--{$smarty.const.IMAGE_SAVE_URLPATH}--><!--{$currentConcierge.image}-->" alt="<!--{$currentConcierge.name}-->" />
                <p class="concierge_title">Tư vấn viên</p>
                <p class="concierge_name"><!--{$currentConcierge.name}--></p>
                <img src="<!--{$TPL_URLPATH}-->img/icon/ico_phone.png" alt="phone" /> <!--{$currentConcierge.tel}--><br />
                <img src="<!--{$TPL_URLPATH}-->img/icon/ico_mail.png" alt="mail" /> <!--{$currentConcierge.email}--><br />
                <p class="concierge_workplace"><!--{$arrTarget[$currentConcierge.workplace]}-->Văn phòng</p>
            </div>
            <p class="concierge_career"><!--{$currentConcierge.career|nl2br_html}--></p>
        </div>
    </div>
    <div class="table_cell">
        <!--{assign var=target value=0}-->
        <!--{if count($arrConcierge) > 0}-->
            <!--{foreach from=$arrConcierge item=concierge}-->
                <!--{if $concierge.workplace != $target}-->
                <p><!--{$arrTarget[$concierge.workplace]}-->Văn phòng</p>
                <!--{assign var=target value=$concierge.workplace}-->
                <!--{/if}-->
                <a href="/user_data/concierge.php?id=<!--{$concierge.member_id}-->">
                    <img src="<!--{$smarty.const.IMAGE_SAVE_URLPATH}--><!--{$concierge.image}-->" alt="<!--{$concierge.name}-->" />
                    <p class="name"><!--{$concierge.name}--></p>
                </a>
            <!--{/foreach}-->
        <!--{/if}-->
    </div>
</div>