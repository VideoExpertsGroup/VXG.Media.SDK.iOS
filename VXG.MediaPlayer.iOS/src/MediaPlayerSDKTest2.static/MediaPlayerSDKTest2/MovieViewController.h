/*
 * Copyright (c) 2011-2017 VXG Inc.
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MediaPlayer.h"
#import "M3U8.h"
#import "Thumbnailer.h"

#define MAX_PLAYERS_COUNT 8

@interface MovieViewController : UIViewController<AVAudioRecorderDelegate, UITableViewDataSource, UITableViewDelegate, MediaPlayerCallback>

+ (id) movieViewControllerWithContentPath: (NSString *) path
                                       hw: (int)hw
                           countInstances: (int)countInstances;
@property (readonly) BOOL playing;

- (void) Close;

@end
