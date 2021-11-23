# VXG Mobile SDK iOS

### MobileSDK 2.0.80.211118

 CloudSDK
Version 2.0.80_20211118
- added M1 support
- added protocol and port various configs for Cloud API in next components:
  CloudPlayerSDK, ScrubberView, ScrubberTimelineView, CalendarView
- added protocol and port various settings for Cloud API, Camera API and Streaming publish in ClousSreamerSDK
- added rtmps support in CloudStreamer
- updated versions of used SDK on latest with FFMPEG 4.4.1 and OpenSSL 1.1.1l support
- updated and cleaned samples

 PlayerSDK
Version 2.0.20211118
- migrated to FFMPEG version 4.4.1
- migrated to OpenSSL version 1.1.1l and used as a shared framework
- added M1 support
- added xcframeworks build support
- added bitcode build support

 EncoderSDK
Version 2.0.20211118
- migrated to FFMPEG version 4.4.1
- migrated to OpenSSL version 1.1.1l and used as a shared framework
- added M1 support
- added xcframeworks build support
- added bitcode build support

### MobileSDK 2.0.76.210906

 PlayerSDK
- Added time shift functionality
- Added ONVIF API for device discovery, based on VXG ONVIF library 
- Builded with latest OpenSSL
- Fixed redraw video frame in pasued mode
- Used extradata analyzer for dectect video width and height when default detection failed before
- Added possibility get stream info from extradata, if detection failed before. 
- Fixed Video IPB streams processing with HW Video decoder 
- FFMPEG: fixed h264_mp4toannexb filter for frame with undefined NALU
- Added h264_metadata for crop
- Added API for setup internal buffers sizes
- Added internal buffers type config: 0 - default, 1 - based on mmap
- Added new config settings: 
    advancedSourceUseAsyncGetAddrInfo
    advancedDecoderVideoHardwareReadyFrameQueueMin
    advancedDecoderVideoHardwareReadyFrameQueueMax
- Added settings for HW Video decoder ready frame queue size
- Added support for streams where the audio stream stops but not on the End Of Stream
- Fixed End Of Stream detection algorithm with incomplete audio stream
- Fixed SW Video decoder configuration for MPEG2 type
- Fixed SW Video decoder crash on YUV P10 formats
- Fixed possible crash for broken streams
- Added get version support

 EncoderSDK
- Method setAudioSamplingRate is now public

 CloudSDK
- Added ScrubberView control
- Added SrcubberTimelineView control
- Added first version of PTZ control
- CalendarView: added a lot of new UI settings
- CalendarView: added events filter support
- CalendarView: added new syle
- TimelineView: added Live button for timeline
- TimelineView: added a few new UI customizations
- CloudStreamer: Added  callback for getting SID / PASSWORD for reconnection use case 
- Added new API commands:
    getBackwardUrl
    triggerEvent
    getActivity
    createClip / getClip / deleteClip
    getEvent
    getCameraAudio
    getRecords
    getTimelineThumbnailsFull
    etc.
- Added CloudPlayerSDK new config settings:
    Fast Forward rate  
    Live URL type  
    Audio Echo cancellation
    Video Decoder type
    Microphone Audio average levels
    etc.
- Corrected error handling in CloudSDK
- Fixed library double load issues
- Added scale independent configs
- Added get version support for all components
- Updated SDK dependencies to the latest versions
  
### MobileSDK 2.0.46.200901

 PlayerSDK (r4739)
- Fixed search paths for MediaPlayerSDKTest.swift sample

### MobileSDK iOS.2.0.47.201002

 PlayerSDK (r4761)
- Improved stream info detection for some streams
- Improved IPB streams support
- Fixed drawing issues for orientation chanegs in pasued state

### MobileSDK 2.0.46.200901

 PlayerSDK (r4739)
- Fixed search paths for MediaPlayerSDKTest.swift sample

### MobileSDK 2.0.45.200714

 PlayerSDK (r4739)
- Added PauseWithBuffering functionality
- Fixed problem with freezing rtmp pause in case of loss of connection
- Fixed issue due to which the frame was not updated when the orientation was changed and the current state is suspended
- Added new callback for detect video aspects changing
- Added new audio renderer based on AudioUnit 
- Added echo cancellation support
- Corrected aspect ratio calculation method
- Added average level for microphone output if AudioUnit used
- Added new notify VIDEO_STREAMINFO_NOT_COMPLETE
- Added first version of closed cations support
- Fixed memory leak

