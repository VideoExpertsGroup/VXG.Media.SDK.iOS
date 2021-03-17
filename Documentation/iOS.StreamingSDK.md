# Overview

VXG Mobile SDK structure:

    |-- VXGMobileSDK.iOS
        |-- MediaSDK
            |-- PlayerSDK
            |-- EncoderSDK
        |-- CloudSDK
            

**Cloud SDK** is a part of **VXG Mobile SDK** responsible for streaming and playback with *VXG Video Server* or *VXG Cloud Video*.

*VXG Video Server* is a software NVR, streaming server and a lightweight VMS that you can run on the edge, on 
premises or on a cloud instance.   

*VXG Cloud Video* is auto scaling verion of the VXG Server running on the cloud.


## Class CloudPlayerSDK
Cloud-Server Player is a tool for live and recorded video playback. 

IMPORTANT: Access token from the Dashboard should be used here

#### Key features

* Playback of live streams
* Playback of recorded videos
* Video controls: Play/Pause
* Control of position for recorded video
* Control of audio output: mute, unmute, volume control
* Control of timeline for recorded video (Show/Hide)

#### -(instancetype)initWithParams: (UIView*) view config: (CPlayerConfig*) config callback: (CPlayerCallback) callbacks

**Description**

Create new instance of player

**Parameters**

view - view control to present video.

config - player options. All options are described in CPlayerConfig

callback - callback function where all notifications will be received.

Add callback to get player's notifications.
There can be one or more CPlayerCallback in one application.

**Return values**

New player object is returned

**Example**

	ccplayer = [[CloudPlayerSDK alloc] initWithParams: videoView config: conf callback:^( CloudPlayerEvent status_code, id<ICloudObject> player) {
        switch (status_code) {
            case SOURCE_CHANGED: {               
            } break;
            case CONNECTING: {
            } break;
            case CONNECTED: {
            } break;
            case STARTED: {
            } break;
            case PAUSED: {
            } break;
            case CLOSED: {
            } break;
            case EOS: {
            } break;
            case SEEK_COMPLETED: {
            } break;
            case ERROR: {
            } break;
            case TRIAL_VERSION: {
            } break;
        }
    }];
 
#### -(instancetype)initWithParams:(UIView *)view config:(CPlayerConfig *)config protocol_callback: (id<ICloudCPlayerCallback>)callbacks;

**Description**

Create new instance of player (another way)

**Parameters**

view - view control to present video.

config - player options. All options are described in CPlayerConfig

callbacks - object implements ICloudCPlayerCallback-protocol with:

	-(void) Status: (CloudPlayerEvent) status_code object: (id) player

Add callback to get player's notifications.
There can be one or more CPlayerCallback in one application.

**Return values**

New player object is returned

**Example**

	@interface MyClass: NSObject <ICloudCPlayerCallback>
	@end
	@implementation MyClass
	...
	-(void) Status: (CloudPlayerEvent) status_code object: (id<ICloudObject>) player 
	{
	switch (status_code) {
            case SOURCE_CHANGED: {               
            } break;
            case CONNECTING: {
            } break;
            case CONNECTED: {
            } break;
            case STARTED: {
            } break;
            case PAUSED: {
            } break;
            case CLOSED: {
            } break;
            case EOS: {
            } break;
            case SEEK_COMPLETED: {
            } break;
            case ERROR: {
            } break;
            case TRIAL_VERSION: {
            } break;
        }
	}
	@end
	....
	//In your class implementation
	MyClass myclass_callback = [[MyClass alloc] init];
	CloudPlayerSDK* ccplayer = [[CloudPlayerSDK alloc] initWithParams:preview_view config:config protocol_callback: myclass_callback];
	....
 
#### -(int) setSource: (NSString*) access_token


**Description**

Set access token to view channel.
Access_token is defined in the Dashboard after channel is created.

**Parameters**

access_token - access token for channel playback.

**Return values**

No return value

**Example**

	ccplayer = [[CloudPlayerSDK alloc] initWithParams: videoView config: conf callback:^( CloudPlayerEvent status_code, id<ICloudObject> player) {
        switch (status_code) {
            case SOURCE_CHANGED: { 
            	[ccplayer start];
            } break;
        }
    }];
	NSString* access_token = @"eyJ0b2tlbiI6InNoYXJlLmV5SnphU0k2SURFNE0zMC41YTQwYzQ2NXQxMmNmZjc4MC5rNlIxWHdjX2ptUjRZSFU5QV9xSVFHc2liX2MiLCJjYW1pZCI6MTMxMDY0LCJhY2Nlc3MiOiJ3YXRjaCJ9";
	[ccplayer setSource: access_token];
 
#### -(int) setConfig: (CPlayerConfig*) config


**Description**

Set various settings for player in player config. All settings are described in CPlayerConfig

**Parameters**

No input parameters

**Return values**

Upon successful completion, setConfig returns 0, otherwise negative value is returned. All errors are described in section Errors.

**Example**

	CPlayerConfig* config = [[CPlayerConfig alloc]init];
		[config aspectRation: 0];
		[ccplayer setConfig: config];
  
 
#### -(void) play

**Description**

Resume play if player is in Pause state.

**Parameters**

No input parameters

**Return values**

No return values

**Example**

	[ccplay play];
 
#### -(void) pause

**Description**

Change playback state from Play to Pause.

**Parameters**

No input parameters

**Return values**

No **Return values**

**Example**

	[ccplayer pause];
 
#### -(void) close

**Description**

Close player object and free all resources.

**Parameters**

No input parameters

**Return values**

No return value

**Example**

	[ccplayer close];
 
#### -(CPlayerStates) getState

**Description**

Return player state. Player's states are described in CPlayerStates.

**Parameters**

No input parameters

**Return values**

getState returns CPlayerStates.

**Example**

	enum ClayerState mState = [ccplayer getState];
	if (mState == CPlayerStateConnected)
		// Player connected to source successfully. 
 
