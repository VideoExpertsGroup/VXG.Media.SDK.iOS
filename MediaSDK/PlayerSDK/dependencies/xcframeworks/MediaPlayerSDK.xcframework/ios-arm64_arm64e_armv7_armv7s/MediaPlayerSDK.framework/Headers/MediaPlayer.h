#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class MediaPlayer;

typedef NS_ENUM(int, MediaPlayerContentProviderLibraryType)
{
    CONTENT_PROVIDER_LIBMEDIA  = 0x00000000,
    CONTENT_PROVIDER_LIBRTSP   = 0x00000001,
    CONTENT_PROVIDER_LIBWEBRTC = 0x00000002,
};

typedef NS_ENUM(int, MediaPlayerNotifyCodes)
{
    PLP_TRIAL_VERSION               = -999,
    
	PLP_BUILD_STARTING              = 1,
	PLP_BUILD_SUCCESSFUL            = 2,
	PLP_BUILD_FAILED                = 3,
    
	PLP_PLAY_STARTING               = 4,
	PLP_PLAY_SUCCESSFUL             = 5,
	PLP_PLAY_FAILED                 = 6,
    
	PLP_CLOSE_STARTING              = 7,
	PLP_CLOSE_SUCCESSFUL            = 8,
	PLP_CLOSE_FAILED                = 9,
    
	PLP_ERROR                       = 10,
    PLP_INTERRUPTED                 = 11,
	PLP_EOS                         = 12,
	  	
    PLP_PLAY_PLAY                   = 14,
    PLP_PLAY_PAUSE                  = 15,
    PLP_PLAY_STOP                   = 16,
	  	
	PLP_SEEK_COMPLETED              = 17,
    PLP_SEEK_FAILED                 = 18,
    PLP_SEEK_STARTED                = 19,

	CP_CONNECT_STARTING             = 101,
	CP_CONNECT_SUCCESSFUL           = 102,
	CP_CONNECT_FAILED               = 103,
	CP_INTERRUPTED                  = 104,
	CP_ERROR_DISCONNECTED           = 105,
	CP_STOPPED                      = 106,
	CP_INIT_FAILED                  = 107,
	  	
	CP_RECORD_STARTED               = 108,
	CP_RECORD_STOPPED               = 109,
	CP_RECORD_CLOSED                = 110,
	  	
    CP_BUFFER_FILLED                = 111,
    CP_ERROR_NODATA_TIMEOUT         = 112,
    
	CP_SOURCE_AUDIO_DISCONTINUITY   = 113,
	CP_SOURCE_VIDEO_DISCONTINUITY   = 114,
    
	CP_START_BUFFERING              = 115,
	CP_STOP_BUFFERING               = 116,
    CP_DISCONNECT_SUCCESSFUL        = 117,
	CP_COOKIE_IS_CHANGED            = 118,
	
    CP_CONNECT_AUTH_SUCCESSFUL 		= 119,
    CP_CONNECT_AUTH_FAILED          = 120,
	
    CP_SOURCE_VIDEO_STREAMINFO_NOT_COMPLETE = 121,

	VDP_STOPPED                     = 201,
	VDP_INIT_FAILED                 = 202,
    VDP_LASTFRAME                   = 203,
	VDP_CRASH                       = 206,
    
	VRP_STOPPED                     = 300,
	VRP_INIT_FAILED                 = 301,
	VRP_NEED_SURFACE                = 302,
	VRP_FIRSTFRAME                  = 305,
    VRP_LASTFRAME                   = 306,
    VRP_FFRAME_APAUSE               = 308,
    VRP_SURFACE_ACQUIRE             = 309,
    VRP_SURFACE_LOST                = 310,
    VRP_SYNCPOINT                   = 311,

	ADP_STOPPED                     = 400,
	ADP_INIT_FAILED                 = 401,
    ADP_LASTFRAME                   = 402,
    
	ARP_STOPPED                     = 500,
	ARP_INIT_FAILED                 = 501,
	ARP_LASTFRAME                   = 502,
	ARP_VOLUME_DETECTED             = 503,
	  	
	CRP_STOPPED                     = 600,
	  	
	SDP_STOPPED                     = 701,
	SDP_INIT_FAILED                 = 702,
	SDP_LASTFRAME                   = 703,
    
};

