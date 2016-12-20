//
//  XHCDownloaderManager.h
//  DownloaderDemo
//
//  Created by Cuikeyi on 2016/12/19.
//  Copyright © 2016年 xiaohongchun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XHCDownloaderModel;

@interface XHCDownloaderManager : NSObject

+ (XHCDownloaderManager *)shareInstall;

- (void)downloadFileWithDownloaderModel:(XHCDownloaderModel *)model;

- (void)removeDownloadFildWithDownloadModel:(XHCDownloaderModel *)model;

@end
