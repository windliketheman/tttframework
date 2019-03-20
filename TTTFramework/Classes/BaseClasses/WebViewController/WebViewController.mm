//
//  WebViewController.m
//  Family
//
//  Created by jia on 15/8/19.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "WebViewController.h"
#import <MobileCoreServices/UTType.h>
#import "NSString+Encoding.h"

#define RotationObservingForVideoEnabled 0

@interface WebViewController ()
@property (nonatomic, readwrite) BOOL statusBarHidden;
@end

@implementation WebViewController

- (BOOL)customizedEnabled
{
    return YES;
}

#pragma mark - Life Cycle

- (void)dealloc
{
    self.webView.delegate = nil;
    self.webView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    // fix webview.scroll contentsize is too small bug.
//    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
//    [bgView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:bgView];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor whiteColor];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    self.webView = webView;
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startFullScreenObserving];
    
    if (self.isFirstTimeViewAppear)
    {
        // 加载数据
        [self loadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopFullScreenObserving];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Inner Methods
- (BOOL)loadData
{
    if (self.fileURL)
    {
        // 本地有 则用本地的
        if (self.isLocalFile)
        {
            return [self loadLocalDocument];
        }
        else
        {
            return [self loadWebPage];
        }
    }
    else if (self.htmlString)
    {
        return [self loadHTMLString];
    }
    else
    {
        // do nothing
        return NO;
    }
}

- (void)reloadData
{
    [self.webView reload];
}

- (BOOL)loadLocalDocument
{
    NSURL *url = [NSURL fileURLWithPath:self.fileURL];
    
    NSString *mimeType = [self fileMimeType:self.fileURL];
    if (mimeType)
    {
        if ([mimeType hasPrefix:@"text/"]) // txt file
        {
            if ([mimeType hasPrefix:@"text/plain"])
            {
#if 0
                NSData *data = [NSData dataWithContentsOfURL:url];
                
                // NSStringEncoding encodeing = NSUTF8StringEncoding;
                NSStringEncoding encodeing = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSString *body = [[NSString alloc] initWithData:data encoding:encodeing];
                
                // 带编码头的如utf-8等，这里会识别出来
                // NSString *body = [NSString stringWithContentsOfFile:self.fileURL usedEncoding:&useEncodeing error:nil];
                // 识别不到，按GBK编码再解码一次.这里不能先按GB18030解码，否则会出现整个文档无换行bug。
                if (!body)
                {
                    body = [NSString stringWithContentsOfFile:self.fileURL encoding:0x80000632 error:nil];
                }
                // 还是识别不到，按GB18030编码再解码一次.
                if (!body)
                {
                    body = [NSString stringWithContentsOfFile:self.fileURL encoding:0x80000631 error:nil];
                }
                
                // 展现
                if (body)
                {
                    [self.webView loadHTMLString:body baseURL: nil];
                }
                else
                {
                    NSString *urlString = [[NSBundle mainBundle] pathForAuxiliaryExecutable:self.fileURL];
                    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                    NSURL *requestUrl = [NSURL URLWithString:urlString];
                    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
                    [self.webView loadRequest:request];
                    
                }
#else
                NSData *txtData = [NSData dataWithContentsOfFile:self.fileURL];
                NSString *encoding = self.fileURL.contentTextCharSet;
                
                [self.webView loadData:txtData MIMEType:mimeType textEncodingName:encoding baseURL:[NSURL fileURLWithPath:NSBundle.mainBundle.bundlePath]]; //
#endif
            }
            else
            {
                [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
            }
        }
        else
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }
    else
    {
        // format txt to html, then load html string.
        NSData *txtData = [NSData dataWithContentsOfURL:url];
        NSString *txtString = [[NSString alloc] initWithData:txtData encoding:NSUTF8StringEncoding];
        NSString* htmlString = [NSString stringWithFormat:
                                @"<HTML>"
                                "<head>"
                                "<title>Text View</title>"
                                "</head>"
                                "<BODY>"
                                "<pre>"
                                "%@"
                                "</pre>"
                                "</BODY>"
                                "</HTML>",
                                txtString];
        [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
    
    return YES;
}

- (BOOL)loadWebPage
{
    // [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.fileURL]]];
    
    // 使用默认缓存策略
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.fileURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    [self.webView loadRequest:request];
    
    return YES;
}

- (BOOL)loadHTMLString
{
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    
    return YES;
}

- (NSString *)fileMimeType:(NSString *)fileNameOrPath
{
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[fileNameOrPath pathExtension], NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (uti, kUTTagClassMIMEType);
    
    return (__bridge NSString *)(mimeType);
}

//// API is expired.
//- (NSString *)getMimeType:(NSString *)fileAbsolutePath error:(NSError *)error
//{
//    NSString *fullPath = [fileAbsolutePath stringByExpandingTildeInPath];
//    NSURL *fileUrl = [NSURL fileURLWithPath:fullPath];
//    NSURLRequest *fileUrlRequest = [NSURLRequest requestWithURL:fileUrl];
//    NSURLResponse *response = nil;
//    [NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:&response error:&error];
//    return [response MIMEType];
//}

- (BOOL)isLocalFile
{
    return [self.fileURL isAbsolutePath];
}

#pragma mark - WebViewLoadDataDelegate
- (BOOL)validateRequestURL:(NSURL *)requestURL
{
    return YES;
}

#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSLog(@"webView shouldStartLoad: %@", url.absoluteString);

    return [self validateRequestURL:url];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (!self.isLocalFile && !self.navigationBarTitle && title)
    {
        self.navigationBarTitle = title;
    }
    
    [NSThread delaySeconds:0.1f perform:^{
        
        [self hideLoading];
    }];
    
    // 屏蔽运营商广告 开始
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('c60_fbar_buoy ng-isolate-scope')[0].style.display = 'none'"];
    // [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementById('tlbstoolbar')[0].style.display = 'none'"];
    // 屏蔽运营商广告 结束
    
//    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//    NSLog(@"%@", currentURL);
    
#if 0
    [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function myFunction() { "
     "var field = document.getElementsByName('q')[0];"
     "field.value='朱祁林';"
     "document.forms[0].submit();"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
#endif
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败");
    
    [self hideLoading];
    
    if (self.isLocalFile) return;
    
    if ([self isNoNetwork])
    {
        [self promptMessage:kNetworkUnavailable];
    }
    else
    {
        [self promptMessage:kLoadDataFailed];
    }
}

#pragma mark - Full Screen
- (void)startFullScreenObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil]; // 进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil]; // 退出全屏
}

- (void)stopFullScreenObserving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)enterFullScreen
{
    if (self.statusBarAppearanceByViewController)
    {
        self.statusBarHidden = self.prefersStatusBarHidden;
    }
    else
    {
        self.statusBarHidden = UIApplication.sharedApplication.isStatusBarHidden;
    }
}

- (void)exitFullScreen
{
    if (self.statusBarAppearanceByViewController)
    {
        self.prefersStatusBarHidden = self.statusBarHidden;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:self.statusBarHidden withAnimation:UIStatusBarAnimationNone];
    }
    
    [self statusBarStyleToFit];
}

- (BOOL)statusBarAppearanceByViewController
{
    NSNumber *viewControllerBased = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
    if (viewControllerBased && !viewControllerBased.boolValue)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#if RotationObservingForVideoEnabled
- (void)retainStatusBar
{
    if (self.statusBarAppearanceByViewController)
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
}

#pragma mark iOS 8 Prior
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.view layoutSubviews];
    
    [self retainStatusBar];
}

#pragma mark ios 8 Later
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        [self retainStatusBar];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        //
    }];
}
#endif

@end
