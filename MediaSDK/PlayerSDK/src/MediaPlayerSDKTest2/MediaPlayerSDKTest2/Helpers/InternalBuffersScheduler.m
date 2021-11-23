//
//  InternalBuffersScheduler.m
//  MediaPlayerSDKTest2
//
//  Created by Max on 15/08/2017.
//
//

#import "InternalBuffersScheduler.h"

@interface InternalBuffersScheduler()
{
    MediaPlayer* mPlayer;

	int mMaxThreshold;
	int mMinThreshold;
	int mMeasurementInterval; // in ms

	// Speed control 
	int mSpeed;
	int mNormalSpeed;
	int mOverSpeed;
	int mDownSpeed;

	/////////////////////////////////////////////////////////////
	// Frames number threshold
	/////////////////////////////////////////////////////////////

	// Upper level of buffering
	int mUpperMaxFrames;
	int mUpperNormalFrames;

	// Lower level of buffering 
	int mLowerMinFrames;
	int mLowerNormalFrames;
	int mVideoFrames;

	int debug_log;

    // support
    bool isRunning;
    dispatch_queue_t queueWorker;
    dispatch_semaphore_t semaphoreClose;
}
@end


@implementation InternalBuffersScheduler


-(id)initWithParams: (MediaPlayer*)player
             maxVal:(int)maxVal
             minVal:(int)minVal
         over_speed:(int)over_speed
          low_speed:(int)low_speed
           interval:(int)interval
{
    self = [super init];
    if (self)
    {
        // default init values
        mMaxThreshold = -1;
        mMinThreshold = -1;
        mMeasurementInterval = 100;

        mSpeed 			= 1000;
        mNormalSpeed 	= 1000;
        mOverSpeed 		= 1050; //  1,2X RATE
        mDownSpeed 		= 950;  //  0,2X RATE

        debug_log        = 1;

        isRunning       = false;
        queueWorker  = dispatch_queue_create("InternalBuffersScheduler", DISPATCH_QUEUE_CONCURRENT);
        semaphoreClose = dispatch_semaphore_create(0);


        //TEST CASE 1
        /*
        mUpperMaxFrames 	= 50;
        mUpperNormalFrames 	= 30;

        mLowerMinFrames 	= 10;
        mLowerNormalFrames 	= 30;
        mVideoFrames		= 0;
        */

        //TEST CASE 2
        mUpperMaxFrames 	= 30;
        mUpperNormalFrames 	= 15;

        mLowerMinFrames 	= 7;
        mLowerNormalFrames 	= 15;
        mVideoFrames		= 0;
	
        /*
        //TEST CASE 3 - 0 - 5 video frames in buffers 
        mUpperMaxFrames 	= 5;
        mUpperNormalFrames	= 1;
        
        mLowerMinFrames 	= 1;
        mLowerNormalFrames	= 3;
        mVideoFrames		= 0;
        */

        // from prameters
		mMaxThreshold		 = maxVal;
		mMinThreshold		 = minVal;
		mPlayer				 = player;
		mSpeed				 = mNormalSpeed;
		mOverSpeed			 = over_speed;
		mDownSpeed			 = low_speed;
		mMeasurementInterval = interval;
     }

     return self;
}

- (void) dealloc
{
    if (debug_log) NSLog(@"%@: dealloc starting...", [self TAG]);
    [self stop];
    
    if (queueWorker)
    {
        queueWorker = NULL;
    }

    if (debug_log) NSLog(@"%@: dealloc end.", [self TAG]);
}

-(NSString *) TAG
{
    return NSStringFromClass([self class]);
}