### MobileSDK 2.0.44.200619

 EncoderSDK (r4743)
- Same as Player work with license file
- Added external audio source 
- Added a few advanced settings
- Added config settings for enable/disable automatically audio session configure
- Fixed a memmory leak in some cases
- Add ability to configure AAC-encoder bitrate and samplerate

### MobileSDK 2.0.43.200324

 PlayerSDK (r4722)
- Added Audio Specific Config(ASC) for AAC streams without it
- Added WebRTC improvements

### MobileSDK 2.0.42.200311

 PlayerSDK (r4716)
- Fixed problems with some streams on iPhone XR
- Fixed problem with incorrect image colors produced by take shot 
  functionality in software decoding mode 
- Examples are slightly corrected

### MobileSDK 2.0.41.200120

 PlayerSDK (r4711)
- Fixed issue with OpenGL ver 2 support on old devices(9.0)
- Lowres/bogomips tuning for SW decoder
- Fixed memory leak in HW decoder
- Added new zoom modes and double tap handler for zoom mode 4201
- Audio manager changed for more clear close
- Restore saved parametres after MediaPlayer closed
- Added new settings for voice processing (used in backward channel)

### MobileSDK 2.0.40.191203

 PlayerSDK (r4700)
- Added new zoom modes
- Added the ability to disable recording support at start
- Added OpenGLES v3 support for SW renderer
- Added MIN and MAX zoom percent settings
- Added fix for UI main thread checker issue which cause a delay on start
- Fixed issue with OpenGLES v2 only devices
- Fixed iOS 13 compatibility issues

### MobileSDK 2.0.39.190917

 EncoderSDK (r4678)
Enchanced logs at trace-mode

 PlayerSDK
Fixed rtmps-streaming

### MobileSDK 2.0.38.190813

 EncoderSDK (r4632)
- Fix fall in case changing resolution too fast
- Fix rtsp-streamer
- AudioData-callback enchanced by peak-value
- Show SDK version and build time at init

 PlayerSDK (r4645)
- Added support for work in background (as audio player)
- Fixed crash with GetUserName in rtsplib on iOS emulator
- Audio session now more cofigurable
- Fixed play/pause in background mode
- Added check for interruption on mediaformat_find_stream_info stage 
- Redesigned some samples and added remote control support
- Fixed 64-bit issue in playlist parser
- Fixed metal shader comilation on ios 13
- Memory leak fixed in sample
- Fixed MediaPlayer restart in background mode 
- Added reconnect background test code to samples
- Fixed orientation issue for some rare conditions

 CloudSDK (r260)
- Improved CloudSDKPlayerView
- Added CloudMultiPlayerSDKView first version 
- Fixed timeline style for CloudPlayerSDKView
- Added handle tap event for CloudPlayerSDKView 
- Added scale for texts according control size
- Added config for timeline control 
- Added styles for CloudPlayerSDKView control
- Fixed setSource with position timeline scroll 
- Fixed scroll to left in timeline 
- Added camera timezone for timeline 
- Added various settings for timeline
- Fixed a lot of memory leaks in frameworks 

### MobileSDK 2.0.37.190607

 EncoderSDK (r4610)
- Fix RTSP-server stream SIGPIPE-signal error

### MobileSDK 2.0.36.190326

 PlayerSDK (r4556)
- Fixed rtsplib content provider close

### MobileSDK 2.0.35.190325

 EncoderSDK (r4437)
- AdditionalInfo-callback for MuxerRec - for information about file recording
- Fix picture-quality while streaming to prevent pictore destroy
- Faster stream-stop
- Use default AudioSession for capturing audio

 PlayerSDK (r4526)
- Dynamic audio rotation for egl-render
- Implemented setting enableInternalAudioSessionConfigure, configure or use default audio-routes
- Issues while recording at file are fixed
- Moved to openssl 1.1.1a for playing WebRTC over https
- Added draw-object over video functionality
- Ffmpeg-framework recompiled with use openssl 1.1.1a-library

 CloudSDK (r240)
- SetRange-mode implemented (for play short parts of timeline as clip);
- CloudPlayerSDKView implemented, for more usability. Timeline/controls/calendar are configurable options;
- Additional ability with Cloud: upload/download/delete images/videosegments/events;
- Additional calbacks: CloudPlayer: sourceChanged, sourceUnreachable, sourceOffline; CloudPlayerSDKView: OnConnected, onError, OnTrial;
- Faster reconnect CloudStreamer in case connection lost

