//
//  LYActionSheet.h
//  LYActionSheet
//
//  Created by 李言 on 16/5/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYActionSheet : NSObject

+ (instancetype)LYActionSheetWithHeight:(CGFloat)height
                              BasicView:(UIView *)basicView
                            ContentView:(UIView *)contentView;

- (instancetype)initWithHeight:(CGFloat)height
                     BasicView:(UIView *)basicView
                   ContentView:(UIView *)contentView;
- (void)showActionSheet;
@end
