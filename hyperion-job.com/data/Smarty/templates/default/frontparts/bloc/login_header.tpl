<!--{if !$tpl_login}-->
<script type="text/javascript">//<![CDATA[
    $(function(){
        var $login_email = $('#header_login_area input[name=login_email]');

        if (!$login_email.val()) {
            $login_email
                .val('メールアドレス')
                .css('color', '#AAA');
        }

        $login_email
            .focus(function() {
                if ($(this).val() == 'メールアドレス') {
                    $(this)
                        .val('')
                        .css('color', '#000');
                }
            })
            .blur(function() {
                if (!$(this).val()) {
                    $(this)
                        .val('メールアドレス')
                        .css('color', '#AAA');
                }
            });

        $('#header_login_form').submit(function() {
            if (!$login_email.val()
                || $login_email.val() == 'メールアドレス') {
                if ($('#header_login_area input[name=login_pass]').val()) {
                    alert('メールアドレス/パスワードを入力して下さい。');
                }
                return false;
            }
            return true;
        });
    });
//]]></script>
<!--{/if}-->
<!--{strip}-->
    <div class="block_outer">
        <div id="header_login_area" class="clearfix">
            <form name="header_login_form" id="header_login_form" method="post" action="<!--{$smarty.const.HTTPS_URL}-->frontparts/login_check.php"<!--{if !$tpl_login}--> onsubmit="return eccube.checkLoginFormInputted('header_login_form')"<!--{/if}-->>
                <input type="hidden" name="mode" value="login" />
                <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
                <input type="hidden" name="url" value="<!--{$smarty.server.REQUEST_URI|h}-->" />
                <div class="block_body clearfix">
                    <!--{if $tpl_login}-->
                        <div class="user_area">
                            ようこそ、
                            <span class="user_name"><!--{$tpl_name1|h}--> <!--{$tpl_name2|h}--> 様 <span class='caret'></span></span>
                            <ul class="mymenu clearfix">
                                <li>
                                    <p><!--{$tpl_name1|h}--> <!--{$tpl_name2|h}--></p>
                                    <input type="button" class="bttn" onclick="document.location.href='/mypage/change.php';" value="アカウント情報" />
                                </li>
                                <li><a href="/mypage/cv.php">キャリアシート</a></li>
                                <li><a href="/user_data/mylist.php?l=keep">お気に入りのお仕事</a></li>
                                <li><a href="/user_data/mylist.php?l=viewed">閲覧したお仕事</a></li>
                                <li><a href="/user_data/mylist.php?l=applied">応募したお仕事</a></li>
                                <li><a href="#" onclick="eccube.fnFormModeSubmit('header_login_form', 'logout', '', ''); return false;">ログアウト</a></li>
                            </ul>
                        </div>
                    <!--{else}-->
                        <ul class="formlist clearfix">
                            <li class="mail"><input type="text" class="box150" name="login_email" value="<!--{$tpl_login_email|h}-->" style="ime-mode: disabled;" placeholder="メールアドレス" /></li>
                            <li class="password"><input type="password" class="box150" name="login_pass" title="パスワードを入力して下さい" placeholder="パスワード" /></li>
                            <li class="btn">
                                <input type="checkbox" name="login_memory" id="header _login_memory" value="1" <!--{$tpl_login_memory|sfGetChecked:1}--> /><label for="header_login_memory"><span>記憶</span></label>
                                <input type="submit" value="ログイン" />
                            </li>
                            <li class="regist">
                                <a href="<!--{$smarty.const.ROOT_URLPATH}-->entry/kiyaku.php" class="bttn">新規登録</a>
                            </li>
                            <li class="forgot">
                                <a href="<!--{$smarty.const.HTTPS_URL}-->forgot/<!--{$smarty.const.DIR_INDEX_PATH}-->" onclick="eccube.openWindow('<!--{$smarty.const.HTTPS_URL}-->forgot/<!--{$smarty.const.DIR_INDEX_PATH}-->','forget','600','400',{scrollbars:'no',resizable:'no'}); return false;" target="_blank">パスワードを忘れた方</a>
                            </li>
                        </ul>
                    <!--{/if}-->
                </div>
            </form>
        </div>
    </div>
<!--{/strip}-->
