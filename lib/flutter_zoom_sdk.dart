import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/init_params.dart';
import 'model/join_meeting_params.dart';

class FlutterZoomSdk {
  static final FlutterZoomSdk _flutterZoomSdk = FlutterZoomSdk._internal();

  factory FlutterZoomSdk() {
    return _flutterZoomSdk;
  }
  FlutterZoomSdk._internal();

  final MethodChannel _channel = const MethodChannel('flutter_zoom_sdk');
  final EventChannel _eventChannel =
      const EventChannel('flutter_zoom_sdk_event_stream');

  String? _voteUrl;
  String? get voteUrl => _voteUrl;
  set setVoteUrl(String? url) {
    _voteUrl = url;
  }

  // static const MethodChannel _channel = MethodChannel('flutter_zoom_sdk')
  //   ..setMethodCallHandler((call) => null);
  // static const EventChannel _eventChannel =
  //     EventChannel('flutter_zoom_sdk_event_stream');

  Future<dynamic> initZoom(InitParams initParams) async {
    await _channel.invokeMethod('init', initParams.toMap());
  }

  Future<bool> joinMeeting(JoinMeetingParams joinParams) async {
    return _channel
        .invokeMethod<bool>('join', joinParams.toMap())
        .then<bool>((bool? value) => value ?? false);
  }

  Future<int?> getZoomUserId() async {
    return await _channel.invokeMethod("get_zoom_user_id");
  }

  Stream<dynamic> onMeetingStatus() {
    return _eventChannel.receiveBroadcastStream();
  }

  Future<dynamic> handlePlatformChannelMethods() async {
    debugPrint('CALL handlePlatformChannelMethods');
    _channel.setMethodCallHandler((call) async {
      debugPrint('CALL setMethodCallHandler');

      if (call.method == 'get_vote_url') {
        debugPrint('IN FLUTTER => CALL => GET VOTE URL');
        return voteUrl;
      } else {
        throw MissingPluginException();
      }
    });
  }
}
