<?php
/*
 * This file is part of SocialLogin
 *
 * Copyright(c) 2012 Cyber-Will Inc. All Rights Reserved.
 *
 * http://www.cyber-will.co.jp/
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/**
 * プラグインのメインクラス
 *
 * @package SocialLogin
 * @author Cyber-Will Inc. KAWAKAMI Takaaki
 * @version $Id: $
 */
class SocialLogin extends SC_Plugin_Base {
    
    /**
     * コンストラクタ
     */
    public function __construct(array $arrSelfInfo) {
        parent::__construct($arrSelfInfo);
    }
    
    /**
     * インストール
     * installはプラグインのインストール時に実行されます.
     * 引数にはdtb_pluginのプラグイン情報が渡されます.
     *
     * @param array $arrPlugin plugin_infoを元にDBに登録されたプラグイン情報(dtb_plugin)
     * @return void
     */
    function install($arrPlugin) {
        // ロゴ画像コピー
        if(copy(PLUGIN_UPLOAD_REALDIR . get_class($this) . "/logo.png", PLUGIN_HTML_REALDIR . get_class($this) . "/logo.png") === false);
        
        // CSS コピー
        if(copy(PLUGIN_UPLOAD_REALDIR . get_class($this) . "/header.css", PLUGIN_HTML_REALDIR . get_class($this) . "/header.css") === false);
    }
    
    /**
     * アンインストール
     * uninstallはアンインストール時に実行されます.
     * 引数にはdtb_pluginのプラグイン情報が渡されます.
     * 
     * @param array $arrPlugin プラグイン情報の連想配列(dtb_plugin)
     * @return void
     */
    function uninstall($arrPlugin) {
        SocialLogin::disable($arrPlugin);
        
        // ロゴ削除
        if(unlink(PLUGIN_HTML_REALDIR . get_class($this) . "/logo.png") === false);
        // CSS 削除
        if(unlink(PLUGIN_HTML_REALDIR . get_class($this) . "/header.css") === false);
        
        if(SC_Helper_FileManager_Ex::deleteFile(PLUGIN_UPLOAD_REALDIR .  get_class($this)) === false);
    }
    
    /**
     * アップデート
     * updateはアップデート時に実行されます.
     * 引数にはdtb_pluginのプラグイン情報が渡されます.
     * 
     * @param array $arrPlugin プラグイン情報の連想配列(dtb_plugin)
     * @return void
     */
    function update($arrPlugin) {
    }
    
    /**
     * 稼働
     * enableはプラグインを有効にした際に実行されます.
     * 引数にはdtb_pluginのプラグイン情報が渡されます.
     *
     * @param array $arrPlugin プラグイン情報の連想配列(dtb_plugin)
     * @return void
     */
    function enable($arrPlugin) {
        
        // Hybridauth 関連のモジュールチェック
        $plugin_html_dir = PLUGIN_HTML_REALDIR . $arrPlugin['plugin_code'];
        // PHP Curl extension [http://www.php.net/manual/en/intro.curl.php]
        if (!function_exists('curl_init')) {
            $err_msg = 'Hybridauth Library needs the CURL PHP extension.';
            GC_Utils_Ex::gfPrintLog($err_msg, ERROR_LOG_REALFILE, true);
            $arrErr = '※ このプラグインを利用するには、拡張モジュール「CURL」が必要です。<br />';
            return $arrErr;
        }
        
        // PHP JSON extension [http://php.net/manual/en/book.json.php]
        if (!function_exists('json_decode')) {
            $err_msg = 'Hybridauth Library needs the JSON PHP extension.';
            GC_Utils_Ex::gfPrintLog($err_msg, ERROR_LOG_REALFILE, true);
            $arrErr = '※ このプラグインを利用するには、拡張モジュール「JSON」が必要です。<br/>';
            return $arrErr;
        }
        
        // OAuth PECL extension is not compatible with this library
        if (extension_loaded('oauth')) {
            $err_msg = 'Hybridauth Library not compatible with installed PECL OAuth extension. Please disable it.';
            GC_Utils_Ex::gfPrintLog($err_msg, ERROR_LOG_REALFILE, true);
            $arrErr = '※ このプラグインを利用するには、PECL 拡張モジュール「OAuth」を無効にしてください。<br/>';
            return $arrErr;
        }
    
        // HybridAuth コピー
        if(SC_Utils_Ex::sfCopyDir(PLUGIN_UPLOAD_REALDIR . get_class($this) . "/lib/hybridauth", HTML_REALDIR) === false);
        
        // ログインスクリプトコピー
        if(copy(PLUGIN_UPLOAD_REALDIR . get_class($this) . "/login_with_openid.php", PLUGIN_HTML_REALDIR . get_class($this) . "/login_with_openid.php") === false);
    }

