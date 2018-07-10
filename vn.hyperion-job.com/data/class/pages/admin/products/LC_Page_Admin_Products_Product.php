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

require_once CLASS_EX_REALDIR . 'page_extends/admin/products/LC_Page_Admin_Products_Ex.php';

/**
 * 求人登録 のページクラス
 *
 * @package Page
 * @author LOCKON CO.,LTD.
 * @version $Id$
 */
class LC_Page_Admin_Products_Product extends LC_Page_Admin_Products_Ex {

    /**
     * Page を初期化する.
     *
     * @return void
     */
    public function init() {
        parent::init();
        $this->tpl_mainpage = 'products/product.tpl';
        $this->tpl_mainno = 'products';
        $this->tpl_subno = 'product';
        $this->tpl_maintitle = '求人管理';
        $this->tpl_subtitle = '求人登録';

        $masterData = new SC_DB_MasterData_Ex();
        $this->arrProductType = $masterData->getMasterData('mtb_product_type');
        $this->arrDISP = $masterData->getMasterData('mtb_disp');
        $this->arrSTATUS = $masterData->getMasterData('mtb_status');
        $this->arrDELIVERYDATE = $masterData->getMasterData('mtb_delivery_date');
        $this->arrMaker = SC_Helper_Maker_Ex::getIDValueList();
        $this->arrAllowedTag = $masterData->getMasterData('mtb_allowed_tag');

        $this->arrDummyFlg = array(0 => '本物', 1 => 'ダミー');
        $this->arrTarget = $masterData->getMasterData('mtb_object');
        foreach ($this->arrTarget as &$target)
            $target .= '在住';
        $this->arrPref = $masterData->getMasterData('mtb_pref');
        $this->arrEmploymentStatus = $masterData->getMasterData('mtb_employment_status');
        $this->arrEmploymentStatusByTarget[1] = array(1 => $this->arrEmploymentStatus[1], 2 => $this->arrEmploymentStatus[2], 3 => $this->arrEmploymentStatus[3]);
        $this->arrEmploymentStatusByTarget[2] = array(1 => $this->arrEmploymentStatus[1]);
        $this->arrTargetByEmploymentStatus = array(1 => 2, 2 => 1, 3 => 1);
        $this->arrSalaryType = $masterData->getMasterData('mtb_salary_type');
        $this->arrSalaryTypeByTarget[1] = array(1 => $this->arrSalaryType[1], 2 => $this->arrSalaryType[2]);
        $this->arrSalaryTypeByTarget[2] = array(3 => $this->arrSalaryType[3]);
        $this->arrCurrency = $masterData->getMasterData('mtb_currency');
        $this->arrCurrencyByTarget[1] = array(1 => $this->arrCurrency[1]);
        $this->arrCurrencyByTarget[2] = $this->arrCurrency;
        $this->arrPosition = $masterData->getMasterData('mtb_position');
        $this->arrRegion = $masterData->getMasterData('mtb_region');
        $this->arrSex = $masterData->getMasterData('mtb_sex');
        $this->arrWelfare = $masterData->getMasterData('mtb_welfare');
        $this->arrProcess = $masterData->getMasterData('mtb_process');

        $objDate = new SC_Date_Ex(RELEASE_YEAR);
        $this->arrEndYear = $objDate->getYear();
        $this->arrMonth = $objDate->getMonth();
        $this->arrDay = $objDate->getDay();

        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $arrConcierge = $objQuery->select('member_id, name', 'dtb_member', 'authority = 2');
        $this->arrConcierge = array();
        foreach ($arrConcierge as $concierge)
            $this->arrConcierge[$concierge['member_id']] = $concierge['name'];

        $arrCity = $objQuery->select('*', 'mtb_city');
        $this->arrCityByRegion = array();
        foreach ($arrCity as $city)
            $this->arrCityByRegion[$city['region_id']][$city['id']] = $city['name'];

        $this->arrCategory = $masterData->getMasterData('mtb_category');
        $arrCategory = $objQuery->select('*', 'mtb_category');
        $this->arrCategoryByTarget = array();
        foreach ($arrCategory as $category) {
            if ($category['object_id'] != '' && $category['object_id'] > 0)
                $this->arrCategoryByTarget[$category['object_id']][$category['id']] = $category['name'];
            else {
                $this->arrCategoryByTarget[1][$category['id']] = $category['name'];
                $this->arrCategoryByTarget[2][$category['id']] = $category['name'];
            }
        }
    }

    /**
     * Page のプロセス.
     *
     * @return void
     */
    public function process() {
        $this->action();
        $this->sendResponse();
    }

