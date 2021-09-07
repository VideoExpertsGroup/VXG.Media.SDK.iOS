### VXG.Mobile.SDK.iOS.2.0.76.210906
* Player
1. Added time shift functionality
2. Added ONVIF API for device discovery, based on VXG ONVIF library 
3. Builded with latest OpenSSL
4. Fixed redraw video frame in pasued mode
5. Used extradata analyzer for dectect video width and height when default detection failed before
6. Added possibility get stream info from extradata, if detection failed before. 
7. Fixed Video IPB streams processing with HW Video decoder 
8. FFMPEG: fixed h264_mp4toannexb filter for frame with undefined NALU
9. Added h264_metadata for crop
10. Added API for setup internal buffers sizes
11. Added internal buffers type config: 0 - default, 1 - based on mmap
12. Added new config settings: 
    - advancedSourceUseAsyncGetAddrInfo
    - advancedDecoderVideoHardwareReadyFrameQueueMin
    - advancedDecoderVideoHardwareReadyFrameQueueMax
13. Added settings for HW Video decoder ready frame queue size
14. Added support for streams where the audio stream stops but not on the End Of Stream
15. Fixed End Of Stream detection algorithm with incomplete audio stream
16. Fixed SW Video decoder configuration for MPEG2 type
17. Fixed SW Video decoder crash on YUV P10 formats
18. Fixed possible crash for broken streams
19. Added get version support

* Encoder
1. Method setAudioSamplingRate is now public

* CloudSDK
1. Added ScrubberView control
2. Added SrcubberTimelineView control
3. Added first version of PTZ control
4. CalendarView: added a lot of new UI settings
5. CalendarView: added events filter support
6. CalendarView: added new syle
7. TimelineView: added Live button for timeline
8. TimelineView: added a few new UI customizations
9. CloudStreamer: Added  callback for getting SID / PASSWORD for reconnection use case 
10. Added new API commands:
    - getBackwardUrl
    - triggerEvent
    - getActivity
    - createClip / getClip / deleteClip
    - getEvent
    - getCameraAudio
    - getRecords
    - getTimelineThumbnailsFull
    - etc.
11. Added CloudPlayerSDK new config settings:
    - Fast Forward rate  
    - Live URL type  
    - Audio Echo cancellation
    - Video Decoder type
    - Microphone Audio average levels
    - etc.
12. Corrected error handling in CloudSDK
13. Fixed library double load issues
14. Added scale independent configs
15. Added get version support for all components
16. Updated SDK dependencies to the latest versions
  
### VXG.Mobile.SDK.iOS.2.0.46.200901
- Player (r4739)
1. Fixed search paths for MediaPlayerSDKTest.swift sample

### VXG.Mobile.SDK.iOS.2.0.47.201002
- Player (r4761)
1. Improved stream info detection for some streams
2. Improved IPB streams support
3. Fixed drawing issues for orientation chanegs in pasued state

### VXG.Mobile.SDK.iOS.2.0.46.200901
- Player (r4739)
1. Fixed search paths for MediaPlayerSDKTest.swift sample

### VXG.Mobile.SDK.iOS.2.0.45.200714
- Player (r4739)
1. Added PauseWithBuffering functionality
2. Fixed problem with freezing rtmp pause in case of loss of connection
3. Fixed issue due to which the frame was not updated when the orientation was changed and the current state is suspended
4. Added new callback for detect video aspects changing
5. Added new audio renderer based on AudioUnit 
6. Added echo cancellation support
7. Corrected aspect ratio calculation method
8. Added average level for microphone output if AudioUnit used
9. Added new notify VIDEO_STREAMINFO_NOT_COMPLETE
10. Added first version of closed cations support
11. Fixed memory leak

### VXG.Mobile.SDK.iOS.2.0.44.200619
-Encoder (r4743)
1. Same as Player work with license file
2. Added external audio source 
3. Added a few advanced settings
4. Added config settings for enable/disable automatically audio session configure
5. Fixed a memmory leak in some cases
6. Add ability to configure AAC-encoder bitrate and samplerate

### VXG.Mobile.SDK.iOS.2.0.43.200324
- Player (r4722)
1. Added Audio Specific Config(ASC) for AAC streams without it
2. Added WebRTC improvements

### VXG.Mobile.SDK.iOS.2.0.42.200311
- Player (r4716)
1. Fixed problems with some streams on iPhone XR
2. Fixed problem with incorrect image colors produced by take shot 
   functionality in software decoding mode 
