import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../../../common_widgets/leave_dialog.dart';
import '../../../global/api_string.dart';
import '../bottom_navbar_screens/profile_screen/profile_controller.dart';

// const token = "007eJxTYNCacupGHPPaC7OT58/h1LF61s74nkn6b88RLsEPO/dujCpXYDBMTklKTjU3NjG2NDYxtTBNNDM3sEgyMDBMNTAzSTNN2jE5KL0hkJHh6ufJjIwMEAjiszFk5JdWVSUyMAAAmTsg+g==";
const appId='1cdbce7343934585a6708b001e064f5b';
class videoCallScreen extends StatefulWidget {
  final String channel_name;
  final String agora_token;
  final String tour_id;
  final String type;
   videoCallScreen({super.key,required this.channel_name,required this.agora_token,required this.tour_id,required this.type});

  @override
  State<videoCallScreen> createState() => _videoCallScreenState();
}

class _videoCallScreenState extends State<videoCallScreen> {
  ProfileController profileController = Get.put(ProfileController());
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _mutedAudio = false;
  bool _mutedVideo = false;
  bool _isFront = false;

  @override
  void initState() {
    super.initState();
    print('CHANNEL ID '+widget.channel_name);
    print('Token '+widget.agora_token);
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
        onError: (ErrorCodeType errorCode,String test) {
          if (errorCode == ErrorCodeType.errInvalidToken) {
            debugPrint("Invalid token");
          } else if (errorCode == ErrorCodeType.errTokenExpired) {
            debugPrint("Token expired");
          }
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    try {
      debugPrint("Attempting to join channel...");
      await _engine.joinChannel(
        token: widget.agora_token,
        channelId: widget.channel_name,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
      debugPrint("Join channel method called successfully.");
    } catch (e) {
      debugPrint("Error while joining channel: $e");
    }

  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Tour Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              height: 150,
              width: 100,
              child: _localUserJoined
                  ? AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              )
                  : const CircularProgressIndicator(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              //width: 100,
              height: 150,
              child: Row(
                children:[
                  RawMaterialButton(
                    onPressed: _onToggleMuteVideo,
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: _mutedVideo
                        ? Colors.white.withAlpha(100)
                        : Colors.transparent,
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      _mutedVideo ? Icons.videocam_off : Icons.videocam,
                      color: _mutedVideo ?Colors.redAccent:Colors.white,
                      size: 20.0,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: _onToggleMuteAudio,
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    fillColor: _mutedAudio
                        ? Colors.white.withAlpha(100)
                        : Colors.transparent,
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      _mutedAudio ? Icons.mic_off : Icons.mic,
                      color: _mutedAudio ?Colors.redAccent:Colors.white,
                      size: 20.0,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: _onToggleCamera,
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor:
                    _isFront ? Colors.white.withAlpha(100) : Colors.transparent,
                    padding: const EdgeInsets.all(15),
                    child: Icon(
                       Icons.swap_horiz_sharp ,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: (){
                      print("clicked");
                      showCallLeaveDialog(
                          context,
                          'Are you sure you want to end your call?',
                          'Yes end call now',
                          'No cancel & return to call', () {
                        _onCallEnd(context);
                      });
                    },
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor:
                    _isFront ? Colors.white.withAlpha(60) : Colors.transparent,
                    padding: const EdgeInsets.all(15),
                    child: Icon(
                      Icons.call_end,
                      color: Colors.red,
                      size: 20.0,
                    ),
                  ),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channel_name),
        ),
      );
    } else {
      return const Text(
        'Please wait for user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  //Switch Camera
  _onToggleCamera() {
    _engine?.switchCamera()?.then((value) {
      setState(() {
        _isFront = !_isFront;
      });
    })?.catchError((err) {});
  }

  //Audio On / Off
  void _onToggleMuteAudio() {
    setState(() {
      _mutedAudio = !_mutedAudio;
    });
    _engine.muteLocalAudioStream(_mutedAudio);
  }

  //Video On / Off
  void _onToggleMuteVideo() {
    setState(() {
      _mutedVideo = !_mutedVideo;
    });
    _engine.muteLocalVideoStream(_mutedVideo);
    _engine.enableLocalVideo(!_mutedVideo);
  }

  //Use This Method To End Call
  void _onCallEnd(BuildContext context) async {
    Navigator.pop(context);
    if(widget.type=="enquiry") {
      profileController.update_tour_Status(
          tour_id: widget.tour_id, Status: 'Attended', from: widget.type);
    }
  }

}