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

// {{{ requires
require_once CLASS_EX_REALDIR . 'page_extends/admin/LC_Page_Admin_Ex.php';

/**
 * ソーシャルログインの設定クラス
 *
 * @package SocialLogin
 * @author Cyber-Will Inc. KAWAKAMI Takaaki
 * @version $Id: $
 */
class LC_Page_Plugin_SocialLogin_Config extends LC_Page_Admin_Ex {
    
    var $arrForm = array();

    /**
     * 初期化する.
     *
     * @return void
     */
    function init() {
        parent::init();
        $this->tpl_mainpage = PLUGIN_UPLOAD_REALDIR ."SocialLogin/templates/admin/config.tpl";
        $this->tpl_subtitle = "ソーシャルログイン設定";
    }

    /**
     * プロセス.
     *
     * @return void
     */
    function process() {
        $this->action();
        $this->sendResponse();
    }

    /**
     * Page のアクション.
     *
     * @return void
     */
    function action() {
        $objFormParam = new SC_FormParam_Ex();
        $this->lfInitParam($objFormParam);
        $objFormParam->setParam($_POST);
        $objFormParam->convParam();
        
        $arrForm = array();
        
        switch ($this->getMode()) {
        case 'edit':
            $arrForm = $objFormParam->getHashArray();
            $this->arrErr = $objFormParam->checkError();

            // エラーなしの場合にはデータを更新
            if (count($this->arrErr) == 0) {
                // データ更新
                $this->arrErr = $this->updateData($arrForm);
                if (count($this->arrErr) == 0) {
                    $this->tpl_onload = "alert('登録が完了しました。');";
                }
            }
            break;
        default:
            // hybridauth の設定情報を取得
            $config = PLUGIN_UPLOAD_REALDIR . 'SocialLogin/lib/hybridauth/config.php';
            $plugin = SC_Plugin_Util_Ex::getPluginByPluginCode("SocialLogin");
            if ($plugin["enable"] == 1) {
                require_once HTML_REALDIR . "/hybridauth/Hybrid/Auth.php";
            } else {
                require_once PLUGIN_UPLOAD_REALDIR . "SocialLogin/lib/hybridauth/Hybrid/Auth.php";
            }
            $hybridauth = new Hybrid_Auth($config);
            $providers = Hybrid_Auth::$config["providers"];

            foreach ($providers as $provider_name => $settings) {
                $arrForm['name'][]    = $provider_name;
                $arrForm['enabled'][] = ($settings['enabled']) ? 1 : 0;
                $arrForm['id'][]      = $settings['keys']['id'];
                $arrForm['secret'][]  = $settings['keys']['secret'];
            }
            
            break;
        }
        $this->arrForm = $arrForm;
        $this->setTemplate($this->tpl_mainpage);
    }

    /**
     * デストラクタ.
     *
     * @return void
     */
    function destroy() {
        parent::destroy();
    }
    
    /**
     * パラメーター情報の初期化
     *
     * @param object $objFormParam SC_FormParamインスタンス
     * @return void
     */
    function lfInitParam(&$objFormParam) {
        $objFormParam->addParam('アプリ名', 'name', STEXT_LEN, 'KVa', array('EXIST_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('有効無効', 'enabled', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam('App ID', 'id', LTEXT_LEN, 'KVa', array('MAX_LENGTH_CHECK'));
        $objFormParam->addParam('App Secret', 'secret', LTEXT_LEN, 'KVa', array('MAX_LENGTH_CHECK'));
    }
    
    /**
     *
     * @param type $arrData
     * @return type 
     */
    function updateData($arrData) {
        $arrErr = array();
        
        $confing = array();
        $config["base_url"] = HTTP_URL . "hybridauth/";
        foreach ($arrData['name'] as $key => $name) {
            $enabled = ($arrData['enabled'][$key] == 1) ? true : false;
            $config['providers'][$name] = array(
                "enabled" => $enabled,
                "keys"    => array(
                    "id" => $arrData['id'][$key],
                    "key" => $arrData['id'][$key],
                    "secret" => $arrData['secret'][$key],
                ),
            );
        }
        $config["debug_mode"] = false;
        $config["debug_file"] = '';
        
        $config_template = file_get_contents(PLUGIN_UPLOAD_REALDIR . 'SocialLogin/hybridauth_config.php.tpl');
        $config_template = str_replace("#CONFIG#", var_export($config, true), $config_template);
        file_put_contents(PLUGIN_UPLOAD_REALDIR . 'SocialLogin/lib/hybridauth/config.php',  $config_template);
        
        // プラグインが有効になっているときは設定ファイルをウェブ公開ディレクトリにコピー
        $plugin = SC_Plugin_Util_Ex::getPluginByPluginCode("SocialLogin");
        if ($plugin["enable"] == 1) {
            $target_config = file_get_contents(PLUGIN_UPLOAD_REALDIR . 'SocialLogin/lib/hybridauth/config.php');
            file_put_contents(HTML_REALDIR . "/hybridauth/config.php",  $target_config);
        }
        
        return $arrErr;
    }
}
?>