3. Examples are slightly corrected

### VXG.Mobile.SDK.iOS.2.0.41.200120
- Player (r4711)
1. Fixed issue with OpenGL ver 2 support on old devices(9.0)
2. Lowres/bogomips tuning for SW decoder
3. Fixed memory leak in HW decoder
4. Added new zoom modes and double tap handler for zoom mode 4201
5. Audio manager changed for more clear close
6. Restore saved parametres after MediaPlayer closed
7. Added new settings for voice processing (used in backward channel)

### VXG.Mobile.SDK.iOS.2.0.40.191203
- Player (r4700)
1. Added new zoom modes
2. Added the ability to disable recording support at start
3. Added OpenGLES v3 support for SW renderer
4. Added MIN and MAX zoom percent settings
5. Added fix for UI main thread checker issue which cause a delay on start
6. Fixed issue with OpenGLES v2 only devices
7. Fixed iOS 13 compatibility issues

### VXG.Mobile.SDK.iOS.2.0.39.190917
- Encoder (r4678)
Enchanced logs at trace-mode

- FFmpeg-framework
Fixed rtmps-streaming

### VXG.Mobile.SDK.iOS.2.0.38.190813
- Encoder (r4632)
1. Fix fall in case changing resolution too fast
2. Fix rtsp-streamer
3. AudioData-callback enchanced by peak-value
4. Show SDK version and build time at init

- Player (r4645)
1. Added support for work in background (as audio player)
2. Fixed crash with GetUserName in rtsplib on iOS emulator
3. Audio session now more cofigurable
4. Fixed play/pause in background mode
5. Added check for interruption on mediaformat_find_stream_info stage 
6. Redesigned some samples and added remote control support
7. Fixed 64-bit issue in playlist parser
8. Fixed metal shader comilation on ios 13
9. Memory leak fixed in sample
10. Fixed MediaPlayer restart in background mode 
11. Added reconnect background test code to samples
12. Fixed orientation issue for some rare conditions

- CloudSDK (r260)
1. Improved CloudSDKPlayerView
2. Added CloudMultiPlayerSDKView first version 
3. Fixed timeline style for CloudPlayerSDKView
4. Added handle tap event for CloudPlayerSDKView 
5. Added scale for texts according control size
6. Added config for timeline control 
7. Added styles for CloudPlayerSDKView control
8. Fixed setSource with position timeline scroll 
9. Fixed scroll to left in timeline 
10. Added camera timezone for timeline 
11. Added various settings for timeline
12. Fixed a lot of memory leaks in frameworks 

### VXG.Mobile.SDK.iOS.2.0.37.190607
- Encoder (r4610)
1. Fix RTSP-server stream SIGPIPE-signal error

### VXG.Mobile.SDK.iOS.2.0.36.190326
- Player(r4556)
1. Fixed rtsplib content provider close

### VXG.Mobile.SDK.iOS.2.0.35.190325
- Encoder (r4437)
1. AdditionalInfo-callback for MuxerRec - for information about file recording
2. Fix picture-quality while streaming to prevent pictore destroy
3. Faster stream-stop
4. Use default AudioSession for capturing audio

- Player(r4526)
1. Dynamic audio rotation for egl-render
2. Implemented setting enableInternalAudioSessionConfigure, configure or use default audio-routes
3. Issues while recording at file are fixed
4. Moved to openssl 1.1.1a for playing WebRTC over https
5. Added draw-object over video functionality

- CloudSDK(r240)
1. SetRange-mode implemented (for play short parts of timeline as clip);
2. CloudPlayerSDKView implemented, for more usability. Timeline/controls/calendar are configurable options;
3. Additional ability with Cloud: upload/download/delete images/videosegments/events;
4. Additional calbacks: CloudPlayer: sourceChanged, sourceUnreachable, sourceOffline; CloudPlayerSDKView: OnConnected, onError, OnTrial;
5. Faster reconnect CloudStreamer in case connection lost

- Other
Ffmpeg-framework recompiled with use openssl 1.1.1a-library

### VXG.Mobile.SDK.iOS.2.0.34.181225
- Encoder (r4395):
1. Expanded address entry restrictions for rtmp stream upto rtmpe:// rtmps://