typedef NS_ENUM(int, MediaPlayerState)
{
    MediaPlayerOpening  = 0,
    MediaPlayerOpened   = 1,
    
    MediaPlayerStarted  = 2,
    MediaPlayerPaused   = 3,
    MediaPlayerStopped  = 4,
    
    MediaPlayerClosing  = 5,
    MediaPlayerClosed   = 6
    
};

typedef NS_ENUM(int, MediaPlayerModes)
{
    PP_MODE_ALL         = -1,        //default
    PP_MODE_VIDEO       = 0x00000001,
    PP_MODE_AUDIO       = 0x00000002,
    PP_MODE_SUBTITLE    = 0x00000004,
    PP_MODE_RECORD      = 0x00000008

};

typedef NS_ENUM(int, MediaPlayerRecordFlags)
{
    RECORD_NO_START           = 0x00000000,
    RECORD_AUTO_START         = 0x00000001,
    RECORD_SPLIT_BY_TIME      = 0x00000002,
    RECORD_SPLIT_BY_SIZE      = 0x00000004,
    RECORD_DISABLE_VIDEO      = 0x00000008,
    RECORD_DISABLE_AUDIO      = 0x00000010,
    RECORD_PTS_CORRECTION     = 0x00000020,
    RECORD_FAST_START         = 0x00000040,
    RECORD_FRAG_KEYFRAME      = 0x00000080,
    RECORD_SYSTEM_TIME_TO_PTS = 0x00000100,
    RECORD_DEFINED_DURATION   = 0x00000200,
    RECORD_FRAG_CUSTOM        = 0x00000480

};

typedef NS_ENUM(int, MediaPlayerRecordStat)
{
    RECORD_STAT_LASTERROR        = 0, //last error
    RECORD_STAT_DURATION         = 1, //in msec
    RECORD_STAT_SIZE             = 2, //in bytes
    RECORD_STAT_DURATION_TOTAL   = 3, //in msec
    RECORD_STAT_SIZE_TOTAL       = 4  //in bytes
    
};

typedef NS_ENUM(int, MediaPlayerProperties)
{
    PROPERTY_RENDERED_VIDEO_FRAMES = 0,
	PROPERTY_AUDIO_VOLUME_MEAN     = 1,
	PROPERTY_AUDIO_VOLUME_MAX      = 2,
	PROPERTY_PLP_LAST_ERROR        = 3,
	PROPERTY_PLP_RESPONSE_TEXT     = 4,
	PROPERTY_PLP_RESPONSE_CODE     = 5,
    PROPERTY_PLP_COOKIE            = 6,
    PROPERTY_PLP_PTS_IN_FIRST_RTP  = 7,
    PROPERTY_PLP_PTS_IN_RANGE      = 8,
    PROPERTY_PLP_RTCP_PACKAGE      = 9,
    PROPERTY_PLP_RTCP_SR           = 10,
    PROPERTY_PLP_RTCP_RR           = 11,
    PROPERTY_BACKWARD_AUDIO_FORMAT = 12,
	PROPERTY_AUDIO_NOTCH_FILTER    = 101
};

typedef NS_ENUM(int, MediaPlayerLatencyPreset)
{
    LATENCY_PRESET_NO_PRESET     = -2,
    LATENCY_PRESET_CUSTOM_PRESET = -1,
    LATENCY_PRESET_HIGHEST       = 0,
    LATENCY_PRESET_HIGH          = 1,
    LATENCY_PRESET_MIDDLE        = 2,
    LATENCY_PRESET_LOWEST        = 3
};

/**
 *  Log levels now supported by MediaPlayer SDK
 */
