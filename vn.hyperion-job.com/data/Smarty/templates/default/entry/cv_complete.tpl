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
    <div id="undercolumn_entry">
        <h2 class="title">Tải hồ sơ trực tuyến (Trang hoàn thành)</h2>
        <div id="complete_area">
            <p class="message">Tạo hồ sơ mới thành công</p>

            <br />
            <form name="form1" id="form1" method="post" action="/user_data/apply.php">
                <input type="hidden" name="<!--{$smarty.const.TRANSACTION_ID_NAME}-->" value="<!--{$transactionid}-->" />
                <input type="hidden" name="mode" value="finish" />
                <div class="btn_area">
                    <ul>
                        <li>
                            <a href="/mypage/change.php" class="bttn">Đến trang cá nhân</a>
                        </li>
                        <!--{if $applyProductId > 0}-->
                            <li>
                                <a href="#" class="bttn" onClick="eccube.setModeAndSubmit('finish', '', '');">Hoàn thành</a>
                            </li>
                            <li>
                                <a href="<!--{$smarty.const.P_DETAIL_URLPATH}--><!--{$applyProductId|u}-->" class="bttn">Đến trang chi tiết công việc</a>
                            </li>
                        <!--{else}-->
                            <li>
                                <a href="<!--{$smarty.const.ROOT_URLPATH}-->products/list.php" class="bttn">Đến trang danh sách công việc</a>
                            </li>
                        <!--{/if}-->
                    </ul>
                </div>
            </form>
        </div>
    </div>
</div>
