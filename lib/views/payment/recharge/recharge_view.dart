import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/common/util.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/default_amount_model.dart';
import 'package:shop_app_client/models/pay_type_model.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/input/base_input.dart';
import 'package:shop_app_client/views/payment/recharge/recharge_controller.dart';

class RechargeView extends GetView<RechargeController> {
  const RechargeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: AppStyles.bgGray,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '余额'.inte,
          fontSize: 17,
        ),
      ),
      backgroundColor: AppStyles.bgGray,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        color: Colors.white,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  AppText(
                    str: '充值'.inte + '：',
                    fontSize: 14,
                  ),
                  Obx(
                    () => AppText(
                      str: controller.amount.value
                          .priceConvert(needFormat: false),
                      color: AppStyles.textRed,
                    ),
                  )
                ],
              ),
              10.horizontalSpace,
              BeeButton(
                text: '确认支付',
                onPressed: controller.onPay,
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.isloading.value >= 2
          ? GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    buildCustomViews(context),
                    Container(
                      decoration: const BoxDecoration(
                          color: AppStyles.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      margin: const EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 10),
                      padding: const EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                            child: AppText(str: '余额充值'.inte),
                          ),
                          buildMoreSupportType(context),
                          Obx(
                            () => Offstage(
                              offstage: controller.selectButton.value !=
                                  controller.defaultAmountList.length,
                              child: buildCustomPrice(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: AppStyles.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      margin: const EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 10),
                      padding: const EdgeInsets.only(
                          top: 0, left: 15, right: 15, bottom: 0),
                      child: buildListView(context),
                    ),
                  ],
                ),
              ),
            )
          : Container()),
    );
  }

  // 其它任意金额
  Widget buildCustomPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          child: AppText(str: '其它任意金额'.inte),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppStyles.primary,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: BaseInput(
            controller: controller.otherPriceController,
            focusNode: controller.otherPriceNode,
            hintText: '其它任意金额'.inte,
            isCollapsed: true,
            textInputAction: TextInputAction.done,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            autoShowRemove: false,
            autoRemoveController: false,
            onChanged: (value) {
              var rate = controller.currencyModel.value?.rate ?? 1;
              if (double.tryParse(value) != null) {
                controller.amount.value = double.parse(value) / rate;
              } else if (value.isEmpty) {
                controller.amount.value = 0;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildMoreSupportType(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10.0, //水平子Widget之间间距
        mainAxisSpacing: 5.0, //垂直子Widget之间间距
        crossAxisCount: 3, //一行的Widget数量
        childAspectRatio: 3 / 2,
      ), // 宽高比例
      itemCount: controller.defaultAmountList.length + 1,
      itemBuilder: _buildGrideBtnView(),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    return (context, index) {
      DefaultAmountModel? model;
      if (index != controller.defaultAmountList.length) {
        model = controller.defaultAmountList[index];
      }
      return GestureDetector(
        onTap: () {
          controller.selectButton.value = index;
          if (model == null) {
            controller.amount.value = 0;
          } else {
            controller.amount.value = (model.amount).toDouble();
          }
        },
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: controller.selectButton.value == index
                  ? AppStyles.primary
                  : AppStyles.bgGray,
              // color: ,
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: model != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AppText(
                        str: '{count}元'.inArgs({
                          'count': model.amount.priceConvert(
                            showPriceSymbol: false,
                            needFormat: false,
                            showInt: true,
                          )
                        }),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: controller.selectButton.value == index
                            ? Colors.white
                            : AppStyles.textBlack,
                      ),
                      model.complimentaryAmount != 0
                          ? AppText(
                              str: '送{count}元'.inArgs({
                                'count': model.complimentaryAmount.priceConvert(
                                  showPriceSymbol: false,
                                  needFormat: false,
                                  showInt: true,
                                )
                              }),
                              fontSize: 14,
                              color: controller.selectButton.value == index
                                  ? Colors.white
                                  : AppStyles.textBlack,
                            )
                          : Container(),
                    ],
                  )
                : AppText(
                    str: '其它金额'.inte,
                    fontWeight: FontWeight.w500,
                    color: controller.selectButton.value == index
                        ? Colors.white
                        : AppStyles.textBlack,
                  ),
          ),
        ),
      );
    };
  }

  Widget buildListView(BuildContext context) {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: payTypeCell,
      itemCount: controller.payTypeList.length,
    );
    return listView;
  }

  Widget payTypeCell(BuildContext context, int index) {
    PayTypeModel typeMap = controller.payTypeList[index];
    return GestureDetector(
        onTap: () {
          if (controller.selectType.contains(typeMap)) {
            return;
          } else {
            controller.selectType.clear();
            controller.selectType.add(typeMap);
          }
        },
        child: Container(
          color: AppStyles.white,
          padding: const EdgeInsets.only(right: 15, left: 15),
          height: 50,
          width: ScreenUtil().screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.only(right: 15),
                      child: typeMap.name.contains('alipay')
                          ? Image.asset(
                              'assets/images/Center/alipay.png',
                            )
                          : typeMap.name.contains('wechat')
                              ? Image.asset(
                                  'assets/images/Center/wechat_pay.png',
                                )
                              : typeMap.name.contains('balance')
                                  ? Image.asset(
                                      'assets/images/Center/balance_pay.png',
                                    )
                                  : Image.asset(
                                      'assets/images/Center/transfer.png',
                                    ),
                    ),
                    Expanded(
                      child: AppText(
                        str: BaseUtils.getPayTypeName(typeMap.name),
                        lines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              Obx(
                () => controller.selectType.contains(typeMap)
                    ? const Icon(
                        Icons.check_circle,
                        color: AppStyles.green,
                      )
                    : const Icon(Icons.radio_button_unchecked,
                        color: AppStyles.textGray),
              ),
            ],
          ),
        ));
  }

  // 支付方式

  Widget buildCustomViews(BuildContext context) {
    var headerView = SizedBox(
      height: 180,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 15, top: 70, right: 15),
            constraints: const BoxConstraints.expand(
              height: 130.0,
            ),
          ),
          Positioned(
              top: 10,
              left: 15,
              right: 15,
              bottom: 0,
              child: Container(
                  padding: const EdgeInsets.only(right: 15, top: 15, left: 15),
                  width: ScreenUtil().screenWidth - 30,
                  decoration: BoxDecoration(
                      color: AppStyles.white,
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AppText(
                              str: '账户余额'.inte,
                            ),
                            GestureDetector(
                              onTap: () {
                                GlobalPages.push(GlobalPages.rechargeHistory);
                              },
                              child: AppText(
                                str: '充值记录'.inte,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        controller.currencyModel.value?.code ??
                                            '',
                                    style: const TextStyle(
                                      color: AppStyles.textRed,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.myBalance.value
                                        .priceConvert(
                                          showPriceSymbol: false,
                                        )
                                        .split('.')
                                        .first,
                                    style: const TextStyle(
                                        color: AppStyles.textRed,
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const TextSpan(
                                    text: '.',
                                    style: TextStyle(
                                      color: AppStyles.textRed,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.myBalance.value
                                        .priceConvert(
                                          showPriceSymbol: false,
                                        )
                                        .split('.')
                                        .last,
                                    style: const TextStyle(
                                      color: AppStyles.textRed,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )))
        ],
      ),
    );
    return headerView;
  }
}
