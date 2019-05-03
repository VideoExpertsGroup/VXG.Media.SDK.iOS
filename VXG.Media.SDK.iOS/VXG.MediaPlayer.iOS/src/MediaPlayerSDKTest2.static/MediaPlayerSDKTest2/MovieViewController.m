/*
 * Copyright (c) 2011-2017 VXG Inc.
 */

#import "MovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "InternalBuffersScheduler.h"

////////////////////////////////////////////////////////////////////////////////
static NSString * formatTimeInterval(CGFloat seconds, BOOL isLeft)
{
    seconds = MAX(0, seconds);
    
    NSInteger s = seconds;
    NSInteger m = s / 60;
    NSInteger h = m / 60;
    
    s = s % 60;
    m = m % 60;

    NSMutableString *format = [(isLeft && seconds >= 0.5 ? @"-" : @"") mutableCopy];
    if (h != 0) [format appendFormat:@"%d:%0.2d", h, m];
    else        [format appendFormat:@"%d", m];
    [format appendFormat:@":%0.2d", s];

    return format;
}

static NSMutableDictionary * gHistory;

@interface MovieViewController () {

    BOOL                _disableUpdateHUD;
    NSTimeInterval      _tickCorrectionTime;
    NSTimeInterval      _tickCorrectionPosition;
    NSUInteger          _tickCounter;
    BOOL                _fullscreen;
    BOOL                _isRecord;
    BOOL                _hiddenHUD;
    BOOL                _fitMode;
    BOOL                _infoMode;
    BOOL                _restoreIdleTimer;
    BOOL                _interrupted;

    UIView              *_topHUD;
    UIToolbar           *_topBar;
    UIToolbar           *_bottomBar;
    UISlider            *_progressSlider;

    UIBarButtonItem     *_playBtn;
    UIBarButtonItem     *_pauseBtn;
    
    UIBarButtonItem     *_aspectBtn;
    UIButton            *_aspectInternalBtn;
    
    UIBarButtonItem     *_volumeMuteBtn;
    UIButton            *_volumeMuteInternalBtn;

    UIBarButtonItem     *_micRecordBtn;
    UIButton            *_micRecordInternalBtn;
    
    UIBarButtonItem     *_speedDownBtn;
    UIButton            *_speedDownInternalBtn;
    
    UIBarButtonItem     *_speedUpBtn;
    UIButton            *_speedUpInternalBtn;
    
    //UIBarButtonItem     *_rewindBtn;
    //UIBarButtonItem     *_fforwardBtn;
    UIBarButtonItem     *_spaceItem;
    UIBarButtonItem     *_fixedSpaceItem;

    UIButton            *_doneButton;
    UIButton            *_shotButton;
    UIButton            *_videoCallbackButton;
    UILabel             *_progressLabel;
    UILabel             *_leftLabel;
    UIButton            *_infoButton;
    UITableView         *_tableView;
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel             *_subtitlesLabel;
    
    UITapGestureRecognizer *_tapGestureRecognizer;
    UITapGestureRecognizer *_doubleTapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureRecognizer;
        
    BOOL                _savedIdleTimer;
    
    NSDictionary        *_parameters;
    NSString            *_path;

    MediaPlayerConfig*  config;
    int                 ff_rate;
    MediaPlayerGraphicLayer graphic_layer;
    int                 hardware_decoder;
    
    M3U8*               m3u8_parser;
    NSArray*            allGetInfoXmlStrings;
    
    int                 shot_buffer_size;
    uint8_t*            shot_buffer;
    
    UIScrollView*       scrollView;

    int                 actualPlayerCount;
    UIView*             frameView[MAX_PLAYERS_COUNT];
    MediaPlayer*        players[MAX_PLAYERS_COUNT];
    
    CGPoint             touchMoveLast;
    
    AVAudioRecorder*    recorder;
    
    BOOL                _showVideoCallbackAlertView;
    UIAlertView*        shotAlertView;
    UIAlertView*        videoCallbackAlertView;
    
    ALAssetsLibrary*    assetsLibrary;
    
    BOOL                _isStarting;

    InternalBuffersScheduler*  buffersScheduler;
    
}

@end

@implementation MovieViewController

+ (void)initialize
{
    if (!gHistory)
        gHistory = [NSMutableDictionary dictionary];
}

- (BOOL)prefersStatusBarHidden { return YES; }

+ (id) movieViewControllerWithContentPath: (NSString *) path
                                    layer: (int)layer
                                       hw: (int)hw
                           countInstances: (int)countInstances
{
    return [[MovieViewController alloc] initWithContentPath:path parameters:nil layer:layer hw:hw countInstances:countInstances];
}

- (id) initWithContentPath: (NSString *) path
                parameters: (NSDictionary *) parameters
                     layer: (int)layer
                        hw: (int)hw
            countInstances: (int)countInstances
{
    NSAssert(path.length > 0, @"empty path");
    
    self = [super initWithNibName:nil bundle:nil];
    LoggerStream(1, @"initWithContentPath controller");
    if (self)
    {
        [MediaPlayerConfig setLogLevel:LOG_LEVEL_ERROR];
        //[MediaPlayerConfig setLogLevelForObjcPart:LOG_LEVEL_TRACE];

        graphic_layer = layer;
        hardware_decoder = hw;
        _path = path;
        _parameters = parameters;
        config = [[MediaPlayerConfig alloc] init];
        config.connectionUrl = _path;
        
        actualPlayerCount = (countInstances < 1 ? 1 : countInstances);
        
        for (int i = 0; i < MAX_PLAYERS_COUNT; i++)
        {
            frameView[i] = nil;
        }

        for (int i = 0; i < MAX_PLAYERS_COUNT; i++)
        {
            players[i] = nil;
        }

        scrollView = nil;
        m3u8_parser = [[M3U8 alloc] init];
        ff_rate = 1000;
        _infoMode = NO;
        
        int width = 5000;
        int height = 5080;
        shot_buffer_size = width * height * 4;
        shot_buffer = malloc(shot_buffer_size);
        
        _isRecord = NO;
        _isStarting = NO;

        buffersScheduler = nil;

        //buffersScheduler = [[InternalBuffersScheduler alloc] initWithParams:
        
    }
    return self;
}

- (void) dealloc
{
    if (shot_buffer)
    {
        free(shot_buffer);
        shot_buffer = 0;
    }
    
    if (recorder != nil)
    {
        if (recorder.recording)
        {
            [recorder stop];

            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"RecordedFromMicrophone.m4a"];
            NSData *data=[NSData dataWithContentsOfURL:recorder.url];
            [data writeToFile:filePath atomically:YES];
        }
        
        [[NSFileManager defaultManager] removeItemAtPath:recorder.url.path error:nil];
        recorder = nil;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (int i = 0; i < MAX_PLAYERS_COUNT; i++)
    {
        frameView[i] = nil;
    }
    
    for (int i = 0; i < MAX_PLAYERS_COUNT; i++)
    {
        if (players[i] != nil)
            LoggerStream(1, @"Close controller %ld", CFGetRetainCount((__bridge CFTypeRef) players[i]));
        players[i] = nil;
    }
    
}

