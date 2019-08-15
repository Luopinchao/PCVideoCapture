//
//  PCReleaseContentModel.h
//  XiangYin
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 luopinchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCReleaseContentModel : NSObject

/*
   类似微信发布页面  数据管理
 */
@property (nonatomic,strong)NSLock *arrayLock;

//发布文字
@property (nonatomic,strong)NSString *contentText;

//默认文字
@property (nonatomic,strong)NSString *defultContentText;
@property (nonatomic,assign)CGFloat contentTextHeight;

// isPhotoOrVideo  0是图片  1是拍摄视频  2是本地视频
@property (nonatomic,assign)int isPhotoOrVideo;

@property (nonatomic,assign)CGFloat rowHeight;

@property (nonatomic,assign)NSInteger dataCount;

//发布定位信息
@property (nonatomic,strong)NSString *locationText; //定位的字符串
@property (nonatomic,strong)NSString *locationGat; //经度
@property (nonatomic,strong)NSString *locationLet; //纬度

//默认➕图片
@property (nonatomic,strong)UIImage *addImage;

//发布图片集合
@property (nonatomic,strong,readonly)NSMutableArray *imageArray;

//发布视频  本地路径
@property (nonatomic,copy)NSString *videoURL;
//第一帧
@property (nonatomic,strong)UIImage *videoFristImage;

//发布提示语
@property (nonatomic,strong)NSString *tipsString;

@property (nonatomic,assign)CGFloat photoHeight;

//计算cell高度
- (CGFloat)cellForHeightIndex:(NSInteger)index;

//最多可显示9张照片  累加
- (void)addImageWithImageArray:(NSArray<UIImage *> *)imageArrays;

@end

NS_ASSUME_NONNULL_END
