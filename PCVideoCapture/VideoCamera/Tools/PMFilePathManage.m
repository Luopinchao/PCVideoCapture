//
//  PMFilePathManage.m
//  AVFoundationTest
//
//  Created by luo_san on 2019/4/23.
//  Copyright © 2019年 luo_san. All rights reserved.
//

#import "PMFilePathManage.h"

@implementation PMFilePathManage

//获取MP4格式视频路径
+ (NSURL *)getVideoFilePathWithMP4
{
    NSString *path = [((NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)).firstObject) stringByAppendingPathComponent:@"/movie"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    long long timeDate = (long long)(([[NSDate date] timeIntervalSince1970]) * 1000);
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.mp4",timeDate]];
    return  [NSURL fileURLWithPath:filePath];
}

//获取视频列表
+ (NSString *)getAllMetaFilePathList;
{
    NSString *path = [((NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)).firstObject) stringByAppendingPathComponent:@"/movie"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        NSString *tempPath = [path stringByAppendingPathComponent:fileList.firstObject];
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath isDirectory:nil]) {
            NSLog(@"视频路径----%@",tempPath);
        }
        return tempPath;
    }
    return nil;
}

@end