- (void) Close
{
    if (recorder != nil)
    {
        if (recorder.recording)
        {
            [recorder stop];

            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"RecordedFromMicrophone.m4a"];
            NSData *data=[NSData dataWithContentsOfURL:recorder.url];
            [data writeToFile:filePath atomically:YES];
        }

        [[NSFileManager defaultManager] removeItemAtPath:recorder.url.path error:nil];
        recorder = nil;
    }

    for (int i = 0; i < MAX_PLAYERS_COUNT; i++)
    {
        frameView[i] = nil;
    }
    
    for (int i = 0; i < MAX_PLAYERS_COUNT; i++)
    {
        if (players[i] != nil)
            LoggerStream(1, @"Close controller %ld", CFGetRetainCount((__bridge CFTypeRef) players[i]));
        players[i] = nil;
    }
}


- (void)loadView
{
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    
    self.view = [[UIView alloc] initWithFrame:bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.tintColor = [UIColor whiteColor];

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.center = self.view.center;
    _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self.view addSubview:_activityIndicatorView];
    
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    CGFloat topH = 50;
    CGFloat botH = 50;

    _topHUD    = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    _topBar    = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, width, topH)];
    _bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, height-botH, width, botH)];
    _bottomBar.tintColor = [UIColor blackColor];

    _topHUD.frame = CGRectMake(0,0,width,_topBar.frame.size.height);

    _topHUD.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _bottomBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

    [self.view addSubview:_topBar];
    [self.view addSubview:_topHUD];
    [self.view addSubview:_bottomBar];

    // top hud

    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(0, 1, 50, topH);
    _doneButton.backgroundColor = [UIColor clearColor];
//    _doneButton.backgroundColor = [UIColor redColor];
    [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_doneButton setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _doneButton.showsTouchWhenHighlighted = YES;
    [_doneButton addTarget:self action:@selector(doneDidTouch:)
          forControlEvents:UIControlEventTouchUpInside];
//    [_doneButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 1, 50, topH)];
    _progressLabel.backgroundColor = [UIColor clearColor];
    _progressLabel.opaque = NO;
    _progressLabel.adjustsFontSizeToFitWidth = NO;
    _progressLabel.textAlignment = NSTextAlignmentRight;
    _progressLabel.textColor = [UIColor blackColor];
    _progressLabel.text = @"";
    _progressLabel.font = [UIFont systemFontOfSize:12];
    
    _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(100, 2, width-227, topH)];
    _progressSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressSlider.continuous = NO;
    _progressSlider.value = 0;

    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-122, 1, 60, topH)];
    _leftLabel.backgroundColor = [UIColor clearColor];
    _leftLabel.opaque = NO;
    _leftLabel.adjustsFontSizeToFitWidth = NO;
    _leftLabel.textAlignment = NSTextAlignmentLeft;
    _leftLabel.textColor = [UIColor blackColor];
    _leftLabel.text = @"";
    _leftLabel.font = [UIFont systemFontOfSize:12];
    _leftLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
   // _infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _infoButton.frame = CGRectMake(width-92, (topH-20)/2+1, 20, 20);
    [_infoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_infoButton setTitle:NSLocalizedString(@"R", nil) forState:UIControlStateNormal];
    _infoButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _infoButton.showsTouchWhenHighlighted = YES;
    _infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_infoButton addTarget:self action:@selector(infoDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _shotButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    _shotButton.frame = CGRectMake(width-61, (topH-20)/2+1, 20, 20);
    _shotButton.showsTouchWhenHighlighted = YES;
    _shotButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_shotButton addTarget:self action:@selector(shotDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _videoCallbackButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    _videoCallbackButton.frame = CGRectMake(width-31, (topH-20)/2+1, 20, 20);
    _videoCallbackButton.showsTouchWhenHighlighted = YES;
    _videoCallbackButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_videoCallbackButton addTarget:self action:@selector(videoCallbackDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    

    [_topHUD addSubview:_doneButton];
    [_topHUD addSubview:_progressLabel];
    [_topHUD addSubview:_progressSlider];
    [_topHUD addSubview:_leftLabel];
    [_topHUD addSubview:_infoButton];
    [_topHUD addSubview:_shotButton];
    [_topHUD addSubview:_videoCallbackButton];

    // bottom hud

    _spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                               target:nil
                                                               action:nil];
    
    _fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                    target:nil
                                                                    action:nil];
    _fixedSpaceItem.width = 2;
    
    //_rewindBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
    //                                                           target:self
    //                                                           action:@selector(rewindDidTouch:)];

    _playBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                             target:self
                                                             action:@selector(playDidTouch:)];
    _playBtn.width = 10;
    
    _pauseBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                              target:self
                                                              action:@selector(playDidTouch:)];
    _pauseBtn.width = 10;

    //_fforwardBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
    //                                                             target:self
    //                                                             action:@selector(forwardDidTouch:)];
