//
//  ViewController.swift
//  MediaPlayerSDKTest.swift
//
//  Created by user on 07/09/2017.
//  Copyright © 2017 VXG Inc. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import MediaPlayer


class ViewController: UIViewController, MediaPlayerCallback {
    
    @IBOutlet weak var ConnectBtn: UIButton!
    @IBOutlet weak var ScrenshotBtn: UIButton!
    @IBOutlet weak var StatusLine: UILabel!
    @IBOutlet weak var AddressLine: UITextField!
    @IBOutlet weak var ScreenShotImageView: UIImageView!
    @IBOutlet weak var VideoContentView: UIView!
    @IBOutlet weak var ScreenShotView: UIView!

    private var isOpened : Bool = false;
    private var mPlayer: MediaPlayer? = nil;
    private let mConfig : MediaPlayerConfig = MediaPlayerConfig();
    
    @objc func status(_ player: MediaPlayer!, args arg: Int32) -> Int32
    {
        print("Status arg is " + String(arg));
        
        let val: MediaPlayerNotifyCodes = MediaPlayerNotifyCodes(rawValue: arg)!;

        OperationQueue.main.addOperation(
            {
                self.StatusLine.text?.append(String(arg) + " ");
            }
        );
        switch val {
        case .PLP_CLOSE_SUCCESSFUL :
            OperationQueue.main.addOperation({
                self.ConnectBtn.setTitle("Connect", for:  UIControl.State.normal);
                self.isOpened = false;
            });
            break;
        case .PLP_BUILD_SUCCESSFUL :
            print ( player.getStreamInfo());
            break;
        default:
            break;
        }
        
        return 0;
    }
    
    @objc func onReceiveData(_ player: MediaPlayer!, buffer: UnsafeMutableRawPointer!, size: Int32, pts: Int64) -> Int32
    {
        return 0
    }

    @objc func onReceiveSubtitleString(_ player: MediaPlayer?, data: String?, duration: UInt64) -> Int32
    {
        return 0
    }
    @objc func onAudioSourceFrameAvailable(_ player: MediaPlayer!, buffer: UnsafeMutableRawPointer!, size: Int32, pts: Int, dts: Int, stream_index: Int32, format: Int32) -> Int32 {
        return 0;
    }
    @objc func onVideoSourceFrameAvailable(_ player: MediaPlayer!, buffer: UnsafeMutableRawPointer!, size: Int32, pts: Int, dts: Int, stream_index: Int32, format: Int32) -> Int32 {
        return 0;
    }
    @objc func onVideoRendererFrameAvailable(_ player: MediaPlayer!, buffer: UnsafeMutableRawPointer!, size: Int32, format_fourcc: UnsafeMutablePointer<Int8>!, width: Int32, height: Int32, bytes_per_row: Int32, pts: Int, will_show: Int32) -> Int32 {
        return 0;
    }
    
    
    func initPlayer(){
        self.mPlayer = MediaPlayer(CGRect(x: 0, y: 0, width: 320, height: 240));
        if(self.mPlayer != nil){
            mPlayer!.contentView().translatesAutoresizingMaskIntoConstraints = true
            
            mPlayer!.contentView().autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight];
            mPlayer!.contentView().bounds  = self.VideoContentView.bounds
            mPlayer!.contentView().center = CGPoint(x: self.VideoContentView.bounds.midX, y: self.VideoContentView.bounds.midY)
            
            mPlayer!.contentView().isUserInteractionEnabled = false
            mPlayer!.contentView().isHidden = true
            self.VideoContentView.addSubview(mPlayer!.contentView())
            self.VideoContentView.sendSubviewToBack(mPlayer!.contentView());
        }else{
            print("could not init player");
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initPlayer();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ConnectBtn_click(_ sender: Any) {
        if ( (AddressLine.text?.isEmpty == true) || (self.mPlayer == nil) ) {
            return;
        }
        if (!isOpened) {
            
            //MediaPlayerConfig.setLogLevel(MediaPlayerLogLevel.LOG_LEVEL_ERROR);
            //MediaPlayerConfig.setLogLevelForObjcPart(MediaPlayerLogLevel.LOG_LEVEL_TRACE);

            self.StatusLine.text = "";
            
            print("Play url: " +  AddressLine.text!);
            
            self.mConfig.connectionUrl              = AddressLine.text;
            self.mConfig.decodingType               = 1; // 1 - hardware, 0 - software
            self.mConfig.synchroEnable              = 1; // syncronization enabled
            self.mConfig.synchroNeedDropVideoFrames = 1; // synchroNeedDropVideoFrames
            self.mConfig.aspectRatioMode            = 1;
            self.mConfig.connectionNetworkProtocol  = -1; // // 0 - udp, 1 - tcp, 2 - http, 3 - https, -1 - AUTO
            self.mConfig.connectionDetectionTime    = 1000 // in milliseconds
            self.mConfig.connectionTimeout          = 60000;
            self.mConfig.decoderLatency             = 0;
            
            
            self.mConfig.synchroNeedDropVideoFrames = 0;
            self.mConfig.dataReceiveTimeout         = 60*1000;
            self.mConfig.numberOfCPUCores           = 1;
            
            self.mPlayer!.open(self.mConfig, callback: self)
            
            ConnectBtn.setTitle("Disconnect", for: UIControl.State.normal);
            
            isOpened = true;
        } else {
            self.mPlayer!.close();
            
            ConnectBtn.setTitle("Disconnect", for: UIControl.State.normal);
            isOpened = false;
        }
        
    }

    func getVideoShot(block: @escaping (UIImage) -> Void) {
        var width: Int32 = -1;
        var height: Int32 = -1;
        var bufferSize: Int32 = 5000 * 5000 * 4;
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: Int(bufferSize), alignment: 0);
        var bytesPerRow: Int32 = 0;

        let ret = self.mPlayer?.getVideoShot(buffer, buffer_size: &bufferSize, width: &width, height: &height, bytes_per_row: &bytesPerRow)
        if (ret == -2) {
            buffer.deallocate();
            return;
        } else if (ret == -1) {
            buffer.deallocate();
            return;
        }
        
        let releaseForShotCreateDataCallback: CGDataProviderReleaseDataCallback = {
            (_ pixelPtr: UnsafeMutableRawPointer?, _ data: UnsafeRawPointer, _ size: Int) in
                data.deallocate();
        }
        let provider = CGDataProvider.init(dataInfo: nil, data: buffer, size: Int(bufferSize), releaseData: releaseForShotCreateDataCallback)!
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        let bitmapinfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue);
        let renderingIntent = CGColorRenderingIntent.defaultIntent;
        let imageRef: CGImage = CGImage.init(width: Int(width), height: Int(height), bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: Int(bytesPerRow), space: colorSpaceRef, bitmapInfo: bitmapinfo, provider: provider, decode: nil, shouldInterpolate: false, intent: renderingIntent)!;

        block(UIImage.init(cgImage: imageRef))
    }

    @IBAction func ScreenShotBtn_click(_ sender: Any) {
        if (ScreenShotView.isHidden) {
            ScreenShotView.isHidden = false;
            ScrenshotBtn.setTitle("Hide screen", for: UIControl.State.normal);
            
            getVideoShot { (image) in
                self.ScreenShotImageView.image = image;
            }
        } else {
            ScreenShotView.isHidden = true;
            ScrenshotBtn.setTitle("Screenshot", for: UIControl.State.normal);
        }
    }
    
    
}

