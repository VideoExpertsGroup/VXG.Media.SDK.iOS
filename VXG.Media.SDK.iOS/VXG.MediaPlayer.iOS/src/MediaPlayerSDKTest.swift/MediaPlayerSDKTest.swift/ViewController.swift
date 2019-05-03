//
//  ViewController.swift
//  MediaPlayerSDKTest.swift
//
//  Created by user on 07/09/2017.
//  Copyright © 2017 veg. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import MediaPlayer


class ViewController: UIViewController, MediaPlayerCallback, UITextFieldDelegate {
    
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
                self.ConnectBtn.setTitle("Connect", for:  UIControlState.normal);
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
    
    
    @objc func onReceiveData(_ player: MediaPlayer?, buffer: UnsafeMutableRawPointer, size: Int32, pts: Int) -> Int32
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
            self.VideoContentView.sendSubview(toBack: mPlayer!.contentView());
        }else{
            print("could not init player");
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initPlayer();
        
        AddressLine.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();

        return true;
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
            //self.mConfig.licenseKey                 = "place license string for your bundle-id here or to file 'license'" ;
            
            self.mConfig.synchroNeedDropVideoFrames = 0;
            self.mConfig.dataReceiveTimeout         = 60*1000;
            self.mConfig.numberOfCPUCores           = 1;
            
            self.mPlayer!.open(self.mConfig, callback: self)
            
            ConnectBtn.setTitle("Disconnect", for: UIControlState.normal);
            
            isOpened = true;
        } else {
            self.mPlayer!.close();
            
            ConnectBtn.setTitle("Disconnect", for: UIControlState.normal);
            isOpened = false;
        }
        
    }

    @IBAction func ScreenShotBtn_click(_ sender: Any) {
        if (ScreenShotView.isHidden) {
            ScreenShotView.isHidden = false;
            ScrenshotBtn.setTitle("Hide screen", for: UIControlState.normal);
            
            var bufsize: Int32 = 1920*1080*4+8;
            var bufsize_initial = bufsize;
            let buffer = UnsafeMutableRawPointer.allocate(bytes: Int(bufsize), alignedTo: 0);
            
            let wptr  : UnsafeMutablePointer<Int32>  = UnsafeMutablePointer<Int32>.allocate(capacity: 1);
            let hptr  : UnsafeMutablePointer<Int32>  = UnsafeMutablePointer<Int32>.allocate(capacity: 1);
            let bsptr : UnsafeMutablePointer<Int32>  = UnsafeMutablePointer<Int32>.allocate(capacity: 1);
            let brptr : UnsafeMutablePointer<Int32>  = UnsafeMutablePointer<Int32>.allocate(capacity: 1);
            
            var w : Int32 = -1;
            var h : Int32 = -1;
            var bp : Int32 = -1;
            
            wptr.initialize(to: Int32(w));
            hptr.initialize(to: Int32(h));
            bsptr.initialize(to: bufsize);
            brptr.initialize(to: Int32(bp));
            
            let rc = self.mPlayer?.getVideoShot(buffer, buffer_size: bsptr, width: wptr, height: hptr, bytes_per_row: brptr);
            
            if (rc == -2) {
                print("Not enough buffer space");
                buffer.deallocate(bytes: Int(bufsize_initial), alignedTo: 0);
                return;
            } else if (rc == -1) {
                print(" Error in mediaPlayer")
                buffer.deallocate(bytes: Int(bufsize_initial), alignedTo: 0);
                return;
            }
            
            w = wptr.pointee;
            h = hptr.pointee;
            bp = brptr.pointee;
            bufsize = bsptr.pointee;
            
            let releaseMaskImagePixelData : CGDataProviderReleaseDataCallback = {( info: UnsafeMutableRawPointer?, data: UnsafeRawPointer, size: Int) -> () in return }
            
            let provider : CGDataProvider = CGDataProvider.init(dataInfo: nil, data: buffer, size: Int(bufsize), releaseData: releaseMaskImagePixelData)!
            let bytesPerRow: Int = Int(bp);
            let colorSpaceRef: CGColorSpace? = CGColorSpaceCreateDeviceRGB();
            let bitmapinfo : CGBitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue);//CGBitmapInfo.byteOrder32Little ;
            
            let renderingIntent = CGColorRenderingIntent.defaultIntent;
            
            let imageRef: CGImage = CGImage.init(width: Int(w), height: Int(h), bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: bytesPerRow, space: colorSpaceRef!, bitmapInfo: bitmapinfo, provider: provider, decode: nil, shouldInterpolate: true, intent: renderingIntent)!;
            
            ScreenShotImageView.image = UIImage.init(cgImage: imageRef);
            
        } else {
            ScreenShotView.isHidden = true;
            ScrenshotBtn.setTitle("Screenshot", for: UIControlState.normal);
        }
    }
    
    
}

