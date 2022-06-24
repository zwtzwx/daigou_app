import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/share_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'dart:convert';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
/*
  分享界面
*/

class SharePage extends StatefulWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  ShareInfoPageState createState() => ShareInfoPageState();
}

class ShareInfoPageState extends State<SharePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _globalKey = GlobalKey();
  String pageTitle = '';
  late ShareModel shareModel;
  @override
  void initState() {
    super.initState();
    pageTitle = '我要分享';
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getShareData();
    });
  }

  // 获取顶部 banner 图
  getShareData() async {
    await UserService.getShareInfo({}, (data) {
      if (data.ret) {
        var data1 = ShareModel.fromJson(data.data);
        setState(() {
          shareModel = data1;
        });
      }
    }, (message) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: Caption(
          str: Translation.t(context, pageTitle),
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: ColorConfig.bgGray,
      body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(top: 0, bottom: 25),
              color: HexToColor('#FEC6A7'),
              width: ScreenUtil().screenWidth,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: ScreenUtil().screenWidth,
                    child: const LoadImage(
                      '',
                      fit: BoxFit.fitWidth,
                      holderImg: "Home/ShareFirst@3x",
                      format: "png",
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 40, left: 40),
                    width: ScreenUtil().screenWidth,
                    child: const LoadImage(
                      '',
                      fit: BoxFit.fitWidth,
                      holderImg: "Home/报名标题@3x",
                      format: "png",
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20, left: 20, top: 15),
                    width: ScreenUtil().screenWidth,
                    child: const LoadImage(
                      '',
                      fit: BoxFit.fitWidth,
                      holderImg: "Home/ShareMiddle@3x",
                      format: "png",
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(right: 0, left: 0, top: 15),
                      width: ScreenUtil().screenWidth,
                      height: 200,
                      child: Container(
                          decoration: BoxDecoration(
                              color: HexToColor('#FFF6EF'),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          margin: const EdgeInsets.only(
                              right: 20, left: 20, top: 15),
                          width: ScreenUtil().screenWidth - 40,
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: const EdgeInsets.only(
                                right: 10, left: 10, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () {
                                      _share();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: HexToColor('#F8D7B8'),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      height: ScreenUtil().screenWidth / 2.7,
                                      width: ScreenUtil().screenWidth / 2.7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                color: HexToColor('#FFF6EF'),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10))),
                                            height:
                                                ScreenUtil().screenWidth / 4.5,
                                            width:
                                                ScreenUtil().screenWidth / 4.5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Caption(
                                                  str: Translation.t(
                                                      context, '微信分享'),
                                                  color: HexToColor('#9A571E'),
                                                ),
                                                Gaps.vGap4,
                                                SizedBox(
                                                  height:
                                                      ScreenUtil().screenWidth /
                                                          10,
                                                  width:
                                                      ScreenUtil().screenWidth /
                                                          10,
                                                  child: Image.asset(
                                                    'assets/images/Home/WeChat@3x.png',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Gaps.vGap10,
                                          Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    HexToColor('#FC8E27'),
                                                    HexToColor('#FFB26A'),
                                                  ],
                                                  //渐变角度
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            width:
                                                ScreenUtil().screenWidth / 4.5,
                                            padding: const EdgeInsets.only(
                                                top: 3, bottom: 3),
                                            child: Caption(
                                              str: Translation.t(
                                                  context, '点击分享'),
                                              fontSize: 14,
                                              color: ColorConfig.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                GestureDetector(
                                    onTap: () async {
                                      PermissionStatus storageStatus =
                                          await Permission.storage.status;
                                      if (storageStatus !=
                                          PermissionStatus.granted) {
                                        storageStatus =
                                            await Permission.storage.request();
                                        if (storageStatus !=
                                            PermissionStatus.granted) {
                                          throw Translation.t(
                                              context, '无法存储图片，请先授权！');
                                        }
                                      }
                                      generatePoster();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: HexToColor('#F8D7B8'),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      height: ScreenUtil().screenWidth / 2.7,
                                      width: ScreenUtil().screenWidth / 2.7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                color: HexToColor('#FFF6EF'),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10))),
                                            height:
                                                ScreenUtil().screenWidth / 4.5,
                                            width:
                                                ScreenUtil().screenWidth / 4.5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Caption(
                                                  str: Translation.t(
                                                      context, '海报分享'),
                                                  color: HexToColor('#9A571E'),
                                                ),
                                                Gaps.vGap4,
                                                SizedBox(
                                                  height:
                                                      ScreenUtil().screenWidth /
                                                          10,
                                                  width:
                                                      ScreenUtil().screenWidth /
                                                          10,
                                                  child: Image.asset(
                                                    'assets/images/Home/Album@3x.png',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Gaps.vGap10,
                                          Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    HexToColor('#FC8E27'),
                                                    HexToColor('#FFB26A'),
                                                  ],
                                                  //渐变角度
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            width:
                                                ScreenUtil().screenWidth / 4.5,
                                            padding: const EdgeInsets.only(
                                                top: 3, bottom: 3),
                                            child: Caption(
                                              str: Translation.t(
                                                  context, '点击生成'),
                                              fontSize: 14,
                                              color: ColorConfig.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          )))
                ],
              ))),
    );
  }

  // 分享
  void _share() {
    var model = WeChatShareMiniProgramModel(
        miniProgramType: WXMiniProgramType.RELEASE,
        webPageUrl: 'https://beegoplus.com/',
        userName: 'gh_e9afa1eee63a',
        title: 'BeeGoPlus集运',
        path: '/pages/index/index',
        description: '_description',
        thumbnail: WeChatImage.network(shareModel.shareImg));
    shareToWeChat(model);
  }

  /*
    生成海报
   */
  generatePoster() async {
    //Future类型,then或者await获取
    String imgStr = shareModel.qrCode.split(',')[1];
    Uint8List bytes = const Base64Decoder().convert(imgStr);
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, 'guanbi');
                    },
                    child: Container(
                        height: ScreenUtil().screenHeight,
                        width: ScreenUtil().screenWidth,
                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, 'guanbi');
                                },
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.centerRight,
                                  width: ScreenUtil().screenWidth,
                                  margin:
                                      const EdgeInsets.only(top: 25, right: 40),
                                  child: const Icon(
                                    Icons.highlight_off,
                                    color: ColorConfig.white,
                                    size: 30,
                                  ),
                                )),
                            Container(
                                color: ColorConfig.bgGray,
                                margin: const EdgeInsets.only(
                                    top: 0, right: 40, left: 40, bottom: 10),
                                child: RepaintBoundary(
                                    key: _globalKey,
                                    child: Stack(children: [
                                      Container(
                                        color: ColorConfig.white,
                                        margin: const EdgeInsets.only(
                                            top: 0, bottom: 0),
                                        child: LoadImage(
                                          shareModel
                                              .info!.backgroundImages.first,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      Positioned(
                                          top: ScreenUtil().screenHeight *
                                                  1 /
                                                  2 -
                                              20,
                                          bottom: 19,
                                          left: 50,
                                          right: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: SizedBox(
                                                      height: 60,
                                                      width: 60,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: Image.memory(
                                                          bytes,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ))),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Caption(
                                                  str: Translation.t(
                                                      context, '长按识别小程序'),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          )),
                                    ]))),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, 'guanbi');
                                },
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          HexToColor('#FF8038'),
                                          HexToColor('#E23112'),
                                        ],
                                        //渐变角度
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  alignment: Alignment.center,
                                  child: TextButton.icon(
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.transparent),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, 'save');
                                      },
                                      icon: Image.asset(
                                        'assets/images/Home/保存到相册@3x.png',
                                      ),
                                      label: Caption(
                                        str: Translation.t(context, '保存'),
                                        color: ColorConfig.white,
                                      )),
                                )),
                          ],
                        )))),
          );
        }).then((value) {
      if (value == 'save') {
        storePoster();
      }
    });
  }

  /*
    保存海报到本地
   */
  storePoster() async {
    // Map<Permission, PermissionStatus> permissions =
    await [
      Permission.storage,
    ].request();
    var isDenied = await Permission.storage.isDenied;
    // var isGranted = await Permission.storage.isGranted;
    if (isDenied) {
      openAppSettings();
    } else {
      try {
        // print('inside');
        final RenderRepaintBoundary boundary = _globalKey.currentContext!
            .findRenderObject()! as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();
        // void _saveImage() async {
        EasyLoading.show();
        final result = await ImageGallerySaver.saveImage(pngBytes);
        // print('result:$result');
        EasyLoading.dismiss();
        if (result['isSuccess']) {
          Util.showToast(Translation.t(context, '保存成功'));
        } else {
          Util.showToast(Translation.t(context, '保存失败'));
        }
        // }
      } catch (e) {
        // ui
      }
    }
  }
}
