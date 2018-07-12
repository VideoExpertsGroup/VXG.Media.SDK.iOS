//
//  videoListCell.h
//  MediaPlayerSDK_TrimTest
//
//  Created by user on 18/05/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface videoListCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *tf_linkVideo;
@property NSDictionary* info;

-(void) hideGo;

@end
