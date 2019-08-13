//
//  Utils.m
//  MediaPlayerSDKTest2
//
//  Created by Max Koutsanov on 6/21/19.
//

#import "Utils.h"

@implementation Utils

+(NSString*)formatTimeInterval:(CGFloat)seconds isLeft:(BOOL)isLeft {
    seconds = MAX(0, seconds);
    
    NSInteger s = seconds;
    NSInteger m = s / 60;
    NSInteger h = m / 60;
    
    s = s % 60;
    m = m % 60;
    
    NSMutableString *format = [(isLeft && seconds >= 0.5 ? @"-" : @"") mutableCopy];
    if (h != 0) [format appendFormat:@"%d:%0.2d", h, m];
    else        [format appendFormat:@"%d", m];
    [format appendFormat:@":%0.2d", s];
    
    return format;
}

@end
