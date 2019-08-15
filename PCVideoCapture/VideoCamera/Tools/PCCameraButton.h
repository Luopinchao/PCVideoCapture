
//  Created by mac on 2019/7/30.
//  Copyright © 2019 luopinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^StutesBlock)(BOOL state);
typedef void (^TouchUpBlock)();
@interface PCCameraButton : UIButton<CAAnimationDelegate,UIGestureRecognizerDelegate>
{
    StutesBlock _block;
    TouchUpBlock _touchUpBlock;
    CGFloat _lineWidth;
    CAShapeLayer *_animationLayer;
    CAShapeLayer *_centerLayer;
    _Bool _isSelect;
    NSLock *_animationLock;
}
- (void)setCilikStutesBlock:(StutesBlock)block;
- (void)setTouchUpBlock:(TouchUpBlock)block;

@end