//    _aspectBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
//                                                                 target:self
//                                                                 action:@selector(aspectDidTouch:)];

    _aspectInternalBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_aspectInternalBtn addTarget:self action:@selector(aspectDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [_aspectInternalBtn setTitle:@"Fit to screen" forState:UIControlStateNormal];
    [_aspectInternalBtn setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    [_aspectInternalBtn setTitleColor:[UIColor grayColor]
                 forState:UIControlStateHighlighted];
    _aspectInternalBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _aspectInternalBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    // the space between the image and text
    CGFloat spacing = 1.0;
    CGSize imageSize = _aspectInternalBtn.imageView.image.size;
    _aspectInternalBtn.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    CGSize titleSize = [_aspectInternalBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _aspectInternalBtn.titleLabel.font}];
    _aspectInternalBtn.imageEdgeInsets = UIEdgeInsetsMake(
                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);

    [_aspectInternalBtn setFrame:CGRectMake(0, 0, titleSize.width + imageSize.width, 32)];
    _aspectBtn = [[UIBarButtonItem alloc] initWithCustomView:_aspectInternalBtn];
    
    
    // Mute
    _volumeMuteInternalBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_volumeMuteInternalBtn addTarget:self action:@selector(volumeMuteDidTouch:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [_volumeMuteInternalBtn setTitle:@"\U0001F508" forState:UIControlStateNormal];
    [_volumeMuteInternalBtn setTitleColor:[UIColor blackColor]
                             forState:UIControlStateNormal];
    [_volumeMuteInternalBtn setTitleColor:[UIColor grayColor]
                             forState:UIControlStateHighlighted];
    _volumeMuteInternalBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _volumeMuteInternalBtn.titleLabel.font = [UIFont systemFontOfSize:14];

    // the space between the image and text
    imageSize = _volumeMuteInternalBtn.imageView.image.size;
    _volumeMuteInternalBtn.titleEdgeInsets = UIEdgeInsetsMake(
                                                          0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    titleSize = [_volumeMuteInternalBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _volumeMuteInternalBtn.titleLabel.font}];
    //titleSize = [@"Record" sizeWithAttributes:@{NSFontAttributeName: _volumeInternalBtn.titleLabel.font}];
    _volumeMuteInternalBtn.imageEdgeInsets = UIEdgeInsetsMake(
                                                          - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    [_volumeMuteInternalBtn setFrame:CGRectMake(0, 0, titleSize.width + imageSize.width, 32)];
    _volumeMuteBtn = [[UIBarButtonItem alloc] initWithCustomView:_volumeMuteInternalBtn];
    

    // Record from Microphone
    _micRecordInternalBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_micRecordInternalBtn addTarget:self action:@selector(micRecordDidTouch:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [_micRecordInternalBtn setTitle:@"\U0001F3A4" forState:UIControlStateNormal];
    [_micRecordInternalBtn setTitleColor:[UIColor blackColor]
                                 forState:UIControlStateNormal];
    [_micRecordInternalBtn setTitleColor:[UIColor grayColor]
                                 forState:UIControlStateHighlighted];
    _micRecordInternalBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _micRecordInternalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _micRecordInternalBtn.backgroundColor = [UIColor clearColor];
    
    // the space between the image and text
    imageSize = _micRecordInternalBtn.imageView.image.size;
    _micRecordInternalBtn.titleEdgeInsets = UIEdgeInsetsMake(
                                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    titleSize = [_micRecordInternalBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _micRecordInternalBtn.titleLabel.font}];
    //titleSize = [@"Record" sizeWithAttributes:@{NSFontAttributeName: _volumeInternalBtn.titleLabel.font}];
    _micRecordInternalBtn.imageEdgeInsets = UIEdgeInsetsMake(
                                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    [_micRecordInternalBtn setFrame:CGRectMake(0, 0, titleSize.width + imageSize.width, 32)];
    _micRecordBtn = [[UIBarButtonItem alloc] initWithCustomView:_micRecordInternalBtn];
    
    
    _speedDownInternalBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_speedDownInternalBtn addTarget:self action:@selector(speedDownDidTouch:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [_speedDownInternalBtn setTitle:@"Speed\u261f" forState:UIControlStateNormal];
    [_speedDownInternalBtn setTitleColor:[UIColor blackColor]
                             forState:UIControlStateNormal];
    [_speedDownInternalBtn setTitleColor:[UIColor grayColor]
                             forState:UIControlStateHighlighted];
    _speedDownInternalBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _speedDownInternalBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    // the space between the image and text
    imageSize = _speedDownInternalBtn.imageView.image.size;
    _speedDownInternalBtn.titleEdgeInsets = UIEdgeInsetsMake(
                                                          0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    titleSize = [_speedDownInternalBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _speedDownInternalBtn.titleLabel.font}];
    _speedDownInternalBtn.imageEdgeInsets = UIEdgeInsetsMake(
                                                          - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    [_speedDownInternalBtn setFrame:CGRectMake(0, 0, titleSize.width + imageSize.width, 32)];
    _speedDownBtn = [[UIBarButtonItem alloc] initWithCustomView:_speedDownInternalBtn];
    
    
    _speedUpInternalBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_speedUpInternalBtn addTarget:self action:@selector(speedUpDidTouch:)
                    forControlEvents:UIControlEventTouchUpInside];
    
    [_speedUpInternalBtn setTitle:@"Speed\u261d" forState:UIControlStateNormal];
    [_speedUpInternalBtn setTitleColor:[UIColor blackColor]
                                forState:UIControlStateNormal];
    [_speedUpInternalBtn setTitleColor:[UIColor grayColor]
                                forState:UIControlStateHighlighted];
    _speedUpInternalBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _speedUpInternalBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    // the space between the image and text
    imageSize = _speedUpInternalBtn.imageView.image.size;
    _speedUpInternalBtn.titleEdgeInsets = UIEdgeInsetsMake(
                                                          0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    titleSize = [_speedUpInternalBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _speedUpInternalBtn.titleLabel.font}];
    _speedUpInternalBtn.imageEdgeInsets = UIEdgeInsetsMake(
                                                          - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    [_speedUpInternalBtn setFrame:CGRectMake(0, 0, titleSize.width + imageSize.width, 32)];
    _speedUpBtn = [[UIBarButtonItem alloc] initWithCustomView:_speedUpInternalBtn];
    
    [self updateBottomBar];

    [self setupPresentView];
    
    _progressLabel.hidden = NO;
    _progressSlider.hidden = NO;
    _leftLabel.hidden = NO;
    _infoButton.hidden = NO;
    
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"mic_record_temp.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    shotAlertView = [[UIAlertView alloc] initWithTitle:@"Test video shot"
                                               message:nil
                                              delegate:nil
                                     cancelButtonTitle:@"Close"
                                     otherButtonTitles:nil];
    
    _showVideoCallbackAlertView = NO;
    videoCallbackAlertView = [[UIAlertView alloc] initWithTitle:@"Test video frame callback"
                                               message:nil
                                              delegate:nil
                                     cancelButtonTitle:@"Close"
                                     otherButtonTitles:nil];
    videoCallbackAlertView.tag = 1234;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    if (self.presentingViewController)
        [self fullscreenMode:YES];
    
    _isStarting = NO;
    
    _savedIdleTimer = [[UIApplication sharedApplication] isIdleTimerDisabled];
    
    [self showHUD: YES];
    
    [_activityIndicatorView startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:[UIApplication sharedApplication]];
    config.connectionUrl = _path;
    config.decodingType = hardware_decoder; // HW
    config.connectionNetworkProtocol = -1;//-1;//
    config.numberOfCPUCores = 2;
    config.synchroEnable = 1;
    config.connectionBufferingTime = 3000;
    config.connectionDetectionTime = 2500;
    config.startPreroll = 0;
    //config.rendererType = 1;

    //config.contentProviderLibrary = 1;
    //config.decodingAudioType = 1;

//    for (int i = 0; i < 4; i++){
//        MediaPlayerPlaySegment* segment = [[MediaPlayerPlaySegment alloc] init];
//        segment.segmentId = i;
//        segment.name = [NSString stringWithFormat:@"%@=%d", @"Segment", i];
//        segment.url = config.connectionUrl;
//
//        [config.connectionSegments addObject:segment];
//    }

    //config.aspectRatioMode = 1;
//    config.aspectRatioMode = 4;
//    config.aspectRatioZoomModePercentAsFloat = 354.1f;
//    config.aspectRatioMoveModeXAsFloat = 0.0f;
//    config.aspectRatioMoveModeYAsFloat = 81.1f;


    //config.useNotchFilter = 1;

    //config.decoderLatency = 1;
    //config.dataReceiveTimeout = 5 * 1000;
    //config.playbackSendPlayPauseToServer = 0;
    
    
    //config.enableInternalGestureRecognizers = 3;
    //config.stateWillResignActive = 2;
    //[player Open:config callback:self];
    
    
    
    NSString* ext = [_path pathExtension];

//    if ([ext caseInsensitiveCompare:@"m4a"] == NSOrderedSame)
//    {
//        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:_path error:nil];
//        
//        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
//        LoggerStream(1, @"Audio play: url %@", [NSURL fileURLWithPath:_path]);
//        LoggerStream(1, @"Audio play: size %@", fileSizeNumber);
//        
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_path] error:nil];
//        [player setDelegate:self];
//        [player play];
//        return;
//    }

    BOOL ret = (([ext caseInsensitiveCompare:@"m3u8"] == NSOrderedSame) ? [m3u8_parser getDataSynchroAndParse:_path] : false);
    
    if (!ret)
    {
        for (int i = 0; i < actualPlayerCount; i++)
        {
            [players[i] Open:config callback:self]; usleep(500000);
        }
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Select stream"
                                                   message: nil
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles: nil];
    
    NSMutableArray* hls_streams = [m3u8_parser getChannelsList];
    if (hls_streams == nil || hls_streams.count <= 0)
    {
        for (int i = 0; i < actualPlayerCount; i++)
        {
            [players[i] Open:config callback:self]; usleep(500000);
        }
        return;
    }
    
    for (HLSStream* stream in hls_streams)
    {
        [alert addButtonWithTitle:[NSString stringWithFormat:@"%@(%@)", stream.BANDWIDTH, stream.RESOLUTION]];
        LoggerStream(1, @"Stream: %@", stream);
    }
    
    alert.tag = 777;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 777 && buttonIndex != 0)
    {
        LoggerStream(1, @"Stream selected: %d", buttonIndex);
        config.extStream = buttonIndex - 1;
        
        config.decodingType = hardware_decoder; // HW
        config.numberOfCPUCores = 2;
        //test
        
        //if ([config.connectionUrl hasPrefix:@"http://124.219.68.6:1935/fetpoc/V_3_ABR.smil"])
        if ([config.connectionUrl hasPrefix:@"http://124.219.68.6:1935/vod/2315.smil/playlist.m3u8"])
        {
//            [config.subtitlePaths addObject:@"http://fetpoc.vasfet.com/V_3_cht.srt"];
//            [config.subtitlePaths addObject:@"http://fetpoc.vasfet.com/V_3_eng.srt"];
//            config.selectSubtitle = 0;
//            [player1 subtitleSelect:0];
            config.enableABR = 1;
            LoggerStream(1, @"Subtitle stream selected: %d", 0);
        }
        
        for (int i = 0; i < actualPlayerCount; i++)
        {
            [players[i] Open:config callback:self]; usleep(500000);
        }
    }
    
    if (alertView.tag == 1234 && buttonIndex == 0)
    {
        _showVideoCallbackAlertView = NO;
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
    
    [_activityIndicatorView stopAnimating];
    
    if (_fullscreen)
        [self fullscreenMode:NO];
        
    if (_infoMode)
        [self showInfoView:NO animated:NO];

    [[UIApplication sharedApplication] setIdleTimerDisabled:_savedIdleTimer];
    
    [_activityIndicatorView stopAnimating];
    _interrupted = YES;
    _showVideoCallbackAlertView = NO;
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] Close];
        LoggerStream(1, @"sample: viewWillDisappear: %@", players[i]);
    }
    
    UIView *v = [self.view.subviews objectAtIndex:0];
    [v removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) applicationWillResignActive: (NSNotification *)notification
{
    [self showHUD:YES];
}

- (void)viewDidLayoutSubviews {
    const CGRect rootViewBounds = self.view.bounds;
    scrollView.frame = rootViewBounds;
    
    const CGFloat kHorizontalMargin = 10.0;
    const CGFloat kVerticalMargin = 10.0;
    const CGFloat kVerticalDistancePerShelf = (actualPlayerCount == 1 ? CGRectGetHeight(rootViewBounds) : (2.0 * CGRectGetHeight(rootViewBounds) / 3.0));
    const CGFloat kShelfHeight = (actualPlayerCount == 1 ? CGRectGetHeight(rootViewBounds) : (2.0 * CGRectGetHeight(rootViewBounds) / 3.0));
    const NSUInteger shelvesCount = actualPlayerCount;
    
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [self getPlayerView:i].frame = CGRectMake(kHorizontalMargin,
                                                  i * kVerticalDistancePerShelf,
                                                  CGRectGetWidth(rootViewBounds) - 2.0 * kHorizontalMargin,
                                                  kShelfHeight - 2.0 * kVerticalMargin);
    }
    
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(rootViewBounds), (shelvesCount - 1) * kVerticalDistancePerShelf + kShelfHeight);
}
#pragma mark - gesture recognizer

