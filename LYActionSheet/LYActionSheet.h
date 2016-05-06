//
//  LYActionSheet.h
//  LYActionSheet
//  这个actionsheet 只有自定义的弹力动画，至于弹出来的view的操作 请传你自定义的内容  contentview
//  Created by 李言 on 16/5/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYActionSheet : NSObject
//  这个actionsheet 只有自定义的弹力动画，至于弹出来的view的操作 请传你自定义的内容  contentview
+ (nullable instancetype)LYActionSheetWithHeight:(CGFloat)height
                                       BasicView:(nullable UIView *)basicView
                                     ContentView:(nonnull UIView *)contentView;
//  这个actionsheet 只有自定义的弹力动画，至于弹出来的view的操作 请传你自定义的内容  contentview
- (nullable instancetype)initWithHeight:(CGFloat)height
                              BasicView:(nullable UIView *)basicView
                            ContentView:(nonnull UIView *)contentView;
- (void)showActionSheet;

- (void)hiddenActionSheet;
@end
