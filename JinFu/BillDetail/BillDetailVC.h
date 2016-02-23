//
//  BillDetailVC.h
//  JinFu
//
//  Created by ybon on 15/12/21.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardListDataModel.h"

@interface BillDetailVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *billDetailGroupTable;
@property (nonatomic, copy) NSString *bankCardId;
@property (nonatomic, strong)BankCardListDataModel *bankCardInfo;
@property (strong, nonatomic) IBOutlet UIImageView *bankCardIconImageView;

@property (strong, nonatomic) IBOutlet UILabel *bankNameAndNumber;

@property (strong, nonatomic) IBOutlet UILabel *deadDate;
@property (strong, nonatomic) IBOutlet UILabel *cdTime;
@property (strong, nonatomic) IBOutlet UILabel *debt;
@property (strong, nonatomic) IBOutlet UILabel *minpay;
@property (strong, nonatomic) IBOutlet UILabel *totalAmount;
@property (strong, nonatomic) IBOutlet UILabel *totalIntegeral;
//付款状态
@property (strong, nonatomic) IBOutlet UILabel *payStateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *payStateBgImageView;
@property (strong, nonatomic) IBOutlet UITextField *payPartTF;
@property (strong, nonatomic) IBOutlet UIView *payButtonView;
@property (strong, nonatomic) IBOutlet UIView *pullMenuView;
@property (strong, nonatomic) IBOutlet UIView *cardInfoView;


- (IBAction)unpaiedButtonClick:(UIButton *)sender;
- (IBAction)paiedButtonClick:(UIButton *)sender;
- (IBAction)payPartButtonClick:(UIButton *)sender;
@end



