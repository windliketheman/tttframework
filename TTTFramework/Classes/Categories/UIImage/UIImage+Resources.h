//
//  UIImage+Resources.h
//  UIFramework
//
//  Created by jia on 2016/11/8.
//  Copyright © 2016年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resources)

+ (UIImage *)imageNamed:(NSString *)imageName inAssets:(NSString *)assetsName ofBundle:(NSString *)bundleName;

@end
