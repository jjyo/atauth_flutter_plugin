
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///接口成功
const kPNSCodeSuccess = '600000';
///唤起授权页成功
const kPNSCodeLoginControllerPresentSuccess = '600001';
///唤起授权页失败
const PNSCodeLoginControllerPresentFailed = "600002";
/// 获取运营商配置信息失败
const PNSCodeGetOperatorInfoFailed = "600004";
/// 未检测到sim卡
const PNSCodeNoSIMCard = "600007";
/// 蜂窝网络未开启
const PNSCodeNoCellularNetwork = "600008";
/// 无法判运营商
const PNSCodeUnknownOperator = "600009";
/// 未知异常
const PNSCodeUnknownError = "600010";
/// 获取token失败
const PNSCodeGetTokenFailed = "600011";
/// 预取号失败
const PNSCodeGetMaskPhoneFailed = "600012";
/// 运营商维护升级，该功能不可用
const PNSCodeInterfaceDemoted = "600013";
/// 运营商维护升级，该功能已达最大调用次数
const PNSCodeInterfaceLimited = "600014";
/// 接口超时
const PNSCodeInterfaceTimeout = "600015";
/// AppID、Appkey解析失败
const PNSCodeDecodeAppInfoFailed = "600017";
/// 运营商已切换
const PNSCodeCarrierChanged = "600021";
/// 终端环境检测失败（终端不支持认证 / 终端检测参数错误）
const PNSCodeEnvCheckFail = "600025";
/// 授权页已加载时不允许调用加速或预取号接口
const PNSCodeCallPreLoginInAuthPage = "600026";

///#pragma mark - 授权页的点击事件回调码

/// 点击返回，⽤户取消一键登录
const PNSCodeLoginControllerClickCancel = "700000";
/// 点击切换按钮，⽤户取消免密登录
const PNSCodeLoginControllerClickChangeBtn = "700001";
/// 点击登录按钮事件
const PNSCodeLoginControllerClickLoginBtn = "700002";
/// 点击CheckBox事件
const PNSCodeLoginControllerClickCheckBoxBtn = "700003";
/// 点击协议富文本文字
const PNSCodeLoginControllerClickProtocol = "700004";

// const PNSErrors = {
//   PNSCodeGetOperatorInfoFailed: '获取运营商配置信息失败',
//   PNSCodeNoSIMCard: '未检测到sim卡',
//   PNSCodeNoCellularNetwork: '蜂窝网络未开启',
//   PNSCodeUnknownOperator: '无法判运营商',
//   PNSCodeUnknownError: '未知异常',
//   PNSCodeGetTokenFailed: '获取token失败',
//   PNSCodeGetMaskPhoneFailed: '预取号失败',
//   PNSCodeInterfaceDemoted: '运营商维护升级，该功能不可用',
//   PNSCodeInterfaceLimited: '运营商维护升级，该功能已达最大调用次数',
//   PNSCodeInterfaceTimeout: '接口超时',
//   PNSCodeDecodeAppInfoFailed: 'AppID、Appkey解析失败',
//   PNSCodeCarrierChanged: '运营商已切换',
//   PNSCodeEnvCheckFail: '终端环境检测失败',
//   PNSCodeCallPreLoginInAuthPage: '授权页已加载时不允许调用加速或预取号接口',
// };

class AtauthFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('atauth_flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> initATAuthSDK(
      {@required String sdkInfo,
        bool loggerEnable = false,
        bool uploadLogEnable = false}) async {
    final result =  await _channel.invokeMethod('initSDK', {
      'authSDKInfo': sdkInfo,
      "loggerEnable": loggerEnable,
      "uploadLogEnable": uploadLogEnable
    });
    return result;
  }

  /// 检查当前环境是否支持一键登录或号码认证
  static Future<String> checkSDK({
    @required PNSAuthType type,
  }) async {
    final result = await _channel.invokeMethod('checkEnvAvailable', {'type': type.name});
    return result;
  }

  /// 加速一键登录授权页弹起
  static Future<String> accelerateLoginPage({
    /// 接口超时时间，单位s，默认为3.0s
    @required double timeout,
  }) async {
    final result = await _channel.invokeMethod('accelerateLoginPage', {'timeout': timeout});
    return result;
  }

  /// 获取一键登录Token，调用该接口首先会弹起授权页，点击授权页的登录按钮获取Token
  /// !!! 这里只有获取token成功才有返回
  static Future<String> getLoginToken({
    /// 接口超时时间，单位s，默认为3.0s
    @required double timeout,
  }) async {
     final result = await _channel.invokeMethod('getLoginTokenPage', {'timeout': timeout});
  }

  /// 注销授权页，建议用此方法，对于移动卡授权页的消失会清空一些数据
  static Future<void> cancelLogin({
    /// 是否添加动画
    @required bool flag,
  }) async {
    return await _channel.invokeMethod('cancelLogin', {'flag': flag});
  }


  /// 手动隐藏一键登录获取登录Token之后的等待动画，默认为自动隐藏
  static Future<void> get hideLoginLoading async {
    return await _channel.invokeMethod('hideLoginLoading');
  }
}


enum PNSAuthType {
  PNSAuthTypeVerifyToken,  //本机号码校验
  PNSAuthTypeLoginToken //一键登录
}

extension _ExtPNSAuthType on PNSAuthType{
  get name => toString().split('.').last;
}
