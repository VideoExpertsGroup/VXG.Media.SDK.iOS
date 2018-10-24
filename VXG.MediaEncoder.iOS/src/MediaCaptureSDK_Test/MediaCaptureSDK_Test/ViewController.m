//
//  ViewController.m
//
//  Copyright © 2016 VXG Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    MediaRecorder* test;
    RtspTransfer* rtsprtmp;
    
    MediaCaptureConfig *test_conf;
    __weak IBOutlet UIView *preview;
    __weak IBOutlet UITextField *streamurl;
    __weak IBOutlet UIButton *streamon;
    __weak IBOutlet UIButton *streamoff;
    __weak IBOutlet UIButton *recon;
    __weak IBOutlet UIButton *recoff;
    __weak IBOutlet UIButton *fullstart;
    __weak IBOutlet UIButton *fullstop;
    __weak IBOutlet UIButton *openbtn;
    __weak IBOutlet UIButton *closebtn;
    __weak IBOutlet UIButton *backfrontbtn;
    __weak IBOutlet UIButton *portraitlandscapebtn;
    
    Boolean vCaptPlay;
    Boolean aCaptPlay;
    
    Boolean CaptOpen;

    Boolean isStarted;
}

//extern int LogLevel;

- (int)Status:(NSString *)who :(int)arg {
    switch (arg) {
        case MUXREC_OPENED: {
            dispatch_async(dispatch_get_main_queue(), ^{
                recon.enabled       = true;
                recoff.enabled      = false;
            } );
        } break;
        case MUXREC_STARTED: { //record started
            dispatch_async(dispatch_get_main_queue(), ^{
                recon.enabled       = false;
                recoff.enabled      = true;
            } );
        } break;
        case MUXREC_STOPED: { //stop record or fullstop(last step)
            dispatch_async(dispatch_get_main_queue(), ^{
                if (aCaptPlay && vCaptPlay) {   //fulstop
                    recon.enabled   = true;
                } else {                        //stop rec only
                    recon.enabled   = false;
                }
                recoff.enabled      = false;
            } );
        } break;
        case MUXREC_CLOSED: { //close(last step)
            dispatch_async(dispatch_get_main_queue(), ^{
                recon.enabled       = false;
            } );
        } break;
        case MUXRTSP_STARTED:
        case MUXRTMP_STARTED: { //streaming started
            dispatch_async(dispatch_get_main_queue(), ^{
                streamon.enabled    = false;
                streamoff.enabled   = true;
            });
        } break;
        case MUXRTSP_STOPED:  //streaming stopped or fullstop(last step)
        case MUXRTMP_STOPED: {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (aCaptPlay && vCaptPlay) {   //fullstop
                    streamon.enabled    = true;
                } else {                        //stop stream only
                    streamon.enabled    = false;
                }
                streamoff.enabled   = false;
            });
        } break;
        case MUXRTSP_CLOSED:
        case MUXRTMP_CLOSED: { //close(last step)
            dispatch_async(dispatch_get_main_queue(), ^{
                streamon.enabled    = false;
            });           
        } break;
        case CAPTURE_VIDEO_STARTED: { //fulstart video
            vCaptPlay = YES;
            if (aCaptPlay || (test_conf.getAudioFormat == AUDIO_FORMAT_NONE) ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    aCaptPlay = YES;
                    
                    fullstart.enabled = false;
                    fullstop.enabled  = true;
                    
                    streamon.enabled = true;
                    recon.enabled = true;

                });
            }
        } break;
        case CAPTURE_AUDIO_STARTED : { //fullstart audio
            aCaptPlay = YES;
            if (vCaptPlay || (test_conf.getVideoFormat == VIDEO_FORMAT_NONE) ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    vCaptPlay = YES;

                    fullstart.enabled = false;
                    fullstop.enabled  = true;
                    
                    streamon.enabled = true;
                    recon.enabled = true;

                });
            }
            
        } break;
        case CAPTURE_VIDEO_STOPED : { //fullstop(first step) video
            vCaptPlay = NO;
            if (!aCaptPlay || (test_conf.getAudioFormat == AUDIO_FORMAT_NONE )) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    aCaptPlay  = NO;
                    
                    fullstart.enabled = true;
                    fullstop.enabled  = false;
                    
                    streamon.enabled = false;
                    recon.enabled = false;
                });
            }
        } break;
        case CAPTURE_AUDIO_STOPED : {//fulstop(first step) audio
            aCaptPlay = NO;
            if (!vCaptPlay || (test_conf.getVideoFormat == VIDEO_FORMAT_NONE) ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    vCaptPlay = NO;
                    
                    fullstart.enabled = true;
                    fullstop.enabled  = false;
                    
                    streamon.enabled = false;
                    recon.enabled = false;
                });
            }
            
        } break;
        case CAPTURE_VIDEO_OPENED:
        case CAPTURE_AUDIO_OPENED: { // open(first step)
            if (!CaptOpen) {
                CaptOpen = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    openbtn.enabled = false;
                    closebtn.enabled = true;
                    
                    streamon.enabled = true;
                    recon.enabled = true;
                
                    fullstart.enabled = true;
                    
                    portraitlandscapebtn.enabled = true;
                    backfrontbtn.enabled = true;
                });
            }
        } break;
        case CAPTURE_AUDIO_CLOSED:
        case CAPTURE_VIDEO_CLOSED: {// close(first step)
            if (CaptOpen) {
                CaptOpen = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    openbtn.enabled = true;
                    closebtn.enabled = false;
                
                    fullstart.enabled = false;
                    fullstop.enabled  = false;

                    portraitlandscapebtn.enabled = false;
                    backfrontbtn.enabled = false;

                });
            }
        } break;
    }
    
    
    return 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    VXG_CaptureSDK_LogLevel = LL_ERROR;
    
    vCaptPlay = NO;
    aCaptPlay = NO;
    
    streamon.enabled = false;
    streamoff.enabled = false;
    recoff.enabled = false;
    recon.enabled = false;
    fullstop.enabled = false;
    fullstart.enabled = false;
    closebtn.enabled = false;
    openbtn.enabled = true;
    
    streamurl.delegate = self;
       
    isStarted = NO;
    // Do any additional setup after loading the view, typically from a nib.
    
    rtsprtmp = [[RtspTransfer alloc] init];
    [rtsprtmp setQueueLength: 30];
    
}

