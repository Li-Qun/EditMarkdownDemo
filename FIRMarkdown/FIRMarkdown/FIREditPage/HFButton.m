//
//  HFButton.m
//  FIRMarkdown
//
//  Created by HF on 2019/3/21.
//  Copyright © 2019年 FIR. All rights reserved.
//

#import "HFButton.h"

@implementation HFButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            // Initialization code
    }
    return self;
}

- (void)selectAnimation
{
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.95f,0.95f);
        [self setAlpha:0.75];
    } completion:^(BOOL finished){
        
    }];
}

- (void)clearAnimation
{
    self.transform = CGAffineTransformMakeScale(1.0f,1.0f);
    [self setAlpha:1];
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
}

- (void)deselectAnimation
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0.15 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakSelf setAlpha:1];
        weakSelf.transform = CGAffineTransformMakeScale(1.0f,1.0f);
        
    } completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self selectAnimation];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self deselectAnimation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self deselectAnimation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}



@end
