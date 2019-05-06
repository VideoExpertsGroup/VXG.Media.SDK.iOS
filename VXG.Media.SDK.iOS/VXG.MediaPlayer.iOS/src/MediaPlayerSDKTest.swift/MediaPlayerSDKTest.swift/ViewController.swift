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
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var ConnectBtn: UIButton!
    @IBOutlet weak var ScrenshotBtn: UIButton!
    @IBOutlet weak var StatusLine: UILabel!
    @IBOutlet weak var AddressLine: UITextField!
    @IBOutlet weak var ScreenShotImageView: UIImageView!
    @IBOutlet weak var VideoContentView: UIView!
    @IBOutlet weak var ScreenShotView: UIView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var callbackIV: UIImageView!
    
    private var isOpened : Bool = false;
    private var mPlayer: MediaPlayer? = nil;
    private let mConfig : MediaPlayerConfig = MediaPlayerConfig();
    
    //This constraints for videoContent at portrait mode
    @IBOutlet var cs_videoContent_bottom: NSLayoutConstraint!
    @IBOutlet var cs_videoContent_top: NSLayoutConstraint!
    @IBOutlet var cs_videoContent_lead: NSLayoutConstraint!
    @IBOutlet var cs_videoContent_trail: NSLayoutConstraint!

   //This constraints for videoContent at landscape mode, but they have 999 priority so they are going to work only if portrait constraits will be removed
    @IBOutlet var cs_videoContent_bottom_999: NSLayoutConstraint!
    @IBOutlet var cs_videoContent_top_999: NSLayoutConstraint!
    @IBOutlet var cs_videoContent_lead_999: NSLayoutConstraint!
    @IBOutlet var cs_videoContent_trail_999: NSLayoutConstraint!
    
    // MARK: MediaPlayerCallback
    
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
            print ( player.getStreamInfo() ?? "Can't get stream info");
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

        let bufcopy: UnsafeMutableRawPointer = UnsafeMutableRawPointer.allocate(byteCount: Int(size), alignment: 0);
        bufcopy.copyMemory(from: buffer, byteCount: Int(size));
        
        OperationQueue.main.addOperation {
            let image = self.makeImage(buffer: bufcopy, width: width, height: height, bytesPerRow: bytes_per_row);
            if (image != nil) {
                self.callbackIV.image = image;
            }
            bufcopy.deallocate();
        }
        return 0;
    }
 
    // MARK: Support functions
    
    func initPlayer(){
        getThumbnail(path: "rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov")
        
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
    
    func makeImage (buffer: UnsafeMutableRawPointer!, width: Int32, height: Int32, bytesPerRow: Int32 ) -> UIImage? {
        
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        // Create a bitmap graphics context with the sample buffer data.
        let bitmapinfo : CGBitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        let context = CGContext(data: buffer,
                                width: Int(width),
                                height: Int(height),
                                bitsPerComponent: 8,
                                bytesPerRow: Int(bytesPerRow),
                                space: colorSpace,
                                bitmapInfo: bitmapinfo.rawValue)
        
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage: CGImage = context!.makeImage()!
        let myImage = UIImage(cgImage: quartzImage)
        
        return myImage;
    }
    
    //demonstraiting work of thumbnailer - class for make images by video link
    func getThumbnail (path :String ) {
        let downloadThumbnailQueue = DispatchQueue(label: "Get Url Thumbnails")
        downloadThumbnailQueue.async(execute: {() -> Void in
            
            let thumb = Thumbnailer()
            let confThumb = ThumbnailerConfig()
            confThumb.connectionUrl = path
            confThumb.outWidth = 320
            confThumb.outHeight = 240
            let waitOpen: NSCondition? = thumb.open(confThumb)
            waitOpen?.lock()
            waitOpen?.wait()
            print("Tumbnailer wait finished.")
            waitOpen?.unlock()
            if thumb.getState() != ThumbnailerOpened {
                print("failed open thumbnailer")
                return
            }
            
            let wptr  : UnsafeMutablePointer<Int32>  = UnsafeMutablePointer<Int32>.allocate(capacity: 1);
            let hptr  : UnsafeMutablePointer<Int32>  = UnsafeMutablePointer<Int32>.allocate(capacity: 1);
            let brptr : UnsafeMutablePointer<Int32>  = UnsafeMutablePointer<Int32>.allocate(capacity: 1);
            
            var width : Int32 = 0;
            var height : Int32 = 0;
            var bprow : Int32 = 0;
            let bufsz: Int32  = confThumb.outWidth * confThumb.outHeight * 4
            
            wptr.initialize(to: Int32(width));
            hptr.initialize(to: Int32(height));
            brptr.initialize(to: Int32(bprow));
            
            let buffer = malloc( Int(bufsz) )
            let rc: Int32 = thumb.getFrame(buffer,
                                           buffer_size: bufsz,
                                           width: wptr,
                                           height: hptr,
                                           bytes_per_row: brptr)
            
            width = wptr.pointee;
            height = hptr.pointee;
            bprow = brptr.pointee;
            
            print ("Thumbnailer getFrame: rc:" + String(rc) + ", width: %d" + String(width) + ", height: " + String(height) + " bytes_per_row: " + String(bprow))
            thumb.close()
            if rc <= 0 {
                print( "failed get thumbnailer " + String(rc))
                free(buffer)
                return
            }

            let myImage = self.makeImage(buffer: buffer, width: width, height: height, bytesPerRow:  bprow)
            
            free(buffer)
            DispatchQueue.main.async(execute: {() -> Void in
                self.thumbnail.image = myImage;
            })
        })
    }
    
    func landscapeOrPortrait() {
        let w = mainView.frame.size.width
        let h = mainView.frame.size.height
        
        if (w >= h) {
            print("Landscape")
            
            mainView.removeConstraints([ cs_videoContent_top, cs_videoContent_lead, cs_videoContent_trail, cs_videoContent_bottom])
            
        } else {
            print("Portrait")
            
            mainView.addConstraints([ cs_videoContent_top, cs_videoContent_lead, cs_videoContent_trail, cs_videoContent_bottom])
        }
    }
    
    // MARK: Views functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initPlayer();
        
        AddressLine.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       self.landscapeOrPortrait()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();

        return true;
    }
    

    // MARK: Buttons clicks

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
            
            ConnectBtn.setTitle("Disconnect", for: UIControl.State.normal);
            
            isOpened = true;
        } else {
            self.mPlayer!.close();
            
            ConnectBtn.setTitle("Disconnect", for: UIControl.State.normal);
            isOpened = false;
        }
        
    }
    
    //demonstraiting work of VideoGetShot - func for make images from playing video
    @IBAction func ScreenShotBtn_click(_ sender: Any) {
        if (ScreenShotView.isHidden) {
            ScreenShotView.isHidden = false;
            ScrenshotBtn.setTitle("Hide screen", for: UIControl.State.normal);
            
            var bufsize: Int32 = 1920*1080*4+8;
            //let buffer = UnsafeMutableRawPointer.allocate(bytes: Int(bufsize), alignedTo: 0);
            let buffer = UnsafeMutableRawPointer.allocate(byteCount: Int(bufsize), alignment: 0);
            
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
                buffer.deallocate();
                return;
            } else if (rc == -1) {
                print(" Error in mediaPlayer")
                buffer.deallocate();
                return;
            }
            
            w = wptr.pointee;
            h = hptr.pointee;
            bp = brptr.pointee;
            bufsize = bsptr.pointee;
            
            ScreenShotImageView.image = self.makeImage(buffer:  buffer, width: w, height: h, bytesPerRow: bp);
            buffer.deallocate();
        } else {
            ScreenShotView.isHidden = true;
            ScrenshotBtn.setTitle("Screenshot", for: UIControl.State.normal);
        }
    }
    
    
}

