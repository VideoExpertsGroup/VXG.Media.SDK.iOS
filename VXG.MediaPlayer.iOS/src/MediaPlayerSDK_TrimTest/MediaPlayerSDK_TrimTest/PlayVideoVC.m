//
//  PlayVideoVC.m
//  MediaPlayerSDK_TrimTest
//
//  Created by user on 18/05/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import "PlayVideoVC.h"


@implementation PlayVideoVC {
    NSDictionary* videoinfo;
    NSString* path;
    NSString* name;
    NSString* type;
    __weak IBOutlet UINavigationItem *ni_navigationBar;
    __weak IBOutlet UIView *v_bottomPanel;
    __weak IBOutlet UIButton *btn_playPause;
    __weak IBOutlet UIButton *btn_Rec;
    __weak IBOutlet UIButton *btn_trim;
    
    
    __weak IBOutlet UIView *v_preview;
    
    MediaPlayer* player;
    MediaPlayerConfig* conf;
    
    Boolean isRecording;
    NSString* recordPath;
    int     playerMode;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    isRecording = NO;
    playerMode = 0;
    
    if (videoinfo) {
        type = [videoinfo objectForKey:@"type"];
        name = [videoinfo objectForKey:@"filename"];
        path = [videoinfo objectForKey:@"fullpath"];
        
        conf    = [[MediaPlayerConfig alloc] init];
        
        conf.decodingType               = 1; // 1 - hardware, 0 - software
        conf.synchroEnable              = 1; // syncronization enabled
        conf.synchroNeedDropVideoFrames = 1; // synchroNeedDropVideoFrames
        conf.aspectRatioMode            = 1;
        conf.connectionNetworkProtocol  = -1; // // 0 - udp, 1 - tcp, 2 - http, 3 - https, -1 - AUTO
        conf.connectionDetectionTime    = 1000; // in milliseconds
        conf.connectionTimeout          = 60000;
        conf.decoderLatency             = 0;
        conf.recordPath                 = recordPath;
        
        conf.connectionUrl = path;
        if ([type isEqualToString:@"record"]) {
            [ni_navigationBar setTitle: name];
            playerMode = 1;
            btn_trim.hidden = NO;
            btn_Rec.hidden  = YES;
        } else {
            [ni_navigationBar setTitle: @"LiveStream"];
            playerMode = 0;
            btn_trim.hidden = YES;
            btn_Rec.hidden  = NO;
        }
        
        player  = [[MediaPlayer alloc] init: [v_preview bounds]];
        [v_preview addSubview: [player contentView]];
        [v_preview sendSubviewToBack: [player contentView]];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setVideoInfo:(NSDictionary *)info {
    videoinfo = info;
}

-(void) setRecordPath:(NSString *)recPath {
    recordPath = recPath;
}

- (IBAction)BackBtn_click:(UIBarButtonItem *)sender {
    if (player) {
        [player Close];
    }
    
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) showError: (NSString*) title msg: (NSString*) msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* code = [UIAlertController alertControllerWithTitle:title message: msg preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *confirmCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
        [code addAction:confirmCancel];
        [self presentViewController:code animated:YES completion:nil];
    });
}

- (int)Status:(MediaPlayer *)player args:(int)arg {
    MediaPlayerNotifyCodes nc = arg;
    switch (nc) {
        case PLP_EOS: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->btn_playPause setTitle:@"Play" forState: UIControlStateNormal];
                self->btn_playPause.tag = 0;
                [player Close];
            });
        } break;
        case PLP_ERROR: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showError:@"Error" msg: @"Something wrong with pipeline"];
                [self->btn_playPause setTitle:@"Play" forState: UIControlStateNormal];
                self->btn_playPause.tag = 0;
                self->btn_Rec.tag =  0;
                [self->btn_Rec setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
                [player Close];
            });
        } break;
        case PLP_TRIAL_VERSION: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showError:@"TRIAL" msg: @"Trial version limitation"];
                [player Close];
                [self->btn_playPause setTitle:@"Play" forState: UIControlStateNormal];
                self->btn_playPause.tag = 0;
                self->btn_Rec.tag =  0;
                [self->btn_Rec setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
            });
        } break;
        case PLP_PLAY_SUCCESSFUL:
        case PLP_PLAY_PLAY: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->btn_playPause setTitle:@"Pause" forState: UIControlStateNormal];
                self->btn_playPause.tag = 2;
            });
        } break;
        case PLP_PLAY_PAUSE: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->btn_playPause setTitle:@"Play" forState: UIControlStateNormal];
                self->btn_playPause.tag = 3;
            });
        } break;
        case CP_CONNECT_STARTING: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->btn_playPause setTitle:@"Connecting.." forState: UIControlStateNormal];
                self->btn_playPause.tag = 1;
            });
        } break;
        case CP_CONNECT_FAILED:
        case CP_INTERRUPTED:
        case CP_ERROR_DISCONNECTED:
        case CP_STOPPED: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->btn_playPause setTitle:@"Play" forState: UIControlStateNormal];
                self->btn_playPause.tag = 0;
                self->btn_Rec.tag =  0;
                [self->btn_Rec setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
                [player Close];
            });
        } break;
        default: {
            NSLog(@"<binary> Notify code : %d", arg);
        } break;
    }

    return 0;
}

- (IBAction)btnPlayPause_click:(UIButton *)sender {
    if (sender.tag == 0) {
        [conf setPlayerMode:PP_MODE_ALL];
        [player Open:conf callback: self];
    } else if (sender.tag == 2) {
        [player Pause];
    } else if (sender.tag == 3) {
        [player Play:0];
    }
}


#pragma mark Record

-(NSString*) getRecordsPath {
    return recordPath;
}

-(void) recordStart {
    if (player) {
        
        [player recordSetup: recordPath flags:  (RECORD_AUTO_START | RECORD_PTS_CORRECTION ) splitTime:0 splitSize:0 prefix:@"REC"];
        [player recordStart];
    }
}

-(void) recordStop {
    if (player) {
        [player recordStop];
    }
}

-(void) record: (Boolean) toRec {
    if (toRec) {
        btn_Rec.tag =  1;
        
        [btn_Rec setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
        [self recordStart];
    } else {
        btn_Rec.tag =  0;
        [btn_Rec setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
        
        [self recordStop];
    }
}

- (IBAction)RecBtn_click:(UIButton *)sender {
    isRecording =! isRecording;
    [self record: isRecording];
}

- (IBAction)TrimBtn_click:(UIButton *)sender {
    if (sender.tag == 0) {
        [conf setPlayerMode:PP_MODE_RECORD];
        [conf setRecordFlags: RECORD_AUTO_START];
        
        //record will be trimmed from 10th sec to 20th sec
        [conf setRecordTrimPosStart: 10000];
        [conf setRecordTrimPosEnd:   20000];
        
        [conf setRecordPrefix:@"TRIM"];
        [player Open:conf callback: self];
    }
}
@end
