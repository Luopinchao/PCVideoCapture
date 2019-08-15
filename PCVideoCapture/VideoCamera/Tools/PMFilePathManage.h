//
//  PMFilePathManage.h
//  AVFoundationTest
//
//  Created by luo_san on 2019/4/23.
//  Copyright © 2019年 luo_san. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMFilePathManage : NSObject

//获取MP4格式视频路径
+ (NSURL *)getVideoFilePathWithMP4;

//获取最近一个视频
+ (NSString *)getAllMetaFilePathList;
@end

NS_ASSUME_NONNULL_END
