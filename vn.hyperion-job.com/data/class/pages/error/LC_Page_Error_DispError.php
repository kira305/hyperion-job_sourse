<?php
/*
 * This file is part of EC-CUBE
 *
 * Copyright(c) 2000-2014 LOCKON CO.,LTD. All Rights Reserved.
 *
 * http://www.lockon.co.jp/
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

require_once CLASS_EX_REALDIR . 'page_extends/admin/LC_Page_Admin_Ex.php';

/**
 * エラー表示のページクラス
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id$
 */
class LC_Page_Error_DispError extends LC_Page_Admin_Ex
{
    /**
     * Page を初期化する.
     * LC_Page_Adminクラス内でエラーページを表示しようとした際に無限ループに陥るのを防ぐため,
     * ここでは, parent::init() を行わない.(フロントのエラー画面出力と同様の仕様)
     *
     * @return void
     */
    public function init()
    {
        SC_Helper_HandleError_Ex::$under_error_handling = true;

        $this->template = LOGIN_FRAME;
        $this->tpl_mainpage = 'login_error.tpl';
        $this->tpl_title = 'Lỗi đăng nhập';
        // ディスプレイクラス生成
        $this->objDisplay = new SC_Display_Ex();

        // transformでフックしている場合に, 再度エラーが発生するため, コールバックを無効化.
        $objHelperPlugin = SC_Helper_Plugin_Ex::getSingletonInstance($this->plugin_activate_flg);
        $objHelperPlugin->arrRegistedPluginActions = array();

        // キャッシュから店舗情報取得（DBへの接続は行わない）
        $this->arrSiteInfo = SC_Helper_DB_Ex::sfGetBasisDataCache(false);
    }

    /**
     * Page のプロセス。
     *
     * @return void
     */
    public function process()
    {
        $this->action();
        $this->sendResponse();
    }

    /**
     * Page のプロセス。
     *
     * @return void
     */
    public function action()
    {
        SC_Response_Ex::sendHttpStatus(500);

        switch ($this->type) {
            case LOGIN_ERROR:
                $this->tpl_error='ID hoặc Password sai. Vui lòng nhập lại.';
                break;
            case ACCESS_ERROR:
                $this->tpl_error='Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
                break;
            case AUTH_ERROR:
                $this->tpl_error='Bạn không thể truy cập vào trang này.';
                SC_Response_Ex::sendHttpStatus(403);
                break;
            case INVALID_MOVE_ERRORR:
                $this->tpl_error='Trang không tồn tại. Vui lòng kiểm tra và đăng nhập lại.';
                break;
            default:
                $this->tpl_error='Đã phát hiện lỗi. Vui lòng kiểm tra và đăng nhập lại.';
                break;
        }

    }

    /**
     * エラーページではトランザクショントークンの自動検証は行わない
     */
    public function doValidToken()
    {
        // queit.
    }
}
