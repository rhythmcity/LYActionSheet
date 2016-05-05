//
//  ViewController.m
//  LYActionSheet
//
//  Created by 李言 on 16/5/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "ViewController.h"
#import "LYActionSheet.h"
@interface ViewController ()
@property (nonatomic, strong)LYActionSheet *lyActionSheet;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
//    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400);
    self.lyActionSheet = [[LYActionSheet alloc] initWithHeight:400 BasicView:self.view ContentView:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.lyActionSheet showActionSheet];
    });
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
