import 'package:fb_bili/db/hi_cache.dart';
import 'package:fb_bili/http/core/hi_error.dart';
import 'package:fb_bili/http/core/hi_net.dart';
import 'package:fb_bili/http/dao/login_dao.dart';
import 'package:fb_bili/http/request/notice_request.dart';
import 'package:fb_bili/http/request/test_request.dart';
import 'package:fb_bili/model/video_model.dart';
import 'package:fb_bili/navigator/hi_navigator.dart';
import 'package:fb_bili/page/home_page.dart';
import 'package:fb_bili/page/login_page.dart';
import 'package:fb_bili/page/registration_page.dart';
import 'package:fb_bili/page/video_detail_page.dart';
import 'package:fb_bili/util/color.dart';
import 'package:fb_bili/util/toast.dart';
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
    return FutureBuilder<HiCache>(
        //进行初始化
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          //定义route
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _routeDelegate)
              : const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          return MaterialApp(
            home: widget,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
              useMaterial3: true,
            ),
          );
        });
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  //为Navigator设置一个key，必要的时候可以通过navigatorKey.currentState来获取到NavigatorState对象
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    //实现路由跳转逻辑
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        videoModel = args!['videoMo'];
      }
      notifyListeners();
    }));
  }
  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      //要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      //tips 具体规则可以根据需要进行调整，这里要求栈中只允许有一个同样的页面的实例
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      //跳转首页时将栈中其它页面进行出栈，因为首页不可回退
      pages.clear();
      page = pagerWrap(const HomePage());
    } else if (routeStatus == RouteStatus.detail) {
      page = pagerWrap(VideoDetailPage(videoModel!));
    } else if (routeStatus == RouteStatus.registration) {
      page = pagerWrap(const RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pagerWrap(LoginPage());
    }
    //重新创建一个数组，否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];
    pages = tempPages;
    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            if (route.settings is MaterialPage) {
              //登录页未登录返回拦截
              if ((route.settings as MaterialPage).child is LoginPage) {
                if (!hasLogin) {
                  showWarnToast("请先登录");
                  return false;
                }
              }
            }
            //执行返回操作
            if (!route.didPop(result)) {
              return false;
            }
            pages.removeLast();
            return true;
          },
        ),
        //fix Android物理返回键，无法返回上一页问题@https://github.com/flutter/flutter/issues/66349
        onWillPop: () async => !await navigatorKey.currentState!.maybePop());
  }

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {}
}

///定义路有数据path
class BiliRoutePath {
  final String location;
  BiliRoutePath.home() : location = "/";
  BiliRoutePath.detail() : location = "/detail";
}
