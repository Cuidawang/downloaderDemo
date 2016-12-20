//
//  Util.m
//  DownloaderDemo
//
//  Created by Cuikeyi on 2016/12/20.
//  Copyright © 2016年 xiaohongchun. All rights reserved.
//

#import "Util.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation Util

#pragma mark - 32位MD5 - 加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString
{
    const char *cStr = [srcString UTF8String];
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

+ (void)showAlertMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:cancelAction];
    [XHCAPPDELEGATE.navigation presentViewController:alertVC animated:YES completion:nil];
}

@end
