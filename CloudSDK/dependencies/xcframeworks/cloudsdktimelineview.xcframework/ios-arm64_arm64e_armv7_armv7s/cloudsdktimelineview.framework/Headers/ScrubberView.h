//
//  ScrubberView.h
//  cloudsdk.timeline.view
//
//  Created by Max on 22/10/2017.
//  Copyright © 2017 vxg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrubberCommon.h"

@interface ScrubberView : UIView

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

// config
-(ScrubberConfig*) getConfig;
-(void) applyConfig;

// states
-(ScrubberState) getState;

// data source, if not set - used internal based on setSource
-(void) setDataSourceDelegate: (id<ScrubberDataSourceDelegate>) source;
-(id<ScrubberDataSourceDelegate>) getDataSourceDelegate;

-(void) setDelegate: (id<ScrubberViewDelegate>) delegate;
-(id<ScrubberViewDelegate>) getDelegate;

// default token for get data
-(int) setSource:(NSString*)source;

-(int) setSource:(NSString*)source
       startFrom:(int64_t)time;

-(int) setSource:(NSString*)source
   startDateTime:(long long)start // default: -1
     endDateTime:(long long)end // default: current time
       eventType:(NSString*)type // default: nil, all events. Possible values: "motion, net, sound, facedetection"
   sortAscending:(long long)isAscending // default: true
       withLimit:(long long)limit // default: 100
      withOffset:(long long)offset // default: 0
       startFrom:(int64_t)time; // default: -1 - live, concrete value is possible closest or first if several available

-(int) refresh;

// data access
-(ScrubberEvent*) getCurrentEvent;
-(NSInteger) getEventsCount;
-(ScrubberEvent*) getEvent:(NSInteger)index;

// scrubber control
-(void) toEvent:(ScrubberEvent*)event;
-(void) toEvent:(ScrubberEvent*)event withSendNotify:(BOOL)isNotify;
-(void) toEvent:(ScrubberEvent*)event withSendNotify:(BOOL)isNotify withScroll:(BOOL)isScroll;

-(void) toFirstEvent;
-(void) toLastEvent;
-(void) toClosestEvent:(ScrubberEvent*)event;

-(void) toNextEvent;
-(void) toNextEventWithSendNotify:(BOOL)isNotify;

-(void) toPreviousEvent;
-(void) toPreviousEventWithSendNotify:(BOOL)isNotify;

-(void) deleteEvent:(ScrubberEvent*)event
         onComplete:(void (^)(int status, NSString* description))complete;

// cleanup
-(void) clean;

+(NSString*) getVersion;

@end
