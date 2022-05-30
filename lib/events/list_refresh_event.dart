//是否刷新列表
class ListRefreshEvent {
  late String type;
  String? field;
  dynamic value;
  int? index;
  ListRefreshEvent(
      {required this.type, this.field, this.value, this.index = -1});
}