- (IBAction)start_btn_click:(id)sender {
    if (!isStarted) {
        test_conf = [[MediaCaptureConfig alloc] init];
        [test_conf setPreview: preview];
        [test_conf setAudioFormat:AUDIO_FORMAT_AAC];
        [test_conf setVideoFormat:VIDEO_FORMAT_H264];
        //[test_conf setStreamType:STREAM_TYPE_RTSP_SERVER];

        [test_conf setStreamType:STREAM_TYPE_RTMP_PUBLISH];
        if ([test_conf getStreamType] == STREAM_TYPE_RTSP_SERVER) {
            int port = [streamurl.text intValue];
            if (port > 0) {
                [test_conf setRTSPport: port];
            } else {
                [test_conf setRTSPport:5540];
            }
        } else if ([test_conf getStreamType] == STREAM_TYPE_RTMP_PUBLISH) {
            if ([streamurl.text length] > 0) {
                [test_conf setRTMPurl: streamurl.text];
            }
        }
        
        [test_conf setLicenseKey:@"set license key here otherwise streams are limited by 2 minutes"];

        [test_conf setVideoConfig: 480 : 360 :30: 256*1024 ];

        [test_conf setDeviceOrientation: Portrait];
        [portraitlandscapebtn setTitle: @"Portrait" forState: UIControlStateNormal];
        
        [test_conf setDevicePosition: Back];
        [backfrontbtn setTitle:@"Back" forState: UIControlStateNormal];
    
        test = [[MediaRecorder alloc] init];
        [test Open: test_conf callback:self];
        
        isStarted = YES;
    }
}
- (IBAction)stop_btn_click:(id)sender {
    if (isStarted) {
        [test Close];
        isStarted = NO;
    }
}

- (IBAction)stream_start_btn_click:(id)sender {
    if (streamurl.text.length > 0) {
        if ( [test_conf getStreamType] == STREAM_TYPE_RTMP_PUBLISH) {
            [test_conf setRTMPurl: streamurl.text ];
        } else if ( [test_conf getStreamType] == STREAM_TYPE_RTSP_SERVER ) {
            int port = [streamurl.text intValue];
            [test_conf setRTSPport:port];
        }
    }
    
    [test StartStreaming];
}
- (IBAction)stream_stop_btn_click:(id)sender {
    [test StopStreaming];
}
- (IBAction)record_start_btn_click:(id)sender {
    [test StartRecording];
}
- (IBAction)record_stop_btn_click:(id)sender {
    [test StopRecording];
}
- (IBAction)full_start_btn_click:(id)sender {
    [test Start];
}
- (IBAction)full_stop_btn_click:(id)sender {
    [test Stop];
}
- (IBAction)BackFrontBtn_click:(UIButton *)sender {
    if ([test_conf getDevicePosition] == Back){
        [sender setTitle: @"Front" forState: UIControlStateNormal];
    } else {
        [sender setTitle: @"Back" forState: UIControlStateNormal];
    }
    [test changeCapturePosition];
}
- (IBAction)PortraitLandscapeBtn_click:(UIButton *)sender {
    if ([test_conf getDeviceOrientation] == Portrait) {
        [sender setTitle: @"Landscape" forState: UIControlStateNormal];
    } else {
        [sender setTitle: @"Portrait" forState: UIControlStateNormal];
    }
    [test changeCaptureOrientation];
}

#pragma mark RTSP->RTMP

- (IBAction)transfer_rtsp_openBtn_click:(UIButton *)sender {
       [rtsprtmp OpenRtsp: @"rtsp://10.20.16.80:554" toRtmp:@"rtmp://media.auth2.cloud-svcp.com:1935/live/u17m167545c167132_rtmppublish?ticket=cam.eyJjIjogMTY3MTMyLCAic3J2IjogIm1lZGlhLmF1dGgyLmNsb3VkLXN2Y3AuY29tIn0.5bc46d25t12cff780.h31Y0G6NNr6wC2B9KI7astanIkw"];
}
- (IBAction)transfer_rtsp_closeBtn_clock:(UIButton *)sender {
     [rtsprtmp Close];
}
- (IBAction)transfer_rtsp_startBtn_click:(UIButton *)sender {
    [rtsprtmp Start];
}
- (IBAction)transfer_rtsp_stopBtn_click:(UIButton *)sender {
    [rtsprtmp Stop];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
