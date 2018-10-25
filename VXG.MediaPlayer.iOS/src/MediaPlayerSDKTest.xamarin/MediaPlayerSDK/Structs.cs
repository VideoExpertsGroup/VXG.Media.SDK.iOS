namespace MediaPlayerSDK
{
	public enum MediaPlayerContentProviderLibraryType
	{
		Media = 0,
		Rtsp = 1,
		Webrtc = 2
	}

	public enum MediaPlayerNotifyCodes
	{
		PlpTrialVersion = -999,
		PlpBuildStarting = 1,
		PlpBuildSuccessful = 2,
		PlpBuildFailed = 3,
		PlpPlayStarting = 4,
		PlpPlaySuccessful = 5,
		PlpPlayFailed = 6,
		PlpCloseStarting = 7,
		PlpCloseSuccessful = 8,
		PlpCloseFailed = 9,
		PlpError = 10,
		PlpEos = 12,
		PlpPlayPlay = 14,
		PlpPlayPause = 15,
		PlpPlayStop = 16,
		PlpSeekCompleted = 17,
		CpConnectStarting = 101,
		CpConnectSuccessful = 102,
		CpConnectFailed = 103,
		CpInterrupted = 104,
		CpErrorDisconnected = 105,
		CpStopped = 106,
		CpInitFailed = 107,
		CpRecordStarted = 108,
		CpRecordStopped = 109,
		CpRecordClosed = 110,
		CpBufferFilled = 111,
		CpErrorNodataTimeout = 112,
		CpSourceAudioDiscontinuity = 113,
		CpSourceVideoDiscontinuity = 114,
		CpStartBuffering = 115,
		CpStopBuffering = 116,
		CpDisconnectSuccessful = 117,
		CpCookieIsChanged = 118,
		VdpStopped = 201,
		VdpInitFailed = 202,
		VdpCrash = 206,
		VrpStopped = 300,
		VrpInitFailed = 301,
		VrpNeedSurface = 302,
		VrpFirstframe = 305,
		VrpLastframe = 306,
		VrpFframeApause = 308,
		VrpSurfaceAcquire = 309,
		VrpSurfaceLost = 310,
		VrpSyncpoint = 311,
		AdpStopped = 400,
		AdpInitFailed = 401,
		ArpStopped = 500,
		ArpInitFailed = 501,
		ArpLastframe = 502,
		ArpVolumeDetected = 503,
		CrpStopped = 600,
		SdpStopped = 701,
		SdpInitFailed = 702,
		SdpLastframe = 703
	}

	public enum MediaPlayerState
	{
		Opening = 0,
		Opened = 1,
		Started = 2,
		Paused = 3,
		Stopped = 4,
		Closing = 5,
		Closed = 6
	}

	public enum MediaPlayerModes
	{
		All = -1,
		Video = 1,
		Audio = 2,
		Subtitle = 4,
		Record = 8
	}

	public enum MediaPlayerRecordFlags
	{
		NoStart = 0,
		AutoStart = 1,
		SplitByTime = 2,
		SplitBySize = 4,
		DisableVideo = 8,
		DisableAudio = 16,
		PtsCorrection = 32,
		FastStart = 64,
		FragKeyframe = 128,
		SystemTimeToPts = 256,
		DefinedDuration = 512
	}

	public enum MediaPlayerRecordStat
	{
		Lasterror = 0,
		Duration = 1,
		Size = 2,
		DurationTotal = 3,
		SizeTotal = 4
	}

	public enum MediaPlayerProperties
	{
		RenderedVideoFrames = 0,
		AudioVolumeMean = 1,
		AudioVolumeMax = 2,
		PlpLastError = 3,
		PlpResponseText = 4,
		PlpResponseCode = 5,
		PlpCookie = 6,
		PlpPtsInFirstRtp = 7,
		PlpPtsInRange = 8,
		PlpRtcpPackage = 9,
		PlpRtcpSr = 10,
		PlpRtcpRr = 11,
		BackwardAudioFormat = 12,
		AudioNotchFilter = 101
	}

	public enum MediaPlayerLatencyPreset
	{
		NoPreset = -2,
		CustomPreset = -1,
		Highest = 0,
		High = 1,
		Middle = 2,
		Lowest = 3
	}

	public enum MediaPlayerLogLevel
	{
		Compiled = -1,
		None = 0,
		Error = 1,
		Info = 3,
		Debug = 4,
		Log = 5,
		Trace = 7
	}

	public enum MediaPlayerGraphicLayer
	{
		Opengl = 0,
		Metal = 1
	}

	public enum ThumbnailerState : uint
	{
		Opening = 0,
		Opened = 1,
		Closing = 2,
		Closed = 3
	}
}
