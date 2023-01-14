//
//  UINavigationItem+Global.h
//  TTTFramework
//
//  Created by jia on 2017/10/15.
//  Copyright © 2017年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UINavigationItemGlobalProtocol <NSObject>

// 全局控制样式
@property (nonatomic, readonly, class, nonnull) Class global;

@property (nonatomic, strong, class, nullable) UIColor *barButtonItemColor;
@property (nonatomic, strong, class, nullable) UIFont  *barButtonItemFont;

@property (nonatomic, strong, class, nullable) UIColor *backButtonItemColor;
@property (nonatomic, strong, class, nullable) UIColor *closeButtonItemColor;

@property (nonatomic, readonly, class) CGFloat barButtonItemSideSpacing;
@property (nonatomic, readonly, class) CGFloat titleButtonItemSideSpacing;
@property (nonatomic, readonly, class) CGFloat imageButtonItemSideSpacing;
@property (nonatomic, readonly, class) CGFloat backButtonItemSideSpacing;

// 调整返回按钮的图片位置
@property (nonatomic, readwrite, class) CGPoint backButtonImageOffset;

@property (nonatomic, readwrite, class) CGSize barButtonItemSize;

// 下面2个按钮图片高度尽量不超过22，否则横屏时会压扁
@property (nonatomic, readwrite, class) CGSize backButtonItemSize;
@property (nonatomic, readwrite, class) CGSize closeButtonItemSize;

@end

@interface UINavigationItem (Global) <UINavigationItemGlobalProtocol>

@end
