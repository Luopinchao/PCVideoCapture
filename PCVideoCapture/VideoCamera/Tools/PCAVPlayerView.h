
//  Created by mac on 2019/7/30.
//  Copyright © 2019 luopinchao. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface PCAVPlayerView : UIView

@property (nonatomic, strong) NSURL *playerUrl;/**< 播放链接 */
/** play */
- (void)play;
- (void)removePlayerViews;
@end
