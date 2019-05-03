//
//  ViewController.h
//  streamland-streamer
//
//  Created by user on 19/01/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CloudStreamerSDK.h"
#import "MediaCaptureSDK.h"

@interface ViewController : UIViewController<ICloudStreamerCallback, MediaCaptureCallback, UITextFieldDelegate>


@end

