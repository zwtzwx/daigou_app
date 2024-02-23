import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/common/upload_util.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/rate_convert.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/models/warehouse_model.dart';
import 'package:huanting_shop/services/shop_service.dart';
import 'package:huanting_shop/services/warehouse_service.dart';
import 'package:huanting_shop/views/components/caption.dart';

class ManualOrderController extends GlobalLogic {
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
  }

  // 上传图片
  void onImgUpload(BuildContext context) {
    ImageUpload.imagePicker(
      onSuccessCallback: (imageUrl) async {
        imgs.add(imageUrl);
      },
      context: context,
      child: CupertinoActionSheet(
        title: Text('请选择上传方式'.ts),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('相册'.ts),
            onPressed: () {
              Navigator.pop(context, 'gallery');
            },
          ),
          CupertinoActionSheetAction(
            child: Text('照相机'.ts),
            onPressed: () {
              Navigator.pop(context, 'camera');
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('取消'.ts),
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
      'freight_fee': 0,
    };
    showLoading();
    var data = await ShopService.addCustomToCart(params);
    hideLoading();
    if (data != null) {
      showSuccess(data);
      Get.find<AppStore>().getCartCount();
      BeeNav.pop();
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
      cancelText: '取消'.ts,
      confirmText: '确认'.ts,
      selectedTextStyle:
          const TextStyle(color: AppColors.primary, fontSize: 12),
      onCancel: () {},
      onConfirm: (Picker picker, List value) {
        warehouse.value = warehouseList[value.first];
      },
    ).showModal(context);
  }
}
