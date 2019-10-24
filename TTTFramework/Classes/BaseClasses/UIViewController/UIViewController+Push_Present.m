//
//  UIViewController+Push_Present.m
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UIViewController+Push_Present.h"
#import "UIViewController+Customized.h"
#import "UINavigationController+Customized.h"
#import "NavigationController.h"

@implementation UIViewController (Push_Present)

// 动作开
- (void)presentRootViewController:(UIViewController *)vc
{
    [self presentRootViewController:vc animated:YES transitionStyle:UIModalTransitionStyleCoverVertical complection:nil];
}

// 动作开关
- (void)presentRootViewController:(UIViewController *)vc animated:(BOOL)animated complection:(dispatch_block_t)complection
{
    [self presentRootViewController:vc animated:animated transitionStyle:UIModalTransitionStyleCoverVertical complection:complection];
}

// 动作开关＋动画类型
- (void)presentRootViewController:(UIViewController *)vc animated:(BOOL)animated transitionStyle:(UIModalTransitionStyle)style complection:(dispatch_block_t)complection
{
    [self presentRootViewController:vc animated:animated transitionStyle:style navigationBarColor:self.navigationController.navigationBarColor navigationBarTextColor:self.navigationController.navigationBarTitleColor complection:complection];
}

#pragma mark --- 定制导航栏
// 动作开＋设置导航栏背景＋文字颜色
- (void)presentRootViewController:(UIViewController *)vc navigationBarColor:(UIColor *)barColor navigationBarTextColor:(UIColor *)barTextColor
{
    [self presentRootViewController:vc animated:YES navigationBarColor:barColor navigationBarTextColor:barTextColor complection:nil];
}

// 动作开＋设置导航栏背景＋文字颜色 完成回调
- (void)presentRootViewController:(UIViewController *)vc navigationBarColor:(UIColor *)barColor navigationBarTextColor:(UIColor *)barTextColor complection:(dispatch_block_t)complection
{
    [self presentRootViewController:vc animated:YES navigationBarColor:barColor navigationBarTextColor:barTextColor complection:complection];
}

// 动作开关＋设置导航栏背景＋文字颜色
- (void)presentRootViewController:(UIViewController *)vc animated:(BOOL)animated navigationBarColor:(UIColor *)barColor navigationBarTextColor:(UIColor *)barTextColor complection:(dispatch_block_t)complection
{
    [self presentRootViewController:vc animated:animated transitionStyle:UIModalTransitionStyleCoverVertical navigationBarColor:barColor navigationBarTextColor:barTextColor complection:complection];
}

// 动作开关＋动画类型＋设置导航栏背景＋文字颜色
- (void)presentRootViewController:(UIViewController *)vc animated:(BOOL)animated transitionStyle:(UIModalTransitionStyle)style navigationBarColor:(UIColor *)barColor navigationBarTextColor:(UIColor *)barTextColor complection:(dispatch_block_t)complection
{
#if 0
    CGFloat red, green, blue, alpha;
    [barColor getRed:&red green:&green blue:&blue alpha:&alpha];
#endif

    UINavigationController *navi = nil;
    if (![vc isKindOfClass:[UINavigationController class]]) {
        // 不是导航器，则把它放入导航器
        // navi = [[UINavigationController alloc] initWithRootViewController:vc];
        navi = [[NavigationController alloc] initWithRootViewController:vc];
    } else {
        // 是导航器 则使用自身
        navi = (UINavigationController *)vc;
    }
    navi.modalTransitionStyle = style;

    [self presentViewController:navi animated:animated completion:^{
        
        if (complection) {
            complection();
        }
    }];
}

#pragma mark --- Dismiss
- (void)dismiss
{
    [self dismissAnimated:YES complection:^{
        //
    }];
}

- (void)dismissAnimated:(BOOL)animated complection:(dispatch_block_t)complection
{
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:animated completion:^{
            if (complection) complection();
        }];
    } else {
        [self dismissViewControllerAnimated:animated completion:^{
            if (complection) complection();
        }];
    }
}

#pragma mark --- Push
- (void)pushViewController:(UIViewController *)vc
{
    [self pushViewController:vc animated:YES];
}

- (void)pushViewController:(UIViewController *)vc animated:(BOOL)animated
{
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToViewController:(id)someViewController
{
    if ([someViewController isKindOfClass:[NSNumber class]]) {
        [self popToViewControllerLevel:someViewController];
    } else {
        [self popToViewControllerObject:someViewController];
    }
}

- (void)popToViewControllerObject:(id)someViewController
{
    UINavigationController *navigationController = nil;
    if ([self isKindOfClass:UINavigationController.class]) {
        navigationController = (UINavigationController *)self;
    } else if (self.navigationController) {
        navigationController = self.navigationController;
    } else {
        // error
        return;
    }

    NSArray *array = nil;
    if ([someViewController isKindOfClass:NSArray.class]) { // NSArray
        array = (NSArray *)someViewController;
    } else if ([someViewController respondsToSelector:@selector(alloc)]) { // Class
        array = @[someViewController];
    } else if ([someViewController isKindOfClass:NSString.class]) { // object
        array = @[someViewController];
    } else {
        // do nothing
    }

    if (!array) {
        // 回跳一级
        [navigationController popViewControllerAnimated:YES];
    } else {
        for (id item in array) {
            Class targetClass = nil;
            if ([item isKindOfClass:NSString.class]) {
                targetClass = NSClassFromString(item);
            } else if ([item respondsToSelector:@selector(alloc)]) {
                targetClass = item;
            } else {
                // do nothing
            }

            if (!targetClass) {
                continue;
            } else {
                for (UIViewController *vc in navigationController.viewControllers) {
                    if ([vc isKindOfClass:targetClass]) {
                        [navigationController popToViewController:vc animated:YES];
                        return;
                    }
                }
            }
        }

        // 回跳一级
        [navigationController popViewControllerAnimated:YES];
    }
}

- (void)popToViewControllerLevel:(NSNumber *)level
{
    UINavigationController *navigationController = nil;
    if ([self isKindOfClass:UINavigationController.class]) {
        navigationController = (UINavigationController *)self;
    } else if (self.navigationController) {
        navigationController = self.navigationController;
    } else {
        // error
        return;
    }

    if (navigationController.viewControllers.count > labs(level.integerValue)) {
        NSInteger index = (level.integerValue >= 0) ? level.integerValue : (navigationController.viewControllers.count + level.integerValue - 1);
        if (index >= 0 && navigationController.viewControllers.count > index) {
            UIViewController *vc = navigationController.viewControllers[index];
            if (vc) {
                [navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }

    // 回跳一级
    [navigationController popViewControllerAnimated:YES];
}

- (BOOL)isExistedViewController:(Class)targetClass
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:targetClass]) {
            return YES;
        }
    }
    return NO;
}

@end