- (void) handleTap: (UITapGestureRecognizer *) sender
{
    LoggerStream(1, @"handleTap %i", 1);
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (sender == _tapGestureRecognizer) {

            [self showHUD: _hiddenHUD];
            
        } else if (sender == _doubleTapGestureRecognizer) {
                
//            UIView *frameView = [self frameView];
//            
//            if (frameView.contentMode == UIViewContentModeScaleAspectFit)
//                frameView.contentMode = UIViewContentModeScaleAspectFill;
//            else
//                frameView.contentMode = UIViewContentModeScaleAspectFit;
            
        }        
    }
}

- (void) handlePan: (UIPanGestureRecognizer *) sender
{
    LoggerStream(1, @"thandlePan %i", 1);
    if (sender.state == UIGestureRecognizerStateEnded) {
        
//        const CGPoint vt = [sender velocityInView:self.view];
//        const CGPoint pt = [sender translationInView:self.view];
//        const CGFloat sp = MAX(0.1, log10(fabsf(vt.x)) - 1.0);
//        const CGFloat sc = fabsf(pt.x) * 0.33 * sp;
//        if (sc > 10) {
//            
//            const CGFloat ff = pt.x > 0 ? 1.0 : -1.0;            
//            [self setMoviePosition: _moviePosition + ff * MIN(sc, 600.0)];
//        }
        //LoggerStream(2, @"pan %.2f %.2f %.2f sec", pt.x, vt.x, sc);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSSet *allTouches = [event allTouches];
//    LoggerStream(1, @"touchesBegan: contactCount %i", allTouches.count);
//    
//    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
//    LoggerStream(1, @"touchesBegan: touchesCount %i", touch.tapCount);
//    
//    touchMoveLast = [touch locationInView:self.view];
//    LoggerStream(1, @"touchesBegan: touchesBeganX %.0f", touchMoveLast.x);
//    LoggerStream(1, @"touchesBegan: touchesBeganY %.0f", touchMoveLast.y);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
    
    CGPoint touchMoveCurrent = [touch locationInView:self.view];
    int delta_x = (int)(touchMoveCurrent.x - touchMoveLast.x) / 2; // 2 for slow move
    int delta_y = (int)(touchMoveCurrent.y - touchMoveLast.y) / 2;
    
    LoggerStream(1, @"touchesMoved: touchesMovedX %.0f, delta-x %i", touchMoveCurrent.x, delta_x);
    LoggerStream(1, @"touchesMoved: touchesMovedY %.0f, delta-y %i", touchMoveCurrent.y, delta_y);

    int directions = [players[0] getAvailableDirectionsForAspectRatioMoveMode];
    LoggerStream(1, @"touchesMoved: getAvailableDirectionsForAspectRatioMoveMode %i", directions);
    
    MediaPlayerConfig* cfg = [players[0] getConfig];
    if (cfg.aspectRatioMode == 5)
    {
        if ((delta_x >= 0 && (directions & 0x2) == 0x2) ||
            (delta_x < 0 && (directions & 0x1) == 0x1))
            cfg.aspectRatioMoveModeX += delta_x;
        
        if ((delta_y >= 0 && (directions & 0x8) == 0x8) ||
            (delta_y < 0 && (directions & 0x4) == 0x4))
            cfg.aspectRatioMoveModeY -= delta_y;
        
        for (int i = 0; i < actualPlayerCount; i++)
        {
            [players[i] updateView];
        }
    }
    
    touchMoveLast = touchMoveCurrent;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSSet *allTouches = [event allTouches];
//    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
//    CGPoint touchLocation = [touch locationInView:self.view];
//    
//    LoggerStream(1, @"touchesEnded: touchesEndedX %.0f", touchLocation.x);
//    LoggerStream(1, @"touchesEnded: touchesEndedY %.0f", touchLocation.y);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
}
#pragma mark - public

-(void) play
{
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] Play:0];
    }
    [self updatePlayButton];
}

