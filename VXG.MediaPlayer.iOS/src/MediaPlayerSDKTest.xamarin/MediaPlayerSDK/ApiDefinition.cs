using System;
using CoreGraphics;
using Foundation;
using ObjCRuntime;
using UIKit;

namespace MediaPlayerSDK
{
	// @interface HLSStream : NSObject
	[BaseType(typeof(NSObject))]
	interface HLSStream
	{
		// @property (nonatomic) NSString * URL;
		[Export("URL")]
		string URL { get; set; }

		// @property (nonatomic) NSString * ID;
		[Export("ID")]
		string ID { get; set; }

		// @property (nonatomic) NSString * BANDWIDTH;
		[Export("BANDWIDTH")]
		string BANDWIDTH { get; set; }

		// @property (nonatomic) NSString * CODECS;
		[Export("CODECS")]
		string CODECS { get; set; }

		// @property (nonatomic) NSString * RESOLUTION;
		[Export("RESOLUTION")]
		string RESOLUTION { get; set; }

		// @property (nonatomic) NSString * WIDTH;
		[Export("WIDTH")]
		string WIDTH { get; set; }
	}

	// @interface M3U8 : NSObject
	[BaseType(typeof(NSObject))]
	interface M3U8
	{
		// -(NSMutableArray *)getChannelsList;
		[Export("getChannelsList")]
		//[Verify (MethodToProperty)]
		NSMutableArray ChannelsList { get; }

		// -(BOOL)getDataSynchroAndParse:(NSString *)url;
		[Export("getDataSynchroAndParse:")]
		bool GetDataSynchroAndParse(string url);
	}

	// @interface MediaPlayerConfig : NSObject
	[BaseType(typeof(NSObject))]
	interface MediaPlayerConfig
	{
		// @property (nonatomic) NSString * connectionUrl;
		[Export("connectionUrl")]
		string ConnectionUrl { get; set; }

		// @property (nonatomic) int connectionNetworkProtocol;
		[Export("connectionNetworkProtocol")]
		int ConnectionNetworkProtocol { get; set; }

		// @property (nonatomic) int connectionDetectionTime;
		[Export("connectionDetectionTime")]
		int ConnectionDetectionTime { get; set; }

		// @property (nonatomic) int connectionBufferingType;
		[Export("connectionBufferingType")]
		int ConnectionBufferingType { get; set; }

		// @property (nonatomic) int connectionBufferingTime;
		[Export("connectionBufferingTime")]
		int ConnectionBufferingTime { get; set; }

		// @property (nonatomic) int connectionBufferingSize;
		[Export("connectionBufferingSize")]
		int ConnectionBufferingSize { get; set; }

		// @property (nonatomic) int connectionTimeout;
		[Export("connectionTimeout")]
		int ConnectionTimeout { get; set; }

		// @property (nonatomic) int dataReceiveTimeout;
		[Export("dataReceiveTimeout")]
		int DataReceiveTimeout { get; set; }

		// @property (nonatomic) int enableInterruptOnClose;
		[Export("enableInterruptOnClose")]
		int EnableInterruptOnClose { get; set; }

		// @property (nonatomic) int extraDataFilter;
		[Export("extraDataFilter")]
		int ExtraDataFilter { get; set; }

		// @property (nonatomic) int decodingType;
		[Export("decodingType")]
		int DecodingType { get; set; }

		// @property (nonatomic) int extraDataOnStart;
		[Export("extraDataOnStart")]
		int ExtraDataOnStart { get; set; }

		// @property (nonatomic) int decoderLatency;
		[Export("decoderLatency")]
		int DecoderLatency { get; set; }

		// @property (nonatomic) int rendererType;
		[Export("rendererType")]
		int RendererType { get; set; }

		// @property (nonatomic) int synchroEnable;
		[Export("synchroEnable")]
		int SynchroEnable { get; set; }

		// @property (nonatomic) int synchroNeedDropVideoFrames;
		[Export("synchroNeedDropVideoFrames")]
		int SynchroNeedDropVideoFrames { get; set; }

		// @property (nonatomic) int synchroNeedDropFramesOnFF;
		[Export("synchroNeedDropFramesOnFF")]
		int SynchroNeedDropFramesOnFF { get; set; }

		// @property (nonatomic) int videoRotate;
		[Export("videoRotate")]
		int VideoRotate { get; set; }

