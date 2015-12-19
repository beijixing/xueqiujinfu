//
//  UnauthoProtectionVC.m
//  JinFu
//
//  Created by ybon on 15/12/18.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "UnauthoProtectionVC.h"
#import "AddProtectionInfoVC.h"

@interface UnauthoProtectionVC ()

@end

@implementation UnauthoProtectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)buyServiceBtnClick:(UIButton *)sender {
    
    NSLog(@"购买保障");
    
    [self.navigationController pushViewController:[[AddProtectionInfoVC alloc] init] animated:YES];
}
@end
