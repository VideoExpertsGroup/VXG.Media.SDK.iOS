/*
 * Copyright (c) 2011-2017 VXG Inc.
 */

#import "MainViewController.h"
#import "MovieViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "../Helpers/Url.h"
#import "../Helpers/Utils.h"
#import <AVKit/AVKit.h>

#import "ONVIFDeviceManager.h"

@interface MainViewController () <ONVIFDeviceManagerDelegate> {
    
    NSMutableArray *_localMovies;
    NSMutableArray *_onvifMovies;
    NSMutableArray *_remoteMovies;
    
    ALAsset *assetSaved;
    ALAssetsLibrary *assetsLibrary;
    
    Url* _current_url;
    int count_local_files;
    int countPlayers;
    int graphic_layer;
    MovieViewController *vc;
    NSString *_last_entered_url;
    
    UIAlertView * alertCopyToPhotos;
    ONVIFDeviceManager* onvifManager;
    
}
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"MediaPlayer SDK Test";
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag: 0];
        
        onvifManager = [[ONVIFDeviceManager alloc] init];
        _last_entered_url = nil;
        count_local_files = 0;
        countPlayers = 1;
        _localMovies = [NSMutableArray array];
        _remoteMovies = [NSMutableArray array];
        _onvifMovies = [NSMutableArray array];
        
        // standard
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"BigBuckBunny from RTSP" url:@"rtsp://rtsp.stream/movie"image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"Pattern from RTSP" url:@"rtsp://rtsp.stream/pattern" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"BipBop" url:@"http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8" image:nil]];

        [_remoteMovies addObject:[[Url alloc] initWithParam:@"ElephantsDream from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"WhatCarCanYouGetForAGrand from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"BigBuckBunny from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"ForBiggerBlazes from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"ForBiggerEscapes from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"ForBiggerFun from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"ForBiggerJoyrides from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"ForBiggerMeltdowns from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"Sintel from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"SubaruOutbackOnStreetAndDirt from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"TearsOfSteel from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"VolkswagenGTIReview from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"WeAreGoingOnBullrun from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4" image:nil]];
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"WhatCarCanYouGetForAGrand from Google"
                                                        url:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4" image:nil]];

        // own
        MediaPlayerConfig* config1 = [[MediaPlayerConfig alloc] init];
        config1.connectionUrl = @"rtsp://rtsp.stream/movie";
        config1.contentProviderLibrary = 1;
        [_remoteMovies addObject:[[Url alloc] initWithConfig:@"BigBuckBunny using own RTSTM" config:config1]];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:image];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:self.tableView];
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"MediaPlayer(Multi) SDK Test";

    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"\u2795"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(addUrl:)];
    self.navigationItem.rightBarButtonItem = flipButton;
    
#ifdef DEBUG_AUTOPLAY
    [self performSelector:@selector(launchDebugTest) withObject:nil afterDelay:0.5];
#endif
}

-(IBAction)addUrl:(id)sender
{
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New url" message:@"Type url here:" delegate:self cancelButtonTitle:@"Add" otherButtonTitles:nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alert show];

//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Message" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"Click" style:UIAlertActionStyleDefault handler:nil]];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
//    {
//        textField.placeholder = @"Type URL here";
//        textField.secureTextEntry = YES;
//    }];
//    
//    [self presentViewController:alert animated:YES completion:nil];

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"New URL:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeURL;
    alertTextField.placeholder = @"Type URL here";
    alert.tag = 3456;
    
    if (_last_entered_url != nil)
    {
        alertTextField.text = _last_entered_url;
    }
    
    [alert show];

}

- (void)launchDebugTest
{
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:4
                                                                              inSection:1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Loading files, wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    [self reloadMovies];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    if (vc != nil)
    {
        [vc Close];
        vc = nil;
    }
}