#### -(void) setPosition:(long long) nPosition

**Description**

Set position for recorded playback.

**Parameters**

nPosition - position in video storage. Position is set in Unix time, UTC, milliseconds.

**Return values**

No return value

**Example**

	// Playback video Tue, 17 Oct 2017 00:00:00 GMT
	[ccplayer setPosition: 1508198400000];
 
#### -(long long) getPosition

**Description**

[Not implemented] Get current position. This function returns value for both modes: live video streaming and recorded video playback.

**Parameters**

No input parameters

**Return values**

Upon successful completion, getPosition() returns position, otherwise negative value is returned. All errors are described in section Errors.
Position is returned in Unix time format, UTC time, milliseconds.

**Example**

	long long current_position = [ccplayer getPosition];
 
#### -(Boolean) isLive

**Description**

Tells if live or recorded video is played at the moment.

**Parameters**

No input parameters

**Return values**

isLive returns true if live video is played, otherwise false value is returned.

**Example**

	BOOL b_cam_live = [ccplayer isLive];
	if (YES == b_cam_live)
		// Live streaming is played at the moment
 
#### -(void) mute:(Boolean) bMmute

**Description**

Set mute / unmute on audio render.

**Parameters**

bMute - Mute sound if value is true, and unmute sound if value is false.

**Return values**

No return value

**Example**

	// Mute sound on audio outptut
	BOOL b_mute = YES;
	[ccplayer mute: b_mute];
	// Unmute sound on audio outptut
	BOOL b_mute = NO;
	[ccplayer mute: b_mute];
 
#### -(Boolean) isMute

**Description**

Return current status of audio output.

**Parameters**

No input parameters

**Return values**

isMute returns true if audio output is muted, otherwise false if audio output is unmuted.

**Example**

	BOOL b_mute_audio = [ccplayer isMute];
	if (YES == b_mute_audio)
		// Audio is muted in player
 
#### -(void) setVolume:(int) vol


**Description**

[Not implemented] Set volume for audio output of defined player.

**Parameters**

val - volume level. 0 is min level; 100 - max level.

**Return values**

No return value

**Example**

	// Set middle audio level for audio output
	[ccplayer setVolume:50];
 
#### -(int) getVolume

**Description**

[Not implemented] Return audio level.

**Parameters**

No input parameters

**Return values**

getVolume returns audio level. Level is changed from min level 0 to max level 100.

**Example**

	// Get  audio level for audio output
	int current_volume = [ccplayer getVolume];
 
#### -(void) showTimeline:(UIView*) vwTimeline

**Description**

[Not implemented] Show timeline in defined view.
Timeline shows all recorded segments or dates when there is recorded data.

**Parameters**

vwTimeline - view that is used to show timeline control. This control can be customized or reused in application.

**Return values**

No return value

**Example**

	[ccplayer showTimeline: view_for_timeline];
 
#### -(void) hideTimeline


**Description**

[Not implemented] Hide timeline. Timeline shows all recorded segments or dates when there is recorded data.

**Parameters**

No input parameters

**Return values**

No return values

**Example**

	[ccplayer hiTimeline];
 
#### -(long long) getID

**Description**

Return source ID. The ID is assigned to every camera that is created on VXG server.

**Parameters**

No input parameters

**Return values**

Upon successful completion, getID returns camera ID, otherwise negative value (-1) is returned

**Example**

	long long cameraID = [ccplayer getId];
 
#### -(NSString*) getPreviewURLSync

**Description**

Get URL to download preview image. This function is called synchronously.

**Parameters**

No input parameters

**Return values**

Upon successful completion, getPreviewURLSync returns URL, otherwise null is returned.

**Example**

	NSString* previewUrl = [ccplayer getPreviewURLSync];
 
#### -(void) getPreviewURL:(void (^)(NSObject* obj, int status)) complete

**Description**

Get URL. URL can be used to download camera preview in jpg format. This function is called asynchronously.

**Parameters**

Сomplete - it is called if correct URL is received from the server or in the case of error..

**Return values**

Upon successful completion, getPreviewURL returns 0, otherwise negative value is returned. All errors are described in section Errors.

**Example**

	[ccplayer getPreviewURL:^(NSObject *obj, int status) {
        if (status == CloudReturnCodeOk) {
            //get URL
            NSString* imageURL = (NSString*) obj;
            //download imagedata by URL
            NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: imageURL]];                            
            //create image by downloaded data
            UIImage *dwimage = [UIImage imageWithData:imageData];
        } else {
            [self showError: [NSString stringWithFormat: @"Error: %@", [ccplayer GetResultStr]] ];
        }
    }];
 
#### -(long long) getTimeLive

**Description**

Get the time when camera will be deleted on server. Until this time camera will be available.
It is useful when the video from camera will be viewed only once and you don't want to keep it on server after the player is closed.

**Parameters**

No input parameters

**Return values**

Upon successful completion, getTimeLive returns time, otherwise 0 value is returned.
Important note: time is set in UTC. Time format is Unix time in milliseconds.

**Example**

	long long time_end = [ccplayer getTimeLive];
 
#### -(void) setTimeLive:(long long) utc_time;

**Description**

Set time when camera will be deleted on server. Until this time camera will be available.
It is useful when the video from camera will be viewed only once and you don't want to keep it on server after the player is closed.

Use save or saveSync to save the value to VXG server.

**Parameters**

utc_time - time when camera object is deleted on server.
Important note: time is set in UTC. Time format is Unix time in milliseconds.

**Return values**

No return value

**Example**

	//set time streaming for the next 10 minutes
	NSDate * stt = [NSDate dateWithTimeIntervalSinceNow: 10*60];
	[ccplayer setTimeLive: [stt timeIntervalSince1970]*1000 ];
	[ccplayer saveSync];
 
#### -(NSString*) getTimezone

**Description**