typedef NS_ENUM(int, MediaPlayerLogLevel)
{
    LOG_LEVEL_COMPILED  = -1,
    LOG_LEVEL_NONE      = 0,
    LOG_LEVEL_ERROR     = 1,
    LOG_LEVEL_INFO      = 3,
    LOG_LEVEL_DEBUG     = 4,
    LOG_LEVEL_LOG       = 5,
    LOG_LEVEL_TRACE     = 7
};

typedef NS_ENUM(int, MediaPlayerGraphicLayer)
{
    GRAPHIC_OPENGL = 0,
    GRAPHIC_METAL  = 1
};

#import "MediaPlayerPlaySegment.h"
#import "MediaPlayerConfig.h"


// callback
@protocol MediaPlayerCallback<NSObject>

@required
- (int) Status: (MediaPlayer*)player
         args: (int)arg;

- (int) OnReceiveData: (MediaPlayer*)player
              buffer: (void*)buffer
                size: (int)  size
                 pts: (long long) pts;

// subtitle data
@optional
- (int) OnReceiveSubtitleString: (MediaPlayer*)player
                           data: (NSString*)data
                       duration: (uint64_t)duration;
- (int) OnReceiveSubtitleBitmap: (MediaPlayer*)player
                           data: (void*)data
                           size: (int)  size
                           left: (int)  left
                            top: (int)  top
                          width: (int)  width
                         height: (int)  height
                    video_width: (int)  video_width
                   video_height: (int)  video_height
                            pts: (long long) pts
                       duration: (long long) duration;
- (int) OnReceiveSubtitleBinary: (MediaPlayer*)player
                           data: (void*)data
                           size: (int)  size
                            pts: (long long) pts
                       duration: (long long) duration;
- (int) OnReceiveSubtitleEventClear;

// data from various parts of media pipeline
@optional
- (int) OnVideoSourceFrameAvailable: (MediaPlayer*)player
                             buffer: (void*)buffer
                               size: (int)  size
                                pts: (long long) pts
                                dts: (long long) dts
                       stream_index: (int)  stream_index
                             format: (int)  format;

- (int) OnAudioSourceFrameAvailable: (MediaPlayer*)player
                             buffer: (void*)buffer
                               size: (int)  size
                                pts: (long long) pts
                                dts: (long long) dts
                       stream_index: (int)  stream_index
                             format: (int)  format;

// format_fourcc: color space in fourcc format for example: 'BGRA', 'I420', 'NV12' ect.
- (int) OnVideoRendererFrameAvailable: (MediaPlayer*)player
                               buffer: (void*)buffer
                                 size: (int)  size
                        format_fourcc: (char*)format_fourcc
                                width: (int)  width
                               height: (int)  height
                        bytes_per_row: (int)  bytes_per_row
                                  pts: (long long) pts
                            will_show: (int)  will_show;
- (int) OnAudioRendererFrameAvailable: (MediaPlayer*) player
                               buffer: (void*) buffer
                                 size: (int) size
                               format: (AudioStreamBasicDescription) format
                                  pts: (long long) pts;


// data from various parts of media pipeline
@optional
- (int) OnAudioMicrophoneFrameAvailable: (MediaPlayer*) player
                                  frame: (nonnull CMSampleBufferRef) frame
                          averageLevels: (nullable float*) avrLevels
                      averageLevelsSize: (size_t) avrLevelsSize;

// webrtc callbacks
@optional
- (int) OnWebRTCOfferAvailable: (MediaPlayer*)player
                      offerSDP: (NSString*)offer;
- (int) OnWebRTCAnswerAvailable: (MediaPlayer*)player
                      answerSDP: (NSString*)answer;
- (int) OnWebRTCIceCandidateAvailable: (MediaPlayer*)player
                         iceCandidate: (NSString*)candidate
                        sdpMLineIndex: (int)index;

//
@optional
- (int) OnVideoAspectsChanged: (MediaPlayer*)player
              withOrientation: (int)orientation;

// Timeshift
@optional
- (int) OnTimeshiftStartPrebufferng: (MediaPlayer*)player
                          withValue: (long long)value;
