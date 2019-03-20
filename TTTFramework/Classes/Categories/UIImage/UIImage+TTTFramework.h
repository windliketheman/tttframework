//
//  UIImage+TTTFramework.h
//  TTTFramework
//
//  Created by jia on 2017/7/17.
//  Copyright © 2017年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

// Framework 所依赖的资源（.bunndle）
extern NSString *const TTTFrameworkResourcesBundleName;

@interface UIImage (TTTFramework)

+ (UIImage *)imageNamed:(NSString *)imageName inAssets:(NSString *)assetsName ofBundle:(NSString *)bundleName;

@end