- (int)OnONVFDeviceDetected:(ONVIFDevice *)device {
    NSLog(@"ONVIF: OnONVFDeviceDetected: device: %@", device.basicInfo.host);
    Url* url = [[Url alloc] initWithParam:device.basicInfo.host url:@"" image:nil];
    [url setType:URL_TYPE_ONVIF];
    [url setUserDefined:(__bridge void *)(device)];
    [_onvifMovies addObject:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    return 0;
}

- (int)OnONVFDeviceInfo:(ONVIFDevice *)device {
    NSLog(@"ONVIF: OnONVFDeviceInfo: device: stream_urls count: %lu", (unsigned long)device.profiles.count);
//    for (int i = 0; i < device.profiles.count; i++) {
//        ONVIFDeviceProfile* item = [device.profiles objectAtIndex:i];
//        NSArray * arr = [item.stream_url componentsSeparatedByString:@"://"];
//        NSString* url = [NSString stringWithFormat:@"%@://%@:%@@%@", [arr objectAtIndex:0], device.username, device.password, [arr objectAtIndex:1]];
//        [_onvifMovies addObject:[[Url alloc] initWithParam:@"" url:url image:nil]];
//    }
//
//    if (device.profiles.count > 0) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    }
    return 0;
}

- (int)OnONVFDeviceInfoAuthenticationRequire:(ONVIFDevice *)device {
    NSLog(@"ONVIF: OnONVFDeviceInfoAuthenticationRequire: device: %@", device.basicInfo.host);
//    if ([device.basicInfo.host isEqual: @"192.168.1.137"]) {
//        device.username = @"admin";
//        device.password = @"q1w2e3r4t5";
//    } else if ([device.basicInfo.host isEqual: @"192.168.1.113"]) {
//        device.username = @"root";
//        device.password = @"q1w2e3r4t5";
//    } else if ([device.basicInfo.host isEqual: @"192.168.1.55"]) {
//        device.username = @"root";
//        device.password = @"q1w2e3r4t5";
//    } else {
//        device.username = @"admin";
//        device.password = @"Pwd_1234";
//    }
    
    return 0;
}

- (void) reloadONVIFCameras {
    [_onvifMovies removeAllObjects];
    [onvifManager close];
    [onvifManager open:self];
    [onvifManager start];
}

- (void) reloadMovies
{
    [_localMovies removeAllObjects];
    NSMutableArray *ma = _localMovies;
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSString *folder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *contents = [fm contentsOfDirectoryAtPath:folder error:nil];
    
    for (NSString *filename in contents) {
        
        if (filename.length > 0 &&
            [filename characterAtIndex:0] != '.') {
            
            NSString *path = [folder stringByAppendingPathComponent:filename];
            NSDictionary *attr = [fm attributesOfItemAtPath:path error:nil];
            if (attr) {
                id fileType = [attr valueForKey:NSFileType];
                if ([fileType isEqual: NSFileTypeRegular]) {
                    
                    NSString *ext = path.pathExtension.lowercaseString;
                    
                    if (([ext isEqualToString:@"mp3"] ||
                        [ext isEqualToString:@"caff"]||
                        [ext isEqualToString:@"aiff"]||
                        [ext isEqualToString:@"ogg"] ||
                        [ext isEqualToString:@"wma"] ||
                        [ext isEqualToString:@"m4a"] ||
                        [ext isEqualToString:@"m4v"] ||
                        [ext isEqualToString:@"wmv"] ||
                        [ext isEqualToString:@"3gp"] ||
                        [ext isEqualToString:@"mp4"] ||
                        [ext isEqualToString:@"mpd"] ||
                        [ext isEqualToString:@"m3u8"] ||
                        [ext isEqualToString:@"m3u"] ||
                        [ext isEqualToString:@"mov"] ||
                        [ext isEqualToString:@"ts"] ||
                        [ext isEqualToString:@"avi"] ||
                        [ext isEqualToString:@"mkv"] ||
                        [ext isEqualToString:@"mpeg"]||
                        [ext isEqualToString:@"mpg"] ||
                        [ext isEqualToString:@"flv"] ||
                        [ext isEqualToString:@"vob"]) &&
                        ([[path lastPathComponent] caseInsensitiveCompare:@"mic_record_temp.m4a"] != NSOrderedSame)){
                        
//                        [ma addObject:path];
                        [ma addObject:[[Url alloc] initWithParam:@"" url:path image:nil]];
                        
                        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
                        
                        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
                        LoggerStream(1, @"Local: url %@", [NSURL fileURLWithPath:path]);
                        LoggerStream(1, @"Local: size %@", fileSizeNumber);
                        
                    }
                }
            }
        }
    }

    // Add all the movies present in the app bundle.
//    NSBundle *bundle = [NSBundle mainBundle];
//    [ma addObjectsFromArray:[bundle pathsForResourcesOfType:@"mp4" inDirectory:@"SampleMovies"]];
//    [ma addObjectsFromArray:[bundle pathsForResourcesOfType:@"m4a" inDirectory:@"SampleMovies"]];
//    [ma addObjectsFromArray:[bundle pathsForResourcesOfType:@"mov" inDirectory:@"SampleMovies"]];
//    [ma addObjectsFromArray:[bundle pathsForResourcesOfType:@"m4v" inDirectory:@"SampleMovies"]];
//    [ma addObjectsFromArray:[bundle pathsForResourcesOfType:@"wav" inDirectory:@"SampleMovies"]];
//
//    [ma sortedArrayUsingSelector:@selector(compare:)];
    
    //_localMovies = [ma copy];
    
    [self updateAssetsLibrary];
    
}

int exists(const char *fname)
{
    FILE *file;
    if ((file = fopen(fname, "r")) != NULL)
    {
        fclose(file);
        return 1;
    }
    return 0;
}

-(NSString*) writeVideoFileIntoTemp:(NSString*)fileName andAsset:(ALAsset*)asset
{
    NSString * tmpfile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
    if (exists([tmpfile cStringUsingEncoding:1]))
        return tmpfile;
    
    return tmpfile;
}

- (void)updateAssetsLibrary
{
    if (assetsLibrary == nil)
    {
        assetsLibrary = [[ALAssetsLibrary alloc] init];
//        ALAssetsLibrary *notificationSender = nil;
//        NSString *minimumSystemVersion = @"4.1";
//        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
//        if ([systemVersion compare:minimumSystemVersion options:NSNumericSearch] != NSOrderedAscending)
//            notificationSender = assetsLibrary;
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsLibraryDidChange:) name:ALAssetsLibraryChangedNotification
//             object:notificationSender];
    }
    
    count_local_files = 0;
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if (group)
         {
             [group setAssetsFilter:[ALAssetsFilter allVideos]];
             [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
              {
                  if (asset/* && count_local_files <= 3*/)
                  {
                      ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
                      NSString *moviePath1 = [[defaultRepresentation url] absoluteString];
                      NSString *fileName = [defaultRepresentation filename];
                      NSString * fileNameWithDot = [NSString stringWithFormat:@"%@%@", @".", fileName];
                      
                      
                      self->count_local_files++;
                      NSLog(@"Video:%@ - %@",fileNameWithDot, moviePath1);
                      
                      NSString * tmpfile = [self writeVideoFileIntoTemp:fileName andAsset:asset];
                      NSLog(@"Saved video:%@ ", tmpfile);
                      
                      Url* cur = [[Url alloc] initWithParam:@"" url:tmpfile image:nil];
                      if (![self->_localMovies containsObject:cur]) {
                          [self->_localMovies addObject:cur];
                      }
                      
                      [self->_localMovies sortUsingComparator:^NSComparisonResult(Url *s1, Url *s2) {
                          return [[s1 getUrl] caseInsensitiveCompare:[s2 getUrl]];
                      }];
                  }
              } ];
         }
         // group == nil signals we are done iterating.
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 //[self updateBrowserItemsAndSignalDelegate:assetItems];
                 //                loadImgView.hidden = NO;
                 //                [spinner stopAnimating];
                 //                [loadImgView removeFromSuperview];
                 //selectVideoBtn .userInteractionEnabled = YES;
                 NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
                 for (NSString *file in tmpDirectory)
                 {
                     NSString * fileName = [NSString stringWithFormat:@"%@/%@", [NSTemporaryDirectory() stringByAppendingPathComponent:@""], file];
                     NSLog(@"Local file: %@", fileName);
                     
                     Url* cur = [[Url alloc] initWithParam:@"" url:fileName image:nil];
                     if (![self->_localMovies containsObject:cur])
                     {
                         [self->_localMovies addObject:cur];

                         [self->_localMovies sortUsingComparator:^NSComparisonResult(Url *s1, Url *s2) {
                             return [[s1 getUrl] caseInsensitiveCompare:[s2 getUrl]];
                         }];
                     }
                 }

                 //NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
                 //[_localMovies addObject:path];

                 [self.tableView reloadData];
                 
                 [self reloadONVIFCameras];
             });
         }
     }
     failureBlock:^(NSError *error)
     {
         NSLog(@"error enumerating AssetLibrary groups %@\n", error);
     }];
}

