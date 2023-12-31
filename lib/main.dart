import 'package:fb_bili/db/hi_cache.dart';
import 'package:fb_bili/http/core/hi_error.dart';
import 'package:fb_bili/http/core/hi_net.dart';
import 'package:fb_bili/http/dao/login_dao.dart';
import 'package:fb_bili/http/request/notice_request.dart';
import 'package:fb_bili/http/request/test_request.dart';
import 'package:fb_bili/model/video_model.dart';
import 'package:fb_bili/page/home_page.dart';
import 'package:fb_bili/page/login_page.dart';
import 'package:fb_bili/page/registration_page.dart';
import 'package:fb_bili/page/video_detail_page.dart';
import 'package:fb_bili/util/color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BillApp());
}

class BillApp extends StatefulWidget {
  const BillApp({super.key});

  @override
  State<BillApp> createState() => _BillAppState();
}

class _BillAppState extends State<BillApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();
  @override
  Widget build(BuildContext context) {
    //定义route
    var widget = Router(routerDelegate: _routeDelegate);
    return MaterialApp(
      home: widget,
    );
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  //为Navigator设置一个key，必要的时候可以通过navigatorKey.currentState来获取到NavigatorState对象
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  List<MaterialPage> pages = [];
  VideoModel? videoModel;
  BiliRoutePath? path;
  @override
  Widget build(BuildContext context) {
    //构建路由栈
    pages = [
      pagerWrap(HomePage(
        onJumpToDetail: (videoModel) {
          this.videoModel = videoModel;
          notifyListeners();
        },
      )),
      if (videoModel != null) pagerWrap(VideoDetailPage(videoModel!))
    ];
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        //在这里控制是否可以返回
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {
    this.path = path;
  }
}

///定义路有数据path
class BiliRoutePath {
  final String location;
  BiliRoutePath.home() : location = "/";
  BiliRoutePath.detail() : location = "/detail";
}

///创建页面
pagerWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}
