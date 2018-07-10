<!--{strip}-->
<script>
    $(document).ready(function() {
  $(".trunc20, .trunc40").dotdotdot({
            ellipsis  : '...',
            wrap  : 'letter',
            height  : null
  });
    });
</script>
<div class="block_outer">
    <div id="newproduct_area">
        <div class="table">
            <div class="table_cell">
                <!--{if $page == "index"}-->
                <a href="/user_data/vietnam.php" class="bttn">Tìm việc tại Việt Nam　>></a>
                <!--{else}-->
                <p class="newproduct_block_title">Việc làm <!--{$arrStatus[1]}--></p>
                <!--{/if}-->
                <div class="newproduct_block">
                    <!--{foreach from=$arrFirstColumnProducts item=arrProduct}-->
                    <a target="_blank" href="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$arrProduct.product_id|u}-->">
                        <div class="newproduct_list table">
                            <div class="table_cell">
                                <div class="trunc20"><!--{$arrProduct.salary_full|h}--></div>
                                <div class="trunc40"><!--{$arrRegion[$arrProduct.region]}--> <!--{$arrCity[$arrProduct.city]}--><br /><!--{$arrProduct.work_location_vn}--></div>
                            </div>
                            <div class="table_cell">
                                <div class="trunc20 name"><!--{$arrProduct.name_vn}--></div>
                                <div class="trunc40"><!--{$arrProduct.main_list_comment_vn|h}--></div>
                            </div>
                        </div>
                    </a>
                    <!--{/foreach}-->
                </div>
            </div>
            <div class="table_cell">
                <!--{if $page == "index"}-->
                <a href="/user_data/japan.php" class="bttn">Tìm việc tại Nhật Bản　>></a>
                <!--{else}-->
                <p class="newproduct_block_title">Việc làm <!--{$arrStatus[2]}--></p>
                <!--{/if}-->
                <div class="newproduct_block">
                    <!--{foreach from=$arrSecondColumnProducts item=arrProduct}-->
                    <a target="_blank" href="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$arrProduct.product_id|u}-->">
                        <div class="newproduct_list table">
                            <div class="table_cell">
                                <div class="trunc20"><!--{$arrProduct.salary_full|h}--></div>
                                <div class="trunc40"><!--{$arrRegion[$arrProduct.region]}--> <!--{$arrCity[$arrProduct.city]}--><br /><!--{$arrProduct.work_location_vn}--></div>
                            </div>
                            <div class="table_cell">
                                <div class="trunc20 name"><!--{$arrProduct.name_vn}--></div>
                                <div class="trunc40"><!--{$arrProduct.main_list_comment_vn|h}--></div>
                            </div>
                        </div>
                    </a>
                    <!--{/foreach}-->
                </div>
            </div>
        </div>
    </div>
</div>
<!--{/strip}-->
            