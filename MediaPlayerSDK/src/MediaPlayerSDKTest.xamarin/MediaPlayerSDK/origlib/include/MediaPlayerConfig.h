//
//  MediaPlayerConfig.h
//  MediaPlayerSDK
//
//  Created by Max on 09/03/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#ifndef MediaPlayerSDK_MediaPlayerConfig_h
#define MediaPlayerSDK_MediaPlayerConfig_h

#import <Foundation/Foundation.h>

@interface MediaPlayerConfig : NSObject

@property (nonatomic) NSString* connectionUrl;
@property (nonatomic) int       connectionNetworkProtocol;  // 0 - udp, 1 - tcp, 2 - http, 3 - https, -1 - AUTO
@property (nonatomic) int       connectionDetectionTime;    // in milliseconds
@property (nonatomic) int       connectionBufferingType;    // 0 - first time only, 1 - continues
@property (nonatomic) int       connectionBufferingTime;    // in milliseconds
@property (nonatomic) int       connectionBufferingSize;    // in bytes
@property (nonatomic) int       connectionTimeout;          // Intteruprt source if connection is not passed timeout
@property (nonatomic) int       dataReceiveTimeout;

@property (nonatomic) int       enableInterruptOnClose;		// 1 - inturrupt connection and close, 0 - do not set a interuption close operation  stream and send TEARDOWN command
@property (nonatomic) int       extraDataFilter;  			// Enable extra data filter in case RTSP

@property (nonatomic) int       decodingType;               // 0 - soft, 1 - hardware
@property (nonatomic) int       extraDataOnStart;           // 0 - no, 1 - add extradata before frame
@property (nonatomic) int       decoderLatency;             // This setting is for s/w decoder, 1 - Low latency, frames are not buffered on decoder , 0 - frames are buffered in video decoder  by default
@property (nonatomic) int       rendererType;               // 0 - egl,  1 - by hardware decoder
@property (nonatomic) int       synchroEnable;              // enable audio video synchro
@property (nonatomic) int       synchroNeedDropVideoFrames; // drop video frames if it late
@property (nonatomic) int       synchroNeedDropFramesOnFF ; // drop video frames if Fast playback(Key frame only)
@property (nonatomic) int       videoRotate;                // 0 - default, 45, 90 ,135, 180, 225, 270 correct values


@property (nonatomic) int       enableColorVideo;           // grayscale or color

@property (nonatomic) int       aspectRatioMode;            // 0 - stretch, 1 - fittoscreen with aspect ratio, 2 - crop, 3 - 100% size, 4 - zoom mode, 5 - move mode
@property (nonatomic) int       aspectRatioZoomModePercent; // value in percents
@property (nonatomic) int       aspectRatioMoveModeX;       // -1 - center, range:0-100, 0 - left side, 100 - right side
@property (nonatomic) int       aspectRatioMoveModeY;       // -1 - center, range:0-100, 0 - top side, 100 - bottom side

@property (nonatomic) int       enableAudio;                // aspect or not
@property (nonatomic) int       colorBackground;

@property (nonatomic) int       numberOfCPUCores;           // <=0 - autodetect, > 0 - will set manually
@property (nonatomic) float     bogoMIPS;                   // BogoMIPS
@property (nonatomic) NSString* sslKey;
@property (nonatomic) int       extStream;                  // Index of stream

@property (nonatomic) uint64_t  startOffest;                // AV_NOPTS_VALUE
@property (nonatomic) int       startPreroll;               // 0 - start immediatly, 1 - start - play 1 frame - pause
@property (nonatomic) NSString* startPath;
@property (nonatomic) NSString* startCookies;

@property (nonatomic) int       ffRate;                     // 1000

@property (nonatomic) int       volumeDetectMaxSamples;
@property (nonatomic) int       volumeBoost;               // 0 off; min:-30dB, max:+30dB

@property (nonatomic) int       fadeOnStart;                // 0 - audio comes straight off, audio is faded ~200ms
@property (nonatomic) int       fadeOnSeek;                 // 0 - audio comes straight off, audio is faded ~200ms
@property (nonatomic) int       fadeOnRate;                 // 0 - audio comes straight off, audio is faded ~200ms

//record parameters
@property (nonatomic) NSString*                 recordPath;
@property (nonatomic) MediaPlayerRecordFlags    recordFlags;        // 0: stopped. 1: autostart rec. see PlayerRecordFlags
@property (nonatomic) int                       recordSplitTime;    // seconds. in case PP_RECORD_SPLIT_BY_TIME
@property (nonatomic) int                       recordSplitSize;    // MB.   in case PP_RECORD_SPLIT_BY_SIZE
@property (nonatomic) NSString*                 recordPrefix;
@property (nonatomic) int64_t                   recordTrimPosStart; // in ms. (-1) not set, all duration.
@property (nonatomic) int64_t                   recordTrimPosEnd;   // in ms. (-1) not set, all duration.

//audio and subtitle default selection
@property (nonatomic) int               selectAudio;        // audio select
@property (nonatomic) int               selectSubtitle;     // subtitle. default off
@property (nonatomic) NSMutableArray*   subtitlePaths;

@property (nonatomic) MediaPlayerModes  playerMode;

// adaptive bitrate mode
@property (nonatomic) int       enableABR;                  // adaptive bitrate

@property (nonatomic) int       playbackSendPlayPauseToServer;	// default 0 - off, 1 - on: will send av_read_play/pause

// iOS specific
@property (nonatomic) int       enableInternalGestureRecognizers;	// 0 - off, 1 - pinch(zoom), 2 - pan(move). Default: (1 | 2)

@end

#endif
