import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/default_amount_model.dart';
import 'package:jiyun_app_client/models/pay_type_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/payment/recharge/recharge_controller.dart';

class RechargeView extends GetView<RechargeController> {
  const RechargeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: BaseStylesConfig.bgGray,
        elevation: 0,
        centerTitle: true,
        title: ZHTextLine(
          str: '余额'.ts,
          fontSize: 17,
        ),
      ),
      backgroundColor: BaseStylesConfig.bgGray,
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
                  ZHTextLine(
                    str: '充值'.ts + '：',
                    fontSize: 14,
                  ),
                  Obx(
                    () => ZHTextLine(
                      str: controller.amount.value.rate(needFormat: false),
                      color: BaseStylesConfig.textRed,
                    ),
                  )
                ],
              ),
              10.horizontalSpace,
              MainButton(
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
                          color: BaseStylesConfig.white,
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
                            child: ZHTextLine(str: '余额充值'.ts),
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
                          color: BaseStylesConfig.white,
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
          child: ZHTextLine(str: '其它任意金额'.ts),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: BaseStylesConfig.primary,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: BaseInput(
            controller: controller.otherPriceController,
            focusNode: controller.otherPriceNode,
            hintText: '其它任意金额'.ts,
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
                  ? BaseStylesConfig.primary
                  : const Color(0xFFFFF9DB),
              // color: ,
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: model != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ZHTextLine(
                        str: '{count}元'.tsArgs({
                          'count': model.amount.rate(
                            showPriceSymbol: false,
                            needFormat: false,
                            showInt: true,
                          )
                        }),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: BaseStylesConfig.textBlack,
                      ),
                      model.complimentaryAmount != 0
                          ? ZHTextLine(
                              str: '送{count}元'.tsArgs({
                                'count': model.complimentaryAmount.rate(
                                  showPriceSymbol: false,
                                  needFormat: false,
                                  showInt: true,
                                )
                              }),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: BaseStylesConfig.textBlack,
                            )
                          : Container(),
                    ],
                  )
                : ZHTextLine(
                    str: '其它金额'.ts,
                    fontWeight: FontWeight.w500,
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
          color: BaseStylesConfig.white,
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
                              'assets/images/AboutMe/alipay.png',
                            )
                          : typeMap.name.contains('wechat')
                              ? Image.asset(
                                  'assets/images/AboutMe/wechat_pay.png',
                                )
                              : typeMap.name.contains('balance')
                                  ? Image.asset(
                                      'assets/images/Home/balance_pay.png',
                                    )
                                  : Image.asset(
                                      'assets/images/AboutMe/transfer.png',
                                    ),
                    ),
                    Expanded(
                      child: ZHTextLine(
                        str: Util.getPayTypeName(typeMap.name),
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
                        color: BaseStylesConfig.green,
                      )
                    : const Icon(Icons.radio_button_unchecked,
                        color: BaseStylesConfig.textGray),
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
                      color: BaseStylesConfig.white,
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ZHTextLine(
                              str: '账户余额'.ts,
                            ),
                            GestureDetector(
                              onTap: () {
                                Routers.push(Routers.rechargeHistory);
                              },
                              child: ZHTextLine(
                                str: '充值记录'.ts,
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
                                    text: controller
                                            .currencyModel.value?.symbol ??
                                        '',
                                    style: const TextStyle(
                                      color: BaseStylesConfig.textRed,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.myBalance.value
                                        .rate(
                                          showPriceSymbol: false,
                                        )
                                        .split('.')
                                        .first,
                                    style: const TextStyle(
                                        color: BaseStylesConfig.textRed,
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const TextSpan(
                                    text: '.',
                                    style: TextStyle(
                                      color: BaseStylesConfig.textRed,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.myBalance.value
                                        .rate(
                                          showPriceSymbol: false,
                                        )
                                        .split('.')
                                        .last,
                                    style: const TextStyle(
                                      color: BaseStylesConfig.textRed,
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