Get a time zone. Time zone is used further to set timeline, calendar, live time and other parameters.

**Parameters**

No input parameters

**Return values**

Upon successful completion, getTimeZone returns time zone, otherwise null value is returned.
time_zone - time zone of the camera. 
Complete list of supported time zones: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

**Example**

	NSString* timezone = [ccplayer getTimezone];
 
#### -(void) setTimezone:(NSString*) tz;

**Description**

Set a time zone. Time zone is used further to set timeline, calendar, live time and other parameters.
Use save or saveSync to save the value to VXG server.

**Parameters**

time_zone - time zone of the camera. Complete list of supported time zones: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

**Return values**

No return value

**Example**

	[ccplayer setTimezone: @"UTC"];
 
#### -(NSString*) getName

**Description**

Get a camera name.
Use refresh or refreshSync to update the name from VXG server.

**Parameters**

No input parameters

**Return values**

Upon successful completion, getName returns camera name, otherwise null value is returned if camera name is not set.

**Example**

	NSString* name = [ccplayer getName];
 
#### -(void) setName: (NSString*) name

**Description**

Set a camera name.
Use save or saveSync to save the value to VXG server.

**Parameters**

name - camera name.

**Return values**

No return value

**Example**

	[ccplayer setName:@"NewCameraName"];
	[ccplayer saveSync];
 
#### -(CCStatus) getStatus

**Description**

Return camera status.
Use refresh() or refreshSync() to update the value from VXG server.

There are following camera statuses:

CCStatusActive = 0,

CCStatusUnauthorized = 1,

CCStatusInactive = 2,

CCStatusInactiveByScheduler = 3,

CCStatusOffline = 4

**Parameters**

No input parameters

**Return values**

Upon successful completion, getStatus() returns CloudCameraStatus object, otherwise null value is returned.

**Example**

	[ccplayer refreshSync]; //sync with cloud
	CCStatus status = [ccplayer getStatus];
	if (status == CCStatusActive)
 
#### -(CCRecordingMode) getRecordingMode

**Description**

Get recording state of camera. There is limitation for media storage on server if trial key is used - recorded data is stored for 72 hours after the moment of recording.
Use refresh or refreshSync to update the value from VXG server.

**Parameters**

No input parameters

**Return values**

CCRecordingMode - recording state

There are following recording states:

CCRecordingModeContinues = 0 - Continuous recording. Media data is recorded uninterruptedly in 24/7 mode.

CCRecordingModeByEvent = 1, - Record media data by event. Current option is supported by push camera only.

CCRecordingModeNoRecording = 2 - No recording or it can be used to stop recording.

**Example**

	[ccplayer refreshSync];
	CCRecordingMode mRecMode = [cplayer getRecordingMode];
	if (mRecMode == CCRecordingModeContinues)
		// Recording is ON
	else if (mRecMode == CCRecordingModeNoRecording)
		// Recording is OFF
 
#### -(void) setRecordingMode:(CCRecordingMode) rec_mode

**Description**

Control recording on the camera. There is limitation for media storage on server if trial key is used - recorded data is stored for 72 hours after the moment of recording.
Use save or saveSync to save the value to VXG server.

**Parameters**

rec_mode - recording option.

There are following recording options:

CCRecordingModeContinues = 0 - Continuous recording. Media data is recorded uninterruptedly in 24/7 mode.

CCRecordingModeByEvent = 1, - Record media data by event. Current option is supported by push camera only.

CCRecordingModeNoRecording = 2 - No recording or it can be used to stop recording.

**Return values**

No return value

**Example**

	//enable non-stop recording
	[ccplayer setRecordingMode: CCRecordingModeContinues];
	[ccplayer saveSync];

	//disable recording
	[ccplayer setRecordingMode: CCRecordModeNoRecording];
	[ccplayer saveSync];
 
#### boolean isRecording()

**Description**

Get the current recording state of the camera.
Use refresh or refreshSync to update the value from VXG server.

**Parameters**

No input parameters

**Return values**

isRecording returns true if recording is running, returns false if recording does not work for some reason.

**Example**

	BOOL recording = [ccplayer isRecording];
		if (YES == recording )
			// Camera recording works right now
 
#### -(CTimeline*) getTimelineSync: (long long)start end: (long long)end

**Description**

Get information about recorded data on server in defined range. Range is set in start and end values. This function is called synchronously.
Records are provided in following structure.

	@interface CTimeline: NSObject
	@property long long start;
	@property long long end;
	@property NSArray<CTimelinePair> periods;
	@end
where

start - start time of range where there are actual records

end - end time of range where there are actual records

periods - start and end time of every record.

All times are defined in Unix time (milliseconds).

	@interface CTimelinePair: NSObject
	@property long long start;
	@property long long end;
	@end
where

start - start time of range of actual record period

end - end time of range of actual record period

All times are defined in Unix time (milliseconds)..

**Example**

	//set limits for the lattest 12 hours
	NSDate * stt = [NSDate dateWithTimeIntervalSinceNow: -12*60*60];
	NSDate * end = [NSDate dateWithTimeIntervalSinceNow: 0];
        
	CTimeline *ct = [cpsdk getTimelineSync: [stt timeIntervalSince1970]*1000 end: [end timeIntervalSince1970]*1000 ]; 
	//print to Log timeline request limits
	NSLog(@"Period [%@, %@] segments count %lu \n", 
		[CloudHelpers formatTime: [ct start]], 
		[CloudHelpers formatTime:[ct end]], 
		[[ ct periods ] count]
	);

	//print to Log whole timeline's periods inside limits
	for(int i=0; i < [[ct periods] count]; i++) {
		CTimelinePair* pair = [[ct periods] objectAtIndex: i];
		NSLog(@"segment %d: %@ %@ \n", i , 
			[CloudHelpers formatTime: [pair start]], 
			[CloudHelpers formatTime:[pair end]]
		);
	}
 
