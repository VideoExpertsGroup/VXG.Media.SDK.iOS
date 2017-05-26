

using System;
using UIKit;
using MediaPlayerSDK;

namespace VXGMediaPlayerSampleApp
{




	public partial class ViewController : UIViewController
	{
		public partial class Callback : MediaPlayerSDK.MediaPlayerCallback
		{
			public ViewController _delegate;

			public override int Status(MediaPlayerSDK.MediaPlayer player, int arg)
			{
				System.Console.WriteLine(String.Format("<binary> status: {0} ", arg));

				if (_delegate != null) {
					BeginInvokeOnMainThread( () => {  _delegate.DebugLbl.Text  +=  String.Format(" {0}", arg); });
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
						ConnectionDetectionTime = 300,
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

				_mediaPlayer?.Close();
			}
			//throw new NotImplementedException();
		}

		protected ViewController(IntPtr handle) : base(handle) {
	// Note: this .ctor should not contain any initialization logic.
		}

		public override void ViewDidLoad()
		{
			base.ViewDidLoad();

			_mediaPlayer = new MediaPlayerSDK.MediaPlayer(VideoContentView.Bounds);
			VideoContentView.AddSubview(_mediaPlayer?.ContentView);

		}

        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.
        }

    }
}