    /**
     * Page のアクション.
     *
     * @return void
     */
    public function action() {
        $objFormParam = new SC_FormParam_Ex();

        // アップロードファイル情報の初期化
        $objUpFile = new SC_UploadFile_Ex(IMAGE_TEMP_REALDIR, IMAGE_SAVE_REALDIR);
        $this->lfInitFile($objUpFile);
        $objUpFile->setHiddenFileList($_POST);

        // ダウンロード販売ファイル情報の初期化
        $objDownFile = new SC_UploadFile_Ex(DOWN_TEMP_REALDIR, DOWN_SAVE_REALDIR);
        $this->lfInitDownFile($objDownFile);
        $objDownFile->setHiddenFileList($_POST);

        // 検索パラメーター引き継ぎ
        $this->arrSearchHidden = $this->lfGetSearchParam($_POST);

        $mode = $this->getMode();
        switch ($mode) {
            case 'pre_edit':
            case 'copy' :
                // パラメーター初期化(求人ID)
                $this->lfInitFormParam_PreEdit($objFormParam, $_POST);
                // エラーチェック
                $this->arrErr = $objFormParam->checkError();
                if (count($this->arrErr) > 0) {
                    trigger_error('', E_USER_ERROR);
                }

                // 求人ID取得
                $product_id = $objFormParam->getValue('product_id');
                // 求人データ取得
                $arrForm = $this->lfGetFormParam_PreEdit($objUpFile, $objDownFile, $product_id);

                // 複製の場合は、ダウンロード求人情報部分はコピーしない
                if ($mode == 'copy') {
                    // ダウンロード求人ファイル名をunset
                    $arrForm['down_filename'] = '';

                    // $objDownFile->setDBDownFile()でsetされたダウンロードファイル名をunset
                    unset($objDownFile->save_file[0]);
                }

                // ページ表示用パラメーター設定
                $this->arrForm = $this->lfSetViewParam_InputPage($objUpFile, $objDownFile, $arrForm);

                // 求人複製の場合、画像ファイルコピー
                if ($mode == 'copy') {
                    $this->arrForm['copy_product_id'] = $this->arrForm['product_id'];
                    $this->arrForm['product_id'] = '';
                    // 画像ファイルのコピー
                    $this->lfCopyProductImageFiles($objUpFile);
                }

                // ページonload時のJavaScript設定
                $this->tpl_onload = $this->lfSetOnloadJavaScript_InputPage();
                break;

            case 'edit':
                // パラメーター初期化, 取得
                $this->lfInitFormParam($objFormParam, $_POST);
                $arrForm = $objFormParam->getHashArray();
                // エラーチェック
                $this->arrErr = $this->lfCheckError_Edit($objFormParam, $objUpFile, $objDownFile, $arrForm);
                if (count($this->arrErr) == 0) {
                    // 確認画面表示設定
                    $this->tpl_mainpage = 'products/confirm.tpl';
                    $this->arrCatList = $this->lfGetCategoryList_Edit();
                    $this->arrForm = $this->lfSetViewParam_ConfirmPage($objUpFile, $objDownFile, $arrForm);
                } else {
                    // 入力画面表示設定
                    $this->arrForm = $this->lfSetViewParam_InputPage($objUpFile, $objDownFile, $arrForm);
                    // ページonload時のJavaScript設定
                    $this->tpl_onload = $this->lfSetOnloadJavaScript_InputPage();
                }
                break;

            case 'complete':
                // パラメーター初期化, 取得
                $this->lfInitFormParam($objFormParam, $_POST);
                $arrForm = $objFormParam->getHashArray();
                // エラーチェック
                $this->arrErr = $this->lfCheckError_Edit($objFormParam, $objUpFile, $objDownFile, $arrForm);
                if (count($this->arrErr) == 0) {
                    // DBへデータ登録
                    $product_id = $this->lfRegistProduct($objUpFile, $objDownFile, $arrForm);

                    // 件数カウントバッチ実行
                    $objQuery = & SC_Query_Ex::getSingletonInstance();
                    $objDb = new SC_Helper_DB_Ex();
                    $objDb->sfCountCategory($objQuery);
                    $objDb->sfCountMaker($objQuery);

                    // ダウンロード求人の複製時に、ダウンロード求人用ファイルを
                    // 変更すると、複製元のファイルが削除されるのを回避。
                    if (!empty($arrForm['copy_product_id'])) {
                        $objDownFile->save_file = array();
                    }

                    // 一時ファイルを本番ディレクトリに移動する
                    $this->lfSaveUploadFiles($objUpFile, $objDownFile, $product_id);

                    $this->tpl_mainpage = 'products/complete.tpl';
                    $this->arrForm['product_id'] = $product_id;
                } else {
                    // 入力画面表示設定
                    $this->arrForm = $this->lfSetViewParam_InputPage($objUpFile, $objDownFile, $arrForm);
                    // ページonload時のJavaScript設定
                    $this->tpl_onload = $this->lfSetOnloadJavaScript_InputPage();
                }
                break;

            // 画像のアップロード
            case 'upload_image':
            case 'delete_image':
                // パラメーター初期化
                $this->lfInitFormParam_UploadImage($objFormParam);
                $this->lfInitFormParam($objFormParam, $_POST);
                $arrForm = $objFormParam->getHashArray();

                switch ($mode) {
                    case 'upload_image':
                        // ファイルを一時ディレクトリにアップロード
                        $this->arrErr[$arrForm['image_key']] = $objUpFile->makeTempFile($arrForm['image_key'], IMAGE_RENAME);
                        if ($this->arrErr[$arrForm['image_key']] == '') {
                            // 縮小画像作成
                            $this->lfSetScaleImage($objUpFile, $arrForm['image_key']);
                        }
                        break;
                    case 'delete_image':
                        // ファイル削除
                        $this->lfDeleteTempFile($objUpFile, $arrForm['image_key']);
                        break;
                    default:
                        break;
                }

                // 入力画面表示設定
                $this->arrForm = $this->lfSetViewParam_InputPage($objUpFile, $objDownFile, $arrForm);
                // ページonload時のJavaScript設定
                $anchor_hash = $this->getAnchorHash($arrForm['image_key']);
                $this->tpl_onload = $this->lfSetOnloadJavaScript_InputPage($anchor_hash);
                break;

            // ダウンロード求人ファイルアップロード
            case 'upload_down':
            case 'delete_down':
                // パラメーター初期化
                $this->lfInitFormParam_UploadDown($objFormParam);
                $this->lfInitFormParam($objFormParam, $_POST);
                $arrForm = $objFormParam->getHashArray();

                switch ($mode) {
                    case 'upload_down':
                        // ファイルを一時ディレクトリにアップロード
                        $this->arrErr[$arrForm['down_key']] = $objDownFile->makeTempDownFile();
                        break;
                    case 'delete_down':
                        // ファイル削除
                        $objDownFile->deleteFile($arrForm['down_key']);
                        break;
                    default:
                        break;
                }

                // 入力画面表示設定
                $this->arrForm = $this->lfSetViewParam_InputPage($objUpFile, $objDownFile, $arrForm);
                // ページonload時のJavaScript設定
                $anchor_hash = $this->getAnchorHash($arrForm['down_key']);
                $this->tpl_onload = $this->lfSetOnloadJavaScript_InputPage($anchor_hash);
                break;

            // 関連求人選択
            case 'recommend_select' :
                // パラメーター初期化
                $this->lfInitFormParam_RecommendSelect($objFormParam);
                $this->lfInitFormParam($objFormParam, $_POST);
                $arrForm = $objFormParam->getHashArray();
                // 入力画面表示設定
                $this->arrForm = $this->lfSetViewParam_InputPage($objUpFile, $objDownFile, $arrForm);

                // 選択された関連求人IDがすでに登録している関連求人と重複していないかチェック
                $this->lfCheckError_RecommendSelect($this->arrForm, $this->arrErr);

                // ページonload時のJavaScript設定
                $anchor_hash = $this->getAnchorHash($this->arrForm['anchor_key']);
                $this->tpl_onload = $this->lfSetOnloadJavaScript_InputPage($anchor_hash);
                break;

            // 確認ページからの戻り
            case 'confirm_return':
                // パラメーター初期化
                $this->lfInitFormParam($objFormParam, $_POST);
                $arrForm = $objFormParam->getHashArray();
                // 入力画面表示設定
                $this->arrForm = $this->lfSetViewParam_InputPage($objUpFile, $objDownFile, $arrForm);
                // ページonload時のJavaScript設定
                $this->tpl_onload = $this->lfSetOnloadJavaScript_InputPage();
                break;
            case 'search_client':
                $this->lfInitFormParam($objFormParam, $_POST);
                $this->setClientTo($_POST['edit_client_id'], $objFormParam);
                $arrForm = $objFormParam->getHashArray();
                $this->arrErr = $this->lfCheckError_Edit($objFormParam, $objUpFile, $objDownFile, $arrForm);
                $this->arrForm = $this->lfSetViewParam_InputPage($objUpFile, $objDownFile, $arrForm);
                $anchor_hash = $this->getAnchorHash($_POST['anchor_key']);
                $this->tpl_onload = $this->lfSetOnloadJavaScript_InputPage($anchor_hash);
                break;
            default:
                // 入力画面表示設定
                $arrForm = array();
                $this->arrForm = $this->lfSetViewParam_InputPage($objUpFile, $objDownFile, $arrForm);
                // ページonload時のJavaScript設定
                $this->tpl_onload = $this->lfSetOnloadJavaScript_InputPage();
                break;
        }

        // 関連求人の読み込み
        $this->arrRecommend = $this->lfGetRecommendProducts($this->arrForm);
        if (isset($this->arrForm['selection_process']) && count($this->arrForm['selection_process']) > 0) {
            $tempArr = array();
            foreach ($this->arrForm['selection_process'] as $pid) {
                $tempArr[$pid] = $this->arrProcess[$pid];
                unset($this->arrProcess[$pid]);
            }
            if (count($this->arrProcess) > 0) {
                foreach ($this->arrProcess as $pid => $value)
                    $tempArr[$pid] = $value;
            }
            $this->arrProcess = $tempArr;
        }
    }