#### -(int) getTimeline: (long long)start end: (long long)end onComplete: (void (^)(NSObject *, int))complete


**Description**

Get information about recorded data on server in defined range. Range is set in start and end values. This function is called synchronously.
Records are provided in following structure:

	@interface CTimeline: NSObject
	@property long long start;
	@property long long end;
	@property NSArray<CTimelinePair> periods;
	@end
where

start - start time of range where there are actual records

end - end time of range where there are actual records

periods - start and end time of every record.

All times are defined in Unix time (milliseconds).

	@interface CTimelinePair: NSObject
	@property long long start;
	@property long long end;
	@end
where

start - start time of range of actual record period

end - end time of range of actual record period

All times are defined in Unix time (milliseconds).

**Parameters**

start - start time of range. It is set in milliseconds Unix time.

end - end time of range. It is set in milliseconds Unix time.

complete - callback is called if correct response is received from server or in case error.

**Example**

        //set limits for the lattest 12 hours
        NSDate * stt = [NSDate dateWithTimeIntervalSinceNow: -12*60*60];
        NSDate * end = [NSDate dateWithTimeIntervalSinceNow: 0];
        
        [cpsdk getTimeline: [stt timeIntervalSince1970]*1000 end: [end timeIntervalSince1970]*1000 onComplete:^(NSObject *obj, int status) {
            if (status == 0) {
                CTimeline* ct = (CTimeline*) obj;
                //print to Log timeline request limits
                NSLog(@"Period [%@, %@] segments count %lu \n", 
                	[CloudHelpers formatTime: [ct start]], 
                    [CloudHelpers formatTime:[ct end]], 
                    [[ ct periods ] count]
                );
                //print to Log whole timeline's periods inside limits
                for(int i=0; i < [[ct periods] count]; i++) {
                    CTimelinePair* pair = [[ct periods] objectAtIndex: i];
                    NSLog(@"segment %d: %@ %@ \n", i , 
                    	[CloudHelpers formatTime: [pair start]], 
                        [CloudHelpers formatTime:[pair end]]
                     );
                }
            }
        }];
 
#### -(double) getLat


**Description**

Get latitude of location.
Use refresh or refreshSync to update the value from VXG server.

**Parameters**

No parameters

**Return values**

double latitude value.

**Example**

	double latitude = [ccplayer getLat];
 
#### -(double) getLng

**Description**

Get longitude of location.
Use refresh() or refreshSync() to update the value from VXG server.

**Parameters**

No parameters

**Return values**

double longitude value.

**Example**

	double longitude = [ccplayer getLng];
 
#### -(void) setLngLtdBounds:(double) latitude: (double)longitude

**Description**

Set location coordinates of mobile camera.
Use save or saveSync to save the value to VXG server.

**Parameters**

latitude, longitude

**Return values**

No return value.

**Example**

	[ccplayer setLngLtdBounds: 56.01 latitude : 89.90 ];
	[ccplayer saveSync];
 
#### - (Boolean) HasError

**Description**

Check if error occurs.

**Parameters**

No parameters

**Return values**

true - error occurs;
false - no error.

**Example**

	BOOL is_error = [ccplayer hasError];
	if(is_error){
		NSLog(@"last error code %d , **Description** %@", [ccplayer GetResultInt], [ccplayer GetResultStr]);
	}
 
#### - (int) GetResultInt

**Description**

Get Integer code of the latest result.

**Parameters**

No parameters

**Return values**

Returns CloudReturnCodes value.

**Example**

	BOOL is_error = [ccplayer hasError];
	if(is_error){
		NSLog(@"last error code %d , **Description** %@", [ccplayer GetResultInt], [ccplayer GetResultStr]);
	}
 
#### - (NSString*) GetResultStr

**Description**

Get String value of the latest result.

**Parameters**

No parameters

**Return values**

Returns String value of CloudReturnCodes.

**Example**

	BOOL is_error = [ccplayer hasError];
	if(is_error){
	NSLog(@"last error code %d , **Description** %@", [ccplayer GetResultInt], [ccplayer GetResultStr]);
	}
 
#### -(int) refreshSync

**Description**

Update/refresh camera properties. This function is called synchronously.

**Parameters**

No parameters

**Return values**

Returns CloudReturnCodes value.

**Example**

	enum CloudReturnCodes rc = [ccplayer refrashSync];
	if (rc == CloudReturnCodeOK)
	//successful refresh
 
-(int) refresh: (void (^)(NSObject* obj, int status)) complete

**Description**

Update/refresh camera properties. This function is called asynchronously.

**Parameters**

No parameters

**Return values**

Returns CloudReturnCodes value.

**Example**

	[ ccplayer refresh: ^(NSObject* obj, int status){
		if (status == CloudReturnCodeOK){
		//refresh succesfull
		}
	}];
 
#### -(int) saveSync

**Description**

Save camera properties. This function is called synchronously.

**Parameters**

No parameters

**Return values**

Returns CloudReturnCodes value.

**Example**

	rc = [ccplayer saveSync];
	if (rc == CloudReturnCodeOk) {
		//save success
	}
 
#### -(int) save: (void (^)(NSObject* obj, int status)) complete

**Description**

Save camera properties. This function is called asynchronously.

**Parameters**

complete - callback called in case of success or errors happened due save

**Return values**

Returns CloudReturnCodes value.

**Example**

	[ ccplayer save: ^(NSObject* obj, int status){
		if (status == CloudReturnCodeOK){
    	//save succesfull
		}
	}];

## Class CloudStreamerSDK
Cloud-Server Streamer is a tool for live video streaming. 

IMPORTANT: Access token from DashBoard should be used here to stream video 
Please create channel and set access token in SetSource. 

#### Key features

* Live video streaming from mobile camera
* Preview image setting for defined channel   
* Various options: video resolution, video bitrate and others


#### -(instancetype)initWithParams: (CStreamerCallback) callbacks


