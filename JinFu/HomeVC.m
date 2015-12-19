//
//  HomeVCViewController.m
//  JinFu
//
//  Created by ybon on 15/12/16.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "HomeVC.h"
#import "LoginVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    
    typeof(self) __weak WEAKSELF = self;
    [self setRightNavigationBarButtonItemWithImage:@"message1" andAction:^{
        NSLog(@"message button click");
//        [self.navigationController pushViewController:[[LoginVC alloc] init] animated:YES];
        [WEAKSELF presentViewController:[[LoginVC alloc] init] animated:YES completion:^{
            
        }];
    }];
}
@end
