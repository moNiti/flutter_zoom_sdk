package com.sennalabs.flutter_zoom_sdk;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import us.zoom.sdk.InMeetingEventHandler;
import us.zoom.sdk.InMeetingService;
import us.zoom.sdk.MeetingActivity;
import us.zoom.sdk.MeetingStatus;
import us.zoom.sdk.SimpleZoomUIDelegate;
import us.zoom.sdk.ZoomSDK;
import com.sennalabs.flutter_zoom_sdk.inmeetingfunction.customizedmeetingui.other.MeetingCommonCallback;
import com.sennalabs.flutter_zoom_sdk.inmeetingfunction.customizedmeetingui.view.MeetingOptionBar;


public class MyMeetingActivity extends MeetingActivity implements MeetingCommonCallback.CommonEvent, View.OnClickListener  {
    View mTopBar;
    private View mBtnLeave;

    MeetingOptionBar.MeetingOptionBarCallBack mCallBack;
    private InMeetingService mInMeetingService;


    @Override
    protected int getLayout() {
        return R.layout.my_custom_meeting_layout;
    }

    @Override
    protected boolean isAlwaysFullScreen() {
        return false;
    }

    @Override
    protected boolean isSensorOrientationEnabled() {
        return false;
    }

    @Override
    public void onToolbarVisibilityChanged(boolean b) {
        super.onToolbarVisibilityChanged(b);
        if(mTopBar != null) {
            if(b) {
                mTopBar.setVisibility(View.VISIBLE);
            }else {
                mTopBar.setVisibility(View.GONE);
            }
        }

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        unRegisterListener();
    }

    @Override
    protected void onResume() {
        super.onResume();
        ZoomSDK.getInstance().getZoomUIService().setZoomUIDelegate(new SimpleZoomUIDelegate() {
            @Override
            public void afterMeetingMinimized(Activity activity) {
                super.afterMeetingMinimized(activity);
                finish();
            }
        });
    }

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        registerListener();

        mTopBar = findViewById(R.id.top_bar);
        mTopBar.setVisibility(View.GONE);

        mBtnLeave = findViewById(R.id.btnLeaveZoomMeeting);
        mBtnLeave.setOnClickListener(this);

        mInMeetingService = ZoomSDK.getInstance().getInMeetingService();
    }

    private void unRegisterListener() {
        try {
            MeetingCommonCallback.getInstance().removeListener(this);
        } catch (Exception e) {
        }
    }


    private void registerListener() {
        MeetingCommonCallback.getInstance().addListener(this);
    }


    @Override
    public void onWebinarNeedRegister(String registerUrl) {
        System.out.println("=>>>>> onWebinarNeedRegister");
    }

    @Override
    public void onMeetingFail(int errorCode, int internalErrorCode) {
        System.out.println("=>>>>> onMeetingFail");

    }

    @Override
    public void onMeetingLeaveComplete(long ret) {
        System.out.println("=>>>>> onMeetingLeaveComplete");
    }

    @Override
    public void onMeetingStatusChanged(MeetingStatus meetingStatus, int errorCode, int internalErrorCode) {
        System.out.println("=>>>>> onMeetingStatusChanged");
        if(meetingStatus == MeetingStatus.MEETING_STATUS_INMEETING) {
            mTopBar.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void onMeetingNeedPasswordOrDisplayName(boolean needPassword, boolean needDisplayName, InMeetingEventHandler handler) {
    }

    @Override
    public void onMeetingNeedColseOtherMeeting(InMeetingEventHandler inMeetingEventHandler) {
        System.out.println("=>>>>> onMeetingNeedColseOtherMeeting");

    }

    @Override
    public void onJoinWebinarNeedUserNameAndEmail(InMeetingEventHandler inMeetingEventHandler) {
        System.out.println("=>>>>> onJoinWebinarNeedUserNameAndEmail");
        System.out.println("=>>>>> onMeetingNeedPasswordOrDisplayName");
        String displayName = FlutterZoomSdkPlugin.INSTANCE.getDisplayName();
        String email = FlutterZoomSdkPlugin.INSTANCE.getEmail();

        if(displayName != null && email != null) {
            inMeetingEventHandler.setRegisterWebinarInfo(displayName, email, false);
        }
    }

    @Override
    public void onFreeMeetingReminder(boolean isOrignalHost, boolean canUpgrade, boolean isFirstGift) {
        System.out.println("=>>>>> onFreeMeetingReminder");
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
         if (id == R.id.btnLeaveZoomMeeting) {
             showLeaveMeetingDialog();
        }

    }

    private void showLeaveMeetingDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this, us.zoom.videomeetings.R.style.ZMDialog);
        if (mInMeetingService.isMeetingConnected()) {
            if (mInMeetingService.isMeetingHost()) {
                builder.setTitle("End or leave meeting")
                        .setPositiveButton("End", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                leave(true);
                            }
                        }).setNeutralButton("Leave", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        leave(false);
                    }
                });
            } else {
                builder.setTitle("Leave meeting")
                        .setPositiveButton("Leave", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                leave(false);
                            }
                        });
            }
        } else {
            builder.setTitle("Leave meeting")
                    .setPositiveButton("Leave", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            leave(false);
                        }
                    });
        }
        builder.create().show();
    }

    private void leave(boolean end) {
        finish();
        mInMeetingService.leaveCurrentMeeting(end);
    }

}