		// @property (nonatomic) int enableColorVideo;
		[Export("enableColorVideo")]
		int EnableColorVideo { get; set; }

		// @property (nonatomic) int aspectRatioMode;
		[Export("aspectRatioMode")]
		int AspectRatioMode { get; set; }

		// @property (nonatomic) int aspectRatioZoomModePercent;
		[Export("aspectRatioZoomModePercent")]
		int AspectRatioZoomModePercent { get; set; }

		// @property (nonatomic) int aspectRatioMoveModeX;
		[Export("aspectRatioMoveModeX")]
		int AspectRatioMoveModeX { get; set; }

		// @property (nonatomic) int aspectRatioMoveModeY;
		[Export("aspectRatioMoveModeY")]
		int AspectRatioMoveModeY { get; set; }

		// @property (nonatomic) int enableAudio;
		[Export("enableAudio")]
		int EnableAudio { get; set; }

		// @property (nonatomic) int colorBackground;
		[Export("colorBackground")]
		int ColorBackground { get; set; }

		// @property (nonatomic) int numberOfCPUCores;
		[Export("numberOfCPUCores")]
		int NumberOfCPUCores { get; set; }

		// @property (nonatomic) float bogoMIPS;
		[Export("bogoMIPS")]
		float BogoMIPS { get; set; }

		// @property (nonatomic) NSString * sslKey;
		[Export("sslKey")]
		string SslKey { get; set; }

		// @property (nonatomic) int extStream;
		[Export("extStream")]
		int ExtStream { get; set; }

		// @property (nonatomic) uint64_t startOffest;
		[Export("startOffest")]
		ulong StartOffest { get; set; }

		// @property (nonatomic) int startPreroll;
		[Export("startPreroll")]
		int StartPreroll { get; set; }

		// @property (nonatomic) NSString * startPath;
		[Export("startPath")]
		string StartPath { get; set; }

		// @property (nonatomic) NSString * startCookies;
		[Export("startCookies")]
		string StartCookies { get; set; }

		// @property (nonatomic) int ffRate;
		[Export("ffRate")]
		int FfRate { get; set; }

		// @property (nonatomic) int volumeDetectMaxSamples;
		[Export("volumeDetectMaxSamples")]
		int VolumeDetectMaxSamples { get; set; }

		// @property (nonatomic) int volumeBoost;
		[Export("volumeBoost")]
		int VolumeBoost { get; set; }

		// @property (nonatomic) int fadeOnStart;
		[Export("fadeOnStart")]
		int FadeOnStart { get; set; }

		// @property (nonatomic) int fadeOnSeek;
		[Export("fadeOnSeek")]
		int FadeOnSeek { get; set; }

		// @property (nonatomic) int fadeOnRate;
		[Export("fadeOnRate")]
		int FadeOnRate { get; set; }

		// @property (nonatomic) NSString * recordPath;
		[Export("recordPath")]
		string RecordPath { get; set; }

		// @property (nonatomic) MediaPlayerRecordFlags recordFlags;
		[Export("recordFlags", ArgumentSemantic.Assign)]
		MediaPlayerRecordFlags RecordFlags { get; set; }

		// @property (nonatomic) int recordSplitTime;
		[Export("recordSplitTime")]
		int RecordSplitTime { get; set; }

		// @property (nonatomic) int recordSplitSize;
		[Export("recordSplitSize")]
		int RecordSplitSize { get; set; }

		// @property (nonatomic) NSString * recordPrefix;
		[Export("recordPrefix")]
		string RecordPrefix { get; set; }

		// @property (nonatomic) int64_t recordTrimPosStart;
		[Export("recordTrimPosStart")]
		long RecordTrimPosStart { get; set; }

		// @property (nonatomic) int64_t recordTrimPosEnd;
		[Export("recordTrimPosEnd")]
		long RecordTrimPosEnd { get; set; }

		// @property (nonatomic) int selectAudio;
		[Export("selectAudio")]
		int SelectAudio { get; set; }

		// @property (nonatomic) int selectSubtitle;
		[Export("selectSubtitle")]
		int SelectSubtitle { get; set; }

		// @property (nonatomic) NSMutableArray * subtitlePaths;
		[Export("subtitlePaths", ArgumentSemantic.Assign)]
		NSMutableArray SubtitlePaths { get; set; }

