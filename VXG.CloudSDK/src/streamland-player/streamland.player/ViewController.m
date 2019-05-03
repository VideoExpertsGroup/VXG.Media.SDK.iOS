//
//  ViewController.m
//  streamland.player
//
//  Created by user on 24/01/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    __weak IBOutlet UIView *videoView;
    __weak IBOutlet UIButton *playPause_btn;
    __weak IBOutlet UIButton *openClose_btn;
    __weak IBOutlet UIButton *aspect_btn;
    __weak IBOutlet UITextField *access_token_tf;
    __weak IBOutlet UILabel *error_lbl;
    
    CloudPlayerSDK* ccplayer;
    CPlayerConfig* conf;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [access_token_tf resignFirstResponder];
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CSDK_LogLevel = CSDK_LOG_LEVEL_ERROR;
    
    access_token_tf.delegate = self;
    
    conf = [[CPlayerConfig alloc] init];
    //[conf setLicenseKey:@"trial"]; //input license key if you have, otherwise playtime is limited to 2 minutes
    
    [playPause_btn setEnabled: NO];
    [aspect_btn  setEnabled: NO];
    
    ccplayer = [[CloudPlayerSDK alloc] initWithParams: videoView config: conf callback:^( CloudPlayerEvent status_code, id<ICloudObject> player) {
        switch (status_code) {
            case SOURCE_CHANGED: {
                
                NSDate* start = [NSDate dateWithTimeIntervalSinceNow: -12*60*60];
                NSDate* end = [NSDate dateWithTimeIntervalSinceNow: 0];
                
                [ccplayer getTimeline: start.timeIntervalSince1970*1000 end: end.timeIntervalSince1970*1000 onComplete:^(NSObject *obj, int status) {
                    if (status == 0) {
                        CTimeline* timeline = (CTimeline*) obj;
                        
                        NSLog(@"Timeline period: [%@ ~ %@] segments: %lu \n", [CloudHelpers formatTime: timeline.start ], [CloudHelpers formatTime: timeline.end], [[timeline periods] count] );
                        for (NSUInteger i=0; i< [[timeline periods] count]; i ++) {
                            CTimelinePair* period = [[timeline periods] objectAtIndex: i];
                            NSLog(@"segment %lu: [%@ ~ %@]\n", i, [CloudHelpers formatTime: period.start ], [CloudHelpers formatTime: period.end]);
                        }
                        
                    }
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [playPause_btn setEnabled:YES];
                    playPause_btn.tag = 0;
                    [playPause_btn setTitle:@"Play" forState: UIControlStateNormal];
                    
                    openClose_btn.tag = 1;
                    [openClose_btn setTitle:@"Close" forState: UIControlStateNormal];
                    
                    [aspect_btn setEnabled: NO];
                    error_lbl.text = @"";
                });
            } break;
            case CONNECTING: {
                NSLog(@"<debug> Connecting...\n");
                dispatch_async(dispatch_get_main_queue(), ^{
                    error_lbl.text = @"Connecting..";
                });
            } break;
            case CONNECTED: {
                NSLog(@"<debug> Connected!\n");
                dispatch_async(dispatch_get_main_queue(), ^{
                    error_lbl.text=@"";
                    [aspect_btn setEnabled: YES];
                });
            } break;
            case STARTED: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    playPause_btn.tag = 1;
                    [playPause_btn setTitle:@"Pause" forState: UIControlStateNormal];
                });
            } break;
            case PAUSED: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    playPause_btn.tag = 0;
                    [playPause_btn setTitle:@"Play" forState: UIControlStateNormal];
                });
            } break;
            case CLOSED: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    error_lbl.text = @"";
                    
                    [playPause_btn setEnabled:NO];
                    playPause_btn.tag = 0;
                    [playPause_btn setTitle:@"Play" forState: UIControlStateNormal];
                    
                    openClose_btn.tag = 0;
                    [openClose_btn setTitle:@"Open" forState: UIControlStateNormal];
                    
                    [aspect_btn setEnabled: NO];
                });
            } break;
            case EOS: {
                
            } break;
            case SEEK_COMPLETED: {
                
            } break;
            case ERROR: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"   ERROR \n");
                    error_lbl.text = @"Error";
                });
            } break;
            case TRIAL_VERSION: {
                NSLog(@"  == = = TRIAL VERSION LIMITATION = = ===\n");
            } break;
        }
        
    }];
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OpenCloseBtn_click:(UIButton *)sender {
    if (sender.tag == 0) {

        int rc = [ccplayer setSource: access_token_tf.text ];
        if (rc < 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"Get access_token from videoexpertsgroup.com dashboard and type here" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction: [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler: nil]];
            [self presentViewController:alert animated:YES completion: nil];
        }
    } else {
        [ccplayer close];
    }
}
- (IBAction)PlayPauseBtn_click:(UIButton *)sender {
    if (sender.tag == 0) {
        [ccplayer play];
        error_lbl.text = @"";
    } else {
        [ccplayer pause];
    }
}

- (IBAction)AspctBtn_click:(UIButton *)sender {
    switch(sender.tag) {
            // 0 - stretch, 1 - fittoscreen with aspect ratio, 2 - crop, 3 - 100% size, 4 - zoom+move mode
        case 0: {
            [sender setTitle:@"aspect" forState: UIControlStateNormal];
            sender.tag = 1;
            [conf aspectRatio: 1];
            [ccplayer setConfig: conf];
        } break;
        case 1: {
            [sender setTitle:@"crop" forState: UIControlStateNormal];
            sender.tag = 2;
            [conf aspectRatio: 2];
            [ccplayer setConfig: conf];
        } break;
        case 2: {
            [sender setTitle:@"orignal" forState: UIControlStateNormal];
            sender.tag = 3;
            [conf aspectRatio: 3];
            [ccplayer setConfig: conf];
        } break;
        case 3: {
            [sender setTitle:@"zoommv" forState: UIControlStateNormal];
            sender.tag = 4;
            [conf aspectRatio: 4];
            [ccplayer setConfig: conf];
        } break;
        default: {
            [sender setTitle:@"strtch" forState: UIControlStateNormal];
            sender.tag = 0;
            [conf aspectRatio: 0];
            [ccplayer setConfig: conf];
        } break;
    }
}

@end
