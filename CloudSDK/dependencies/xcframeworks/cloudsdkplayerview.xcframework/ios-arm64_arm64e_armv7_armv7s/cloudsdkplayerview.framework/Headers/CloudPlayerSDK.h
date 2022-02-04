//
//  CloudPlayerSDK.h
//  CloudSDK
//
//  Created by user on 17/01/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//
#import "CloudCommonSDK.h"
#import <AVFoundation/AVFoundation.h>


@protocol  ICloudCObject
- (Boolean) HasError;
- (int) GetResultInt;
- (NSString*) GetResultStr;
@end

typedef NS_ENUM(int, CloudPlayerEvent) {
    TRIAL_VERSION   = -999,
    CONNECTING      = 0,
    CONNECTED       = 1,
    STARTED         = 2,
    PAUSED          = 3,
    CLOSED          = 6,
    EOS             = 12,
    OUT_OF_RANGE    = 13,
    SEEK_COMPLETED  = 17,
    SEEK_FAILED     = 18,
    SEEK_STARTED    = 19,
    ERROR           = 105,
    SOURCE_CHANGED  = 3000,
    POSITION_JUMPED = 3001,
    SOURCE_UNREACHABLE = 19000,
    SOURCE_ONLINE      = 19001,
    SOURCE_OFFLINE     = 19002,
    VIDEO_FIRST_FRAME  = 20000,
    RECORD_STARTED     = 20100,
    RECORD_STOPPED     = 20101,
    RECORD_CLOSED      = 20102,
    SOURCE_CHANGED_WAIT_RECORDS_UPLOAD_STARTED  = 20103,
    SOURCE_CHANGED_WAIT_RECORDS_UPLOAD_CONTINUE = 20104,
    SOURCE_CHANGED_WAIT_RECORDS_UPLOAD_STOPPED  = 20105
};

typedef NS_ENUM(int, CPlayerStates)
{
    CPlayerStateConnecting = 0,
    CPlayerStateConnected  = 1,
    CPlayerStateStarted    = 2,
    CPlayerStatePaused     = 3,
    CPlayerStateClosed     = 4,
    CPlayerStateEOS        = 12,
};

typedef NS_ENUM(int, CPlayerModes)
{
    CPlayerModeLive     = 1 << 0,
    CPlayerModePlayback = 1 << 1
};

typedef NS_ENUM(int, CCloudApiProtocolDefaults) {
    CCloudApiProtocolDefaultsUNSECURE = 0,
    CCloudApiProtocolDefaultsSECURE = 1
};

typedef NS_ENUM(int, CCloudApiProtocolType) {
    CCloudApiProtocolTypeHTTP = 0,
    CCloudApiProtocolTypeHTTPS = 1
};

typedef NS_ENUM(int, CPlayerLiveUrlType) {
    CPlayerLiveUrlTypeDefault = 0,
    CPlayerLiveUrlTypeRTMP = 1,
    CPlayerLiveUrlTypeRTMPS = 2,
    CPlayerLiveUrlTypeHLS = 3,
    CPlayerLiveUrlTypeRTSP = 4
};

typedef void (^CPlayerCallback)(CloudPlayerEvent status_code, id<ICloudCObject> player);

@protocol ICloudCPlayerCallback
-(void) Status: (CloudPlayerEvent) status_code object: (id<ICloudCObject>) player;
-(int) OnAudioMicrophoneFrameAvailable: (id<ICloudCObject>)player
                                 frame: (nonnull CMSampleBufferRef)frame
                         averageLevels: (nullable float*)avrLevels
                     averageLevelsSize: (size_t)avrLevelsSize;
@end

// protocol
@protocol CloudPlayerSDKDelegate<NSObject>

@optional
-(int) OnPlayingPositionChanged:(long long)position
                   withDuration:(long long)duration
                 withRangeStart:(long long)rangeStart
                   withRangeEnd:(long long)rangeEnd;
-(int) onSharedTokenWillExpireIn:(long long)deltaTimeInMs;

@end

