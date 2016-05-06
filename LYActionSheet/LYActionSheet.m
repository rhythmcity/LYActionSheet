//
//  LYActionSheet.m
//  LYActionSheet
//
//  Created by 李言 on 16/5/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "LYActionSheet.h"
static NSInteger const PathStartHeight =  44;
@interface LYActionSheet ()
@property (nonatomic, strong)CAShapeLayer *backgroundLayer;
@property (nonatomic, strong)CADisplayLink *displayLink;
@property (nonatomic, strong)UIView *view;              //半透明背景
@property (nonatomic, strong)UIView *contentView;       //当前actionsheet 的内容
@property (nonatomic, strong)UIView *basicView;         //背景view  推出actionsheet 之前的展示的view
@property (nonatomic, strong)UIView *motionView;        //运动view 用于弹出和消失的view
@property (nonatomic, assign)CGFloat motionHeight;
@property (nonatomic, assign)BOOL    isShow;
@property (nonatomic, strong)UITapGestureRecognizer *tap;
@property (nonatomic, strong)NSLayoutConstraint *motionViewconstrantHeight;
@end

@implementation LYActionSheet
- (instancetype) init {
    if (self = [super init]) {
        
        _motionView = [[UIView alloc] init];
        _motionView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _view = [[UIView alloc] init];
        _view.backgroundColor = [UIColor lightGrayColor];
        _view.alpha = 0;
        _view.userInteractionEnabled = NO;
        _view.translatesAutoresizingMaskIntoConstraints = NO;
        [_motionView addSubview:_contentView];
        _backgroundLayer = [CAShapeLayer layer];
        
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTap:)];
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

    NSLayoutConstraint *contentViewconstrantleft =  [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.motionView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *contentViewconstrantright =  [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.motionView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *contentViewconstranttop = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.motionView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *contentViewconstrantBottom =  [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.motionView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [NSLayoutConstraint activateConstraints:@[contentViewconstrantleft,contentViewconstrantright,contentViewconstranttop,contentViewconstrantBottom]];

    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = contentView.backgroundColor;
    [self.contentView addSubview:contentView];
    
    
    NSLayoutConstraint *viewconstrantleft =  [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *viewconstrantright =  [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *viewconstranttop = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *viewconstrantBottom =  [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];

    [NSLayoutConstraint activateConstraints:@[viewconstrantleft,viewconstrantright,viewconstranttop,viewconstrantBottom]];

    return self;
}

- (void)addActionSheet {
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];

    NSLayoutConstraint *viewconstrantleft =  [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self.view superview] attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *viewconstrantright =  [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self.view superview] attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *viewconstranttop = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self.view superview] attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *viewconstrantBottom =  [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self.view superview] attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [NSLayoutConstraint activateConstraints:@[viewconstrantleft,viewconstrantright,viewconstranttop,viewconstrantBottom]];

    [[UIApplication sharedApplication].keyWindow addSubview:self.motionView];

   
    NSLayoutConstraint *motionViewconstrantleft =  [NSLayoutConstraint constraintWithItem:self.motionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self.motionView superview] attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *motionViewconstrantright =  [NSLayoutConstraint constraintWithItem:self.motionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self.motionView superview] attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    self.motionViewconstrantHeight = [NSLayoutConstraint constraintWithItem:self.motionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:PathStartHeight];
    NSLayoutConstraint *motionViewconstrantBottom =  [NSLayoutConstraint constraintWithItem:self.motionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self.motionView superview] attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [NSLayoutConstraint activateConstraints:@[motionViewconstrantleft,motionViewconstrantright,self.motionViewconstrantHeight,motionViewconstrantBottom]];
    
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
    NSArray *array  =   self.motionView.constraints;
    for (NSLayoutConstraint *constraint  in array) {
        if (constraint.firstItem == self.motionView && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = height;
        }
    }
    
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
        
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
    if (self.isShow) {
        return;
    }
    [self addActionSheet];
    [self animationToView:0.4 opactity:0.8];
    [self animationToStatusBar:0.8 style:UIStatusBarStyleLightContent];
    [self animationToSpringPathFromValue:PathStartHeight toValue:PathStartHeight-44 duration:0.3];
    [self animationToBasicViewWithsx:1.02 sy:1.02 sz:1.02 duration:0.3];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationToMotion:self.motionHeight duration:0.5];
        [self animationToSpringPathFromValue:PathStartHeight-44 toValue:PathStartHeight+10 duration:0.3];
        [self animationToBasicViewWithsx:0.89 sy:0.89 sz:0.89 duration:0.4];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationToSpringPathFromValue:PathStartHeight+10 toValue:PathStartHeight-10 duration:0.1];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationToSpringPathFromValue:PathStartHeight-10 toValue:PathStartHeight duration:0.1];
        [self animationToBasicViewWithsx:0.9 sy:0.9 sz:0.9 duration:0.1];
        

    });
    
    self.isShow = YES;
    
    
    self.view.userInteractionEnabled = YES;
    
    [self.view addGestureRecognizer:self.tap];
}

- (void)removeActionSheet {
    [NSLayoutConstraint deactivateConstraints:self.view.constraints];
    [NSLayoutConstraint deactivateConstraints:@[self.motionViewconstrantHeight]];
    [self.view removeFromSuperview];
    [self.motionView removeFromSuperview];

}
- (void)hiddenActionSheet {
    if (!self.isShow) {
        return;
    }
    
    [self animationToView:1.5 opactity:0];
    [self animationToStatusBar:0.8 style:UIStatusBarStyleDefault];
    [self animationToSpringPathFromValue:PathStartHeight toValue:PathStartHeight+50 duration:0.3];
    [self animationToBasicViewWithsx:0.89 sy:0.89 sz:0.89 duration:0.3];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationToSpringPathFromValue:PathStartHeight + 50 toValue:PathStartHeight - 10 duration:0.1];
       
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationToSpringPathFromValue:PathStartHeight - 10 toValue:PathStartHeight-44 duration:0.3];
        [self animationToMotion:PathStartHeight duration:0.3];
       
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self animationToBasicViewWithsx:1 sy:1 sz:1 duration:0.1];
        [self animationToSpringPathFromValue:PathStartHeight-44 toValue:PathStartHeight duration:0.1];
      
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isShow = NO;
        self.view.userInteractionEnabled = NO;
        [self.view removeGestureRecognizer:self.tap];
        [self removeActionSheet];
    });
}

- (void)backViewTap:(UITapGestureRecognizer *)tap {

    [self hiddenActionSheet];
}

@end