@optional
- (int) OnTimeshiftProgressPrebufferng: (MediaPlayer*)player
                             withValue: (long long)value;
@optional
- (int) OnTimeshiftEndPrebufferng: (MediaPlayer*)player
                        withValue: (long long)value;

@end

// main functionailty
@interface MediaPlayer : NSObject

// initializer
- (id) init:(CGRect) bounds;
- (id) initWithBounds: (CGRect)bounds
      andGraphicLayer: (MediaPlayerGraphicLayer)layer;

// VideoView
- (UIView *) contentView;

- (void) Open: (MediaPlayerConfig*)config
     callback: (id<MediaPlayerCallback>)callback;
- (void) Close;

- (MediaPlayerConfig*) getConfig;
// used for apply a some config changes on working player (after Open)
- (int) applyConfig;

- (MediaPlayerState) getState;

- (int) getPropInt: (MediaPlayerProperties)prop;
- (int64_t) getPropInt64: (MediaPlayerProperties)prop;
- (NSString*) getPropString: (MediaPlayerProperties)prop;
- (char*) getPropBinary: (MediaPlayerProperties)prop
            buffer_size: (int32_t*)buffer_size;

- (int) updateView;

- (void) Play: (int)drawNumberOfFramesAndPause; // now supported only drawNumberOfFramesAndPause:1 - draw one frame and pause
- (void) Pause;
- (void) PauseWithFlush;
- (void) PauseWithBuffering;
- (void) Stop;

- (void) setFFRate: (int)rate;

// Get video shot RGBA32
// Parameters:
// buffer - allocated buffer for shot
// buffer_size - in: allocated before buffer size,
//              out: real image size
// width, height - in: desired scale size. -1 for original.
//                out: real image sizes
//               note: work only for software decoding
// bytes_per_row - image bytes ber row
//
// Return: 0 - ok, (-1) - error, (-2) - need more buffer space for image
- (int) getVideoShot: (void*)buffer
         buffer_size: (int32_t*)buffer_size
               width: (int32_t*)width
              height: (int32_t*)height
       bytes_per_row: (int32_t*)bytes_per_row;

- (void) setStreamPosition: (int64_t)lTime;
- (int64_t) getStreamDuration;
- (int64_t) getStreamPosition;
- (int64_t) getRenderPosition;
- (void) setLiveStreamPath: (NSString*)path;
- (void) setStartLiveStreamPosition: (int64_t)offset;
- (void) setLiveStreamPosition: (int64_t)lTime;
- (BOOL) getLiveStreamPosition: (int64_t*)first
                       current: (int64_t*)current
                          last: (int64_t*)last
                      duration: (int64_t*)duration
                   stream_type: (int*)stream_type
               timeshift_first: (int64_t*)timeshift_first
             timeshift_current: (int64_t*)timeshift_current
                timeshift_last: (int64_t*)timeshift_last
            timeshift_duration: (int64_t*)timeshift_duration
         timeshift_stream_type: (int*)timeshift_stream_type;

- (void) toggleMute: (BOOL)mute;

- (void) setKey: (NSString*)key;

- (int) getDataDelayOnSource;
- (int) getDataBitrateOnSource;

- (float) getStatFPS;

- (NSString*) getStreamInfo;

- (int) subtitleGetCount;
- (int) subtitleSelect: (int)stream_i;
- (int) subtitleGetSelected;
- (int) subtitleSourceAdd: (NSString*)path;
- (int) subtitleSourceRemove: (NSString*)path;

// record support
- (void) recordSetup: (NSString*)path
               flags: (MediaPlayerRecordFlags)flags
           splitTime: (int32_t)splitTime
           splitSize: (int32_t)splitSize
              prefix: (NSString*)prefix;

- (void) recordStart;
- (void) recordStop;

- (NSString*) recordGetFileName: (int32_t)param; //0 - last stopped; 1 - last started
- (int64_t) recordGetStat: (MediaPlayerRecordStat)param;


