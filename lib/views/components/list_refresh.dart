/*
  下单刷新
 */

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListRefresh extends StatefulWidget {
  final dynamic renderItem;
  final Widget? headerView;
  final Function refresh;
  final Function more;
  final IndexedWidgetBuilder? separator;
  final bool gridView;
  final bool upDataItem;
  final bool shrinkWrap;
  final bool physics;
  final String listType;
  final String noMessageTip;
  final bool isCanRemoveCell;
  final ValueChanged<List<dynamic>>? putAlldatas;

  const ListRefresh(
      {Key? key,
      required this.renderItem,
      this.headerView,
      this.gridView = false,
      this.physics = false,
      this.upDataItem = false,
      this.isCanRemoveCell = false,
      this.shrinkWrap = false,
      this.listType = 'ListView',
      this.noMessageTip = '目前还没有数据',
      required this.refresh,
      required this.more,
      this.separator,
      this.putAlldatas})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListRefreshState();
}

class _ListRefreshState extends State<ListRefresh> {
  bool _isLoading = true; // 是否正在请求数据中
  bool _hasMore = true; // 是否还有更多数据可加载
  int _deleteIndex = -1; // 待删除item索引
  int currentIndex = -1;
  final dynamic _items = [];
  final ScrollController _scrollCtrl = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _refresh({String type = ''}) async {
    if (!mounted) {
      return;
    }
    final data = await widget.refresh(type: type);
    _refreshController.resetNoData();
    if (data != null) {
      _items.clear();
      if (!mounted) {
        return;
      }
      setState(() {
        _hasMore = data != null && data["dataList"] != null;
        if (_hasMore) {
          _items.addAll(data["dataList"]);
        }
        _hasMore = data['total'] - data['pageIndex'] == 0 ? false : true;
        if (_hasMore) {
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      });
    }
    _isLoading = false;
    _refreshController.refreshCompleted();
    if (widget.upDataItem) {
      widget.putAlldatas!(_items);
    }
  }

  _more() async {
    if (!mounted) {
      return;
    }
    final data = await widget.more();
    setState(() {
      _hasMore = data["dataList"] != null;
      if (_hasMore) {
        _items.addAll(data["dataList"]);
      }
      _hasMore = data['total'] - data['pageIndex'] == 0 ? false : true;
      if (_hasMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
      if (widget.upDataItem) {
        widget.putAlldatas!(_items);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // if (widget.refresh is! Function) {
    //   throw ArgumentError("has no refresh function");
    // }
    _refresh();
    ApplicationEvent.getInstance().event.on<ListRefreshEvent>().listen((event) {
      if (event.type == 'delete') {
        if (!mounted) {
          return;
        }
        setState(() {
          _deleteIndex = event.index!;
          _items.removeAt(_deleteIndex);
        });
      } else if (event.type == 'operate') {
        setState(() {
          currentIndex = event.index!;
          _items[event.index].isRead = event.value;
        });
      } else if (event.type == 'refresh') {
        _refresh();
      } else if (event.type == 'reset') {
        _refresh(type: 'reset');
      }
    });
  }

  Widget _buildProgressIndicator() {
    return SingleChildScrollView(
        child: ConstrainedBox(
            child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                    child: Column(children: <Widget>[
                  const Opacity(
                    opacity: 1.0,
                    child: CupertinoActivityIndicator(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '加载中'.ts + '...',
                      style: TextConfig.textGray14,
                    ),
                  )
                ]))),
            constraints: const BoxConstraints(minHeight: 50)));
  }

  IndexedWidgetBuilder _itemBuilder() {
    return (context, index) {
      if (widget.renderItem is Function) {
        return widget.isCanRemoveCell
            ? Dismissible(
                key: UniqueKey(),
                onDismissed: (msd) {
                  //参数暂时没有用到，则用下划线表示
                  // widget.
                  // Scaffold.of(context).showSnackBar(
                  //     new SnackBar(content: new Text("item dismissed")));
                  // print(msd);
                  // AgentMsgList msgList = _items[index];
                  // ApiMe.deleteMessage(msgList.id, (data) {
                  //   if (data['ret'].toString() == '1') {
                  //     Util.showToast('删除信息成功');
                  //     ApplicationEvent.event
                  //         .fire(ListRefreshEvent('refresh', index));
                  //   }
                  // }, (message) {
                  //   Util.showToast(message);
                  // });
                },
                background: Container(
                    padding: const EdgeInsets.only(right: 15),
                    color: const Color(0xffff0000),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '删除'.ts,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      ],
                    )),
                // 监听
                movementDuration: const Duration(milliseconds: 100),
                child: widget.renderItem(index, _items[index]))
            : widget.renderItem(index, _items[index]);
      } else {
        throw ArgumentError("renderItem is not function");
      }
    };
  }

  Widget get _child {
    switch (widget.listType) {
      case 'GirdView':
        return GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //一行的Widget数量
              childAspectRatio: 0.8,
            ),
            itemCount: _items.length,
            itemBuilder: _itemBuilder());
      default:
        return ListView.builder(
            shrinkWrap: widget.shrinkWrap,
            physics: widget.physics
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            itemCount: _items.length,
            cacheExtent: 0,
            itemBuilder: _itemBuilder(),
            controller: _scrollCtrl);
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  Widget _empty() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 140,
          width: 140,
          child: LoadImage(
            '',
            fit: BoxFit.contain,
            holderImg: "Home/empty",
            format: "png",
          ),
        ),
        ZHTextLine(
          str: widget.noMessageTip.ts,
          color: BaseStylesConfig.textGrayC,
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: (ScrollNotification note) {
          FocusScope.of(context).requestFocus(FocusNode());
          return false;
        },
        child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: ClassicHeader(
              refreshingIcon: const CupertinoActivityIndicator(),
              height: 45.0,
              releaseText: '松开手刷新'.ts,
              refreshingText: '刷新中'.ts,
              completeText: '刷新完成'.ts,
              failedText: '刷新失败'.ts,
              idleText: '下拉刷新'.ts,
            ),
            footer: CustomFooter(
              height: _items.length < 10 ? 0 : 60,
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text(
                    '上拉加载'.ts,
                    style: TextConfig.textGray14,
                  );
                } else if (mode == LoadStatus.loading) {
                  body = _buildProgressIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text(
                    '加载失败点击重试'.ts,
                    style: TextConfig.textGray14,
                  );
                } else if (mode == LoadStatus.canLoading) {
                  body = Text(
                    '松手加载更多'.ts,
                    style: TextConfig.textGray14,
                  );
                } else {
                  body = Text(
                    '没有更多数据了'.ts,
                    style: TextConfig.textGray14,
                  );
                }

                return SizedBox(
                  height: _items.length < 10 ? 0 : 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _refresh,
            onLoading: _more,
            child: _isLoading
                ? _buildProgressIndicator()
                : (_items.length == 0 ? _empty() : _child)));
  }
}
