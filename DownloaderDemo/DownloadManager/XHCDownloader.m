//
//  XHCDownloader.m
//  XHCSort
//
//  Created by Cuikeyi on 2016/12/19.
//  Copyright © 2016年 xiaohongchun. All rights reserved.
//

#import "XHCDownloader.h"

@interface XHCDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSFileHandle *writeHandle;        /**< 写数据的文件句柄 */
@property (nonatomic, assign) long long totalLength;            /**< 文件的总大小 */
@property (nonatomic, assign) long long currentLength;          /**<  */

@end

@implementation XHCDownloader

+ (double)localFileDownloadScaleWithUrl:(NSString *)url
{
    NSString *key = getFileTotalSizeKey(url);
    double size = [[NSUserDefaults standardUserDefaults] doubleForKey:key];
    return size;
}

+ (void)removeLocalFileDownloadScaleWithUrl:(NSString *)url
{
    NSString *key = getFileTotalSizeKey(url);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (instancetype)initWithUrlString:(NSString *)urlString savePath:(NSString *)savePath fileName:(NSString *)fileName fileType:(NSString *)fileType
{
    if (self = [super init]) {
        NSParameterAssert(urlString);
        NSParameterAssert(savePath);
        NSParameterAssert(fileType);
        /* 去掉特殊符号做文件名
        NSString *testString = @"http://v.xiaohongchun.com/BBF10FBD3A3DA18E";
        NSString *pattern = @"[:./]";
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:9 error:nil];
        NSString *lala = [regular stringByReplacingMatchesInString:testString options:0 range:NSMakeRange(0, testString.length) withTemplate:@""];
         */
        if (!fileName) {
            fileName = urlString;
        }
        fileName = [Util getMd5_32Bit_String:fileName];
        
        _destPath = [NSString stringWithFormat:@"%@/%@.%@", savePath, fileName, fileType];
        _url = urlString;
    }
    return self;
}

/**
 开始下载
 */
- (void)start
{
    
    [self.dataTask resume];
    _running = YES;
}

/**
 暂停下载
 */
- (void)pause
{
    
    [self.dataTask suspend];
    _running = NO;
}

#pragma mark - 辅助方法
NSString * getFileTotalSizeKey(NSString *url)
{
    return [NSString stringWithFormat:@"fileTotalSize_%@", url];
}

unsigned long long fileSizeForPath (NSString *path)
{
    unsigned long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError * error = nil;
        NSDictionary * fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize =[fileDict fileSize];
        }
    }
    return fileSize;
}

#pragma mark - 懒加载
- (NSURLSessionDataTask *)dataTask
{
    if (!_dataTask) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:_destPath]) {
            [[NSFileManager defaultManager] createFileAtPath:_destPath contents:nil attributes:nil];
        }
        _writeHandle = [NSFileHandle fileHandleForWritingAtPath:_destPath];
        // 创建流
        NSOutputStream __block *outputStream = [[NSOutputStream alloc] initWithURL:[NSURL fileURLWithPath:_destPath] append:YES];
        // 请求体
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
        
        
        unsigned long long cacheFileSize = 0;
        cacheFileSize = fileSizeForPath(_destPath);
        if (cacheFileSize) {
            NSString *range = [NSString stringWithFormat:@"bytes=%lld-", cacheFileSize];
            [request setValue:range forHTTPHeaderField:@"Range"];
        }
        // 下载对象（任务）
        _dataTask = [sessionManager dataTaskWithRequest:request completionHandler:nil];
        _running = NO;
        // 下载接受数据
        [sessionManager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
            // 下载文件总大小
            _totalLength = response.expectedContentLength + cacheFileSize;
            // 储存下载的进度
            double scale = (double)cacheFileSize/_totalLength;
            NSString *key = getFileTotalSizeKey(_url);
            [[NSUserDefaults standardUserDefaults] setDouble:scale forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"文件总大小%lld", _totalLength);
            
            // 打开流
            [outputStream open];
            return NSURLSessionResponseAllow;
        }];
        // 写入数据
        [sessionManager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
            NSInteger result = [outputStream write:data.bytes maxLength:data.length];
            if (result == -1) {
                // 出错了
                // outputStream.streamError;
                [_dataTask cancel];
            }
            else {
                // 写文件
                
                [_writeHandle seekToFileOffset:cacheFileSize + _currentLength];
                [_writeHandle writeData:data];
                self.currentLength += data.length;
                
                // 下载进度
                double progress = (double)(_currentLength + cacheFileSize) / _totalLength;
                NSLog(@"%.2f", progress);
                NSString *key = getFileTotalSizeKey(_url);
                [[NSUserDefaults standardUserDefaults] setDouble:progress forKey:key];
                [[NSUserDefaults standardUserDefaults] synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.progressBlock) {
                        self.progressBlock(progress);
                    }
                });
                
            }
        }];
        // 下载完成
        [sessionManager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
            _running = NO;
            [outputStream close];
            outputStream = nil;
            [_writeHandle closeFile];
            task = nil;
            if (error) {
                
            }
        }];
        
    }
    return _dataTask;
}

@end
