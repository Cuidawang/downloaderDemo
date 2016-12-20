//
//  XHCDownloader.h
//  XHCSort
//
//  Created by Cuikeyi on 2016/12/19.
//  Copyright © 2016年 xiaohongchun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^XHCProgressHandler)(double progress);

@interface XHCDownloader : NSObject

/**
 下载文件的url
 */
@property (nonatomic, strong, readonly) NSString *url;

/**
 文件的储存路径
 */
@property (nonatomic, strong, readonly) NSString *destPath;

/**
 下载进度
 */
@property (nonatomic, copy) XHCProgressHandler progressBlock;

/**
 下载状态
 */
@property (nonatomic, assign, readonly, getter=isRunning) BOOL running;

/**
 读取本地已经下载文件的进度，用于初始化时候，显示下载文件的进度的需求

 @param url 文件的url
 @return 文件已经下载的文件大小
 */
+ (double)localFileDownloadScaleWithUrl:(NSString *)url;

/**
 删除本地记录下载文件的进度，当视频被删除的时候调用

 @param url 视频的url
 */
+ (void)removeLocalFileDownloadScaleWithUrl:(NSString *)url;

/**
 初始化方法

 @param urlString 下载文件的url
 @return XHCDownloader对象
 */
- (instancetype)initWithUrlString:(NSString *)urlString savePath:(NSString *)savePath fileName:(NSString *)fileName fileType:(NSString *)fileType;

/**
 开始（恢复）下载
 */
- (void)start;

/**
 暂停下载
 */
- (void)pause;

@end
