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

require_once CLASS_EX_REALDIR . 'page_extends/LC_Page_Ex.php';

/**
 * エラー表示のページクラス
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id:LC_Page_Error.php 15532 2007-08-31 14:39:46Z nanasess $
 */
class LC_Page_Error extends LC_Page_Ex
{
    /** エラー種別 */
    public $type;

    /** SC_SiteSession インスタンス */
    public $objSiteSess;

    /** TOPへ戻るフラグ */
    public $return_top = false;

    /** エラーメッセージ */
    public $err_msg = '';

    /** モバイルサイトの場合 true */
    public $is_mobile = false;

    /**
     * Page を初期化する.
     *
     * DBエラー発生時, エラーページを表示しようした際の DB 接続を防ぐため,
     * ここでは, parent::init() を行わない.
     * @return void
     */
    public function init()
    {
        SC_Helper_HandleError_Ex::$under_error_handling = true;

        $this->tpl_mainpage = 'error.tpl';
        $this->tpl_title = 'Sự cố';
        // ディスプレイクラス生成
        $this->objDisplay = new SC_Display_Ex();

        $objHelperPlugin = SC_Helper_Plugin_Ex::getSingletonInstance($this->plugin_activate_flg);
        if (is_object($objHelperPlugin)) {
            // transformでフックしている場合に, 再度エラーが発生するため, コールバックを無効化.
            $objHelperPlugin->arrRegistedPluginActions = array();
        }

        // キャッシュから店舗情報取得（DBへの接続は行わない）
        $this->arrSiteInfo = SC_Helper_DB_Ex::sfGetBasisDataCache(false);
    }

    /**
     * Page のプロセス.
     *
     * @return void
     */
    public function process()
    {
        parent::process();
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
            case PRODUCT_NOT_FOUND:
                $this->tpl_error='Trang đích không tồn tại.';
                SC_Response_Ex::sendHttpStatus(404);
                break;
            case PAGE_ERROR:
                $this->tpl_error='Không thể chuyển đến trang đích.';
                break;
            case CART_EMPTY:
                $this->tpl_error='Không có hàng trong giỏ.';
                break;
            case CART_ADD_ERROR:
                $this->tpl_error='Đang xử lí mua hàng. Không thể thêm hàng mới.';
                break;
            case CANCEL_PURCHASE:
                $this->tpl_error='Thủ tục bị vô hiệu hóa. Có thể đã xảy ra một trong các lỗi sau:<br />・Phiên làm việc đã hết hạn<br />・Thực hiện mua hàng mới khi thủ tục mua hàng đang chuẩn bị hoàn tất<br />・Thủ tục mua hàng đã hoàn tất';
                break;
            case CATEGORY_NOT_FOUND:
                $this->tpl_error='Không tồn tại mục đã được chỉ định.';
                SC_Response_Ex::sendHttpStatus(404);
                break;
            case SITE_LOGIN_ERROR:
                $this->tpl_error='Địa chỉ email hoặc mật khẩu không đúng.';
                break;
            case TEMP_LOGIN_ERROR:
                $this->tpl_error='Địa chỉ email hoặc mật khẩu không đúng.<br />Trường hợp chưa hoàn thành việc đăng ký thành viên,<br />hãy đăng ký lại bằng email đúng.';
                break;
            case CUSTOMER_ERROR:
                $this->tpl_error='Truy cập trái phép.';
                break;
            case SOLD_OUT:
                $this->tpl_error='Xin lỗi quý khách, hàng đang tạm hết.';
                break;
            case CART_NOT_FOUND:
                $this->tpl_error='Xin lỗi quý khách, việc lấy thông tin mặt hàng đã thất bại.';
                break;
            case LACK_POINT:
                $this->tpl_error='Xin lỗi quý khách, số điểm hiện tại của quý khách hiện không đủ.';
                break;
            case FAVORITE_ERROR:
                $this->tpl_error='Mặt hàng đã được đưa vào mục yêu thích.';
                break;
            case EXTRACT_ERROR:
                $this->tpl_error="Không thể giải nén tệp,\nhoặc không có quyền truy cập.";
                break;
            case FTP_DOWNLOAD_ERROR:
                $this->tpl_error='Tải tệp FTP không thành công.';
                break;
            case FTP_LOGIN_ERROR:
                $this->tpl_error='Đăng nhập vào FTP không thành công.';
                break;
            case FTP_CONNECT_ERROR:
                $this->tpl_error='Đăng nhập vào FTP không thành công.';
                break;
            case CREATE_DB_ERROR:
                $this->tpl_error="Tạo DB không thành công.\nNgười dùng không có quyền tạo DB";
                break;
            case DB_IMPORT_ERROR:
                $this->tpl_error="Không thể thêm cơ sỏ dữ liệu,\ntệp sql có thể bị hỏng.";
                break;
            case FILE_NOT_FOUND:
                $this->tpl_error='Tệp không tồn tại trong đường dẫn.';
                break;
            case WRITE_FILE_ERROR:
                $this->tpl_error="Không thể ghi vào tập tên cấu hình. \nVui lòng xin quyền được ghi vào tập tin này.";
                break;
            case DOWNFILE_NOT_FOUND:
                $this->tpl_error='Tệp tải xuống không tồn tại.<br />Vui lòng liên hệ trực tiếp với cửa hàng.';
                break;
            case FREE_ERROR_MSG:
                $this->tpl_error=$this->err_msg;
                break;
            default:
                $this->tpl_error='Đã có lỗi xảy ra.';
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
