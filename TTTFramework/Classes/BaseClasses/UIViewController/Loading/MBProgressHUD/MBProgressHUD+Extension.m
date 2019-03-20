//
//  MBProgressHUD+Extension.m
//  TTTFramework
//
//  Created by jia on 16/5/6.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "MBProgressHUD+Extension.h"
#import "UIFrameworkCommonDefines.h"

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
    for (UIActivityIndicatorView *view in self.bezelView.subviews)
    {
        if ([view isKindOfClass:UIActivityIndicatorView.class])
        {
            return view;
        }
    }
    return nil;
}

- (void)setMBProgressHUDLook:(MBProgressHUDTheme)look
{
    if (MBProgressHUDThemePure == look)
    {
        self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        self.bezelView.backgroundColor = nil;        // 提示框颜色
        self.contentColor = RGBCOLOR(255, 255, 255); // 文字颜色
        self.activityIndicator.color = nil;          // loading颜色
    }
    else if (MBProgressHUDThemeLight == look)
    {
        self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        self.bezelView.backgroundColor = RGBACOLOR(255, 255, 255, 0.8);
        self.contentColor = RGBCOLOR(45, 45, 45);
        self.activityIndicator.color = RGBCOLOR(45, 45, 45);
    }
    else
    {
        self.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        self.bezelView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
        self.contentColor = RGBCOLOR(255, 255, 255);
        self.activityIndicator.color = RGBCOLOR(255, 255, 255);
    }
}

@end
