//
//  FinancialVC.m
//  JinFu
//
//  Created by ybon on 15/12/16.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "FinancialVC.h"
#import "UnauthoProtectionVC.h"

@interface FinancialVC ()

@end

@implementation FinancialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"金服";
}

- (IBAction)phoneRemindBtnClick:(UIButton *)sender {
    
    NSLog(@"电话提醒");
}

- (IBAction)lostProtectionBtnClick:(UIButton *)sender {
    NSLog(@"失卡保障");
}
- (IBAction)unauthorizedChargeBtnClick:(UIButton *)sender {
    NSLog(@"盗刷保障");
    [self.navigationController pushViewController:[[UnauthoProtectionVC alloc] init] animated:YES];
}

- (IBAction)posMachineBtnClick:(UIButton *)sender {
    NSLog(@"POS机");
}
@end
