//
//  MediaPlayerPlaySegment.h
//  MediaPlayerSDK
//
//  Created by Max on 09/03/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#ifndef MediaPlayerSDK_MediaPlayerPlaySegment_h
#define MediaPlayerSDK_MediaPlayerPlaySegment_h

#import <Foundation/Foundation.h>

@interface MediaPlayerPlaySegment : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* url;

@property (nonatomic) int64_t segmentId;
@property (nonatomic) int64_t startTime;
@property (nonatomic) int64_t stopTime;
@property (nonatomic) int64_t durationTime;
@property (nonatomic) int64_t startOffset;

-(id) initWithSegment:(MediaPlayerPlaySegment *) newSegment;

@end

#endif
