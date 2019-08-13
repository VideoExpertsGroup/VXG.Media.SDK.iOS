//
//  CloudCommonSDK.h
//  CloudSDK
//
//  Created by user on 18/01/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(int, CCStatus)
{
    CCStatusActive = 0,
    CCStatusUnauthorized = 1,
    CCStatusInactive = 2,
    CCStatusInactiveByScheduler = 3,
    CCStatusOffline = 4
};

typedef NS_ENUM(int, CCRecordingMode)
{
    CCRecordingModeContinues = 0,
    CCRecordingModeByEvent = 1,
    CCRecordingModeNoRecording = 2
};

typedef NS_OPTIONS(int, CTimelineScaleType)
{
    CTIMELINE_SCALE_MINUTE = 0,
    CTIMELINE_SCALE_HOUR   = 1,
    CTIMELINE_SCALE_12HOUR = 2,
    CTIMELINE_SCALE_RANGE  = 3
};

typedef NS_OPTIONS(int, CTimelineControls)
{
    CTIMELINE_CONTROL_TORIGHT   = 1 << 0,
    CTIMELINE_CONTROL_TOLEFT    = 1 << 1,
    CTIMELINE_CONTROL_CALENDAR  = 1 << 2,
    CTIMELINE_CONTROL_SCALE     = 1 << 3
};

@interface CTimelinePair : NSObject
@property long long start;
@property long long end;
@end

@interface CTimeline : NSObject
@property long long start;
@property long long end;
@property NSArray<CTimelinePair*>* periods;
@end

@interface CTimelineStyle : NSObject
@property(copy, nonatomic) UIColor *mainColor;
@property(copy, nonatomic) UIColor *lineColor;
@property(copy, nonatomic) UIColor *textColor;
@property(copy, nonatomic) UIColor *textBackgroundColor;
@property(copy, nonatomic) UIColor *trackColor;
@property(copy, nonatomic) UIColor *knobColor;
@property(copy, nonatomic) UIImage *knobImage;
@property(copy, nonatomic) UIColor *strokeColor;
@property(copy, nonatomic) UIColor *rangeColor;
@property(nonatomic) float lineWidth;
@property(nonatomic) float trackWidth;
@property(copy, nonatomic) NSString* timeFormat;
@property(copy, nonatomic) NSString* timeZone;
@property(nonatomic) float strokeWidth;
@property(nonatomic) float strokeStepWidth;
@property(nonatomic) int   strokeTextNamingType; // 0 - for each, 1 - through one
@property(nonatomic) int   strokeTextPositionType; // 0 - mixed, 1 - top only, 2 - bottom only
@property(nonatomic) float scalePixelsPerSecond;

// copy
+(CTimelineStyle*) makeCopy:(CTimelineStyle*)src;
@end

// config for timeline
@interface CTimelineConfig : NSObject
@property (nonatomic) CTimelineControls controls;

// copy
+ (CTimelineConfig*) makeCopy:(CTimelineConfig*) src;
@end

@interface CPreviewImage : NSObject
@property(copy, nonatomic) NSString *url;
@property(nonatomic) NSInteger width;
@property(nonatomic) NSInteger height;
@property(nonatomic) NSInteger size;
@property(copy, nonatomic) NSString *time;
@property(copy, nonatomic) NSString *expire;
@end
