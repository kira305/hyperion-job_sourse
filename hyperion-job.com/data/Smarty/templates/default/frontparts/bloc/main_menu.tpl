<ul id="main_menu">
    <!--{if $tpl_page_class_name !== "LC_Page_Index"}-->
    <li><a href="/">ホーム</a></li>
    <li <!--{if strpos($smarty.server.REQUEST_URI, '/user_data/vietnam.php') !== false}-->class='active'<!--{/if}-->><a href="/user_data/vietnam.php">ベトナム在住向け</a></li>
    <li <!--{if strpos($smarty.server.REQUEST_URI, '/user_data/japan.php') !== false}-->class='active'<!--{/if}-->><a href="/user_data/japan.php">日本在住向け</a></li>
    <!--{/if}-->

    <li <!--{if strpos($smarty.server.REQUEST_URI, '/abouts/') !== false}-->class='active'<!--{/if}-->><a href="/abouts">会社概要</a></li>
    <li <!--{if strpos($smarty.server.REQUEST_URI, '/contact/') !== false}-->class='active'<!--{/if}-->><a href="/contact">お問い合わせ</a></li>
</ul>