**Description**

Construct streamer object.

**Parameters**

callback - callback is used to notify application on various events : errors, started , stopped, connected and so on.

**Return values**

Return new CloudStreamerSDK object

**Example**

	CloudStreamerSDK *ccstreamer = [[CloudStreamerSDK alloc] initWithParams: ^(CloudStreamerEvent status_code, NSString* info){
	switch (status_code) {
    	case STARTED: {
        	//get info as URL for stream
        } break;
    	case STOPED: {
        } break;
    	case ERROR: {
        	//get info as **Description** of the latest error
        } break;
    	case CAMERACONNECTED: {
        } break;
    }
	}];

#### -(instancetype)initWithParams: (id<ICloudStreamerCallback>) callbacks;

**Description**

Construct streamer object (another way)

**Parameters**

callbacks - object implements ICloudStreamerCallback-protocol with:

	-(void) onStarted: (NSString*) url;
	-(void) onStopped;
	-(void) onError:(int) err;
	-(void) onCameraConnected;

**Return values**

Return new CloudStreamerSDK object

**Example**

	@interface MyClass: NSObject <ICloudStreamerCallback>
	@end
	@implementation MyClass
	...
	-(void) onStarted: (NSString*) url {
	}
	-(void) onStopped {
	}
	-(void) onError:(int) err {
	}
	-(void) onCameraConnected {
	}
	@end
	....
	//In your class implementation
		MyClass myclass_callback = [[MyClass alloc] init];
		CloudStreamerSDK* ccstreamer = [[CloudStreamerSDK alloc] initWithParams: myclass_callback];
	....

#### -(int) setSource: (NSString*) access_token

**Description**

Set access token of channel for streaming.
New channel is created in DashBoard or using AdminAPI.
Access token for streamer is defined after channel creating.

**Parameters**

access_token - access token to broadcast channel.

**Return values**

No return value

**Example**

	CloudStreamerSDK *ccstreamer = [[CloudStreamerSDK alloc] initWithParams: ^(CloudStreamerEvent status_code, NSString* info){
	switch (status_code) {
    	case STARTED: {
        	//get info as URL for stream
        } break;
    	case STOPED: {
        } break;
    	case ERROR: {
        	//get info as **Description** of the latest error
        } break;
    	case CAMERACONNECTED: {
        	[ccstreamer Start];
        } break;
    }
	}];
	NSString* access_token = @"eyJ0b2tlbiI6InNoYXJlLmV5SnphU0k2SURFXQxMmNmZjc4MC5rNlIxWHdjX2ptUjRZSFU5QV9xSVFHc2liX2MiLCJjYW1pZCI6MTMxMDY0LCJhY2Nlc3MiOiJ3YXRjaCJ9";
	[ccstreamer setSource: access_token]; //as soon as possible, CAMMERACONNECTED callback is fired up,to start streamer

#### -(int) setConfig: (NSString*) config

**Description**

[Not implemented] restore saved CloudCamera session


#### -(void) Start

**Description**

Start channel object on backend.
Backend sends onStarted as soon as client is connected or record is enabled.
Backend sends onStopped as soon as latest client is disconnected and recording is disabled or in case if application call stop().

**Parameters**

There is no input parameters.

**Return values**

No return value

**Example**

	[ccstreamer Start];

#### -(void) Stop

**Description**

Stop channel object on backend.
Backend sends onStopped as soon as channel is stopped.

**Parameters**

There is no input parameters.

**Return values**

No return value

**Example**

	[ccstreamer Stop];

#### -(long long) getID

**Description**

Return source ID. The ID is assigned to every camera that is created on VXG server.

**Parameters**

No input **Parameters**

**Return values**

Upon successful completion, getID() returns camera ID, otherwise negative value (-1) is returned.

**Example**

	long long getID = [ccstreamer getID];

#### -(int) setPreviewImage: (UIImage*) preview;


**Description**

Application is able to add custom image on backend . This image is used for channel preview.
Function resize and uploads picture on server. Format of picture is JPG.

**Parameters**

preview - image-object to download.

**Return values**

No return value

**Example**

	//upload image as preview from project-resources
	[ccstreamer setPreviewImage: [UIImage imageNamed:"test_image.jpg"] ];

#### -(NSString*) getPreviewURLSync


**Description**

Get URL to download preview image. This function is called synchronously.

**Parameters**

No input parameters

**Return values**

Upon successful completion, getPreviewURLSync returns URL, otherwise null is returned.

**Example**

	NSString* previewUrl = [ccstreamer getPreviewURLSync];

#### -(void) getPreviewURL:(void (^)(NSObject* obj, int status)) complete


**Description**

Get URL. URL can be used to download camera preview in jpg format. This function is called asynchronously.

**Parameters**

Сomplete - it is called if correct URL is received from the server or in the case of error..

**Return values**

Upon successful completion, getPreviewURL returns 0, otherwise negative value is returned. All errors are described in section Errors.

**Example**

	[ccstreamer getPreviewURL:^(NSObject *obj, int status) {
                         if (status == CloudReturnCodeOk) {
                         	 //get URL
                             NSString* imageURL = (NSString*) obj;
                             //download imagedata by URL
                             NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: imageURL]];                            
                             //create image by downloaded data
                             UIImage *dwimage = [UIImage imageWithData:imageData];
                         } else {
                             [self showError: [NSString stringWithFormat: @"Error: %@", [ccstreamer GetResultStr]] ];
                         }
    }];

#### -(long long) getTimeLive


**Description**

Get the time when camera will be deleted on server. Until this time camera will be available.
It is useful when the video from camera will be viewed only once and you don't want to keep it on server after the player is closed.
Use refresh or refreshSync to update the value from VXG server.

**Parameters**

No input parameters

**Return values**

Upon successful completion, getTimeLive() returns time, otherwise 0 value is returned.
Important note: time is set in UTC. Time format is Unix time in milliseconds.

