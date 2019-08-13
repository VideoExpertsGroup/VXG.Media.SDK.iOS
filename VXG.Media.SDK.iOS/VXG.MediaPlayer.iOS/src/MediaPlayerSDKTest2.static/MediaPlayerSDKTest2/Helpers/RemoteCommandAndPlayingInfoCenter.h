//
//  RemoteCommandAndPlayingInfoCenter.h
//  MediaPlayerSDKTest2
//
//  Created by Max Koutsanov on 6/21/19.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Url.h"

NS_ASSUME_NONNULL_BEGIN

// callback
@protocol RemoteCommandAndPlayingInfoCenterDelegate<NSObject>

// subtitle data
@optional
- (int) OnRemoteCommandPlay;
- (int) OnRemoteCommandPause;
- (int) OnRemoteCommandChangePlaybackPosition:(NSTimeInterval)positionTime;
@end

@interface RemoteCommandAndPlayingInfoCenter : NSObject

// disable default init
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

// only with params!
-(id)initWithParams:(Url*)url;
-(id)initWithParams:(Url*)url andDelegate:(id<RemoteCommandAndPlayingInfoCenterDelegate>)delegate;

-(void)setDelegate:(id<RemoteCommandAndPlayingInfoCenterDelegate>)delegate;
-(id<RemoteCommandAndPlayingInfoCenterDelegate>) getDelegate;

-(void)open;
-(void)close;

-(void)updatePlaybackPosition:(CGFloat)position
                 withDuration:(CGFloat)duration
                      andrate:(CGFloat)rate;

@end

NS_ASSUME_NONNULL_END
