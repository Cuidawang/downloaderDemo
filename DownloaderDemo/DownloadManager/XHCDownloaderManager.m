//
//  XHCDownloaderManager.m
//  DownloaderDemo
//
//  Created by Cuikeyi on 2016/12/19.
//  Copyright © 2016年 xiaohongchun. All rights reserved.
//

#import "XHCDownloaderManager.h"
#import "XHCDownloader.h"
#import "XHCDownloaderModel.h"

#define maxDownNum  3

@interface XHCDownloaderManager ()

@property (nonatomic, strong) NSMutableDictionary *downloaderModelDict;
@property (nonatomic, strong) NSMutableDictionary *downloaderDict;

@end

@implementation XHCDownloaderManager

+ (XHCDownloaderManager *)shareInstall
{
    static XHCDownloaderManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XHCDownloaderManager alloc] init];
        manager.downloaderDict = [NSMutableDictionary dictionaryWithCapacity:maxDownNum];
        manager.downloaderModelDict = [NSMutableDictionary dictionaryWithCapacity:maxDownNum];
    });
    return manager;
}

- (void)downloadPathWithDownloaderModel:(XHCDownloaderModel *)model
{
    if([_downloaderModelDict objectForKey:model.url]) {// 判断开始还是暂停
        
        XHCDownloader *downloader = [_downloaderDict objectForKey:model.url];
        if (downloader.isRunning) {// 如果正在下载，暂停下载
            [downloader pause];
        }
        else {
            [downloader start];
        }
    }
    else {// 添加到数组中
        if (_downloaderModelDict.allKeys.count < maxDownNum) {
            [_downloaderModelDict setObject:model forKey:model.url];
            
            NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            XHCDownloader *downloader = [[XHCDownloader alloc] initWithUrlString:model.url savePath:path fileName:[model.url substringFromIndex:25] fileType:@"mp4"];
            downloader.progressBlock = ^ (double progress) {
                model.progress = @(progress);
                if (progress == 1.00) {
                    [_downloaderDict removeObjectForKey:model.url];
                    [_downloaderModelDict removeObjectForKey:model.url];
                }
            };
            [downloader start];
            [_downloaderDict setObject:downloader forKey:model.url];
        }
        else {
            // 提示用户超过最大下载数
        }
        
    }
}

@end