// Helper methods
- (Boolean) isHardwareDecoding;

// Get available directions for move mode
// Return: possible move 0 - nothing, 1 - to left, 2 - to right, 4 - to top, 8 - to bottom
- (int) getAvailableDirectionsForAspectRatioMoveMode;

// Get view sizes and video aspects like video width/height, aspect calculations etc.
// Parameters:
// view_orientation - current view orientation
// view_width - current view width
// view_height - current view height
// video_width - video width
// video_height - video height
// aspect_left - left video position after current aspect ratio mode calculations
// aspect_top - top video position after current aspect ratio mode calculations
// aspect_width - video width after current aspect ratio mode calculations
// aspect_height - video height after current aspect ratio mode calculations
// aspect_zoom - current zoom coefficient
- (void)getViewSizesAndVideoAspects:(int*)view_orientation
                         view_width:(int*)view_width
                        view_height:(int*)view_height
                        video_width:(int*)video_width
                       video_height:(int*)video_height
                        aspect_left:(int*)aspect_left
                         aspect_top:(int*)aspect_top
                       aspect_width:(int*)aspect_width
                      aspect_height:(int*)aspect_height
                        aspect_zoom:(int*)aspect_zoom;


// Get inernal buffers states
// Parameters:
// source_videodecoder_filled - bytes filled in buffer between source and video decoder
// source_videodecoder_size - buffer size between source and video decoder
// videodecoder_videorenderer_filled - buffer size between video decoder and video renderer
// videodecoder_videorenderer_size - buffer size between video decoder and video renderer
// source_audiodecoder_filled - buffer size between source and audio decoder
// source_audiodecoder_size - buffer size between source and audio decoder
// audiodecoder_audiorenderer_filled - buffer size between audio decoder and audio renderer
// audiodecoder_audiorenderer_size - buffer size between audio decoder and audio renderer
- (void)getInternalBuffersState:(int*)source_videodecoder_filled
           source_videodecoder_size:(int*)source_videodecoder_size
       source_videodecoder_num_frms:(int*)source_videodecoder_num_frms
  videodecoder_videorenderer_filled:(int*)videodecoder_videorenderer_filled
    videodecoder_videorenderer_size:(int*)videodecoder_videorenderer_size
videodecoder_videorenderer_num_frms:(int*)videodecoder_videorenderer_num_frms
         source_audiodecoder_filled:(int*)source_audiodecoder_filled
           source_audiodecoder_size:(int*)source_audiodecoder_size
  audiodecoder_audiorenderer_filled:(int*)audiodecoder_audiorenderer_filled
    audiodecoder_audiorenderer_size:(int*)audiodecoder_audiorenderer_size
                      video_latency:(int*)video_latency
                      audio_latency:(int*)audio_latency;

- (void) addPlaySegment:(MediaPlayerPlaySegment*) segment;
- (void) removePlaySegment:(MediaPlayerPlaySegment*) segment;

- (int) sendBackwardAudioBuffer: (uint8_t*)buffer
                       withSize: (int32_t)size
                         andPts: (int64_t)pts;

- (int) setRtspPlaybackScale: (double)scale;

// WebRTC
- (int) webrtcSetAnswer: (NSString*)answer;
- (int) webrtcSetICECandidate: (NSString*)candidate
            withSDPMLineIndex: (int)index;

// Draw over Video
// Add draw object for display over video in desired rectangle
- (CALayer*) drawAddObjectOverVideo: (CALayer*)object
                    inBoundsOnVideo: (CGRect)boundsOnVideo;

// Remove draw object from video
- (void) drawRemoveObjectFromVideo: (CALayer*)object;

// Remove all drawing objects from video
- (void) drawRemoveAllObjectsFromVideo;

// Update all draw objects
- (void) drawRefreshAllObjectsOnVideo;

// Shraed media usage
+ (int) isMediaLibraryInited;
+ (void) setMediaLibraryInited:(Boolean) val;

+ (NSString*) getVersion;

@end














