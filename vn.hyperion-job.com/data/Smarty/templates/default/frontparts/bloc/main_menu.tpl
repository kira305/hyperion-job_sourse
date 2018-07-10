<ul id="main_menu">
    <!--{if $tpl_page_class_name !== "LC_Page_Index"}-->
    <li><a href="/">TRANG CHỦ</a></li>
    <li <!--{if strpos($smarty.server.REQUEST_URI, '/user_data/vietnam.php') !== false}-->class='active'<!--{/if}-->><a href="/user_data/vietnam.php">TÌM VIỆC TẠI VIỆT NAM</a></li>
    <li <!--{if strpos($smarty.server.REQUEST_URI, '/user_data/japan.php') !== false}-->class='active'<!--{/if}-->><a href="/user_data/japan.php">TÌM VIỆC TẠI NHẬT BẢN</a></li>
    <!--{/if}-->

    <li <!--{if strpos($smarty.server.REQUEST_URI, '/abouts/') !== false}-->class='active'<!--{/if}-->><a href="/abouts">GIỚI THIỆU</a></li>
    <li <!--{if strpos($smarty.server.REQUEST_URI, '/contact/') !== false}-->class='active'<!--{/if}-->><a href="/contact">LIÊN HỆ</a></li>
</ul>