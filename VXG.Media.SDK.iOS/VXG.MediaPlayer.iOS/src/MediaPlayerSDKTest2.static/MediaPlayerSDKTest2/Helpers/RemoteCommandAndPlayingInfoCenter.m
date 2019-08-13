//
//  RemoteCommandAndPlayingInfoCenter.m
//  MediaPlayerSDKTest2
//
//  Created by Max Koutsanov on 6/21/19.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "RemoteCommandAndPlayingInfoCenter.h"

@interface RemoteCommandAndPlayingInfoCenter() {
    Url* _url;
    id<RemoteCommandAndPlayingInfoCenterDelegate> _delegate;
    
}
@end

@implementation RemoteCommandAndPlayingInfoCenter

-(id)initWithParams:(Url*)url {
    self = [super init];
    if (self) {
        _url = url;
        _delegate = nil;
    }
   
    return self;
}

-(id)initWithParams:(Url*)url andDelegate:(id<RemoteCommandAndPlayingInfoCenterDelegate>)delegate {
    self = [super init];
    if (self) {
        _url = url;
        _delegate = delegate;
    }
    
    return self;

}

- (void) dealloc {
}

-(void)setDelegate:(id<RemoteCommandAndPlayingInfoCenterDelegate>)delegate {
    _delegate = delegate;
}

-(id<RemoteCommandAndPlayingInfoCenterDelegate>) getDelegate {
    return _delegate;
}

-(void) open {
    if (_url == nil) {
        return;
    }

    MPNowPlayingInfoCenter *np = [MPNowPlayingInfoCenter defaultCenter];
    
    NSString* trackName = [_url getName];
    if (trackName.length <= 0) {
        trackName = @"No Name";
    }
    
    np.nowPlayingInfo = @{
                          MPMediaItemPropertyTitle:[_url getName],
                          MPMediaItemPropertyArtist:[_url getUrl]
                          };
    
    if (@available(iOS 10, *)) {
        if ([_url getImage] != nil) {
            MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithBoundsSize:[_url getImage].size
                                                                           requestHandler:^UIImage* _Nonnull(CGSize aSize) {
                                                                               return [self->_url getImage];
                                                                           }];
            NSMutableDictionary *nowPlayingInfo = [np.nowPlayingInfo mutableCopy];
            [nowPlayingInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
            np.nowPlayingInfo = nowPlayingInfo;
        }
    }
    
    MPRemoteCommandCenter* commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    [commandCenter.playCommand addTarget:self action:@selector(playTrack:)];
    [commandCenter.pauseCommand addTarget:self action:@selector(pauseTrack:)];
    [commandCenter.playCommand setEnabled:YES];
    [commandCenter.pauseCommand setEnabled:YES];
    
    // change position
    [commandCenter.changePlaybackPositionCommand addTarget:self action:@selector(onChangePlaybackPositionCommand:)];
    [commandCenter.changePlaybackPositionCommand setEnabled:YES];
}

-(void) close {
    MPRemoteCommandCenter* commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.playCommand removeTarget:self];
    [commandCenter.pauseCommand removeTarget:self];
    [commandCenter.changePlaybackPositionCommand removeTarget:self];
}

-(void)updatePlaybackPosition:(CGFloat)position
                 withDuration:(CGFloat)duration
                      andrate:(CGFloat)rate {
    MPNowPlayingInfoCenter *np = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *nowPlayingInfo = [np.nowPlayingInfo mutableCopy];
    [nowPlayingInfo setObject:@(position) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [nowPlayingInfo setObject:@(duration) forKey:MPMediaItemPropertyPlaybackDuration];
    [nowPlayingInfo setObject:@(rate) forKey:MPNowPlayingInfoPropertyPlaybackRate];
    np.nowPlayingInfo = nowPlayingInfo;
}

- (MPRemoteCommandHandlerStatus) onChangePlaybackPositionCommand:(MPChangePlaybackPositionCommandEvent *) event {
    NSLog(@"changePlaybackPosition to %f", event.positionTime);
    if (_delegate != nil && [_delegate respondsToSelector:@selector(OnRemoteCommandChangePlaybackPosition:)]) {
        [_delegate OnRemoteCommandChangePlaybackPosition:event.positionTime];
    }
    
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus) playTrack:(MPRemoteCommandEvent *) event {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(OnRemoteCommandPlay)]) {
        [_delegate OnRemoteCommandPlay];
    }
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus) pauseTrack:(MPRemoteCommandEvent *) event {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(OnRemoteCommandPause)]) {
        [_delegate OnRemoteCommandPause];
    }
    return MPRemoteCommandHandlerStatusSuccess;
}

@end
