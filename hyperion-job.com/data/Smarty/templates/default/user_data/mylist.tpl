<script type="text/javascript">//<![CDATA[
    function fnInCart(th, mode) {
        var cartForm = $(th).closest('form');
        cartForm.find('input[name=mode]').val(mode);
        cartForm.submit();
    }
    
    $(document).ready(function() {
	$("h3 a, .skill").dotdotdot({
            ellipsis	: '...',
            wrap	: 'letter',
            height	: null
	});
    });

    $(window).load(function(){
        if($('.list_area_form').length > 0){
            for (var i = 0; i < $('.list_area_form').length; i += 2) {
                if( $('.list_area_form').eq(i).height() > $('.list_area_form').eq(i+1).height() ){
                    $('.list_area_form .list_area').eq(i+1).height( $('.list_area_form .list_area').eq(i).height() );
                } else {
                    $('.list_area_form .list_area').eq(i).height( $('.list_area_form .list_area').eq(i+1).height() );
                }
            }
        }
    });
//]]></script>

<h2 class="title"><!--{$tpl_subtitle|h}--></h2>

<!--{foreach from=$arrProducts item=arrProduct name=arrProducts}-->

    <!--{if $smarty.foreach.arrProducts.first}-->
        <!--▼件数-->
        <div class="product_count">
            <span class="attention"><!--{$tpl_linemax}-->件</span>の案件がございます。
        </div>
        <!--▲件数-->
    <!--{/if}-->

    <!--{assign var=id value=$arrProduct.product_id}-->
    <!--{assign var=arrErr value=$arrProduct.arrErr}-->
    <!--▼仕事-->
    <form name="product_form<!--{$id|h}-->" action="?" class="list_area_form" method="post">
        <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
        <input type="hidden" name="mode" value="" />
        <input type="hidden" name="l" value="<!--{$l}-->" />
        <input type="hidden" name="product_id" value="<!--{$id|h}-->" />
        <input type="hidden" name="product_class_id" id="product_class_id<!--{$id|h}-->" value="<!--{$tpl_product_class_id[$id]}-->" />
        <div class="list_area clearfix">
            <a name="product<!--{$id|h}-->"></a>
            <!--★仕事名★-->
            <h3>
                <a target="_blank" href="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$arrProduct.product_id|u}-->"><!--{$arrProduct.name|h}--></a>
            </h3>

            <div class="table">
                <div class="table_cell">
                    <!--{if count($productStatus[$id]) > 0}-->
                    <!--▼仕事ステータス-->
                        <p class="product_status">
                        <!--{foreach from=$productStatus[$id] item=status}-->
                            <span><!--{$arrSTATUS[$status]}--></span>
                        <!--{/foreach}-->
                        </p>
                    <!--▲仕事ステータス-->
                    <!--{/if}-->
                    <p><b>雇用形態：</b><!--{$arrEmploymentStatus[$arrProduct.employment_status]|h}--></p>
                    <p><b>給与：</b><!--{$arrProduct.salary_full|h}--></p>
                    <p><b>勤務地：</b><!--{$arrRegion[$arrProduct.region]}--> <!--{$arrCity[$arrProduct.city]}--> <!--{$arrProduct.work_location}--></p>
                </div>
                <div class="table_cell">
                    <div class="listphoto">
                        <a target="_blank" href="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$arrProduct.product_id|u}-->">
                            <img src="<!--{$arrProduct.base64_image|h}-->" alt="<!--{$arrProduct.name|h}-->" class="picture" /></a>
                    </div>
                </div>
            </div>

            <p class="skill"><b>応募条件：</b><!--{$arrProduct.skill|h|nl2br}--><br />　<!--{$arrProduct.qualification|h|nl2br}--></p>

            <ul class="list_button">
                <!--{if !($l == 'keep')}-->
                    <!--{if $arrProduct.is_favorite }-->
                        <li><a href="#">お気に入り</a></li>
                    <!--{else}-->
                        <li><a href="#" onclick="fnInCart(this, 'cart'); return false;">お気に入り登録</a></li>
                    <!--{/if}-->
                <!--{else}-->
                    <li><a href="#" onclick="fnInCart(this, 'delete'); return false;">お気に入りのお仕事を削除する</a></li>
                <!--{/if}-->
                <li><a target="_blank" href="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$arrProduct.product_id|u}-->">詳細をもっと見る</a></li>
            </ul>
        </div>
    </form>
    <!--▲仕事-->
<!--{foreachelse}-->
    <!--{include file="frontparts/search_zero.tpl"}-->
<!--{/foreach}-->
