//
//  NavigationController.m
//  TTTFramework
//
//  Created by jia on 16/4/12.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "NavigationController.h"
#import "UINavigationBar+Customized.h"
#import "NavigationController+Global.h"
#import "UITabBarController+TabBar.h"
#import "UIViewController+.h"

@interface NavigationController ()

@end

@implementation NavigationController

#pragma mark - Setter & Getter
- (void)setNavigationBarTranslucent:(BOOL)navigationBarTranslucent
{
    [self.navigationBar setTranslucent:navigationBarTranslucent];
}

- (BOOL)navigationBarTranslucent
{
    return self.navigationBar.translucent;
}

- (void)setCustomizedNavigationBarTranslucent:(BOOL)customizedNavigationBarTranslucent
{
    ((NavigationBar *)self.navigationBar).prefersCustomizedTranslucent = customizedNavigationBarTranslucent;
}

- (BOOL)customizedNavigationBarTranslucent
{
    return [((NavigationBar *)self.navigationBar) prefersCustomizedTranslucent];
}

#pragma mark - Member Methods
- (instancetype)init
{
    if (self = [super initWithNavigationBarClass:[self navigationBarClass] toolbarClass:nil]) {
        self.customizedEnabled = YES;
        self.navigationBarTranslucent = self.class.global.navigationBarTranslucent;
        self.customizedNavigationBarTranslucent = self.class.global.customizedNavigationBarTranslucent;
    }
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.customizedEnabled = YES;
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.customizedEnabled = YES;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [self init]) {
        self.customizedEnabled = YES;
        self.viewControllers = @[rootViewController];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(nullable Class)navigationBarClass toolbarClass:(nullable Class)toolbarClass
{
    if (self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass]) {
        self.customizedEnabled = YES;
    }
    return self;
}

- (Class)navigationBarClass
{
    return [NavigationBar class];
}

#pragma mark - Super
#if 0
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
        [self.navigationBar setBarTintColor:navigationBarColor];
    }
}
#endif

- (void)updateNavigationBarTitleAttributes:(NSDictionary *)navigationBarTitleAttributes
{
    [super updateNavigationBarTitleAttributes:navigationBarTitleAttributes];
}

- (void)updateNavigationBarLargeTitleAttributes:(NSDictionary *)navigationBarTitleAttributes
{
    [super updateNavigationBarLargeTitleAttributes:navigationBarTitleAttributes];
}

/*
#pragma mark --- Push | Pop
// Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self controlTabBarHidden];
    [super pushViewController:viewController animated:animated];
}

// Returns the popped controller.
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *popedViewController = [super popViewControllerAnimated:animated];
    [self controlTabBarShown];

    return popedViewController;
}

// Pops view controllers until the one specified is on top. Returns the popped controllers.
- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray<__kindof UIViewController *> *popedViewControllers = [super popToViewController:viewController animated:animated];
    [self controlTabBarShown];

    return popedViewControllers;
}

// Pops until there's only a single view controller left on the stack. Returns the popped controllers.
- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray<__kindof UIViewController *> *popedViewControllers = [super popToRootViewControllerAnimated:animated];
    [self controlTabBarShown];

    return popedViewControllers;
}

- (void)controlTabBarHidden
{
    if (self.tabBarController)
    {
        if (self.viewControllers.count == 1)
        {
            [self.tabBarController hideTabBar];
        }
    }
}

- (void)controlTabBarShown
{
    if (self.tabBarController)
    {
        if (self.viewControllers.count == 1)
        {
            [self.tabBarController showTabBar];
        }
    }
}
*/

@end
