import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/user_model.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/list_refresh.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/user/agent/agent_member/controller.dart';

class AgentMemberPage extends GetView<AgentMemberController> {
  const AgentMemberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: controller.promotionType == 1 ? '已注册好友'.ts : '已下单好友'.ts,
          fontSize: 17,
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: RefreshView(
            renderItem: buildAgentUserView,
            refresh: controller.loadData,
            more: controller.loadMoreData),
      ),
    );
  }

  Widget buildAgentUserView(int index, UserModel model) {
    return Container(
        margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          children: [
            ClipOval(
              child: ImgItem(
                model.avatar,
                width: 54.w,
                height: 54.w,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(
                    str: model.name,
                    fontSize: 16,
                  ),
                  5.verticalSpaceFromWidth,
                  AppText(
                    str: '注册时间'.ts + '  ' + model.createdAt,
                    fontSize: 12,
                    color: AppColors.textNormal,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
