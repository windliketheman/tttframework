//
//  UITabBarController+TabBar.m
//  UIFramework
//
//  Created by jia on 2017/11/12.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UITabBarController+TabBar.h"

@implementation UITabBarController (TabBar)

- (BOOL)isTabBarShowing
{
    CGFloat screenHeight = CGRectGetMaxY(self.view.frame);
    CGFloat tabBarOrigin = CGRectGetMinY(self.tabBar.frame);
    return tabBarOrigin < screenHeight;
}

- (void)showTabBar
{
    if (!self.isTabBarShowing)
    {
        CGRect tabBarRect = self.tabBar.frame;
        tabBarRect.origin.y -= CGRectGetHeight(self.tabBar.bounds);
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             [self.tabBar setFrame:tabBarRect];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)hideTabBar
{
    if (self.isTabBarShowing)
    {
        CGRect tabBarRect = self.tabBar.frame;
        tabBarRect.origin.y += CGRectGetHeight(self.tabBar.bounds);
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             [self.tabBar setFrame:tabBarRect];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

//- (void)showTabBar
//{
//    CGRect tabBarRect = self.tabBarController.tabBar.frame;
//    tabBarRect.origin.y -= CGRectGetHeight(self.tabBarController.tabBar.bounds);
//
//    [UIView animateWithDuration:0.25f
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//
//                         [self.tabBarController.tabBar setFrame:tabBarRect];
//                     }
//                     completion:^(BOOL finished) {
//
//                     }];
//}
//
//- (void)hideTabBar
//{
//    CGRect tabBarRect = self.tabBarController.tabBar.frame;
//    tabBarRect.origin.y += CGRectGetHeight(self.tabBarController.tabBar.bounds);
//
//    [UIView animateWithDuration:0.25f
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//
//                         [self.tabBarController.tabBar setFrame:tabBarRect];
//                     }
//                     completion:^(BOOL finished) {
//
//                     }];
//}

@end
