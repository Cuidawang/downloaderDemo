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

- (void)downloadFileWithDownloaderModel:(XHCDownloaderModel *)model
{
    
    if (model.progress.integerValue == 1) {
        [Util showAlertMessage:@"视频已经下载完成了"];
        return;
    }
    
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
            XHCDownloader *downloader = [[XHCDownloader alloc] initWithUrlString:model.url savePath:path fileName:model.url fileType:@"mp4"];
            model.destPath = downloader.destPath;
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
            [Util showAlertMessage:@"最大支持三个下载"];
        }
        
    }
}

- (void)removeDownloadFildWithDownloadModel:(XHCDownloaderModel *)model
{
    if ([_downloaderModelDict objectForKey:model.url]) {// 删除时，取消正在下载的任务
        XHCDownloader *downloader = [_downloaderDict objectForKey:model.url];
        [downloader pause];
        [_downloaderDict removeObjectForKey:model.url];
        [_downloaderModelDict removeObjectForKey:model.url];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:model.destPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:model.destPath error:nil];
    }
    [XHCDownloader removeLocalFileDownloadScaleWithUrl:model.url];
    
}

@end
