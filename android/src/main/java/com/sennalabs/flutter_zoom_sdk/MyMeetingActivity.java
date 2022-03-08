package com.sennalabs.flutter_zoom_sdk;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;

import us.zoom.sdk.CameraDevice;
import us.zoom.sdk.InMeetingEventHandler;
import us.zoom.sdk.InMeetingService;
import us.zoom.sdk.InMeetingUserInfo;
import us.zoom.sdk.InMeetingVideoController;
import us.zoom.sdk.MeetingActivity;
import us.zoom.sdk.MeetingStatus;
import us.zoom.sdk.SimpleZoomUIDelegate;
import us.zoom.sdk.ZoomSDK;

import com.sennalabs.flutter_zoom_sdk.inmeetingfunction.customizedmeetingui.other.MeetingCommonCallback;
import com.sennalabs.flutter_zoom_sdk.inmeetingfunction.customizedmeetingui.view.MeetingOptionBar;
import com.sennalabs.flutter_zoom_sdk.inmeetingfunction.customizedmeetingui.view.adapter.CameraMenuItem;
import com.sennalabs.flutter_zoom_sdk.inmeetingfunction.customizedmeetingui.view.adapter.SimpleMenuAdapter;

import java.util.List;


public class MyMeetingActivity extends MeetingActivity implements MeetingCommonCallback.CommonEvent, View.OnClickListener {
    View mTopBar;
    private View mBtnLeave;
    private View mBtnQAPanelist;
    private View mBtnSwitchCamera;

    private InMeetingService mInMeetingService;
    private InMeetingVideoController mInMeetingVideoController;


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
        if (mTopBar != null) {
            if (b) {
                mTopBar.setVisibility(View.VISIBLE);
            } else {
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

        mBtnQAPanelist = findViewById(R.id.btnQAPanelist);
        mBtnQAPanelist.setOnClickListener(this);

        mBtnSwitchCamera = findViewById(R.id.btnSwitchSideCamera);
        mBtnSwitchCamera.setOnClickListener(this);

        mInMeetingService = ZoomSDK.getInstance().getInMeetingService();
        mInMeetingVideoController = mInMeetingService.getInMeetingVideoController();
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
        if (meetingStatus == MeetingStatus.MEETING_STATUS_INMEETING) {
            refreshTopBar();
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

        if (displayName != null && email != null) {
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
        } else if (id == R.id.btnQAPanelist) {
            mInMeetingService.showZoomQAUI(this, 13);
        } else if (id == R.id.btnSwitchSideCamera) {
            switchSideCamera();
        }

    }

    public void updateQAPanelistButton() {
        InMeetingUserInfo myUserInfo = mInMeetingService.getMyUserInfo();
        if (myUserInfo != null && mInMeetingService.isWebinarMeeting()) {
            if (myUserInfo.getInMeetingUserRole() == InMeetingUserInfo.InMeetingUserRole.USERROLE_PANELIST) {
                mBtnQAPanelist.setVisibility(View.VISIBLE);
            } else {
                mBtnQAPanelist.setVisibility(View.GONE);
            }
        }
    }

    public void updateSwitchCameraButton() {
        InMeetingUserInfo myUserInfo = mInMeetingService.getMyUserInfo();
        if (myUserInfo != null && mInMeetingService.isWebinarMeeting()) {
            if (myUserInfo.getInMeetingUserRole() == InMeetingUserInfo.InMeetingUserRole.USERROLE_PANELIST) {
                mBtnSwitchCamera.setVisibility(View.VISIBLE);
            } else {
                mBtnSwitchCamera.setVisibility(View.GONE);
            }
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

    public void switchSideCamera() {
        if (mInMeetingVideoController.canSwitchCamera()) {
            mInMeetingVideoController.switchToNextCamera();
        }
    }

    public void refreshTopBar(){
        updateQAPanelistButton();
        updateSwitchCameraButton();
    }

}