@interface CPlayerConfig : NSObject
-(instancetype) init;
-(void) visibleControls: (Boolean) bControls;
-(Boolean) getVisibleControls;
-(void) videoDecoderType: (int) type;
-(int) getVideoDecoderType;
-(void) aspectRatio: (int) mode;
-(int)  getAspectRatio;
-(void) zoomAspectRatio: (int) zoom;
-(int) getZoomAspectRatio;
-(void) zoomMinAspectRatio: (int) zoom;
-(int) getZoomMinAspectRatio;
-(void) zoomMaxAspectRatio: (int) zoom;
-(int) getZoomMaxAspectRatio;
-(void) moveXAspectRatio: (int) x;
-(int) getMoveXAspectRatio;
-(void) moveYAspectRatio: (int) y;
-(int) getMoveYAspectRatio;
-(void) setMinLatency: (long) latency;
-(long) getMinLatency;
-(void) setBufferOnStart:(int) buffering_time;
-(int) getBufferOnStart;
-(void) setLicenseKey: (NSString*) license;
-(NSString*) getLicenseKey;

-(void) setFFRate: (int) rate;
-(int) getFFRate;

-(void) setEnableInternalAudioSessionConfigure: (int) enable;
-(int) getEnableInternalAudioSessionConfigure;
-(void) setInternalAudioSessionMode: (NSString*) mode;
-(NSString*) getInternalAudioSessionMode;
-(void) setInternalAudioSessionCategory: (NSString*) category;
-(NSString*) getInternalAudioSessionCategory;
-(void) setInternalAudioSessionCategoryOptions: (NSUInteger) options;
-(NSUInteger) getInternalAudioSessionCategoryOptions;
-(void) setEnableInternalAudioUnitVPIO: (int) enable;
-(int) getEnableInternalAudioUnitVPIO;

-(void) setLatencyPreset: (int) preset;
-(int) getLatencyPreset;
- (void) setConnectionDetectionTime: (int) val;
- (int) getConnectionDetectionTime;
- (void) setConnectionNetworkProtocol: (int) val;
- (int) getConnectionNetworkProtocol;
- (void) setConnectionBufferingTime: (int) val;
- (int) getConnectionBufferingTime;

- (void) setPlayerType: (int) val;
- (int) getPlayerType;

-(void) setConnectionMonitorType: (int) type;
-(int) getConnectionMonitorType;

-(void) setLiveUrlType: (CPlayerLiveUrlType) type;
-(CPlayerLiveUrlType) getLiveUrlType;

-(void) setWorkaroundForceLiveUrlTypeForTokenWithPath: (CPlayerLiveUrlType) type;
-(CPlayerLiveUrlType) getWorkaroundForceLiveUrlTypeForTokenWithPath;

-(void) setWorkaroundWaitWhileRecordsUploaded: (int) valueInMs;
-(int) getWorkaroundWaitWhileRecordsUploaded;

-(void) setAdvancedOptionReconnectOnHttpError: (NSString*) codes;
-(NSString*) getAdvancedOptionReconnectOnHttpError;

-(void) setCloudApiPort: (int) port;
-(int) getCloudApiPort;

-(void) setCloudApiProtocolType: (CCloudApiProtocolType) type;
-(CCloudApiProtocolType) getCloudApiProtocolType;

-(void) setCloudApiProtocolDefaults: (CCloudApiProtocolDefaults) type;

-(void) setShareTokenExpireCheckingTickRate: (long long) rateInMs;
-(long long) getShareTokenExpireCheckingTickRate;

-(void) setShareTokenExpireNotificationDeltaTimeGuard: (long long) deltaTimeGuardInMs;
-(long long) getShareTokenExpireNotificationDeltaTimeGuard;

+ (void)setLogLevel:(int)newValue;
+ (void)setMediaPlayerLogLevelForObjcPart:(int)objcValue forNativePart:(int)nativeValue forMediaPart:(int)mediaValue;

@end

@interface CloudPlayerSDK : NSObject<ICloudCObject>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithParams: (UIView*) view
                      config : (CPlayerConfig*) config
                    callback : (CPlayerCallback) callbacks;

-(instancetype)initWithParams:(UIView *)view
                       config:(CPlayerConfig *)config
            protocol_callback: (id<ICloudCPlayerCallback>)callbacks;

-(void) setDelegate: (id<CloudPlayerSDKDelegate>) delegate;
-(id<CloudPlayerSDKDelegate>) getDelegate;

-(int) setSource: (NSString*) source;
-(int) setSource: (NSString*) source withPosition:(long long)position;
-(int) setConfig: (CPlayerConfig*) config;
-(CPlayerConfig*) getConfig;
-(void) play;
-(void) pause;
-(void) close;
-(CPlayerStates) getState;
-(void) setPrefferedMode: (CPlayerModes)mode;
-(CPlayerModes) getPrefferedMode;
-(void) setPosition:(long long) nPosition;
-(long long) getPosition;
-(Boolean) isLive;
-(void) mute:(Boolean) bMmute;
-(Boolean) isMute;
-(void) setVolume:(int) vol;
-(int) getVolume;

