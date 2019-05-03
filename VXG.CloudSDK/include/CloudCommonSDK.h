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


@interface CTimelinePair : NSObject
@property long long start;
@property long long end;
@end

@interface CTimeline : NSObject
@property long long start;
@property long long end;
@property NSArray<CTimelinePair*>* periods;
@end

@interface CPreviewImage : NSObject
@property(copy, nonatomic) NSString *url;
@property(nonatomic) NSInteger width;
@property(nonatomic) NSInteger height;
@property(nonatomic) NSInteger size;
@property(copy, nonatomic) NSString *time;
@property(copy, nonatomic) NSString *expire;
@end
