//
//  UINavigationController+Customized.m
//  TTTFramework
//
//  Created by jia on 2016/12/5.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "UINavigationController+Customized.h"
#import "UINavigationBar+Customized.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"
#import "UIImage+Extension.h"
#import "UIColor+Extension.h"
#import "UIViewController+.h"

static id _appearance_navigationBarColor;
static UIColor *_appearance_navigationBarTitleColor;
static UIFont *_appearance_navigationBarTitleFont;

@implementation UINavigationController (Customized)

#pragma mark - Properties
- (id)navigationBarColor
{
    return self.navigationBar.color;
}

- (UIColor *)navigationBarTitleColor
{
    return self.navigationBar.titleColor;
}

- (UIFont *)navigationBarTitleFont
{
    return self.navigationBar.titleFont;
}

- (NSDictionary *)navigationBarTitleAttributes
{
    return self.navigationBar.titleAttributes;
}

- (UIColor *)navigationBarLargeTitleColor
{
    return self.navigationBar.largeTitleColor;
}

- (UIFont *)navigationBarLargeTitleFont
{
    return self.navigationBar.largeTitleFont;
}

- (NSDictionary *)navigationBarLargeTitleAttributes
{
    return self.navigationBar.largeTitleAttributes;
}

- (void)updateNavigationBarColor:(UIColor *)navigationBarColor
{
    if (navigationBarColor && ![navigationBarColor isKindOfClass:UIColor.class]) {
        // 错误，传入的不是一个color
        return;
    }
    self.navigationBar.color = navigationBarColor;

    if (@available(iOS 13.0, *)) {
        if (navigationBarColor) {
            // scroll达到边缘时，导航栏的外观熟悉
            UINavigationBarAppearance *edgeAppearance = self.navigationBar.scrollEdgeAppearance;
            if (!edgeAppearance) {
                edgeAppearance = [[UINavigationBarAppearance alloc] init];
            }
            [edgeAppearance configureWithOpaqueBackground];
            edgeAppearance.backgroundColor = navigationBarColor;
            self.navigationBar.scrollEdgeAppearance = edgeAppearance;
            
            // 标准外观样式
            UINavigationBarAppearance *appearance = self.navigationBar.standardAppearance;
            if (!appearance) {
                appearance = [[UINavigationBarAppearance alloc] init];
            }
            [appearance configureWithOpaqueBackground];
            appearance.backgroundColor = navigationBarColor;
            // appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
            self.navigationBar.standardAppearance = appearance;
        } else {
            // scroll达到边缘时，导航栏的外观熟悉
            UINavigationBarAppearance *edgeAppearance = self.navigationBar.scrollEdgeAppearance;
            if (!edgeAppearance) {
                edgeAppearance = [[UINavigationBarAppearance alloc] init];
            }
            [edgeAppearance configureWithTransparentBackground];
            edgeAppearance.backgroundColor = navigationBarColor;
            self.navigationBar.scrollEdgeAppearance = edgeAppearance;
            
            // 标准外观样式
            UINavigationBarAppearance *appearance = self.navigationBar.standardAppearance;
            if (!appearance) {
                appearance = [[UINavigationBarAppearance alloc] init];
            }
            [appearance configureWithDefaultBackground];
            appearance.backgroundColor = navigationBarColor;
            self.navigationBar.standardAppearance = appearance;
        }
    } else {
        // 适用于iOS13以前的系统，已经过时
        if (!navigationBarColor) {
            [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBarTintColor:nil];
        } else {
            CGFloat red, green, blue, alpha;
            [navigationBarColor getRed:&red green:&green blue:&blue alpha:&alpha];

            if (alpha >= 1.0) {
                [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                [self.navigationBar setBarTintColor:navigationBarColor];
            } else {
                [self.navigationBar setBackgroundImage:[UIImage imageWithColor:navigationBarColor] forBarMetrics:UIBarMetricsDefault];
            }
        }
    }
}

- (void)updateNavigationBarColor:(UIColor *)navigationBarColor scrollViewSwitchable:(BOOL)scrollViewSwitchable
{
    if (!scrollViewSwitchable) {
        [self updateNavigationBarColor:navigationBarColor];
        return;
    }
    
    if (navigationBarColor && ![navigationBarColor isKindOfClass:UIColor.class]) {
        // 错误，传入的不是一个color
        return;
    }
    self.navigationBar.color = navigationBarColor;

    if (@available(iOS 13.0, *)) {
        if (navigationBarColor) {
            // scroll达到边缘时，导航栏的外观熟悉
            UINavigationBarAppearance *edgeAppearance = self.navigationBar.scrollEdgeAppearance;
            if (!edgeAppearance) {
                edgeAppearance = [[UINavigationBarAppearance alloc] init];
            }
            [edgeAppearance configureWithOpaqueBackground];
            edgeAppearance.backgroundColor = navigationBarColor;
            self.navigationBar.scrollEdgeAppearance = edgeAppearance;
            
            // 标准外观样式
            UINavigationBarAppearance *appearance = self.navigationBar.standardAppearance;
            if (!appearance) {
                appearance = [[UINavigationBarAppearance alloc] init];
            }
            [appearance configureWithOpaqueBackground];
            appearance.backgroundColor = navigationBarColor;
            self.navigationBar.standardAppearance = appearance;
        } else {
            // scroll达到边缘时，导航栏的外观熟悉
            UINavigationBarAppearance *edgeAppearance = self.navigationBar.scrollEdgeAppearance;
            if (!edgeAppearance) {
                edgeAppearance = [[UINavigationBarAppearance alloc] init];
            }
            [edgeAppearance configureWithDefaultBackground];
            edgeAppearance.backgroundColor = navigationBarColor;
            self.navigationBar.scrollEdgeAppearance = edgeAppearance;
            
            // 标准外观样式
            UINavigationBarAppearance *appearance = self.navigationBar.standardAppearance;
            if (!appearance) {
                appearance = [[UINavigationBarAppearance alloc] init];
            }
            [appearance configureWithDefaultBackground];
            appearance.backgroundColor = navigationBarColor;
            self.navigationBar.standardAppearance = appearance;
        }
    } else {
        // 适用于iOS13以前的系统，已经过时
        if (!navigationBarColor) {
            [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBarTintColor:nil];
        } else {
            CGFloat red, green, blue, alpha;
            [navigationBarColor getRed:&red green:&green blue:&blue alpha:&alpha];

            if (alpha >= 1.0) {
                [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                [self.navigationBar setBarTintColor:navigationBarColor];
            } else {
                [self.navigationBar setBackgroundImage:[UIImage imageWithColor:navigationBarColor] forBarMetrics:UIBarMetricsDefault];
            }
        }
    }
}

- (void)updateNavigationBarTitleColor:(UIColor *)navigationBarTitleColor
{
    self.navigationBar.titleColor = navigationBarTitleColor;
}

- (void)updateNavigationBarTitleFont:(UIFont *)navigationBarTitleFont
{
    self.navigationBar.titleFont = navigationBarTitleFont;
}

- (void)updateNavigationBarTitleAttributes:(NSDictionary *)navigationBarTitleAttributes
{
    self.navigationBar.titleAttributes = navigationBarTitleAttributes;
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *edgeAppearance = self.navigationBar.scrollEdgeAppearance;
        if (!edgeAppearance) {
            edgeAppearance = [[UINavigationBarAppearance alloc] init];
        }
        edgeAppearance.titleTextAttributes = navigationBarTitleAttributes;
        self.navigationBar.scrollEdgeAppearance = edgeAppearance;
        
        UINavigationBarAppearance *appearance = self.navigationBar.standardAppearance;
        if (!appearance) {
            appearance = [[UINavigationBarAppearance alloc] init];
        }
        appearance.titleTextAttributes = navigationBarTitleAttributes;
        self.navigationBar.standardAppearance = appearance;
    }
}

- (void)updateNavigationBarLargeTitleColor:(UIColor *)navigationBarTitleColor
{
    self.navigationBar.largeTitleColor = navigationBarTitleColor;
}

- (void)updateNavigationBarLargeTitleFont:(UIFont *)navigationBarTitleFont
{
    self.navigationBar.largeTitleFont = navigationBarTitleFont;
}

- (void)updateNavigationBarLargeTitleAttributes:(NSDictionary *)navigationBarTitleAttributes
{
    self.navigationBar.largeTitleAttributes = navigationBarTitleAttributes;
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *edgeAppearance = self.navigationBar.scrollEdgeAppearance;
        if (!edgeAppearance) {
            edgeAppearance = [[UINavigationBarAppearance alloc] init];
        }
        edgeAppearance.largeTitleTextAttributes = navigationBarTitleAttributes;
        self.navigationBar.scrollEdgeAppearance = edgeAppearance;
        
        UINavigationBarAppearance *appearance = self.navigationBar.standardAppearance;
        if (!appearance) {
            appearance = [[UINavigationBarAppearance alloc] init];
        }
        appearance.largeTitleTextAttributes = navigationBarTitleAttributes;
        self.navigationBar.standardAppearance = appearance;
    }
}

