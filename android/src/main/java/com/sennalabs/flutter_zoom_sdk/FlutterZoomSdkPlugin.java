package com.sennalabs.flutter_zoom_sdk;


import android.content.Context;
import android.content.Intent;
import android.view.View;

import androidx.annotation.NonNull;

import com.sennalabs.flutter_zoom_sdk.inmeetingfunction.customizedmeetingui.view.MeetingWindowHelper;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import us.zoom.sdk.InMeetingNotificationHandle;
import us.zoom.sdk.JoinMeetingOptions;
import us.zoom.sdk.JoinMeetingParams;
import us.zoom.sdk.MeetingService;
import us.zoom.sdk.MeetingServiceListener;
import us.zoom.sdk.MeetingStatus;
import us.zoom.sdk.StartMeetingParams;
import us.zoom.sdk.ZoomError;
import us.zoom.sdk.ZoomSDK;
import us.zoom.sdk.ZoomSDKInitParams;
import us.zoom.sdk.ZoomSDKInitializeListener;
import us.zoom.sdk.ZoomSDKRawDataMemoryMode;

/**
 * FlutterZoomSdkPlugin
 */
public class FlutterZoomSdkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    private EventChannel meetingStatusChannel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_zoom_sdk");
        channel.setMethodCallHandler(this);
        meetingStatusChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_zoom_sdk_event_stream");
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
//            Intent intent = new Intent(context, MainActivity.class);
//            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            this.context.startActivity(intent);
//            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("init")) {
            init(call, result);
        } else if (call.method.equals("join")) {
            joinMeeting(call, result);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void init(final MethodCall methodCall, final MethodChannel.Result result) {
        Map<String, String> options = methodCall.arguments();
        ZoomSDK zoomSDK = ZoomSDK.getInstance();
        if (zoomSDK.isInitialized()) {
            List<Integer> response = Arrays.asList(0, 0);
            result.success(response);
            return;
        }

        ZoomSDKInitParams initParams = new ZoomSDKInitParams();
        initParams.appKey = options.get("appKey");
        initParams.appSecret = options.get("appSecret");
        initParams.domain = options.get("domain");
        initParams.enableLog = true;
        initParams.enableGenerateDump = true;
        initParams.logSize = 5;
        initParams.videoRawDataMemoryMode = ZoomSDKRawDataMemoryMode.ZoomSDKRawDataMemoryModeStack;


        final InMeetingNotificationHandle handle = new InMeetingNotificationHandle() {

            @Override
            public boolean handleReturnToConfNotify(Context context, Intent intent) {
                intent = new Intent(context, FlutterZoomSdkPlugin.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
                if (context == null) {
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                }
                intent.setAction(InMeetingNotificationHandle.ACTION_RETURN_TO_CONF);
                assert context != null;
                context.startActivity(intent);
                return true;
            }
        };


        ZoomSDKInitializeListener listener = new ZoomSDKInitializeListener() {
            /**
             * @param errorCode {@link us.zoom.sdk.ZoomError#ZOOM_ERROR_SUCCESS} if the SDK has been initialized successfully.
             */
            @Override
            public void onZoomSDKInitializeResult(int errorCode, int internalErrorCode) {
                List<Integer> response = Arrays.asList(errorCode, internalErrorCode);

                if (errorCode != ZoomError.ZOOM_ERROR_SUCCESS) {
                    System.out.println("Failed to initialize Zoom SDK");
                    result.success(response);
                    return;
                }

                ZoomSDK zoomSDK = ZoomSDK.getInstance();
                ZoomSDK.getInstance().getMeetingSettingsHelper().enableShowMyMeetingElapseTime(true);
                ZoomSDK.getInstance().getMeetingSettingsHelper().setCustomizedNotificationData(null, handle);

                MeetingService meetingService = zoomSDK.getMeetingService();
                meetingStatusChannel.setStreamHandler(new StatusStreamHandler(meetingService, context));
                result.success(response);
            }

            @Override
            public void onZoomAuthIdentityExpired() {
            }
        };

        zoomSDK.initialize(context, listener, initParams);
    }

    public void joinMeeting(MethodCall methodCall, MethodChannel.Result result) {

        Map<String, String> options = methodCall.arguments();

        ZoomSDK zoomSDK = ZoomSDK.getInstance();

        if (!zoomSDK.isInitialized()) {
            System.out.println("Not initialized!!!!!!");
            result.success(false);
            return;
        }

        MeetingService meetingService = zoomSDK.getMeetingService();

//        JoinMeetingOptions opts = new JoinMeetingOptions();
//        opts.no_invite = false;
//        opts.no_share = parseBoolean(options, "disableShare");
//        opts.no_titlebar =  parseBoolean(options, "disableTitlebar");
//        opts.no_driving_mode = parseBoolean(options, "disableDrive");
//        opts.no_dial_in_via_phone = parseBoolean(options, "disableDialIn");
//        opts.no_disconnect_audio = parseBoolean(options, "noDisconnectAudio");
//        opts.no_audio = false;
//        boolean view_options = true;
//        if(view_options){
//            opts.meeting_views_options = MeetingViewsOptions.NO_TEXT_MEETING_ID + MeetingViewsOptions.NO_TEXT_PASSWORD;
//        }


//        Map<String, dynamic> toMap() {
//            return {
//                    'webinarToken': webinarToken,
//                    'displayName': displayName,
//                    'email': email,
//                    'password': password,
//                    'meetingNo': meetingNo,
//    };
//        }
        JoinMeetingParams params = new JoinMeetingParams();

        params.meetingNo = options.get("meetingNo");
        params.displayName = options.get("displayName");
        params.webinarToken = options.get("webinarToken");
        params.password = options.get("password");

        ZoomSDK.getInstance().getMeetingSettingsHelper().setCustomizedMeetingUIEnabled(true);
        ZoomSDK.getInstance().getSmsService().enableZoomAuthRealNameMeetingUIShown(false);
        meetingService.joinMeetingWithParams(context, params, null);
        MeetingStatus status =   meetingService.getMeetingStatus();


        System.out.println("STAUTS =>>>>>>>>>>>>" + status);

        result.success(true);
    }




    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }


}