    public function setClientTo($client_id, &$objFormParam) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $arrResults = $objQuery->select('*', 'dtb_client', 'client_id = ?', array($client_id));
        $client = $arrResults[0];
        $objFormParam->setValue('client_id', $client_id);
        $objFormParam->setValue('client_introduction', '設立年月日：' . $client['establishment_date'] . '
資本金：' . $client['capital'] . '
会社の規模：' . $client['scale'] . '
事業部の簡単な情報：' . $client['introduction']);
        $objFormParam->setValue('client_introduction_vn', 'Ngày thành lập：' . $client['establishment_date_vn'] . '
Vốn：' . $client['capital_vn'] . '
Quy mô công ty：' . $client['scale_vn'] . '
Thông tin đơn giản về bộ phận kinh doanh：' . $client['introduction_vn']);
        $objFormParam->setValue('client_zip01', $client['zip01']);
        $objFormParam->setValue('client_zip02', $client['zip02']);
        $objFormParam->setValue('client_pref', $client['pref']);
        $objFormParam->setValue('client_addr01', $client['addr01']);
    }

    /**
     * パラメーター情報の初期化
     * - 編集/複製モード
     *
     * @param  SC_FormParam_Ex $objFormParam SC_FormParamインスタンス
     * @param  array  $arrPost      $_POSTデータ
     * @return void
     */
    public function lfInitFormParam_PreEdit(&$objFormParam, $arrPost) {
        $objFormParam->addParam('求人ID', 'product_id', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->setParam($arrPost);
        $objFormParam->convParam();
    }

    /**
     * パラメーター情報の初期化
     *
     * @param  SC_FormParam_Ex $objFormParam SC_FormParamインスタンス
     * @param  array  $arrPost      $_POSTデータ
     * @return void
     */
    public function lfInitFormParam(&$objFormParam, $arrPost) {
        $objFormParam->addParam('求人ID', 'product_id', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('仕事名', 'name', STEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('仕事名_VN', 'name_vn', STEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('職種', 'category_id', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('公開・非公開', 'status', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('求人ステータス', 'product_status', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));

        if (!$arrPost['has_product_class']) {
            // 新規登録, 規格なし求人の編集の場合
            $objFormParam->addParam('求人種別', 'product_type_id', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam('ダウンロード求人ファイル名', 'down_filename', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam('ダウンロード求人実ファイル名', 'down_realfilename', MTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam('temp_down_file', 'temp_down_file', '', '', array());
            $objFormParam->addParam('save_down_file', 'save_down_file', '', '', array());
            $objFormParam->addParam('求人コード', 'product_code', STEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam(NORMAL_PRICE_TITLE, 'price01', PRICE_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK', 'ZERO_START'));
            $objFormParam->addParam(SALE_PRICE_TITLE, 'price02', PRICE_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK', 'ZERO_START'));
            if (OPTION_PRODUCT_TAX_RULE) {
                $objFormParam->addParam('消費税率', 'tax_rate', PERCENTAGE_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
            }
            $objFormParam->addParam('在庫数', 'stock', AMOUNT_LEN, 'n', array('SPTAB_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK', 'ZERO_START'));
            $objFormParam->addParam('在庫無制限', 'stock_unlimited', INT_LEN, 'n', array('SPTAB_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        }
        $objFormParam->addParam('求人送料', 'deliv_fee', PRICE_LEN, 'n', array('NUM_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK', 'ZERO_START'));
        $objFormParam->addParam('ポイント付与率', 'point_rate', PERCENTAGE_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK', 'ZERO_START'));
        $objFormParam->addParam('発送日目安', 'deliv_date_id', INT_LEN, 'n', array('NUM_CHECK'));
        $objFormParam->addParam('販売制限数', 'sale_limit', AMOUNT_LEN, 'n', array('SPTAB_CHECK', 'ZERO_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK', 'ZERO_START'));
        $objFormParam->addParam('メーカー', 'maker_id', INT_LEN, 'n', array('NUM_CHECK'));
        $objFormParam->addParam('メーカーURL', 'comment1', URL_LEN, 'a', array('SPTAB_CHECK', 'URL_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('検索ワード', 'comment3', LLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('備考欄(SHOP専用)', 'note', LLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('簡単な仕事情報', 'main_list_comment', MTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('簡単な仕事情報_VN', 'main_list_comment_vn', MTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('仕事詳細', 'main_comment', LLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('仕事詳細_VN', 'main_comment_vn', LLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('save_main_large_image', 'save_main_large_image', '', '', array());
        $objFormParam->addParam('temp_main_large_image', 'temp_main_large_image', '', '', array());

        $objFormParam->addParam('ダミーフラグ', 'dummy_flg', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));

        for ($cnt = 1; $cnt <= RECOMMEND_PRODUCT_MAX; $cnt++) {
            $objFormParam->addParam('関連求人コメント' . $cnt, 'recommend_comment' . $cnt, LTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam('関連求人ID' . $cnt, 'recommend_id' . $cnt, INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam('recommend_delete' . $cnt, 'recommend_delete' . $cnt, '', 'n', array());
        }

        $objFormParam->addParam('求人ID', 'copy_product_id', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));

        $objFormParam->addParam('has_product_class', 'has_product_class', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('product_class_id', 'product_class_id', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));

        if ($arrPost['employment_status'] == 2 || $arrPost['employment_status'] == 3) {
            $objFormParam->addParam('ポジション', 'position', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam('給与詳細', 'salary', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam('給与詳細_VN', 'salary_vn', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        } else {
            $objFormParam->addParam('ポジション', 'position', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam('給与詳細', 'salary', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
            $objFormParam->addParam('給与詳細_VN', 'salary_vn', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        }
        $objFormParam->addParam('ダミーフラグ', 'dummy_flg', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('掲載終了日', 'end_year', 4, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'), '', false);
        $objFormParam->addParam('掲載終了日', 'end_month', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'), '', false);
        $objFormParam->addParam('掲載終了日', 'end_day', 2, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'), '', false);
        $objFormParam->addParam('求人数', 'offer_number', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('対象', 'target', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('雇用形態', 'employment_status', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('給与区分', 'salary_type', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('通貨', 'currency', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('給与上限', 'salary_min', PRICE_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK', 'ZERO_START'));
        $objFormParam->addParam('給与下限', 'salary_max', PRICE_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK', 'ZERO_START'));
        $objFormParam->addParam('為替相場', 'exchange_rate', STEXT_LEN, 'n', array('MAX_LENGTH_CHECK', 'ZERO_START'));
        $objFormParam->addParam('都道府県', 'region', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('市区町村', 'city', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('勤務地', 'work_location', STEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('勤務地_VN', 'work_location_vn', STEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('交通アクセス', 'traffic_access', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('交通アクセス_VN', 'traffic_access_vn', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('勤務時間', 'working_hour', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('勤務時間_VN', 'working_hour_vn', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('勤務曜日', 'working_day', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('勤務曜日_VN', 'working_day_vn', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('昼休み時間', 'lunch_time', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('昼休み時間_VN', 'lunch_time_vn', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('試用期間', 'trial_period', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('試用期間_VN', 'trial_period_vn', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('性別', 'sex', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('資格', 'qualification', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('資格_VN', 'qualification_vn', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('性格', 'personality', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('性格_VN', 'personality_vn', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('経験・スキルの詳細', 'skill', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('経験・スキルの詳細_VN', 'skill_vn', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('昇給', 'payrise', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('昇給_VN', 'payrise_vn', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('賞与', 'bonus', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('賞与_VN', 'bonus_vn', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('保険', 'insurance', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('保険_VN', 'insurance_vn', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('福利', 'welfare', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('その他の福利', 'other_welfare', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('その他の福利_VN', 'other_welfare_vn', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('健康診断', 'medical_checkup', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('健康診断_VN', 'medical_checkup_vn', MLTEXT_LEN, 'KVa', array('SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('応募方法', 'applicate_method', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('応募方法_VN', 'applicate_method_vn', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('選考プロセス', 'selection_process', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('コンシェルジュ', 'concierge', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));

        $objFormParam->addParam('企業名', 'client_id', INT_LEN, 'n', array('EXIST_CHECK', 'NUM_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('会社紹介', 'client_introduction', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('会社紹介_VN', 'client_introduction_vn', MLTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));
        $objFormParam->addParam('郵便番号1', 'client_zip01', ZIP01_LEN, 'n', array('EXIST_CHECK', 'SPTAB_CHECK', 'NUM_CHECK', 'NUM_COUNT_CHECK'));
        $objFormParam->addParam('郵便番号2', 'client_zip02', ZIP02_LEN, 'n', array('EXIST_CHECK', 'SPTAB_CHECK', 'NUM_CHECK', 'NUM_COUNT_CHECK'));
        $objFormParam->addParam('都道府県', 'client_pref', INT_LEN, 'n', array('EXIST_CHECK', 'MAX_LENGTH_CHECK', 'NUM_CHECK'));
        $objFormParam->addParam('住所', 'client_addr01', MTEXT_LEN, 'KVa', array('EXIST_CHECK', 'SPTAB_CHECK', 'MAX_LENGTH_CHECK'));



        $objFormParam->setParam($arrPost);
        $objFormParam->convParam();
    }

    /**
     * パラメーター情報の初期化
     * - 画像ファイルアップロードモード
     *
     * @param  SC_FormParam_Ex $objFormParam SC_FormParamインスタンス
     * @return void
     */
    public function lfInitFormParam_UploadImage(&$objFormParam) {
        $objFormParam->addParam('image_key', 'image_key', '', '', array());
    }

    /**
     * パラメーター情報の初期化
     * - ダウンロード求人ファイルアップロードモード
     *
     * @param  SC_FormParam_Ex $objFormParam SC_FormParamインスタンス
     * @return void
     */
    public function lfInitFormParam_UploadDown(&$objFormParam) {
        $objFormParam->addParam('down_key', 'down_key', '', '', array());
    }

    /**
     * パラメーター情報の初期化
     * - 関連求人追加モード
     *
     * @param  SC_FormParam_Ex $objFormParam SC_FormParamインスタンス
     * @return void
     */
    public function lfInitFormParam_RecommendSelect(&$objFormParam) {
        $objFormParam->addParam('anchor_key', 'anchor_key', '', '', array());
        $objFormParam->addParam('select_recommend_no', 'select_recommend_no', INT_LEN, 'n', array('NUM_CHECK', 'MAX_LENGTH_CHECK'));
    }

    /**
     * アップロードファイルパラメーター情報の初期化
     * - 画像ファイル用
     *
     * @param  SC_UploadFile_Ex $objUpFile SC_UploadFileインスタンス
     * @return void
     */
    public function lfInitFile(&$objUpFile) {
        $objUpFile->addFile('画像', 'main_large_image', array('jpg', 'gif', 'png'), IMAGE_SIZE, false, LARGE_IMAGE_WIDTH, LARGE_IMAGE_HEIGHT);
    }

    /**
     * アップロードファイルパラメーター情報の初期化
     * - ダウンロード求人ファイル用
     *
     * @param  SC_UploadFile_Ex $objDownFile SC_UploadFileインスタンス
     * @return void
     */
    public function lfInitDownFile(&$objDownFile) {
        $objDownFile->addFile('ダウンロード販売用ファイル', 'down_file', explode(',', DOWNLOAD_EXTENSION), DOWN_SIZE, true, 0, 0);
    }

    /**
     * フォーム入力パラメーターのエラーチェック
     *
     * @param  object $objFormParam SC_FormParamインスタンス
     * @param  SC_UploadFile_Ex $objUpFile    SC_UploadFileインスタンス
     * @param  SC_UploadFile_Ex $objDownFile  SC_UploadFileインスタンス
     * @param  array  $arrForm      フォーム入力パラメーター配列
     * @return array  エラー情報を格納した連想配列
     */
    public function lfCheckError_Edit(&$objFormParam, &$objUpFile, &$objDownFile, $arrForm) {
        $objErr = new SC_CheckError_Ex($arrForm);
        $arrErr = array();

        // 入力パラメーターチェック
        $arrErr = $objFormParam->checkError();

        // アップロードファイル必須チェック
        $arrErr = array_merge((array) $arrErr, (array) $objUpFile->checkExists());

        $objErr->doFunc(array('掲載終了日', 'end_year', 'end_month', 'end_day'), array('CHECK_DATE'));
        $objErr->doFunc(array('郵便番号', 'zip01', 'zip02'), array('ALL_EXIST_CHECK'));
        if (SC_Utils_Ex::sfIsInt($arrForm['salary_min']) && SC_Utils_Ex::sfIsInt($arrForm['salary_max']) && $arrForm['salary_min'] > $arrForm['salary_max'])
            $objErr->arrErr['salary_min'] .= '※ 給与の指定範囲が不正です。<br />';

        // HTMLタグ許可チェック
        $objErr->doFunc(array('詳細-メインコメント', 'main_comment', $this->arrAllowedTag), array('HTML_TAG_CHECK'));
        $objErr->doFunc(array('詳細-メインコメント_VN', 'main_comment_vn', $this->arrAllowedTag), array('HTML_TAG_CHECK'));

        // 規格情報がない求人の場合のチェック
        if ($arrForm['has_product_class'] != true) {
            // 在庫必須チェック(在庫無制限ではない場合)
            if ($arrForm['stock_unlimited'] != UNLIMITED_FLG_UNLIMITED) {
                $objErr->doFunc(array('在庫数', 'stock'), array('EXIST_CHECK'));
            }
            // ダウンロード求人ファイル必須チェック(ダウンロード求人の場合)
            if ($arrForm['product_type_id'] == PRODUCT_TYPE_DOWNLOAD) {
                $arrErr = array_merge((array) $arrErr, (array) $objDownFile->checkExists());
                $objErr->doFunc(array('ダウンロード求人ファイル名', 'down_filename'), array('EXIST_CHECK'));
            }
        }

        $arrErr = array_merge((array) $arrErr, (array) $objErr->arrErr);

        return $arrErr;
    }

    /**
     * 関連求人の重複登録チェック、エラーチェック
     *
     * 関連求人の重複があった場合はエラーメッセージを格納し、該当の求人IDをリセットする
     *
     * @param  array $arrForm 入力値の配列
     * @param  array $arrErr  エラーメッセージの配列
     * @return void
     */
    public function lfCheckError_RecommendSelect(&$arrForm, &$arrErr) {
        $select_recommend_no = $arrForm['select_recommend_no'];
        $select_recommend_id = $arrForm['recommend_id' . $select_recommend_no];

        foreach ($arrForm as $key => $value) {
            if (preg_match('/^recommend_id/', $key)) {
                if ($select_recommend_no == preg_replace('/^recommend_id/', '', $key)) {
                    continue;
                }
                $delete_key = 'recommend_delete' . intval(str_replace('recommend_id', '', $key));
                if ($select_recommend_id == $arrForm[$key] && $arrForm[$delete_key] != 1) {
                    // 重複した場合、選択されたデータをリセットする
                    $arrForm['recommend_id' . $select_recommend_no] = '';
                    $arrErr['recommend_comment' . $select_recommend_no] = '※ すでに登録されている関連求人です。<br />';
                    break;
                }
            }
        }
    }

    /**
     * 検索パラメーター引き継ぎ用配列取得
     *
     * @param  array $arrPost $_POSTデータ
     * @return array 検索パラメーター配列
     */
    public function lfGetSearchParam($arrPost) {
        $arrSearchParam = array();
        $objFormParam = new SC_FormParam_Ex();

        parent::lfInitParam($objFormParam);
        $objFormParam->setParam($arrPost);
        $arrSearchParam = $objFormParam->getSearchArray();

        return $arrSearchParam;
    }

    /**
     * フォームパラメーター取得
     * - 編集/複製モード
     *
     * @param  SC_UploadFile_Ex  $objUpFile   SC_UploadFileインスタンス
     * @param  SC_UploadFile_Ex  $objDownFile SC_UploadFileインスタンス
     * @param  integer $product_id  求人ID
     * @return array   フォームパラメーター配列
     */
    public function lfGetFormParam_PreEdit(&$objUpFile, &$objDownFile, $product_id) {
        $arrForm = array();

        // DBから求人データ取得
        $arrForm = $this->lfGetProductData_FromDB($product_id);
        // DBデータから画像ファイル名の読込
        $objUpFile->setDBFileList($arrForm);
        // DBデータからダウンロードファイル名の読込
        $objDownFile->setDBDownFile($arrForm);

        return $arrForm;
    }

    /**
     * 表示用フォームパラメーター取得
     * - 入力画面
     *
     * @param  SC_UploadFile_Ex $objUpFile   SC_UploadFileインスタンス
     * @param  SC_UploadFile_Ex $objDownFile SC_UploadFileインスタンス
     * @param  array  $arrForm     フォーム入力パラメーター配列
     * @return array  表示用フォームパラメーター配列
     */
    public function lfSetViewParam_InputPage(&$objUpFile, &$objDownFile, &$arrForm) {
        // カテゴリマスターデータ取得
        $objDb = new SC_Helper_DB_Ex();
        list($this->arrCatVal, $this->arrCatOut) = $objDb->sfGetLevelCatList(false);

        if ($arrForm['status'] == '') {
            $arrForm['status'] = DEFAULT_PRODUCT_DISP;
        }
        if ($arrForm['product_type_id'] == '') {
            $arrForm['product_type_id'] = DEFAULT_PRODUCT_DOWN;
        }
        if (OPTION_PRODUCT_TAX_RULE) {
            // 編集の場合は設定された税率、新規の場合はデフォルトの税率を取得
            if ($arrForm['product_id'] == '') {
                $arrRet = SC_Helper_TaxRule_Ex::getTaxRule();
            } else {
                $arrRet = SC_Helper_TaxRule_Ex::getTaxRule($arrForm['product_id'], $arrForm['product_class_id']);
            }
            $arrForm['tax_rate'] = $arrRet['tax_rate'];
        }
        // アップロードファイル情報取得(Hidden用)
        $arrHidden = $objUpFile->getHiddenFileList();
        $arrForm['arrHidden'] = array_merge((array) $arrHidden, (array) $objDownFile->getHiddenFileList());

        // 画像ファイル表示用データ取得
        $arrForm['arrFile'] = $objUpFile->getFormFileList(IMAGE_TEMP_URLPATH, IMAGE_SAVE_URLPATH);

        // ダウンロード求人実ファイル名取得
        $arrForm['down_realfilename'] = $objDownFile->getFormDownFile();

        // 基本情報(デフォルトポイントレート用)
        $arrForm['arrInfo'] = SC_Helper_DB_Ex::sfGetBasisData();

        return $arrForm;
    }

    /**
     * 表示用フォームパラメーター取得
     * - 確認画面
     *
     * @param  SC_UploadFile_Ex $objUpFile   SC_UploadFileインスタンス
     * @param  SC_UploadFile_Ex $objDownFile SC_UploadFileインスタンス
     * @param  array  $arrForm     フォーム入力パラメーター配列
     * @return array  表示用フォームパラメーター配列
     */
    public function lfSetViewParam_ConfirmPage(&$objUpFile, &$objDownFile, &$arrForm) {
        // 画像ファイル用データ取得
        $arrForm['arrFile'] = $objUpFile->getFormFileList(IMAGE_TEMP_URLPATH, IMAGE_SAVE_URLPATH);
        // ダウンロード求人実ファイル名取得
        $arrForm['down_realfilename'] = $objDownFile->getFormDownFile();

        return $arrForm;
    }

    /**
     * 縮小した画像をセットする
     *
     * @param  SC_UploadFile_Ex $objUpFile SC_UploadFileインスタンス
     * @param  string $image_key 画像ファイルキー
     * @return void
     */
    public function lfSetScaleImage(&$objUpFile, $image_key) {
        $subno = str_replace('sub_large_image', '', $image_key);
        switch ($image_key) {
            case 'sub_large_image' . $subno:
                // サブメイン画像
                $this->lfMakeScaleImage($objUpFile, $_POST['image_key'], 'sub_image' . $subno);
                break;
            default:
                break;
        }
    }

    /**
     * 画像ファイルのコピー
     *
     * @param  object $objUpFile SC_UploadFileインスタンス
     * @return void
     */
    public function lfCopyProductImageFiles(&$objUpFile) {
        $arrKey = $objUpFile->keyname;
        $arrSaveFile = $objUpFile->save_file;

        foreach ($arrSaveFile as $key => $val) {
            $this->lfMakeScaleImage($objUpFile, $arrKey[$key], $arrKey[$key], true);
        }
    }

    /**
     * 縮小画像生成
     *
     * @param  object  $objUpFile SC_UploadFileインスタンス
     * @param  string  $from_key  元画像ファイルキー
     * @param  string  $to_key    縮小画像ファイルキー
     * @param  boolean $forced
     * @return void
     */
    public function lfMakeScaleImage(&$objUpFile, $from_key, $to_key, $forced = false) {
        $arrImageKey = array_flip($objUpFile->keyname);
        $from_path = '';

        if ($objUpFile->temp_file[$arrImageKey[$from_key]]) {
            $from_path = $objUpFile->temp_dir . $objUpFile->temp_file[$arrImageKey[$from_key]];
        } elseif ($objUpFile->save_file[$arrImageKey[$from_key]]) {
            $from_path = $objUpFile->save_dir . $objUpFile->save_file[$arrImageKey[$from_key]];
        }

        if (file_exists($from_path)) {
            // 生成先の画像サイズを取得
            $to_w = $objUpFile->width[$arrImageKey[$to_key]];
            $to_h = $objUpFile->height[$arrImageKey[$to_key]];

            if ($forced) {
                $objUpFile->save_file[$arrImageKey[$to_key]] = '';
            }

            if (empty($objUpFile->temp_file[$arrImageKey[$to_key]]) && empty($objUpFile->save_file[$arrImageKey[$to_key]])
            ) {
                // リネームする際は、自動生成される画像名に一意となるように、Suffixを付ける
                $dst_file = $objUpFile->lfGetTmpImageName(IMAGE_RENAME, '', $objUpFile->temp_file[$arrImageKey[$from_key]]) . $this->lfGetAddSuffix($to_key);
                $path = $objUpFile->makeThumb($from_path, $to_w, $to_h, $dst_file);
                $objUpFile->temp_file[$arrImageKey[$to_key]] = basename($path);
            }
        }
    }

    /**
     * アップロードファイルパラメーター情報から削除
     * 一時ディレクトリに保存されている実ファイルも削除する
     *
     * @param  SC_UploadFile_Ex $objUpFile SC_UploadFileインスタンス
     * @param  string $image_key 画像ファイルキー
     * @return void
     */
    public function lfDeleteTempFile(&$objUpFile, $image_key) {
        // TODO: SC_UploadFile::deleteFileの画像削除条件見直し要
        $arrTempFile = $objUpFile->temp_file;
        $arrKeyName = $objUpFile->keyname;

        foreach ($arrKeyName as $key => $keyname) {
            if ($keyname != $image_key)
                continue;

            if (!empty($arrTempFile[$key])) {
                $temp_file = $arrTempFile[$key];
                $arrTempFile[$key] = '';

                if (!in_array($temp_file, $arrTempFile)) {
                    $objUpFile->deleteFile($image_key);
                } else {
                    $objUpFile->temp_file[$key] = '';
                    $objUpFile->save_file[$key] = '';
                }
            } else {
                $objUpFile->temp_file[$key] = '';
                $objUpFile->save_file[$key] = '';
            }
        }
    }

    /**
     * アップロードファイルを保存する
     *
     * @param  object  $objUpFile   SC_UploadFileインスタンス
     * @param  object  $objDownFile SC_UploadFileインスタンス
     * @param  integer $product_id  求人ID
     * @return void
     */
    public function lfSaveUploadFiles(&$objUpFile, &$objDownFile, $product_id) {
        // TODO: SC_UploadFile::moveTempFileの画像削除条件見直し要
        $objImage = new SC_Image_Ex($objUpFile->temp_dir);
        $arrKeyName = $objUpFile->keyname;
        $arrTempFile = $objUpFile->temp_file;
        $arrSaveFile = $objUpFile->save_file;
        $arrImageKey = array();
        foreach ($arrTempFile as $key => $temp_file) {
            if ($temp_file) {
                $objImage->moveTempImage($temp_file, $objUpFile->save_dir);
                $arrImageKey[] = $arrKeyName[$key];
                if (!empty($arrSaveFile[$key]) && !$this->lfHasSameProductImage($product_id, $arrImageKey, $arrSaveFile[$key]) && !in_array($temp_file, $arrSaveFile)
                ) {
                    $objImage->deleteImage($arrSaveFile[$key], $objUpFile->save_dir);
                }
            }
        }
        $objDownFile->moveTempDownFile();
    }

    /**
     * 同名画像ファイル登録の有無を確認する.
     *
     * 画像ファイルの削除可否判定用。
     * 同名ファイルの登録がある場合には画像ファイルの削除を行わない。
     * 戻り値： 同名ファイル有り(true) 同名ファイル無し(false)
     *
     * @param  string  $product_id      求人ID
     * @param  string  $arrImageKey     対象としない画像カラム名
     * @param  string  $image_file_name 画像ファイル名
     * @return boolean
     */
    public function lfHasSameProductImage($product_id, $arrImageKey, $image_file_name) {
        if (!SC_Utils_Ex::sfIsInt($product_id))
            return false;
        if (!$arrImageKey)
            return false;
        if (!$image_file_name)
            return false;

        $arrWhere = array();
        $sqlval = array('0', $product_id);
        foreach ($arrImageKey as $image_key) {
            $arrWhere[] = "{$image_key} = ?";
            $sqlval[] = $image_file_name;
        }
        $where = implode(' OR ', $arrWhere);
        $where = "del_flg = ? AND ((product_id <> ? AND ({$where}))";

        $arrKeyName = $this->objUpFile->keyname;
        foreach ($arrKeyName as $key => $keyname) {
            if (in_array($keyname, $arrImageKey))
                continue;
            $where .= " OR {$keyname} = ?";
            $sqlval[] = $image_file_name;
        }
        $where .= ')';

        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $exists = $objQuery->exists('dtb_products', $where, $sqlval);

        return $exists;
    }

    /**
     * DBから求人データを取得する
     *
     * @param  integer $product_id 求人ID
     * @return string   求人データ配列
     */
    public function lfGetProductData_FromDB($product_id) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $arrProduct = array();

        // 求人データ取得
        $col = '*';
        $table = <<< __EOF__
            dtb_products AS T1
            LEFT JOIN (
                SELECT product_id AS product_id_sub,
                    product_code,
                    price01,
                    price02,
                    deliv_fee,
                    stock,
                    stock_unlimited,
                    sale_limit,
                    point_rate,
                    product_type_id,
                    down_filename,
                    down_realfilename
                FROM dtb_products_class
            ) AS T2
                ON T1.product_id = T2.product_id_sub
__EOF__;
        $where = 'product_id = ?';
        $objQuery->setLimit('1');
        $arrProduct = $objQuery->select($col, $table, $where, array($product_id));

        // 規格情報ありなしフラグ取得
        $objDb = new SC_Helper_DB_Ex();
        $arrProduct[0]['has_product_class'] = $objDb->sfHasProductClass($product_id);

        // 規格が登録されていなければ規格ID取得
        if ($arrProduct[0]['has_product_class'] == false) {
            $arrProduct[0]['product_class_id'] = SC_Utils_Ex::sfGetProductClassId($product_id, '0', '0');
        }

        // 求人ステータス取得
        $objProduct = new SC_Product_Ex();
        $productStatus = $objProduct->getProductStatus(array($product_id));
        $arrProduct[0]['product_status'] = $productStatus[$product_id];

        // 関連求人データ取得
        $arrRecommend = $this->lfGetRecommendProductsData_FromDB($product_id);
        $arrProduct[0] = array_merge($arrProduct[0], $arrRecommend);

        list($arrProduct[0]['end_year'], $arrProduct[0]['end_month'], $arrProduct[0]['end_day']) = explode('-', $arrProduct[0]['end_date']);
        $arrProduct[0]['category_id'] = explode(' ', $arrProduct[0]['category_id']);
        $arrProduct[0]['sex'] = explode(' ', $arrProduct[0]['sex']);
        $arrProduct[0]['welfare'] = explode(' ', $arrProduct[0]['welfare']);
        $arrProduct[0]['selection_process'] = explode(' ', $arrProduct[0]['selection_process']);

        return $arrProduct[0];
    }

    /**
     * DBから関連求人データを取得する
     *
     * @param  integer $product_id 求人ID
     * @return array   関連求人データ配列
     */
    public function lfGetRecommendProductsData_FromDB($product_id) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $arrRecommendProducts = array();

        $col = 'recommend_product_id,';
        $col .= 'comment';
        $table = 'dtb_recommend_products';
        $where = 'product_id = ?';
        $objQuery->setOrder('rank DESC');
        $arrRet = $objQuery->select($col, $table, $where, array($product_id));

        $no = 1;
        foreach ($arrRet as $arrVal) {
            $arrRecommendProducts['recommend_id' . $no] = $arrVal['recommend_product_id'];
            $arrRecommendProducts['recommend_comment' . $no] = $arrVal['comment'];
            $no++;
        }

        return $arrRecommendProducts;
    }

    /**
     * 関連求人データ表示用配列を取得する
     *
     * @param  string $arrForm フォーム入力パラメーター配列
     * @return array  関連求人データ配列
     */
    public function lfGetRecommendProducts(&$arrForm) {
        $arrRecommend = array();

        for ($i = 1; $i <= RECOMMEND_PRODUCT_MAX; $i++) {
            $keyname = 'recommend_id' . $i;
            $delkey = 'recommend_delete' . $i;
            $commentkey = 'recommend_comment' . $i;

            if (!isset($arrForm[$delkey]))
                $arrForm[$delkey] = null;

            if ((isset($arrForm[$keyname]) && !empty($arrForm[$keyname])) && $arrForm[$delkey] != 1) {
                $objProduct = new SC_Product_Ex();
                $arrRecommend[$i] = $objProduct->getDetail($arrForm[$keyname]);
                $arrRecommend[$i]['product_id'] = $arrForm[$keyname];
                $arrRecommend[$i]['comment'] = $arrForm[$commentkey];
            }
        }

        return $arrRecommend;
    }

    /**
     * 表示用カテゴリマスターデータ配列を取得する
     * - 編集モード
     *
     * @param void
     * @return array カテゴリマスターデータ配列
     */
    public function lfGetCategoryList_Edit() {
        $objDb = new SC_Helper_DB_Ex();
        $arrCategoryList = array();

        list($arrCatVal, $arrCatOut) = $objDb->sfGetLevelCatList(false);
        for ($i = 0; $i < count($arrCatVal); $i++) {
            $arrCategoryList[$arrCatVal[$i]] = $arrCatOut[$i];
        }

        return $arrCategoryList;
    }

    /**
     * ページonload用JavaScriptを取得する
     * - 入力画面
     *
     * @param  string $anchor_hash アンカー用ハッシュ文字列(省略可)
     * @return string ページonload用JavaScript
     */
    public function lfSetOnloadJavaScript_InputPage($anchor_hash = '') {
        return "eccube.checkStockLimit('" . DISABLED_RGB . "'); " . $anchor_hash;
    }

    /**
     * DBに求人データを登録する
     *
     * @param  SC_UploadFile_Ex  $objUpFile   SC_UploadFileインスタンス
     * @param  SC_UploadFile_Ex  $objDownFile SC_UploadFileインスタンス
     * @param  array   $arrList     フォーム入力パラメーター配列
     * @return integer 登録求人ID
     */
    public function lfRegistProduct(&$objUpFile, &$objDownFile, $arrList) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $objDb = new SC_Helper_DB_Ex();

        // 配列の添字を定義
        $checkArray = array('name', 'name_vn', 'status', 'main_list_comment', 'main_list_comment_vn', 'main_comment', 'main_comment_vn', 'deliv_fee',
            'comment1', 'comment2', 'comment3', 'comment4', 'comment5', 'comment6', 'sale_limit', 'deliv_date_id', 'maker_id', 'note', 'dummy_flg', 
            'target', 'offer_number', 'client_id', 'client_introduction', 'client_introduction_vn', 'client_zip01', 'client_zip02', 'client_pref', 'client_addr01', 
            'employment_status', 'salary_type', 'position', 'currency', 'salary_max', 'salary_min', 'salary', 'salary_vn', 'exchange_rate', 'region', 'city', 'work_location', 'work_location_vn', 
            'traffic_access', 'traffic_access_vn', 'working_hour', 'working_hour_vn', 'working_day', 'working_day_vn', 'lunch_time', 'lunch_time_vn',
            'trial_period', 'trial_period_vn', 'qualification', 'qualification_vn', 'personality', 'personality_vn', 'skill', 'skill_vn', 'payrise', 'payrise_vn', 
            'bonus', 'bonus_vn', 'insurance', 'insurance_vn', 'other_welfare', 'other_welfare_vn', 'medical_checkup', 'medical_checkup_vn', 'applicate_method', 'applicate_method_vn', 'concierge');
        $arrList = SC_Utils_Ex::arrayDefineIndexes($arrList, $checkArray);

        // INSERTする値を作成する。
        foreach ($checkArray as $field) {
            if ($field != 'deliv_fee' && $field != 'sale_limit')
                $sqlval[$field] = $arrList[$field];
        }
        $sqlval['update_date'] = 'CURRENT_TIMESTAMP';
        $sqlval['creator_id'] = $_SESSION['member_id'];
        $arrRet = $objUpFile->getDBFileList();
        $sqlval = array_merge($sqlval, $arrRet);

        if ($arrList['end_year'] > 0)
            $sqlval['end_date'] = $arrList['end_year'] . '-' . $arrList['end_month'] . '-' . $arrList['end_day'];
        $sqlval['category_id'] = implode(" ", $arrList['category_id']);
        $sqlval['sex'] = implode(" ", $arrList['sex']);
        $sqlval['welfare'] = implode(" ", $arrList['welfare']);
        $sqlval['selection_process'] = implode(" ", $arrList['selection_process']);

        $objQuery->begin();

        // 新規登録(複製時を含む)
        if ($arrList['product_id'] == '') {
            $product_id = $objQuery->nextVal('dtb_products_product_id');
            $sqlval['product_id'] = $product_id;

            // INSERTの実行
            $sqlval['create_date'] = 'CURRENT_TIMESTAMP';
            $objQuery->insert('dtb_products', $sqlval);

            $arrList['product_id'] = $product_id;

            // 複製求人の場合には規格も複製する
            if ($arrList['copy_product_id'] != '' && SC_Utils_Ex::sfIsInt($arrList['copy_product_id'])) {
                if (!$arrList['has_product_class']) {
                    //規格なしの場合、複製は価格等の入力が発生しているため、その内容で追加登録を行う
                    $this->lfCopyProductClass($arrList, $objQuery);
                } else {
                    //規格がある場合の複製は複製元の内容で追加登録を行う
                    // dtb_products_class のカラムを取得
                    $dbFactory = SC_DB_DBFactory_Ex::getInstance();
                    $arrColList = $objQuery->listTableFields('dtb_products_class');
                    $arrColList_tmp = array_flip($arrColList);

                    // 複製しない列
                    unset($arrColList[$arrColList_tmp['product_class_id']]);     //規格ID
                    unset($arrColList[$arrColList_tmp['product_id']]);           //求人ID
                    unset($arrColList[$arrColList_tmp['create_date']]);

                    // 複製元求人の規格データ取得
                    $col = SC_Utils_Ex::sfGetCommaList($arrColList);
                    $table = 'dtb_products_class';
                    $where = 'product_id = ?';
                    $objQuery->setOrder('product_class_id');
                    $arrProductsClass = $objQuery->select($col, $table, $where, array($arrList['copy_product_id']));

                    // 規格データ登録
                    $objQuery = & SC_Query_Ex::getSingletonInstance();
                    foreach ($arrProductsClass as $arrData) {
                        $sqlval = $arrData;
                        $sqlval['product_class_id'] = $objQuery->nextVal('dtb_products_class_product_class_id');
                        $sqlval['deliv_fee'] = $arrList['deliv_fee'];
                        $sqlval['point_rate'] = $arrList['point_rate'];
                        $sqlval['sale_limit'] = $arrList['sale_limit'];
                        $sqlval['product_id'] = $product_id;
                        $sqlval['create_date'] = 'CURRENT_TIMESTAMP';
                        $sqlval['update_date'] = 'CURRENT_TIMESTAMP';
                        $objQuery->insert($table, $sqlval);
                    }
                }
            }
            // 更新
        } else {
            $product_id = $arrList['product_id'];
            // 削除要求のあった既存ファイルの削除
            $arrRet = $this->lfGetProductData_FromDB($arrList['product_id']);
            // TODO: SC_UploadFile::deleteDBFileの画像削除条件見直し要
            $objImage = new SC_Image_Ex($objUpFile->temp_dir);
            $arrKeyName = $objUpFile->keyname;
            $arrSaveFile = $objUpFile->save_file;
            $arrImageKey = array();
            foreach ($arrKeyName as $key => $keyname) {
                if ($arrRet[$keyname] && !$arrSaveFile[$key]) {
                    $arrImageKey[] = $keyname;
                    $has_same_image = $this->lfHasSameProductImage($arrList['product_id'], $arrImageKey, $arrRet[$keyname]);
                    if (!$has_same_image) {
                        $objImage->deleteImage($arrRet[$keyname], $objUpFile->save_dir);
                    }
                }
            }
            $objDownFile->deleteDBDownFile($arrRet);
            // UPDATEの実行
            $where = 'product_id = ?';
            $objQuery->update('dtb_products', $sqlval, $where, array($product_id));
        }

        // 求人登録の時は規格を生成する。複製の場合は規格も複製されるのでこの処理は不要。
        if ($arrList['copy_product_id'] == '') {
            // 規格登録
            if ($objDb->sfHasProductClass($product_id)) {
                // 規格あり求人（求人規格テーブルのうち、求人登録フォームで設定するパラメーターのみ更新）
                $this->lfUpdateProductClass($arrList);
            } else {
                // 規格なし求人（求人規格テーブルの更新）
                $arrList['product_class_id'] = $this->lfInsertDummyProductClass($arrList);
            }
        }

        // 求人ステータス設定
        $objProduct = new SC_Product_Ex();
        $objProduct->setProductStatus($product_id, $arrList['product_status']);

        // 税情報設定
        if (OPTION_PRODUCT_TAX_RULE && !$objDb->sfHasProductClass($product_id)) {
            SC_Helper_TaxRule_Ex::setTaxRuleForProduct($arrList['tax_rate'], $arrList['product_id'], $arrList['product_class_id']);
        }

        // 関連求人登録
        $this->lfInsertRecommendProducts($objQuery, $arrList, $product_id);

        $objQuery->commit();

        return $product_id;
    }

    /**
     * 規格を設定していない求人を求人規格テーブルに登録
     *
     * @param  array $arrList
     * @return void
     */
    public function lfInsertDummyProductClass($arrList) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $objDb = new SC_Helper_DB_Ex();

        // 配列の添字を定義
        $checkArray = array('product_class_id', 'product_id', 'product_code', 'stock', 'stock_unlimited', 'price01', 'price02', 'sale_limit', 'deliv_fee', 'point_rate', 'product_type_id', 'down_filename', 'down_realfilename');
        $sqlval = SC_Utils_Ex::sfArrayIntersectKeys($arrList, $checkArray);
        $sqlval = SC_Utils_Ex::arrayDefineIndexes($sqlval, $checkArray);

        $sqlval['stock_unlimited'] = $sqlval['stock_unlimited'] ? UNLIMITED_FLG_UNLIMITED : UNLIMITED_FLG_LIMITED;
        $sqlval['creator_id'] = strlen($_SESSION['member_id']) >= 1 ? $_SESSION['member_id'] : '0';

        if (strlen($sqlval['product_class_id']) == 0) {
            $sqlval['product_class_id'] = $objQuery->nextVal('dtb_products_class_product_class_id');
            $sqlval['create_date'] = 'CURRENT_TIMESTAMP';
            $sqlval['update_date'] = 'CURRENT_TIMESTAMP';
            // INSERTの実行
            $objQuery->insert('dtb_products_class', $sqlval);
        } else {
            $sqlval['update_date'] = 'CURRENT_TIMESTAMP';
            // UPDATEの実行
            $objQuery->update('dtb_products_class', $sqlval, 'product_class_id = ?', array($sqlval['product_class_id']));
        }
        return $sqlval['product_class_id'];
    }

    /**
     * 規格を設定している求人の求人規格テーブルを更新
     * (deliv_fee, point_rate, sale_limit)
     *
     * @param  array $arrList
     * @return void
     */
    public function lfUpdateProductClass($arrList) {
        $objQuery = & SC_Query_Ex::getSingletonInstance();
        $sqlval = array();

        $sqlval['deliv_fee'] = $arrList['deliv_fee'];
        $sqlval['point_rate'] = $arrList['point_rate'];
        $sqlval['sale_limit'] = $arrList['sale_limit'];
        $where = 'product_id = ?';
        $objQuery->update('dtb_products_class', $sqlval, $where, array($arrList['product_id']));
    }

    /**
     * DBに関連求人データを登録する
     *
     * @param  SC_Query  $objQuery   SC_Queryインスタンス
     * @param  string  $arrList    フォーム入力パラメーター配列
     * @param  integer $product_id 登録する求人ID
     * @return void
     */
    public function lfInsertRecommendProducts(&$objQuery, $arrList, $product_id) {
        // 一旦関連求人を全て削除する
        $objQuery->delete('dtb_recommend_products', 'product_id = ?', array($product_id));
        $sqlval['product_id'] = $product_id;
        $rank = RECOMMEND_PRODUCT_MAX;
        for ($i = 1; $i <= RECOMMEND_PRODUCT_MAX; $i++) {
            $keyname = 'recommend_id' . $i;
            $commentkey = 'recommend_comment' . $i;
            $deletekey = 'recommend_delete' . $i;

            if (!isset($arrList[$deletekey]))
                $arrList[$deletekey] = null;

            if ($arrList[$keyname] != '' && $arrList[$deletekey] != '1') {
                $sqlval['recommend_product_id'] = $arrList[$keyname];
                $sqlval['comment'] = $arrList[$commentkey];
                $sqlval['rank'] = $rank;
                $sqlval['creator_id'] = $_SESSION['member_id'];
                $sqlval['create_date'] = 'CURRENT_TIMESTAMP';
                $sqlval['update_date'] = 'CURRENT_TIMESTAMP';
                $objQuery->insert('dtb_recommend_products', $sqlval);
                $rank--;
            }
        }
    }

    /**
     * 規格データをコピーする
     *
     * @param  array   $arrList  フォーム入力パラメーター配列
     * @param  SC_Query  $objQuery SC_Queryインスタンス
     * @return boolean エラーフラグ
     */
    public function lfCopyProductClass($arrList, &$objQuery) {
        // 複製元のdtb_products_classを取得（規格なしのため、1件のみの取得）
        $col = '*';
        $table = 'dtb_products_class';
        $where = 'product_id = ?';
        $arrProductClass = $objQuery->select($col, $table, $where, array($arrList['copy_product_id']));

        //トランザクション開始
        $objQuery->begin();
        $err_flag = false;
        //非編集項目は複製、編集項目は上書きして登録
        foreach ($arrProductClass as $records) {
            foreach ($records as $key => $value) {
                if (isset($arrList[$key])) {
                    switch ($key) {
                        case 'stock_unlimited':
                            $records[$key] = (int) $arrList[$key];
                            break;
                        default:
                            $records[$key] = $arrList[$key];
                            break;
                    }
                }
            }

            $records['product_class_id'] = $objQuery->nextVal('dtb_products_class_product_class_id');
            $records['update_date'] = 'CURRENT_TIMESTAMP';
            $records['create_date'] = 'CURRENT_TIMESTAMP';
            $objQuery->insert($table, $records);
            //エラー発生時は中断
            if ($objQuery->isError()) {
                $err_flag = true;
                continue;
            }
        }
        //トランザクション終了
        if ($err_flag) {
            $objQuery->rollback();
        } else {
            $objQuery->commit();
        }

        return !$err_flag;
    }

    /**
     * リネームする際は、自動生成される画像名に一意となるように、Suffixを付ける
     *
     * @param  string $to_key
     * @return string
     */
    public function lfGetAddSuffix($to_key) {
        if (IMAGE_RENAME === true)
            return;

        // 自動生成される画像名
        $dist_name = '';
        switch ($to_key) {
            case 'main_list_image':
                $dist_name = '_s';
                break;
            case 'main_image':
                $dist_name = '_m';
                break;
            default:
                $arrRet = explode('sub_image', $to_key);
                $dist_name = '_sub' . $arrRet[1];
                break;
        }

        return $dist_name;
    }

    /**
     * アンカーハッシュ文字列を取得する
     * アンカーキーをサニタイジングする
     *
     * @param  string $anchor_key フォーム入力パラメーターで受け取ったアンカーキー
     * @return <type>
     */
    public function getAnchorHash($anchor_key) {
        if ($anchor_key != '') {
            return "location.hash='#" . htmlspecialchars($anchor_key) . "'";
        } else {
            return '';
        }
    }

}
