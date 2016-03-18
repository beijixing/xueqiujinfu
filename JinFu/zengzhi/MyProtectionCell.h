//
//  MyProtectionCell.h
//  JinFu
//
//  Created by ybon on 16/2/25.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BuyServiceEventBlock)(void);
typedef void(^ServiceOperationEvevntBlock)(void);
typedef void(^AskPayEventBlock) (void);
@interface MyProtectionCell : UITableViewCell

@property (strong, nonatomic) UIImageView *bankCardBg;
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIImageView *lineImage;

@property (strong, nonatomic) UILabel *endTime;
@property (strong, nonatomic) UILabel *CDTime;
@property (strong, nonatomic) UIImageView *bankIcon;
@property (strong, nonatomic) UILabel *bankName;
@property (strong, nonatomic) UILabel *cardLast4Num;
@property (strong, nonatomic) UILabel *servicePeriod;
@property (strong, nonatomic) UILabel *serviceStartAndEndTime;
@property (strong, nonatomic) UIButton *operationButton;
@property (strong, nonatomic) UIButton *buyServiceButton;
@property (nonatomic, copy) BuyServiceEventBlock buyService;
@property (nonatomic, copy) ServiceOperationEvevntBlock operationEvevnt;
@property (nonatomic, copy) AskPayEventBlock askPay;
- (void)buyServiceButtonClick:(UIButton *)sender;
- (void)operationButtonClick:(UIButton *)sender;
- (void)setPosItemShowState:(BOOL)state;
- (void)setCardsInfo:(NSArray *)cardsInfo;
@end
