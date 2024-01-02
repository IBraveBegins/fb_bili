import 'package:fb_bili/navigator/hi_navigator.dart';
import 'package:fb_bili/util/string_util.dart';
import 'package:fb_bili/util/toast.dart';
import 'package:fb_bili/widget/appbar.dart';
import 'package:fb_bili/widget/login_button.dart';
import 'package:fb_bili/widget/login_effect.dart';
import 'package:fb_bili/widget/login_input.dart';
import 'package:flutter/material.dart';

import '../http/core/hi_error.dart';
import '../http/dao/login_dao.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = true;
  bool loginEnable = false;
  late String userName;
  late String password;
  late String rePassword;
  late String imoocId;
  late String orderId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }),
      body: ListView(
        //自适应键盘弹起，防止遮挡
        children: [
          LoginEffect(
            protect: protect,
          ),
          LoginInput(
            "用户名",
            "请输入用户名",
            onChanged: (text) {
              userName = text;
              checkInput();
            },
          ),
          LoginInput(
            "密码",
            "请输入密码",
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
          LoginInput(
            "确认密码",
            "请再次输入密码",
            obscureText: true,
            onChanged: (text) {
              rePassword = text;
              checkInput();
            },
            focusChanged: (focus) {
              setState(() {
                protect = focus;
              });
            },
          ),
          LoginInput(
            "慕课网ID",
            "请输入你的慕课网用户ID",
            keyboardType: TextInputType.number,
            onChanged: (text) {
              imoocId = text;
              checkInput();
            },
          ),
          LoginInput(
            "课程订单号",
            "请输入课程订单号后四位",
            keyboardType: TextInputType.number,
            lineStretch: true,
            onChanged: (text) {
              orderId = text;
              checkInput();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: LoginButton(
              '注册',
              enable: loginEnable,
              onPressed: checkParams,
            ),
          )
        ],
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
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
      var result =
          await LoginDao.registration(userName, password, imoocId, orderId);
      print(result);
      if (result['code'] == 0) {
        print('注册成功');
        showToast('注册成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
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

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = '两次密码不一致';
    } else if (orderId.length != 4) {
      tips = '请输入订单号的后四位';
    }
    if (tips != null) {
      print(tips);
      return;
    }
    send();
  }
}
