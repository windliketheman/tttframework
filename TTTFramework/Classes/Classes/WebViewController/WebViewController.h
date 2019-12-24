//
//  WebViewController.h
//  Family
//
//  Created by jia on 15/8/19.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UIViewController+.h"

@protocol WebViewLoadDataDelegate <NSObject>
- (BOOL)loadData;
- (BOOL)validateRequestURL:(NSURL *)requestURL;
@end

@interface WebViewController : UIViewController <UIWebViewDelegate, WebViewLoadDataDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSString *fileURL;
@property (nonatomic, strong) NSString *htmlString;

// this class always return YES, subclass must to override, not using:(.customizedEnabled = ?).
- (BOOL)customizedEnabled;

- (BOOL)isLocalFile;

@end
