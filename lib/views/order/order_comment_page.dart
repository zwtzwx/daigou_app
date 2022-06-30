import 'package:jiyun_app_client/common/fade_route.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/upload_util.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/models/comment_model.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/services/comment_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/photo_view_gallery_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
/*
  订单评价
*/

class OrderCommentPage extends StatefulWidget {
  const OrderCommentPage({Key? key, required this.arguments}) : super(key: key);
  final Map arguments;
  @override
  OrderCommentPageState createState() => OrderCommentPageState();
}

class OrderCommentPageState extends State<OrderCommentPage> {
  final TextEditingController _evaluateController = TextEditingController();
  FocusNode blankNode = FocusNode();
  String coupons = '';
  String tips = '';
  int comprehensiveStar = 0;
  int logisticsStar = 0;
  int customerStar = 0;
  int packStar = 0;
  bool isDetail = false;
  String pageTitle = '我要评价';
  late OrderModel model;
  CommentModel? commentModel;
  List<String> selectImg = [''];

  @override
  void initState() {
    super.initState();
    model = widget.arguments['order'];
    if (widget.arguments['detail'] != null) {
      isDetail = true;
      pageTitle = '我的评价';
      getCommentDetail();
    } else {
      getCommentInfo();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 评价详情
  getCommentDetail() async {
    var data = await CommentService.getDetail(model.id);
    if (data != null) {
      setState(() {
        commentModel = data;
        comprehensiveStar = data.score;
        logisticsStar = data.logisticsScore;
        customerStar = data.customerScore;
        packStar = data.packScore;
      });
    }
  }

  // 评价提示信息
  getCommentInfo() async {
    var data = await CommentService.getInfo();
    setState(() {
      tips = data;
    });
  }

  // 提交评价
  onSubmit() async {
    List<String> listImg = [];
    for (var item in selectImg) {
      if (item != '') {
        listImg.add(item);
      }
    }
    String msg = '';
    if (_evaluateController.text.isEmpty) {
      msg = '请输入您的评价内容';
    } else if (logisticsStar == 0) {
      msg = '请给我们的物流评个分吧';
    } else if (customerStar == 0) {
      msg = '请给我们的客服评个分吧';
    } else if (packStar == 0) {
      msg = '请给我们的打包评个分吧';
    }
    if (msg.isNotEmpty) {
      Util.showToast(Translation.t(context, msg));
      return;
    }
    Map<String, dynamic> dic = {
      'order_id': model.id,
      'content': _evaluateController.text,
      'score': comprehensiveStar,
      'images': listImg,
      'logistics_score': logisticsStar,
      'customer_score': customerStar,
      'pack_score': packStar,
    };
    EasyLoading.show();
    Map data = await CommentService.onComment(dic);
    EasyLoading.dismiss();
    if (data['ok']) {
      EasyLoading.showSuccess(data['msg']);
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'reset'));
      Navigator.pop(context, true);
    } else {
      EasyLoading.showError(data['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Caption(
            str: Translation.t(context, pageTitle),
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: ColorConfig.bgGray,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  topView(),
                  buildMiddleView(),
                  isDetail ? Gaps.empty : bottomView(),
                  Gaps.vGap10,
                ],
              ),
            )));
  }

  // 上传图片
  Widget uploadPhoto() {
    return Container(
        padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
        alignment: Alignment.center,
        height: (ScreenUtil().screenWidth - 60) / 4,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //设置列数
              crossAxisCount: 4,
              //设置横向间距
              crossAxisSpacing: 5,
              //设置主轴间距
              mainAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            shrinkWrap: false,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: isDetail
                ? (commentModel?.images.length ?? 0)
                : (selectImg.isEmpty ? 1 : selectImg.length),
            itemBuilder:
                isDetail ? _buildImageShowItem() : _buildGrideBtnView()));
  }

  _buildImageShowItem() {
    return (context, index) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(FadeRoute(
              page: PhotoViewGalleryScreen(
            images: commentModel?.images ?? [], //传入图片list
            index: index, //传入当前点击的图片的index
            heroTag: '', //传入当前点击的图片的hero tag （可选）
          )));
          // NinePictureAllScreenShow(model.images, index);
        },
        child: Container(
          color: ColorConfig.white,
          child: LoadImage(
            commentModel?.images[index] ?? '',
            fit: BoxFit.fitWidth,
            format: "png",
          ),
        ),
      );
    };
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    return (context, index) {
      return _buildImageItem(
          context, selectImg.isEmpty ? '' : selectImg[index], index);
    };
  }

  Widget _buildImageItem(context, String url, int index) {
    return GestureDetector(
      child: Stack(children: <Widget>[
        url.isNotEmpty
            ? Container(
                color: ColorConfig.bgGray,
                height: (ScreenUtil().screenWidth - 60 - 15) / 4,
                width: (ScreenUtil().screenWidth - 60 - 15) / 4,
                child: LoadImage(
                  url,
                  fit: BoxFit.fitWidth,
                  // holderImg: "Home/集运评价@3x",
                ),
              )
            : Container(
                alignment: Alignment.center,
                color: ColorConfig.bgGray,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.add,
                      size: 30,
                      color: ColorConfig.textGray,
                    ),
                    Caption(
                      str: Translation.t(context, '添加图片'),
                      fontSize: 10,
                    )
                  ],
                ),
              ),
        Positioned(
            top: 0,
            right: 0,
            child: url != ''
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!selectImg.contains('')) {
                          selectImg.add('');
                        }
                        selectImg.remove(url);
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: ColorConfig.textGrayC,
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: const Icon(
                        Icons.close,
                        color: ColorConfig.white,
                        size: 18,
                      ),
                    ))
                : Container()),
      ]),
      onTap: () {
        UploadUtil.imagePicker(
          onSuccessCallback: (imageUrl) {
            setState(() {
              if (selectImg.length == 3) {
                if (index == 2) {
                  selectImg.removeLast();
                  selectImg.add(imageUrl);
                } else {
                  selectImg.replaceRange(index, index + 1, [imageUrl]);
                }
              } else {
                selectImg.insert(index, imageUrl);
              }
            });
          },
          context: context,
          child: CupertinoActionSheet(
            title: Text(Translation.t(context, '请选择上传方式')),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(Translation.t(context, '相册')),
                onPressed: () {
                  Navigator.pop(context, 'gallery');
                },
              ),
              CupertinoActionSheetAction(
                child: Text(Translation.t(context, '照相机')),
                onPressed: () {
                  Navigator.pop(context, 'camera');
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(Translation.t(context, '取消')),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
          ),
        );
      },
    );
  }

  Widget bottomView() {
    return Container(
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 15,
      ),
      child: Column(
        children: <Widget>[
          tips.isNotEmpty
              ? Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    tips,
                  ),
                )
              : Gaps.empty,
          Container(
            height: 40,
            margin: const EdgeInsets.only(top: 40),
            width: double.infinity,
            child: MainButton(
              text: '提交评价',
              onPressed: onSubmit,
            ),
          ),
        ],
      ),
    );
  }

  Widget topView() {
    var headerView = Container(
        decoration: BoxDecoration(
          color: ColorConfig.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1, color: Colors.white),
        ),
        padding: const EdgeInsets.only(left: 5, right: 5),
        margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
        // height: 251 + (ScreenUtil().screenWidth - 60) / 4,
        child: Column(children: <Widget>[
          SizedBox(
            // height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                height: 20,
                                margin:
                                    const EdgeInsets.only(top: 10, left: 15),
                                alignment: Alignment.centerLeft,
                                child: Caption(
                                  str: '订单号：' + model.orderSn,
                                  fontSize: 14,
                                  color: ColorConfig.textBlack,
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    height: 30,
                                    margin:
                                        const EdgeInsets.only(top: 5, left: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Caption(
                                      str: Translation.t(context, '综合评分'),
                                      fontSize: 14,
                                      color: ColorConfig.textBlack,
                                    )),
                                Container(
                                    height: 30,
                                    margin:
                                        const EdgeInsets.only(top: 5, left: 15),
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                        children: startsSourceList(
                                            comprehensiveStar, 1))),
                              ],
                            ),
                          ],
                        )
                      ]),
                ))
              ],
            ),
          ),
          Gaps.vGap5,
          Gaps.line,
          Gaps.vGap5,
          !isDetail
              ? Container(
                  height: 150,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 8.0, bottom: 4.0),
                  child: TextField(
                    controller: _evaluateController,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    decoration: InputDecoration.collapsed(
                      hintText: Translation.t(context, '请描述您对本次集运的体验'),
                    ),
                  ),
                )
              : Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text(commentModel?.content ?? ''),
                ),
          Gaps.line,
          Gaps.vGap10,
          uploadPhoto(),
        ]));
    return headerView;
  }

  buildMiddleView() {
    var middleView = Container(
      padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
      margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
      decoration: BoxDecoration(
        color: ColorConfig.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 1, color: Colors.white),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 5, left: 0),
                      alignment: Alignment.centerLeft,
                      child: Caption(
                        str: Translation.t(context, '物流评分'),
                        fontSize: 15,
                        color: ColorConfig.textBlack,
                      )),
                  Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 5, left: 15),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: startsSourceList(logisticsStar, 2),
                      ))
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 5, left: 0),
                      alignment: Alignment.centerLeft,
                      child: Caption(
                        str: Translation.t(context, '客服评分'),
                        fontSize: 15,
                        color: ColorConfig.textBlack,
                      )),
                  Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 5, left: 15),
                      alignment: Alignment.topLeft,
                      child: Row(children: startsSourceList(customerStar, 3))),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 5, left: 0),
                      alignment: Alignment.centerLeft,
                      child: Caption(
                        str: Translation.t(context, '打包评分'),
                        fontSize: 15,
                        color: ColorConfig.textBlack,
                      )),
                  Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 5, left: 15),
                      alignment: Alignment.topLeft,
                      child: Row(children: startsSourceList(packStar, 4))),
                ],
              ),
            ],
          )
        ],
      ),
    );
    return middleView;
  }

  startsSourceList(int selectStar, int type) {
    List<Widget> startList = [];
    for (var i = 0; i < 5; i++) {
      var view = GestureDetector(
        onTap: () {
          if (isDetail) return;
          setState(() {
            switch (type) {
              case 1: // 综合评分
                comprehensiveStar = i + 1;
                break;
              case 2: // 物流评分
                logisticsStar = i + 1;
                break;
              case 3: // 客服评分
                customerStar = i + 1;
                break;
              case 4: // 打包评分
                packStar = i + 1;
                break;
              default:
            }
          });
        },
        child: Container(
            alignment: Alignment.centerLeft,
            height: 25,
            width: 25,
            padding: const EdgeInsets.all(4),
            child: selectStar > i
                ? Image.asset(
                    'assets/images/AboutMe/好评Sel@3x.png',
                  )
                : Image.asset(
                    'assets/images/AboutMe/好评Dis@3x.png',
                  )),
      );
      startList.add(view);
    }
    return startList;
  }
}
