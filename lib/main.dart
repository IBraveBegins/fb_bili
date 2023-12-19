import 'package:fb_bili/db/hi_cache.dart';
import 'package:fb_bili/http/core/hi_error.dart';
import 'package:fb_bili/http/core/hi_net.dart';
import 'package:fb_bili/http/dao/login_dao.dart';
import 'package:fb_bili/http/request/notice_request.dart';
import 'package:fb_bili/http/request/test_request.dart';
import 'package:fb_bili/page/registration_page.dart';
import 'package:fb_bili/util/color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: RegistrationPage(
        onJumpToLogin: () {},
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    HiCache.preInit();
  }

  void _incrementCounter() async {
    // TestRequest request = TestRequest();
    // request.add("aaaa", "111").add("bb", "33").add("requestPrams", "111");
    // try {
    //   var result = await HiNet.getInstance().fire(request);
    //   print(result);
    // } on NeedAuth catch (e) {
    //   print(e);
    // } on NeedLogin catch (e) {
    //   print(e);
    // } on HiNetError catch (e) {
    //   print(e);
    // }
    // HiCache.getInstance().setString("aaa", "value");
    // var value = HiCache.getInstance().get("aaa");
    // print('value:$value');
    // test();
    testNotice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void test() async {
    try {
      // var result =
      //     await LoginDao.registration('ibrave', '123456', '7060303', '1560');
      var result2 = await LoginDao.login('ibrave', '123456');
      print(result2);
    } on NeedAuth catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void testNotice() async {
    try {
      var notice = await HiNet.getInstance().fire(NoticeRequest());
      print(notice);
    } on NeedLogin catch (e) {
      print(e);
    } on NeedAuth catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e.message);
    }
  }
}
