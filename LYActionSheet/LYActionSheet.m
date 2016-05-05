//
//  LYActionSheet.m
//  LYActionSheet
//
//  Created by 李言 on 16/5/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "LYActionSheet.h"
#import "Masonry/Masonry.h"
static NSInteger const PathStartHeight = 44;
@interface LYActionSheet ()
@property (nonatomic, strong)CAShapeLayer *backgroundLayer;
@property (nonatomic, strong)CADisplayLink *displayLink;
@property (nonatomic, strong)UIView *view;              //半透明背景
@property (nonatomic, strong)UIView *contentView;       //当前actionsheet 的内容
@property (nonatomic, strong)UIView *basicView;         //背景view  推出actionsheet 之前的展示的view
@property (nonatomic, strong)UIView *motionView;        //运动view 用于弹出和消失的view
@property (nonatomic, assign)CGFloat motionHeight;
@end

@implementation LYActionSheet
- (instancetype) init {
    if (self = [super init]) {
        
        _motionView = [[UIView alloc] init];
        
        _contentView = [[UIView alloc] init];
        _view = [[UIView alloc] init];
        _view.backgroundColor = [UIColor darkGrayColor];
        _view.alpha = 0;
        _view.userInteractionEnabled = NO;
        [_motionView addSubview:_contentView];
        _backgroundLayer = [CAShapeLayer layer];
//        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaylinkAction:)];
//        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
      
//        [UIApplication sharedApplication].keyWindow.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

+ (instancetype)LYActionSheetWithHeight:(CGFloat)height
                              BasicView:(UIView *)basicView
                            ContentView:(UIView *)contentView {
    LYActionSheet *actionSheet = [[LYActionSheet alloc] initWithHeight:height BasicView:basicView ContentView:contentView];
    return actionSheet;
}

- (instancetype)initWithHeight:(CGFloat)height
                     BasicView:(UIView *)basicView
                   ContentView:(UIView *)contentView {
    self = [self init];
    self.basicView = basicView;
    self.motionHeight = height;
//
//    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"contentView": self.contentView}]];
//    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"contentView": self.contentView}]];
//    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.motionView);
    }];
    self.contentView.backgroundColor = contentView.backgroundColor;
    [self.contentView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(40);
        make.leading.trailing.bottom.equalTo(self.contentView);
    }];
//    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-44-[contentView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"contentView": contentView}]];
//    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"contentView": contentView}]];
    [self addActionSheet];
    return self;
}

- (void)addActionSheet {
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([UIApplication sharedApplication].keyWindow);
    }];
//    self.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self.motionView];
    
    [self.motionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PathStartHeight);
        make.leading.trailing.bottom.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
