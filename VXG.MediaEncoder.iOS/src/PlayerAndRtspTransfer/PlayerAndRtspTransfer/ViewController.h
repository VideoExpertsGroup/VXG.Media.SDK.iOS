//
//  ViewController.h
//  PlayerAndRtspTransfer
//
//  Created by user on 26/10/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MediaCaptureSDK.h"
#import "MediaPlayer.h"

@interface ViewController : UIViewController<MediaPlayerCallback, RtspTransferCallback>


@end

