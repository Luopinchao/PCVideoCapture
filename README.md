# PCVideoCapture
小视频拍摄，Video，自定义相机。

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
    [self presentViewController：vc animated：YES completion：nil];

