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

/**
 * PDF 納品書を出力する
 *
 * TODO ページクラスとすべき要素を多々含んでいるように感じる。
 */
define('PDF_TEMPLATE_REALDIR', TEMPLATE_ADMIN_REALDIR . 'pdf/');

class SC_Fpdf_CV extends SC_Helper_FPDI {

    var $customer_data;

    public function __construct() {
        $this->FPDF();
        // デフォルトの設定
        $this->tpl_pdf = PDF_TEMPLATE_REALDIR . 'cvjp.pdf';  // テンプレートファイル

        $masterData = new SC_DB_MasterData_Ex();
        $this->arrSex = $masterData->getMasterData('mtb_sex');
        $this->arrMaritalStatus = $masterData->getMasterData('mtb_marital_status');
        $this->arrTarget = $masterData->getMasterData('mtb_object');
        $this->arrEducation = $masterData->getMasterData('mtb_education');
        $this->arrPosition = $masterData->getMasterData('mtb_position');
        $this->arrRegion = $masterData->getMasterData('mtb_region');
        $this->arrJLPT = $masterData->getMasterData('mtb_jlpt');
        $this->arrWorkExperience = array(1 => '経験あり', 0 => '未経験');
        $this->arrPref = $masterData->getMasterData('mtb_pref');
        $this->arrCategory = $masterData->getMasterData('mtb_category');

        // SJISフォント
        $this->AddSJISFont();
        $this->SetFont('SJIS');

        //ページ総数取得
        $this->AliasNbPages();

        // マージン設定
        $this->SetMargins(5, 5);

        // PDFを読み込んでページ数を取得
        $this->pageno = $this->setSourceFile($this->tpl_pdf);
    }

