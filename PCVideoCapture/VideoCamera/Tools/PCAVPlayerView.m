
//  Created by mac on 2019/7/30.
//  Copyright © 2019 luopinchao. All rights reserved.
//

#import "PCAVPlayerView.h"
#import "PCStaticValue.h"
@interface PCAVPlayerView()
@property (nonatomic, strong) AVPlayerLayer           *avPlayerLayer;
@property (nonatomic, strong) AVPlayer                *avPlayer;
@property (nonatomic, strong) AVPlayerItem            *playerItem;

@end

@implementation PCAVPlayerView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setVolum];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setVolum];
    }
    return self;
}


- (void)setVolum{
    self.clipsToBounds = YES;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionMixWithOthers
                   error:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)setPlayerUrl:(NSURL *)playerUrl{
    if (playerUrl) {
        _playerUrl = playerUrl;
        if (_avPlayer) {
            [_avPlayer pause];
            [_avPlayerLayer removeFromSuperlayer];
            [self.playerItem removeObserver:self forKeyPath:@"status"];
        }
        _playerItem = [[AVPlayerItem alloc]initWithURL:playerUrl];
        _avPlayer = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
        _avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
        _avPlayerLayer.backgroundColor = [UIColor blackColor].CGColor;
        [(AVPlayerLayer *)self.layer addSublayer:_avPlayerLayer];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听status属性
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    if (_avPlayerLayer) {
        _avPlayerLayer.frame = self.bounds;
    }
}

/** 播放 */
- (void)play{
    if (_avPlayer) {
        [_avPlayer play];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {}}}

#pragma notification
- (void)playerPlayToEnd:(NSNotification *)notification{
    NSLog(@"播放完成");
    [self.avPlayer seekToTime:kCMTimeZero];
    [self play];
}

- (void)removePlayerViews
{
    if (_avPlayer) {
        [_avPlayer pause];
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        self.playerItem = nil;
        self.avPlayerLayer = nil;
        self.avPlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
@end
