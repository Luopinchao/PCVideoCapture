
//  Created by mac on 2017/7/21.
//  Copyright © 2019 luuopinchao. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "PCStaticValue.h"

@interface PCRecordEncoder : NSObject

@property (nonatomic, readonly) NSString *path;
/**
 *  @param path 媒体存发路径
 *  @param cy   视频分辨率的高
 *  @param cx   视频分辨率的宽
 *  @param ch   音频通道
 *  @param rate 音频的采样比率
 */
+ (PCRecordEncoder*)encoderForPath:(NSString*)path Height:(NSInteger)cy width:(NSInteger)cx channels: (int)ch samples:(Float64)rate;

- (void)finishWithCompletionHandler:(void (^)(void))handler;

/**
 *  通过这个方法写入数据
 */
- (BOOL)encodeFrame:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)isVideo;

@end
