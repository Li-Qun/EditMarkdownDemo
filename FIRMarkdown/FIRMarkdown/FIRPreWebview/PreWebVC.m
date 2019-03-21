//
//  PreWebVC.m
//  FIRMarkdown
//
//  Created by HF on 2019/3/21.
//  Copyright © 2019年 FIR. All rights reserved.
//

#import "PreWebVC.h"
#import "Masonry.h"

@interface PreWebVC () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL needShowMarkdown;
@property (nonatomic, assign) BOOL isTransferFinished;
@property (nonatomic, strong) NSString *markdown;

@end

@implementation PreWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
}

- (void)dealloc
{
    if (_webView) {
        _webView.delegate = nil;
        [_webView stopLoading];
    }
    [_webView removeFromSuperview];
    _webView = nil;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    NSLog(@"释放了UIWebView");
    NSLog(@"PreWebVC dealloc");
}

#pragma mark - event

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (self.isTransferFinished) {
        if (self.openUrlBlock) {
            self.openUrlBlock(request.URL.absoluteString);
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.needShowMarkdown) {
        self.needShowMarkdown = NO;
    }
    if (!self.isTransferFinished) {
        [self refreshMarkdown:self.markdown];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark - private

- (void)configSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.needShowMarkdown = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"markdown" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *requset = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requset];
}

- (void)refreshMarkdown:(NSString *)markdown
{
    self.markdown = markdown;
        //
    if (self.needShowMarkdown) return;
        //
    NSString *content = [self getMarkdownContentWithMarkdowString:markdown];
    NSString *js = [NSString stringWithFormat:@"javascript:parseMarkdown(\"%@\",true)",content];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    self.isTransferFinished = YES;
}

#pragma mark - getter setter

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (NSString *)getMarkdownContentWithMarkdowString:(NSString *)markdown {
    markdown = [markdown stringByReplacingOccurrencesOfString:@"\r"withString:@""];//⚠️防止不识别\r
    markdown = [markdown stringByReplacingOccurrencesOfString:@"\n"withString:@"\\n"];
    markdown = [markdown stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    markdown = [markdown stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    return markdown;
}

@end
