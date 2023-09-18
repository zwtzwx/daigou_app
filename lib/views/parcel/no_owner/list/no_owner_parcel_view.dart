// ignore_for_file: unnecessary_const

/*
  无人认领包裹
 */

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:jiyun_app_client/views/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/views/parcel/no_owner/list/no_owner_parcel_controller.dart';

class NoOwnerParcelView extends GetView<NoOwnerParcelController> {
  const NoOwnerParcelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: AppText(
            str: '异常件认领'.ts,
            color: AppColors.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: AppColors.bgGray,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: <Widget>[
              headerView(),
              Expanded(
                child: Container(
                  child: buildListView(context),
                ),
              )
            ],
          ),
        ));
  }

  Widget buildListView(context) {
    return ListRefresh(
      renderItem: buildCellList,
      refresh: controller.loadList,
      more: controller.loadMoreList,
      shrinkWrap: true,
    );
  }

  Widget headerView() {
    return Container(
      padding: const EdgeInsets.only(right: 5, left: 5),
      color: Colors.white,
      child: SearchBar(
        controller: controller.keywordController,
        focusNode: controller.focusNode,
        onSearch: (str) {
          // onSearch();
        },
        onSearchClick: (str) {
          controller.onSearch();
        },
      ),
    );
  }

  Widget buildCellList(int index, ParcelModel model) {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: const ImageIcon(
                  const AssetImage("assets/images/PackageAndOrder/tag.png"),
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              AppGaps.hGap5,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      AppText(
                        str: '快递单号'.ts + '：',
                        fontSize: 14,
                      ),
                      AppText(
                        str: model.expressNum ?? "",
                        fontSize: 14,
                      ),
                    ],
                  ),
                  AppGaps.vGap4,
                  AppText(
                    str: '${'入库时间'.ts}：' + (model.inStorageAt ?? ""),
                    fontSize: 13,
                    color: AppColors.textGray,
                  ),
                ],
              ),
            ],
          ),
          Flexible(
            child: MainButton(
              text: '认领',
              onPressed: () {
                controller.toDetail(model);
              },
            ),
          ),
        ],
      ),
    );
  }
}