- (void)checkIsLocalAndCopyToOwnTemp: (NSString*)path
{
    if (path == nil || [path length] <= 0)
        return;
    
    if (assetsLibrary == nil)
    {
        assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    assetSaved = NULL;
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if (group)
         {
             [group setAssetsFilter:[ALAssetsFilter allVideos]];
             [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
              {
                  if (asset/* && count_local_files <= 3*/)
                  {
                      ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
                      NSString *moviePath1 = [[defaultRepresentation url] absoluteString];
                      NSString *fileName = [defaultRepresentation filename];
                      NSString *fileNameWithDot = [NSString stringWithFormat:@"%@%@", @".", fileName];
                      
                      NSLog(@"Video:%@ - %@",fileNameWithDot, moviePath1);
                      
                      NSString * tmpfile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
                      NSLog(@"Video path:%@ - %@, %d, %d",tmpfile, path, [tmpfile isEqualToString: path], exists([tmpfile cStringUsingEncoding:1]));
                      if (![tmpfile isEqualToString: path] || exists([tmpfile cStringUsingEncoding:1]))
                          return;
                      
                      assetSaved = asset;
                  }
              }];
         }
         // group == nil signals we are done iterating.
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (assetSaved == NULL)
                     return;
                 
                 UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"For play video, we need copy movie to app temp directory!\nDo you agree?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
                 
                 alert.tag = 7890;
                 [alert show];
             });
         }
     }
     failureBlock:^(NSError *error)
     {
         NSLog(@"error enumerating AssetLibrary groups %@\n", error);
     }];
}

