//
//  UIView+LoadingPrompt.m
//  ennew
//
//  Created by jia on 15/7/24.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "UIView+LoadingPrompt.h"

#if UIViewLoadingPromptEnabled
#import <objc/runtime.h>
#import "LoadingView.h"
#import "UIColor+Extension.h"
#import "NSObject+Swizzle.h"

@implementation UIView (LoadingPrompt)

#pragma mark - Properties
- (void)setSubviewOfLoadingView:(UIView *)subviewOfLoadingView
{
    objc_setAssociatedObject(self, @selector(subviewOfLoadingView), subviewOfLoadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)subviewOfLoadingView
{
    return objc_getAssociatedObject(self, @selector(subviewOfLoadingView));
}

- (void)setSubviewOfPromptView:(UIView *)subviewOfPromptView
{
    objc_setAssociatedObject(self, @selector(subviewOfPromptView), subviewOfPromptView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)subviewOfPromptView
{
    return objc_getAssociatedObject(self, @selector(subviewOfPromptView));
}

#pragma mark - Swizzle
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:NSSelectorFromString(@"willRemoveSubview:") withSelector:@selector(uiview_willRemoveSubview:)];
    });
}

- (void)uiview_willRemoveSubview:(UIView *)subview
{
    if ([subview isEqual:self.subviewOfLoadingView]) {
        self.subviewOfLoadingView = nil;
    } else if ([subview isEqual:self.subviewOfPromptView]) {
        self.subviewOfPromptView = nil;
    }

    [self uiview_willRemoveSubview:subview];
}

#pragma mark - Tools
- (void)showLoadingViewWithText:(NSString *)text
{
    if (!self.subviewOfLoadingView) {
        self.subviewOfLoadingView = [[LoadingView alloc] initWithSize:self.bounds.size];
    }

    [(LoadingView *)self.subviewOfLoadingView showLoadingText:text inView:self];
}

- (void)hideLoadingView
{
    if (self.subviewOfLoadingView) {
        [(LoadingView *)self.subviewOfLoadingView hide];
    }
}

- (void)showPromptWithMessage:(NSString *)message
{
    if (!self.subviewOfPromptView) {
        self.subviewOfPromptView = [[LoadingView alloc] initWithSize:self.bounds.size];
    }

    [(LoadingView *)self.subviewOfPromptView showLoadingText:message inView:self];
}

@end
#endif
