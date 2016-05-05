//
//  ViewController.m
//  LYActionSheet
//
//  Created by 李言 on 16/5/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "ViewController.h"
#import "LYActionSheet.h"
#import "detailViewController.h"
@interface ViewController ()
@property (nonatomic, strong)LYActionSheet *lyActionSheet;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go)];
    [self.view addGestureRecognizer:tap];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   
        
              
//        [self.lyActionSheet showActionSheet];
    });
    

}
- (void)go {
    detailViewController *dvc =[[detailViewController alloc] init];
    [self.navigationController pushViewController:dvc animated:YES];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