    public function setData($id = '') {
        // ページ番号よりIDを取得
        $tplidx = $this->ImportPage(1);
        // ページを追加（新規）
        $this->AddPage();
        //表示倍率(100%)
        $this->SetDisplayMode('real');
        // テンプレート内容の位置、幅を調整 ※useTemplateに引数を与えなければ100%表示がデフォルト
        $this->useTemplate($tplidx);

        $objCustomer = new SC_Customer_Ex();
        $customer_id = empty($id) ? $objCustomer->getValue('customer_id') : $id;
        $this->customer_data = SC_Helper_Customer_Ex::sfGetCustomerData($customer_id);

        $fontSize = 7.5;
        $this->SetFont('Gothic', '', $fontSize);

        if(!empty($this->customer_data['image']))
        {
            $this->Image(IMAGE_SAVE_DIR_COMMON . $this->customer_data['image'], 161, 20, 30 ,30);
        }
        //職歴のページ数を判定
        $historyCount = count($this->customer_data['start_year']);
        $historyPageCount = 0;
        if($historyCount>0) {
            //1ページに５職歴
            $historyPageCount = ceil($historyCount / 5);
        }
        //ページ数を出力
        $this->lfText(190, 15, '1/' . ($historyPageCount+1), $fontSize, '');

        $x = 55;
        $y = 21;
        $lineHeight = 7.2;
        $this->lfText($x, $y, $this->customer_data['name01'] . ' ' . $this->customer_data['name02'], $fontSize, '');
        $this->lfText($x, $y + $lineHeight, $this->arrSex[$this->customer_data['sex']], $fontSize, '');
        $this->lfText($x, $y + 2 * $lineHeight, $this->customer_data['year'] . '年' . $this->customer_data['month'] . '月' . $this->customer_data['day'] . '日', $fontSize, '');
        $this->lfText($x, $y + 3 * $lineHeight, $this->customer_data['email'], $fontSize, '');
        $this->lfText($x, $y + 4 * $lineHeight, $this->customer_data['tel01'] . '-' . $this->customer_data['tel02'] . '-' . $this->customer_data['tel03'], $fontSize, '');

        $x = 55;
        $y = 60;
        $lineHeight = 5.4;
        $this->lfText($x, $y, $this->arrMaritalStatus[$this->customer_data['marital_status']], $fontSize, '');
        $this->lfText($x, $y + $lineHeight, $this->arrTarget[$this->customer_data['current_address']], $fontSize, '');
        $this->lfText($x, $y + 2 * $lineHeight, '〒 ' . $this->customer_data['zip01'] . ' - ' . $this->customer_data['zip02'], $fontSize, '');
        $this->lfText($x, $y + 3 * $lineHeight, $this->arrPref[$this->customer_data['pref']], $fontSize, '');
        $this->lfText($x, $y + 4 * $lineHeight, $this->customer_data['addr01'], $fontSize, '');
        $this->lfText($x, $y + 5 * $lineHeight, $this->customer_data['addr02'], $fontSize, '');
        $this->lfText($x, $y + 6 * $lineHeight, $this->arrEducation[$this->customer_data['education']], $fontSize, '');
        $this->lfText($x, $y + 7 * $lineHeight, $this->customer_data['school_name'], $fontSize, '');
        $this->lfText($x, $y + 8 * $lineHeight, $this->customer_data['major'], $fontSize, '');
        //卒業年月日　TODO
        $lineHeight = 5.35;
        $this->lfText($x, $y + 9 * $lineHeight, $this->customer_data['graduation_year'] . '年' . $this->customer_data['graduation_month'] . '月' . $this->customer_data['graduation_day'] . '日', $fontSize, '');
        $lineHeight = 5.3;
        $this->lfText($x, $y + 10 * $lineHeight, $this->arrWorkExperience[$this->customer_data['work_experience']], $fontSize, '');
    
        $x = 55;
        $y = 117;
        $this->SetXY($x - 1, $y);
        $this->MultiCell(126, $lineHeight, $this->arrIdToStrValue($this->arrCategory, $this->customer_data['desired_work']), 0, 'L', false);
        //positionを削除
        // $this->lfText($x, $y, $this->arrIdToStrValue($this->arrPosition, $this->customer_data['desired_position']), $fontSize, '');
        $y = 136;
        if ($this->customer_data['current_salary'] != '' && $this->customer_data['current_salary'] > 1)
            $this->lfText($x, $y, $this->customer_data['current_salary'] . '万円', $fontSize, '');
        if ($this->customer_data['desired_salary'] != '' && $this->customer_data['desired_salary'] > 1)
            $this->lfText($x, $y + 1 * $lineHeight, $this->customer_data['desired_salary'] . '万円', $fontSize, '');
        $this->lfText($x, $y + 2 * $lineHeight, $this->arrIdToStrValue($this->arrRegion, $this->customer_data['desired_region']), $fontSize, '');

        $y = 154;
        $this->lfText($x, $y, 'JLPT：' . $this->arrJLPT[$this->customer_data['jp_level']] . '　　その他：' . $this->customer_data['jp_other'], $fontSize, '');
        $this->lfText($x, $y + $lineHeight, 'TOEIC：' . $this->customer_data['toeic'] . '　　IELTS：' . $this->customer_data['ielts'] . '　　その他：' . $this->customer_data['eng_other'], $fontSize, '');
        //他の言語
        $y = 161;
        $this->SetXY($x - 1, $y);
        $strtemp = $this->getMaxLines($this->customer_data['other_language'], 2); //2行のデータのみ出力
        $this->MultiCell(126, $lineHeight, $strtemp, 0, 'L', false);

        //資格
        $this->SetXY($x - 1, 173);
        $strtemp = $this->getMaxLines($this->customer_data['qualification'], 3); //3行のデータのみ出力
        $this->MultiCell(126, $lineHeight, $strtemp, 0, 'L', false);
        //スキル
        $this->SetXY($x - 1, 190);
        $strtemp = $this->getMaxLines($this->customer_data['skill'], 3); //3行のデータのみ出力
        $this->MultiCell(126, $lineHeight, $strtemp, 0, 'L', false);
        //自己PR
        $this->SetXY($x - 1, 208);
        $this->MultiCell(140, $lineHeight, $this->customer_data['self_pr'], 0, 'L', false);
        
        for ($i = 0; $i < $historyPageCount; $i++) {
            $startNo = $i*5;
            $endNo = $startNo + 5;
            if($endNo > $historyCount) $endNo = $historyCount;
            $this->createHistoryPage($i+2, $startNo,$endNo,$historyPageCount);
        }
    }
    function createHistoryPage($pageNo, $startNo, $endNo,$historyPageCount) {
        // ページ番号よりIDを取得
       $tplidx = $this->ImportPage(2);
       // ページを追加（新規）
       $this->AddPage();
       //表示倍率(100%)
       $this->SetDisplayMode('real');
       // テンプレート内容の位置、幅を調整 ※useTemplateに引数を与えなければ100%表示がデフォルト
       $this->useTemplate($tplidx);
       //ページ数を出力
       $this->lfText(190, 15, $pageNo . '/' . ($historyPageCount+1), $fontSize, '');

        $x = 20;
        $y = 47;
        $lineHeight = 4;
        for ($i = $startNo; $i < $endNo; $i++) {
            $this->SetXY(13, $y);
            $this->MultiCell(50, $lineHeight, strval($i+1), 0, 'L', false);
            $workingDate = '';
            if ($this->customer_data['start_year'][$i] > 0 || $this->customer_data['end_year'][$i] > 0) {
                if ($this->customer_data['start_year'][$i] > 0)
                    $workingDate = $this->customer_data['start_year'][$i] . '年' . $this->customer_data['start_month'][$i] . '月';
                else
                    $workingDate = '未登録';
                
                $this->SetXY($x, $y-10);
                $this->MultiCell(50, $lineHeight, $workingDate, 0, 'L', false);
                $this->SetXY($x, $y);
                $this->MultiCell(50, $lineHeight, "　　～　　", 0, 'L', false);
                if ($this->customer_data['end_year'][$i] > 0)
                    $workingDate = $this->customer_data['end_year'][$i] . '年' . $this->customer_data['end_month'][$i] . '月';
                else
                    $workingDate = '未登録';
                $this->SetXY($x, $y+10);
                $this->MultiCell(50, $lineHeight, $workingDate, 0, 'L', false);
            }
            //年間
            $this->SetXY($x + 21, $y);
            $this->MultiCell(14, $lineHeight, $this->customer_data['working_year'][$i], 0, 'C', false);
            //会社名
            $this->SetXY($x + 33, $y-17);
            $this->MultiCell(38, $lineHeight, substr($this->customer_data['working_company_name'][$i],0,100), 0, 'L', false);
            //住所
            $this->SetXY($x + 33, $y+2);
            $this->MultiCell(38, $lineHeight, substr($this->customer_data['company_addr'][$i],0,100), 0, 'L', false);

            //TODO
            //従業員数
            $this->SetXY($x + 72, $y-17);
            $this->MultiCell(38, $lineHeight, substr($this->customer_data['working_member_num'][$i],0,40), 0, 'L', false);
            //雇用形態
            $this->SetXY($x + 72, $y-7);
            $this->MultiCell(38, $lineHeight, substr($this->customer_data['working_status'][$i],0,40), 0, 'L', false);
            //部署/役職
            $this->SetXY($x + 72, $y+3);
            $this->MultiCell(38, $lineHeight, substr($this->customer_data['working_position'][$i],0,40), 0, 'L', false);
            //業種
            $this->SetXY($x + 72, $y+13);
            $this->MultiCell(38, $lineHeight, substr($this->customer_data['working_type'][$i],0,40), 0, 'L', false);
            //経験職種
            $this->SetXY($x + 72, $y+23);
            $this->MultiCell(38, $lineHeight, substr($this->customer_data['working_experience'][$i],0,40), 0, 'L', false);
            //仕事概要
            $this->SetXY($x + 118, $y-22);
            $this->MultiCell(55, $lineHeight, substr($this->customer_data['job_description'][$i],0,800), 0, 'L', false);
            $y += 50.4;
        }
    }
    public function createPdf() {
        ob_clean();
        $filename = 'CV-' . $this->customer_data['customer_id'] . '-' . date("Ymd-His") . '.pdf';
        $this->Output($this->lfConvSjis($filename), 'D');

        // 入力してPDFファイルを閉じる
        $this->Close();
    }

