//
//  PlayerView.h
//  cloudsdk.player.view
//
//  Copyright © 2017 vxg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudPlayerSDK.h"

typedef NS_ENUM(int, CloudPlayerSDKViewErrors)
{
    CLOUDPLAYERVIEW_ERROR_EOS = -1,
    CLOUDPLAYERVIEW_ERROR_STREAM_UNREACHABLE = -2,
    CLOUDPLAYERVIEW_ERROR_STREAM_COULDNOTPLAY = -3,
};

typedef NS_ENUM(int, CloudPlayerSDKViewStyles)
{
    CLOUDPLAYERVIEW_STYLE_DEFAULT = 0,
    CLOUDPLAYERVIEW_STYLE_1,
};

typedef NS_OPTIONS(NSInteger, CloudPlayerSDKViewControls)
{
    CLOUDPLAYERVIEW_CONTROL_STARTTIME                    = 1 << 0,
    CLOUDPLAYERVIEW_CONTROL_STOPTIME                     = 1 << 1,
    CLOUDPLAYERVIEW_CONTROL_FULLSCREEN_TOGGLER           = 1 << 2,
    CLOUDPLAYERVIEW_CONTROL_CAPTION                      = 1 << 3,
    CLOUDPLAYERVIEW_CONTROL_BACK                         = 1 << 4,
    CLOUDPLAYERVIEW_CONTROL_CLOSE                        = 1 << 5,
    CLOUDPLAYERVIEW_CONTROL_PLAYPAUSE                    = 1 << 6,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_LOCK                = 1 << 7,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_PLAYPAUSE           = 1 << 8,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_PREVIOUS            = 1 << 9,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_NEXT                = 1 << 10,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_ASPECT              = 1 << 11,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_FULLSCREEN_TOGGLER  = 1 << 12,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_TIMELINE_CALENDAR   = 1 << 13,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_TIMELINE_DATE       = 1 << 14,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_TIMELINE_TIME_LEFT  = 1 << 15,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_TIMELINE_TIME_RIGHT = 1 << 16,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_TIMELINE_PREVIOUS   = 1 << 17,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_TIMELINE_NEXT       = 1 << 18,
    CLOUDPLAYERVIEW_CONTROL_CONTROLS_TIMELINE_TIMESCALE  = 1 << 19,
    CLOUDPLAYERVIEW_CONTROL_TIMELINE                     = 1 << 20,
    CLOUDPLAYERVIEW_CONTROL_TIMELINE_CALENDAR            = 1 << 21,
    CLOUDPLAYERVIEW_CONTROL_TIMELINE_PREVIOUS            = 1 << 22,
    CLOUDPLAYERVIEW_CONTROL_TIMELINE_NEXT                = 1 << 23,
    CLOUDPLAYERVIEW_CONTROL_TIMELINE_TIMESCALE           = 1 << 24
};

typedef NS_OPTIONS(int, CloudPlayerSDKViewModes)
{
    CLOUDPLAYERVIEW_MODE_AUTOPLAY = 1 << 0,
};

// config for sdk view
@interface CloudPlayerSDKViewConfig : NSObject

// style
+ (void)setStyle:(CloudPlayerSDKViewStyles)newValue;
+ (CloudPlayerSDKViewStyles)getStyle;

// controls visibility, default: CLOUDPLAYERVIEW_CONTROL_PLAYPAUSE | CLOUDPLAYERVIEW_CONTROL_FULLSCREEN_TOGGLER
@property (nonatomic) CloudPlayerSDKViewControls controls;
// player modes, default: CLOUDPLAYERVIEW_MODE_AUTOPLAY
@property (nonatomic) CloudPlayerSDKViewModes modes;

// modify default visible error text
-(void) modifyErrorDescription:(CloudPlayerSDKViewErrors)error newDescriptionText:(NSString*)description;

// copy
+ (CloudPlayerSDKViewConfig*) makeCopy:(CloudPlayerSDKViewConfig*) src;

@end

// protocol
@protocol CloudPlayerSDKViewDelegate<NSObject>

@optional
-(int) OnPlayerWillLoad:(CPlayerConfig*) playerConfig;
-(int) OnPlayerDidLoad:(CloudPlayerSDK*) player;

@optional
-(int) OnSourceChanged;
-(int) OnSourceUnreachable;
-(int) OnSourceOnline;

-(int) OnConnected;
-(int) OnVideoFirstFrame;
-(int) OnRecordStarted;
-(int) OnRecordStopped:(NSString*)path;
-(int) OnRecordClosed:(int)errcode;
-(int) OnPlayed;
-(int) OnPaused;
-(int) OnError:(int) errcode;
-(int) OnTrial;

@optional
-(int) OnControlsToggled:(Boolean)show;
-(int) OnFullscreenToggled:(Boolean)on;

-(int) OnClosePressed;
-(int) OnPlayerControlsPreviousPressed;
-(int) OnPlayerControlsNextPressed;

@optional
-(int) OnPlayerViewTapped;

@end


//IB_DESIGNABLE
@interface CloudPlayerSDKView: UIView

@property (nonatomic) IBInspectable NSUInteger playerType;

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithFrame:(CGRect)frame andDelegate:(id<CloudPlayerSDKViewDelegate>)delegate;

// post load after nib loaded
-(int) postLoad;

// config
-(CloudPlayerSDKViewConfig*) getConfig;
-(void) applyConfig;

// for events
-(void) setDelegate:(id<CloudPlayerSDKViewDelegate>)delegate;
-(id<CloudPlayerSDKViewDelegate>) getDelegate;

// source provider
-(int) setSource:(NSString*)source;
-(int) setSource:(NSString*)source withPosition:(long long)position;
-(void) close;

-(void) play;
-(void) pause;

-(void) setPosition:(long long)position;
-(long long) getPosition;

-(void) toggleControls:(Boolean)show withNotify:(Boolean)send;
-(void) toggleFullscreen:(Boolean)on withNotify:(Boolean)send;

-(void) setPlaybackControlBackgroundColor:(UIColor*) color;

// for advanced users
-(CloudPlayerSDK*) getPlayer;

@end
