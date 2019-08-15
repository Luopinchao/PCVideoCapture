
//  Created by mac on 2019/8/12.
//  Copyright © 2019 luopinchao. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "PCAVPlayerView.h"
#import "PCStaticValue.h"

@interface VideoPlayerViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView      *topView;
@property (nonatomic, strong) UIButton      *doneButton;
@property (nonatomic, strong) UIButton      *completeButton;
@property (nonatomic, strong) PCAVPlayerView *playerView;

@end

@implementation VideoPlayerViewController

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Bottom_Height)];
        _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [self.doneButton setTitle:@"退出" forState:UIControlStateNormal];
        [self.doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:self.doneButton];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitle:@"完成" forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        btn.backgroundColor = RGBA(60, 182, 80, 1);
        [_topView addSubview:btn];
        self.completeButton = btn;
        [self.view addSubview:_topView];
    }
    return _topView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    self.topView.frame = CGRectMake(0, 0, ScreenWidth, Bottom_Height);
    self.completeButton.frame = CGRectMake(ScreenWidth - 80, Bottom_Height - 40, 60, 32);
    self.doneButton.frame = CGRectMake(20, Bottom_Height - 40, 50, 32);
    if (self.image != NULL) {
        UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollview.delegate = self;
        scrollview.minimumZoomScale = kMinZoom;
        scrollview.maximumZoomScale = kMaxZoom;
        self.imageView = [[UIImageView alloc] initWithFrame:scrollview.bounds];
        self.imageView.clipsToBounds = YES;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.image = self.image;
        [scrollview addSubview:self.imageView];
        [self.view addSubview:scrollview];
    } else {
        self.playerView = [[PCAVPlayerView alloc]init];
        self.playerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.playerView.playerUrl = [[NSBundle mainBundle] URLForAuxiliaryExecutable:[NSString stringWithFormat:@"%@",self.videoUrl]];
        [self.view addSubview:self.playerView];
        [self.playerView play];
    }
    
    [self.view bringSubviewToFront:self.topView];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGFloat zs = scrollView.zoomScale;
    zs = MAX(zs, 1.0);
    zs = MIN(zs, 3.0);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    scrollView.zoomScale = zs;
    [UIView commitAnimations];
}

- (void)doneAction
{
    [self.playerView removePlayerViews];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)completeAction
{
    [self.playerView removePlayerViews];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"completeAction" object:nil];
    }];
}

@end