**Example**

	long long time_end = [ccstreamer getTimeLive];

#### -(void) setTimeLive:(long long) utc_time


**Description**

Set time when camera will be deleted on server. Until this time camera will be available.
It is useful when the video from camera will be viewed only once and you don't want to keep it on server after the player is closed.

Use save() or saveSync() to save the value to VXG server.

**Parameters**

time - time when camera object is deleted on server.
Important note: time is set in UTC. Time format is Unix time in milliseconds.

**Return values**

No return value

**Example**

	//set time streaming for the next 10 minutes
	NSDate * stt = [NSDate dateWithTimeIntervalSinceNow: 10*60];
	[ccstreamer setTimeLive: [stt timeIntervalSince1970]*1000 ];
	[ccstreamer saveSync];

#### -(void) setTimezone:(NSString*) tz


**Description**

Set a time zone. Time zone is used further to set timeline, calendar, live time and other parameters.
Use save or saveSync to save the value to VXG server.

**Parameters**

time_zone - time zone of the camera. Complete list of supported time zones: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

**Return values**

No return value

**Example**

	[ccstreamer setTimezone: @"UTC"];

#### -(NSString*) getTimezone


**Description**

Get a time zone. Time zone is used further to set timeline, calendar, live time and other parameters.
Use refresh or refreshSync to update the value from VXG server.

**Parameters**

No input parameters

**Return values**

Upon successful completion, getTimeZone returns time zone, otherwise null value is returned.
time_zone - time zone of the camera. Complete list of supported time zones: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

**Example**

	NSString* timezone = [ccstreamer getTimezone];

#### -(NSString*) getName


**Description**

Get a camera name.
Use refresh or refreshSync to update the value from VXG server.

**Parameters**

No input parameters

**Return values**

Upon successful completion, getName returns camera name, otherwise null value is returned if camera name is not set.

**Example**

	NSString* name = [ccstreamer getName];

#### -(void) setName: (NSString*) name


**Description**

Set a camera name.
Use save or saveSync to save the value to VXG server.

**Parameters**

name - camera name.

**Return values**

No return value

**Example**

	[ccstreamer setName:@"NewCameraName"];
	[ccstreamer saveSync];

#### -(CCStatus) getStatus


**Description**

Return camera status.
Use refresh or refreshSync to update the value from VXG server.

There are following camera statuses:

CCStatusActive = 0,

CCStatusUnauthorized = 1,

CCStatusInactive = 2,

CCStatusInactiveByScheduler = 3,

CCStatusOffline = 4

**Parameters**

No input parameters

**Return values**

Upon successful completion, getStatus() returns CloudCameraStatus object, otherwise null value is returned.

**Example**

	[ccstreamer refreshSync];
	enum CCStatus sts = [ccstreamer getStatus];
	if (sts == CCStatusActive)
	// camera is active

#### -(void) setRecordingMode:(CCRecordingMode) rec_mode


**Description**

Control recording on the camera. There is limitation for media storage on server if trial key is used - recorded data is stored for 72 hours after the moment of recording.
Use save or saveSync to save the value to VXG server.

**Parameters**

rec_mode - recording option.

There are following recording options:

CCRecordingModeContinues = 0 - Continuous recording. Media data is recorded uninterruptedly in 24/7 mode.

CCRecordingModeByEvent = 1, - Record media data by event. Current option is supported by push camera only.

CCRecordingModeNoRecording = 2 - No recording or it can be used to stop recording.

**Return values**

No return value

**Example**

	//enable non-stop recording
	[ccstreamer setRecordingMode: CCRecordingModeContinues];
	[ccstreamer saveSync];

	//disable recording
	[ccstreamer setRecordingMode: CCRecordModeNoRecording];
	[ccstreamer saveSync];

#### -(CCRecordingMode) getRecordingMode


**Description**

Get recording state of camera. There is limitation for media storage on server if trial key is used - recorded data is stored for 72 hours after the moment of recording.
Use refresh or refreshSync to update the value from VXG server.

**Parameters**

No input parameters

**Return values**

CCRecordingMode - recording state

There are following recording states:

CCRecordingModeContinues = 0 - Continuous recording. Media data is recorded uninterruptedly in 24/7 mode.

CCRecordingModeByEvent = 1, - Record media data by event. Current option is supported by push camera only.

CCRecordingModeNoRecording = 2 - No recording or it can be used to stop recording.

**Example**

	[ccstreamer refreshSync];
	enum CCRecordingMode rm = [ccstreamer getRecordingMode];

	//disable recording if enabled
	if (rm != CCRecordingModeNoRecording) {
		[ccstreamer setRecordingMode: CCRecordingModeNoRecording];
		[ccstreamer saveSync];
	}

#### -(CTimeline*) getTimelineSync: (long long)start end: (long long)end


**Description**

Get information about recorded data on server in defined range. Range is set in start and end values. This function is called synchronously.
Records are provided in following structure.

	@interface CTimeline: NSObject
	@property long long start;
	@property long long end;
	@property NSArray periods;
	@end
where

start - start time of range where there are actual records

end - end time of range where there are actual records

periods - start and end time of every record.

All times are defined in Unix time (milliseconds).

	@interface CTimelinePair : NSObject
	@property long long start;
	@property long long end;
	@end
where

start - start time of range of actual record period

end - end time of range of actual record period

All times are defined in Unix time (milliseconds)

**Return values**

Upon successful completion, getTimelineSync() returns object CloudTimeLine, otherwise null value is returned. Null means there are no records for defined period.

