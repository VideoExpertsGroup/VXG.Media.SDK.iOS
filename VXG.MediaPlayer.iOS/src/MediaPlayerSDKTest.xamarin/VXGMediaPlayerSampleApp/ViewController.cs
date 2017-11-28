

using System;
using System.IO;
using System.Runtime.InteropServices;
using UIKit;
using CoreGraphics;
using MediaPlayerSDK;


namespace VXGMediaPlayerSampleApp
{
	public partial class ViewController : UIViewController
	{



		Boolean isScreen = false;

		public partial class Callback : MediaPlayerSDK.MediaPlayerCallback
		{
			public ViewController _delegate;

			public override int Status(MediaPlayerSDK.MediaPlayer player, int arg)
			{
				System.Console.WriteLine(String.Format("<binary> status: {0} \n ", arg));

				if (_delegate != null) {
					BeginInvokeOnMainThread( () => {  _delegate.DebugLbl.Text  +=  String.Format(" {0}", arg); });
                    if (arg == (int)MediaPlayerSDK.MediaPlayerNotifyCodes.PlpCloseSuccessful)
                    {
                        BeginInvokeOnMainThread(() =>
                        {
                            _delegate.ConnectBtn.SetTitle("Connect", UIControlState.Normal);
                            _delegate.ConnectBtn.Tag = 0;

                            _delegate.RecordBtn.Enabled = false;
                        });
                    }
                    if (arg == (int)MediaPlayerSDK.MediaPlayerNotifyCodes.PlpBuildSuccessful)
                    {
                        System.Console.WriteLine(player.StreamInfo);
                        BeginInvokeOnMainThread(() => {
                            _delegate.RecordBtn.SetTitle("Record", UIControlState.Normal);
                            _delegate.RecordBtn.Tag = 0;
                            _delegate.RecordBtn.Enabled = true;
                        });
                    }
                    if (arg == (int)MediaPlayerSDK.MediaPlayerNotifyCodes.CpRecordStopped) {
                        string recfile = player.RecordGetFileName(0);
                        System.Console.Write(String.Format("STOPPED (arg {0} ): file recorded {1} \n", arg, recfile) );
                    }
                    if (arg == (int) MediaPlayerSDK.MediaPlayerNotifyCodes.CpRecordClosed) {
                        string recfile = player.RecordGetFileName(0);
                        System.Console.Write(String.Format("CLOSED: file recorded: {0} \n", recfile));

                        BeginInvokeOnMainThread( () => {
                            if(UIKit.UIVideo.IsCompatibleWithSavedPhotosAlbum(recfile)) {
                                System.Console.Write(String.Format("PHOTOS: Can save \n"));

                                UIKit.UIVideo.SaveToPhotosAlbum(recfile, (path, error) => {
                                    System.Console.Write(String.Format("PHOTOS: Saved succesfully \n"));
                                });
                            } else {
                                System.Console.Write(String.Format("PHOTOS: Can't save \n"));
                            }
                        });

                    }
				}
				return 0;
			}

			public override int OnReceiveData(MediaPlayerSDK.MediaPlayer player, IntPtr buffer, int size, nint pts)
			{
				return 0;
			}
			public override int OnReceiveSubtitleString(MediaPlayerSDK.MediaPlayer player, string data, ulong duration)
			{
				return 0;
			}
			public override int OnVideoSourceFrameAvailable(MediaPlayerSDK.MediaPlayer player, IntPtr buffer, int size, nint pts, nint dts, int stream_index, int format)
			{
				//BeginInvokeOnMainThread( () => {  _delegate.DebugLbl.Text  =  String.Format("pts {0}",  pts); });
				return 0;
			}
			public override int OnAudioSourceFrameAvailable(MediaPlayerSDK.MediaPlayer player, IntPtr buffer, int size, nint pts, nint dts, int stream_index, int format)
			{
				return 0;
			}


		}

		private MediaPlayerSDK.MediaPlayer _mediaPlayer;
        private string filepath;
        private string latestfile;


