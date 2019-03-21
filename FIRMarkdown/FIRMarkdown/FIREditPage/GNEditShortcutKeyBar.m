//
//  GNEditShortcutKeyBar.m
//  GraanNote
//
//  Created by HF on 2019/3/21.
//  Copyright © 2019年 FIR. All rights reserved.
//

#import "GNEditShortcutKeyBar.h"
#import <YYText/YYText.h>
#import "YYCategories.h"
#import "Masonry.h"
#import "HFButton.h"


@interface GNEditShortcutKeyBar ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end


@implementation GNEditShortcutKeyBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubviews];
    }
    return self;
}

#pragma mark - event

- (void)shortcutAction:(HFButton *)btn
{
    NSLog(@"%ld",btn.tag);
    if (self.clickEditShortcutKeyBlock) {
        self.clickEditShortcutKeyBlock(btn.tag);
    }
}

#pragma mark - private

- (void)configSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    //
    UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:backView];
    backView.backgroundColor = [UIColor colorWithHexString:@"F9A034"];
    backView.width = 52;
    backView.height = 40;
    //
    HFButton *btn = [HFButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_shortcut_%d",0]]];
    [backView addSubview:btn];
    btn.height = 40;
    btn.width = 52;
    btn.left = 0;
    btn.tag = 0;
    [btn addTarget:self action:@selector(shortcutAction:) forControlEvents:UIControlEventTouchUpInside];
    //滚动范围为非关闭键盘键集
    [self addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(52, 0, self.width - 52, self.height);
    [self.scrollView setContentSize:CGSizeMake(10 + 40 * 10 + 10, self.scrollView.height)];
    HFButton *lastBtn = nil;
    for (int i = 0; i < 10; i ++) {
        
        HFButton *btn = [HFButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_shortcut_%d",i + 1]]];
        [self.scrollView addSubview:btn];
        btn.height = 40;
        btn.width = 40;
        if (lastBtn) {
            CGFloat padding = 0;
            btn.left = lastBtn.right + padding;
        } else {
            btn.left = 10;
        }
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(shortcutAction:) forControlEvents:UIControlEventTouchUpInside];
        lastBtn = btn;
    }
    //
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"D5D5D5"];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(@(1));
        make.left.right.equalTo(self);
    }];
}

- (void)clickEditShortKeyWithType:(GNEditShortcutKeyType)itemType inTextView:(YYTextView *)textView
{
    if (GNEditShortcutKeyTypeClose == itemType) {
        [textView resignFirstResponder];
        return ;
    }
        //插入的文本内容
    NSString *insertText;
        //插入文本内容后，光标的位置
    NSRange selectedRange = textView.selectedRange;
    if (GNEditShortcutKeyTypeH1 == itemType) {
        insertText = @"# ";
        selectedRange.location += 2;    //移动到 #和一个空格 后面
    } else if (GNEditShortcutKeyTypeH2 == itemType) {
        insertText = @"## ";
        selectedRange.location += 3;    //移动到 ##和一个空格 后面
    } else if (GNEditShortcutKeyTypeH3 == itemType) {
        insertText = @"### ";
        selectedRange.location += 4;    //移动到 ###和一个空格 后面
    } else if (GNEditShortcutKeyTypeB == itemType) {
        insertText = @"****";
        selectedRange.location += 2;    //移动到 ** 后面
    } else if (GNEditShortcutKeyTypeI == itemType) {
        insertText = @"__";
        selectedRange.location += 1;    //移动到 _ 后面
    } else if (GNEditShortcutKeyTypeQuotes == itemType) {
        insertText = @"> ";
        selectedRange.location += 2;    //移动到 >和一个空格 后面
    } else if (GNEditShortcutKeyTypeCode == itemType) {
        insertText = @"``";
        selectedRange.location += 1;    //移动到 ` 后面
    }  else if (GNEditShortcutKeyTypeLink == itemType) {
        insertText = @"[]()";
        selectedRange.location += 1;    //移动到 [ 后面
    }  else if (GNEditShortcutKeyTypeArray == itemType) {
        insertText = @"- ";
        selectedRange.location += 2;    //移动到 -和一个空格 后面
    } else if (GNEditShortcutKeyTypeAt == itemType) {
        insertText = @"@";
        selectedRange.location += 1;    //移动到 @ 后面
    } else if (GNEditShortcutKeyTypeImg == itemType) {
        insertText = @"![]()";
        selectedRange.location += 4;    //移动到 ( 后面
    } else {
            //        insertText = title;
            //        selectedRange.location += title.length; //移动到插入文本的最后
    }
        //插入文本
    [textView insertText:insertText];
        //移动光标
    textView.selectedRange = selectedRange;
}
#pragma mark - getter setter

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
