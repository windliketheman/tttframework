//
//  TabBarController.h
//  TTTFramework
//
//  Created by jia on 16/4/21.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "UITabBarController+TabBar.h"

typedef void (^NavigationControllerConstructor)(UINavigationController **nc, UIViewController *vc);

@interface TabBarController : UITabBarController

// input images
@property (nonatomic, strong) NSArray *tabBarItemImages;
@property (nonatomic, strong) NSArray *tabBarItemSelectedImages;

// input titles
@property (nonatomic, strong) NSArray *tabBarItemTitles;
@property (nonatomic, assign) UIOffset tabBarItemTitleOffset;

// item color
@property (nonatomic, strong) UIColor *tabBarItemNormalColor;
@property (nonatomic, strong) UIColor *tabBarItemSelectedColor;

@property (nonatomic, strong) UIFont *tabBarItemTitleFont;

@property (nonatomic, strong) NSArray *contentViewControllers;

@property (nonatomic, copy) NavigationControllerConstructor navigationControllerConstructor;

#pragma mark - Member Methods
// 构建TabBarController，属性都设置完毕之后调用
- (void)loadChildViewControllers;

// 刷新Tab Bar上的项目
- (void)reloadTabBarItems;

@end
