//
//  ScrubberView.h
//  cloudsdk.timeline.view
//
//  Created by Max on 22/10/2017.
//  Copyright © 2017 vxg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, ScrubberApiProtocolDefaults) {
    ScrubberApiProtocolDefaultsUNSECURE = 0,
    ScrubberApiProtocolDefaultsSECURE = 1
};

typedef NS_ENUM(int, ScrubberApiProtocolType) {
    ScrubberApiProtocolTypeHTTP = 0,
    ScrubberApiProtocolTypeHTTPS = 1
};

typedef NS_OPTIONS(int, ScrubberControls) {
    SCRUBBER_CONTROL_STUB = 1 << 0
};

typedef NS_ENUM(int, ScrubberInternalDataSourceType) {
    SCRUBBER_INTERNAL_DATASOURCE_TYPE_EVENTS = 0,
    SCRUBBER_INTERNAL_DATASOURCE_TYPE_RECORDS = 1,
    SCRUBBER_INTERNAL_DATASOURCE_TYPE_TIMELINE = 2,
};

// config for scrubber
@interface ScrubberConfig : NSObject

// controls visibility
@property (nonatomic) ScrubberControls controls;
@property (nonatomic) ScrubberInternalDataSourceType dataSourceType;

// Appearance settings:
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIColor *backgroundCellColor;
@property (nonatomic) UIColor *scrubberCenterMarkColor;
@property (nonatomic) CGFloat scrubberCenterMarkWidth;


// Supportted keys
// @"object_and_scene_detection"
// @"motion"
// @"sound"
// @"network"
@property (nonatomic) NSDictionary<NSString*, UIImage*>* eventTypeImages;

@property (nonatomic) UIColor *eventTypeTintColor;
@property (nonatomic) CGFloat cellWidth;
@property (nonatomic) CGFloat cellSeparatorWidth;

@property (nonatomic) UIFont *dateTimeTextFont;
@property (nonatomic) UIColor *dateTimeTextColor;
@property (nonatomic) CGFloat dateTimeTextKerning;
@property (nonatomic) NSString *dateTimeFormat;
@property (nonatomic) NSString *dateTimeZone;
@property (nonatomic) UIFont *liveViewTextFont;
@property (nonatomic) UIColor *liveViewTextColor;
@property (nonatomic) CGFloat liveViewTextKerning;

@property (nonatomic) Boolean continuousEventPlaying;
@property (nonatomic) Boolean eventGrouping;

-(void) setScrubberApiPort: (int) port;
-(int) getScrubberApiPort;

-(void) setScrubberApiProtocolType: (ScrubberApiProtocolType) type;
-(ScrubberApiProtocolType) getScrubberApiProtocolType;

-(void) setScrubberApiProtocolDefaults: (ScrubberApiProtocolDefaults) type;

// copy
+ (ScrubberConfig*) makeCopy:(ScrubberConfig*) src;

@end

// data provider content
typedef NS_ENUM(int, ScrubberEventType) {
    SCRUBBER_EVENT_TYPE_UNDEFINED = -1,
    SCRUBBER_EVENT_TYPE_FIRST = 0,
    SCRUBBER_EVENT_TYPE_RECORD = 1,
    SCRUBBER_EVENT_TYPE_LIVE = 2,
    SCRUBBER_EVENT_TYPE_GROUP = 3
};

@interface ScrubberEvent : NSObject
@property (nonatomic) ScrubberEventType type;
@property (nonatomic) NSNumber* identificator;
@property (nonatomic) NSNumber* camid;
@property (nonatomic) NSString* time;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* imageUrl;
@property (nonatomic) NSString* videoUrl;

@property (nonatomic) long long start;
@property (nonatomic) long long end;
@property (nonatomic) UIImageView* imageView;
@property (nonatomic) long long timeAsValue;
@property (nonatomic) NSString* timezone;

// for group type only
@property (nonatomic) ScrubberEvent* parent;
@property (nonatomic) NSMutableArray<ScrubberEvent*>* childs;

+(ScrubberEvent*) build;
+(ScrubberEvent*) build:(int64_t)time;
+(ScrubberEvent*) build:(NSNumber*)identificator andTime:(int64_t)time;

@end

typedef NS_ENUM(int, ScrubberState) {
    SCRUBBER_STATE_REST = 0,
    SCRUBBER_STATE_EVENTS_LOADING = 1,
    SCRUBBER_STATE_EVENTS_LOADING_FOR_DATE = 2,
    SCRUBBER_STATE_EVENTS_REFRESHING = 3,
    SCRUBBER_STATE_EVENT_DELETING = 4,
};

@protocol ScrubberViewDelegate<NSObject>

// state notifications
@optional
-(int) OnScrubberStateChangedFrom:(ScrubberState)prevState
                          toState:(ScrubberState)newState
                       withStatus:(int)status;

// user interacation
@optional
-(void) OnScrubberDidSelectEvent:(ScrubberEvent*)event;

@optional
-(void) OnScrubberFlyOverEvent:(ScrubberEvent*)event;

@optional
-(void) OnScrubberDraggingStartFlyOverEvent:(ScrubberEvent*)event;
-(void) OnScrubberDraggingContinueFlyOverEvent:(ScrubberEvent*)event;
-(void) OnScrubberDraggingEndFlyOverEvent:(ScrubberEvent*)event;

//
@optional
-(int) OnScrubberEventPlayStarted:(ScrubberEvent*)event;
-(int) OnScrubberEventPlayFinished:(ScrubberEvent*)event;

@optional
-(void) OnScrubberGetRangeForPlayingEvent:(ScrubberEvent*)event
                               startRange:(long long*)start
                                 endRange:(long long*)end;

@optional
-(void) OnScrubberSetCurrentPositionForPlayingEvent:(ScrubberEvent*)event
                                        newPosition:(long long)position;
-(long long) OnScrubberGetCurrentPositionForPlayingEvent:(ScrubberEvent*)event;

@optional
-(int) onSharedTokenWillExpireIn:(long long)deltaTimeInMs;

@end

@protocol ScrubberDataSourceDelegate<NSObject>

@required
-(NSInteger) OnScrubberGetEventsCount;
-(void) OnScrubberSetEventsCount:(NSInteger) newCount;
-(ScrubberEvent*) OnScrubberGetEventByIndex:(NSInteger) index;
-(int) OnScrubberDeleteEvent:(ScrubberEvent*) event;
-(int) OnScrubberSetQuantity:(NSInteger) quantity;

-(void) OnScrubberSetCurrentTime:(long long) currentTime;

@end
