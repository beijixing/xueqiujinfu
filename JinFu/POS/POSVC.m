//
//  POSVC.m
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "POSVC.h"
#import "AddPosInfoVC.h"
#import "AFNetManager.h"
#import "MBProgressHUD.h"

@interface POSVC ()

@end

@implementation POSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.descTextView.text = self.posInfo.serviceRemark;
    self.navigationItem.title = @"POS机";
    [self configNavigationLeftButton];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
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

- (IBAction)buyProtectionButtonClick:(UIButton *)sender {
    if (![[AFNetManager sharedManager] checkNetStateWithTip:@"网络不好，请稍后再试"]){
        return;
    }
    AddPosInfoVC *addposInfoVc = [[AddPosInfoVC alloc] init];
    addposInfoVc.posInfo = self.posInfo;
    [self.navigationController pushViewController:addposInfoVc animated:YES];
}
@end
