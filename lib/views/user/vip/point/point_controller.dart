import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/user_model.dart';
import 'package:huanting_shop/models/user_point_item_model.dart';
import 'package:huanting_shop/models/user_point_model.dart';
import 'package:huanting_shop/services/point_service.dart';

class IntergralLogic extends GlobalLogic {
  UserModel? userInfo;

  final userPointModel = Rxn<UserPointModel?>();
  int pageIndex = 0;
  bool isloading = false;
  List<UserPointItemModel> userPointList = [];

  @override
  onInit() {
    super.onInit();
    created();
  }

  created() async {
    userPointModel.value = await PointService.getSummary();
  }

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {"page": (++pageIndex), 'size': 20};
    var data = await PointService.getList(dic);
    return data;
  }
}
