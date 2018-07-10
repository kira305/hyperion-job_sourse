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
<!--{$arrOrder.order_name01}--> <!--{$arrOrder.order_name02}--> 

<!--{$tpl_header}-->

************************************************
　Chi tiết công việc
************************************************

<!--{section name=cnt loop=$arrOrderDetail}-->
<!--{assign var=pid value=`$arrOrderDetail[cnt].product_id`}-->
<!--{assign var=regionId value=`$arrProduct[$pid].region`}-->
<!--{assign var=cityId value=`$arrProduct[$pid].city`}-->
Tên công việc： <!--{$arrProduct[$pid].name_vn|h}-->
Mức lương： <!--{$arrProduct[$pid].salary_full|h}-->
<!--{$arrProduct[$pid].salary_vn|h}-->
Ngày làm việc： <!--{$arrProduct[$pid].working_day_vn}-->
Thời gian làm việc： <!--{$arrProduct[$pid].working_hour_vn}-->
Địa điểm làm việc： <!--{$arrRegion[$regionId]}--> <!--{$arrCity[$cityId]}--> <!--{$arrProduct[$pid].work_location_vn}-->
<!--{/section}-->

<!--{$tpl_footer}-->
