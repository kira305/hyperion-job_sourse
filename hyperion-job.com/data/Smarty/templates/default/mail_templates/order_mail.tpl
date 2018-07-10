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
<!--{$arrOrder.order_name01}--> <!--{$arrOrder.order_name02}--> 様

<!--{$tpl_header}-->

************************************************
　仕事詳細
************************************************

<!--{section name=cnt loop=$arrOrderDetail}-->
<!--{assign var=pid value=`$arrOrderDetail[cnt].product_id`}-->
<!--{assign var=regionId value=`$arrProduct[$pid].region`}-->
<!--{assign var=cityId value=`$arrProduct[$pid].city`}-->
仕事名： <!--{$arrOrderDetail[cnt].product_name}-->
給与： <!--{$arrProduct[$pid].salary_full|h}-->
<!--{$arrProduct[$pid].salary|h}-->
就業日： <!--{$arrProduct[$pid].working_day}-->
勤務時間： <!--{$arrProduct[$pid].working_hour}-->
勤務地： <!--{$arrRegion[$regionId]}--> <!--{$arrCity[$cityId]}--> <!--{$arrProduct[$pid].work_location}-->
<!--{/section}-->

<!--{$tpl_footer}-->