### MobileSDK 2.0.34.181225

 EncoderSDK (r4395)
- Expanded address entry restrictions for rtmp stream upto rtmpe:// rtmps://

### MobileSDK 2.0.33.181206

 EncoderSDK (r4379)
- Adding setting setRtspAnalyzeDuration for more reactive (re-)connections

### MobileSDK 2.0.32.181204

 PlayerSDK:
- Video rotation fixed (r4366)
- Fixed race condition between Open and Close (r4364)
- Decreased memory usage (especially for 4k video) (r4363)
- Added check for 4k HW decoder support. Fixed Metal video renderer (r4360)
- Fixed HW decoder close session hang on iOS ver >= 11 (r4359)

### MobileSDK 2.0.31.181202

 EncoderSDK (r4365)
- More polite closing of RtspTransfer

### MobileSDK 2.0.30.181127

 EncoderSDK (r4362)
- Changing the state and callbacks of RtspTransfer
- Fix MediaCaptureSDK_Test to reconnect the RtspTransfer instance if an error occurred

### MobileSDK 2.0.29.181112

 EncoderSDK(r4353)
- Prevented permission request for camera if nopreview or VIDEO_FORMAT_NONE configured, and for microphone if AUDIO_FORMAT_NONE configured

### MobileSDK 2.0.28.181106

 EncoderSDK(r4348)