### VXG.Mobile.SDK.iOS.2.0.33.181206
- Encoder (r4379):
1. Adding setting setRtspAnalyzeDuration for more reactive (re-)connections

### VXG.Mobile.SDK.iOS.2.0.32.181204
- Player:
1. Video rotation fixed (r4366)
2. Fixed race condition between Open and Close (r4364)
3. Decreased memory usage (especially for 4k video) (r4363)
4. Added check for 4k HW decoder support. Fixed Metal video renderer (r4360)
5. Fixed HW decoder close session hang on iOS ver >= 11 (r4359)

### VXG.Mobile.SDK.iOS.2.0.31.181202
- Encoder (r4365):
1. More polite closing of RtspTransfer

### VXG.Mobile.SDK.iOS.2.0.30.181127
- Encoder (r4362):
1. Changing the state and callbacks of RtspTransfer
2. Fix MediaCaptureSDK_Test to reconnect the RtspTransfer instance if an error occurred

### VXG.Mobile.SDK.iOS.2.0.29.181112
- Encoder(r4353):
1. Prevented permission request for camera if nopreview or VIDEO_FORMAT_NONE configured, and for microphone if AUDIO_FORMAT_NONE configured

### VXG.Mobile.SDK.iOS.2.0.28.181106
- Encoder(r4348):
1. Update example MediaCaptureSDK_test for RtspTransfer callbacks
2. Prevent SIGBART error for ios simulator at MuteMicrophone (Encoder doesn't work for iosSimulator because there isn't camera/microphone simulation, but shouldn't fall)

### VXG.Mobile.SDK.iOS.2.0.27.181102
- Player(r4342)
1. Posibility to check/prevent load ffmpeg-library (isMediaLibraryInited/setMediaLibraryInited)

- Encoder(r4339)
1. Posibility to check/prevent load ffmpeg-library by variable VXG_CaptureSDK_ffmpeg_inited
2. RtspTransfer callbacks implemented
3. Additional example PlayerAndRtspTransfer implemented for demonstrate calbacks&preventing loading ffmpeg-funcs
4. MuteMicrophone function implemented

### VXG.Mobile.SDK.iOS.2.0.26.181026
- Player(r4331):
1. Fix high-CPU load 

- Encoder(r4330):
1. RtspTransfer add setting RTSPConnection to main Api


### VXG.Mobile.SDK.iOS.2.0.25.181025
- Player(r4329):
1. Update xamarin-examples for the latest MediaPlayerSDK(r4317)

### VXG.Mobile.SDK.iOS.2.0.24.181024
- Encoder(r4233):
1. Implemented rtsp->rtmp transfer as single class
2. Fixed file recording & trimming
3. Fixed audio timestamps calculating

### VXG.Mobile.SDK.iOS.2.0.23.181018
- Player (r4317):
1. Added Metal graphic API support
2. Fixed Main Thread Checker issues
3. Fixed issue with wrong protocol sequence for ffmpeg source

### VXG.Mobile.SDK.iOS.2.0.22.180924
- Player (r4275): Added OpenGL ES 3.0 support

### VXG.Mobile.SDK.iOS.2.0.21.180821
- Player (r4247): Fixed issue with close on udp streams

### VXG.Mobile.SDK.iOS.2.0.20.180629
- Encoder(r4204): Implemented AUDIO_FORMAT_ALAW (G711@8000khz alaw)

### VXG.Mobile.SDK.iOS.2.0.19.180627
- Encoder(r4202): 
1. LogLevel renamed to VXG_CaptureSDK_LogLevel
2. Reenabled AUDIO_FORMAT_ULAW (G711@8000khz)

### VXG.Mobile.SDK.iOS.2.0.18.180622
- Player: add xamarin-example MediaPlayerSDKTest.xamarin.static using static version of MediaPlayerSDK

### VXG.Mobile.SDK.iOS.2.0.18.180618
- Encoder(r4193): add example MediaCaptureSDK_Test.swift
- Player (r4192): removing duplicate symbols with rfc_md5
- CloudSDK: compiled with new MediaPlayer-version 

### VXG.Mobile.SDK.iOS.2.0.17.180613
- Encoder(r4191): add example PlayerAndStreamer_test for demonstrate ability create application-projet with both MediaCaptureSDK and MediaPlayerSDK
- Player (r4190): update Xamarin-example for new headers if MediaPlayerSDK
- CloudSDK(r163):
1. VXG.StreamLand renamed to VXG.CloudSDK
2. Compiled with new MediaPlayer-version 

### VXG.Mobile.SDK.iOS.2.0.16.180612
- Player(r4189): fixed possible duplicated symbols with VXG.MediaEncoder.iOS SDK;

### VXG.Mobile.SDK.iOS.2.0.16.180607
- Player(r4188): fixed scale for SW decoder if resolution same; added scale for HW getVideoShot; enable video renderer callback again;

### VXG.Mobile.SDK.iOS.2.0.16.180510
- Streamland(r155): fixed issues with protocol data exchange. Decreased network traffic. Disabled a lot of unnecesarry trace-messages.

### VXG.Mobile.SDK.iOS.2.0.15.180508
- Player(r4161): fix crash on corrupted license-key; disable videoRenderFrameAvailable-callback;
- Streamland(r154): Compiled with new MediaPlayer-version

### VXG.Mobile.SDK.iOS.2.0.14.180504
- Encoder: update example, implemented sample-functions for changing camera position & orientation 


### VXG.Mobile.SDK.iOS.2.0.13.180428
- Streamland(r152): additional error proccecing
- Encoder (r4153): less cpu and mem-usage, increased perforance

### VXG.Mobile.SDK.iOS.2.0.12.180411
-  Streamland(r150): Compiled with new MediaPlayer-version, streamland-player example ecnhanced by show how to get timeline segments on SOURCE_CHANGED callback-value

### VXG.Mobile.SDK.iOS.2.0.11.180410
- Player(r4111):
1. Added runtime set log level functionality
2. Added keep-alive setting for http(s) sources

### VXG.Mobile.SDK.iOS.2.0.10.180328

- "How to use the license key.pdf" added

- Player (r4084): 
1. latency control; 
2. play segment functionality

-  Encoder (r4085): Front/back camera change

-  Streamland(r144): Compiled with new MediaPlayer-version

### VXG.Mobile.SDK.iOS.2.0.9.180313
 - Streamland (r138): Add callback for error on setSource
 - Encoder (r3961): 
 1. Autocorrect wrong values for width height and pts;
 2. Force quiting after 10 seconds wait if something wrong;
 3. Fix camera configure for iPhoneX
 - Player (r4009): fix mem.leaks if used onVideoRendererFrameAvailable-callback

### VXG.Mobile.SDK.iOS.2.0.8.180213
- Modify xamarin example to use license system (config and file)

### VXG.Mobile.SDK.iOS.2.0.7.180208
- Fix update license system for MediaPlayerSDK
- Add static version of MediaPlayerSDK to package

### VXG.Mobile.SDK.iOS.2.0.6.180206
- Update license system, provides update outdated keys over internet

### VXG.Mobile.SDK.iOS.2.0.5.180129
1. Fix bug in libcloudsdk.a while calling callback CONNECT_SUCCESSFUL
2. Rewrited samples for Streamland, removed hardcoded acces_tokens 

### VXG.Mobile.SDK.iOS.2.0.4.180126
- Fix bad stream after stream restarting
- Remove unnecessary debug-messages while streaming

### VXG.Mobile.SDK.iOS.2.0.3.180124
- Package structure reformat
- CloudPlayerSDK with sample streamland-player implemented

### VXG.Cloud.SDK.iOS.2.0.2.180119
- Package structure reformat
- CloudSDK classes decreased to simple one: CloudPlayerSDK(TODO) and CloudStreamerSDK
- CloudStreamerSDK with sample streamland-streamer implemented


### VXG.Cloud.SDK.iOS.2.0.1.170919
- Added next snippets:
   1. Snippet.CloudCamera.ChangeSettings
   2. Snippet.CloudCameraList.AddDelete
   3. Snippet.CloudCameraList.PrintAll
   4. Snippet.CloudPlayer.CreateAndPlayCameraFromUrl
   5. Snippet.CloudPlayer.PlayKnownCameraID
   6. Snippet.CloudPlayer.PlayKnownCameraUrl
- Added sample: CloudPlayerTest
- CloudAPI extended with record and lat/long
- Fixed various issues in CloudPlayer, CloudCamera and CloudConnectection


### VXG.Cloud.SDK.iOS.2.0.0.170912
First version
1. Implemneted: CloudAPI, CloudConnection, CloudTrialConnection, CloudCameraList, partialy CloudPlayer
2. Added snippets: Simple camera list, View live camera by id

