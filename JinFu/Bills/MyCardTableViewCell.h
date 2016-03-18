//
//  MyCardTableViewCell.h
//  JinFu
//
//  Created by ybon on 16/2/23.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GetPaymentStateBlock)(NSInteger ,CGFloat);

@interface MyCardTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *bankCardBg;
@property (strong, nonatomic) UILabel *deadDate;
@property (strong, nonatomic) UIImageView *cardIcon;
@property (strong, nonatomic) UIImageView *cnyImage;
@property (strong, nonatomic) UILabel *cardNameAndNumber;
@property (strong, nonatomic) UIImageView *lineImage;
@property (strong, nonatomic) UILabel *cdTime;
@property (strong, nonatomic) UILabel *debt;
@property (strong, nonatomic) UILabel *minPay;
@property (strong, nonatomic) UILabel *creditLine;
@property (strong, nonatomic) UILabel *integeral;
@property (strong, nonatomic) UILabel *period;
@property (strong, nonatomic) UILabel *leftDaysToNextBillDay;
@property (strong, nonatomic) UIImageView *rightOperation;
//付款状态相关
@property (strong, nonatomic) UIImageView *payButtonView;
@property (strong, nonatomic) UIImageView *payStateBgImageView;
@property (strong, nonatomic) UILabel *payStateLabel;
@property (strong, nonatomic) UIImageView *pullView;

@property (nonatomic, copy) GetPaymentStateBlock getPayState;
- (void)setPayState:(NSString *)state andPaidNum:(NSString *)paid;

@end
