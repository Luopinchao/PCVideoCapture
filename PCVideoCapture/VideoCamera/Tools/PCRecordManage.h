
//  Created by mac on 2017/7/21.
//  Copyright © 2019 luuopinchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PCStaticValue.h"

@protocol PCRecordManageDelegate <NSObject>

//照片回调
- (void)captureStillImageSuccess:(CMSampleBufferRef)samlpBuff;

//视频本地路径回调
- (void)captureStillVideoSuccess:(NSString *)path;

@end

@interface PCRecordManage : NSObject

@property (nonatomic, assign, readonly) BOOL isCapturing;//正在录制
@property (nonatomic, assign, readonly) BOOL isPaused;//是否暂停
@property (nonatomic, assign, readonly) CGFloat currentRecordTime;//当前录制时间
@property (nonatomic, assign) CGFloat maxRecordTime;//录制最长时间
@property (weak, nonatomic) id<PCRecordManageDelegate>delegate;
@property (nonatomic, strong) NSString *videoPath;//视频路径

//视频渲染layer
- (AVCaptureVideoPreviewLayer *)previewLayer;
//获取静态图片
- (void)starCameraStillImage;
//启动录制功能
- (void)startUp;
//关闭录制功能
- (void)shutdown;
//开始录制
- (void) startCapture;
//停止录制
- (void) stopCaptureHandler:(void (^)(UIImage *movieImage))handler;
//开启闪光灯
- (void)openFlashLight;
//关闭闪光灯
- (void)closeFlashLight;
//切换前后置摄像头
- (void)changeCameraInputDeviceisFront:(BOOL)isFront;
@end