		// @property (nonatomic) MediaPlayerModes playerMode;
		[Export("playerMode", ArgumentSemantic.Assign)]
		MediaPlayerModes PlayerMode { get; set; }

		// @property (nonatomic) int enableABR;
		[Export("enableABR")]
		int EnableABR { get; set; }

		// @property (nonatomic) int playbackSendPlayPauseToServer;
		[Export("playbackSendPlayPauseToServer")]
		int PlaybackSendPlayPauseToServer { get; set; }

		// @property (nonatomic) int useNotchFilter;
		[Export("useNotchFilter")]
		int UseNotchFilter { get; set; }

		// @property (nonatomic) int enableInternalGestureRecognizers;
		[Export("enableInternalGestureRecognizers")]
		int EnableInternalGestureRecognizers { get; set; }

		// @property (nonatomic) int stateWillResignActive;
		[Export("stateWillResignActive")]
		int StateWillResignActive { get; set; }
	}



	// @interface MediaPlayer : NSObject
	[BaseType(typeof(NSObject))]
	interface MediaPlayer
	{
		// -(id)init:(CGRect)bounds;
		[Export("init:")]
		IntPtr Constructor(CGRect bounds);

		// -(UIView *)contentView;
		[Export("contentView")]
		//[Verify (MethodToProperty)]
		UIView ContentView { get; }

		// -(void)Open:(MediaPlayerConfig *)config callback:(id<MediaPlayerCallback>)callback;
		[Export("Open:callback:")]
		void Open(MediaPlayerConfig config, MediaPlayerCallback callback);

		// -(void)Close;
		[Export("Close")]
		void Close();

		// -(MediaPlayerConfig *)getConfig;
		[Export("getConfig")]
		//[Verify (MethodToProperty)]
		MediaPlayerConfig Config { get; }

		// -(MediaPlayerState)getState;
		[Export("getState")]
		//[Verify (MethodToProperty)]
		MediaPlayerState State { get; }

		// -(int)getPropInt:(MediaPlayerProperties)prop;
		[Export("getPropInt:")]
		int GetPropInt(MediaPlayerProperties prop);

		// -(NSString *)getPropString:(MediaPlayerProperties)prop;
		[Export("getPropString:")]
		string GetPropString(MediaPlayerProperties prop);

		// -(int)updateView;
		[Export("updateView")]
		//[Verify (MethodToProperty)]
		int UpdateView { get; }

		// -(void)Play:(int)drawNumberOfFramesAndPause;
		[Export("Play:")]
		void Play(int drawNumberOfFramesAndPause);

		// -(void)Pause;
		[Export("Pause")]
		void Pause();

		// -(void)PauseWithFlush;
		[Export("PauseWithFlush")]
		void PauseWithFlush();

		// -(void)Stop;
		[Export("Stop")]
		void Stop();

		// -(void)setFFRate:(int)rate;
		[Export("setFFRate:")]
		void SetFFRate(int rate);

		// -(int)getVideoShot:(void *)buffer buffer_size:(int32_t *)buffer_size width:(int32_t *)width height:(int32_t *)height bytes_per_row:(int32_t *)bytes_per_row;
		[Export("getVideoShot:buffer_size:width:height:bytes_per_row:")]
		//unsafe int GetVideoShot (void* buffer, int* buffer_size, int* width, int* height, int* bytes_per_row);
		unsafe int GetVideoShot(IntPtr buffer, ref int buffer_size, ref int width, ref int height, ref int bytes_per_row);

		// -(void)setStreamPosition:(int64_t)lTime;
		[Export("setStreamPosition:")]
		void SetStreamPosition(long lTime);

		// -(int64_t)getStreamDuration;
		[Export("getStreamDuration")]
		//[Verify (MethodToProperty)]
		long StreamDuration { get; }

		// -(int64_t)getStreamPosition;
		[Export("getStreamPosition")]
		//[Verify (MethodToProperty)]
		long StreamPosition { get; }

		// -(int64_t)getRenderPosition;
		[Export("getRenderPosition")]
		//[Verify (MethodToProperty)]
		long RenderPosition { get; }

		// -(void)setLiveStreamPath:(NSString *)path;
		[Export("setLiveStreamPath:")]
		void SetLiveStreamPath(string path);

