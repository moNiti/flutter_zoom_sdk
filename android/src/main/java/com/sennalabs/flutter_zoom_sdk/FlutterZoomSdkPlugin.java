package com.sennalabs.flutter_zoom_sdk;


import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.webkit.WebView;

import androidx.annotation.NonNull;

import java.util.Arrays;
import java.util.List;
import java.util.Map;


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
import us.zoom.sdk.MeetingStatus;
import us.zoom.sdk.MeetingViewsOptions;
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
    private String displayName;
    private String email;

    static public FlutterZoomSdkPlugin INSTANCE;

//    GETTER ZONE
    public String getDisplayName() {
        return displayName;
    }

    public String getEmail() {
        return email;
    }



    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_zoom_sdk");
        System.out.println("SET METHOD CHANNEL");
        channel.setMethodCallHandler(this);
        meetingStatusChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_zoom_sdk_event_stream");

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("init")) {
            init(call, result);
        } else if (call.method.equals("join")) {
            joinMeeting(call, result);
        }
        else if(call.method.equals("get_zoom_user_id")) {
            getZoomUserId(call, result);

        }else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        System.out.println("onDetachedFromEngine");
        channel.setMethodCallHandler(null);
    }

    private void init(final MethodCall methodCall, final MethodChannel.Result result) {
        Map<String, String> options = methodCall.arguments();
        ZoomSDK zoomSDK = ZoomSDK.getInstance();
        if (zoomSDK.isInitialized()) {
            List<Integer> response = Arrays.asList(0, 0);
            result.success(true);
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
                    result.success(false);
                    return;
                }


                ZoomSDK zoomSDK = ZoomSDK.getInstance();
                ZoomSDK.getInstance().getMeetingSettingsHelper().enableShowMyMeetingElapseTime(true);
                ZoomSDK.getInstance().getMeetingSettingsHelper().setCustomizedNotificationData(null, handle);

                MeetingService meetingService = zoomSDK.getMeetingService();
                meetingStatusChannel.setStreamHandler(new StatusStreamHandler(meetingService, context));
                result.success(true);
            }

            @Override
            public void onZoomAuthIdentityExpired() {
            }
        };

        zoomSDK.initialize(context, listener, initParams);
    }

    public void getZoomUserId(MethodCall methodCall, MethodChannel.Result result) {
        long myUserId = ZoomSDK.getInstance().getInMeetingService().getMyUserID();
        result.success(String.valueOf(myUserId));
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

        JoinMeetingOptions opts = new JoinMeetingOptions();
        opts.no_webinar_register_dialog = true;
        opts.webinar_token = options.get("webinarToken");
        opts.no_invite = true;
        opts.no_share = true;
        opts.no_titlebar =  true;
//        opts.no_driving_mode = parseBoolean(options, "disableDrive");
//        opts.no_dial_in_via_phone = parseBoolean(options, "disableDialIn");
//        opts.no_disconnect_audio = parseBoolean(options, "noDisconnectAudio");
//        opts.no_audio = false;
//        boolean view_options = true;
//        if(view_options){
//            opts.meeting_views_options = MeetingViewsOptions.NO_TEXT_MEETING_ID + MeetingViewsOptions.NO_TEXT_PASSWORD;
//        }

        JoinMeetingParams params = new JoinMeetingParams();

        params.meetingNo = options.get("meetingNo");
        params.displayName = options.get("displayName");
        params.webinarToken = options.get("webinarToken");
        params.password = options.get("password");



        this.displayName = options.get("displayName");
        this.email = options.get("email");



        ZoomSDK.getInstance().getMeetingSettingsHelper().setCustomizedMeetingUIEnabled(false);
        ZoomSDK.getInstance().getInMeetingService().allowParticipantsToRename(false);
        ZoomSDK.getInstance().getZoomUIService().enableMinimizeMeeting(true);
        meetingService.joinMeetingWithParams(context, params, opts);

        MeetingStatus status = meetingService.getMeetingStatus();

        System.out.println("STAUTS =>>>>>>>>>>>>" + status);

        result.success(true);
    }

    public void openVote(Context mContext) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                channel.invokeMethod("get_vote_url", null, new Result() {
                    @Override
                    public void success(Object o) {
                        String url = o.toString();
                        if (url != null && !url.isEmpty()) {
                            System.out.println("URL IS NOT EMPTY");
                            try {
                                Intent webViewIntent = new Intent(mContext, VoteWebViewActivity.class);
                                webViewIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                webViewIntent.putExtra("url", o.toString());
                                mContext.startActivity(webViewIntent);
                            } catch (Exception ex) {
                                System.out.println("EXECPTION =>>>>>>>> " + ex.toString());
                            }
                        }
                    }

                    @Override
                    public void error(String s, String s1, Object o) {
                        System.out.println("=>>>>> ERROR OCCURED" + s);
                    }

                    @Override
                    public void notImplemented() {
                        System.out.println("=>>>>> NOT IMPLEMENTED");
                    }
                });
            }
        });
    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        INSTANCE = this;
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
