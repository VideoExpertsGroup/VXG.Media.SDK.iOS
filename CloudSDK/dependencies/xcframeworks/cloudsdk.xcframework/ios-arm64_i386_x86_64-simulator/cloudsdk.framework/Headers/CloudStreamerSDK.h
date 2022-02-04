//
//  CloudStreamerSDK.h
//  CloudSDK
//
//  Created by user on 17/01/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import "CloudCommonSDK.h"

typedef NS_ENUM(int, CloudStreamerSDKApiProtocolDefaults) {
    CloudStreamerSDKApiProtocolDefaultsUNSECURE = 0,
    CloudStreamerSDKApiProtocolDefaultsSECURE = 1
};

typedef NS_ENUM(int, CloudStreamerSDKApiProtocolType) {
    CloudStreamerSDKApiProtocolTypeHTTP = 0,
    CloudStreamerSDKApiProtocolTypeHTTPS = 1
};

typedef NS_ENUM(int, CloudStreamerSDKCameraApiProtocolType) {
    CloudStreamerSDKCameraApiProtocolTypeWS = 0,
    CloudStreamerSDKCameraApiProtocolTypeWSS = 1
};

typedef NS_ENUM(int, CloudStreamerSDKCameraMediaProtocolType) {
    CloudStreamerSDKCameraMediaProtocolTypeRTMP = 0,
    CloudStreamerSDKCameraMediaProtocolTypeRTMPS = 1
};

@interface CloudStreamerSDKConfig : NSObject

-(void) setApiPort: (int) port;
-(int) getApiPort;

-(void) setCameraApiPort: (int) port;
-(int) getCameraApiPort;

-(void) setApiProtocolType: (CloudStreamerSDKApiProtocolType) type;
-(CloudStreamerSDKApiProtocolType) getApiProtocolType;

-(void) setCameraApiProtocolType: (CloudStreamerSDKCameraApiProtocolType) type;
-(CloudStreamerSDKCameraApiProtocolType) getCameraApiProtocolType;

-(void) setCameraMediaProtocolType: (CloudStreamerSDKCameraMediaProtocolType) type;
-(CloudStreamerSDKCameraMediaProtocolType) getCameraMediaProtocolType;

-(void) setApiProtocolDefaults: (CloudStreamerSDKApiProtocolDefaults) type;

@end


typedef NS_ENUM(int, CloudStreamerEvent) {
    CS_STARTED         = 1,
    CS_STOPED          = 2,
    CS_ERROR           = 3,
    CS_FILE_UPLOADED   = 4,
    CS_CAMERACONNECTED = 3000,
};

typedef void (^CStreamerCallback)(CloudStreamerEvent status_code, NSString* info);

@protocol ICloudCStreamerCallback<NSObject>
@optional
-(void) onStarted: (NSString*) url;
-(void) onStopped;
-(void) onError:(int) err;
-(void) onCameraConnected;
-(void) onConfigured: (NSString*) sid pwd: (NSString*) pwd;
-(void) onAdditionalInfo: (NSDictionary*) info;
@end;

@interface CloudStreamerSDK : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithParams: (id<ICloudCStreamerCallback>) callbacks;
-(instancetype)initWithStatusCallback: (CStreamerCallback) callbacks;

-(CloudStreamerSDKConfig*) getSreamerConfig;
-(int) setSource: (NSString*) access_token;

-(int) setPreviewImage: (UIImage*) preview;
-(int) setConfig: (NSString*) config;
-(NSString*) getConfig;

-(void) Start;
-(void) Stop;

-(void) setSid: (NSString*) sid andPwd: (NSString*) pwd;

-(long long) getID;
-(NSString*) getPreviewURLSync;
-(void) getPreviewURL:(void (^)(NSObject* obj, int status)) complete;
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

-(void) setLngLtdBounds:(double) latitude : (double)longitude;
-(double) getLat;
-(double) getLng;

- (Boolean) HasError;
- (int) GetResultInt;
- (NSString*) GetResultStr;

-(int) refreshSync;
-(int) saveSync;
-(int) refresh: (void (^)(NSObject* obj, int status)) complete;
-(int) save: (void (^)(NSObject* obj, int status)) complete;

-(void) putTimelineThumbnail: (UIImage*) img date:(NSDate*) date;
-(void) putTimelineVideoSegment: (NSString*) segmentPath startDate:(NSDate*) sdate endDate:(NSDate*) edate;
-(void) getTimelineVideoSegment: (NSDate*) sdate endDate:(NSDate*) edate onComplete: (void (^)(NSObject *, int))complete;
-(void) deleteTimelineVideoSegment :(NSDate *)sdate endDate:(NSDate *)edate onComplete:(void (^)(NSObject *, int))complete;

+(NSString*) getVersion;

@end
