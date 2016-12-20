//
//  Util.h
//  DownloaderDemo
//
//  Created by Cuikeyi on 2016/12/20.
//  Copyright © 2016年 xiaohongchun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;
+ (void)showAlertMessage:(NSString *)message;

@end
