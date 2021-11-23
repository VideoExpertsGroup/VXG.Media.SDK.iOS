//
//  ViewController.m
//  streamland-streamer
//
//  Created by user on 19/01/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    CloudStreamerSDK* strm;
    NSString* access_token;
    MediaRecorder* cpt;
    MediaCaptureConfig* cfg;
    
    Boolean isStarted;
    __weak IBOutlet UIView *videoView;
    __weak IBOutlet UIButton *startStopStreaming;
    __weak IBOutlet UITextField *access_tioken_tf;
    __weak IBOutlet UIButton *orientationBtn;
    __weak IBOutlet UIButton *cameraBtn;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [access_tioken_tf resignFirstResponder];
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    access_tioken_tf.delegate = self;
    
    strm = [[CloudStreamerSDK alloc] initWithParams: self];
    
    isStarted = NO;
    
    //You can get access_token from dashboard https://dashboard.videoexpertsgroup.com/?streaming=
    
    
    cfg = [[MediaCaptureConfig alloc] init];
    [cfg setStreamType:STREAM_TYPE_RTMP_PUBLISH];
    [cfg setVideoFormat: VIDEO_FORMAT_H264];
    [cfg setAudioFormat: AUDIO_FORMAT_AAC];
    [cfg setDevicePosition:Back];
    [cfg setDeviceOrientation: Portrait];
    [cfg setVideoConfig: 192 : 144 : 30 : 128*1024];
    [cfg setPreview: videoView];
    [cfg setLicenseKey:@"Trial"]; //Trial version of MediacaptureSDK works without stops only 2min
    
    cpt = [[MediaRecorder alloc] init];
    
    VXG_CaptureSDK_LogLevel = LL_ERROR;
    
    [cpt Open: cfg callback: self];
    
    [strm Start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)StartStop_btn_click:(UIButton *)sender {
    if (sender.tag == 0) {
        access_token = access_tioken_tf.text;
        int rc = [strm setSource: access_token];
        NSLog(@"<debug> rc = %d \n", rc);
        if (rc < 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"Get access_token from videoexpertsgroup.com dashboard and type here" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction: [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler: nil]];
            [self presentViewController:alert animated:YES completion: nil];
        }
    } else if (sender.tag == 2) {
        [cpt StopStreaming];
        [strm Stop];
        
        startStopStreaming.tag = 0;
        [startStopStreaming setTitle: @"Start Streaming" forState: UIControlStateNormal];
    }
    
}

- (void)onCameraConnected {
    NSLog(@"<debug> %s called", __func__);
    dispatch_async(dispatch_get_main_queue(), ^{
        [strm Start];
        startStopStreaming.tag = 1;
        [startStopStreaming setTitle: @"Stop Streaming" forState: UIControlStateNormal];
    });
}

- (void)onError:(int)err {
    NSLog(@"<debug> %s called param %d", __func__, err);
    [cfg setRTMPurl: nil];
    [cpt StopStreaming];
    dispatch_async(dispatch_get_main_queue(), ^{
        startStopStreaming.tag = 0;
        [startStopStreaming setTitle: @"Start Streaming" forState: UIControlStateNormal];
    });
}

- (void)onStarted:(NSString *) url {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (startStopStreaming.tag == 1) {
                NSLog(@"<debug> %s called param %@", __func__, url);
                [cfg setRTMPurl: url];
                [cpt StartStreaming];
                
                startStopStreaming.tag = 2;
            }
        });
}

- (void)onStopped {
    NSLog(@"<debug> %s called", __func__);
}

- (IBAction)cameraChange:(id)sender {
    [cpt changeCapturePosition];
}

- (IBAction)orientationChange:(UIButton *)sender {
    [cpt changeCaptureOrientation];
}

- (int)Status:(NSString *)who :(int)arg {
    if (arg == CAPTURE_VIDEO_STARTED) {
        dispatch_async(dispatch_get_main_queue(), ^{
            orientationBtn.enabled = YES;
            cameraBtn.enabled = YES;
        });
    } else if (arg == CAPTURE_AUDIO_STOPED || arg == CAPTURE_VIDEO_OPENED) {
        dispatch_async(dispatch_get_main_queue(), ^{
            orientationBtn.enabled = NO;
            cameraBtn.enabled = NO;
        });
    }
    
    NSLog(@"<debug> %s called param %d", __func__, arg);
    return 0;
}

@end