		// -(void)setStartLiveStreamPosition:(int64_t)offset;
		[Export("setStartLiveStreamPosition:")]
		void SetStartLiveStreamPosition(long offset);

		// -(void)setLiveStreamPosition:(int64_t)lTime;
		[Export("setLiveStreamPosition:")]
		void SetLiveStreamPosition(long lTime);

		// -(BOOL)getLiveStreamPosition:(int64_t *)first current:(int64_t *)current last:(int64_t *)last duration:(int64_t *)duration stream_type:(int *)stream_type;
		[Export("getLiveStreamPosition:current:last:duration:stream_type:")]
		//unsafe bool GetLiveStreamPosition(long* first, long* current, long* last, long* duration, int* stream_type);
		unsafe bool GetLiveStreamPosition(ref long first, ref long current, ref long last, ref long duration, ref int stream_type);

		// -(void)toggleMute:(BOOL)mute;
		[Export("toggleMute:")]
		void ToggleMute(bool mute);

		// -(void)setKey:(NSString *)key;
		[Export("setKey:")]
		void SetKey(string key);

		// -(int)getDataDelayOnSource;
		[Export("getDataDelayOnSource")]
		//[Verify (MethodToProperty)]
		int DataDelayOnSource { get; }

		// -(int)getDataBitrateOnSource;
		[Export("getDataBitrateOnSource")]
		//[Verify (MethodToProperty)]
		int DataBitrateOnSource { get; }

		// -(float)getStatFPS;
		[Export("getStatFPS")]
		//[Verify (MethodToProperty)]
		float StatFPS { get; }

		// -(NSString *)getStreamInfo;
		[Export("getStreamInfo")]
		//[Verify (MethodToProperty)]
		string StreamInfo { get; }

		// -(int)subtitleGetCount;
		[Export("subtitleGetCount")]
		//[Verify (MethodToProperty)]
		int SubtitleGetCount { get; }

		// -(int)subtitleSelect:(int)stream_i;
		[Export("subtitleSelect:")]
		int SubtitleSelect(int stream_i);

		// -(int)subtitleGetSelected;
		[Export("subtitleGetSelected")]
		//[Verify (MethodToProperty)]
		int SubtitleGetSelected { get; }

		// -(int)subtitleSourceAdd:(NSString *)path;
		[Export("subtitleSourceAdd:")]
		int SubtitleSourceAdd(string path);

		// -(int)subtitleSourceRemove:(NSString *)path;
		[Export("subtitleSourceRemove:")]
		int SubtitleSourceRemove(string path);

		// -(void)recordSetup:(NSString *)path flags:(MediaPlayerRecordFlags)flags splitTime:(int32_t)splitTime splitSize:(int32_t)splitSize prefix:(NSString *)prefix;
		[Export("recordSetup:flags:splitTime:splitSize:prefix:")]
		void RecordSetup(string path, MediaPlayerRecordFlags flags, int splitTime, int splitSize, string prefix);

		// -(void)recordStart;
		[Export("recordStart")]
		void RecordStart();

		// -(void)recordStop;
		[Export("recordStop")]
		void RecordStop();

		// -(NSString *)recordGetFileName:(int32_t)param;
		[Export("recordGetFileName:")]
		string RecordGetFileName(int param);

		// -(int64_t)recordGetStat:(MediaPlayerRecordStat)param;
		[Export("recordGetStat:")]
		long RecordGetStat(MediaPlayerRecordStat param);

		// -(Boolean)isHardwareDecoding;
		[Export("isHardwareDecoding")]
		//[Verify (MethodToProperty)]
		byte IsHardwareDecoding { get; }

		// -(int)getAvailableDirectionsForAspectRatioMoveMode;
		[Export("getAvailableDirectionsForAspectRatioMoveMode")]
		//[Verify (MethodToProperty)]
		int AvailableDirectionsForAspectRatioMoveMode { get; }

