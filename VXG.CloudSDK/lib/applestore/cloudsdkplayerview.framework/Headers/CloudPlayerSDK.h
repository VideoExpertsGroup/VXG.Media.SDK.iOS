//
//  CloudPlayerSDK.h
//  CloudSDK
//
//  Created by user on 17/01/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//
#import "CloudCommonSDK.h"


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
    ERROR           = 105,
    SOURCE_CHANGED  = 3000,
    POSITION_JUMPED = 3001,
    SOURCE_UNREACHABLE = 19000,
    SOURCE_ONLINE      = 19001,
    SOURCE_OFFLINE     = 19002,
    VIDEO_FIRST_FRAME  = 20000,
    RECORD_STARTED     = 20100,
    RECORD_STOPPED     = 20101,
    RECORD_CLOSED      = 20102
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

typedef void (^CPlayerCallback)(CloudPlayerEvent status_code, id<ICloudCObject> player);

@protocol ICloudCPlayerCallback
-(void) Status: (CloudPlayerEvent) status_code object: (id<ICloudCObject>) player;
@end


@interface CPlayerConfig : NSObject
-(instancetype) init;
-(void) visibleControls: (Boolean) bControls;
-(Boolean) getVisibleControls;
-(void) aspectRatio: (int) mode;
-(int)  getAspectRatio;
-(void) zoomAspectRatio: (int) zoom;
-(int) getZoomAspectRatio;
-(void) setMinLatency: (long) latency;
-(long) getMinLatency;
-(void) setBufferOnStart:(int) buffering_time;
-(int) getBufferOnStart;
-(void) setLicenseKey: (NSString*) license;
-(NSString*) getLicenseKey;

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

-(long long) getTimeLive;
-(void) setTimeLive:(long long) utc_time;
-(void) setTimezone:(NSString*) tz;
-(NSString*) getTimezone;
-(void) setName: (NSString*) name;
-(NSString*) getName;
-(CCStatus) getStatus;
-(Boolean) getPublic;
-(void) setPublic: (Boolean) isPublic;
-(Boolean) isOwner;

-(CCRecordingMode) getRecordingMode;
-(void) setRecordingMode:(CCRecordingMode) rec_mode;

-(CTimeline*) getTimelineSync: (long long)start  end: (long long)end;
-(int) getTimeline: (long long)start end: (long long)end onComplete: (void (^)(NSObject *, int))complete;
-(NSMutableArray<NSString*> *) getCalendarSync:(long long)start end:(long long)end limit:(int)limit offset:(int)offset;
-(int) getCalendar:(long long)start end:(long long)end limit:(int)limit offset:(int)offset onComplete:(void (^)(NSObject *, int))complete;
-(NSDictionary*) getImagesSync: (long long)start end: (long long)end limit:(uint) limit offset:(uint) offset order: (Boolean)is_ascending;
-(int) getImages: (long long)start end: (long long)end limit: (uint) limit offset:(uint) offset order: (Boolean)is_ascending onComplete:(void (^)(NSObject *, int))complete;
-(NSDictionary*) getTimelineThumbnailsSync: (long long)start  end: (long long)end order: (Boolean)is_ascending;
-(int) getTimelineThumbnails: (long long)start end: (long long)end order: (Boolean)is_ascending onComplete: (void (^)(NSObject *, int))complete;
-(NSDictionary*) getEventsSync: (long long)start end: (long long)end limit: (long) limit offset:(long) offset events:(NSString*) events order: (Boolean)is_ascending;
-(int) getEvents: (long long)start end: (long long)end limit: (long) limit offset:(long) offset events:(NSString*) events order: (Boolean)is_ascending onComplete:(void (^)(NSObject *, int))complete;


-(void) setLngLtdBounds:(double) latitude : (double)longitude;
-(double) getLat;
-(double) getLng;

-(Boolean) HasError;
-(int) GetResultInt;
-(NSString*) GetResultStr;

-(int) refreshSync;
-(int) saveSync;
-(int) refresh: (void (^)(NSObject* obj, int status)) complete;
-(int) save: (void (^)(NSObject* obj, int status)) complete;

@end
