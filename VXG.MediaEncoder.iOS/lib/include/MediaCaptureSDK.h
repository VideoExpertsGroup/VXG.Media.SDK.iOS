//
//  MediaCaptureSDK.h
//  MediaCaptureSDK
//
//  Copyright © 2017 VXG Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(int, StreamType){
    STREAM_TYPE_UNKNOWN = 0,
    STREAM_TYPE_RTMP_PUBLISH = 1,
    STREAM_TYPE_RTSP_SERVER = 2,
    STREAM_TYPE_AMOUNT = 3
};

typedef NS_ENUM(int, VideoFormat){
    VIDEO_FORMAT_H264 = 0,
    VIDEO_FORMAT_NONE = 1
};

typedef NS_ENUM(int, AudioFormat){
    AUDIO_FORMAT_AAC = 0,
    AUDIO_FORMAT_ULAW = 1,
    AUDIO_FORMAT_ALAW = 2,
    AUDIO_FORMAT_NONE = 3
};

typedef NS_ENUM(int, CaptureNotifyCodes){
    CAPTURE_VIDEO_OPENED    = 0,
    CAPTURE_VIDEO_STARTED   = 1,
    CAPTURE_VIDEO_STOPED    = 2,
    CAPTURE_VIDEO_CLOSED    = 3,
    CAPTURE_AUDIO_OPENED    = 4,
    CAPTURE_AUDIO_STARTED   = 5,
    CAPTURE_AUDIO_STOPED    = 6,
    CAPTURE_AUDIO_CLOSED    = 7,
    ENCODER_VIDEO_OPENED    = 8,
    ENCODER_VIDEO_STARTED   = 9,
    ENCODER_VIDEO_STOPED    = 10,
    ENCODER_VIDEO_CLOSED    = 11,
    ENCODER_AUDIO_OPENED    = 12,
    ENCODER_AUDIO_STARTED   = 13,
    ENCODER_AUDIO_STOPED    = 14,
    ENCODER_AUDIO_CLOSED    = 15,
    MUXREC_OPENED           = 16,
    MUXREC_STARTED          = 17,
    MUXREC_STOPED           = 18,
    MUXREC_CLOSED           = 19,
    MUXRTMP_OPENED          = 20,
    MUXRTMP_STARTED         = 21,
    MUXRTMP_STOPED          = 22,
    MUXRTMP_CLOSED          = 23,
    MUXRTSP_OPENED          = 24,
    MUXRTSP_STARTED         = 25,
    MUXRTSP_STOPED          = 26,
    MUXRTSP_CLOSED          = 27,
    RENDER_OPENED           = 28,
    RENDER_STARTED          = 29,
    RENDER_STOPED           = 30,
    RENDER_CLOSED           = 31,
    FULL_CLOSE              = 32
};

typedef NS_ENUM(int, LogLevels){
    LL_QUIET    = -1,
    LL_PANIC    = 0,
    LL_FATAL    = 1,
    LL_ERROR    = 2,
    LL_WARNING  = 3,
    LL_INFO     = 4,
    LL_DEBUG    = 5,
    LL_VERBOSE  = 6,
    LL_TRACE    = 7,
    LL_ALL      = 8
};

typedef NS_ENUM(int, CaptureDevicePosition){
    Back,
    Front
};

typedef NS_ENUM(int, CaptureDeviceOrientation){
    Landscape,
    Portrait
};

extern int VXG_CaptureSDK_LogLevel;
void LogElement(int loglevel, NSString *format, ... );

@protocol MediaCaptureCallback;

@interface MediaCaptureConfig : NSObject
-(void) setPreview: (UIView*) previewView;
-(UIView*) getPreview;
-(int) setVideoConfig: (int) width : (int) height : (int) framerate : (long long) bitrate;
-(int) getInputWidth;
-(int) getInputHeight;
-(int) getInputFramerate;
-(long long) getBitrate;
-(int) setSecVideoConfig: (int) width : (int) height : (int) framerate : (long long) bitrate;
-(int) getSecWidth;
-(int) getSecHeight;
-(int) getSecFramerate;
-(long long) getSecBitrate;
-(void) setBitrateLimit:(Boolean) isLimited;
-(Boolean) isBitrateLimit;

-(int) setRTMPurl: (NSString*) url;
-(NSString*) getRTMPurl;

- (int) setRTSPport: (int) port;
- (int) getRTSPport;

-(int) setSecRTMPurl: (NSString*) url;
-(NSString*) getSecRTMPurl;

- (enum StreamType) getStreamType;
- (int) setStreamType: (enum StreamType) type;

- (enum VideoFormat) getVideoFormat;
- (int) setVideoFormat: (enum VideoFormat) format;

- (enum AudioFormat) getAudioFormat;
- (int) setAudioFormat: (enum AudioFormat) format;

-(void) setLicenseKey: (NSString*) license_key;

-(enum CaptureDevicePosition) getDevicePosition;
-(void) setDevicePosition: (enum CaptureDevicePosition) devornt;

-(enum CaptureDeviceOrientation) getDeviceOrientation;
- (void) setDeviceOrientation:(enum CaptureDeviceOrientation)devornt;
@end

@protocol MediaCaptureCallback <NSObject>
- (int) Status: (NSString*) who : (int) arg;
@end

@interface MediaRecorder : NSObject<MediaCaptureCallback>
- (id) init;
- (int) Open:(MediaCaptureConfig*)cfg callback:(id<MediaCaptureCallback>) cbk;
- (void) Close;
- (void) Start;
- (void) Stop;
- (void) StartStreaming;
- (void) StopStreaming;
- (void) StartRecording;
- (void) StopRecording;
- (long) GetDuration;
- (long) GetVideoPackets;
- (long) GetAudioPackets;
- (UIImage*) getVideoShot;

-(void) changeCapturePosition;
-(void) changeCaptureOrientation;

+ (NSArray<NSDictionary*>*) getFormats;
@end

typedef MediaRecorder MediaCapture;