- (void) pause
{
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] Pause];
        //[players[i] PauseWithFlush];
    }
    [self updatePlayButton];
}

#pragma mark - actions

- (void) doneDidTouch: (id) sender
{
    LoggerStream(1, @"doneDidTouch: %d", 0);
    if (self.presentingViewController || !self.navigationController)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void) shotDidTouch: (id) sender
{
    if (players[0] == nil)
        return;
    
    int32_t desired_width = -1;//100;
    int32_t desired_height = -1;//100;
    int32_t bytes_per_row = 0;
    
    int rc = [players[0] getVideoShot:shot_buffer buffer_size:&shot_buffer_size width:&desired_width height:&desired_height bytes_per_row:&bytes_per_row];
    LoggerStream(1, @"getVideoShot retrun rc=%d", rc);
    if (rc < 0)
        return;
    
    NSString* info = [players[0] getStreamInfo];
    LoggerStream(1, @"getStreamInfo: = %@", info);

    // info from thumnailer
//    Thumbnailer* thumb = [[Thumbnailer alloc] init];
//    ThumbnailerConfig* confThumb = [[ThumbnailerConfig alloc] init];
//    confThumb.connectionUrl = config.connectionUrl;
//    confThumb.outWidth = 328;
//    confThumb.outHeight = 240;
//    
//    dispatch_semaphore_t waitOpen = [thumb Open:confThumb];
//    dispatch_semaphore_wait(waitOpen, DISPATCH_TIME_FOREVER);
//
//    if ([thumb getState] != ThumbnailerOpened)
//    {
//        LoggerStream(1, @"failed open thumbnailer %d", 0);
//        return;
//    }
//
//
//    int rc = [thumb getFrame:shot_buffer buffer_size:shot_buffer_size width:&desired_width height:&desired_height bytes_per_row:&bytes_per_row];
//    LoggerStream(1, @"Thumbnailer getFrame: rc: %d, width: %d, height: %d bytes_per_row: %d", rc, desired_width, desired_height, bytes_per_row);
//
//    [thumb Close];
    
    [self showShotView:shot_buffer buffer_size:shot_buffer_size width:desired_width height:desired_height bytes_per_row:bytes_per_row];
}

- (void) videoCallbackDidTouch: (id) sender
{
    if (players[0] == nil)
        return;
    
    [videoCallbackAlertView show];
    _showVideoCallbackAlertView = YES;
}


- (void) infoDidTouch: (id) sender
{
//    if (_infoMode)
//    {
//        [self showInfoView: !_infoMode animated:YES];
//        return;
//    }
 
    if (players[0] == nil)
        return;

    if (_isRecord)
    {
        [players[0] recordStop];
        _isRecord = NO;
        [_infoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        NSString * tmpfile = [NSTemporaryDirectory() stringByAppendingPathComponent:@""];
        [players[0] recordSetup: tmpfile flags: (RECORD_AUTO_START | RECORD_PTS_CORRECTION) splitTime:0 splitSize:0 prefix:@"TestRecord"];
        [players[0] recordStart];
        _isRecord = YES;
        [_infoButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_infoButton setFont:[UIFont boldSystemFontOfSize:18]];
    }
    
//    // info from thumnailer
//    Thumbnailer* thumb = [[Thumbnailer alloc] init];
//    ThumbnailerConfig* confThumb = [[ThumbnailerConfig alloc] init];
//    confThumb.connectionUrl = config.connectionUrl;
//    
//    NSCondition* waitOpen = [thumb Open:confThumb];
//    
//    [waitOpen wait];
//    
//    if ([thumb getState] != ThumbnailerOpened)
//    {
//        LoggerStream(1, @"failed open thumbnailer %d", 0);
//        return;
//    }
//    
//    NSString* info = [thumb getInfo];
//    LoggerStream(1, @"Thumbnailer info: %@", info);
//    
//    allGetInfoXmlStrings = [info componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
//    
//    [thumb Close];
//    
//    [self showInfoView: !_infoMode animated:YES];

    
}

- (void) playDidTouch: (id) sender
{
    if (players[0] == nil)
        return;
    
    MediaPlayerState state = [players[0] getState];
    LoggerStream(1, @"getState %d", state);
    if (state == MediaPlayerStarted)
        [self pause];
    else
        [self play];

    [_activityIndicatorView stopAnimating];

}

- (void) aspectDidTouch: (id) sender
{
    if (players[0] == nil)
        return;
    
    MediaPlayerConfig* cfg = [players[0] getConfig];
    cfg.aspectRatioMode++;
    if (cfg.aspectRatioMode > 8)
        cfg.aspectRatioMode = 0;

    [scrollView setUserInteractionEnabled:YES];
    switch (cfg.aspectRatioMode)
    {
        case 0:
            [_aspectInternalBtn setTitle:@"Stretch" forState:UIControlStateNormal];
            break;
        case 1:
            [_aspectInternalBtn setTitle:@"Fit to screen" forState:UIControlStateNormal];
            break;
        case 2:
            [_aspectInternalBtn setTitle:@"Crop" forState:UIControlStateNormal];
            break;
        case 3:
            [_aspectInternalBtn setTitle:@"Original size" forState:UIControlStateNormal];
            break;
        case 4:
            [_aspectInternalBtn setTitle:@"Zoom/Move1" forState:UIControlStateNormal];
            break;
        case 5:
            [_aspectInternalBtn setTitle:@"Zoom/Move2" forState:UIControlStateNormal];
            break;

        case 6:
            [_aspectInternalBtn setTitle:@"Zoom/Move3" forState:UIControlStateNormal];
            break;

        case 7:
            [_aspectInternalBtn setTitle:@"Zoom/Move4" forState:UIControlStateNormal];
            break;

//        case 5:
//        {
//            MediaPlayerConfig* cfg = [players[0] getConfig];
//            if (cfg.aspectRatioMode == 5)
//            {
//                cfg.aspectRatioMoveModeX = 50;
//                cfg.aspectRatioMoveModeY = 50;
//                for (int i = 0; i < actualPlayerCount; i++)
//                {
//                    [players[i] updateView];
//                }
//            }
////            [scrollView setUserInteractionEnabled:NO];
//            [_aspectInternalBtn setTitle:@"Zoom/Move" forState:UIControlStateNormal];
//            break;
//        }
    }
    
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] updateView];
    }
}

- (void) volumeMuteDidTouch: (id) sender
{
    if (players[0] == nil)
        return;
    
    MediaPlayerConfig* cfg = [players[0] getConfig];
    BOOL mute = (cfg.enableAudio == 1);
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] toggleMute:mute];
    }

    LoggerStream(1, @"enableAudio %d", cfg.enableAudio);
    switch (cfg.enableAudio)
    {
        case 0:
            [_volumeMuteInternalBtn setTitle:@"\U0001F507" forState:UIControlStateNormal];
            break;
        case 1:
            [_volumeMuteInternalBtn setTitle:@"\U0001F508" forState:UIControlStateNormal];
            break;
    }
}

