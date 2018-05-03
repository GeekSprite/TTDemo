//
//  TTSimpleRouter.m
//  TTDemo
//
//  Created by liuxj on 2018/5/3.
//  Copyright © 2018年 iwm. All rights reserved.
//

#import "TTSimpleRouter.h"
#import <UIKit/UIKit.h>
#import "TTFeedbackViewController.h"

@implementation TTSimpleRouter

#pragma mark - Public Method

+ (void)openURL:(NSURL *)url {
    //可以判断是使用webview还是使用Native
    NSString *scheme = url.scheme;
    //用于查找方法表
    NSString *host = url.host;
    //可以得到跳转所需参数
    NSString *query = url.query;
    
    NSDictionary *params = [self paramsWithQuery:query];

    if ([scheme isEqualToString:@"tantanapp"]) {
        //一般来说应该有一张对应跳转表，这里直接写死
        if ([host isEqualToString:@"feedback"]) {
            [self openFeedbackPageWithParams:params];
        }
    }else {
        //webview 或者其他
    }
}

#pragma mark - OpenGage

+ (void)openFeedbackPageWithParams:(NSDictionary *)params {
    //这里可以解析参数传给VC，这里简单忽略掉
    TTFeedbackViewController *feedbackVC = [[TTFeedbackViewController alloc] init];
    [self showViewController:feedbackVC];
}

#pragma mark - Helper

//用于解析参数
+ (NSDictionary *)paramsWithQuery:(NSString *)query {
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    NSArray *querysArray = [query componentsSeparatedByString:@"&"];
    [querysArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *componentsArray = [query componentsSeparatedByString:@"="];
        parametersDict[componentsArray.firstObject] = componentsArray.lastObject;
    }];
    return parametersDict.copy;
}

+ (UIViewController *)topViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (true) {
        if (rootVC.childViewControllers.lastObject) {
            rootVC = rootVC.childViewControllers.lastObject;
            continue;
        }
        
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            rootVC = ((UINavigationController *)rootVC).viewControllers.lastObject;
            continue;
        }
        
        if ([rootVC isKindOfClass:[UITabBarController class]]) {
            rootVC = ((UITabBarController *)rootVC).selectedViewController;
            continue;
        }
        
        if (rootVC.presentedViewController) {
            rootVC = rootVC.presentedViewController;
            continue;
        }
        
        break;
    }
    
    return rootVC;
}

+ (void)showViewController:(UIViewController *)vc {
    UIViewController *topVC = [self topViewController];
    
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)topVC pushViewController:vc animated:YES];
    }else if(topVC.navigationController) {
        [topVC.navigationController pushViewController:vc animated:YES];
    }else {
        [topVC presentViewController:vc animated:YES completion:nil];
    }
}

@end