- (void)setNavigationBarShadowImageEnabled:(BOOL)enabled
{
    self.navigationBar.shadowImageEnabled = enabled;

    if (@available(iOS 13.0, *)) {
        // scroll达到边缘时，导航栏的外观熟悉
        UINavigationBarAppearance *edgeAppearance = self.navigationBar.scrollEdgeAppearance;
        if (!edgeAppearance) {
            edgeAppearance = [[UINavigationBarAppearance alloc] init];
        }
        edgeAppearance.shadowColor = [UIColor clearColor]; // clear或nil，不显示
        self.navigationBar.scrollEdgeAppearance = edgeAppearance;
        
        // 标准外观样式
        UINavigationBarAppearance *appearance = self.navigationBar.standardAppearance;
        if (!appearance) {
            appearance = [[UINavigationBarAppearance alloc] init];
        }
        if (enabled) {
            // appearance.shadowColor = [UIColor greenColor]; // 能显示具体颜色
            // appearance.shadowColor = [UIColor colorWithRed:SHADOW_IMAGE_GRAY_VALUE green:SHADOW_IMAGE_GRAY_VALUE blue:SHADOW_IMAGE_GRAY_VALUE alpha:1.0];
            appearance.shadowImage = [[UIImage alloc] init]; // 这样设置的阴影可以在浅色、深色系统间自由切换
        } else {
            appearance.shadowColor = [UIColor clearColor]; // 设置color为clear或nil，可以让阴影不显示
            // appearance.shadowImage = nil; // 不能通过设置image为nil来达到去掉阴影的效果
        }
        self.navigationBar.standardAppearance = appearance;
    }
}