**Example**

	//set limits for the lattest 12 hours
	NSDate * stt = [NSDate dateWithTimeIntervalSinceNow: -12*60*60];
	NSDate * end = [NSDate dateWithTimeIntervalSinceNow: 0];
        
	CTimeline *ct = [ccstreamer getTimelineSync: [stt timeIntervalSince1970]*1000 end: [end timeIntervalSince1970]*1000 ]; 

	//print to Log timeline request limits
	NSLog(@"Period [%@, %@] segments count %lu \n", 
		[CloudHelpers formatTime: [ct start]], 
		[CloudHelpers formatTime:[ct end]], 
		[[ ct periods ] count]
	);

	//print to Log whole timeline's periods inside limits
	for(int i=0; i < [[ct periods] count]; i++) {
		CTimelinePair* pair = [[ct periods] objectAtIndex: i];
		NSLog(@"segment %d: %@ %@ \n", i , 
			[CloudHelpers formatTime: [pair start]], 
			[CloudHelpers formatTime:[pair end]]
		);
	}

#### -(int) getTimeline: (long long)start end: (long long)end onComplete: (void (^)(NSObject *, int))complete


**Description**

Get information about recorded data on server in defined range. Range is set in start and end values. This function is called synchronously.

Records are provided in following structure:

	@interface CTimeline : NSObject
	@property long long start;
	@property long long end;
	@property NSArray periods;
	@end
where

start - start time of range where there are actual records

end - end time of range where there are actual records

periods - start and end time of every record.

All times are defined in Unix time (milliseconds).

	@interface CTimelinePair : NSObject
	@property long long start;
	@property long long end;
	@end
where

start - start time of range of actual record period

end - end time of range of actual record period

All times are defined in Unix time (milliseconds)

**Return values**

Upon successful completion, getTimeline returns 0, otherwise negative value is returned. All errors are described in section Errors.

**Example**

        //set limits for the lattest 12 hours
        NSDate * stt = [NSDate dateWithTimeIntervalSinceNow: -12*60*60];
        NSDate * end = [NSDate dateWithTimeIntervalSinceNow: 0];
        
        [ccstreamer getTimeline: [stt timeIntervalSince1970]*1000 end: [end timeIntervalSince1970]*1000 onComplete:^(NSObject *obj, int status) {
            if (status == 0) {
                CTimeline* ct = (CTimeline*) obj;
                //print to Log timeline request limits
                NSLog(@"Period [%@, %@] segments count %lu \n", 
                	[CloudHelpers formatTime: [ct start]], 
                    [CloudHelpers formatTime:[ct end]], 
                    [[ ct periods ] count]
                );
                //print to Log whole timeline's periods inside limits
                for(int i=0; i < [[ct periods] count]; i++) {
                    CTimelinePair* pair = [[ct periods] objectAtIndex: i];
                    NSLog(@"segment %d: %@ %@ \n", i , 
                    	[CloudHelpers formatTime: [pair start]], 
                        [CloudHelpers formatTime:[pair end]]
                     );
                }
            }
        }];

#### -(void) setLngLtdBounds:(double) latitude : (double)longitude


**Description**

Set location coordinates of mobile camera.
Use save or saveSync to save the value to VXG server.

**Parameters**

latitude, longitude

**Return values**

No return value.

**Example**

	[ccstreamer setLngLtdBounds: 56.01 latitude : 89.90 ];
	[ccstreamer saveSync];

#### -(double) getLat


**Description**

Get location property: latitude.
Use refresh() or refreshSync() to update the value from VXG server.

**Parameters**

No parameters

**Return values**

double latitude value.

**Example**

	[ccstreamer refreshSync];
	long long latitude = [ccstreamer getLat];

#### -(double) getLng


**Description**

Get location property: longitude.
Use refresh() or refreshSync() to update the value from VXG server.

**Parameters**

No parameters

**Return values**

double longitude value.

**Example**

	[ccstreamer refreshSync];
	long long longitude = [ccstreamer getLon];

#### -(Boolean) getPublic;


**Description** 

Check camera is visible for another users

**Return values**

YES - camera is visible,
NO - camera is hidden

**Example**

	BOOL isPublic = [ccstreamer getPublic];
	if (!isPublic) {
		[ccstreamer setPublic: YES];
		[ccstreamer saveSync];
	}

#### -(void) setPublic: (Boolean) isPublic;


**Description** 

Set camera to visible for other user

**Parameters**

isPublic - value to enable/disable visibility

**Example**

	BOOL isPublic = [ccstreamer getPublic];
	if (!isPublic) {
		[ccstreamer setPublic: YES];
		[ccstreamer saveSync];
	}

#### -(Boolean) isOwner;


**Description**

[Not implemented] check user is creator of camera

**Return values**

YES - user is owner,
NO - user is not owner

**Example**

	if ([ccstreamer isOwner]) {
		[ccstreamer setName: @"My camera"];
		[ccstreamer saveSync];
	}

#### - (Boolean) HasError

**Description**

Check is error occurs.

**Parameters**

No parameters

**Return values**

true - error occurs;
false - no error.

**Example**

	BOOL is_error = [ccstreamer hasError];
	if(is_error){
		NSLog(@"last error code %d , **Description** %@", [ccstreamer GetResultInt], [ccstreamer GetResultStr]);
	}

#### - (int) GetResultInt


**Description**

Get last result Integer code.

**Parameters**

No parameters

**Return values**

Returns CloudReturnCodes value.

**Example**

	BOOL is_error = [ccstreamer hasError];
	if(is_error){
		NSLog(@"last error code %d , **Description** %@", [ccstreamer GetResultInt], [ccstreamer GetResultStr]);
	}

#### - (NSString*) GetResultStr

**Description**

Get last result String value.

**Parameters**

No parameters

**Return values**

Returns String value of CloudReturnCodes.

**Example**

	BOOL is_error = [ccstreamer hasError];
	if(is_error){
		NSLog(@"last error code %d , **Description** %@", [ccstreamer GetResultInt], [ccstreamer GetResultStr]);
	}

#### -(int) refreshSync

**Description**

Update/refresh camera properties. This function is called synchronously.

**Parameters**

No parameters

**Return values**

Returns CloudReturnCodes value.

