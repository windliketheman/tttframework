//
//  UIButton+ImageWithColor.m
//  UIFramework
//
//  Created by jia on 2017/4/27.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "UIButton+ImageWithColor.h"
#import "UIImage+Extension.h"
#import "UIColor+Extension.h"

@implementation UIButton (ImageWithColor)

- (void)setImage:(UIImage *)image withColor:(UIColor *)color
{
    self.imageView.backgroundColor = [UIColor clearColor];
    
    [self setImage:[image imageWithTintColor:color] forState:UIControlStateNormal];
    [self setImage:[image imageWithTintColor:color.highlightedColor] forState:UIControlStateHighlighted];
    [self setImage:[image imageWithTintColor:color.disabledColor] forState:UIControlStateDisabled];
}

- (void)setImageColor:(UIColor *)color
{
    [self setImage:[[self imageForState:UIControlStateNormal] imageWithTintColor:color] forState:UIControlStateNormal];
    [self setImage:[[self imageForState:UIControlStateHighlighted] imageWithTintColor:color] forState:UIControlStateHighlighted];
    [self setImage:[[self imageForState:UIControlStateDisabled] imageWithTintColor:color] forState:UIControlStateDisabled];
}

- (void)setTitle:(NSString *)title withColor:(UIColor *)color
{
    [self setTitle:title forState:UIControlStateNormal];
    
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color.highlightedColor forState:UIControlStateHighlighted];
    [self setTitleColor:color.disabledColor forState:UIControlStateDisabled];
}

@end
