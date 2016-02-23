//
//  CompensateDetailVC.m
//  JinFu
//
//  Created by ybon on 16/2/3.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "LostCardPaymentsDetailVC.h"

@interface LostCardPaymentsDetailVC ()

@end

@implementation LostCardPaymentsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.text = self.dataModel.userName;
    self.IDcard.text = self.dataModel.IDNum;
    self.TelNum.text = self.dataModel.TelNum;
    self.creditCarsNumber.text = self.dataModel.creditCard;
    self.compensateAmount.text = [NSString stringWithFormat:@"￥%@", self.dataModel.amount];
    self.state.text = self.dataModel.stateStr;
    self.desTextview.text = self.dataModel.remark;
    
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.title = @"赔付记录";
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

@end
