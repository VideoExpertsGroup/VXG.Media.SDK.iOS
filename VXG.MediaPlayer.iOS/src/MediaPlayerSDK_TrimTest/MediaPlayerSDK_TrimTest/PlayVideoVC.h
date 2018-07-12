//
//  PlayVideoVC.h
//  MediaPlayerSDK_TrimTest
//
//  Created by user on 18/05/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MediaPlayer.h"

@interface PlayVideoVC : UIViewController<MediaPlayerCallback>
-(void) setVideoInfo: (NSDictionary*) info;
-(void) setRecordPath: (NSString*) recPath;
@end