- (void) controlByNumberVideoFrames
{
    if (mPlayer == nil)
    {
        return;
    }

    int source_videodecoder_filled = 0;
    int source_videodecoder_size = 0;
    int source_videodecoder_num_frms = 0;
    int videodecoder_videorenderer_filled = 0;
    int videodecoder_videorenderer_size = 0;
    int videodecoder_videorenderer_num_frms = 0;
    int source_audiodecoder_filled = 0;
    int source_audiodecoder_size = 0;
    int audiodecoder_audiorenderer_filled = 0;
    int audiodecoder_audiorenderer_size = 0;
    int video_latency = 0;
    int audio_latency = 0;

    [mPlayer getInternalBuffersState:&source_videodecoder_filled
               source_videodecoder_size:&source_videodecoder_size
           source_videodecoder_num_frms:&source_videodecoder_num_frms
      videodecoder_videorenderer_filled:&videodecoder_videorenderer_filled
        videodecoder_videorenderer_size:&videodecoder_videorenderer_size
    videodecoder_videorenderer_num_frms:&videodecoder_videorenderer_num_frms
             source_audiodecoder_filled:&source_audiodecoder_filled
               source_audiodecoder_size:&source_audiodecoder_size
      audiodecoder_audiorenderer_filled:&audiodecoder_audiorenderer_filled
        audiodecoder_audiorenderer_size:&audiodecoder_audiorenderer_size
                          video_latency:&video_latency
                          audio_latency:&audio_latency];

        if (debug_log) NSLog(@"%@: getInternalBuffersState: src<->vide_dec:%d, vid_dec<->vid_ren:%d", [self TAG],
                     source_videodecoder_num_frms,
                     videodecoder_videorenderer_num_frms);

    if (mUpperMaxFrames > 0 && mUpperNormalFrames > 0)
    {
        //int video_frames = state.getBufferFramesSourceAndVideoDecoder() + state.getBufferFramesBetweenVideoDecoderAndVideoRenderer() ;
        int video_frames = source_videodecoder_num_frms + videodecoder_videorenderer_num_frms ;

        if (mVideoFrames == 0)
            mVideoFrames  = video_frames;
        else 
            mVideoFrames  = (mVideoFrames + video_frames)/2;

        if (debug_log) NSLog(@"%@: IBS Current v_frames: %d, m: %d", [self TAG], video_frames, mVideoFrames);

//        if (0 != debug_log) 
//            Log.d(getClass().getName(), "IBS Current v_frames: " + video_frames + " m:" + mVideoFrames);

        if (mVideoFrames != 0)
        {
            if (mVideoFrames >= mUpperMaxFrames &&
                    mNormalSpeed == mSpeed) 
            {
                mSpeed = mOverSpeed;	
//                Log.d(getClass().getName(),
//                        "IBS Threshold reached, setting playback c_speed to " + mSpeed + " v:" + video_frames + ":" + mVideoFrames);
                if (debug_log) NSLog(@"%@: IBS Threshold reached, setting playback c_speed to %d v:%d:%d",
                                                        [self TAG], mSpeed, mVideoFrames, mVideoFrames);
                [mPlayer setFFRate:mSpeed];
            } 
            else if (mVideoFrames <= mUpperNormalFrames &&
                        mOverSpeed == mSpeed )
            {
                mSpeed = mNormalSpeed;
//                Log.d(getClass().getName(),
//                        "IBS Threshold reached setting playback c_speed " + mSpeed  + " v:" + video_frames + ":" + mVideoFrames);
                if (debug_log) NSLog(@"%@: IBS Threshold reached setting playback c_speed %d v:%d:%d",
                                                        [self TAG], mSpeed, mVideoFrames, mVideoFrames);
                [mPlayer setFFRate:mSpeed];
            }
            else if (mVideoFrames <= mLowerMinFrames &&
                        mNormalSpeed == mSpeed)
            {
                mSpeed = mDownSpeed;
//                Log.d(getClass().getName(),
//                        "IBS Threshold reached setting playback c_speed " + mSpeed  + " v:" + video_frames + ":" + mVideoFrames);
                if (debug_log) NSLog(@"%@: IBS Threshold reached setting playback c_speed %d v:%d:%d",
                                                        [self TAG], mSpeed, mVideoFrames, mVideoFrames);
                [mPlayer setFFRate:mSpeed];
            }
            else if (mVideoFrames >= mLowerNormalFrames &&
                        mDownSpeed == mSpeed)
            {
                mSpeed = mNormalSpeed;
//                Log.d(getClass().getName(),
//                        "IBS Threshold reached setting playback c_speed " + mSpeed  + " v:" + video_frames + ":" + mVideoFrames);
                if (debug_log) NSLog(@"%@: IBS Threshold reached setting playback c_speed %d v:%d:%d",
                                                        [self TAG], mSpeed, mVideoFrames, mVideoFrames);
                [mPlayer setFFRate:mSpeed];
            }
        }
    }
}

- (void) threadWorker
{
    if (debug_log) NSLog(@"%@: threadWorker starting...", [self TAG]);

    while ( isRunning &&
                ([mPlayer getState] == MediaPlayerOpened  ||
                    [mPlayer getState] == MediaPlayerOpening ||
                        [mPlayer getState] == MediaPlayerStarted ||
                            [mPlayer getState] == MediaPlayerPaused) )
    {
        [self controlByNumberVideoFrames];
        
        usleep(mMeasurementInterval * 1000);
    }

    if (debug_log) NSLog(@"%@: threadWorker signal close!", [self TAG]);
    dispatch_semaphore_signal(semaphoreClose);

    if (debug_log) NSLog(@"%@: threadWorker closed.", [self TAG]);
}

-(bool) start
{
    if (debug_log) NSLog(@"%@: thread starting...", [self TAG]);

    if (mPlayer == nil)
    {
        if (debug_log) NSLog(@"%@: thread failed mPlayer == nil", [self TAG]);
        return false;
    }

    isRunning = true;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self threadWorker];
    });

    NSLog(@"%@: thread started.", [self TAG]);
    return true;
}

-(void) stop
{
    if (debug_log) NSLog(@"%@: thread closing...", [self TAG]);

    if (!isRunning)
    {
        dispatch_semaphore_wait(semaphoreClose, DISPATCH_TIME_NOW);
        if (debug_log) NSLog(@"%@: thread closed.", [self TAG]);
        return;
    }

    isRunning = false;
    long res = dispatch_semaphore_wait(semaphoreClose, DISPATCH_TIME_FOREVER);

    if (debug_log) NSLog(@"%@: thread closed (%ld)", [self TAG], res);
}


@end
