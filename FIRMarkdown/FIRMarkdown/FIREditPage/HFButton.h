//
//  HFButton.h
//  FIRMarkdown
//
//  Created by HF on 2019/3/21.
//  Copyright © 2019年 FIR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFButton : UIButton

- (void)setImage:(UIImage *)image;
- (void)clearAnimation;
    // 万能对象
@property (strong,nonatomic) id obj;
@property (strong,nonatomic) id obj2;//indexpath

@end

NS_ASSUME_NONNULL_END
