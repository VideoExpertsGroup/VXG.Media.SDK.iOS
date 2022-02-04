//
//  TimelineView.h
//  cloudsdk.timeline.view
//
//  Created by Max on 22/10/2017.
//  Copyright © 2017 vxg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudPlayer.h"
#import "CloudCamera.h"

typedef NS_OPTIONS(int, TimelineScaleType)
{
    TIMELINE_SCALE_MINUTE = 0,
    TIMELINE_SCALE_HOUR   = 1,
    TIMELINE_SCALE_12HOUR = 2,
    TIMELINE_SCALE_RANGE  = 3
};

typedef NS_OPTIONS(int, TimelineControls)
{
    TIMELINE_CONTROL_TORIGHT   = 1 << 0,
    TIMELINE_CONTROL_TOLEFT    = 1 << 1,
    TIMELINE_CONTROL_CALENDAR  = 1 << 2,
    TIMELINE_CONTROL_SCALE     = 1 << 3
};

// config for timeline
@interface TimelineConfig : NSObject

// controls visibility
@property (nonatomic) TimelineControls controls;

// copy
+ (TimelineConfig*) makeCopy:(TimelineConfig*) src;

@end

// data provider content
@interface TimelinePair : NSObject
@property long long start;
@property long long end;
@end

@interface Timeline : NSObject
@property long long start;
@property long long end;
@property NSArray<TimelinePair*>* periods;
@end

@protocol TimelineViewDelegate<NSObject>

// override it for provide data for
@optional
- (Timeline*) OnTimelineDataRequest:(long long) start
                                end:(long long) end;

@optional
-(int) OnTimelinePositionChanged:(long long)position
                    withDuration:(long long)duration
                  withRangeStart:(long long)rangeStart
                    withRangeEnd:(long long)rangeEnd;

@optional
-(int) onSharedTokenWillExpireIn:(long long)deltaTimeInMs;

@end

@interface TimelineView : UIView

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

// color scheme
@property (nonatomic) UIColor* mainColor;
@property (nonatomic) UIColor* trackColor;
@property (nonatomic) UIColor* knobColor;
@property (nonatomic) UIImage* knobImage;
@property (nonatomic) UIColor* lineColor;
@property (nonatomic) UIColor* strokeColor;
@property (nonatomic) UIColor* textColor;
@property (nonatomic) UIColor* textBackgroundColor;
@property (nonatomic) UIColor* rangeColor;
@property (nonatomic) UIColor* scaleColor;
@property (nonatomic) UIColor* scaleSelectedColor;
@property (nonatomic) float trackWidth;
@property (nonatomic) float lineWidth;
@property (nonatomic) NSString* timeFormat;
@property (nonatomic) NSString* timeZone;
@property (nonatomic) float strokeWidth;
@property (nonatomic) float strokeStepWidth;
@property (nonatomic) int strokeTextNamingType; // 0 - for each, 1 - through one
@property (nonatomic) int strokeTextPositionType; // 0 - mixed, 1 - top only, 2 - bottom only
@property (nonatomic) float scalePixelsPerSecond;

// modes
@property (nonatomic) int trackFillMode; // 0 - from records segments, 1 - from current position

// config
-(TimelineConfig*) getConfig;
-(void) applyConfig;

// common approach
-(void) setDelegate: (id<TimelineViewDelegate>) delegate;
-(id<TimelineViewDelegate>) getDelegate;

// player approach
-(void) setPlayer: (CloudPlayer*) player;
-(CloudPlayer*) getPlayer;

// old camera approach
-(void) setCamera: (CloudCamera*) camera;
-(CloudCamera*) getCamera;

- (void) setScale:(TimelineScaleType)scale;
- (TimelineScaleType) getScale;

-(void) setRange: (int64_t) start_time end: (int64_t) end_time;
-(void) unsetRange;

-(void) setPosition:(int64_t)time;
-(void) setTrackingMode:(BOOL)on;
-(void) setEnsureVisible:(bool)on;

-(void) setCalendarContainer:(UIView*)view;
-(UIView*) getCalendarContainer;

// UI
-(void) toggleCalendarControl;
-(void) toggleCalendarControl:(BOOL)on;
-(void) toggleScaleControl:(TimelineScaleType)scale;

-(void) scrollTimelineToLeft;
-(void) scrollTimelineToRight;

// cleanup
-(void) clean;

+(NSString*) getVersion;

@end
