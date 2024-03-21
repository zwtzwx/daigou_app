import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/common/upload_util.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/models/warehouse_model.dart';
import 'package:shop_app_client/services/shop_service.dart';
import 'package:shop_app_client/services/warehouse_service.dart';
import 'package:shop_app_client/views/components/caption.dart';

class ManualOrderController extends GlobalController {
  final TextEditingController linkController = TextEditingController();
  final FocusNode linkNode = FocusNode();
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameNode = FocusNode();
  final TextEditingController platformController = TextEditingController();
  final FocusNode qtyNode = FocusNode();
  final TextEditingController qtyController = TextEditingController(text: '1');
  final FocusNode platformNode = FocusNode();
  final TextEditingController specController = TextEditingController();
  final FocusNode specNode = FocusNode();
  final TextEditingController remarkController = TextEditingController();
  final FocusNode remarkNode = FocusNode();
  final TextEditingController priceController = TextEditingController();
  final FocusNode priceNode = FocusNode();
  final TextEditingController feeController = TextEditingController();
  final FocusNode feeNode = FocusNode();
  final Rx<String> reduce = '1'.obs;

  final warehouse = Rxn<WareHouseModel?>();
  List<WareHouseModel> warehouseList = [];
  final imgs = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getWarehouse();
  }

  @override
  void onClose() {
    linkNode.dispose();
    nameNode.dispose();
    platformNode.dispose();
    specNode.dispose();
    remarkNode.dispose();
    priceNode.dispose();
    // freightNode.dispose();
    qtyNode.dispose();
    super.onClose();
  }

  void getWarehouse() async {
    var data = await WarehouseService.getSimpleList();
    warehouseList = data;
    if (data.isNotEmpty) {
      warehouse.value = data.first;
    }
  }

  void onQty(int step) {
    var qty = num.parse(qtyController.text);
    if (step < 0 && qty <= 1) return;
    qty += step;
    qtyController.text = qty.toString();
    reduce.value = qtyController.text;
  }

  // 上传图片
  void onImgUpload(BuildContext context) {
    ImagePickers.imagePicker(
      onSuccessCallback: (imageUrl) async {
        imgs.add(imageUrl);
      },
      context: context,
      child: CupertinoActionSheet(
        title: Text('请选择上传方式'.inte),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('相册'.inte),
            onPressed: () {
              Navigator.pop(context, 'gallery');
            },
          ),
          CupertinoActionSheetAction(
            child: Text('照相机'.inte),
            onPressed: () {
              Navigator.pop(context, 'camera');
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('取消'.inte),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }

  // 提交
  void onConfirm() async {
    String? msg;
    if (warehouse.value == null) {
      msg = '请选择仓库';
    } else if (linkController.text.isEmpty) {
      msg = '请填写商品链接';
    } else if (platformController.text.isEmpty) {
      msg = '请填写平台';
    } else if (nameController.text.isEmpty) {
      msg = '请填写商品名称';
    } else if (priceController.text.isEmpty) {
      msg = '请填写商品单价';
    }else if (feeController.text.isEmpty) {
      msg = '请填写国内运费';
    }else if (imgs.isEmpty) {
      msg = '请上传商品图片';
    }
    if (msg != null) {
      showToast(msg);
      return;
    }
    Map<String, dynamic> params = {
      'warehouse_id': warehouse.value?.id ?? '',
      'platform': platformController.text,
      'platform_url': linkController.text,
      'name': nameController.text,
      'price': num.parse(priceController.text).originPrice,
      'quantity': num.parse(qtyController.text),
      'amount': num.parse(priceController.text) * num.parse(qtyController.text),
      'remark': remarkController.text,
      'freight_fee':feeController.text,
      'sku_info': {
        'imgs': imgs,
        'specs': [
          {
            'label': '规格',
            'value': specController.text,
          },
        ],
        'sku_img': imgs.isNotEmpty ? imgs.first : '',
        'shop_name': platformController.text,
        'shop_id': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    };
    showLoading();
    var data = await ShopService.addCustomToCart(params);
    hideLoading();
    if (data != null) {
      showSuccess(data);
      Get.find<AppStore>().getCartCount();
      GlobalPages.pop();
    }
  }

  void onShowWarehousePicker(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    Picker(
      height: 200.h,
      adapter: PickerDataAdapter(
          data: warehouseList
              .map(
                (e) => PickerItem(
                  text: AppText(
                    fontSize: 20.sp,
                    str: e.warehouseName ?? '',
                  ),
                ),
              )
              .toList()),
      cancelText: '取消'.inte,
      confirmText: '确认'.inte,
      selectedTextStyle:
          const TextStyle(color: AppStyles.primary, fontSize: 12),
      onCancel: () {},
      onConfirm: (Picker picker, List value) {
        warehouse.value = warehouseList[value.first];
      },
    ).showModal(context);
  }
}
