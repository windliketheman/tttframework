//
//  NSString+Directories.m
//  TTTFramework
//
//  Created by jia on 16/4/15.
//  Copyright © 2016年 jia. All rights reserved.
//

#import "NSString+Directories.h"

@implementation NSString (Directories)

// 系统Documents目录
+ (NSString *)systemDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

// 系统Documents目录
- (NSString *)systemDocumentsDirectory
{
    return [[self class] systemDocumentsDirectory];
}

@end
