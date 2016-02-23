//
//  ProtectionCardCell.m
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "ProtectionCardCell.h"
#import "LostCardPayServiceVC.h"
#import "ServiceCardListDataModel.h"
#import "BankCardIconManager.h"
#import "CardAndNumberCell.h"
@interface ProtectionCardCell ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_cardList;
    NSArray *_dataArr;
}
@end

@implementation ProtectionCardCell


- (void)awakeFromNib {
    
    CGRect frame = CGRectMake(self.threeCardsView.frame.size.height/3, -self.threeCardsView.frame.size.height/2, self.threeCardsView.frame.size.height, self.threeCardsView.frame.size.width);
    _cardList = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _cardList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cardList.showsHorizontalScrollIndicator = NO;
    _cardList.showsVerticalScrollIndicator = NO;
    _cardList.dataSource = self;
    _cardList.delegate = self;
    _cardList.transform = CGAffineTransformMakeRotation(-M_PI / 2);//横向滚动
    _cardList.backgroundColor = [UIColor clearColor];
    [self.threeCardsView addSubview:_cardList];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)buyServiceButtonClick:(UIButton *)sender {
    if (self.buyService)
    {
        self.buyService();
    }
}

- (IBAction)operationButtonClick:(UIButton *)sender {
    if (self.operationEvevnt) {
        self.operationEvevnt();
    }

    if (self.askPay) {
        self.askPay();
    }
}


- (void)setCardsInfo:(NSArray *)cardsInfo {
    if (cardsInfo.count == 1) {
        self.onlyOneCardView.hidden = NO;
        self.threeCardsView.hidden = YES;
        ServiceCardListDataModel *cardData = cardsInfo[0];
        self.bankName.text = [NSString stringWithFormat:@"%@", cardData.bankName];
        
        self.cardLast4Num.text = [self getCardNUmberText:cardData.cardNumber];;
        NSString *iconPath = [[BankCardIconManager sharedManager] getBankIconPathWithName: cardData.bankName];
        self.bankIcon.image = ImageName(iconPath);
    }else {
        self.onlyOneCardView.hidden = YES;
        self.threeCardsView.hidden = NO;
        _dataArr = cardsInfo;
        [_cardList reloadData];
    }
}

- (NSString *)getCardNUmberText:(NSString *)cardNumber {
    NSString *cardNumberText;
    if (cardNumber.length < 5) {
        cardNumberText = cardNumber;
    }else {
        cardNumberText = [NSString stringWithFormat:@"%@", [cardNumber substringWithRange:NSMakeRange(cardNumber.length-5, 4)]];
    }
    return cardNumberText;
}

- (void)setPosItemShowState:(BOOL)state {
    if (state) {//显示pos无关的标签
        self.tianhouLable.hidden = YES;
        self.fuwuLabel.hidden = YES;
        self.fuwuqixianLable.hidden = YES;
        self.yueLabel.hidden = YES;
        self.fuwuqiLabel.hidden = YES;
        self.endTime.hidden = YES;
        self.CDTime.hidden = YES;
        self.bankIcon.hidden = YES;
        self.bankName.hidden = YES;
        self.cardLast4Num.hidden = YES;
        self.servicePeriod.hidden = YES;
        self.serviceStartAndEndTime.hidden = YES;
        self.buyServiceButton.hidden = YES;
    }else {
        self.tianhouLable.hidden = NO;
        self.fuwuLabel.hidden = NO;
        self.fuwuqixianLable.hidden = NO;
        self.yueLabel.hidden = NO;
        self.fuwuqiLabel.hidden = NO;
        self.endTime.hidden = NO;
        self.CDTime.hidden = NO;
        self.bankIcon.hidden = NO;
        self.bankName.hidden = NO;
        self.cardLast4Num.hidden = NO;
        self.servicePeriod.hidden = NO;
        self.serviceStartAndEndTime.hidden = NO;
        self.buyServiceButton.hidden = NO;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardAndNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardAndNumberCell"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CardAndNumberCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);//横向滚动
    }
    ServiceCardListDataModel *cardData = _dataArr[indexPath.row];
    cell.cardNumber.text = [self getCardNUmberText:cardData.cardNumber];;
    NSString *iconPath = [[BankCardIconManager sharedManager] getBankIconPathWithName: cardData.bankName];
    cell.cardImageView.image = ImageName(iconPath);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
@end