//    self.motionView.frame = CGRectMake(0, [UIApplication sharedApplication].keyWindow.bounds.size.height - 94, [UIApplication sharedApplication].keyWindow.bounds.size.width, 94);
//
//    [[UIApplication sharedApplication].keyWindow setNeedsLayout];
    [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
    
    
    self.backgroundLayer.fillColor = self.contentView.backgroundColor.CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(0, PathStartHeight)];
    [bezierPath addLineToPoint:CGPointMake(self.contentView.bounds.size.width, PathStartHeight)];
    [bezierPath addLineToPoint:CGPointMake(self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
    [bezierPath addLineToPoint:CGPointMake(0, self.contentView.bounds.size.height)];
    [bezierPath addLineToPoint:CGPointMake(0, PathStartHeight)];
    self.backgroundLayer.strokeColor        = [UIColor clearColor].CGColor;
    self.backgroundLayer.path               = bezierPath.CGPath;
    self.backgroundLayer.frame              = self.contentView.layer.bounds;
    self.contentView.layer.mask             = self.backgroundLayer;
    self.contentView.layer.masksToBounds    = YES;

}

- (void)animationToStatusBar:(NSTimeInterval)time style:(UIStatusBarStyle)style {
    
    if (self.contentView) {
        [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
    }

}

- (CGPathRef)getBezierPathWithProgress:(CGFloat)progress fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue {

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat newprogress = (toValue - fromValue)*progress;
    
    [path moveToPoint:CGPointMake(0, PathStartHeight)];
    [path addQuadCurveToPoint:CGPointMake(self.contentView.bounds.size.width, PathStartHeight) controlPoint:CGPointMake(self.contentView.bounds.size.width/2, fromValue + newprogress)];
    [path addLineToPoint:CGPointMake(self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
    [path addLineToPoint:CGPointMake(0, self.contentView.bounds.size.height)];
    [path addLineToPoint:CGPointMake(0, PathStartHeight)];
    
    return path.CGPath;
}

- (void)animationToMotion:(CGFloat)height duration:(NSTimeInterval)duration {
//    NSArray *array  =   self.motionView.constraints;
//    
//    for (NSLayoutConstraint *constraint  in array) {
//        if (constraint.firstItem == self.motionView && constraint.firstAttribute == NSLayoutAttributeHeight) {
//            
//            constraint.constant = height;
//        }
//    }
    
    
    [self.motionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:height]);
    }];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
        
//        self.motionView.frame = CGRectMake(0, [UIApplication sharedApplication].keyWindow.bounds.size.height - height, [UIApplication sharedApplication].keyWindow.bounds.size.width, height);
    } completion:^(BOOL finished) {
        
    }];
    
    


}

- (void)animationToSpringPathFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(NSTimeInterval)duration {
    
    CAKeyframeAnimation *keyanimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    keyanimation.duration = duration;
    keyanimation.fillMode = kCAFillModeForwards;
    keyanimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    NSMutableArray *pathArray = [NSMutableArray array];
    for (int i = 0; i<= (int)(duration * 60); i++) {

        [pathArray addObject:(id)[self getBezierPathWithProgress:(CGFloat)i/((CGFloat)duration*60) fromValue:fromValue toValue:toValue]];
    }
    keyanimation.values = pathArray;
    
    keyanimation.autoreverses = NO;
    keyanimation.removedOnCompletion = NO;
    
    self.backgroundLayer.path = [self getBezierPathWithProgress:1.0 fromValue:fromValue toValue:toValue];
    
    [self.backgroundLayer addAnimation:keyanimation forKey:@"spring"];

    

}
- (void)animationToBasicViewWithsx:(CGFloat)sx sy:(CGFloat)sy sz:(CGFloat)sz duration:(NSTimeInterval)duration {
    
     [UIView animateWithDuration:duration animations:^{
         self.basicView.layer.transform = CATransform3DMakeScale(sx, sy, sz);
     }];

}

- (void)animationToView:(NSTimeInterval)time opactity:(CGFloat)opactity {
     [UIView animateWithDuration:time animations:^{
         self.view.layer.opacity = opactity;
     } completion:^(BOOL finished) {
        
     }];


}

- (void)displaylinkAction:(CADisplayLink *)displayLink {
    
    
}


- (void)showActionSheet {
   
    [self animationToView:0.4 opactity:0.8];
    [self animationToStatusBar:0.8 style:UIStatusBarStyleLightContent];
    [self animationToSpringPathFromValue:PathStartHeight toValue:0 duration:0.3];
    [self animationToBasicViewWithsx:1.02 sy:1.02 sz:1.02 duration:0.3];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationToMotion:self.motionHeight duration:0.5];
        [self animationToSpringPathFromValue:0 toValue:PathStartHeight+10 duration:0.3];
        [self animationToBasicViewWithsx:0.89 sy:0.89 sz:0.89 duration:0.4];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationToSpringPathFromValue:PathStartHeight+10 toValue:PathStartHeight-10 duration:0.1];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationToSpringPathFromValue:PathStartHeight-10 toValue:PathStartHeight duration:0.1];
        [self animationToBasicViewWithsx:0.9 sy:0.9 sz:0.9 duration:0.1];
    });
   
}

- (void)hiddenActionSheet {


}



@end
