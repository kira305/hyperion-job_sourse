<!--{*
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
 *}-->

<script type="text/javascript">//<![CDATA[
    // 規格2に選択肢を割り当てる。
    function fnSetClassCategories(form, classcat_id2_selected) {
        var $form = $(form);
        var product_id = $form.find('input[name=product_id]').val();
        var $sele1 = $form.find('select[name=classcategory_id1]');
        var $sele2 = $form.find('select[name=classcategory_id2]');
        eccube.setClassCategories($form, product_id, $sele1, $sele2, classcat_id2_selected);
    }

    function applyPopup(){
        $.colorbox({href:"<!--{$smarty.const.ROOT_URLPATH}--><!--{$smarty.const.USER_DIR}-->apply_popup.php", iframe:true, fastIframe:false, width:"800px", height:"500px", transition:"fade", scrolling:false});
    }

    $(function(){
        var detailHeader = $(".detail_header").clone();
        $('<div />', { class: 'detail_header_float' }).append(detailHeader).insertAfter("#detailarea");

        var detailHeaderVisibleHeight = $('#header_wrap').outerHeight() + $('#topcolumn').outerHeight() + 20 + $('.detail_header').outerHeight();
        var flag = false;
        $(window).scroll(function () {
            var scrollTop = $(this).scrollTop();
            if (scrollTop > detailHeaderVisibleHeight) {
                if (flag == false) {
                    flag = true;
                    $('.detail_header_float').stop().animate({
                        'top': '0'
                    }, 500);
                }
            } else {
                if (flag) {
                    flag = false;
                    $('.detail_header_float').stop().animate({
                        'top': '-100px'
                    }, 500);
                }
            }
        });
    });
//]]></script>

