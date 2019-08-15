
//  Created by mac on 2019/7/30.
//  Copyright © 2019 luopinchao. All rights reserved.
//

#import "PCCameraButton.h"
#import "PCStaticValue.h"

@implementation PCCameraButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = frame.size.width*0.11;
        CAShapeLayer *circleBorder = [CAShapeLayer layer];
        circleBorder.frame = self.bounds;
        circleBorder.borderWidth = _lineWidth;
        circleBorder.borderColor = RGBA(180, 180, 180, .8).CGColor;
        circleBorder.cornerRadius = frame.size.width/2;
        [self.layer addSublayer:circleBorder];
        
        _centerLayer = [CAShapeLayer layer];
        _centerLayer.frame = CGRectMake(_lineWidth, _lineWidth, frame.size.width-(_lineWidth)*2, frame.size.height-(_lineWidth)*2);
        _centerLayer.cornerRadius = _centerLayer.frame.size.width / 2;
        _centerLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_centerLayer];
        
        _isSelect = NO;
        _animationLock = [[NSLock alloc] init];
        UITapGestureRecognizer *guest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraPhoto)];
        [self addGestureRecognizer:guest];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)cameraPhoto{
    [UIView animateWithDuration:.01 animations:^{
        _touchUpBlock();
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
    [UIView animateWithDuration:.02 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)setCilikStutesBlock:(StutesBlock)block
{
    _block = block;
}

- (void)setTouchUpBlock:(TouchUpBlock)block
{
    _touchUpBlock = block;
}

- (void)btnLong:(UILongPressGestureRecognizer *)guest
{
    if (guest.state == UIGestureRecognizerStateBegan) {
        CGFloat scale = 1.5;
        _block(YES);
        [self setLayerAnimations];
        [UIView animateWithDuration:.01 animations:^{
            self.transform = CGAffineTransformMakeScale(scale, scale);
        }];
    } else if (guest.state == UIGestureRecognizerStateEnded) {
        CGFloat scale = 1;
        _block(NO);
        [_animationLayer removeAnimationForKey:@"strokeEnd"];
        [_animationLayer removeFromSuperlayer];
        [UIView animateWithDuration:.15 animations:^{
            self.transform = CGAffineTransformMakeScale(scale, scale);
        }];
    }
}

- (void)setLayerAnimations
{
    _animationLayer = [CAShapeLayer layer];
    _animationLayer.fillColor = [UIColor clearColor].CGColor;
    _animationLayer.lineWidth =  4.0f;
    _animationLayer.lineCap = kCALineCapRound;
    _animationLayer.lineJoin = kCALineJoinRound;
    _animationLayer.strokeColor = RGBA(60, 182, 80, 1).CGColor;

    CGPoint point = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:38.0f startAngle:-(M_PI/2) endAngle:M_PI*2  clockwise:YES];
    _animationLayer.path = path.CGPath;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    _animationLayer.autoreverses = YES;
    animation.duration = VidoeMaxTime;
    // 设置layer的animation
    [_animationLayer addAnimation:animation forKey:nil];
    animation.delegate = self;
    [self.layer addSublayer:_animationLayer];
}



//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self startAnimations];
//}
//
//- (void)startAnimations
//{
//    [_animationLock lock];
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
//    CABasicAnimation *animationBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
//    animation.duration = animationBounds.duration = 0.2f;
//    animation.fromValue = @(_centerLayer.cornerRadius);
//    CGRect bounds = _centerLayer.bounds;
//    animationBounds.fromValue = [NSValue valueWithCGRect:bounds];
//    if(!_isSelect){
//        animation.toValue = @(5);
//        bounds.size.width = self.bounds.size.width*0.4;
//        bounds.size.height = self.bounds.size.height*0.4;
//        animationBounds.toValue = [NSValue valueWithCGRect:bounds];
//        _centerLayer.cornerRadius = 5.0f;
//        _centerLayer.bounds = bounds;
//    } else {
//        bounds.size.width = self.frame.size.width-(_lineWidth+2)*2;
//        bounds.size.height = self.frame.size.height-(_lineWidth+2)*2;
//        animationBounds.toValue = [NSValue valueWithCGRect:bounds];
//        animation.toValue = @(bounds.size.width/2);
//        _centerLayer.cornerRadius = bounds.size.width/2;
//        _centerLayer.bounds = bounds;
//    }
//    [_centerLayer addAnimation:animation forKey:@"cornerRadius"];
//    [_centerLayer addAnimation:animationBounds forKey:@"bounds"];
//
//    //c创建动画组
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    //设置执行时间
//    group.duration = 0.2f;
//    group.delegate = self;
//    group.removedOnCompletion = YES;
//    group.animations = @[animationBounds,animation];
//    [_centerLayer addAnimation:group forKey:@"group"];
//    _isSelect = !_isSelect;
//    _block(_isSelect);
//    [_animationLock unlock];
//}
//
#pragma mark  -- CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_animationLayer removeAllAnimations];
}

@end
