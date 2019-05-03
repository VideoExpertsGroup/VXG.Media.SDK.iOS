//
//  InternalBuffersScheduler.h
//  MediaPlayerSDKTest2
//
//  Created by Max on 15/08/2017.
//
//

#import <Foundation/Foundation.h>
#import "MediaPlayer.h"

@interface InternalBuffersScheduler : NSObject

    // disable default init
    + (instancetype)new NS_UNAVAILABLE;
    - (instancetype)init NS_UNAVAILABLE;

    // only with params!
    -(id)initWithParams: (MediaPlayer*)player
                 maxVal:(int)maxVal
                 minVal:(int)minVal
             over_speed:(int)over_speed
              low_speed:(int)low_speed
               interval:(int)interval;

    -(bool) start;
    -(void)stop;

@end
