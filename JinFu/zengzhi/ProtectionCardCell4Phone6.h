//
//  ProtectionCardCell4Phone6.h
//  JinFu
//
//  Created by ybon on 16/1/27.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtectionCardCell.h"

@interface ProtectionCardCell4Phone6 : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *bankCardBg;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewLine;

@property (strong, nonatomic) IBOutlet UILabel *endTime;
@property (strong, nonatomic) IBOutlet UILabel *CDTime;
@property (strong, nonatomic) IBOutlet UIImageView *bankIcon;
@property (strong, nonatomic) IBOutlet UILabel *bankName;
@property (strong, nonatomic) IBOutlet UILabel *cardLast4Num;
@property (strong, nonatomic) IBOutlet UILabel *servicePeriod;
@property (strong, nonatomic) IBOutlet UILabel *serviceStartAndEndTime;
@property (strong, nonatomic) IBOutlet UIButton *operationButton;
@property (strong, nonatomic) IBOutlet UIButton *buyServiceButton;
@property (nonatomic, copy) BuyServiceEventBlock buyService;
@property (nonatomic, copy) ServiceOperationEvevntBlock operationEvevnt;
@property (nonatomic, copy) AskPayEventBlock askPay;
- (IBAction)buyServiceButtonClick:(UIButton *)sender;
- (IBAction)operationButtonClick:(UIButton *)sender;


//银行卡信息
@property (strong, nonatomic) IBOutlet UIView *onlyOneCardView;
@property (strong, nonatomic) IBOutlet UIView *threeCardsView;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView1;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView2;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView3;
@property (strong, nonatomic) IBOutlet UILabel *cardNum1;
@property (strong, nonatomic) IBOutlet UILabel *cardNum2;
@property (strong, nonatomic) IBOutlet UILabel *cardNum3;


//pos隐藏信息
@property (strong, nonatomic) IBOutlet UILabel *tianhouLable;
@property (strong, nonatomic) IBOutlet UILabel *fuwuLabel;
@property (strong, nonatomic) IBOutlet UILabel *fuwuqixianLable;
@property (strong, nonatomic) IBOutlet UILabel *yueLabel;
@property (strong, nonatomic) IBOutlet UILabel *fuwuqiLabel;

- (void)setPosItemShowState:(BOOL)state;
- (void)setCardsInfo:(NSArray *)cardsInfo;
@end
