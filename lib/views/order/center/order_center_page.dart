import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/views/order/center/order_center_controller.dart';

/*
  包裹&订单
  订单中心
*/

class OrderCenterView extends GetView<OrderCenterController> {
  const OrderCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Obx(
          () => ZHTextLine(
            str: '我的包裹'.ts,
            color: BaseStylesConfig.textBlack,
            fontSize: 18,
          ),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      body: RefreshIndicator(
        color: BaseStylesConfig.themeRed,
        child: btnCell(),
        onRefresh: controller.getDatas,
      ),
    );
  }

  /*
  订单包裹等按钮列表
  */
  Widget btnCell() {
    return Container(
      decoration: BoxDecoration(
        color: BaseStylesConfig.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.only(top: 10.h),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 0.0, //水平子Widget之间间距
            mainAxisSpacing: 0.0, //垂直子Widget之间间距
            crossAxisCount: 4, //一行的Widget数量
            childAspectRatio: 1,
          ), // 宽高比例
          itemCount: 8,
          itemBuilder: (context, index) {
            return Obx(() => itemCell(context, index));
          }),
    );
  }

  Widget itemCell(BuildContext context, index) {
    List<Map<String, dynamic>> list = [
      {
        'title': '未入库',
        'icon': 'PackageAndOrder/undone-icon',
        'qty':
            controller.userOrderCountModel.value?.waitStorage.toString() ?? '',
      },
      {
        'title': '已入库',
        'icon': 'PackageAndOrder/done-icon',
        'qty':
            controller.userOrderCountModel.value?.alreadyStorage.toString() ??
                '',
      },
      {
        'title': '待处理',
        'icon': 'PackageAndOrder/process-icon',
        'qty': controller.userOrderCountModel.value?.waitPack.toString() ?? '',
      },
      {
        'title': '待支付',
        'icon': 'PackageAndOrder/unpaid-icon',
        'qty': controller.userOrderCountModel.value?.waitPay.toString() ?? '',
      },
      {
        'title': '待发货',
        'icon': 'PackageAndOrder/unship-icon',
        'qty': controller.userOrderCountModel.value?.waitTran.toString() ?? '',
      },
      {
        'title': '已发货',
        'icon': 'PackageAndOrder/ship-icon',
        'qty': controller.userOrderCountModel.value?.shipping.toString() ?? '',
      },
      {
        'title': '已签收',
        'icon': 'PackageAndOrder/sign-icon',
        'qty': '',
      },
      {
        'title': '异常件认领',
        'icon': 'PackageAndOrder/abnormal-icon',
        'qty': '',
      },
    ];
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Routers.push(Routers.parcelList, 1);
        } else if (index == 1) {
          Routers.push(Routers.parcelList, 2);
        } else if (index < 7) {
          Routers.push(Routers.orderList, {'index': index - 1});
        } else if (index == 7) {
          Routers.push(Routers.noOwnerList);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                LoadImage(
                  list[index]['icon'],
                  fit: BoxFit.fitWidth,
                  width: 50,
                  height: 50,
                ),
                list[index]['qty'].isNotEmpty && list[index]['qty'] != '0'
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: BaseStylesConfig.textRed,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          height: 20,
                          width: 20,
                          child: ZHTextLine(
                            alignment: TextAlign.center,
                            str: list[index]['qty'],
                            fontSize: list[index]['qty'].length == 1 ? 14 : 12,
                            fontWeight: FontWeight.bold,
                            color: BaseStylesConfig.white,
                          ),
                        ),
                      )
                    : Sized.empty,
              ],
            ),
            ZHTextLine(
              str: (list[index]['title'] as String).ts,
              lines: 5,
              alignment: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