- (void) micRecordDidTouch: (id) sender
{
    if (players[0] == nil)
        return;
    
    if (!recorder.recording)
    {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        _micRecordInternalBtn.backgroundColor = [UIColor redColor];
        [_micRecordInternalBtn setTitle:@"\U0001F3A4" forState:UIControlStateNormal];
        //[recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    }
    else
    {
        // Pause recording
        [recorder stop];
        
        //AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //[audioSession setActive:NO error:nil];
        
        _micRecordInternalBtn.backgroundColor = [UIColor clearColor];
        [_micRecordInternalBtn setTitle:@"\U0001F3A4" forState:UIControlStateNormal];
        //[recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    }
}
         
- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"RecordedFromMicrophone.m4a"];
    NSData *data=[NSData dataWithContentsOfURL:recorder.url];
    [data writeToFile:filePath atomically:YES];
    
    [[NSFileManager defaultManager] removeItemAtPath:recorder.url.path error:nil];
    
 }

- (void) speedDownDidTouch: (id) sender
{
    
//    UIView *frameView = [self frameView];
//    frameView.frame = CGRectMake( 0, 0, 500, 500 );
    
//    MediaPlayerConfig* cfg = [players[0] getConfig];
//    if (cfg.aspectRatioMode == 4)
//    {
//        cfg.aspectRatioZoomModePercent--;
//        for (int i = 0; i < actualPlayerCount; i++)
//        {
//            [players[i] updateView];
//        }
//        return;
//    }
    
    ff_rate = 400;
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] setFFRate:ff_rate];
    }
}

- (void) speedUpDidTouch: (id) sender
{
//    UIView *frameView = [self frameView];
//    frameView.frame = self.view.bounds;

//    MediaPlayerConfig* cfg = [players[0] getConfig];
//    if (cfg.aspectRatioMode == 4)
//    {
//        cfg.aspectRatioZoomModePercent++;
//        for (int i = 0; i < actualPlayerCount; i++)
//        {
//            [players[i] updateView];
//        }
//        return;
//    }
    
    ff_rate = 3000;
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] setFFRate:ff_rate];
    }
}


- (void) forwardDidTouch: (id) sender
{
//    [self setMoviePosition: _moviePosition + 10];
}

- (void) rewindDidTouch: (id) sender
{
//    [self setMoviePosition: _moviePosition - 10];
}

- (void) progressDidChange: (id) sender
{
    UISlider *slider = sender;
    [players[0] setLiveStreamPosition:slider.value * 1000];
}

#pragma mark - private

- (void) restorePlay
{
}

- (void) setupPresentView
{
    CGRect bounds = self.view.bounds;
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [self getPlayerView:i].frame = CGRectMake( 0, i * 758, 320, 758 );
    }
   
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.contentSize=CGSizeMake(320, actualPlayerCount * 758);
    scrollView.contentInset=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);

    for (int i = 0; i < actualPlayerCount; i++)
    {
        [scrollView addSubview:[self getPlayerView:i]];
    }
    
    [self.view insertSubview:scrollView atIndex:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) setupUserInteraction
{
    UIView * view = [self getPlayerView:0];
    self.view.userInteractionEnabled = YES;
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    _tapGestureRecognizer.numberOfTapsRequired = 1;
    
    _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    
    [_tapGestureRecognizer requireGestureRecognizerToFail: _doubleTapGestureRecognizer];
    
    [self.view addGestureRecognizer:_doubleTapGestureRecognizer];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
    
}

- (UIView *) getPlayerView:(int)index
{
    LoggerStream(1, @"getPlayerView %@", players[index]);
    if (players[index] == nil)
    {
        //players[index] = [[MediaPlayer alloc] init:CGRectMake( 0, 0, 100, 100 )];
        players[index] = [[MediaPlayer alloc] initWithBounds:CGRectMake( 0, 0, 100, 100 ) andGraphicLayer:graphic_layer];
        LoggerStream(1, @"alloc player %ld", CFGetRetainCount((__bridge CFTypeRef) players[index]));
    }

    return [players[index] contentView];
}


- (void) enableAudio: (BOOL) on
{
}

- (void) tick
{
    MediaPlayerState state = [players[0] getState];
    
    if (state == MediaPlayerStarted ||
           state == MediaPlayerPaused)
    {
        _tickCorrectionTime = 0;
        [_activityIndicatorView stopAnimating];
    }
    
    if (state == MediaPlayerStarted ||
            state == MediaPlayerPaused)
    {
        const NSTimeInterval time =  0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            [self tick];
        });
    }
 
    if ((_tickCounter % 200) == 0)
    {
        LoggerStream(1, @"getStatFPS: %f, isHrdware %d", [players[0] getStatFPS], [players[0] isHardwareDecoding]);
        
//        int buffer_size_sr = 0;
//        char* buff_sr = [players[0] getPropBinary: PROPERTY_PLP_RTCP_SR buffer_size:&buffer_size_sr];
//        int buffer_size_rr = 0;
//        char* buff_rr = [players[0] getPropBinary: PROPERTY_PLP_RTCP_RR buffer_size:&buffer_size_rr];
//
//        LoggerStream(1, @"PROPERTY_PLP_RTCP_SR: %d, buff_sr %p", buffer_size_sr, buff_sr);
//        LoggerStream(1, @"PROPERTY_PLP_RTCP_RR: %d, buff_rr %p", buffer_size_rr, buff_rr);
    }
 
    if ((_tickCounter++ % 3) == 0)
    {
        [self updateHUD];
        
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
        [players[0] getInternalBuffersState:&source_videodecoder_filled
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
        //LoggerStream(1, @"getInternalBuffersState: %d, %d, %d, %d, %d, %d, %d, %d",
        //             source_videodecoder_filled, source_videodecoder_size, videodecoder_videorenderer_filled, videodecoder_videorenderer_size,
        //             source_audiodecoder_filled, source_audiodecoder_size, audiodecoder_audiorenderer_filled, audiodecoder_audiorenderer_size);
        
        int view_orientation = 0;
        int view_width = 0;
        int view_height = 0;
        int video_width = 0;
        int video_height = 0;
        int aspect_left = 0;
        int aspect_top = 0;
        int aspect_width = 0;
        int aspect_height = 0;
        int aspect_zoom = 0;
        [players[0] getViewSizesAndVideoAspects:&view_orientation
                                     view_width:&view_width
                                    view_height:&view_height
                                    video_width:&video_width
                                   video_height:&video_height
                                    aspect_left:&aspect_left
                                     aspect_top:&aspect_top
                                   aspect_width:&aspect_width
                                  aspect_height:&aspect_height
                                    aspect_zoom:&aspect_zoom];
        //LoggerStream(1, @"getViewSizesAndVideoAspects: %d, %d, %d, %d, %d, %d, %d, %d, %d, %d",
        //            view_orientation, view_width, view_height, video_width, video_height,
        //            aspect_left, aspect_top, aspect_width, aspect_height, aspect_zoom);
    }
}

- (void) updateBottomBar
{
    MediaPlayerState state = [players[0] getState];
    UIBarButtonItem *playPauseBtn = (state == MediaPlayerStarted) ? _pauseBtn : _playBtn;
    //[_bottomBar setItems:@[_spaceItem, _rewindBtn, _fixedSpaceItem, playPauseBtn,
    //                       _fixedSpaceItem, _fforwardBtn, _spaceItem] animated:NO];
    [_bottomBar setItems:@[_spaceItem, _fixedSpaceItem, _speedDownBtn, _speedUpBtn, _fixedSpaceItem, playPauseBtn, _fixedSpaceItem, _aspectBtn,
                           _fixedSpaceItem, _volumeMuteBtn, _fixedSpaceItem, _micRecordBtn, _spaceItem] animated:NO];
}

- (void) updatePlayButton
{
    [self updateBottomBar];
}

