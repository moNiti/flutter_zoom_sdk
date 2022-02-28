import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_zoom_sdk/flutter_zoom_sdk.dart';
import 'package:flutter_zoom_sdk/model/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await FlutterZoomSdk().handlePlatformChannelMethods();
  bool? result = await FlutterZoomSdk().initZoom(InitParams(
      appKey: dotenv.env['ZOOM_KEY']!,
      appSecret: dotenv.env['ZOOM_SECRET']!,
      domain: dotenv.env['ZOOM_DOMAIN']!));
  FlutterZoomSdk().onMeetingStatus().listen((status) {
    print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
  });
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    print("FLUTTER HERE");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  debugPrint('START ON PRESS');
                  debugPrint('START SET URL');
                  // await Future.delayed(Duration(seconds: 3));
                  FlutterZoomSdk().setVoteUrl = "https://www.google.com";
                  // await Future.delayed(Duration(seconds: 2));
                  debugPrint('SUCCESS SET VOTE URL');
                  debugPrint('START OPEN NATIVE VIEW');

                  try {
                    dynamic result =
                        await FlutterZoomSdk().joinMeeting(JoinMeetingParams(
                      displayName: "885/822 นิติ",
                      meetingNo: "99085112262",
                      email: "fah@sennalabs.com",
                      password: "902362",
                      webinarToken:
                          "dPfF8dvAuOOywG2lIZwxtLdNwsX67816PtVE7V1Ajts.DQMAAAAXDeranhZXamtwb0dlOVR5MkZBY0dsNjNGdDJBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                    ));
                    print(result);
                  } catch (ex) {
                    print("ex $ex");
                  }
                },
                child: Text("JOIN MEETING"))
          ],
        ),
      ),
    );
  }
}
