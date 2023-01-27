/*
  收件地址列表
 */

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/components/search_bar.dart';
import 'package:jiyun_app_client/views/user/address/list/address_list_controller.dart';

class AddressListView extends GetView<AddressListController> {
  const AddressListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: ZHTextLine(
            str: '地址管理'.ts,
            fontSize: 18,
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: 40,
            child: MainButton(
              text: '添加地址',
              onPressed: () {
                Routers.push(Routers.addressAddEdit, {'isEdit': '0'});
              },
            ),
          ),
        ),
        backgroundColor: BaseStylesConfig.bgGray,
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
            ],
          ),
        ));
  }

  Widget searchCell() {
    return Container(
      color: Colors.white,
      child: SearchBar(
        onSearch: (value) {
          controller.keyword.value = value;
        },
        onSearchClick: (value) {
          controller.getList();
        },
        controller: controller.keywordController,
        focusNode: controller.keywordNode,
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
    // 地址拼接
    String contentStr = '';

    if (model.area != null) {
      if (model.area != null) {
        contentStr = model.countryName + ' ' + model.area!.name;
      }
      if (model.subArea != null) {
        contentStr += ' ' + model.subArea!.name;
      }
    } else {
      contentStr += model.street;
      contentStr += ' ' + model.doorNo;
      contentStr += ' ' + model.city;
      contentStr += ' ' + model.countryName;
    }

    return GestureDetector(
      onTap: () {
        controller.onSelectAddress(model);
      },
      child: Container(
        decoration: const BoxDecoration(
          color: BaseStylesConfig.white,
          border: Border(
            top: BorderSide(
              color: BaseStylesConfig.line,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().screenWidth - 60,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: ZHTextLine(
                                str: nameN,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ZHTextLine(
                              str: nameAll,
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        width: ScreenUtil().screenWidth - 60,
                        alignment: Alignment.topLeft,
                        child: ZHTextLine(
                          str: contentStr,
                          lines: 3,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Routers.push(Routers.addressAddEdit,
                          {'address': model, 'isEdit': '1'});
                    },
                    child: const ImageIcon(
                      AssetImage("assets/images/AboutMe/编辑@3x.png"),
                      color: BaseStylesConfig.textDark,
                      size: 15,
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
