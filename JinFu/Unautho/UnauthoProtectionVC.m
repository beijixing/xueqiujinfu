//
//  UnauthoProtectionVC.m
//  JinFu
//
//  Created by ybon on 15/12/18.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "UnauthoProtectionVC.h"
#import "AddProtectionInfoVC.h"
#import "AFNetManager.h"
#import "MBProgressHUD.h"

@interface UnauthoProtectionVC ()

@end

@implementation UnauthoProtectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.navigationController.navigationBarHidden = NO;
    self.descTextView.text = self.serviceInfo.serviceRemark;
    self.navigationItem.title = @"盗刷保障";
    [self configNavigationLeftButton];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)buyServiceBtnClick:(UIButton *)sender {
    if (![[AFNetManager sharedManager] checkNetStateWithTip:@"网络不好，请稍后再试"]){
        return;
    }
    DLog(@"购买保障");
    AddProtectionInfoVC *addInfoVc = [[AddProtectionInfoVC alloc] init];
    addInfoVc.serviceInfo = self.serviceInfo;
    [self.navigationController pushViewController:addInfoVc animated:YES];
    
    
}
@end
