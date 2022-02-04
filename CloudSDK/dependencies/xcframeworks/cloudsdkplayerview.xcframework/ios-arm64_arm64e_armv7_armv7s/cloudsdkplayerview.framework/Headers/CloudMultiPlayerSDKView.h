//
//  PlayerView.h
//  cloudsdk.player.view
//
//  Copyright © 2017 vxg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudPlayerSDKView.h"

typedef NS_ENUM(int, CloudMultiPlayerSDKViewScreenLayouts) {
    CloudMultiPlayerSDKViewScreenLayout_2x2,
    CloudMultiPlayerSDKViewScreenLayout_3x3,
    CloudMultiPlayerSDKViewScreenLayout_4x4,
    CloudMultiPlayerSDKViewScreenLayout_1x3,
    CloudMultiPlayerSDKViewScreenLayout_Custom
};

// protocol
@protocol CloudMultiPlayerSDKViewDelegate<NSObject>

@optional
-(int) OnPlayerTapped:(CloudPlayerSDKView*)player onIndex:(int)index;

@end

//IB_DESIGNABLE
@interface CloudMultiPlayerSDKView: UIView

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

//-(instancetype)initWithFrame:(CGRect)frame andDelegate:(id<CloudPlayerSDKViewDelegate>)delegate;

// post load after nib loaded
-(int) postLoad;

// for events
-(void) setDelegate:(id<CloudMultiPlayerSDKViewDelegate>)delegate;
-(id<CloudMultiPlayerSDKViewDelegate>) getDelegate;

//
-(void) setScreenLayout:(CloudMultiPlayerSDKViewScreenLayouts)layout;
-(CloudMultiPlayerSDKViewScreenLayouts) getScreenLayout;

-(int) setSource:(NSString*)source
         onIndex:(int)index
         isLocal:(int)local;
-(int) removeSource:(int)index;
-(int) removeAllSources;

//-(CloudPlayerSDKView*) getCloudPlayerSDKView:(int)index;

@end