-(NSString*) writeVideoFileIntoTempWithCopyContent:(NSString*)fileName andAsset:(ALAsset*)asset
{
    NSString * tmpfile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
    if (exists([tmpfile cStringUsingEncoding:1]))
        return tmpfile;
    
    
    ALAssetRepresentation * rep = [asset defaultRepresentation];
    
    NSUInteger size = [rep size];
    const int bufferSize = 1024*1024; // or use 8192 size as read from other posts
    
    NSLog(@"Writing to %@",tmpfile);
    FILE* f = fopen([tmpfile cStringUsingEncoding:1], "wb+");
    if (f == NULL) {
        NSLog(@"Can not create tmp file.");
        return NULL;
    }
    
    Byte * buffer = (Byte*)malloc(bufferSize);
    int read = 0, offset = 0, written = 0;
    NSError* err;
    if (size != 0) {
        do {
            read = [rep getBytes:buffer
                      fromOffset:offset
                          length:bufferSize
                           error:&err];
            fwrite(buffer, sizeof(char), read, f);
            offset += read;
        } while (read != 0);
        
        
    }
    free(buffer);
    fclose(f);
    return tmpfile;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:     return @"Remote";
        case 1:     return @"ONVIF";
        case 2:     return @"Local";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _remoteMovies.count;
        case 1:
            return _onvifMovies.count;
        case 2:
            return _localMovies.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Url* url = NULL;
    
    NSString* path = NULL;
    UIImage* image = NULL;
    
    if (indexPath.section == 0 && indexPath.row < _remoteMovies.count) {

        url = [_remoteMovies objectAtIndex:indexPath.row];
        path = [url getUrl];
        cell.textLabel.text = path;//.lastPathComponent;
        
    } else if (indexPath.section == 1 && indexPath.row < _onvifMovies.count) {
        
        url = [_onvifMovies objectAtIndex:indexPath.row];
        path = [url getName];
        cell.textLabel.text = path;
        
    } else if (indexPath.section == 2 && indexPath.row < _localMovies.count) {
        
        url = [_localMovies objectAtIndex:indexPath.row];
        path = [url getUrl];
        cell.textLabel.text = path.lastPathComponent;
    }

    image = [url getImage];
    
    CGSize size = CGSizeMake(320, 240);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [[UIColor whiteColor] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    if (image == nil)
    {
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    }
    else
    {
        cell.imageView.image = image;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil)
    {
        return cell;
    }
    
    // Fetch using GCD
    dispatch_queue_t downloadThumbnailQueue = dispatch_queue_create("Get Url Thumbnails", NULL);
    dispatch_async(downloadThumbnailQueue, ^{
        
        //return;
        
        Thumbnailer* thumb = [[Thumbnailer alloc] init];
        ThumbnailerConfig* confThumb = [[ThumbnailerConfig alloc] init];
        confThumb.connectionUrl = path;
        confThumb.outWidth = 320;
        confThumb.outHeight = 240;
        
        NSCondition* waitOpen = [thumb Open:confThumb];
        [waitOpen lock];
        [waitOpen wait];
        LoggerStream(1, @"Tumbnailer wait finished.");
        [waitOpen unlock];
        
        if ([thumb getState] != ThumbnailerOpened)
        {
            LoggerStream(1, @"failed open thumbnailer %d", 0);
            return;
        }
        
        int32_t width = 0;
        int32_t height = 0;
        int32_t bytes_per_row = 0;
        
        int buffer_size = confThumb.outWidth * confThumb.outHeight * 4;
        uint8_t* buffer = malloc(buffer_size);
        
        int rc = [thumb getFrame:buffer buffer_size:buffer_size width:&width height:&height bytes_per_row:&bytes_per_row];
        LoggerStream(1, @"Thumbnailer getFrame: rc: %d, width: %d, height: %d bytes_per_row: %d", rc, width, height, bytes_per_row);
        [thumb Close];

        if (rc <= 0)
        {
            LoggerStream(1, @"failed get thumbnailer %d", rc);
            free(buffer);
            return;
        }
        
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        // Create a bitmap graphics context with the sample buffer data.
        CGContextRef context= CGBitmapContextCreate(buffer, width, height, 8, bytes_per_row, colorSpace,  kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        
        // Create a Quartz image from the pixel data in the bitmap graphics context
        CGImageRef quartzImage = CGBitmapContextCreateImage(context);
        UIImage* myImage = [[UIImage alloc] initWithCGImage:quartzImage];
        
        // Free up the context and color space
        CFRelease(quartzImage);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        free(buffer);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UITableViewCell *cellToUpdate = [self.tableView cellForRowAtIndexPath:indexPath]; // create a copy of the cell to avoid keeping a strong pointer to "cell" since that one may have been reused by the time the block is ready to update it.
            if (cellToUpdate != nil)
            {
                Url* url = NULL;
                if (indexPath.section == 0) {
                    url = [self->_remoteMovies objectAtIndex:indexPath.row];
                } else if (indexPath.section == 1) {
                    url = [self->_onvifMovies objectAtIndex:indexPath.row];
                } else if (indexPath.section == 2) {
                    url = [self->_localMovies objectAtIndex:indexPath.row];
                }
                
                [url setImage:myImage];
                [cellToUpdate.imageView setImage:myImage];
                [cellToUpdate setNeedsLayout];
            }
        });
    });

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Url* url = NULL;
    if (indexPath.section == 0) {
        if (indexPath.row >= _remoteMovies.count) return;
        _current_url = [_remoteMovies objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        if (indexPath.row >= _onvifMovies.count) return;
        _current_url = [_onvifMovies objectAtIndex:indexPath.row];
        NSString* username = @"admin";
        NSString* password = @"q1w2e3r4t5";
        if ([[_current_url getName] isEqual: @"192.168.1.137"]) {
            username = @"admin";
            password = @"q1w2e3r4t5";
        } else if ([[_current_url getName] isEqual: @"192.168.1.113"]) {
            username = @"root";
            password = @"q1w2e3r4t5";
        } else if ([[_current_url getName] isEqual: @"192.168.1.55"]) {
            username = @"root";
            password = @"q1w2e3r4t5";
        }

        [Utils enterLoginAndPassword:self
                           withTitle:@"Camera Access"
                         withMessage:@"Please enter login and password for get info from camera:"
                           withLogin:username
                        withPassword:password
                      withCompletion:^(NSString * _Nonnull login, NSString * _Nonnull password) {
            LoggerStream(1, @"Login: %@, and password: %@", login, password);
            ONVIFDevice* device = [self->_current_url getUserDefined];
            device.username = login;
            device.password = password;
            [self->onvifManager getInfo:device withCompletion:^(ONVIFDevice *device) {
                NSMutableArray<NSString*>* urls = [[NSMutableArray alloc] init];
                for (int i = 0; i < device.profiles.count; i++) {
                    ONVIFDeviceProfile* item = [device.profiles objectAtIndex:i];
                    NSArray * arr = [item.stream_url componentsSeparatedByString:@"://"];
                    NSString* url = [NSString stringWithFormat:@"%@://%@:%@@%@", [arr objectAtIndex:0], device.username, device.password, [arr objectAtIndex:1]];
                    [urls addObject:url];
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils selectFrom:self withTitle:@"Select stream" withMessage:@"Please select stream url:" withArray:urls withCompletion:^(NSString * _Nonnull value) {
                        [self->_current_url setUrl:value];
                        [self startSelectionProcess];
                    }];
                });
            }];
        }];
        return;
    } else if (indexPath.section == 2) {
        if (indexPath.row >= _localMovies.count) return;
        _current_url = [_localMovies objectAtIndex:indexPath.row];
        [self checkIsLocalAndCopyToOwnTemp:[_current_url getUrl]];
    }

    [self startSelectionProcess];
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    return  MAX_PLAYERS_COUNT;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld", (long)(row + 1)];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    countPlayers = row + 1;
}


