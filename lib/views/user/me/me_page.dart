import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/user/me/me_controller.dart';

/*
  我的
*/

class MeView extends GetView<MeController> {
  const MeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: BaseStylesConfig.bgGray,
      appBar: const EmptyAppBar(),
      primary: false,
      body: RefreshIndicator(
        onRefresh: controller.created,
        color: BaseStylesConfig.textRed,
        child: Container(
          color: BaseStylesConfig.bgGray,
          child: ListView.builder(
            itemBuilder: buildCellForFirstListView,
            controller: controller.scrollController,
            itemCount: 3,
          ),
        ),
      ),
    );
  }

  Widget buildCellForFirstListView(BuildContext context, int index) {
    List<Map> list1 = [
      {
        'name': '个人信息',
        'icon': 'AboutMe/info-icon',
        'route': Routers.profile,
      },
      {
        'name': '更改手机号',
        'icon': 'AboutMe/phone-icon',
        'route': Routers.changeMobileAndEmail,
        'params': {'type': 1},
      },
      {
        'name': '更改邮箱',
        'icon': 'AboutMe/emai-icon',
        'route': Routers.changeMobileAndEmail,
        'params': {'type': 2},
      },
      {
        'name': '收货地址',
        'icon': 'AboutMe/adress-icon',
        'route': Routers.addressList,
        'params': {'select': 0},
      },
      {
        'name': '交易记录',
        'icon': 'AboutMe/pay-record-icon',
        'route': Routers.transaction,
      },
    ];
    List<Map> list2 = [
      {
        'name': '修改密码',
        'icon': 'AboutMe/password',
        'route': Routers.password,
      },
      {
        'name': '关于我们',
        'icon': 'AboutMe/about-me-icon',
        'route': Routers.abountMe,
      },
      {
        'name': '退出登录',
        'icon': 'AboutMe/logout-icon',
      },
    ];
    if (index == 1) {
      return buildListView(context, list1);
    } else if (index == 2) {
      return buildListView(context, list2);
    }
    return buildCustomViews(context);
  }

  Widget buildListView(BuildContext context, List<Map> list) {
    var listView = Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: const BoxDecoration(
        color: BaseStylesConfig.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildBottomListCell(context, list[index]),
            ),
          ),
        ],
      ),
    );
    return listView;
  }

  Widget buildBottomListCell(BuildContext context, Map item) {
    return GestureDetector(
      onTap: () async {
        if (item['route'] != null) {
          Routers.push(item['route'], item['params']);
        } else {
          var res = await BaseDialog.cupertinoConfirmDialog(
              context, '确认退出登录吗'.ts + '？');
          if (res == true) {
            controller.onLogout();
          }
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            LoadImage(
              item['icon'],
              width: 24,
              height: 24,
            ),
            Sized.hGap10,
            ZHTextLine(
              str: (item['name'] as String).ts,
              lines: 2,
              alignment: TextAlign.center,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: BaseStylesConfig.textGray,
                  size: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCustomViews(BuildContext context) {
    var headerView = Stack(
      children: [
        const LoadImage(
          'Home/bg',
          fit: BoxFit.fitWidth,
        ),
        Obx(() {
          UserModel? userModel = controller.userInfoModel.userInfo.value;
          return Positioned(
            left: 20,
            top: ScreenUtil().statusBarHeight + 40,
            child: Row(
              children: [
                ClipOval(
                  child: LoadImage(
                    userModel?.avatar ?? '',
                    fit: BoxFit.fitWidth,
                    holderImg: "AboutMe/u",
                    format: "png",
                    width: 80,
                    height: 80,
                  ),
                ),
                Sized.hGap16,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ZHTextLine(
                      str: userModel?.name ?? '',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    Sized.vGap5,
                    ZHTextLine(
                      alignment: TextAlign.center,
                      str: 'ID: ${userModel?.id ?? ''}',
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        Obx(
          () => (controller.userVipModel.value?.pointStatus == 1 ||
                  controller.userVipModel.value?.growthValueStatus == 1)
              ? Positioned(
                  left: 30,
                  right: 30,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFf3e4bb), Color(0xFFd1bb7f)],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    child: Row(
                      children: [
                        controller.userVipModel.value?.pointStatus == 1
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Routers.push(Routers.vip);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        const LoadImage(
                                          'AboutMe/V',
                                          width: 28,
                                          height: 28,
                                        ),
                                        Sized.hGap15,
                                        ZHTextLine(
                                          str: '等级'.ts,
                                          color: BaseStylesConfig.vipNormal,
                                        ),
                                        Sized.hGap15,
                                        ZHTextLine(
                                          str: controller.userVipModel.value
                                                  ?.profile.levelName ??
                                              '',
                                          fontWeight: FontWeight.bold,
                                          color: BaseStylesConfig.vipNormal,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Sized.empty,
                        controller.userVipModel.value?.growthValueStatus == 1
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Routers.push(Routers.point);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                  color: HexToColor('#f3e4ba')),
                                            ),
                                          ),
                                        ),
                                        const LoadImage(
                                          'AboutMe/jf',
                                          width: 28,
                                          height: 28,
                                        ),
                                        Sized.hGap15,
                                        ZHTextLine(
                                          str: '积分'.ts,
                                          color: BaseStylesConfig.vipNormal,
                                        ),
                                        Sized.hGap15,
                                        ZHTextLine(
                                          str:
                                              '${controller.userVipModel.value?.profile.point ?? ''}',
                                          fontWeight: FontWeight.bold,
                                          color: BaseStylesConfig.vipNormal,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Sized.empty,
                      ],
                    ),
                  ))
              : Sized.empty,
        ),
      ],
    );
    return headerView;
  }
}
