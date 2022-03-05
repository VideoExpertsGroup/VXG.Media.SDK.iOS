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
    __weak IBOutlet UIButton *record_btn;
    __weak IBOutlet UITextField *access_token_tf;
    __weak IBOutlet UILabel *error_lbl;
    
    CloudPlayerSDK* ccplayer;
    CPlayerConfig* conf;

    Boolean isRecording;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [access_token_tf resignFirstResponder];
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CSDK_LogLevel = CSDK_LOG_LEVEL_ERROR;
    isRecording = false;
    
    access_token_tf.delegate = self;
    
    conf = [[CPlayerConfig alloc] init];
    [conf setConnectionDetectionTime:1000];
    [conf setConnectionBufferingTime:500];
    //[conf setLicenseKey:@"trial"]; //input license key if you have, otherwise playtime is limited to 2 minutes
    
    // setup record using config if you want auto start record
    //NSString* tmpfile = [NSTemporaryDirectory() stringByAppendingPathComponent:@""];
    //[conf setLocalRecordPath:tmpfile];
    
    // if you want auto start record
    //[conf setLocalRecordFlags:(CPlayerLocalRecordFlagsAutoStart)];
    
    //[conf setLocalRecordPrefix:@"ConfigTestRecord"];
    //[conf setLocalRecordSplitSize:0];
    //[conf setLocalRecordSplitTime:0];
    //[conf setLocalRecordFrameDuration:0];
    //[conf setLocalRecordTrimPosEnd:-1];
    //[conf setLocalRecordTrimPosStart:-1];

    [playPause_btn setEnabled: NO];
    [aspect_btn  setEnabled: NO];
    
    ccplayer = [[CloudPlayerSDK alloc] initWithParams: videoView config: conf callback:^( CloudPlayerEvent status_code, id<ICloudCObject> player) {
        switch (status_code) {
            case SOURCE_CHANGED: {
                
                NSDate* start = [NSDate dateWithTimeIntervalSinceNow: -12*60*60];
                NSDate* end = [NSDate dateWithTimeIntervalSinceNow: 0];
                
                [ccplayer getTimeline: start.timeIntervalSince1970*1000 end: end.timeIntervalSince1970*1000 onComplete:^(NSObject *obj, int status) {
                    if (status == 0) {
                        CTimeline* timeline = (CTimeline*) obj;
                        
                        NSLog(@"Timeline period: [%@ ~ %@] segments: %lu \n", [CloudHelpers formatTime: timeline.start ], [CloudHelpers formatTime: timeline.end], [[timeline periods] count] );
                        for (NSUInteger i=0; i< [[timeline periods] count]; i ++) {
                            id<CTimelinePair> period = [[timeline periods] objectAtIndex: i];
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
            case RECORD_STARTED: {
                NSLog(@"RECORD_STARTED: \n");
                isRecording = true;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [record_btn setTitle:@"Stop Recording" forState: UIControlStateNormal];
                });

            } break;
            case RECORD_STOPPED: {
                isRecording = false;
                NSString* filename = [ccplayer localRecordGetFileName:0];
                int64_t duration = [ccplayer localRecordGetStat:CPlayerLocalRecordStatsDurationTotal];
                NSLog(@"RECORD_STOPPED: filename: %@, duration: %lld\n", filename, duration);
            } break;
            case RECORD_CLOSED: {
                isRecording = false;
                NSLog(@"RECORD_CLOSED: \n");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [record_btn setTitle:@"Start Recording" forState: UIControlStateNormal];
                });
            } break;
        }
        
    }];
   
    [ccplayer setDelegate:self];
  
}

-(int) onSharedTokenWillExpireIn:(long long)deltaTimeInMs {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"onSharedTokenExpiredIn: %lld", deltaTimeInMs);
        NSString* token = @"";
        int rc = [ccplayer setSource: token ];
        if (rc < 0) {
            NSString* error = [ccplayer GetResultStr];
            if (error == nil || error.length <= 0) {
                error = @"Get access_token from videoexpertsgroup.com dashboard and type here";
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Check expire error"
                                                                           message:error preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction: [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler: nil]];
            [self presentViewController:alert animated:YES completion: nil];
        }
    });

    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OpenCloseBtn_click:(UIButton *)sender {
    if (sender.tag == 0) {
        NSString* token = access_token_tf.text;
        int rc = [ccplayer setSource: token ];
        if (rc < 0) {
            NSString* error = [ccplayer GetResultStr];
            if (error == nil || error.length <= 0) {
                error = @"Get access_token from videoexpertsgroup.com dashboard and type here";
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:error preferredStyle:UIAlertControllerStyleAlert];
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

- (IBAction)RecordBtn_click:(UIButton *)sender {
    if (isRecording) {
        [ccplayer localRecordStop];
    } else {
        NSString* tmpfile = [NSTemporaryDirectory() stringByAppendingPathComponent:@""];
        // setup continues recording
        [ccplayer localRecordSetup:tmpfile flags:(CPlayerLocalRecordFlagsNoSart) splitTime:0 splitSize:0 prefix:@"TestRecord"];
        // setup record splitted by time
        //[ccplayer localRecordSetup:tmpfile flags:(CPlayerLocalRecordFlagsNoSart | CPlayerLocalRecordFlagsSplitByTime) splitTime:30 splitSize:0 prefix:@"TestRecord"];
        // setup record splitter by size
        //[ccplayer localRecordSetup:tmpfile flags:(CPlayerLocalRecordFlagsNoSart | CPlayerLocalRecordFlagsSplitBySize) splitTime:0 splitSize:1 prefix:@"TestRecord"];
        [ccplayer localRecordStart];
    }
}

@end
