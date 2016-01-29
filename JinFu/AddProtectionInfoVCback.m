//
//  AddProtectionInfoVC.m
//  JinFu
//
//  Created by ybon on 15/12/18.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "AddProtectionInfoVCback.h"
#import "UnauthoProtectionInfoVC.h"
@interface AddProtectionInfoVCback ()

@end

@implementation AddProtectionInfoVCback

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)agreeProtocol:(UIButton *)sender {
    [self.navigationController pushViewController:[[UnauthoProtectionInfoVC alloc] init] animated:YES];
}
@end
