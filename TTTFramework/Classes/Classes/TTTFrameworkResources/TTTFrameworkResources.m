//
//  TTTFrameworkResources.m
//  TTTFramework
//
//  Created by jia on 2019/7/22.
//

#import "TTTFrameworkResources.h"
#import <objc/runtime.h>

NSString *const TTTFrameworkResourcesBundleName = @"TTTFramework";

@implementation TTTFrameworkResources

+ (NSBundle *)frameworkBundle
{
    NSString *bundleName = TTTFrameworkResourcesBundleName;
    
    NSBundle *podBundle = [NSBundle bundleForClass:self.class];
    NSString *bundlePath = [podBundle pathForResource:bundleName ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

+ (void)setCurrentLanguage:(NSString *)currentLanguage
{
    // 因为类名不同，self也就是不用的类名，数据会绑定到不同的类上，这里只想唯一绑定一次，不能用self，全用UIViewController
    objc_setAssociatedObject(self.class, @selector(currentLanguage), currentLanguage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSString *)currentLanguage
{
    NSString *currentLanguage = objc_getAssociatedObject(self.class, @selector(currentLanguage));
    if (currentLanguage.length > 0) {
        return currentLanguage;
    }

    NSBundle *mainBundle = NSBundle.mainBundle;
    NSString *preferredLocalization = mainBundle.preferredLocalizations.firstObject;
    if (preferredLocalization.length == 0) {
        preferredLocalization = [NSBundle preferredLocalizationsFromArray:mainBundle.localizations forPreferences:NSLocale.preferredLanguages].firstObject;
    }

    if ([preferredLocalization hasPrefix:@"zh"]) {
        if ([preferredLocalization rangeOfString:@"Hans" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            currentLanguage = @"zh-Hans";
        } else {
            currentLanguage = @"zh-Hant";
        }
    } else if ([preferredLocalization hasPrefix:@"en"]) {
        currentLanguage = @"en";
    } else {
        currentLanguage = preferredLocalization;
    }

    if (currentLanguage.length == 0) {
        currentLanguage = @"en";
    }

    self.currentLanguage = currentLanguage;
    return currentLanguage;
}

+ (UIImage *)imageNamed:(NSString *)imageName inAssets:(NSString *)assetsName
{
    NSBundle *bundle = [self frameworkBundle];
    
    if (bundle) {
        // NSLog(@"Testing Framework 里bundle path: %@", [libBundle resourcePath]);
        
        NSString *path = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xcassets", assetsName]];
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.imageset", imageName]];
        path = [path stringByAppendingPathComponent:imageName];
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        
        // NSLog(@"Testing Framework image size: %f, %f", image.size.width, image.size.height);
        return image;
    }
    return nil;
}

@end