    public function arrIdToStrValue($arrVal, $arrId) {
        $strValue = '';
        if (count($arrId) > 0) {
            foreach ($arrId as $i => $id) {
                if ($i == 0)
                    $strValue .= $arrVal[$id];
                else
                    $strValue .= '、' . $arrVal[$id];
            }
        }
        return $strValue;
    }

    // PDF_Japanese::Text へのパーサー

    /**
     * @param integer $x
     * @param integer $y
     */
    private function lfText($x, $y, $text, $size = 0, $style = '') {
        // 退避
        $bak_font_style = $this->FontStyle;
        $bak_font_size = $this->FontSizePt;

        $this->SetFont('', $style, $size);
        $this->Text($x, $y, $text);

        // 復元
        $this->SetFont('', $bak_font_style, $bak_font_size);
    }
    /**
     * 空欄の行を削除
     * @return string
     */
    public function removeEmptyLines($string)
    {
        return preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $string);
    }
    public function getMaxLines($string, $maxLines) {
        try {
            $string = $this->removeEmptyLines($string);
            $array = explode("\n", $string); // とりあえず行に分割
            $array = array_map('trim', $array); // 各行にtrim()をかける
            $array = array_filter($array, 'strlen'); // 文字数が0の行を取り除く
            $array = array_values($array); // これはキーを連番に振りなおしてるだけ
            $result="";
            $cnt = count($array);
            $string = $this->removeEmptyLines($string);
            if($cnt<=1) return $string;
    
            if($maxLines < $cnt) {
            } else {
                $maxLines = $cnt;
            }
            for($i=0; $i<$maxLines; $i++) {
                $result .= $array[$i] . "\n";
            }
            return $result;
        } catch(Exception $e) {
            return $string;
        }
    }
}
