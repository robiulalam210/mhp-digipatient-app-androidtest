import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:digi_patient/resources/colors.dart';
import 'package:digi_patient/view/real_communication/data.dart';
import 'package:flutter/material.dart';
import '/resources/app_url.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoCallingView extends StatefulWidget {
  const VideoCallingView({super.key, required this.token, required this.channelName, required this.appId});
  final String token;
  final String channelName;
  final String appId;

  @override
  State<VideoCallingView> createState() => _VideoCallingViewState();
}

class _VideoCallingViewState extends State<VideoCallingView> {

  late final AgoraClient client;
  @override
  void initState() {
    super.initState();

    initAgora();
  }
  void initAgora() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: widget.appId,
          channelName: widget.channelName,
          tempToken: widget.token,
          tokenUrl: AppUrls.videoCall,

      ),
    );
    await client.initialize();
    setState(() {

    });
  }
  // var provider = context.read();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          // leading: const CustomBackButton(),
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primaryColor,
          title: const Text("Video Call"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(client: client, layoutType: Layout.floating),
              AgoraVideoButtons(client: client, ),
            ],
          ),
        ),
      ),
    );
  }
}


class VideoCallingRTCView extends StatefulWidget {
  const VideoCallingRTCView({Key? key, required this.token}) : super(key: key);
  final String token;
  @override
  State<VideoCallingRTCView> createState() => _VideoCallingRTCViewState();
}

class _VideoCallingRTCViewState extends State<VideoCallingRTCView> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  // String? token ;

  @override
  void initState() {
    super.initState();
    initAgora();
  }


  Future<void> initAgora() async {
    // token = widget.token;
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize( RtcEngineContext(
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
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: widget.token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;

      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Video Call'),
        ),
        body: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 100,
                height: 150,
                child: Center(
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
            ),

          ],
        ),
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
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
