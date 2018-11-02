//
//  ViewController.m
//  PlayerAndRtspTransfer
//
//  Created by user on 26/10/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController {
    RtspTransfer *trsf;
    
    MediaPlayerConfig*  config;
    MediaPlayer  *plr;
    __weak IBOutlet UIView *v_playerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    trsf = [[RtspTransfer alloc] init];
    [trsf setQueueLength: 60];
    [trsf setRtspConnectionType: RTSP_CONN_TCP];
    
    config = [[MediaPlayerConfig alloc] init];
    plr = [[MediaPlayer alloc] init:v_playerView.bounds];
    [v_playerView addSubview: [plr contentView]];
    
    
}

#pragma mark - btn_clicks

- (IBAction)playBtn_click:(UIButton *)sender {
    if (sender.tag == 0) {
        NSString* rtmpurl = @"rtmp://10.20.16.17/live/binary_test_rtsp";
         config.connectionUrl = rtmpurl;
        [trsf OpenRtsp: @"rtsp://10.20.16.80:554" toRtmp: rtmpurl callback:self];
        [trsf Start];
        sender.tag = 1;
        [sender setTitle:@"Stop" forState: UIControlStateNormal];
    } else {
        [plr Close];
        [trsf Close];
        sender.tag = 0;
        [sender setTitle:@"Play" forState: UIControlStateNormal];
    }
}

#pragma mark - player protocol
-(int)Status:(MediaPlayer *)player args:(int)arg {
    NSLog(@"<MediaPlayer>Status: %d", arg);
    
    return 0;
}

#pragma mark - rtsptransfer protocol
-(int) RtspTransferStatus:(RtspTransfer *)who Code:(int)arg {
    if (arg == RT_DEST_OPENED) {
        
        if (VXG_CaptureSDK_ffmpeg_inited > [MediaPlayer isMediaLibraryInited]) {
            [MediaPlayer setMediaLibraryInited: YES];
        }
        
         dispatch_async(dispatch_get_main_queue(), ^{
             [self->plr Open: self->config callback: self];
         });
    }
    return 0;
}


@end