-(void) showTimeline:(UIView*) vwTimeline;
-(void) showTimeline:(UIView*)timelineContainer withCalendarContainer:(UIView*)calendarContainer;
-(CTimelineConfig*) getTimelineConfig;
-(void) applyTimelineConfig;
-(void) setTimelineStyle:(UIColor*)main lineColor:(UIColor*)line textColor:(UIColor*)text textBackgroundColor:(UIColor*)textBackground trackColor:(UIColor*)track knobColor:(UIColor *)knob strokeColor:(UIColor*)stroke rangeColor:(UIColor*)range;
-(void) setTimelineStyle:(CTimelineStyle*)style;
-(CTimelineStyle*) getTimelineStyle;
-(void) setTimelineScale:(CTimelineScaleType)scale;
-(CTimelineScaleType) getTimelineScale;
-(void) setRange: (int64_t) start_time end_time: (int64_t) end_time;
-(void) getRange: (int64_t*) start_time end_time: (int64_t*) end_time;
-(void) unsetRange;
-(void) hideTimeline;

-(long long) getID;

-(NSString*) getPreviewURLSync;
-(void) getPreviewURL:(void (^)(NSObject* obj, int status)) complete;
-(CPreviewImage*) getPreviewImageSync;
-(void) getPreviewImage:(void (^)(NSObject *, int))complete;
-(int) getVideoShot: (void*)buffer
        buffer_size: (int32_t*)buffer_size
              width: (int32_t*)width
             height: (int32_t*)height
      bytes_per_row: (int32_t*)bytes_per_row;
- (int) getViewSizesAndVideoAspects: (int32_t*)view_orientation
                         view_width: (int32_t*)view_width
                        view_height: (int32_t*)view_height
                        video_width: (int32_t*)video_width
                       video_height: (int32_t*)video_height
                        aspect_left: (int32_t*)aspect_left
                         aspect_top: (int32_t*)aspect_top
                       aspect_width: (int32_t*)aspect_width
                      aspect_height: (int32_t*)aspect_height
                        aspect_zoom: (int32_t*)aspect_zoom;
- (void) setFFRate: (int32_t)rate;
- (void) updateView;

-(long long) getTimeLive;
-(void) setTimeLive:(long long) utc_time;
-(void) setTimezone:(NSString*) tz;
-(NSString*) getTimezone;
-(void) setName: (NSString*) name;
-(NSString*) getName;
-(CCStatus) getStatus;
-(NSDictionary*) getEventsInfo;
-(Boolean) getPublic;
-(void) setPublic: (Boolean) isPublic;
-(Boolean) isOwner;

-(CCRecordingMode) getRecordingMode;
-(void) setRecordingMode:(CCRecordingMode) rec_mode;

-(CCPrivacyMode) getPrivacyMode;
-(void) setPrivacyMode: (CCPrivacyMode) mode;

-(CTimeline*) getTimelineSync: (long long)start  end: (long long)end;
-(int) getTimeline: (long long)start end: (long long)end onComplete: (void (^)(NSObject *, int))complete;
-(NSMutableArray<NSString*> *) getActivitySync:(Boolean)isCameraId
                                         start:(long long)start
                                           end:(long long)end
                                        events:(NSString*)events
                                    boundstime:(NSNumber*)isBoundstime
                                   daysincamtz:(NSNumber*)isDaysincamtz
                                         limit:(int)limit
                                        offset:(int)offset;
-(int) getActivity:(Boolean)isCameraId
             start:(long long)start
               end:(long long)end
            events:(NSString*)events
        boundstime:(NSNumber*)isBoundstime
       daysincamtz:(NSNumber*)isDaysincamtz
             limit:(int)limit
            offset:(int)offset
        onComplete:(void (^)(NSObject *, int))complete;