		// -(void)getViewSizesAndVideoAspects:(int *)view_orientation view_width:(int *)view_width view_height:(int *)view_height video_width:(int *)video_width video_height:(int *)video_height aspect_left:(int *)aspect_left aspect_top:(int *)aspect_top aspect_width:(int *)aspect_width aspect_height:(int *)aspect_height aspect_zoom:(int *)aspect_zoom;
		[Export("getViewSizesAndVideoAspects:view_width:view_height:video_width:video_height:aspect_left:aspect_top:aspect_width:aspect_height:aspect_zoom:")]
		//unsafe void GetViewSizesAndVideoAspects(int* view_orientation, int* view_width, int* view_height, int* video_width, int* video_height, int* aspect_left, int* aspect_top, int* aspect_width, int* aspect_height, int* aspect_zoom);
		unsafe void GetViewSizesAndVideoAspects(ref int view_orientation, ref int view_width, ref int view_height, ref int video_width, ref int video_height, ref int aspect_left, ref int aspect_top, 
		                                        ref int aspect_width, ref int aspect_height, ref int aspect_zoom);

		// -(void)getInternalBuffersState:(int *)source_videodecoder_filled source_videodecoder_size:(int *)source_videodecoder_size source_videodecoder_num_frms:(int *)source_videodecoder_num_frms videodecoder_videorenderer_filled:(int *)videodecoder_videorenderer_filled videodecoder_videorenderer_size:(int *)videodecoder_videorenderer_size videodecoder_videorenderer_num_frms:(int *)videodecoder_videorenderer_num_frms source_audiodecoder_filled:(int *)source_audiodecoder_filled source_audiodecoder_size:(int *)source_audiodecoder_size audiodecoder_audiorenderer_filled:(int *)audiodecoder_audiorenderer_filled audiodecoder_audiorenderer_size:(int *)audiodecoder_audiorenderer_size video_latency:(int *)video_latency audio_latency:(int *)audio_latency;
		[Export("getInternalBuffersState:source_videodecoder_size:source_videodecoder_num_frms:videodecoder_videorenderer_filled:videodecoder_videorenderer_size:videodecoder_videorenderer_num_frms:source_audiodecoder_filled:source_audiodecoder_size:audiodecoder_audiorenderer_filled:audiodecoder_audiorenderer_size:video_latency:audio_latency:")]
		//unsafe void GetInternalBuffersState(int* source_videodecoder_filled, int* source_videodecoder_size, int* source_videodecoder_num_frms, int* videodecoder_videorenderer_filled, int* videodecoder_videorenderer_size, int* videodecoder_videorenderer_num_frms, int* source_audiodecoder_filled, int* source_audiodecoder_size, int* audiodecoder_audiorenderer_filled, int* audiodecoder_audiorenderer_size, int* video_latency, int* audio_latency);
		unsafe void GetInternalBuffersState(ref int source_videodecoder_filled, ref int source_videodecoder_size, ref int source_videodecoder_num_frms, ref int videodecoder_videorenderer_filled, 
		                                    ref int videodecoder_videorenderer_size, ref int videodecoder_videorenderer_num_frms, ref int source_audiodecoder_filled, ref int source_audiodecoder_size, 
		                                    ref int audiodecoder_audiorenderer_filled, ref int audiodecoder_audiorenderer_size, ref int video_latency, ref int audio_latency);
	}

	// @protocol MediaPlayerCallback <NSObject>
	[Protocol, Model]
	[BaseType(typeof(NSObject))]
	interface MediaPlayerCallback
	{
		// @required -(int)Status:(MediaPlayer *)player args:(int)arg;
		[Abstract]
		[Export("Status:args:")]
		int Status(MediaPlayer player, int arg);

		// @required -(int)OnReceiveData:(MediaPlayer *)player buffer:(void *)buffer size:(int)size pts:(long)pts;
		[Abstract]
		[Export("OnReceiveData:buffer:size:pts:")]
		//unsafe int OnReceiveData (MediaPlayer player, void* buffer, int size, nint pts);
		unsafe int OnReceiveData(MediaPlayer player, IntPtr buffer, int size, nint pts);

		// @optional -(int)OnReceiveSubtitleString:(MediaPlayer *)player data:(NSString *)data duration:(uint64_t)duration;
		[Export("OnReceiveSubtitleString:data:duration:")]
		int OnReceiveSubtitleString(MediaPlayer player, string data, ulong duration);

