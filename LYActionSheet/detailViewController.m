//
//  detailViewController.m
//  LYActionSheet
//
//  Created by 李言 on 16/5/5.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "detailViewController.h"
#import "LYActionSheet.h"
@implementation detailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor darkGrayColor];
    
    
    LYActionSheet * lyActionSheet = [[LYActionSheet alloc] initWithHeight:600 BasicView:self.navigationController.view ContentView:view];
    [lyActionSheet showActionSheet];
    


}
@end
