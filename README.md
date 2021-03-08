

# VXG Media SDK for iOS

## Disclaimer
This is a non-commercial version of VXG Media SDK for iOS.  Playback is limited to 2 minutes.
Commercial use and access to extra features requires a license.  Learn more about <a href="https://www.videoexpertsgroup.com">VXG iOS RTSP SDK</a>

## About SDK
SDK consists of three modules:
- Player SDK - for playback of media files and streams
- Encoder SDK - for live video broadcasting from mobile device
- Cloud SDK - module for playback from or streaming to VXG Cloud / VXG Server

SDK can be used for IPTV, iOS client of surveillance system, IP camera viewer, TV player, OTT clients and other kinds of applications 
with video playback. Source code of samples can be provided.

## Documentation 
The full SDK documentation can be found here - https://dashboard.videoexpertsgroup.com/docs/.

## Media Player
   Main features:
   * **Low latency for network streams** – Special API controls playback latency and buffering in every module.
   * **Multi-channel support** – Support of simultaneous connection to several video sources.
   * **Getting raw video frames** (whole or cropped) after decoder for computer vision handler (include Face detector sample).
   * **Hardware acceleration** – Hardware accelerated decoding of HD video (H.264, H.265, MPEG4, MPEG2 and others).
   * **H/W post and pre-processing** – Hardware de-interlacing and pre-processing using OpenGL shaders.
   * **Smart OpenGL rendering** - Digital zoom and picture shifting.
   * **Fast and Low rate playback** - Support of 0.1x-16x speed rate for files and 0.1x-3x for live streams
   * **Smooth change position** - Support of quick position change with audio fade in a short time
   * **Record during Playback** - Support of record from live video source to mp4 file compatible with all social networks
   * **Real time statistics** - Statistics are calculated in real time: bitrate, latency in video and audio flow, number of frames in video flow
   
   Additional features:
   * **Smart thumbnails** – Quick and simple API gets thumbnails for local files and live streams.
   * **Replay** - Support of position change in live HLS streams
   * **Audio filtering** - Support of volume boost, tempo, notch
   * **ONVIF** - Support of ONVIF protocol (it is provided on demand) 
   
   Supported file formats and network protocols:
   * Supported file formats: AVI, 3GP, M4V, MP4, WMV, FLV, MPEG, MPG, MOV, RM, VOB, ASF, MKV, F4V, TRP, TS, TP and others.
   * Supported Network protocols: HLS, HTTP, RTMPT, RTMPE, HTTTPS, RTMPTS, MMS, RTMP, RTP, SRTP, UDP, HLS, RTSP and others.
   * Support of Multicast, Unicast and Broadcast
   * Stream playback: Multicast/Unicast UDP, HTTP and HTTPS tunneling for RTSP.
   
   Supported subtitles:
   * DVD subtitles (codec dvd_subtitle), Closed Caption (EIA-608 / CEA-708) Decoder (codec eia_608), PJS subtitle, RealText subtitle, SSA (SubStation Alpha) subtitle, SubRip subtitle, Raw text subtitle, WebVTT subtitle
   
## Media Encoder
   Main Features:
   * RTSP server (in local network) / RTMP in public network
   * H.264 encoding up to 4K resolution  
   * Simultaneous recording and broadcasting
   * Capturing audio from microphone
   * Recording audio in WAV format
   * Custom Stream Encryption (on demand)
   * RTSP tunneling over HTTPS, HTTP
   * Capturing raw video up to 30 FPS
   * Capturing raw audio (PCM format)

Learn more about <a href="www.videoexpertsgroup.com">Cloud Video Surveillance</a>
   
## Demo screenshots
<img src="http://www.videoexpertsgroup.com/git/iphone_rtsp.png" alt="RTSP Player sample" width="400">
