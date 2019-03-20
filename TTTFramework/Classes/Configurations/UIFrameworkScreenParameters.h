//
//  UIFrameworkScreenParameters.h
//  UIFramework
//
//  Created by jia on 2016/11/30.
//  Copyright © 2016年 jia. All rights reserved.
//

#ifndef UIFrameworkScreenParameters_h
#define UIFrameworkScreenParameters_h

// 屏幕属性：宽 高 缩放比
#define SCREEN_WIDTH                   ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                  ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_SCALE                   ([UIScreen mainScreen].scale)

#define ONE_PIXEL                      (1/SCREEN_SCALE)

// 状态栏高度
#define STATUS_BAR_HEIGHT              CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])

// 导航栏高度
#define NAVIGATION_BAR_HEIGHT          44.0

// 切换栏高度
#define TAB_BAR_HEIGHT                 49.0

// 安全区
#define SAFE_AREA_LEFT_SPACING         (@available(iOS 11.0, *) ? [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.left   : 0.0)
#define SAFE_AREA_RIGHT_SPACING        (@available(iOS 11.0, *) ? [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.right  : 0.0)
#define SAFE_AREA_TOP_SPACING          (@available(iOS 11.0, *) ? [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.top    : 0.0)
#define SAFE_AREA_BOTTOM_SPACING       (@available(iOS 11.0, *) ? [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom : 0.0)

// 切换栏区域
#define TAB_BAR_AREA_HEIGHT            (TAB_BAR_HEIGHT + SAFE_AREA_BOTTOM_SPACING)

// 是否是全面屏（如iphoneX）
#define THIS_IS_ALL_SCREEN_DEVICE      (@available(iOS 11.0, *) ? [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0 : NO)

// 是否是 iPhone Plus
#define DEVICE_IS_IPHONE_PLUS          ((MIN(SCREEN_WIDTH, SCREEN_HEIGHT)) >= 414)

// 导航栏元素距离屏幕边距
#define PREFERRED_SCREEN_SIDE_SPACING  (DEVICE_IS_IPHONE_PLUS ? 20.0 : 16.0)

#endif /* UIFrameworkScreenParameters_h */