<div id="undercolumn">
    <form name="form1" id="form1" method="post" action="?">
        <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
        <input type="hidden" name="mode" value="cart" />
        <input type="hidden" name="product_id" value="<!--{$tpl_product_id}-->" />
        <input type="hidden" name="product_class_id" value="<!--{$tpl_product_class_id}-->" id="product_class_id" />
        <input type="hidden" name="favorite_product_id" value="" />
        <input type="hidden" name="quantity" value="1" />
        <div id="detailarea" class="clearfix">
            <div class="detail_header">
                <div id="detailphotobloc">
                    <!--{assign var=key value="main_large_image"}-->
                    <!--★画像★-->
                    <!--{if $arrProduct.base64_image == '' }-->
                        <img src="<!--{$arrFile[$key].filepath|h}-->" alt="<!--{$arrProduct.name|h}-->" />
                    <!--{else}-->
                        <img src="<!--{$arrFile[$key].base64_image|h}-->" alt="<!--{$arrProduct.name|h}-->" />
                    <!--{/if}-->
                </div>
                <div id="detailrightbloc">
                    <!--★仕事名★-->
                    <h2><!--{$arrProduct.name|h}--></h2>

                    <div class="end_date">終了日：<!--{$arrProduct.end_date|date_format:"%Y年%m月%d日"}--></div>

                    <div class="btn_area" id="detail_btn_area">
                        <!--{if $arrProduct.is_favorite }-->
                            <button class="bttn" type="button" onClick=""><span>お気に入り</span></button>
                        <!--{else}-->
                            <button class="bttn" type="button" onClick="javascript:eccube.changeAction('?product_id=<!--{$arrProduct.product_id|h}-->'); eccube.setModeAndSubmit('add_favorite', '', '');"><span>お気に入り登録</span></button>
                        <!--{/if}-->
                        &nbsp; &nbsp;
                        <!--{if $isApplied}-->
                            <button class="bttn" type="button" onClick=""><span>応募済み</span></button>
                        <!--{elseif $arrProduct.end_date != '' && $arrProduct.end_date|strtotime <= $smarty.now|date_format:"%Y-%m-%d"|strtotime}-->
                            <button class="bttn" type="button" onClick=""><span>掲載期間が終了しています</span></button>
                        <!--{else}-->
                            <button class="bttn" type="button" onclick="javascript:eccube.changeAction('?product_id=<!--{$arrProduct.product_id|h}-->'); eccube.setModeAndSubmit('cart_to_shopping', 'quantity', 1);"><span>応募</span></button>
                        <!--{/if}-->
                    </div>
                </div>
            </div>
            <div class="table">
                <div class="table_cell">
                    <p class="detail_block_title">応募詳細</p>
                    <table class="detail_block_table">
                        <tr>
                            <th>雇用形態</th>
                            <td><!--{$arrEmploymentStatus[$arrProduct.employment_status]}--></td>
                        </tr>
                        <tr>
                            <th>給与</th>
                            <td><!--{$arrProduct.salary_full|h}--><br /><!--{$arrProduct.salary|h|nl2br_html}--></td>
                        </tr>
                        <tr>
                            <th>勤務地</th>
                            <td><!--{$arrRegion[$arrProduct.region]}--> <!--{$arrCity[$arrProduct.city]}--><br /><!--{$arrProduct.work_location}--></td>
                        </tr>
                        <tr>
                            <th>交通アクセス</th>
                            <td><!--{$arrProduct.traffic_access|nl2br_html}--></td>
                        </tr>
                        <tr>
                            <th>勤務時間</th>
                            <td><!--{$arrProduct.working_hour|nl2br_html}--><br />昼休み時間：<!--{$arrProduct.lunch_time|nl2br_html}--></td>
                        </tr>
                        <tr>
                            <th>勤務曜日</th>
                            <td><!--{$arrProduct.working_day|nl2br_html}--></td>
                        </tr>
                        <tr>
                            <th>試用期間</th>
                            <td><!--{$arrProduct.trial_period|nl2br_html}--></td>
                        </tr>
                    </table>

                    <p class="detail_block_title">仕事条件</p>
                    <table class="detail_block_table">
                        <tr>
                            <th>仕事数</th>
                            <td><!--{$arrProduct.offer_number}--></td>
                        </tr>
                        <tr>
                            <th>性別</th>
                            <td>
                                <!--{if count($arrProduct.sex) > 0}-->
                                    <!--{foreach from=$arrProduct.sex item="item" key="key"}-->
                                        <!--{$arrSex.$item}--><!--{if $key < count($arrProduct.sex) - 1}-->, <!--{/if}-->
                                    <!--{/foreach}-->
                                <!--{/if}-->
                            </td>
                        </tr>
                        <tr>
                            <th>資格</th>
                            <td><!--{$arrProduct.qualification|nl2br_html}--></td>
                        </tr>
                        <tr>
                            <th>性格</th>
                            <td><!--{$arrProduct.personality|nl2br_html}--></td>
                        </tr>
                        <tr>
                            <th>経験・スキルの詳細</th>
                            <td><!--{$arrProduct.skill|nl2br_html}--></td>
                        </tr>
                    </table>

                    <p class="detail_block_title">福利厚生・制度</p>
                    <table class="detail_block_table">
                        <tr>
                            <th>昇給</th>
                            <td><!--{$arrProduct.payrise|nl2br_html}--></td>
                        </tr>
                        <tr>
                            <th>賞与</th>
                            <td><!--{$arrProduct.bonus|nl2br_html}--></td>
                        </tr>
                        <tr>
                            <th>保険</th>
                            <td><!--{$arrProduct.insurance|nl2br_html}--></td>
                        </tr>
                        <tr>
                            <th>福利</th>
                            <td>
                                <!--{if count($arrProduct.welfare) > 0}-->
                                    <!--{foreach from=$arrProduct.welfare item="item" key="key"}-->
                                        <!--{$arrWelfare.$item}--><br />
                                    <!--{/foreach}-->
                                <!--{/if}-->
                            </td>
                        </tr>
                        <tr>
                            <th>その他の福利</th>
                            <td><!--{$arrProduct.other_welfare|nl2br_html}--></td>
                        </tr>
                        <tr>
                            <th>健康診断</th>
                            <td><!--{$arrProduct.medical_checkup|nl2br_html}--></td>
                        </tr>
                    </table>
                </div>
                <div class="table_cell">
                    <p class="detail_block_title">仕事詳細</p>
                    <div class="detail_block_area">
                        <!--{$arrProduct.main_comment|nl2br_html}-->
                    </div>
                    <!--{if $arrProduct.employment_status == 1}-->
                    <p class="detail_block_title">会社紹介</p>
                    <div class="detail_block_area"><!--{$arrProduct.client_introduction|nl2br_html}--></div>
                    <!--{/if}-->
                </div>
            </div>

            <p class="detail_block_title">応募方法</p>
            <table class="detail_block_table">
                <tr>
                    <th>応募方法</th>
                    <td><!--{$arrProduct.applicate_method|nl2br_html}--></td>
                </tr>
                <tr>
                    <th>選考プロセス</th>
                    <td>
                        <!--{if count($arrProduct.selection_process) > 0}-->
                            <!--{foreach from=$arrProduct.selection_process item=item key=key}-->
                            <div class="selection_process">
                                <img src="<!--{$TPL_URLPATH}--><!--{$arrProcessImage[$item]}-->" alt="<!--{$arrProcess[$item]}-->" id="icon<!--{$item}-->" />
                                <p><!--{$arrProcess[$item]}--></p>
                            </div><!--{if $key < count($arrProduct.selection_process) - 1}--><span class="selection_arrow">›</span><!--{/if}-->
                            <!--{/foreach}-->
                        <!--{/if}-->
                    </td>
                </tr>
                <!--{if $arrProduct.concierge_info != ''}-->
                <tr>
                    <th>担当者</th>
                    <td>
                        <div id="concierge_info">
                            <img src="<!--{$smarty.const.IMAGE_SAVE_URLPATH}--><!--{$arrProduct.concierge_info.image}-->" alt="<!--{$arrProduct.concierge_info.name}-->" />
                            <span>仕事コンシェルジュ</span>
                            <!--{$arrProduct.concierge_info.name}--><br />
                            <img src="<!--{$TPL_URLPATH}-->img/icon/ico_phone.png" alt="phone" /> <!--{$arrProduct.concierge_info.tel}--><br />
                            <img src="<!--{$TPL_URLPATH}-->img/icon/ico_mail.png" alt="mail" /> <!--{$arrProduct.concierge_info.email}--><br />
                            <!--{$arrTarget[$arrProduct.concierge_info.workplace]}-->オフィス所属
                        </div>
                    </td>
                </tr>
                <!--{/if}-->
            </table>

        </div>
    </form>

    <!--詳細ここまで-->

</div>
