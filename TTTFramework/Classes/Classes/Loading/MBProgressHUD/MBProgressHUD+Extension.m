//
//  MBProgressHUD+Extension.m
//  TTTFramework
//
//  Created by jia on 16/5/6.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "MBProgressHUD+Extension.h"
#import "TTTFrameworkCommonDefines.h"

@implementation MBProgressHUD (Extension)

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style
{
    self.activityIndicator.activityIndicatorViewStyle = style;
}

- (void)setActivityIndicatorTransformScale:(CGFloat)scale
{
    self.activityIndicator.transform = CGAffineTransformMakeScale(scale, scale);
}

- (UIActivityIndicatorView *)activityIndicator
{
    for (UIActivityIndicatorView *view in self.bezelView.subviews) {
        if ([view isKindOfClass:UIActivityIndicatorView.class]) {
            return view;
        }
    }
    return nil;
}

- (void)setMBProgressHUDLook:(MBProgressHUDTheme)look
{
    if (MBProgressHUDThemePure == look) {
        // 浅色内容, 文字 & loading
        UIColor *lightContentColor = RGBACOLOR(255, 255, 255, 1.0);

        // 深色内容, 文字 & loading
        UIColor *darkContentColor = RGBACOLOR(0, 0, 0, 1.0);
        
        if (@available(iOS 13.0, *)) {
            // Blur 效果
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            // 提示框颜色
            self.bezelView.backgroundColor = nil;
            // 文字颜色
            self.contentColor = [UIColor colorWithDynamicProvider:^UIColor *_Nonnull (UITraitCollection *_Nonnull traitCollection) {
                if (UIUserInterfaceStyleDark == traitCollection.userInterfaceStyle) {
                    return lightContentColor;
                }
                return darkContentColor;
            }];
            // loading颜色
            self.activityIndicator.color = [UIColor colorWithDynamicProvider:^UIColor *_Nonnull (UITraitCollection *_Nonnull traitCollection) {
                if (UIUserInterfaceStyleDark == traitCollection.userInterfaceStyle) {
                    return lightContentColor;
                }
                return darkContentColor;
            }];
        }
    } else if (MBProgressHUDThemeLight == look) {
        self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        // 提示框颜色
        self.bezelView.backgroundColor = RGBACOLOR(255, 255, 255, 0.75);
        // 文字颜色
        self.contentColor = RGBACOLOR(5, 5, 5, 1.0);
        // loading颜色
        self.activityIndicator.color = RGBACOLOR(5, 5, 5, 1.0);
    } else {
        // 浅色模式
        UIColor *lightModeBubbleColor = RGBACOLOR(30, 30, 30, 1.0); // 提示框颜色
        UIColor *lightModeTextColor = RGBCOLOR(255, 255, 255);      // 文字颜色
        UIColor *lightModeLoadingColor = RGBCOLOR(255, 255, 255);   // loading颜色

        // 深色模式
        UIColor *darkModeBubbleColor = RGBACOLOR(60, 60, 60, 1.0); // 提示框颜色
        UIColor *darkModeTextColor = RGBCOLOR(255, 255, 255);      // 文字颜色
        UIColor *darkModeLoadingColor = RGBCOLOR(255, 255, 255);   // loading颜色
        if (@available(iOS 13.0, *)) {
            self.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.bezelView.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor *_Nonnull (UITraitCollection *_Nonnull traitCollection) {
                if (UIUserInterfaceStyleDark == traitCollection.userInterfaceStyle) {
                    return darkModeBubbleColor;
                }
                return lightModeBubbleColor;
            }];
            self.contentColor = [UIColor colorWithDynamicProvider:^UIColor *_Nonnull (UITraitCollection *_Nonnull traitCollection) {
                if (UIUserInterfaceStyleDark == traitCollection.userInterfaceStyle) {
                    return darkModeTextColor;
                }
                return lightModeTextColor;
            }];
            self.activityIndicator.color = [UIColor colorWithDynamicProvider:^UIColor *_Nonnull (UITraitCollection *_Nonnull traitCollection) {
                if (UIUserInterfaceStyleDark == traitCollection.userInterfaceStyle) {
                    return darkModeLoadingColor;
                }
                return lightModeLoadingColor;
            }];
        } else {
            self.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.bezelView.backgroundColor = lightModeBubbleColor;
            self.contentColor = lightModeTextColor;
            self.activityIndicator.color = lightModeLoadingColor;
        }
    }
}

@end