- Update example MediaCaptureSDK_test for RtspTransfer callbacks
- Prevent SIGBART error for ios simulator at MuteMicrophone (Encoder doesn't work for iosSimulator because there isn't camera/microphone simulation, but shouldn't fall)

### MobileSDK 2.0.27.181102

 PlayerSDK (r4342)
- Posibility to check/prevent load ffmpeg-library (isMediaLibraryInited/setMediaLibraryInited)

 EncoderSDK(r4339)
- Posibility to check/prevent load ffmpeg-library by variable VXG_CaptureSDK_ffmpeg_inited
- RtspTransfer callbacks implemented
- Additional example PlayerAndRtspTransfer implemented for demonstrate calbacks&preventing loading ffmpeg-funcs
- MuteMicrophone function implemented

### MobileSDK 2.0.26.181026

 PlayerSDK (r4331)
- Fix high-CPU load 

 EncoderSDK(r4330)
- RtspTransfer add setting RTSPConnection to main Api


### MobileSDK 2.0.25.181025

 PlayerSDK (r4329)
- Update xamarin-examples for the latest MediaPlayerSDK(r4317)

### MobileSDK 2.0.24.181024

 EncoderSDK(r4233)
- Implemented rtsp->rtmp transfer as single class
- Fixed file recording & trimming
- Fixed audio timestamps calculating

### MobileSDK 2.0.23.181018

 PlayerSDK (r4317)
- Added Metal graphic API support
- Fixed Main Thread Checker issues
- Fixed issue with wrong protocol sequence for ffmpeg source

### MobileSDK 2.0.22.180924

 PlayerSDK (r4275)
- Added OpenGL ES 3.0 support

### MobileSDK 2.0.21.180821

 PlayerSDK (r4247)
- Fixed issue with close on udp streams

### MobileSDK 2.0.20.180629

 EncoderSDK (r4204)
- Implemented AUDIO_FORMAT_ALAW (G711@8000khz alaw)

### MobileSDK 2.0.19.180627

 EncoderSDK(r4202): 
- LogLevel renamed to VXG_CaptureSDK_LogLevel
- Reenabled AUDIO_FORMAT_ULAW (G711@8000khz)

### MobileSDK 2.0.18.180622

 PlayerSDK
- add xamarin-example MediaPlayerSDKTest.xamarin.static using static version of MediaPlayerSDK

### MobileSDK 2.0.18.180618

 EncoderSDK(r4193)
- add example MediaCaptureSDK_Test.swift

 PlayerSDK (r4192)
- removing duplicate symbols with rfc_md5

 CloudSDK
- compiled with new MediaPlayer-version 

### MobileSDK 2.0.17.180613

 EncoderSDK(r4191)
- add example PlayerAndStreamer_test for demonstrate ability create application-projet with both MediaCaptureSDK and MediaPlayerSDK

 PlayerSDK (r4190)
- update Xamarin-example for new headers if MediaPlayerSDK

 CloudSDK (r163)
- VXG.StreamLand renamed to VXG.CloudSDK
- Compiled with new MediaPlayer-version 

### MobileSDK 2.0.16.180612

 PlayerSDK (r4189)
- fixed possible duplicated symbols with VXG.MediaEncoder.iOS SDK;

### MobileSDK 2.0.16.180607

 PlayerSDK (r4188)
- fixed scale for SW decoder if resolution same; added scale for HW getVideoShot; enable video renderer callback again;

### MobileSDK 2.0.16.180510

 CloudSDK (r155)
- fixed issues with protocol data exchange. Decreased network traffic. Disabled a lot of unnecesarry trace-messages.

### MobileSDK 2.0.15.180508

 PlayerSDK (r4161)
- fix crash on corrupted license-key; disable videoRenderFrameAvailable-callback;

 CloudSDK (r154)
- Compiled with new MediaPlayer-version

### MobileSDK 2.0.14.180504

 EncoderSDK
- update example, implemented sample-functions for changing camera position & orientation 


### MobileSDK 2.0.13.180428

 CloudSDK (r152)
- additional error proccecing

 EncoderSDK (r4153)
- less cpu and mem-usage, increased perforance

### MobileSDK 2.0.12.180411

 CloudSDK (r150)
- Compiled with new MediaPlayer-version, streamland-player example ecnhanced by show how to get timeline segments on SOURCE_CHANGED callback-value

### MobileSDK 2.0.11.180410

 PlayerSDK (r4111)
- Added runtime set log level functionality
- Added keep-alive setting for http(s) sources

### MobileSDK 2.0.10.180328

 CloudSDK (r144)
- "How to use the license key.pdf" added
- Compiled with new MediaPlayer-version

 PlayerSDK (r4084): 
- latency control; 
- play segment functionality

 EncoderSDK (r4085)
- Front/back camera change

### MobileSDK 2.0.9.180313

 CloudSDK (r138)
- Add callback for error on setSource

 EncoderSDK (r3961) 
- Autocorrect wrong values for width height and pts;
- Force quiting after 10 seconds wait if something wrong;
- Fix camera configure for iPhoneX

 PlayerSDK (r4009)
- fix mem.leaks if used onVideoRendererFrameAvailable-callback

### MobileSDK 2.0.8.180213

 CloudSDK
- Modify xamarin example to use license system (config and file)

### MobileSDK 2.0.7.180208

 CloudSDK
- Fix update license system for MediaPlayerSDK
- Add static version of MediaPlayerSDK to package

### MobileSDK 2.0.6.180206

 CloudSDK
- Update license system, provides update outdated keys over internet

### MobileSDK 2.0.5.180129

 CloudSDK
- Fix bug in libcloudsdk.a while calling callback CONNECT_SUCCESSFUL
- Rewrited samples for Streamland, removed hardcoded acces_tokens 

### MobileSDK 2.0.4.180126

 CloudSDK
- Fix bad stream after stream restarting
- Remove unnecessary debug-messages while streaming

### MobileSDK 2.0.3.180124

 CloudSDK
- Package structure reformat
- CloudPlayerSDK with sample streamland-player implemented

### VXG.Cloud.SDK.iOS.2.0.2.180119

 CloudSDK
- Package structure reformat
- CloudSDK classes decreased to simple one: CloudPlayerSDK(TODO) and CloudStreamerSDK
- CloudStreamerSDK with sample streamland-streamer implemented


### VXG.Cloud.SDK.iOS.2.0.1.170919

 CloudSDK
- Added next snippets:
   Snippet.CloudCamera.ChangeSettings
   Snippet.CloudCameraList.AddDelete
   Snippet.CloudCameraList.PrintAll
   Snippet.CloudPlayer.CreateAndPlayCameraFromUrl
   Snippet.CloudPlayer.PlayKnownCameraID
   Snippet.CloudPlayer.PlayKnownCameraUrl
- Added sample: CloudPlayerTest
- CloudAPI extended with record and lat/long
- Fixed various issues in CloudPlayer, CloudCamera and CloudConnectection


### VXG.Cloud.SDK.iOS.2.0.0.170912

 CloudSDK
- Implemneted: CloudAPI, CloudConnection, CloudTrialConnection, CloudCameraList, partialy CloudPlayer
- Added snippets: Simple camera list, View live camera by id

