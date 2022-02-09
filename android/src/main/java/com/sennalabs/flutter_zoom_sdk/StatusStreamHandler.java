package com.sennalabs.flutter_zoom_sdk;


import android.content.Context;
import android.content.Intent;

import java.util.Arrays;
import java.util.List;

import io.flutter.plugin.common.EventChannel;
import us.zoom.sdk.MeetingError;
import us.zoom.sdk.MeetingService;
import us.zoom.sdk.MeetingServiceListener;
import us.zoom.sdk.MeetingStatus;
import us.zoom.sdk.MobileRTCSDKError;
import us.zoom.sdk.ZoomSDK;

public class StatusStreamHandler implements EventChannel.StreamHandler {
    private MeetingService meetingService;
    private MeetingServiceListener statusListener;
    private Context context;

    public StatusStreamHandler(MeetingService meetingService, Context context) {
        this.meetingService = meetingService;
        this.context = context;
    }

    @Override
    public void onListen(Object arguments, final EventChannel.EventSink events) {
        statusListener = new MeetingServiceListener() {
            @Override
            public void onMeetingStatusChanged(MeetingStatus meetingStatus, int errorCode, int internalErrorCode) {
                System.out.println("STATUS CHANGE TO" + meetingStatus);
                if (meetingStatus == MeetingStatus.MEETING_STATUS_FAILED &&
                        errorCode == MeetingError.MEETING_ERROR_CLIENT_INCOMPATIBLE) {
                    events.success(Arrays.asList("MEETING_STATUS_UNKNOWN", "Version of ZoomSDK is too low"));
                    return;
                }
                if (meetingStatus == MeetingStatus.MEETING_STATUS_CONNECTING) {
                    System.out.println("CALLLLLLL STATUS LISTENRER");
                    showMeetingUi();
                }
                if(meetingStatus == MeetingStatus.MEETING_STATUS_INMEETING) {
                    long myUserId = ZoomSDK.getInstance().getInMeetingService().getMyUserID();
                    System.out.println("MY User Id =>>>>>>>>>" + myUserId);
                    MobileRTCSDKError result = ZoomSDK.getInstance().getInMeetingService().changeName(FlutterZoomSdkPlugin.INSTANCE.getDisplayName(), myUserId);
                    System.out.println("RESULT change name =>>>>" + result);
                }

                events.success(getMeetingStatusMessage(meetingStatus));
            }


        };

        this.meetingService.addListener(statusListener);
    }

    @Override
    public void onCancel(Object arguments) {
        this.meetingService.removeListener(statusListener);

    }

    private List<String> getMeetingStatusMessage(MeetingStatus meetingStatus) {
        String[] message = new String[2];

        message[0] = meetingStatus != null ? meetingStatus.name() : "";

        switch (meetingStatus) {
            case MEETING_STATUS_CONNECTING:
                message[1] = "Connect to the meeting server.";
                break;
            case MEETING_STATUS_DISCONNECTING:
                message[1] = "Disconnect the meeting server, user leaves meeting.";
                break;
            case MEETING_STATUS_FAILED:
                message[1] = "Failed to connect the meeting server.";
                break;
            case MEETING_STATUS_IDLE:
                message[1] = "No meeting is running";
                break;
            case MEETING_STATUS_IN_WAITING_ROOM:
                message[1] = "Participants who join the meeting before the start are in the waiting room.";
                break;
            case MEETING_STATUS_INMEETING:
                message[1] = "Meeting is ready and in process.";
                break;
            case MEETING_STATUS_RECONNECTING:
                message[1] = "Reconnecting meeting server.";
                break;
            case MEETING_STATUS_UNKNOWN:
                message[1] = "Unknown status.";
                break;
            case MEETING_STATUS_WAITINGFORHOST:
                message[1] = "Waiting for the host to start the meeting.";
                break;
            case MEETING_STATUS_WEBINAR_DEPROMOTE:
                message[1] = "Demote the attendees from the panelist.";
                break;
            case MEETING_STATUS_WEBINAR_PROMOTE:
                message[1] = "Upgrade the attendees to panelist in webinar.";
                break;
            default:
                message[1] = "No status available.";
                break;
        }

        return Arrays.asList(message);
    }

    private void showMeetingUi() {
        if (ZoomSDK.getInstance().getMeetingSettingsHelper().isCustomizedMeetingUIEnabled()) {
            Intent intent = new Intent(context, MyMeetingActivity.class);
            intent.putExtra("from", MyMeetingActivity.JOIN_FROM_APIUSER);
//            intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        }
    }

}