-(NSMutableArray<NSString*> *) getCalendarSync:(long long)start end:(long long)end limit:(int)limit offset:(int)offset;
-(int) getCalendar:(long long)start end:(long long)end limit:(int)limit offset:(int)offset onComplete:(void (^)(NSObject *, int))complete;
-(NSDictionary*) getImagesSync: (long long)start end: (long long)end limit:(uint) limit offset:(uint) offset order: (Boolean)is_ascending;
-(int) getImages: (long long)start end: (long long)end limit: (uint) limit offset:(uint) offset order: (Boolean)is_ascending onComplete:(void (^)(NSObject *, int))complete;
-(NSDictionary*) getTimelineThumbnailsSync: (long long)start  end: (long long)end order: (Boolean)is_ascending;
-(int) getTimelineThumbnails: (long long)start end: (long long)end order: (Boolean)is_ascending onComplete: (void (^)(NSObject *, int))complete;
//events
-(NSDictionary*) getEventsSync: (long long)start end: (long long)end limit: (long) limit offset:(long) offset events:(NSString*) events order: (Boolean)is_ascending;
-(int) getEvents: (long long)start end: (long long)end limit: (long) limit offset:(long) offset events:(NSString*) events order: (Boolean)is_ascending onComplete:(void (^)(NSObject *, int))complete;
-(int) getEvent: (long long) eventid onComplete:(void (^)(NSObject *, int))complete;
-(int) deleteEvent: (long long) eventid onComplete:(void (^)(NSObject *, int))complete;
//clips
-(int) getClips: (long long)start end: (long long)end limit: (long) limit offset:(long) offset order: (Boolean)is_ascending onComplete:(void (^)(NSObject *, int))complete;
-(int) createClip: (NSString*) title start: (long long)start end: (long long)end deleteAt: (long long ) delete_at  onComplete:(void (^)(NSObject *, int))complete ;
-(int) getClip: (long long) clipid onComplete:(void (^)(NSObject *, int))complete ;
-(int) deleteClip: (long long) clipid onComplete:(void (^)(NSObject *, int))complete;
//ptz
-(void) getPTZ: (void (^)(NSObject *, int))complete;
-(void) executePTZ: (NSString*) action timeout:(NSNumber*) timeout onComplete: (void (^)(NSObject *, int))complete;
//settings
-(void) getStreams:    (void (^)(NSObject* obj, int status)) complete;
-(void) getVideoStreamByVsid:  (NSString*) vsid callback:  (void (^)(NSObject* obj, int status)) complete;
-(void) updateVideoStreamByVsid: (NSString*) vsid
                        resolution_width: (uint32_t) rwidth
                       resolution_height: (uint32_t) rheight
                                     fps: (float) fps
                                     gop: (uint32_t) gop
                                complete: (void (^)(NSObject* obj, int status)) complete;

-(void) getCameraVideoSettings: (void (^)(NSObject* obj, int status)) complete;
-(void) updateCameraVideoSettings:  (NSDictionary*) vsettings complete: (void (^)(NSObject* obj, int status)) complete;
-(void) getCameraOSD:  (void (^)(NSObject* obj, int status)) complete;
-(void) updateCameraOSD: (NSDictionary*) osdsettings complete: (void (^)(NSObject* obj, int status)) complete;
-(void) getCameraMotionDetection: (void (^)(NSObject* obj, int status)) complete;
-(void) updateCameraMotionDetection:  (NSDictionary*) settings complete: (void (^)(NSObject* obj, int status)) complete;
-(void) updateCameraAudio:  (NSDictionary*) settings complete: (void (^)(NSObject* obj, int status)) complete;
-(void) getCameraAudio:  (void (^)(NSObject* obj, int status)) complete;

-(void) triggerEvent:(NSString*)name
            withTime:(NSString*)time
            withMeta:(NSDictionary*)meta
            complete:(void (^)(NSObject* obj, int status))complete;

//wifi settings
-(void) getCameraWifiListLimit: (unsigned int) limit
                            offset: (unsigned int) offset
                      callback: (void (^)(NSObject* obj, int status)) complete ;
-(void) updateCameraWifiList: (void (^)(NSObject* obj, int status)) complete ;
-(void) getCameraSelectedWifi: (void (^)(NSObject* obj, int status)) complete ;
-(void) setCameraSelectedWifi: (NSDictionary*) wifiInfo
                     callback: (void (^)(NSObject* obj, int status)) complete ;

-(NSString*) getBackwardUrl;
-(void) getLiveUrls: (void (^)(NSObject *, int))complete;

-(void) setLngLtdBounds:(double) latitude : (double)longitude;
-(double) getLat;
-(double) getLng;

-(Boolean) HasError;
-(int) GetResultInt;
-(NSString*) GetResultStr;

-(void) setProxyDelegate: (id<CloudProxyNetworkRequests>) proxyRequests;

-(int) refreshSync;
-(int) saveSync;
-(int) refresh: (void (^)(NSObject* obj, int status)) complete;
-(int) save: (void (^)(NSObject* obj, int status)) complete;

-(int) GetStatusCallbackLastParam;

+(NSString*) getVersion;

@end
