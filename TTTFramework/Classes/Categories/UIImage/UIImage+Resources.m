//
//  UIImage+Resources.m
//  UIFramework
//
//  Created by jia on 2016/11/8.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "UIImage+Resources.h"

@implementation UIImage (Resources)

+ (UIImage *)imageNamed:(NSString *)imageName inAssets:(NSString *)assetsName ofBundle:(NSString *)bundleName
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSBundle *libBundle = [NSBundle bundleWithPath:[mainBundle.resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle", bundleName]]];
    
    if (libBundle)
    {
        // NSLog(@"Testing Framework 里bundle path: %@", [libBundle resourcePath]);
        
        NSString *path = [[libBundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xcassets", assetsName]];
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.imageset", imageName]];
        path = [path stringByAppendingPathComponent:imageName];
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        // NSLog(@"Testing Framework image size: %f, %f", image.size.width, image.size.height);
        return image;
    }
    return nil;
}

@end