**Example**

	enum CloudReturnCodes rc = [ccstreamer refrashSync];
	if (rc == CloudReturnCodeOK)
	//successful refresh

#### -(int) refresh: (void (^)(NSObject* obj, int status)) complete

**Description**

Update/refresh camera properties. This function is called asynchronously.

**Parameters**

No parameters

**Return values**

Returns CloudReturnCodes value.

**Example**

	[ ccstreamer refresh: ^(NSObject* obj, int status){
		if (status == CloudReturnCodeOK){
			//refresh succesfull
		}
	}];

#### -(int) saveSync

**Description**

Save camera properties. This function is called synchronously.

**Parameters**

No parameters

**Return values**

Returns CloudReturnCodes value.

**Example**

	rc = [ccstreamer saveSync];
	if (rc == CloudReturnCodeOk) {
		//save success
	}

#### -(int) save: (void (^)(NSObject* obj, int status)) complete

**Description**

Save camera properties. This function is called asynchronously.

**Parameters**

Complete - callback called in case of success or errors happened due save

**Return values**

Returns CloudReturnCodes value.

**Example**

	[ ccstreamer save: ^(NSObject* obj, int status){
		if (status == CloudReturnCodeOK){
			//save succesfull
		}
	}];

## Class CPlayerConfig
Config to control player settings. 

Following setting are supported: 

* Show/Hide Controls
* Control video output  
* Control Latency 
* Control buffer on start and during playback


#### -(instancetype) init

**Description**

Allocate config object with default value in every setting.

**Parameters**

No input parameters

**Return values**

No return value


#### -(void) visibleControls: (Boolean) bControls

**Description**

Present or hide visible controls in player.

**Parameters**

bControls - shows control if value is true, otherwise hides control.

**Return values**

No return value


#### -(void) aspectRatio: (int) mode

**Description**

Set video output mode.

Following modes are supported:

0 - stretch

1 - fit to screen with aspect ratio

2 - crop

3 - 100% size

4 - zoom mode

5 - move mode

**Parameters**

mode - video output mode. Default value is 1. Correct values are 0-5.

**Return values**

No return value


#### -(void) setMinLatency: (long) latency

**Description**

Set latency control.
Latency in player is controlled by reducing the number of inner buffers in pipeline.

**Parameters**

Latency - set max latency in milliseconds.

**Return values**

No return value


#### -(void) setBufferOnStart:(int) buffering_time

**Description**

Set buffer size on start of playback. Buffer size is allocated based on time stamp information in stream.

**Parameters**

buffering_time - size of buffer in milliseconds.

**Return values**

No return value

## Enum CloudReturnCodes

Returning codes and error codes. Use **getResultInt()** or **getResultStr()** to get the last error.

| Name | Code | Description |
| ------ | ------ | ------ |
|CloudReturnCodeOk	|0	|Success
|CloudReturnCodeOkCompletionPending	|1	|Operation is pending
|CloudReturnCodeErrorNotImplemented	|-1	|Function or method is not implemented
|CloudReturnCodeErrorNotConfigured	|-2	|Object is not configured
|CloudReturnCodeErrorNoMemory	|-12	|Out of memory
|CloudReturnCodeErrorAccessDenided	|-13	|Access denied
|CloudReturnCodeErrorBadArgument	|-22	|Invalid argument
|CloudReturnCodeErrorStreamUnreachable	|-5049	|The stream is not reachable. Please double check the URL address and restart the stream
|CloudReturnCodeErrorExpectedFilter	|-5050	|Expected filter
|CloudReturnCodeErrorNoCloudConnection	|-5051	|No cloud connection (there is no connection object or token is invalid)
|CloudReturnCodeErrorWrongResponse	|-5052	|Response from cloud is expected in json, but we got something else
|CloudReturnCodeErrorSourceNotConfigured	|-5053	|Source is not configured
|CloudReturnCodeErrorInvalidSource	|-5054	|Invalid source
|CloudReturnCodeErrorRecordsNotFound	|-5055	|Records are not found
|CloudReturnCodeErrorNotAuthorized	|-5401	|Failed authorization on cloud (wrong credentials)
|CloudReturnCodeErrorForbidden	|-5403	|
|CloudReturnCodeErrorNotFound	|-5404	|Object is not found
|CloudReturnCodeErrorTooManyRequests	|-5429	|

## Enum CloudPlayerEvent

Notifications that player object generates in various states 

| Name | Code | Description |
| ------ | ------ | ------ |
|CloudPlayerEventConnecting	|0	|Connection is establishing
|CloudPlayerEventConnected	|1	|Connection is established
|CloudPlayerEventStarted	|2	|play() is successfully done. Player changes state to PLAY.
|CloudPlayerEventPaused	|3	|pause() is successfully done. Player state is PAUSE.
|CloudPlayerEventClosed	|6	|close() is successfully finished. Player state is CLOSED.
|CloudPlayerEventSeekCompleted	|17	|setPosition() is successfully finished.
|CloudPlayerEventEOS	|12	|End-Of-Stream event is notifying that playback is stopped because of the end of stream.
|CloudPlayerEventError	|105	|Player is disconnected from media stream due to an error
|CloudPlayerEventTrialVersion	|-999	|Trial version limitation - playback is limited to 2 minutes.

## Enum CloudPlayerState

Player states 

| Name | Code | Description |
| ------ | ------ | ------ |
|CloudPlayerStateConnecting	|0	|Connection is establishing
|CloudPlayerStateConnected	|1	|Connection is established
|CloudPlayerStateStarted	|2	|play() is successfully done. Player state is PLAYED.
|CloudPlayerStatePaused	|3	|pause() is successfully done. Player state is PAUSED.
|CloudPlayerStateClosed	|4	|close() is successfully finished. Player state is CLOSED.
|CloudPlayerStateEOS	|12	|Player is stopped because the End-Of-Stream is reached.