- (BOOL)navigationBarShadowImageEnabled
{
    return self.navigationBar.shadowImageEnabled;
}

#pragma mark - Swizzle
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(preferredStatusBarStyle) withSelector:@selector(uinavigationController_preferredStatusBarStyle)];
        [self swizzleInstanceSelector:@selector(prefersStatusBarHidden) withSelector:@selector(uinavigationController_prefersStatusBarHidden)];

        [self swizzleInstanceSelector:@selector(shouldAutorotate) withSelector:@selector(uinavigationController_shouldAutorotate)];
        [self swizzleInstanceSelector:@selector(supportedInterfaceOrientations) withSelector:@selector(uinavigationController_supportedInterfaceOrientations)];
        [self swizzleInstanceSelector:@selector(preferredInterfaceOrientationForPresentation) withSelector:@selector(uinavigationController_preferredInterfaceOrientationForPresentation)];
    });
}

- (UIStatusBarStyle)uinavigationController_preferredStatusBarStyle
{
    if (self.topViewController) {
        return [self.topViewController preferredStatusBarStyle];
    } else {
        return self.statusBarStyle;
    }
}

/*
 // 不重写默认的 感觉没必要
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
 */

// 这个方法写了也不调用
- (BOOL)uinavigationController_prefersStatusBarHidden
{
    if (self.topViewController) {
        return [self.topViewController prefersStatusBarHidden];
    } else {
        return [self uinavigationController_prefersStatusBarHidden];
    }
}

/*
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
 */

- (BOOL)uinavigationController_shouldAutorotate
{
    if (self.topViewController) {
        return [self.topViewController shouldAutorotate];
    }
    return [self uinavigationController_shouldAutorotate];
}

- (UIInterfaceOrientationMask)uinavigationController_supportedInterfaceOrientations
{
    if (self.topViewController) {
        return [self.topViewController supportedInterfaceOrientations];
    }
    return [self uinavigationController_supportedInterfaceOrientations];
}

// 初始方向（Presentation方式专用）
- (UIInterfaceOrientation)uinavigationController_preferredInterfaceOrientationForPresentation
{
    if (self.topViewController) {
        return [self.topViewController preferredInterfaceOrientationForPresentation];
    }
    return [self uinavigationController_preferredInterfaceOrientationForPresentation];
}

@end
