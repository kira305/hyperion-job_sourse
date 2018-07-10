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

<div id="undercolumn">
    <h2 class="title">Liên hệ</h2>

    <div id="undercolumn_contact">

        <form name="form1" id="form1" method="post" action="?">
            <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
            <input type="hidden" name="mode" value="confirm" />

            <table summary="お問い合わせ">
                <col width="30%" />
                <col width="70%" />
                <tr>
                    <th>Tên của bạn<span class="attention">※</span></th>
                    <td>
                        <span class="attention"><!--{$arrErr.name01}--><!--{$arrErr.name02}--></span>
                        Họ&nbsp;<input type="text" class="box120" name="name01" value="<!--{$arrForm.name01.value|default:$arrData.name01|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr.name01|sfGetErrorColor}-->; ime-mode: active;" />　
                        Tên&nbsp;<input type="text" class="box120" name="name02" value="<!--{$arrForm.name02.value|default:$arrData.name02|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr.name02|sfGetErrorColor}-->; ime-mode: active;" />
                    </td>
                </tr>
                <tr>
                    <th>Tên của bạn (Furigana)</th>
                    <td>
                        <span class="attention"><!--{$arrErr.kana01}--><!--{$arrErr.kana02}--></span>
                        Họ&nbsp;<input type="text" class="box120" name="kana01" value="<!--{$arrForm.kana01.value|default:$arrData.kana01|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr.kana01|sfGetErrorColor}-->; ime-mode: active;" />　
                        Tên&nbsp;<input type="text" class="box120" name="kana02" value="<!--{$arrForm.kana02.value|default:$arrData.kana02|h}-->" maxlength="<!--{$smarty.const.STEXT_LEN}-->" style="<!--{$arrErr.kana02|sfGetErrorColor}-->; ime-mode: active;" />
                    </td>
                </tr>
                <tr>
                    <th>Điện thoại</th>
                    <td>
                        <span class="attention"><!--{$arrErr.tel01}--><!--{$arrErr.tel02}--><!--{$arrErr.tel03}--></span>
                        <input type="text" class="box60" name="tel01" value="<!--{$arrForm.tel01.value|default:$arrData.tel01|h}-->" maxlength="<!--{$smarty.const.TEL_ITEM_LEN}-->" style="<!--{$arrErr.tel01|sfGetErrorColor}-->; ime-mode: disabled;" />&nbsp;-&nbsp;
                        <input type="text" class="box60" name="tel02" value="<!--{$arrForm.tel02.value|default:$arrData.tel02|h}-->" maxlength="<!--{$smarty.const.TEL_ITEM_LEN}-->" style="<!--{$arrErr.tel02|sfGetErrorColor}-->; ime-mode: disabled;" />&nbsp;-&nbsp;
                        <input type="text" class="box60" name="tel03" value="<!--{$arrForm.tel03.value|default:$arrData.tel03|h}-->" maxlength="<!--{$smarty.const.TEL_ITEM_LEN}-->" style="<!--{$arrErr.tel03|sfGetErrorColor}-->; ime-mode: disabled;" />
                    </td>
                </tr>
                <tr>
                    <th>Email<span class="attention">※</span></th>
                    <td>
                        <span class="attention"><!--{$arrErr.email}--><!--{$arrErr.email02}--></span>
                        <input type="text" class="box380 top" name="email" value="<!--{$arrForm.email.value|default:$arrData.email|h}-->" style="<!--{$arrErr.email|sfGetErrorColor}-->; ime-mode: disabled;" /><br />
                        <!--{* ログインしていれば入力済みにする *}-->
                        <!--{if $smarty.session.customer}-->
                        <!--{assign var=email02 value=$arrData.email}-->
                        <!--{/if}-->
                        <input type="text" class="box380" name="email02" value="<!--{$arrForm.email02.value|default:$email02|h}-->" style="<!--{$arrErr.email02|sfGetErrorColor}-->; ime-mode: disabled;" /><br />
                        <p class="mini"><span class="attention">Vui lòng nhập lại lần 2 để xác nhận.</span></p>
                    </td>
                </tr>
                <tr>
                    <th>Câu hỏi của bạn<span class="attention">※</span><br />
                    <span class="mini">(Không quá <!--{$smarty.const.MLTEXT_LEN}--> ký tự)</span></th>
                    <td>
                        <span class="attention"><!--{$arrErr.contents}--></span>
                        <textarea name="contents" class="box380" cols="60" rows="20" style="<!--{$arrErr.contents.value|h|sfGetErrorColor}-->; ime-mode: active;"><!--{"\n"}--><!--{$arrForm.contents.value|h}--></textarea>
                        <p class="mini attention">※Những thắc mắc liên quan đến việc ứng tuyển, vui lòng điền thêm tên công việc  để tiện cho việc xác nhận.</p>
                    </td>
                </tr>
            </table>

            <div class="btn_area">
                <ul>
                    <li>
                        <input type="submit" value="Xác nhận" name="confirm" />
                    </li>
                </ul>
            </div>

        </form>
                    
        <p class="pmark_area">Trong trường hợp khẩn cấp hoặc cần tư vấn trực tiếp vui lòng liên hệ đến số điện thoại (+84) 90-229-7658.<br />
            Để biết thông tin về chính sách bảo mật thông tin cá nhân của chúng tôi, vui lòng nhấp vào <a href="<!--{$smarty.const.ROOT_URLPATH}-->guide/privacy.php">đây</a>。</p>
        <div class="contact_privacy">
            <div class="pmark"><a href="https://privacymark.jp/" target="_blank"><img src="<!--{$TPL_URLPATH}-->img/picture/img-privacy.png" alt="" width="94" height="96"></a></div>
            <p class="ptext">Hyperion đã được cấp Privacy Mark, đảm bảo việc bảo mật thông tin cá nhân một cách an toàn.</p>
        </div>
    </div>
</div>
