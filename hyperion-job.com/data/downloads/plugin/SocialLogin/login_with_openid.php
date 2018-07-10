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

// need this on top for hybridauth
session_start();

// {{{ requires
require_once '../../require.php';
require_once CLASS_EX_REALDIR . 'page_extends/LC_Page_Ex.php';
    
/**
 * ソーシャルログイン のページクラス.
 *
 * @package Page
 * @author Cyber-Will Inc. KAWAKAMI Takaaki
 * @version $Id: $
 */
class LC_Page_Plugin_LoginWithOpenID extends LC_Page_Ex {

    // }}}
    // {{{ functions

    /**
     * Page を初期化する.
     *
     * @return void
     */
    function init() {
        parent::init();

    }

    /**
     * Page のプロセス.
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

        // 会員管理クラス
        $objCustomer = new SC_Customer_Ex();

        // パラメーター管理クラス
        $objFormParam = new SC_FormParam_Ex();

        // パラメーター情報の初期化
        $this->lfInitParam($objFormParam);

        // リクエスト値をフォームにセット
        $objFormParam->setParam($_REQUEST);

        //$url = htmlspecialchars($_REQUEST['url'], ENT_QUOTES);
        $url = ROOT_URLPATH . 'mypage/index.php';
        
        // モードによって分岐
        switch ($this->getMode()) {
            case 'login':
                // 入力値のエラーチェック
                $objFormParam->trimParam();
                $arrErr = $objFormParam->checkError();

                // エラーの場合はエラー画面に遷移
                if (count($arrErr) > 0) {
                    SC_Utils_Ex::sfDispSiteError(FREE_ERROR_MSG, '', true, '認証サービス名が不正です。');
                    SC_Response_Ex::actionExit();
                }

                // 入力チェック後の値を取得
                $arrForm = $objFormParam->getHashArray();

                // 遷移先の制御
                if (count($arrErr) == 0) {
                    // ログイン処理
                    $provider = $objFormParam->getValue('provider');
                    
                    $config = HTML_REALDIR . 'hybridauth/config.php';
                    require_once HTML_REALDIR . "hybridauth/Hybrid/Auth.php";
                    
                    try {
                        $hybridauth = new Hybrid_Auth($config);
                        $adapter = $hybridauth->authenticate($provider);
                        
                        if ($adapter->isUserConnected()) {
                            $user_profile = $adapter->getUserProfile();
                            
                            if ($user_profile->email) {
                                
                                $objCustomer = new SC_Customer();
                                $objCustomer->setLogin($user_profile->email);
                                if (!empty($objCustomer->customer_data)) {
                                    // セッションが引き継げないので dtb_session に直接書き込んでおく
                                    SC_Helper_Session_Ex::sfSessWrite(session_id(), session_encode());
                                    
                                    SC_Response_Ex::sendRedirect($url);
                                    SC_Response_Ex::actionExit();
                                } else {
                                    SC_Utils_Ex::sfDispSiteError(FREE_ERROR_MSG, '', true, $provider . 'のメールアドレスに対応する会員がSHOPに登録されていません。');
                                    SC_Response_Ex::actionExit();
                                }
                            } else {
                                SC_Utils_Ex::sfDispSiteError(FREE_ERROR_MSG, '', true, $provider . 'よりメールアドレスが提供されていません。');
                                SC_Response_Ex::actionExit();
                            }
                        } else {
                            SC_Utils_Ex::sfDispSiteError(FREE_ERROR_MSG, '', true, $provider . 'への接続に失敗しました。');
                            SC_Response_Ex::actionExit();
                        }
                        
                    } catch(Exception $e) {  
                        // In case we have errors 6 or 7, then we have to use Hybrid_Provider_Adapter::logout() to 
                        // let hybridauth forget all about the user so we can try to authenticate again.
                        switch ($e->getCode()) { 
                            case 0: // Unspecified error.
                            case 1: // Hybridauth configuration error.
                            case 2: // Provider not properly configured.
                            case 3: // Unknown or disabled provider.
                            case 4: // Missing provider application credentials.
                            case 5: // Authentification failed. The user has canceled the authentication or the provider refused the connection.
                            case 8: // Provider does not support this feature.
                                break;
                            case 6 : // User profile request failed. Most likely the user is not connected to the provider and he should to authenticate again.
                            case 7 : // User not connected to the provider.
                                $adapter->logout();
                                break;
                        }
                        $errstr = $e->getMessage() . "\n";
                        $errstr .= $e->getTraceAsString(); 
                        GC_Utils_Ex::gfPrintLog($errstr, ERROR_LOG_REALFILE, true);
                        
                        SC_Utils_Ex::sfDispSiteError(FREE_ERROR_MSG, '', true, $provider . 'への接続に失敗しました。');
                        SC_Response_Ex::actionExit();
                    }
                    
                } else {
                    // 入力エラーの場合、元のアドレスに戻す。
                    SC_Response_Ex::sendRedirect($url);
                    SC_Response_Ex::actionExit();
                }

                break;
            default:
                $config = HTML_REALDIR . 'hybridauth/config.php';
                require_once HTML_REALDIR . "hybridauth/Hybrid/Auth.php";
                $hybridauth = new Hybrid_Auth($config);
                
                $providers = $hybridauth->getConnectedProviders();
                if (count($providers) > 0) {
                    $adapter = $hybridauth->getAdapter($providers[0]);
                    $user_profile = $adapter->getUserProfile();
                    if ($user_profile->email) {
                        $objCustomer = new SC_Customer();
                        $objCustomer->setLogin($user_profile->email);
                        
                        // セッションが引き継げないので dtb_session に直接書き込んでおく
                        SC_Helper_Session_Ex::sfSessWrite(session_id(), session_encode());
                    }
                }
                SC_Response_Ex::sendRedirect($url);
                SC_Response_Ex::actionExit();
                break;
        }

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
     * パラメーター情報の初期化.
     *
     * @param SC_FormParam $objFormParam パラメーター管理クラス
     * @return void
     */
    function lfInitParam(&$objFormParam) {
        $objFormParam->addParam('認証サービス名', 'provider', STEXT_LEN, 'KVa', array('MAX_LENGTH_CHECK'));
    }
    
    // トークンチェックをスキップ
    function doValidToken() {
        return;
    }
}

// }}}
// {{{ generate page

$objPage = new LC_Page_Plugin_LoginWithOpenID();
register_shutdown_function(array($objPage, 'destroy'));
$objPage->init();
$objPage->process();