    /**
     * 停止
     * disableはプラグインを無効にした際に実行されます.
     * 引数にはdtb_pluginのプラグイン情報が渡されます.
     *
     * @param array $arrPlugin プラグイン情報の連想配列(dtb_plugin)
     * @return void
     */
    function disable($arrPlugin) {
        // HybridAuth削除
        if(SC_Helper_FileManager_Ex::deleteFile(HTML_REALDIR . "/hybridauth") === false);
        
        // ログインスクリプト削除
        if(SC_Helper_FileManager_Ex::deleteFile(PLUGIN_HTML_REALDIR . get_class($this) . "/login_with_openid.php") === false);
        //if(unlink(PLUGIN_HTML_REALDIR . get_class($this) . "/login_with_openid.php") === false);
    }
    
    /**
     * プレフィルタコールバック関数
     *
     * @param string &$source テンプレートのHTMLソース
     * @param LC_Page_Ex $objPage ページオブジェクト
     * @param string $filename テンプレートのファイル名
     * @return void
     */
    function prefilterTransform(&$source, LC_Page_Ex $objPage, $filename) {
        $objTransform = new SC_Helper_Transform($source);
        $template_dir = PLUGIN_UPLOAD_REALDIR . get_class($this) . '/templates/';
        switch($objPage->arrPageLayout['device_type_id']){
            case DEVICE_TYPE_MOBILE:
                break;
            case DEVICE_TYPE_SMARTPHONE:
                // スマートフォン 版MyPageログイン
                if (strpos($filename, 'mypage/login.tpl') !== false) {
                    $objTransform->select('form#login_mypage div.login_area div.btn_area')->insertAfter(file_get_contents($template_dir . 'sphone/mypage/snip.social_login_buttons.tpl'));
                    break;
                }
                break;
            case DEVICE_TYPE_PC:
                // PC 版ヘッダー用 CSS へのリンク挿入
                if (strpos($filename, 'site_frame.tpl') !== false) {
                    $objTransform->select('html.###00000001### head')->insertAfter(file_get_contents($template_dir . 'default/snip.css_link.tpl'));
                    break;
                }
                // PC 版MyPageログイン
                if (strpos($filename, 'mypage/login.tpl') !== false) {
                    $objTransform->select('div#undercolumn_login form#login_mypage div.login_area div.inputbox div.btn_area ul li')->insertAfter(file_get_contents($template_dir . 'default/mypage/snip.social_login_buttons.tpl'));
                    break;
                }
                break;
                
            // 管理画面
            case DEVICE_TYPE_ADMIN:
                //break; 管理画面では $objPage->arrPageLayout['device_type_id'] が取得できてないっぽい
            default:
                // ブロックもここに落ちてくる

                // PC 版ヘッダーログインブロック
                if (strpos($filename, '/default/frontparts/bloc/login_header.tpl') !== false) {
                    $objTransform->select('ul.formlist.clearfix li.forgot')->insertAfter(file_get_contents($template_dir . 'default/frontparts/bloc/snip.social_login_buttons_in_list.tpl'));
                    break;
                }
                // PC 版ログインブロック
                if (strpos($filename, '/default/frontparts/bloc/login.tpl') !== false) {
                    $objTransform->select('form#login_form div.block_body p.btn input', 1)->insertAfter(file_get_contents($template_dir . 'default/frontparts/bloc/snip.social_login_buttons_in_list.tpl'));
                    break;
                }
                break;
        }
        $source = $objTransform->getHTML();
    }
    
    /**
     * 処理の介入箇所とコールバック関数を設定
     * registerはプラグインインスタンス生成時に実行されます
     * 
     * @param SC_Helper_Plugin $objHelperPlugin 
     */
    function register(SC_Helper_Plugin $objHelperPlugin) {
        $objHelperPlugin->addAction('LC_Page_process', array(&$this, 'get_providers'));
        $objHelperPlugin->addAction('prefilterTransform', array(&$this, 'prefilterTransform'), 1);
    }
    
    function get_providers(LC_Page_Ex $objPage) {
        // hybridauth の設定情報を取得
        $config = PLUGIN_UPLOAD_REALDIR . 'SocialLogin/lib/hybridauth/config.php';
        require_once HTML_REALDIR . "hybridauth/Hybrid/Auth.php";
        $hybridauth = new Hybrid_Auth($config);
        $objPage->providers = Hybrid_Auth::$config["providers"];
        $objPage->provider_enabled = false;
        foreach ($objPage->providers as $provider) {
            if ($provider['enabled'] == true) { 
                $objPage->provider_enabled = true;
                break;
            }
        }
        // ログイン情報の取得
        $objCustomer = new SC_Customer_Ex();
        $this->tpl_login = ($objCustomer->isLoginSuccess()) ? true : false;
    }
}
?>