- (void)video:(NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSLog(@"didFinishSavingWithError: %@", error);
    [alertCopyToPhotos dismissWithClickedButtonIndex:-1 animated:YES];
    alertCopyToPhotos = nil;
//    if(error)
//        NSLog(@"didFinishSavingWithError: %@", error);
}
              
- (void)startSelectionProcess {
    countPlayers = 1;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Select the number of players"
                                                   message: nil
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Select", @"Copy To Photos", @"Play with AVPlay", nil];

    alert.alertViewStyle = UIAlertViewStyleDefault;

    //countryCodePickedView
    UIPickerView *countryCodePickedView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    [countryCodePickedView setDataSource: self];
    [countryCodePickedView setDelegate: self];
    countryCodePickedView.showsSelectionIndicator = YES;

    [alert setValue:countryCodePickedView forKey:@"accessoryView"];
    alert.tag = 111;
    [alert show];

    LoggerApp(1, @"Playing a movie: %@", _current_url);
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3456 && buttonIndex == 1)
    {
        UITextField *newUrl = [alertView textFieldAtIndex:0];
        NSLog(@"new url: %@", newUrl.text);
        if (newUrl.text == nil || [newUrl.text length] <= 0)
            return;
        
        _last_entered_url = newUrl.text;
        [_remoteMovies addObject:[[Url alloc] initWithParam:@"" url:newUrl.text image:nil]];
        
//        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }

    if (alertView.tag == 111 && buttonIndex == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Select Graphichs Layer"
                                                       message: nil
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles: nil];
        
        [alert addButtonWithTitle:[NSString stringWithFormat:@"Open GL"]];
        [alert addButtonWithTitle:[NSString stringWithFormat:@"Metal"]];
        
        alert.tag = 7834;
        [alert show];
    }

    if (alertView.tag == 111 && buttonIndex == 2)
    {
        alertCopyToPhotos = [[UIAlertView alloc] initWithTitle:@"" message:@"Movie copying to photos, wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alertCopyToPhotos show];
        
        //        NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        //        LoggerStream(1, @"Copy dir doc : %@", documentDirectory);
        LoggerStream(1, @"Copy dir path: %@", [_current_url getUrl]);
        
        //        NSString *videoFile = [documentDirectory stringByAppendingPathComponent:@"video.mp4"];
        UISaveVideoAtPathToSavedPhotosAlbum([_current_url getUrl], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }

    if (alertView.tag == 111 && buttonIndex == 3)
    {
        //NSURL *videoURL = [NSURL URLWithString:@"https://dl.getdropbox.com/s/yxguhjdrtrz1msl/933b6f26-33f7-49cd-bf51-2463edac2279.m3u8"];
        NSString* url = [_current_url getUrl];
        NSURL *videoURL = [NSURL URLWithString:url];
        if ([url localizedCaseInsensitiveContainsString:@"/private/var/mobile/Containers/Data/Application/"]) {
            videoURL = [NSURL URLWithString:[@"file://" stringByAppendingString:url]];
        }
        LoggerStream(1, @"URL: %@", videoURL);

        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:^{
          [playerViewController.player play];
        }];
    }

    if (alertView.tag == 7834 && buttonIndex != 0)
    {
        LoggerStream(1, @"Graphic layer: %ld", (long)buttonIndex);
        graphic_layer = (buttonIndex-1);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Select decoder type"
                                                       message: nil
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles: nil];
        
        [alert addButtonWithTitle:[NSString stringWithFormat:@"Software"]];
        [alert addButtonWithTitle:[NSString stringWithFormat:@"Hardware"]];
        
        alert.tag = 888;
        [alert show];
    }
    
    if (alertView.tag == 888 && buttonIndex != 0)
    {
        LoggerStream(1, @"Stream selected: %d", buttonIndex);
        if (vc != nil)
        {
            //[vc Close];
            vc = nil;
        }
        [onvifManager close];
        vc = [MovieViewController movieViewControllerWithContentPath:_current_url
                                                               layer:graphic_layer
                                                                  hw:(buttonIndex-1)
                                                      countInstances:countPlayers];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
        LoggerStream(1, @"Stream opened: %d", buttonIndex);
    }
    
    if (alertView.tag == 7890 && buttonIndex != 0)
    {
        UIAlertView *alertCopyFile = [[UIAlertView alloc] initWithTitle:@"" message:@"Movie copying, wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alertCopyFile show];
        
        dispatch_queue_t copyQueue = dispatch_queue_create("Copy file", NULL);
        dispatch_async(copyQueue, ^{
            
            ALAssetRepresentation *defaultRepresentation = [assetSaved defaultRepresentation];
            NSString *moviePath1 = [[defaultRepresentation url] absoluteString];
            NSString *fileName = [defaultRepresentation filename];
            NSString *fileNameWithDot = [NSString stringWithFormat:@"%@%@", @".", fileName];
            
            NSLog(@"Video:%@ - %@",fileNameWithDot, moviePath1);
            
            NSString * tmpfile = [self writeVideoFileIntoTempWithCopyContent:fileName andAsset:assetSaved];
            NSLog(@"Saved video:%@ ", tmpfile);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertCopyFile dismissWithClickedButtonIndex:0 animated:YES];
            });
        });
        
    }
}

@end
