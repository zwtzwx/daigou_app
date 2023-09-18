import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/shop/problem_order_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';
import 'package:jiyun_app_client/views/components/button/plain_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/goods/cart_goods_item.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';

class ProbleShopOrder extends StatefulWidget {
  const ProbleShopOrder({
    Key? key,
    required this.status,
  }) : super(key: key);
  final int status;

  @override
  State<ProbleShopOrder> createState() => _ProbleShopOrderState();
}

class _ProbleShopOrderState extends State<ProbleShopOrder> {
  int page = 0;
  int processType = 0;

  loadData({type}) async {
    page = 0;
    return await loadMoreData();
  }

  loadMoreData() async {
    var params = {'page': ++page, 'size': 10};
    if (widget.status != 0) {
      params['status'] = widget.status == 1 ? 3 : 2;
    }
    for (var i = 0; i < processList.length; i++) {
      params['tackle[$i]'] = processList[i];
    }
    var data = await ShopService.getProbleOrderList(params);
    return data;
  }

  List<int> get processList {
    List<int> value = [];

    switch (processType) {
      case 0:
        value = [0, 1];
        break;
      case 1:
        value = [2];
        break;
    }
    return value;
  }

  // 补款
  void onOrderAddtionalFee(ProblemOrderModel order) async {
    var s = await Routers.push(Routers.shopOrderPay, {'problemOrder': order});
    if (s != null) {
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'refresh'));
    }
  }

  // 咨询
  void onChat(ProblemOrderModel order) async {
    Routers.push(Routers.shopOrderChatDetail, {'consult': order.consult});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        processModelCell(),
        Expanded(
          child: ListRefresh(
            shrinkWrap: true,
            renderItem: renderItem,
            refresh: loadData,
            more: loadMoreData,
          ),
        ),
      ],
    );
  }

  Widget renderItem(int index, ProblemOrderModel model) {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...(model.problemSkus ?? []).map((shop) => CartGoodsItem(
              cartModel: shop.sku!,
              previewMode: true,
              otherWiget: model.problemType == 2
                  ? AppText(
                      str: (model.status == 1 ? '待补款'.ts : '补款成功'.ts) +
                          '：' +
                          num.parse(model.amount ?? '0')
                              .rate(needFormat: false),
                      color: model.status == 1
                          ? const Color(0xFFFFAF44)
                          : AppColors.textGrayC9,
                    )
                  : (model.problemType == 3
                      ? AppText(
                          color: model.status == 0
                              ? AppColors.textRed
                              : AppColors.textGrayC9,
                          str: (model.status == 0 ? '待退款'.ts : '退款成功'.ts) +
                              '：' +
                              num.parse(model.amount ?? '0')
                                  .rate(needFormat: false))
                      : null))),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                str: '国内运费'.ts,
                fontSize: 14,
              ),
              AppText(
                str: (model.order?.freightFee ?? 0).rate(needFormat: false),
                fontSize: 14,
                color: AppColors.textGrayC9,
              ),
            ],
          ),
          12.verticalSpace,
          AppText(
            str: '问题描述'.ts,
            fontSize: 14,
          ),
          5.verticalSpace,
          AppText(
            str: (model.problemSkus ?? []).isNotEmpty
                ? (model.problemSkus!.first.remark ?? '')
                : '',
            fontSize: 12,
            color: AppColors.textGrayC9,
            lines: 5,
          ),
          [0, 1].contains(model.status)
              ? Container(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 90.w,
                        ),
                        child: PlainButton(
                          text: '咨询',
                          textColor: AppColors.textDark,
                          borderColor: AppColors.textGrayC,
                          borderRadis: 999,
                          fontSize: 14,
                          onPressed: () {
                            onChat(model);
                          },
                        ),
                      ),
                      model.problemType == 2
                          ? Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 90.w,
                                ),
                                child: PlainButton(
                                  text: '补款',
                                  textColor: AppColors.textDark,
                                  borderColor: AppColors.primary,
                                  borderRadis: 999,
                                  fontSize: 14,
                                  onPressed: () {
                                    onOrderAddtionalFee(model);
                                  },
                                ),
                              ),
                            )
                          : AppGaps.empty,
                    ],
                  ))
              : AppGaps.empty
        ],
      ),
    );
  }

  Widget processModelCell() {
    List<String> types = ['待处理', '已处理'];
    return Container(
      height: 28.h,
      margin: EdgeInsets.only(bottom: 10.h),
      alignment: Alignment.center,
      child: UnconstrainedBox(
        child: Container(
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: types
                .asMap()
                .keys
                .map((index) => GestureDetector(
                      onTap: () {
                        if (index == processType) return;
                        setState(() {
                          processType = index;
                        });
                        ApplicationEvent.getInstance()
                            .event
                            .fire(ListRefreshEvent(type: 'refresh'));
                      },
                      child: Container(
                        height: 28.h,
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: processType == index
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: AppText(
                          str: types[index].ts,
                          fontSize: 14,
                          color: processType == index
                              ? AppColors.textDark
                              : AppColors.textGrayC9,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
