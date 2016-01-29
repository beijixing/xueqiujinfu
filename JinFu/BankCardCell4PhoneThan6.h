//
//  BankCardCell4PhoneThan6.h
//  JinFu
//
//  Created by ybon on 16/1/27.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardCell.h"

@interface BankCardCell4PhoneThan6 : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bankCardBg;
@property (strong, nonatomic) IBOutlet UILabel *deadDate;
@property (strong, nonatomic) IBOutlet UIImageView *cardIcon;
@property (strong, nonatomic) IBOutlet UILabel *cardNameAndNumber;
@property (strong, nonatomic) IBOutlet UILabel *cdTime;
@property (strong, nonatomic) IBOutlet UILabel *debt;
@property (strong, nonatomic) IBOutlet UILabel *minPay;
@property (strong, nonatomic) IBOutlet UILabel *creditLine;
@property (strong, nonatomic) IBOutlet UILabel *integeral;
@property (strong, nonatomic) IBOutlet UILabel *period;
@property (nonatomic, copy)BankCardCellButtonAction billDetailButtonAction;
@property (strong, nonatomic) IBOutlet UILabel *leftDaysToNextBillDay;
- (IBAction)billDetailButtonClick:(UIButton *)sender;

//付款状态相关
@property (strong, nonatomic) IBOutlet UIView *payButtonView;
@property (strong, nonatomic) IBOutlet UIImageView *payStateBgImageView;
@property (strong, nonatomic) IBOutlet UILabel *payStateLabel;
@property (strong, nonatomic) IBOutlet UIView *pullView;

- (IBAction)unpayButtonClick:(UIButton *)sender;
- (IBAction)paidButtonClick:(UIButton *)sender;
- (IBAction)payPartButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *payPartTF;
@property (nonatomic, copy) GetPaymentStateBlock getPayState;

- (void)setPayState:(NSString *)state andPaidNum:(NSString *)paid;

@end
