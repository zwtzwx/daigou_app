import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/shop/shop_order_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/goods/cart_goods_item.dart';

class BeeShopOrder extends StatelessWidget {
  const BeeShopOrder({
    Key? key,
    required this.model,
    this.onCancel,
    this.onPay,
  }) : super(key: key);
  final ShopOrderModel model;
  final Function? onPay;
  final Function? onCancel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BeeNav.push(BeeNav.shopOrderDetail, {'id': model.id});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: model.skus!
                    .map(
                      (e) => BeeShopOrderGoodsItem(
                        previewMode: true,
                        cartModel: e,
                        orderStatusName: model.statusName,
                        goodsToDetail: false,
                      ),
                    )
                    .toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        str: '国内运费'.ts,
                        fontSize: 14,
                      ),
                      AppText(
                        str: (model.freightFee ?? 0).rate(needFormat: false),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        str: '服务费'.ts,
                        fontSize: 14,
                      ),
                      AppText(
                        str: (model.serviceFee ?? 0).rate(needFormat: false),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        str: '总金额'.ts,
                        fontSize: 14,
                      ),
                      AppText(
                        str: (model.amount ?? 0).rate(needFormat: false),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textRed,
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      model.status == 0
                          ? ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: ScreenUtil().setWidth(85),
                              ),
                              child: HollowButton(
                                text: '取消订单',
                                borderRadis: 999,
                                fontSize: 14,
                                borderColor: AppColors.textGrayC,
                                textColor: AppColors.textNormal,
                                onPressed: () {
                                  onCancel!();
                                  // orderCancel(
                                  //     context: context,
                                  //     orderId: model.id,
                                  //     onSuccess: () {
                                  //       ApplicationEvent.getInstance()
                                  //           .event
                                  //           .fire(ListRefreshEvent(
                                  //               type: 'refresh'));
                                  //     });
                                },
                              ),
                            )
                          : AppGaps.empty,
                      10.horizontalSpace,
                      model.status == 0
                          ? ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: ScreenUtil().setWidth(85),
                              ),
                              child: BeeButton(
                                text: '立即支付',
                                borderRadis: 999,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                onPressed: () {
                                  onPay!();
                                  // orderPay(
                                  //     context: context,
                                  //     orderId: model.id,
                                  //     onSuccess: () {
                                  //       ApplicationEvent.getInstance()
                                  //           .event
                                  //           .fire(ListRefreshEvent(
                                  //               type: 'refresh'));
                                  //     });
                                },
                              ),
                            )
                          : AppGaps.empty,
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
