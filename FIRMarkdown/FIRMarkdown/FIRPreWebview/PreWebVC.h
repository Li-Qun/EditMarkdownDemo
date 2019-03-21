//
//  PreWebVC.h
//  FIRMarkdown
//
//  Created by HF on 2019/3/21.
//  Copyright © 2019年 FIR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreWebVC : UIViewController

@property (nonatomic, copy) void (^openUrlBlock)(NSString *url);

- (void)refreshMarkdown:(NSString *)markdown;

@end

NS_ASSUME_NONNULL_END