- (void) updateHUD
{
    if (_disableUpdateHUD)
        return;

    
    int64_t _first = 0;
    int64_t _current = 0;
    int64_t _last = 0;
    int64_t _duration = 0;
    int     _stream_type = 0;
    [players[0] getLiveStreamPosition:&_first
                          current:&_current
                             last:&_last
                         duration:&_duration
                      stream_type:&_stream_type];
    
    //LoggerStream(1, @"position: %lld, %lld, %lld, %lld, %d", _first, _current, _last, _duration, _stream_type);
    
    const CGFloat duration = _duration / 1000;
    const CGFloat position = _current / 1000;
    
    if (duration == 0)
    {
        _leftLabel.text = @"\u221E"; // infinity
        _leftLabel.font = [UIFont systemFontOfSize:14];
        return;
    }
    
    if (_progressSlider.state == UIControlStateNormal)
    {
        _progressSlider.minimumValue = 0;
        _progressSlider.maximumValue = duration;
        _progressSlider.value = position;
    }
    
    _progressLabel.text = formatTimeInterval(position, NO);
    
    if (_duration != 0)
        _leftLabel.text = formatTimeInterval(duration, NO);

}

- (void) showHUD: (BOOL) show
{
    _hiddenHUD = !show;    
    _panGestureRecognizer.enabled = _hiddenHUD;
        
    [[UIApplication sharedApplication] setIdleTimerDisabled:_hiddenHUD];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                     animations:^{
                         
                         CGFloat alpha = _hiddenHUD ? 0 : 1;
                         _topBar.alpha = alpha;
                         _topHUD.alpha = alpha;
                         _bottomBar.alpha = alpha;
                     }
                     completion:nil];
    
}

- (void) fullscreenMode: (BOOL) on
{
    _fullscreen = on;
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:on withAnimation:UIStatusBarAnimationNone];
    // if (!self.presentingViewController) {
    //[self.navigationController setNavigationBarHidden:on animated:YES];
    //[self.tabBarController setTabBarHidden:on animated:YES];
    // }
}

- (void) enableUpdateHUD
{
    _disableUpdateHUD = NO;
}

- (int) Status: (MediaPlayer*)player1
          args: (int)arg
{
    NSLog(@"Status called: arg code is %d for instance %@", arg, player1);
    switch(arg)
    {
        case CP_ERROR_NODATA_TIMEOUT:
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                //[player1 Close];
                [player1 Stop];
            });
            break;
        }
        case PLP_BUILD_STARTING:
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [_activityIndicatorView startAnimating];
                [self updatePlayButton];
            });
            break;
        }
        case PLP_PLAY_STARTING:
        {
            _isStarting = YES;
            break;
        }
        case PLP_PLAY_SUCCESSFUL:
        {
//            if (buffersScheduler == nil)
//            {
//                buffersScheduler = [[InternalBuffersScheduler alloc] initWithParams:players[0]
//                                                                             maxVal:(int)40000
//                                                                             minVal:(int)10000
//                                                                         over_speed:(int)1050
//                                                                          low_speed:(int)950
//                                                                           interval:(int)100];
//            }
//
//            [buffersScheduler start];

//            int64_t first_pts = [player1 getPropInt64:PROPERTY_PLP_PTS_IN_FIRST_RTP];
//            int64_t first_pts_on_play = [player1 getPropInt64:PROPERTY_PLP_PTS_IN_RANGE];
//            NSString* RTCP_PACKET = [player1 getPropString:PROPERTY_PLP_RTCP_PACKAGE];
//            NSLog(@"Status called: PROPERTY_PLP_PTS_IN_FIRST_RTP: %lld, PROPERTY_PLP_PTS_IN_RANGE: %lld, PROPERTY_PLP_RTCP_PACKAGE: %@",
//                                first_pts, first_pts_on_play, RTCP_PACKET);
//
//            int buffer_size_sr = 0;
//            char* buff_sr = [players[0] getPropBinary: PROPERTY_PLP_RTCP_SR buffer_size:&buffer_size_sr];
//            int buffer_size_rr = 0;
//            char* buff_rr = [players[0] getPropBinary: PROPERTY_PLP_RTCP_RR buffer_size:&buffer_size_rr];
//
//            NSLog(@"Status called: PROPERTY_PLP_RTCP_SR: %d, %p, PROPERTY_PLP_RTCP_RR: %d, %p",
//                  buffer_size_sr, buff_sr, buffer_size_rr, buff_rr);

//
//            NSArray *items = [RTCP_PACKET componentsSeparatedByString:@";"];
//            for (int i = 0; i < [items count]; i++) {
//                NSArray *pair = [items[i] componentsSeparatedByString:@":"];
//                NSLog(@"Status called: pair: %@", pair);
//                if ([pair[0] isEqualToString:@"first_rtcp_ntp_time"]){
//                    int64_t final_time = 0;
//                    int64_t msb0baseTime = 2085978496000L;
//                    int64_t msb1baseTime = -2208988800000L;
//
//                    uint64_t ntpTimeValue = strtoull([pair[1] UTF8String], NULL, 0);
//                    int64_t seconds = (ntpTimeValue >> 32) & 0xffffffffL;     // high-order 32-bits
//                    int64_t fraction = ntpTimeValue & 0xffffffffL;             // low-order 32-bits
//
//                    fraction = round(1000 * fraction / 0x100000000L);
//                    int64_t msb = seconds & 0x80000000L;
//                    if (msb == 0) {
//                        // use base: 7-Feb-2036 @ 06:28:16 UTC
//                        final_time = msb0baseTime + (seconds * 1000) + fraction;
//                    } else {
//                        // use base: 1-Jan-1900 @ 01:00:00 UTC
//                        final_time = msb1baseTime + (seconds * 1000) + fraction;
//                    }
//
//                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:final_time/1000.0];
//                    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
//                    [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//                    NSString *dateString=[dateformatter stringFromDate:date];
//                    NSLog(@"Status called: dateString: %@", dateString);
//                }
//            }
            break;
        }
        case PLP_PLAY_PAUSE:
        {
            if (!_isStarting)
                break;
            
            _isStarting = NO;
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [_activityIndicatorView stopAnimating];
                [self updatePlayButton];
                
                [_progressSlider addTarget:self
                                    action:@selector(progressDidChange:)
                          forControlEvents:UIControlEventValueChanged];

                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self tick];
                });
                
                
                
            });
            break;
        }

        case PLP_CLOSE_STARTING:
        {
//            if (buffersScheduler != nil)
//                [buffersScheduler stop];
//
//            buffersScheduler = nil;

 //           dispatch_async(dispatch_get_main_queue(), ^
 //                          {
                               NSLog(@"Status called: arg code is %d for instance %@ invoke close", arg, player1);
                               [player1 Close];
 //                          });
            break;
        }
    }
    return 0;
}

-(int) OnReceiveData: (MediaPlayer*)player
              buffer: (void*)buffer
                size: (int) size
                 pts: (long) pts
{
    
    NSLog(@"OnReceiveData called");
    return 0;
}

- (int) OnReceiveSubtitleString: (MediaPlayer*)player
                           data: (NSString*)data
                       duration: (uint64_t)duration
{
    
    NSLog(@"OnReceiveSubtitleString called: %@, %llu", data, duration);
    return 0;
}

