//
//  AppDelegate.h
//  DownloaderDemo
//
//  Created by Cuikeyi on 2016/12/19.
//  Copyright © 2016年 xiaohongchun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XHCAPPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigation;

@end

