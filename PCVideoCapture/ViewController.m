//
//  ViewController.m
//  PCVideoCapture
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 luopinchao. All rights reserved.
//

#import "ViewController.h"
#import "ReleaseNewVideoViewController.h"
#import "PCReleaseContentModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark  入口调用    info.plist   导入以下权限字段
- (IBAction)touchRecording:(id)sender {
    /*
     <key>NSCameraUsageDescription</key>
     <string>此应用需要使用您的相机</string>
     <key>NSMicrophoneUsageDescription</key>
     <string>此应用需要您的麦克风权限</string>
     <key>NSPhotoLibraryAddUsageDescription</key>
     <string>此应用需要使用您的多媒体</string>
     <key>NSPhotoLibraryUsageDescription</key>
     <string>此应用需要使用您的相册</string>
     <key>UIRequiredDeviceCapabilities</key>
     */
    ReleaseNewVideoViewController *vc = [[ReleaseNewVideoViewController alloc] initWithNibName:@"ReleaseNewVideoViewController" bundle:nil];
    vc.model = [[PCReleaseContentModel alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}



@end
