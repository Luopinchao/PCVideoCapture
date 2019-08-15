
//  Created by mac on 2019/8/12.
//  Copyright © 2019 luuopinchao. All rights reserved.
//

#import "ReleaseNewVideoViewController.h"
#import "PCRecordManage.h"
#import "VideoPlayerViewController.h"
#import "PCCameraButton.h"
#import "PCStaticValue.h"
typedef enum _CuptureOutputType{
    CuptureOutputStillImage, //静态图片
    CuptureOutputlagerVideo,//小视频
}CuptureOutputType;

@interface ReleaseNewVideoViewController ()<PCRecordManageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UIImage *fristImage;
@property (nonatomic, assign) CuptureOutputType cuptureOutputType;
@property (weak, nonatomic) IBOutlet UILabel *tipsLable;
@property (weak, nonatomic) IBOutlet UIButton *flashLightBT;
@property (weak, nonatomic) IBOutlet UIButton *changeCameraBT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_Y;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tHeight;
@property (strong, nonatomic) PCCameraButton *recordBt;
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) PCRecordManage         *recordEngine;
@property (assign, nonatomic) BOOL                    allowRecord;//允许录制
@property (strong, nonatomic) VideoPlayerViewController *playerVC;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSLock *recordLock;
@end
@implementation ReleaseNewVideoViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMediaComplete) name:@"completeAction" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"completeAction" object:nil];
    [self.timer invalidate];
    _recordEngine = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.recordEngine shutdown];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_recordEngine == nil) {
        [self.recordEngine previewLayer].frame = self.view.bounds;
        [self.view.layer insertSublayer:[self.recordEngine previewLayer] atIndex:0];
    }
    [self.recordEngine startUp];
}

- (void)hiddentipsLable{
    self.tipsLable.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recordLock = [[NSLock alloc] init];
    [self performSelector:@selector(hiddentipsLable) withObject:NULL afterDelay:3.0];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:.33];
    self.bottomView.opaque = NO;
    self.topBgView.userInteractionEnabled = YES;
    self.topBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.33];
    self.topBgView.opaque = NO;
    self.allowRecord = YES;
    self.recordBt = [[PCCameraButton alloc] initWithFrame:CGRectMake((ScreenWidth - 76)/2.0, (CGRectGetHeight(self.bottomView.frame) - 76)/2.0, 76, 76)];
    self.tHeight.constant = 60.0f;
    if (iPhoneX) {
        self.tHeight.constant = 84.0f;
    }
    WEAKSELF
    [self.recordBt setCilikStutesBlock:^(BOOL state) {
        STRONGSELF
        //开始和暂停录制事件
        if (strongSelf.allowRecord) {
            strongSelf.recordBt.selected = !strongSelf.recordBt.selected;
            if (state) {
                [strongSelf.recordLock lock];
                [strongSelf setHiddenTopView:YES];
                [strongSelf _initTimer];
                [strongSelf.recordEngine startCapture];
            } else {
                [strongSelf.recordEngine shutdown];
                strongSelf.cuptureOutputType = CuptureOutputlagerVideo;
                [strongSelf setHiddenTopView:NO];
                [strongSelf.timer invalidate];
                [strongSelf.recordEngine stopCaptureHandler:^(UIImage *movieImage) {
                    strongSelf.fristImage = movieImage;
                    strongSelf.playerVC = [[VideoPlayerViewController alloc] init];
                    strongSelf.playerVC.videoUrl = [NSURL URLWithString:strongSelf.recordEngine.videoPath];
                    [strongSelf.recordLock unlock];
                    [strongSelf presentViewController:strongSelf.playerVC animated:YES completion:nil];
                }];
            }
        }
    }];
    [self.recordBt setTouchUpBlock:^{
        STRONGSELF
        [strongSelf.recordEngine starCameraStillImage];
    }];
    [self.bottomView addSubview:self.recordBt];
}



//照片回调
- (void)captureStillImageSuccess:(CMSampleBufferRef)samlpBuff
{
    self.cuptureOutputType = CuptureOutputStillImage;
    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:samlpBuff];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    WEAKSELF
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.fristImage = image;
                weakSelf.playerVC = [[VideoPlayerViewController alloc] init];
                weakSelf.playerVC.image =image;
                [weakSelf presentViewController:weakSelf.playerVC animated:YES completion:nil];
            });
        }
    }];
}

- (void)setHiddenTopView:(BOOL)hidden
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (hidden) {
            self.topView_Y.constant = - self.tHeight.constant;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }else {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            self.topView_Y.constant = 0;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}


- (void)_initTimer
{
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(updateTimeDisplay)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateTimeDisplay {
    NSUInteger time = self.recordEngine.currentRecordTime;
    //由于帧动画时间与录制时间不同步  暂时没做优化
    if (time-4 == VidoeMaxTime) {
        [self.recordEngine shutdown];
        self.cuptureOutputType = CuptureOutputlagerVideo;
        [self setHiddenTopView:NO];
        [self.timer invalidate];
        [self.recordEngine stopCaptureHandler:^(UIImage *movieImage) {
            self.fristImage = movieImage;
            self.playerVC = [[VideoPlayerViewController alloc] init];
            self.playerVC.videoUrl = [NSURL URLWithString:self.recordEngine.videoPath];
            [self.recordLock unlock];
            [self presentViewController:self.playerVC animated:YES completion:nil];
        }];

    }
}

#pragma mark - set、get方法
- (PCRecordManage *)recordEngine {
    if (_recordEngine == nil) {
        _recordEngine = [[PCRecordManage alloc] init];
        _recordEngine.delegate = self;
    }
    return _recordEngine;
}

- (void)selectMediaComplete
{
    if (CuptureOutputStillImage == self.cuptureOutputType) {
        self.model.isPhotoOrVideo = 0;
        [self.model addImageWithImageArray:@[self.fristImage]];
    } else if (CuptureOutputlagerVideo == self.cuptureOutputType) {
        self.model.isPhotoOrVideo = 2;
        self.model.videoFristImage = self.fristImage;
        self.model.videoURL = self.recordEngine.videoPath;
    }
    if (_blockMediaStute) {
        _blockMediaStute(YES);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 关闭
//返回点击事件
- (IBAction)dismissAction:(id)sender {
    if (_blockMediaStute) {
        _blockMediaStute(NO);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setBlockMediaStute:(BlockMediaStute)blockMediaStute
{
    _blockMediaStute = blockMediaStute;
}

//开关闪光灯
- (IBAction)flashLightAction:(id)sender {
    if (self.changeCameraBT.selected == NO) {
        self.flashLightBT.selected = !self.flashLightBT.selected;
        if (self.flashLightBT.selected == YES) {
            [self.recordEngine openFlashLight];
        }else {
            [self.recordEngine closeFlashLight];
        }
    }
}

//切换前后摄像头
- (IBAction)changeCameraAction:(id)sender {
    self.changeCameraBT.selected = !self.changeCameraBT.selected;
    if (self.changeCameraBT.selected == YES) {
        //前置摄像头
        [self.recordEngine closeFlashLight];
        self.flashLightBT.selected = NO;
        [self.recordEngine changeCameraInputDeviceisFront:YES];
    }else {
        [self.recordEngine changeCameraInputDeviceisFront:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
