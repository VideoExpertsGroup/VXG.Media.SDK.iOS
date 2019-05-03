//
//  videoListCell.m
//  MediaPlayerSDK_TrimTest
//
//  Created by user on 18/05/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import "videoListCell.h"

@implementation videoListCell {
    
    __weak IBOutlet UIButton *btn_GO;
    __weak IBOutlet NSLayoutConstraint *video_go_distance;
}

-(void) hideGo {
    [btn_GO setHidden: YES];
    
    video_go_distance.constant = 8;
}

@end
