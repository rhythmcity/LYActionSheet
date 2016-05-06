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
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor blueColor]];
    button.frame = CGRectMake(0, 0, 100, 100);
    button.center = self.view.center;
    [button setTitle:@"tap me " forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.lyActionSheet  = [[LYActionSheet alloc] initWithHeight:600 BasicView:self.navigationController.view ContentView:view];
    
    

}


- (void)buttonClick:(UIButton *)sender {
    
    [self.lyActionSheet showActionSheet];
    
    
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
