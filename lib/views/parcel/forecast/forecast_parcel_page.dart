import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/express_company_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/parcel/forecast/forecast_controller.dart';

/*
  包裹预报
*/
class ForecastParcelView extends GetView<ForecastController> {
  const ForecastParcelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: '包裹预报'.ts,
          fontSize: 18,
        ),
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Obx(
                    () => TextButton.icon(
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                      ),
                      onPressed: () {
                        controller.agreementBool.value =
                            !controller.agreementBool.value;
                      },
                      icon: controller.agreementBool.value
                          ? const Icon(
                              Icons.check_circle_outline,
                              color: BaseStylesConfig.green,
                            )
                          : const Icon(
                              Icons.circle_outlined,
                              color: BaseStylesConfig.textGray,
                            ),
                      label: ZHTextLine(
                        str: '我已阅读并同意'.ts,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showProtocol(context);
                    },
                    child: ZHTextLine(
                      str: '《${'转运协议'.ts}》',
                      color: HexToColor('#fe8b25'),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
                child: MainButton(
                  onPressed: controller.onSubmit,
                  text: '提交预报',
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              parcelListCell(context),
              // buildBottomListView(),
              // Sized.vGap15,
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildBottomListView() {
  //   return SizedBox(
  //     child: Column(children: buildAddServiceListView()),
  //   );
  // }

  // List<Widget> buildAddServiceListView() {
  //   List<Widget> listWidget = [];
  //   for (ValueAddedServiceModel item in valueAddedServiceList) {
  //     var listTitle = Container(
  //       decoration: BoxDecoration(
  //           color: BaseStylesConfig.white,
  //           border: Border(
  //             bottom: Divider.createBorderSide(context,
  //                 color: BaseStylesConfig.line, width: 1),
  //           )),
  //       child: ListTile(
  //         tileColor: BaseStylesConfig.white,
  //         title: SizedBox(
  //           height: 20,
  //           child: ZHTextLine(
  //             str: item.content,
  //             fontSize: 16,
  //           ),
  //         ),
  //         subtitle: SizedBox(
  //           height: 18,
  //           child: ZHTextLine(
  //             str: item.remark,
  //             fontSize: 14,
  //             color: BaseStylesConfig.textGray,
  //           ),
  //         ),
  //         trailing: Switch.adaptive(
  //           value: item.isOpen,
  //           activeColor: BaseStylesConfig.green,
  //           onChanged: (value) {
  //             setState(() {
  //               item.isOpen = value;
  //               FocusScope.of(context).requestFocus(blankNode);
  //             });
  //           },
  //         ),
  //       ),
  //     );
  //     listWidget.add(listTitle);
  //   }

  //   return listWidget;
  // }

  Widget parcelListCell(BuildContext context) {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: parcelItemCell,
      controller: controller.scrollController,
      itemCount: controller.formData.length,
    );
    return listView;
  }

  // 包裹
  Widget parcelItemCell(BuildContext context, int index) {
    // 快递单号
    TextEditingController orderNumberController = TextEditingController();
    final FocusNode orderNumber = FocusNode();
    ParcelModel model = controller.formData[index];
    if (model.expressNum != null) {
      orderNumberController.text = model.expressNum!;
    }

    return SizedBox(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // GestureDetector(
            //   onTap: () async {
            //     FocusScope.of(context).requestFocus(FocusNode());
            //     Picker(
            //       adapter: PickerDataAdapter(
            //           data: getPickerExpressCompany(
            //               controller.expressCompanyList)),
            //       cancelText: '取消'.ts,
            //       confirmText: '确认'.ts,
            //       selectedTextStyle:
            //           const TextStyle(color: Colors.blue, fontSize: 12),
            //       onCancel: () {},
            //       onConfirm: (Picker picker, List value) {
            //         model.expressName =
            //             controller.expressCompanyList[value.first].name;
            //         model.expressId =
            //             controller.expressCompanyList[value.first].id;
            //       },
            //     ).showModal(context);
            //   },
            //   child: InputTextItem(
            //       title: '快递名称'.ts,
            //       leftFlex: 2,
            //       isRequired: true,
            //       inputText: Container(
            //         alignment: Alignment.center,
            //         margin: const EdgeInsets.only(left: 11),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           children: <Widget>[
            //             Text(
            //               model.expressName ?? '请选择快递名称'.ts,
            //               style: model.expressName != null
            //                   ? TextConfig.textDark14
            //                   : TextConfig.textGray14,
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(
            //                   right: 15, top: 10, bottom: 10),
            //               child: Icon(
            //                 Icons.arrow_forward_ios,
            //                 color: model.expressName != null
            //                     ? BaseStylesConfig.textBlack
            //                     : BaseStylesConfig.textGray,
            //                 size: 18,
            //               ),
            //             ),
            //           ],
            //         ),
            //       )),
            // ),
            InputTextItem(
              title: '快递单号'.ts,
              leftFlex: 2,
              isRequired: true,
              flag: false,
              inputText: NormalInput(
                hintText: '请输入快递单号'.ts,
                contentPadding: const EdgeInsets.only(top: 17, right: 15),
                textAlign: TextAlign.right,
                controller: orderNumberController,
                focusNode: orderNumber,
                autoFocus: false,
                onChanged: (res) {
                  model.expressNum = res;
                },
                keyName: '',
              ),
            ),
          ],
        ),
      ),
    );
  }

  getPickerExpressCompany(List<ExpressCompanyModel> list) {
    List<PickerItem> data = [];
    for (var item in list) {
      var containe = PickerItem(
        text: ZHTextLine(
          fontSize: 24,
          str: item.name,
        ),
      );
      data.add(containe);
    }
    return data;
  }

  // 转运协议
  showProtocol(BuildContext context) {
    BaseDialog.normalDialog(
      context,
      title: controller.terms['title'],
      child: Flexible(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Html(data: controller.terms['content']),
          ),
        ),
      ),
    );
  }
}
