//
//  LostCardVC.m
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "LostCardVC.h"
#include "AddLostCardProtectionInfoVC.h"
#import "AFNetManager.h"
#import "MBProgressHUD.h"

@interface LostCardVC ()

@end

@implementation LostCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.descriptionTextView.text = self.serviceInfo.serviceRemark;
    self.navigationItem.title = @"失卡保障";
    [self configNavigationLeftButton];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)buyProtectionButtonClick:(UIButton *)sender {
    if (![[AFNetManager sharedManager] checkNetStateWithTip:@"网络不好，请稍后再试"]){
        return;
    }
    
    AddLostCardProtectionInfoVC *addProtectionInfoVc = [[AddLostCardProtectionInfoVC alloc] init];
    addProtectionInfoVc.serviceInfo = self.serviceInfo;
    [self.navigationController pushViewController:addProtectionInfoVc animated:YES];
}
@end
