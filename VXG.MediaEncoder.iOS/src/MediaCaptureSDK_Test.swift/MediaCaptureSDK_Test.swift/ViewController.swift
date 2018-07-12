//
//  ViewController.swift
//  MediaCaptureSDK_Test.swift
//
//  Created by user on 18/06/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation


class ViewController: UIViewController, MediaCaptureCallback {
    @IBOutlet weak var v_preview: UIView!
    @IBOutlet weak var tf_textfield: UITextField!
    @IBOutlet weak var b_startstop: UIButton!
    
    private var mMediaCaptureConfig: MediaCaptureConfig = MediaCaptureConfig.init();
    private var mMediaRecorder: MediaRecorder = MediaRecorder.init();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        VXG_CaptureSDK_LogLevel = LogLevels.LL_DEBUG.rawValue;
        
        OperationQueue.main.addOperation {
            self.mMediaCaptureConfig.setVideo(640, 480, 30, 256);
            self.mMediaCaptureConfig.setPreview(self.v_preview);
            self.mMediaCaptureConfig.setStreamType(StreamType.STREAM_TYPE_RTSP_SERVER);
            self.mMediaCaptureConfig.setVideoFormat(VideoFormat.VIDEO_FORMAT_H264);
            self.mMediaCaptureConfig.setAudioFormat(AudioFormat.AUDIO_FORMAT_AAC);
            self.mMediaCaptureConfig.setDevicePosition( CaptureDevicePosition.Back);
            //self.mMediaCaptureConfig.setRTMPurl("rtmp://url");
            self.mMediaCaptureConfig.setRTSPport( 5540 );
            if (self.mMediaCaptureConfig.getStreamType() == StreamType.STREAM_TYPE_RTSP_SERVER) {
                self.tf_textfield.text = self.getWiFiAddress()! + ":" + String( self.mMediaCaptureConfig.getRTSPport());
            } else {
                self.tf_textfield.text = String(self.mMediaCaptureConfig.getRTMPurl());
            }
            
            self.mMediaRecorder.open( self.mMediaCaptureConfig, callback: self);
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func status(_ who: String!, _ arg: Int32) -> Int32 {
        let code: CaptureNotifyCodes = CaptureNotifyCodes(rawValue: arg)!;
        print("MediaCaptureCallback, who: " + who + ", arg: " + String(arg));
        switch code {
        case .FULL_CLOSE:
            
            break;
        case .MUXRTMP_STARTED, .MUXRTSP_STARTED:
            OperationQueue.main.addOperation {
                self.b_startstop.tag = 2;
                self.b_startstop.setTitle("Stop stream", for: UIControlState.normal);
            }
            break;
        case .MUXRTMP_STOPED, .MUXRTSP_STOPED:
            
            break;
            
        default:
            break;
        }
        return 0;
    }

    @IBAction func b_startstop_click(_ sender: UIButton) {
        if (sender.tag == 0) {
            self.mMediaRecorder.start();
            sender.setTitle("Starting...", for: UIControlState.normal);
            sender.tag = 1;
        } else if (sender.tag == 2) {
            self.mMediaRecorder.stop();
            sender.setTitle("Start stream", for: UIControlState.normal);
            sender.tag = 0;
        }
    }
    
    @IBAction func b_backfront_click(_ sender: UIButton) {
        if (sender.tag == 0 ) {
            sender.tag = 1;
            sender.setTitle("Front", for: UIControlState.normal);
        } else {
            sender.tag = 0;
            sender.setTitle("Back", for: UIControlState.normal);
        }
        self.mMediaRecorder.changeCapturePosition();
    }
    
    func getWiFiAddress() -> String? {
        var address : String?
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
}

