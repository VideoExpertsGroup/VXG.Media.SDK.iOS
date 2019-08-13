//
//  Utils.h
//  MediaPlayerSDKTest2
//
//  Created by Max Koutsanov on 6/21/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+(NSString*)formatTimeInterval:(CGFloat)seconds isLeft:(BOOL)isLeft;

@end

NS_ASSUME_NONNULL_END
