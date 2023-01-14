//
//  UINavigationBar+Customized.h
//  TTTFramework
//
//  Created by jia on 2016/12/5.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kShadowImageGrayValue 176.0/255.0

@protocol UINavigationBarCustomizedProtocol <NSObject>

@property (nonatomic, readonly) id _Nullable color;

@end

@interface UINavigationBar (Customized) <UINavigationBarCustomizedProtocol>

@property (nonatomic, strong, nullable) id color;

@property (nonatomic, strong, nonnull) UIColor      *titleColor;
@property (nonatomic, strong, nonnull) UIFont       *titleFont;
@property (nonatomic, strong, nonnull) NSDictionary *titleAttributes;

@property (nonatomic, strong, nonnull) UIColor      *largeTitleColor;
@property (nonatomic, strong, nonnull) UIFont       *largeTitleFont;
@property (nonatomic, strong, nonnull) NSDictionary *largeTitleAttributes;

@property (nonatomic) BOOL shadowImageEnabled;

@end
