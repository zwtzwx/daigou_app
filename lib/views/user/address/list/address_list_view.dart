/*
  收件地址列表
 */

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/receiver_address_model.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/user/address/list/address_list_controller.dart';

class BeeShippingPage extends GetView<BeeShippingLogic> {
  const BeeShippingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: AppText(
            str: '地址管理'.inte,
            fontSize: 17,
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 15.h),
            height: 38.h,
            child: BeeButton(
              text: '添加地址',
              onPressed: () {
                GlobalPages.push(GlobalPages.addressAddEdit, arg: {
                  'isEdit': '0',
                  'addressType': controller.addressType.value
                });
              },
            ),
          ),
        ),
        backgroundColor: AppStyles.bgGray,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: [
              searchCell(),
              Expanded(
                child: Obx(() => listCell()),
              ),
              20.verticalSpace,
            ],
          ),
        ));
  }

  Widget searchCell() {
    List<String> title = ['送货上门', '自提收货'];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Obx(
        () => Row(
          children: title
              .asMap()
              .keys
              .map(
                (index) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (index + 1 == controller.addressType.value) return;
                      controller.addressType.value = index + 1;
                      controller.getAddress();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: controller.addressType.value == index + 1
                            ? AppStyles.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: AppText(
                        str: title[index].inte,
                        fontSize: 14,
                        fontWeight: controller.addressType.value == index + 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: controller.addressType.value == index + 1
                            ? Colors.white
                            : AppStyles.textDark,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget listCell() {
    var listView = ListView.builder(
      shrinkWrap: true,
      itemBuilder: addressItemCell,
      itemCount: controller.addressList.length,
    );
    return listView;
  }

  Widget addressItemCell(BuildContext context, int index) {
    ReceiverAddressModel model = controller.addressList[index];
    // 名字
    String nameN = model.receiverName;
    String timezoneN = model.timezone + '-';
    String phoneN = model.phone;
    String nameAll = timezoneN + phoneN;

    return GestureDetector(
      onTap: () {
        controller.onSelectAddress(model);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0),
        decoration: BoxDecoration(
          color: AppStyles.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: AppStyles.textDark,
                            ),
                            children: [
                              TextSpan(
                                text: nameN,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              WidgetSpan(
                                child: 5.horizontalSpace,
                              ),
                              TextSpan(
                                text: nameAll,
                              ),
                              WidgetSpan(
                                child: model.isDefault == 1
                                    ? UnconstrainedBox(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          decoration: BoxDecoration(
                                            color: AppStyles.primary,
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                          alignment: Alignment.center,
                                          height: 15.h,
                                          child: AppText(
                                            str: '默认'.inte,
                                            fontSize: 10,
                                          ),
                                        ),
                                      )
                                    : AppGaps.empty,
                              ),
                            ],
                          ),
                        ),
                        model.addressType == 2
                            ? Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: AppText(
                                  str: model.station?.name ?? '',
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : AppGaps.empty,
                        5.verticalSpace,
                        AppText(
                          str: model.getContent(),
                          lines: 3,
                        ),
                      ],
                    ),
                  ),
                  10.horizontalSpace,
                  GestureDetector(
                    onTap: () {
                      GlobalPages.push(GlobalPages.addressAddEdit, arg: {
                        'id': model.id,
                        'isEdit': '1',
                        'addressType': model.addressType ?? 1,
                      });
                    },
                    child: LoadAssetImage(
                      'Center/edit',
                      width: 15.w,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
