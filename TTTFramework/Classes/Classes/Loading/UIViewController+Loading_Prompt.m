//
//  UIViewController+Loading_Prompt.m
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UIViewController+Loading_Prompt.h"
#import "UIViewController+Global.h"
#import "UIViewController+LoadingSuperView.h"
#import <objc/runtime.h>

typedef NS_ENUM (NSInteger, LoadingPromptVisualStyle)
{
    LoadingPromptVisualStyleLoading = 0,
    LoadingPromptVisualStyleInfo,
    LoadingPromptVisualStyleSuccess,
    LoadingPromptVisualStyleFailure,
};

@interface UIViewControllerLoadingPromptCardView : UIView

@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *graphicContainerView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSLayoutConstraint *titleWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *graphicTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *graphicCenterYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *titleTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *titleBottomConstraint;
@property (nonatomic, assign) CGFloat currentIndicatorScale;

- (void)configureWithText:(NSString *)text
              visualStyle:(LoadingPromptVisualStyle)visualStyle
                    theme:(LoadingPromptTheme)theme
                     font:(UIFont *)font
             maxTextWidth:(CGFloat)maxTextWidth
       indicatorScaleHint:(CGFloat)indicatorScaleHint;

- (CGSize)preferredCardSize;
- (CGAffineTransform)activityIndicatorBaseTransform;
- (BOOL)usesPadLayout;

@end

@interface UIViewControllerLoadingPromptOverlayView : UIView

@property (nonatomic, strong) UIViewControllerLoadingPromptCardView *cardView;
@property (nonatomic, assign) BOOL blocksUserInteraction;
@property (nonatomic, strong) NSLayoutConstraint *cardWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *cardHeightConstraint;
@property (nonatomic, assign) BOOL transitionAnimating;

- (void)configureWithText:(NSString *)text
              visualStyle:(LoadingPromptVisualStyle)visualStyle
                    theme:(LoadingPromptTheme)theme
                     font:(UIFont *)font
             maxTextWidth:(CGFloat)maxTextWidth
       indicatorScaleHint:(CGFloat)indicatorScaleHint;

- (void)showAnimated:(BOOL)animated;
- (void)transitionToText:(NSString *)text
             visualStyle:(LoadingPromptVisualStyle)visualStyle
                   theme:(LoadingPromptTheme)theme
                    font:(UIFont *)font
            maxTextWidth:(CGFloat)maxTextWidth
      indicatorScaleHint:(CGFloat)indicatorScaleHint
                animated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

@end

@implementation UIViewControllerLoadingPromptCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];

        UIVisualEffect *effect = nil;
        UIColor *cardBackgroundColor = nil;
        if (@available(iOS 26.0, *))
        {
            effect = [UIGlassEffect effectWithStyle:UIGlassEffectStyleRegular];
            cardBackgroundColor = [UIColor clearColor];
        }
        else if (@available(iOS 13.0, *))
        {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThickMaterial];
            cardBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.08];
        }
        else
        {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
            cardBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.08];
        }

        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.translatesAutoresizingMaskIntoConstraints = NO;
        _effectView.clipsToBounds = YES;
        _effectView.layer.cornerRadius = 22.0;
        if (@available(iOS 13.0, *))
        {
            _effectView.layer.cornerCurve = kCACornerCurveContinuous;
        }
        _effectView.contentView.backgroundColor = cardBackgroundColor;
        [self addSubview:_effectView];

        _graphicContainerView = [[UIView alloc] init];
        _graphicContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        _graphicContainerView.userInteractionEnabled = NO;
        _graphicContainerView.layer.cornerRadius = 28.0;
        [_effectView.contentView addSubview:_graphicContainerView];

        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        if (@available(iOS 13.0, *))
        {
            _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
        }
        else
        {
            _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        }
        [_graphicContainerView addSubview:_activityIndicatorView];

        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_graphicContainerView addSubview:_iconImageView];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_effectView.contentView addSubview:_titleLabel];

        self.titleWidthConstraint = [_titleLabel.widthAnchor constraintEqualToConstant:220.0];
        self.titleWidthConstraint.active = YES;

        self.graphicTopConstraint = [_graphicContainerView.topAnchor constraintEqualToAnchor:_effectView.contentView.topAnchor constant:24.0];
        self.graphicCenterYConstraint = [_graphicContainerView.centerYAnchor constraintEqualToAnchor:_effectView.contentView.centerYAnchor];
        self.titleTopConstraint = [_titleLabel.topAnchor constraintEqualToAnchor:_graphicContainerView.bottomAnchor constant:14.0];
        self.titleBottomConstraint = [_titleLabel.bottomAnchor constraintEqualToAnchor:_effectView.contentView.bottomAnchor constant:-24.0];

        [NSLayoutConstraint activateConstraints:@[
            [_effectView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [_effectView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [_effectView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [_effectView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

            [_graphicContainerView.centerXAnchor constraintEqualToAnchor:_effectView.contentView.centerXAnchor],
            [_graphicContainerView.widthAnchor constraintEqualToConstant:56.0],
            [_graphicContainerView.heightAnchor constraintEqualToConstant:56.0],
            self.graphicTopConstraint,

            [_activityIndicatorView.centerXAnchor constraintEqualToAnchor:_graphicContainerView.centerXAnchor],
            [_activityIndicatorView.centerYAnchor constraintEqualToAnchor:_graphicContainerView.centerYAnchor],

            [_iconImageView.centerXAnchor constraintEqualToAnchor:_graphicContainerView.centerXAnchor],
            [_iconImageView.centerYAnchor constraintEqualToAnchor:_graphicContainerView.centerYAnchor],
            [_iconImageView.widthAnchor constraintEqualToConstant:30.0],
            [_iconImageView.heightAnchor constraintEqualToConstant:30.0],

            self.titleTopConstraint,
            [_titleLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:_effectView.contentView.leadingAnchor constant:24.0],
            [_titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:_effectView.contentView.trailingAnchor constant:-24.0],
            [_titleLabel.centerXAnchor constraintEqualToAnchor:_effectView.contentView.centerXAnchor],
            self.titleBottomConstraint
        ]];
    }
    return self;
}

- (void)configureWithText:(NSString *)text
              visualStyle:(LoadingPromptVisualStyle)visualStyle
                    theme:(LoadingPromptTheme)theme
                     font:(UIFont *)font
             maxTextWidth:(CGFloat)maxTextWidth
       indicatorScaleHint:(CGFloat)indicatorScaleHint
{
    self.titleLabel.text = text.length > 0 ? text : nil;
    self.titleLabel.hidden = (text.length == 0);
    self.titleLabel.font = font ?: [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    self.titleWidthConstraint.constant = MAX(120.0, maxTextWidth);
    self.titleLabel.preferredMaxLayoutWidth = self.titleWidthConstraint.constant;
    self.graphicTopConstraint.active = !self.titleLabel.hidden;
    self.graphicCenterYConstraint.active = self.titleLabel.hidden;
    self.titleTopConstraint.active = !self.titleLabel.hidden;
    self.titleBottomConstraint.active = !self.titleLabel.hidden;

    UIColor *cardTextColor = [self cardTextColorForTheme:theme];
    UIColor *accentColor = [self accentColorForVisualStyle:visualStyle theme:theme];
    self.titleLabel.textColor = cardTextColor;
    self.graphicContainerView.backgroundColor = [accentColor colorWithAlphaComponent:(visualStyle == LoadingPromptVisualStyleLoading) ? 0.08 : 0.10];
    self.graphicContainerView.layer.borderWidth = 0.8;
    self.graphicContainerView.layer.borderColor = [accentColor colorWithAlphaComponent:0.08].CGColor;

    self.activityIndicatorView.hidden = (visualStyle != LoadingPromptVisualStyleLoading);
    self.iconImageView.hidden = !self.activityIndicatorView.hidden;

    if (visualStyle == LoadingPromptVisualStyleLoading)
    {
        CGFloat indicatorScale = indicatorScaleHint > 0.0 ? indicatorScaleHint : 1.0;
        self.currentIndicatorScale = 0.82 * indicatorScale;
        self.activityIndicatorView.transform = [self activityIndicatorBaseTransform];
        self.activityIndicatorView.color = accentColor;
        [self.activityIndicatorView startAnimating];
        self.iconImageView.image = nil;
    }
    else
    {
        self.currentIndicatorScale = 1.0;
        [self.activityIndicatorView stopAnimating];
        self.iconImageView.tintColor = accentColor;
        if (@available(iOS 13.0, *))
        {
            NSString *imageName = @"exclamationmark.circle.fill";
            if (visualStyle == LoadingPromptVisualStyleSuccess)
            {
                imageName = @"checkmark.circle.fill";
            }
            else if (visualStyle == LoadingPromptVisualStyleFailure)
            {
                imageName = @"xmark.circle.fill";
            }
            self.iconImageView.image = [UIImage systemImageNamed:imageName];
        }
        else
        {
            self.iconImageView.image = nil;
        }
    }

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGSize)preferredCardSize
{
    CGFloat titleWidth = self.titleWidthConstraint.constant;
    CGFloat horizontalInset = self.usesPadLayout ? 30.0 : 24.0;
    CGFloat topInset = self.usesPadLayout ? 28.0 : 24.0;
    CGFloat bottomInset = self.usesPadLayout ? 28.0 : 24.0;
    CGFloat titleSpacing = self.usesPadLayout ? 16.0 : 14.0;
    CGFloat minimumCardSide = self.usesPadLayout ? 118.0 : 104.0;
    CGFloat cardWidth = self.titleLabel.hidden ? minimumCardSide : (titleWidth + horizontalInset * 2.0);
    CGFloat titleHeight = 0.0;
    if (!self.titleLabel.hidden) {
        CGSize fittingSize = [self.titleLabel sizeThatFits:CGSizeMake(titleWidth, CGFLOAT_MAX)];
        titleHeight = ceil(fittingSize.height);
    }
    CGFloat cardHeight = self.titleLabel.hidden ? minimumCardSide : (topInset + 56.0 + titleSpacing + titleHeight + bottomInset);
    return CGSizeMake(ceil(cardWidth), ceil(MAX(cardHeight, minimumCardSide)));
}

- (CGAffineTransform)activityIndicatorBaseTransform
{
    return CGAffineTransformMakeScale(self.currentIndicatorScale > 0.0 ? self.currentIndicatorScale : 1.0,
                                      self.currentIndicatorScale > 0.0 ? self.currentIndicatorScale : 1.0);
}

- (BOOL)usesPadLayout
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (UIColor *)cardTextColorForTheme:(LoadingPromptTheme)theme
{
    if (theme == LoadingPromptThemeDark)
    {
        return [UIColor whiteColor];
    }

    if (@available(iOS 13.0, *))
    {
        return [UIColor labelColor];
    }
    return [UIColor colorWithWhite:0.08 alpha:1.0];
}

- (UIColor *)accentColorForVisualStyle:(LoadingPromptVisualStyle)visualStyle
                                 theme:(LoadingPromptTheme)theme
{
    switch (visualStyle)
    {
        case LoadingPromptVisualStyleSuccess:
            if (@available(iOS 13.0, *))
            {
                return [UIColor systemGreenColor];
            }
            return [UIColor colorWithRed:0.20 green:0.67 blue:0.35 alpha:1.0];
        case LoadingPromptVisualStyleFailure:
            if (@available(iOS 13.0, *))
            {
                return [UIColor systemRedColor];
            }
            return [UIColor colorWithRed:0.88 green:0.22 blue:0.21 alpha:1.0];
        case LoadingPromptVisualStyleInfo:
            if (@available(iOS 13.0, *))
            {
                return [UIColor secondaryLabelColor];
            }
            return [UIColor colorWithWhite:0.35 alpha:1.0];
        case LoadingPromptVisualStyleLoading:
        default:
            if (theme == LoadingPromptThemeDark)
            {
                return [UIColor whiteColor];
            }
            if (@available(iOS 13.0, *))
            {
                return [UIColor labelColor];
            }
            return [UIColor colorWithWhite:0.12 alpha:1.0];
    }
}

@end

@implementation UIViewControllerLoadingPromptOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.alpha = 0.0;

        _cardView = [[UIViewControllerLoadingPromptCardView alloc] initWithFrame:CGRectZero];
        [self addSubview:_cardView];
        
        self.cardWidthConstraint = [_cardView.widthAnchor constraintEqualToConstant:180.0];
        self.cardHeightConstraint = [_cardView.heightAnchor constraintEqualToConstant:140.0];
        
        [NSLayoutConstraint activateConstraints:@[
            [_cardView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [_cardView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            self.cardWidthConstraint,
            self.cardHeightConstraint
        ]];
    }
    return self;
}

- (void)configureWithText:(NSString *)text
              visualStyle:(LoadingPromptVisualStyle)visualStyle
                    theme:(LoadingPromptTheme)theme
                     font:(UIFont *)font
             maxTextWidth:(CGFloat)maxTextWidth
       indicatorScaleHint:(CGFloat)indicatorScaleHint
{
    [self.cardView configureWithText:text
                         visualStyle:visualStyle
                               theme:theme
                                font:font
                        maxTextWidth:maxTextWidth
                  indicatorScaleHint:indicatorScaleHint];
    CGSize preferredSize = [self.cardView preferredCardSize];
    self.cardWidthConstraint.constant = preferredSize.width;
    self.cardHeightConstraint.constant = preferredSize.height;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setBlocksUserInteraction:(BOOL)blocksUserInteraction
{
    _blocksUserInteraction = blocksUserInteraction;
    self.userInteractionEnabled = blocksUserInteraction;
}

- (void)showAnimated:(BOOL)animated
{
    [self.layer removeAllAnimations];
    [self.cardView.layer removeAllAnimations];

    if (!animated)
    {
        self.alpha = 1.0;
        self.cardView.alpha = 1.0;
        self.cardView.transform = CGAffineTransformIdentity;
        return;
    }

    self.alpha = 1.0;
    self.cardView.alpha = 0.0;
    self.cardView.transform = CGAffineTransformMakeScale(0.96, 0.96);
    [UIView animateWithDuration:0.28
                          delay:0.0
         usingSpringWithDamping:0.78
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        self.cardView.alpha = 1.0;
        self.cardView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)transitionToText:(NSString *)text
             visualStyle:(LoadingPromptVisualStyle)visualStyle
                   theme:(LoadingPromptTheme)theme
                    font:(UIFont *)font
            maxTextWidth:(CGFloat)maxTextWidth
      indicatorScaleHint:(CGFloat)indicatorScaleHint
                animated:(BOOL)animated
{
    if (self.transitionAnimating)
    {
        [self.cardView.layer removeAllAnimations];
        [self.cardView.effectView.contentView.layer removeAllAnimations];
        [self.cardView.titleLabel.layer removeAllAnimations];
        [self.cardView.graphicContainerView.layer removeAllAnimations];
        [self.cardView.activityIndicatorView.layer removeAllAnimations];
        [self.cardView.iconImageView.layer removeAllAnimations];
    }

    [self.layer removeAllAnimations];
    [self.cardView.layer removeAllAnimations];
    [self.cardView.effectView.layer removeAllAnimations];
    [self.cardView.effectView.contentView.layer removeAllAnimations];
    [self.cardView.titleLabel.layer removeAllAnimations];
    [self.cardView.graphicContainerView.layer removeAllAnimations];
    [self.cardView.activityIndicatorView.layer removeAllAnimations];
    [self.cardView.iconImageView.layer removeAllAnimations];

    void (^applyState)(void) = ^{
        [self.cardView configureWithText:text
                             visualStyle:visualStyle
                                   theme:theme
                                    font:font
                            maxTextWidth:maxTextWidth
                      indicatorScaleHint:indicatorScaleHint];
        CGSize preferredSize = [self.cardView preferredCardSize];
        self.cardWidthConstraint.constant = preferredSize.width;
        self.cardHeightConstraint.constant = preferredSize.height;
    };

    if (!animated)
    {
        applyState();
        self.alpha = 1.0;
        self.cardView.alpha = 1.0;
        self.cardView.transform = CGAffineTransformIdentity;
        [self setNeedsLayout];
        [self layoutIfNeeded];
        return;
    }

    self.transitionAnimating = YES;
    self.alpha = 1.0;
    self.cardView.alpha = 1.0;
    self.cardView.transform = CGAffineTransformIdentity;

    BOOL hadTitle = !self.cardView.titleLabel.hidden;
    BOOL willHaveTitle = (text.length > 0);
    BOOL isLoadingTarget = (visualStyle == LoadingPromptVisualStyleLoading);
    BOOL wasLoading = !self.cardView.activityIndicatorView.hidden;

    UILabel *titleLabel = self.cardView.titleLabel;
    UIView *graphicContainerView = self.cardView.graphicContainerView;
    UIActivityIndicatorView *activityIndicatorView = self.cardView.activityIndicatorView;
    UIImageView *iconImageView = self.cardView.iconImageView;

    titleLabel.transform = CGAffineTransformIdentity;
    graphicContainerView.transform = CGAffineTransformIdentity;
    activityIndicatorView.transform = CGAffineTransformScale([self.cardView activityIndicatorBaseTransform], 0.92, 0.92);
    iconImageView.transform = CGAffineTransformMakeScale(0.92, 0.92);

    titleLabel.alpha = hadTitle ? 1.0 : 0.0;
    activityIndicatorView.alpha = activityIndicatorView.hidden ? 0.0 : 1.0;
    iconImageView.alpha = iconImageView.hidden ? 0.0 : 1.0;

    if (!hadTitle && willHaveTitle)
    {
        titleLabel.alpha = 0.0;
    }

    [UIView transitionWithView:self.cardView.effectView.contentView
                      duration:0.18
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                    animations:^{
        applyState();
    } completion:nil];

    titleLabel.alpha = hadTitle ? 0.55 : 0.0;
    titleLabel.transform = CGAffineTransformIdentity;
    graphicContainerView.transform = CGAffineTransformMakeScale(0.94, 0.94);
    self.cardView.transform = CGAffineTransformMakeScale(0.99, 0.99);

    if (isLoadingTarget)
    {
        activityIndicatorView.alpha = 0.0;
        activityIndicatorView.transform = CGAffineTransformScale([self.cardView activityIndicatorBaseTransform], 0.84, 0.84);
    }
    else
    {
        iconImageView.alpha = 0.0;
        iconImageView.transform = CGAffineTransformMakeScale(wasLoading ? 0.90 : 0.92, wasLoading ? 0.90 : 0.92);
    }

    [UIView animateWithDuration:0.30
                          delay:0.0
         usingSpringWithDamping:0.86
          initialSpringVelocity:0.45
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        [self layoutIfNeeded];
        self.cardView.transform = CGAffineTransformIdentity;
        titleLabel.alpha = willHaveTitle ? 1.0 : 0.0;
        titleLabel.transform = CGAffineTransformIdentity;
        graphicContainerView.transform = CGAffineTransformIdentity;
        activityIndicatorView.alpha = activityIndicatorView.hidden ? 0.0 : 1.0;
        activityIndicatorView.transform = [self.cardView activityIndicatorBaseTransform];
        iconImageView.alpha = iconImageView.hidden ? 0.0 : 1.0;
        iconImageView.transform = CGAffineTransformMakeScale(isLoadingTarget ? 1.0 : 1.03, isLoadingTarget ? 1.0 : 1.03);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.14
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:^{
            iconImageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL innerFinished) {
            self.transitionAnimating = NO;
            titleLabel.alpha = titleLabel.hidden ? 0.0 : 1.0;
            titleLabel.transform = CGAffineTransformIdentity;
            graphicContainerView.transform = CGAffineTransformIdentity;
            activityIndicatorView.alpha = activityIndicatorView.hidden ? 0.0 : 1.0;
            activityIndicatorView.transform = [self.cardView activityIndicatorBaseTransform];
            iconImageView.alpha = iconImageView.hidden ? 0.0 : 1.0;
            iconImageView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)hideAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion
{
    [self.layer removeAllAnimations];
    [self.cardView.layer removeAllAnimations];

    if (!animated)
    {
        [self removeFromSuperview];
        if (completion)
        {
            completion();
        }
        return;
    }

    [UIView animateWithDuration:0.18
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.cardView.alpha = 0.0;
        self.cardView.transform = CGAffineTransformMakeScale(0.96, 0.96);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion)
        {
            completion();
        }
    }];
}

@end

@implementation UIViewController (Loading_Prompt)

+ (void)setLoadingPromptTheme:(LoadingPromptTheme)loadingPromptTheme
{
    objc_setAssociatedObject(self.global, @selector(loadingPromptTheme), @(loadingPromptTheme), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (LoadingPromptTheme)loadingPromptTheme
{
    NSNumber *loadingPromptTheme = objc_getAssociatedObject(self.global, @selector(loadingPromptTheme));
    if (loadingPromptTheme != nil)
    {
        return loadingPromptTheme.integerValue;
    }
    return LoadingPromptThemeLight;
}

+ (void)setLoadingIndicatorTransformScale:(CGFloat)loadingIndicatorTransformScale
{
    objc_setAssociatedObject(self.global, @selector(loadingIndicatorTransformScale), @(loadingIndicatorTransformScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)loadingIndicatorTransformScale
{
    NSNumber *loadingIndicatorTransformScale = objc_getAssociatedObject(self.global, @selector(loadingIndicatorTransformScale));
    if (loadingIndicatorTransformScale != nil)
    {
        return loadingIndicatorTransformScale.floatValue;
    }
    return 1.0;
}

+ (void)setPromptTimeInterval:(CGFloat)promptTimeInterval
{
    objc_setAssociatedObject(self.global, @selector(promptTimeInterval), @(promptTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)setLoadingPromptTitleFont:(UIFont *)loadingPromptTitleFont
{
    objc_setAssociatedObject(self.global, @selector(loadingPromptTitleFont), loadingPromptTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIFont *)loadingPromptTitleFont
{
    UIFont *loadingPromptTitleFont = objc_getAssociatedObject(self.global, @selector(loadingPromptTitleFont));
    if (loadingPromptTitleFont)
    {
        return loadingPromptTitleFont;
    }
    return [UIFont boldSystemFontOfSize:14.0];
}

+ (void)setLoadingPromptMargin:(CGFloat)loadingPromptMargin
{
    objc_setAssociatedObject(self.global, @selector(loadingPromptMargin), @(loadingPromptMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)loadingPromptMargin
{
    NSNumber *loadingPromptMargin = objc_getAssociatedObject(self.global, @selector(loadingPromptMargin));
    if (loadingPromptMargin != nil)
    {
        return loadingPromptMargin.floatValue;
    }
    return 20.0;
}

+ (void)setLoadingPromptCornerRadius:(CGFloat)loadingPromptCornerRadius
{
    objc_setAssociatedObject(self.global, @selector(loadingPromptCornerRadius), @(loadingPromptCornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)loadingPromptCornerRadius
{
    NSNumber *loadingPromptCornerRadius = objc_getAssociatedObject(self.global, @selector(loadingPromptCornerRadius));
    if (loadingPromptCornerRadius != nil)
    {
        return loadingPromptCornerRadius.floatValue;
    }
    return 6.0;
}

+ (CGFloat)promptTimeInterval
{
    NSNumber *promptTimeInterval = objc_getAssociatedObject(self.global, @selector(promptTimeInterval));
    if (promptTimeInterval != nil)
    {
        return promptTimeInterval.floatValue;
    }
    return 1.5;
}

- (void)setPreferredLoadingPromptTheme:(LoadingPromptTheme)preferredLoadingPromptTheme
{
    objc_setAssociatedObject(self, @selector(preferredLoadingPromptTheme), @(preferredLoadingPromptTheme), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LoadingPromptTheme)preferredLoadingPromptTheme
{
    NSNumber *preferredLoadingPromptTheme = objc_getAssociatedObject(self, @selector(preferredLoadingPromptTheme));
    if (preferredLoadingPromptTheme != nil)
    {
        return preferredLoadingPromptTheme.integerValue;
    }
    return UIViewController.global.loadingPromptTheme;
}

- (void)setPreferredPromptTimeInterval:(CGFloat)preferredPromptTimeInterval
{
    objc_setAssociatedObject(self, @selector(preferredPromptTimeInterval), @(preferredPromptTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)preferredPromptTimeInterval
{
    NSNumber *preferredPromptTimeInterval = objc_getAssociatedObject(self, @selector(preferredPromptTimeInterval));
    if (preferredPromptTimeInterval != nil)
    {
        return preferredPromptTimeInterval.floatValue;
    }
    return UIViewController.global.promptTimeInterval;
}

- (void)setHideDelayTimer:(NSTimer *)hideDelayTimer
{
    if (self.hideDelayTimer)
    {
        [self.hideDelayTimer invalidate];
    }
    objc_setAssociatedObject(self, @selector(hideDelayTimer), hideDelayTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)hideDelayTimer
{
    return objc_getAssociatedObject(self, @selector(hideDelayTimer));
}

- (void)setLoadingDate:(NSDate *)loadingDate
{
    objc_setAssociatedObject(self, @selector(loadingDate), loadingDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)loadingDate
{
    return objc_getAssociatedObject(self, @selector(loadingDate));
}

#pragma mark - Outter Methods
- (void)showLoading
{
    [self showLoading:nil inView:self.loadingSuperView];
}

- (void)showLoading:(NSString *)loadingText
{
    [self showLoading:loadingText inView:self.loadingSuperView];
}

- (void)showLoadingInView:(UIView *)view
{
    [self showLoading:nil inView:view];
}

- (void)showLoading:(NSString *)loadingText inView:(UIView *)view
{
    if (NSThread.currentThread.isMainThread)
    {
        [self showLoadingWithText:loadingText inView:view];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoadingWithText:loadingText inView:view];
        });
    }
}

- (void)hideLoading
{
    if (NSThread.currentThread.isMainThread)
    {
        [self hideLoadingView];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingView];
        });
    }
}

- (BOOL)isShowingLoading
{
    return self.HUD.superview != nil;
}

- (void)promptMessage:(NSString *)message
{
    if (!message || ![message isKindOfClass:NSString.class] || [message isEqualToString:@""])
    {
        return;
    }

    [self promptMessage:message inView:self.loadingSuperView];
}

- (void)promptSuccessMessage:(NSString *)message
{
    [self promptSuccessMessage:message inView:self.loadingSuperView];
}

- (void)promptSuccessMessage:(NSString *)message inView:(UIView *)view
{
    [self showPromptMessage:message visualStyle:LoadingPromptVisualStyleSuccess inView:view];
}

- (void)promptFailureMessage:(NSString *)message
{
    [self promptFailureMessage:message inView:self.loadingSuperView];
}

- (void)promptFailureMessage:(NSString *)message inView:(UIView *)view
{
    [self showPromptMessage:message visualStyle:LoadingPromptVisualStyleFailure inView:view];
}

- (void)promptInfoMessage:(NSString *)message
{
    [self promptInfoMessage:message inView:self.loadingSuperView];
}

- (void)promptInfoMessage:(NSString *)message inView:(UIView *)view
{
    [self showPromptMessage:message visualStyle:LoadingPromptVisualStyleInfo inView:view];
}

- (void)promptMessage:(NSString *)message inView:(UIView *)view
{
    [self showPromptMessage:message visualStyle:[self promptVisualStyleForMessage:message] inView:view];
}

- (void)showPromptMessage:(NSString *)message
              visualStyle:(LoadingPromptVisualStyle)visualStyle
                   inView:(UIView *)view
{
    if (!message || ![message isKindOfClass:NSString.class] || [message isEqualToString:@""])
    {
        return;
    }

    if (NSThread.currentThread.isMainThread)
    {
        [self showPromptWithText:message visualStyle:visualStyle inView:view];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showPromptWithText:message visualStyle:visualStyle inView:view];
        });
    }
}

#pragma mark - Inner Methods
const char HUDKey;
- (void)setHUD:(UIView *)hud
{
    objc_setAssociatedObject(self, &HUDKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)HUD
{
    return objc_getAssociatedObject(self, &HUDKey);
}

- (void)showLoadingWithText:(NSString *)text inView:(UIView *)view
{
    [self doExtraWhenShowLoading];

    self.hideDelayTimer = nil;
    [self showOverlayWithText:text inView:view autoHidden:NO];
}

- (void)showPromptWithText:(NSString *)message inView:(UIView *)view
{
    [self showPromptWithText:message visualStyle:[self promptVisualStyleForMessage:message] inView:view];
}

- (void)showPromptWithText:(NSString *)message
               visualStyle:(LoadingPromptVisualStyle)visualStyle
                    inView:(UIView *)view
{
    [self doExtraWhenShowLoading];

    [self showOverlayWithText:message inView:view autoHidden:YES visualStyle:visualStyle];

    NSTimer *timer = [NSTimer timerWithTimeInterval:self.preferredPromptTimeInterval target:self selector:@selector(handleHideTimer:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.hideDelayTimer = timer;
}

- (void)showOverlayWithText:(NSString *)text inView:(UIView *)inView autoHidden:(BOOL)autoHidden
{
    [self showOverlayWithText:text inView:inView autoHidden:autoHidden visualStyle:LoadingPromptVisualStyleLoading];
}

- (void)showOverlayWithText:(NSString *)text
                     inView:(UIView *)inView
                 autoHidden:(BOOL)autoHidden
                visualStyle:(LoadingPromptVisualStyle)visualStyle
{
    UIViewControllerLoadingPromptOverlayView *overlay = (UIViewControllerLoadingPromptOverlayView *)self.HUD;
    BOOL needsNewOverlay = !overlay || ![overlay isKindOfClass:[UIViewControllerLoadingPromptOverlayView class]] || overlay.superview != inView;
    BOOL wasVisible = (overlay.superview != nil);

    if (needsNewOverlay)
    {
        if (overlay.superview)
        {
            [overlay removeFromSuperview];
        }

        overlay = [[UIViewControllerLoadingPromptOverlayView alloc] initWithFrame:inView.bounds];
        [inView addSubview:overlay];
        self.HUD = overlay;
        wasVisible = NO;
    }
    else
    {
        overlay.frame = inView.bounds;
    }

    if (!wasVisible)
    {
        self.loadingDate = [NSDate date];
        NSLog(@"[%@] %p show loading", NSStringFromClass(self.class), self);
    }

    overlay.blocksUserInteraction = YES;
    CGFloat maxTextWidth = [self preferredPromptTextWidthInView:inView];
    LoadingPromptVisualStyle resolvedVisualStyle = autoHidden ? visualStyle : LoadingPromptVisualStyleLoading;
    if (wasVisible)
    {
        [overlay transitionToText:text
                      visualStyle:resolvedVisualStyle
                            theme:self.preferredLoadingPromptTheme
                             font:self.class.loadingPromptTitleFont
                     maxTextWidth:maxTextWidth
               indicatorScaleHint:self.class.loadingIndicatorTransformScale
                         animated:YES];
    }
    else
    {
        [overlay configureWithText:text
                       visualStyle:resolvedVisualStyle
                             theme:self.preferredLoadingPromptTheme
                              font:self.class.loadingPromptTitleFont
                      maxTextWidth:maxTextWidth
                indicatorScaleHint:self.class.loadingIndicatorTransformScale];
        [overlay showAnimated:YES];
    }
}

- (CGFloat)preferredPromptTextWidthInView:(UIView *)view
{
    CGFloat containerWidth = CGRectGetWidth(view.bounds);
    if (containerWidth <= 0.0)
    {
        containerWidth = CGRectGetWidth(UIScreen.mainScreen.bounds);
    }

    CGFloat horizontalPadding = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 140.0 : 96.0;
    CGFloat maxWidth = containerWidth - horizontalPadding;
    CGFloat minimumWidth = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 180.0 : 140.0;
    CGFloat maximumWidth = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 340.0 : 260.0;
    return MIN(MAX(maxWidth, minimumWidth), maximumWidth);
}

- (LoadingPromptVisualStyle)promptVisualStyleForMessage:(NSString *)message
{
    if (message.length == 0)
    {
        return LoadingPromptVisualStyleInfo;
    }

    NSArray<NSString *> *failureKeywords = @[@"失败", @"错误", @"出错", @"异常", @"不存在", @"无效", @"为空"];
    for (NSString *keyword in failureKeywords)
    {
        if ([message containsString:keyword])
        {
            return LoadingPromptVisualStyleFailure;
        }
    }

    NSArray<NSString *> *successKeywords = @[@"成功", @"完成", @"结束", @"已拷贝", @"已开启", @"已关闭"];
    for (NSString *keyword in successKeywords)
    {
        if ([message containsString:keyword])
        {
            return LoadingPromptVisualStyleSuccess;
        }
    }

    return LoadingPromptVisualStyleInfo;
}

- (void)handleHideTimer:(NSTimer *)timer
{
    self.hideDelayTimer = nil;

    [self hideLoadingView];
}

- (void)hideLoadingView
{
    [self doExtraWhenHideLoading];

    if (self.hideDelayTimer.isValid)
    {
        [self.hideDelayTimer invalidate];
    }

    if (self.hideDelayTimer)
    {
        self.hideDelayTimer = nil;
    }

    UIViewControllerLoadingPromptOverlayView *overlay = (UIViewControllerLoadingPromptOverlayView *)self.HUD;
    if (overlay)
    {
        __weak typeof(self) weakSelf = self;
        [overlay hideAnimated:YES completion:^{
            __strong typeof(weakSelf) self = weakSelf;
            self.HUD = nil;
            NSLog(@"[%@] %p hide loading, loading time: %f", NSStringFromClass(self.class), self, [[NSDate date] timeIntervalSinceDate:self.loadingDate]);
            self.loadingDate = nil;
        }];
    }
}

@end
