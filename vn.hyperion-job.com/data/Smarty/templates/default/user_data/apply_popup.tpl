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
                Email：<!--{$customer_data.email}--><br />
                Điện thoại：<!--{$customer_data.tel01}--><!--{$customer_data.tel02}--><!--{$customer_data.tel03}--><br />
            </div>
        </div>
        <!--{if $page == 'complete'}-->
        <div id="complete_area">
            <p>Ứng tuyển thành công</p>
            <p>Chúng tôi sẽ sớm liên hệ lại với bạn</p>
        </div>
        <!--{else}-->
        <div id="cv_area">
            <!--{if $customer_data.current_address == ""}-->
            <label><input type="radio" name="apply_type" value="1" />Tạo hồ sơ trực tuyến</label>
            <!--{else}-->
            <label><input type="radio" name="apply_type" value="2" />Sử dụng hồ sơ có sẵn</label>
            <!--{/if}-->
            
            <!--{if $customer_data.cv != ""}-->
            <label><input type="radio" name="apply_type" value="3" />Sử dụng hồ sơ đã tải lên</label>
            <!--{/if}-->
            
            <label><input type="radio" name="apply_type" value="4" />Tải hồ sơ mới</label>
        </div>
        <div class="btn_area">
            <ul>
                <li>
                    <a href="#" data-url="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$applyProductId|u}-->" class="bttn back">Đến trang chi tiết công việc</a>
                </li>
                <li>
                    <a href="#" class="bttn" onClick="eccube.setModeAndSubmit('finish', '', '');">Ứng tuyển</a>
                </li>
            </ul>
        </div>
        <!--{/if}-->
    </form>
</div>