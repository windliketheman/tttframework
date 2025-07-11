//
//  UIViewController+Global.h
//  TTTFramework
//
//  Created by jia on 2017/10/15.
//  Copyright © 2017年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerGlobalProtocol <NSObject>

// 全局控制样式
@property (nonatomic, readonly, class) Class global;

// 背景色
@property (nonatomic, strong, class) UIColor *backgroundColor;

// 分割线颜色
@property (nonatomic, strong, class) UIColor *separatorColor;

// 分组背景色（TableView背景色）
@property (nonatomic, strong, class) UIColor *spacingColor;

@end

@interface UIViewController (Global) <UIViewControllerGlobalProtocol>

@end