		partial void ScreenButton_down(UIButton sender)
		{
			
			if (!isScreen)
			{
				ScreenshotView.Hidden	= false;
				ScreenBtn.SetTitle("Hide screen", UIControlState.Normal);
				isScreen = true;

				int val = 1920 * 1080 * 4 + 8; //ARGB 1920x1080 + 8(iosspecific)
				IntPtr b = Marshal.AllocHGlobal(val);


				int val1 = -1; //return realsize after getvideoshot
				int val2 = -1; //return realsize after getvideoshot	
				int val3 = 0;  //return realsize after getvideoshot

				int rc = _mediaPlayer.GetVideoShot(b, ref val, ref val1, ref val2, ref val3);
				if (rc == -2){
					System.Console.WriteLine(String.Format("<binary> rc: {0} , not enough space allocated", rc));
					Marshal.FreeHGlobal(b);
					return;
				} else if (rc == -1) {
					System.Console.WriteLine(String.Format("<binary> rc: {0} , error", rc));
					Marshal.FreeHGlobal(b);
					return;
				}


				CGDataProvider provider = new CGDataProvider(b, val);
				int bitsPerComponent = 8;
				int bitsPerPixel = 32;
				int bytesPerRow = val3;

				CGColorSpace colorspaceref = CGColorSpace.CreateDeviceRGB();
				CGBitmapFlags bitmapinfo = CGBitmapFlags.ByteOrder32Little | CGBitmapFlags.NoneSkipFirst;
				CGColorRenderingIntent renderintent = CGColorRenderingIntent.Default;
				CGImage imageref = new CGImage(val1, val2, bitsPerComponent, bitsPerPixel, val3, colorspaceref, bitmapinfo, provider, null, true, renderintent);

				UIImage img = new UIImage(imageref);
				ScrenShotImageView.Image 	= img;
				Marshal.FreeHGlobal(b);
			} else {
				ScreenBtn.SetTitle("Screen", UIControlState.Normal);
				ScreenshotView.Hidden	= true;
				isScreen = false;
			}
		}	

		partial void ConnectBtn_down(UIButton sender)
		{
			if (sender.Tag == 0) {
				DebugLbl.Text = "Status: ";
				sender.SetTitle("Disconnect", UIControlState.Normal);
				sender.Tag = 1;

				_mediaPlayer?.Open(new MediaPlayerConfig
					{
						ConnectionUrl = URL_textfield.Text,
						ConnectionNetworkProtocol = -1,
						ConnectionBufferingTime = 5000,
						ConnectionDetectionTime = 3000,
						DecodingType = 1,
						RendererType = 1,
						SynchroEnable = 1,
						SynchroNeedDropVideoFrames = 1,
						EnableColorVideo = 1,
						DataReceiveTimeout = 30000,
						NumberOfCPUCores = 0
				}, new Callback { _delegate = this } );
				int rc = _mediaPlayer.UpdateView;

			} else {
                
				sender.SetTitle("Connect", UIControlState.Normal);
				sender.Tag = 0;

                if (RecordBtn.Tag == 1)
                {
                    _mediaPlayer?.RecordStop();

                    RecordBtn.Enabled = false;
                    RecordBtn.SetTitle("Record", UIControlState.Normal);
                    RecordBtn.Tag = 0;

                }

				_mediaPlayer?.Close();
			}
			//throw new NotImplementedException();
		}

        partial void RecordButton_down(UIButton sender)
        {
            if (sender.Tag == 0) {
                sender.Tag = 1;
                sender.SetTitle("Recording", UIControlState.Normal);

                _mediaPlayer.RecordSetup(filepath, 
                                         MediaPlayerRecordFlags.FastStart | MediaPlayerRecordFlags.PtsCorrection | MediaPlayerRecordFlags.FragKeyframe, 0 , 0, "rec"
                                        );
                
                _mediaPlayer.RecordStart();
            } else {
                sender.Tag = 0;
                sender.SetTitle("Record", UIControlState.Normal);

                _mediaPlayer.RecordStop();

            }
        }


		protected ViewController(IntPtr handle) : base(handle) {
	// Note: this .ctor should not contain any initialization logic.
		}



        public override void ViewDidLoad()
		{
			base.ViewDidLoad();


			_mediaPlayer = new MediaPlayerSDK.MediaPlayer(VideoContentView.Bounds);
			VideoContentView.AddSubview(_mediaPlayer?.ContentView);

            var documents = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
            filepath = Path.Combine(documents, "..", "tmp");


		}

        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.
        }

    }
}
