//
//  GNEditShortcutKeyBar.h
//  GraanNote
//
//  Created by HF on 2019/3/21.
//  Copyright © 2019年 FIR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GNEditShortcutKeyType) {
    GNEditShortcutKeyTypeClose  = 0,
    GNEditShortcutKeyTypeH1,
    GNEditShortcutKeyTypeH2,
    GNEditShortcutKeyTypeH3,
    GNEditShortcutKeyTypeB,
    GNEditShortcutKeyTypeI,
    GNEditShortcutKeyTypeQuotes,//   “
    GNEditShortcutKeyTypeCode,
    GNEditShortcutKeyTypeLink,
    GNEditShortcutKeyTypeArray,
    GNEditShortcutKeyTypeAt,
    GNEditShortcutKeyTypeImg
};

@interface GNEditShortcutKeyBar : UIView

@property (nonatomic, copy) void (^clickEditShortcutKeyBlock)(GNEditShortcutKeyType itemType);

- (void)clickEditShortKeyWithType:(GNEditShortcutKeyType)itemType inTextView:(id)textView;

@end

NS_ASSUME_NONNULL_END
