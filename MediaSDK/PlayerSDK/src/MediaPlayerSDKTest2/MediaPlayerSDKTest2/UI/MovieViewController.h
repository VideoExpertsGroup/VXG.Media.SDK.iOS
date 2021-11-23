/*
 * Copyright (c) 2011-2017 VXG Inc.
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MediaPlayer.h"
#import "M3U8.h"
#import "Thumbnailer.h"

#define MAX_PLAYERS_COUNT 8

#import "../Helpers/Url.h"
#import "../Helpers/RemoteCommandAndPlayingInfoCenter.h"

@interface MovieViewController : UIViewController<AVAudioRecorderDelegate, UITableViewDataSource, UITableViewDelegate,
                                                            MediaPlayerCallback, RemoteCommandAndPlayingInfoCenterDelegate>

+ (id) movieViewControllerWithContentPath: (Url*)url
                                    layer: (int)layer
                                       hw: (int)hw
                           countInstances: (int)countInstances;
@property (readonly) BOOL playing;

- (void) Close;

@end
