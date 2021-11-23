// WARNING
//
// This file has been generated automatically by Visual Studio from the outlets and
// actions declared in your storyboard file.
// Manual changes to this file will not be maintained.
//
using Foundation;
using System;
using System.CodeDom.Compiler;

namespace VXGMediaPlayerSampleApp
{
    [Register ("ViewController")]
    partial class ViewController
    {
        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UIButton ConnectBtn { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UILabel DebugLbl { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UIButton ScreenBtn { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UIView ScreenshotView { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UIImageView ScrenShotImageView { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UITextField URL_textfield { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UIView VideoContentView { get; set; }

        [Action ("ConnectBtn_down:")]
        [GeneratedCode ("iOS Designer", "1.0")]
        partial void ConnectBtn_down (UIKit.UIButton sender);

        [Action ("ScreenButton_down:")]
        [GeneratedCode ("iOS Designer", "1.0")]
        partial void ScreenButton_down (UIKit.UIButton sender);

        void ReleaseDesignerOutlets ()
        {
            if (ConnectBtn != null) {
                ConnectBtn.Dispose ();
                ConnectBtn = null;
            }

            if (DebugLbl != null) {
                DebugLbl.Dispose ();
                DebugLbl = null;
            }

            if (ScreenBtn != null) {
                ScreenBtn.Dispose ();
                ScreenBtn = null;
            }

            if (ScreenshotView != null) {
                ScreenshotView.Dispose ();
                ScreenshotView = null;
            }

            if (ScrenShotImageView != null) {
                ScrenShotImageView.Dispose ();
                ScrenShotImageView = null;
            }

            if (URL_textfield != null) {
                URL_textfield.Dispose ();
                URL_textfield = null;
            }

            if (VideoContentView != null) {
                VideoContentView.Dispose ();
                VideoContentView = null;
            }
        }
    }
}