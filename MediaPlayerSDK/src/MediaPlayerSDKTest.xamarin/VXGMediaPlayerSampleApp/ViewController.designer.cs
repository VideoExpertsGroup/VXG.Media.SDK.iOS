// WARNING
//
// This file has been generated automatically by Xamarin Studio from the outlets and
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
        UIKit.UILabel DebugLbl { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UITextField URL_textfield { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UIView VideoContentView { get; set; }

        [Action ("ConnectBtn_down:")]
        [GeneratedCode ("iOS Designer", "1.0")]
        partial void ConnectBtn_down (UIKit.UIButton sender);

        void ReleaseDesignerOutlets ()
        {
            if (DebugLbl != null) {
                DebugLbl.Dispose ();
                DebugLbl = null;
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