void ReleaseCVPixelBufferForCVPixelBufferCreateWithBytes(void *releaseRefCon, const void *baseAddr)
{
    CFDataRef bufferData = (CFDataRef)releaseRefCon;
    CFRelease(bufferData);
}

//- (int) OnVideoSourceFrameAvailable: (MediaPlayer*)player
//                             buffer: (void*)buffer
//                               size: (int)  size
//                                pts: (long) pts
//                                dts: (long) dts
//                       stream_index: (int)  stream_index
//                             format: (int)  format
//{
//    NSLog(@"OnVideoSourceFrameAvailable called: buffer:%p, size:%d, pts:%ld, dts:%ld, stream_index:%d, format:%d",
//          buffer, size, pts, dts, stream_index, format);
//    return 0;
//}

//- (int) OnAudioSourceFrameAvailable: (MediaPlayer*)player
//                             buffer: (void*)buffer
//                               size: (int)  size
//                                pts: (long) pts
//                                dts: (long) dts
//                       stream_index: (int)  stream_index
//                             format: (int)  format
//{
//    NSLog(@"OnAudioSourceFrameAvailable called: buffer:%p, size:%d, pts:%ld, dts:%ld, stream_index:%d, format:%d",
//          buffer, size, pts, dts, stream_index, format);
//    return 0;
//}
//
//- (int) OnVideoRendererFrameAvailable: (MediaPlayer*)player
//                               buffer: (void*)buffer
//                                 size: (int)  size
//                        format_fourcc: (char*)format_fourcc
//                                width: (int)  width
//                               height: (int)  height
//                        bytes_per_row: (int)  bytes_per_row
//                                  pts: (long) pts
//                            will_show: (int)  will_show
//{
//
//    NSLog(@"OnVideoRendererFrameAvailable called: buffer:%p, size:%d, format_fourcc:%s, width:%d, height:%d, bytes_per_row:%d, pts:%llu, will_show:%d", buffer, size, format_fourcc, width, height, bytes_per_row, pts, will_show);
//
//    NSString* fourccString = [NSString stringWithFormat:@"%s" , format_fourcc];
//    if ([fourccString caseInsensitiveCompare:@"I420"] == NSOrderedSame)
//    {
//        char* pbuffer = buffer;
//        char* plogo = logo;
//        for (int h = 0; h < 50; h++)
//        {
//            int index = 0;
//            for (int w = 0; w < 128; w++)
//            {
//                char Y = 128;//0.299 * plogo[index] + 0.587 * plogo[index+1] + 0.114 * plogo[index+2];
//                memset(pbuffer, Y, 1);
//                pbuffer++; index++;
//            }
//
//            pbuffer += (bytes_per_row - 128);
//            plogo += 128 * 4;
//        }
//    }
//
//    if ([fourccString caseInsensitiveCompare:@"BGRA"] == NSOrderedSame)
//    {
///*        CVPixelBufferRef pixelBuffer;
//        CFDataRef bufferData = CFDataCreate(NULL, buffer, height * bytes_per_row);
//
//        CVPixelBufferCreateWithBytes(kCFAllocatorSystemDefault,
//                                     width,
//                                     height,
//                                     kCVPixelFormatType_32ARGB,
//                                     (void*)CFDataGetBytePtr(bufferData),
//                                     bytes_per_row,
//                                     ReleaseCVPixelBufferForCVPixelBufferCreateWithBytes,
//                                     (void*)bufferData,
//                                     NULL,
//                                     &pixelBuffer);
//
//        CFRelease(pixelBuffer);*/
//
////        dispatch_async(dispatch_get_main_queue(), ^
////        {
////            [self showVideoCallbackView:buffer buffer_size:size width:width height:height bytes_per_row:bytes_per_row];
////        });
//        char* pbuffer = buffer;
//        char* plogo = logo;
//        for (int h = 0; h < 50; h++)
//        {
//            memcpy(pbuffer, plogo, 128 * 4);
//            pbuffer += bytes_per_row;
//            plogo += 128 * 4;
//        }
//    }
//
//    return 0;
//}


- (void) showInfoView: (BOOL) showInfo animated: (BOOL)animated
{
    if (!_tableView)
        [self createTableView];
    
    //[self pause];
    
    CGSize size = self.view.bounds.size;
    CGFloat Y = _topHUD.bounds.size.height;
    
    if (showInfo) {
        
        _tableView.hidden = NO;
        
        if (animated) {
            
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                             animations:^{
                                 
                                 _tableView.frame = CGRectMake(0,Y,size.width,size.height - Y);
                             }
                             completion:nil];
        } else {
            
            _tableView.frame = CGRectMake(0,Y,size.width,size.height - Y);
        }
        
    } else {
        
        if (animated) {
            
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                             animations:^{
                                 
                                 _tableView.frame = CGRectMake(0,size.height,size.width,size.height - Y);
                                 
                             }
                             completion:^(BOOL f){
                                 
                                 if (f) {
                                     _tableView.hidden = YES;
                                 }
                             }];
        } else {
            
            _tableView.frame = CGRectMake(0,size.height,size.width,size.height - Y);
            _tableView.hidden = YES;
        }
    }
    
    _infoMode = showInfo;
}

- (void) showShotView:(uint8_t*)buffer
          buffer_size:(int32_t)buffer_size
                width:(int32_t)width
               height:(int32_t)height
        bytes_per_row:(int32_t)bytes_per_row

{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 10, 85, 50)];
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,
                                                              buffer,
                                                              buffer_size,
                                                              NULL);
    
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = bytes_per_row;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width,
                                        height,
                                        8,
                                        32,
                                        bytes_per_row,colorSpaceRef,
                                        bitmapInfo,
                                        provider,NULL,NO,renderingIntent);

    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    [imageView setImage:newImage];
    
    //check if os version is 7 or above
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [shotAlertView setValue:imageView forKey:@"accessoryView"];
    }else{
        [shotAlertView addSubview:imageView];
    }

    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    
    [shotAlertView show];
}

- (void) showVideoCallbackView:(uint8_t*)buffer
          buffer_size:(int32_t)buffer_size
                width:(int32_t)width
               height:(int32_t)height
        bytes_per_row:(int32_t)bytes_per_row
{
    if (!_showVideoCallbackAlertView)
        return;
    
//    [videoCallbackAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 10, 85, 50)];
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, buffer_size, NULL);
    
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = bytes_per_row;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width,
                                        height,
                                        8,
                                        32,
                                        bytes_per_row,colorSpaceRef,
                                        bitmapInfo,
                                        provider,NULL,NO,renderingIntent);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    [imageView setImage:newImage];
    
    //check if os version is 7 or above
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [videoCallbackAlertView setValue:imageView forKey:@"accessoryView"];
    }else{
        [videoCallbackAlertView addSubview:imageView];
    }
    
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    
    //[videoCallbackAlertView show];
}

- (void) createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.hidden = YES;
    
    CGSize size = self.view.bounds.size;
    CGFloat Y = _topHUD.bounds.size.height;
    _tableView.frame = CGRectMake(0,size.height,size.width,size.height - Y);
    
    [self.view addSubview:_tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Get info return XML", nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allGetInfoXmlStrings count];
}

- (id) mkCell: (NSString *) cellIdentifier
    withStyle: (UITableViewCellStyle) style
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [self mkCell:@"ValueCell" withStyle:UITableViewCellStyleValue1];
    cell.textLabel.text = [allGetInfoXmlStrings objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end

