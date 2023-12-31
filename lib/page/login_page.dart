import 'package:fb_bili/navigator/hi_navigator.dart';
import 'package:fb_bili/util/toast.dart';
import 'package:fb_bili/widget/appbar.dart';
import 'package:fb_bili/widget/login_button.dart';
import 'package:fb_bili/widget/login_effect.dart';
import 'package:fb_bili/widget/login_input.dart';
import 'package:flutter/material.dart';

import '../http/core/hi_error.dart';
import '../http/dao/login_dao.dart';
import '../util/string_util.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = true;
  bool loginEnable = false;
  late String userName;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('密码登录', '注册', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: ListView(
        children: [
          LoginEffect(protect: protect),
          LoginInput(
            '用户名',
            '请输入用户名',
            onChanged: (text) {
              userName = text;
              checkInput();
            },
          ),
          LoginInput(
            '密码',
            '请输入密码',
            obscureText: true,
            onChanged: (text) {
              password = text;
              checkInput();
            },
            focusChanged: (focus) {
              setState(() {
                protect = focus;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: LoginButton(
              '登录',
              enable: loginEnable,
              onPressed: send,
            ),
          ),
        ],
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(userName, password);
      print(result);
      if (result['code'] == 0) {
        print('登录成功');
        showToast('登录成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }
}
