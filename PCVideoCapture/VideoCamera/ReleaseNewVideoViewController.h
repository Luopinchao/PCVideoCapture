
//  Created by mac on 2019/8/12.
//  Copyright © 2019 luuopinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCReleaseContentModel.h"
NS_ASSUME_NONNULL_BEGIN

//是否录制过视频和照片  刷新外面页面
typedef void (^BlockMediaStute)(BOOL state);
@interface ReleaseNewVideoViewController : UIViewController
@property (nonatomic, copy) BlockMediaStute blockMediaStute;
@property (nonatomic, strong)PCReleaseContentModel *model;
@end

NS_ASSUME_NONNULL_END