		// @optional -(int)OnVideoSourceFrameAvailable:(MediaPlayer *)player buffer:(void *)buffer size:(int)size pts:(long)pts dts:(long)dts stream_index:(int)stream_index format:(int)format;
		[Export("OnVideoSourceFrameAvailable:buffer:size:pts:dts:stream_index:format:")]
		//unsafe int OnVideoSourceFrameAvailable (MediaPlayer player, void* buffer, int size, nint pts, nint dts, int stream_index, int format);
		unsafe int OnVideoSourceFrameAvailable(MediaPlayer player, IntPtr buffer, int size, nint pts, nint dts, int stream_index, int format);

		// @optional -(int)OnAudioSourceFrameAvailable:(MediaPlayer *)player buffer:(void *)buffer size:(int)size pts:(long)pts dts:(long)dts stream_index:(int)stream_index format:(int)format;
		[Export("OnAudioSourceFrameAvailable:buffer:size:pts:dts:stream_index:format:")]
		//unsafe int OnAudioSourceFrameAvailable (MediaPlayer player, void* buffer, int size, nint pts, nint dts, int stream_index, int format);
		unsafe int OnAudioSourceFrameAvailable(MediaPlayer player, IntPtr buffer, int size, nint pts, nint dts, int stream_index, int format);

		// @optional -(int)OnVideoRendererFrameAvailable:(MediaPlayer *)player buffer:(void *)buffer size:(int)size format_fourcc:(char *)format_fourcc width:(int)width height:(int)height bytes_per_row:(int)bytes_per_row pts:(long)pts will_show:(int)will_show;
		[Export("OnVideoRendererFrameAvailable:buffer:size:format_fourcc:width:height:bytes_per_row:pts:will_show:")]
		//unsafe int OnVideoRendererFrameAvailable (MediaPlayer player, void* buffer, int size, sbyte* format_fourcc, int width, int height, int bytes_per_row, nint pts, int will_show);
		unsafe int OnVideoRendererFrameAvailable(MediaPlayer player, IntPtr buffer, int size, ref sbyte format_fourcc, int width, int height, int bytes_per_row, nint pts, int will_show);
	}


	// @interface ThumbnailerConfig : NSObject
	[BaseType(typeof(NSObject))]
	interface ThumbnailerConfig
	{
		// @property (nonatomic) NSString * connectionUrl;
		[Export("connectionUrl")]
		string ConnectionUrl { get; set; }

		// @property (nonatomic) int connectionNetworkProtocol;
		[Export("connectionNetworkProtocol")]
		int ConnectionNetworkProtocol { get; set; }

		// @property (nonatomic) int dataReceiveTimeout;
		[Export("dataReceiveTimeout")]
		int DataReceiveTimeout { get; set; }

		// @property (nonatomic) int numberOfCPUCores;
		[Export("numberOfCPUCores")]
		int NumberOfCPUCores { get; set; }

		// @property (nonatomic) float bogoMIPS;
		[Export("bogoMIPS")]
		float BogoMIPS { get; set; }

		// @property (nonatomic) int outWidth;
		[Export("outWidth")]
		int OutWidth { get; set; }

		// @property (nonatomic) int outHeight;
		[Export("outHeight")]
		int OutHeight { get; set; }
	}

	// @interface Thumbnailer : NSObject
	[BaseType(typeof(NSObject))]
	interface Thumbnailer
	{
		// -(NSCondition *)Open:(ThumbnailerConfig *)config;
		[Export("Open:")]
		NSCondition Open(ThumbnailerConfig config);

		// -(void)Close;
		[Export("Close")]
		void Close();

		// -(ThumbnailerConfig *)getConfig;
		[Export("getConfig")]
		//[Verify (MethodToProperty)]
		ThumbnailerConfig Config { get; }

		// -(ThumbnailerState)getState;
		[Export("getState")]
		//[Verify (MethodToProperty)]
		ThumbnailerState State { get; }

		// -(NSString *)getInfo;
		[Export("getInfo")]
		//[Verify (MethodToProperty)]
		string Info { get; }

		// -(int)getFrame:(void *)buffer buffer_size:(int32_t)buffer_size width:(int32_t *)width height:(int32_t *)height bytes_per_row:(int32_t *)bytes_per_row;
		[Export("getFrame:buffer_size:width:height:bytes_per_row:")]
		//unsafe int GetFrame (void* buffer, int buffer_size, int* width, int* height, int* bytes_per_row);
		unsafe int GetFrame(IntPtr buffer, int buffer_size, ref int width, ref int height, ref int bytes_per_row);
	}
}