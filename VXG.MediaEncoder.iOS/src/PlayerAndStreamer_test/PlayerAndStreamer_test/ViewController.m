//
//  ViewController.m
//  PlayerAndStreamer_test
//
//  Created by user on 13/06/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import "ViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController {
    MediaPlayerConfig* vxg_player_cfg;
    MediaPlayer*    vxg_player;
    
    MediaCaptureConfig* vxg_capture_cfg;
    MediaRecorder*  vxg_capture;
    __weak IBOutlet UIView *vw_player;
    __weak IBOutlet UIView *vw_capture;
    
    __weak IBOutlet UITextField *tf_player;
    __weak IBOutlet UIButton *b_player;
    __weak IBOutlet UILabel *lbl_connecting;
    __weak IBOutlet UILabel *lbl_connecting_2;
    
    __weak IBOutlet UITextField *tf_capture;
    __weak IBOutlet UIButton *b_capture;
    
    NSString* ip;
}

// Get IP Address
- (NSString *)GetOurIpAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    vxg_capture_cfg = [[MediaCaptureConfig alloc] init];
    [vxg_capture_cfg setPreview: vw_capture];
    [vxg_capture_cfg setDeviceOrientation: Portrait];
    [vxg_capture_cfg setDevicePosition: Back];
    [vxg_capture_cfg setVideoFormat: VIDEO_FORMAT_H264];
    [vxg_capture_cfg setAudioFormat: AUDIO_FORMAT_AAC];
    [vxg_capture_cfg setLicenseKey: @"insert llicense key here"];
    [vxg_capture_cfg setVideoConfig: 640 : 480 : 30 : 512*1024];
    [vxg_capture_cfg setStreamType: STREAM_TYPE_RTSP_SERVER];
    [vxg_capture_cfg setRTSPport: 5540];
    if ([vxg_capture_cfg getStreamType] == STREAM_TYPE_RTSP_SERVER) {
        ip = [self GetOurIpAddress];
        
        tf_capture.text = [NSString stringWithFormat:@"RTSP: rtsp://%@:%d", ip,[vxg_capture_cfg getRTSPport]];
        //tf_capture.enabled = NO;
    }
    
    vxg_capture = [[MediaRecorder alloc] init];
    [vxg_capture Open: vxg_capture_cfg callback: self];
    
    
    
    vxg_player_cfg = [[MediaPlayerConfig alloc] init];
    [vxg_player_cfg setLicenseKey:@"insert license key here"];
    [vxg_player_cfg setConnectionUrl: tf_player.text ];
    [vxg_player_cfg setConnectionNetworkProtocol: -1];
    [vxg_player_cfg setConnectionBufferingTime: 5000];
    [vxg_player_cfg setConnectionDetectionTime: 3000];
    [vxg_player_cfg setDecodingType: 1];
    [vxg_player_cfg setRendererType: 1];
    [vxg_player_cfg setSynchroEnable: 1];
    [vxg_player_cfg setSynchroNeedDropVideoFrames: 1];
    [vxg_player_cfg setEnableColorVideo: 1];
    [vxg_player_cfg setDataReceiveTimeout: 30000];
    [vxg_player_cfg setNumberOfCPUCores: 0];
    
    vxg_player  = [[MediaPlayer alloc] init: [vw_player bounds]];
    [vw_player addSubview: [vxg_player contentView]];
    
    tf_player.delegate = self;
    tf_capture.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (int)Status:(MediaPlayer *)player args:(int)arg {
    NSLog(@"%s called with val %d\n", __func__, arg);
    switch (arg) {
        case PLP_PLAY_STARTING: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [lbl_connecting setHidden: YES];
                b_player.tag = 2;
            });
        } break;
        case PLP_ERROR:
        case PLP_EOS:
        case PLP_BUILD_FAILED:
        case PLP_PLAY_FAILED:
        case CP_CONNECT_FAILED: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [lbl_connecting setHidden: YES];
                b_player.tag = 0;
                [b_player setTitle: @"Start Video" forState: UIControlStateNormal];
                [vxg_player Close];
            });

        }
            
    }
    
    return 0;
}


- (int)Status:(NSString *)who :(int)arg {
    NSLog(@"%s called with val %d", __func__, arg);
    switch ( arg ) {
        case MUXRTSP_STARTED:
        case MUXRTMP_STARTED: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [lbl_connecting_2 setHidden: YES];
                b_capture.tag = 2;
            });
        }break;
    }
    
    
    return 0;
}

- (IBAction)b_video_start:(UIButton*)sender {
    if (sender.tag == 0) {
        [vxg_player_cfg setConnectionUrl: tf_player.text];
        [vxg_player Open: vxg_player_cfg callback: self];
        [sender setTitle: @"Stop Video" forState: UIControlStateNormal];
        sender.tag = 1;
        lbl_connecting.hidden = NO;
    } else if (sender.tag == 2) {
        [vxg_player Close];
        [sender setTitle: @"Start Video" forState: UIControlStateNormal];
        sender.tag = 0;
    }
}

- (IBAction)b_stream_start:(UIButton *)sender {
    if (sender.tag == 0) {
        [vxg_capture StartStreaming];
        [b_capture setTitle: @"Stop Stream" forState: UIControlStateNormal];
        [lbl_connecting_2 setHidden: NO];
        sender.tag = 1;
    } else if (sender.tag == 2) {
        [vxg_capture StopStreaming];
        [b_capture setTitle: @"Start Stream" forState: UIControlStateNormal];
        sender.tag = 0;
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
