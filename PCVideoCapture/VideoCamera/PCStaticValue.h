//
//  PCStaticValue.h
//  PCVideoCapture
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 luopinchao. All rights reserved.
//

#ifndef PCStaticValue_h
#define PCStaticValue_h
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ScreenHeight  MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)
#define ScreenWidth   MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)
#define iPhoneX (((int)((ScreenHeight/ScreenWidth)*100) == 216) ? YES:NO)

static CGFloat const kMaxZoom = 3.0f;
static CGFloat const kMinZoom = 1.0f;
static CGFloat const getPhotoHeight = 96.0f;

#define Bottom_Height (iPhoneX ? 88 : 64)
//视频的最大时间
static CGFloat const VidoeMaxTime = 30;
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#endif /* PCStaticValue_h */
