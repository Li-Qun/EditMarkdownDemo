//
//  FIREditPageVC.m
//  FIRMarkdown
//
//  Created by HF on 2019/3/21.
//  Copyright © 2019年 FIR. All rights reserved.
//

#import "FIREditPageVC.h"
#import "PreWebVC.h"
#import "GNEditShortcutKeyBar.h"
//
#import <YYText/YYText.h>
#import "YYCategories.h"
#import "Masonry.h"

//状态栏高度
#define statusBar_height  ([[UIApplication sharedApplication] statusBarFrame].size.height)
//是否是 iPhoneX
#define kDevice_Is_iPhoneX (statusBar_height > 20 ?  YES : NO)
//tab 相对于底部 的安全距离
#define tabbarBottomPadding  (kDevice_Is_iPhoneX ? 34 : 0)
//导航高度
#define nav_height        (statusBar_height + 44.f)

@interface FIREditPageVC () <YYTextViewDelegate>

@property (nonatomic, strong) YYTextView *textView;  //body
@property (nonatomic, strong) GNEditShortcutKeyBar *shortcutKeyView;
@property (nonatomic, assign) BOOL isShowPreview;
@property (nonatomic, strong) PreWebVC *previewVC;
@property (nonatomic, strong) UIBarButtonItem *previewButtonItem;
@end

@implementation FIREditPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self configSubviews];
    [self addAnimationShow];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

- (void)dealloc
{
    _textView.delegate = nil;
    [_previewVC.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - event

- (void)clickPreviewAcation
{
    [self switchPreviewOrEditView];
}

//预览模式切换
- (void)switchPreviewOrEditView
{
    self.previewVC.view.hidden = self.isShowPreview;
    self.isShowPreview = self.isShowPreview ? NO : YES;
    self.previewButtonItem.title = self.isShowPreview ? @"编辑":@"预览";
    if (self.isShowPreview) {
        [self.previewVC refreshMarkdown:self.textView.text];
        [self.textView resignFirstResponder];
    } else {
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - Delegate
#pragma mark -- YYTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView
{
    self.shortcutKeyView.hidden = NO;
    return YES;
}

- (void)textViewDidEndEditing:(YYTextView *)textView;
{
    self.shortcutKeyView.hidden = YES;
}

#pragma mark -- keyboard KVO

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (![notification.name isEqualToString:UIKeyboardWillChangeFrameNotification]) return;
    NSDictionary *userInfo = notification.userInfo;
    if (!userInfo) return;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];//键盘顶部起始位置⌨️
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    __weak typeof(self) weakSelf = self;
    void(^animations)(void) = ^{
        CGFloat topY = MAX(endFrame.origin.y - weakSelf.shortcutKeyView.height,0);
        if (topY != weakSelf.shortcutKeyView.top) {
            weakSelf.shortcutKeyView.top = topY;
        }
            //更新textView高度 start
        BOOL  isKeyboardOpen = endFrame.origin.y < weakSelf.view.bottom;//键盘打开
        CGFloat padding = isKeyboardOpen ? weakSelf.view.bottom - weakSelf.shortcutKeyView.top : 0 + tabbarBottomPadding;
        [weakSelf.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).offset(- padding);
        }];
        [weakSelf.view updateConstraintsIfNeeded];
        [weakSelf.view layoutIfNeeded];
            //end
    };
    
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:animations completion:completion];
}

    //  键盘弹出触发该方法
- (void)keyboardDidShow
{
    NSLog(@"键盘弹出");
}
    //  键盘隐藏触发该方法
- (void)keyboardDidHide
{
    NSLog(@"键盘收起");
    self.shortcutKeyView.top = self.view.bottom;
}


#pragma mark - private

- (void)configSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(- 16);
        make.bottom.equalTo(self.view).offset(- 0 - tabbarBottomPadding);
    }];
    [self.view addSubview:self.self.previewVC.view];
    [self.previewVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(nav_height);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.previewVC.view.hidden = YES;
    self.isShowPreview = NO;
    self.shortcutKeyView.hidden = YES;
    [self.view addSubview:self.shortcutKeyView];
    //预填充 可选
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample1" ofType:@"md"];
    NSString *markdown = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    self.textView.text = markdown;
}

- (void)initNavBar
{
    UIBarButtonItem *previewBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"预览" style:UIBarButtonItemStyleDone target:self action:@selector(clickPreviewAcation)];
    self.navigationItem.rightBarButtonItem = previewBtnItem;
    self.previewButtonItem = previewBtnItem;
}

- (void)addAnimationShow
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - getter setter

- (YYTextView *)textView
{
    if (!_textView) {
        _textView = [[YYTextView alloc]init];
        _textView.placeholderText = @"请输入内容...";
        _textView.placeholderFont = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _textView.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _textView.delegate = self;
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 6;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:_textView.font,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        _textView.typingAttributes = attributes;
    }
    return _textView;
}

- (PreWebVC *)previewVC
{
    if (!_previewVC) {
        //__weak typeof(self) weakSelf = self;
        _previewVC = [[PreWebVC alloc]init];
        [_previewVC setOpenUrlBlock:^(NSString * _Nonnull url) {
            NSLog(@"TODO:去打开网页:%@",url);
        }];
    }
    return _previewVC;
}

- (GNEditShortcutKeyBar *)shortcutKeyView
{
    if (!_shortcutKeyView) {
        __weak typeof(self) weakSelf = self;
        _shortcutKeyView = [[GNEditShortcutKeyBar alloc]initWithFrame:CGRectMake(0, self.view.bottom, self.view.width, 40)];
        [_shortcutKeyView setClickEditShortcutKeyBlock:^(GNEditShortcutKeyType itemType) {
            [weakSelf.shortcutKeyView clickEditShortKeyWithType:itemType inTextView:weakSelf.textView];
        }];
    }
    return _shortcutKeyView;
}

@end
