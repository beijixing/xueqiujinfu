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
@implementation ProtectionCardCell

- (void)awakeFromNib {
    // Initialization code
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

    }else if (cardsInfo.count == 2){
        
        self.onlyOneCardView.hidden = YES;
        self.threeCardsView.hidden = NO;
        [self set2CardsInfo:cardsInfo];
        
    }else if (cardsInfo.count == 3) {
        self.onlyOneCardView.hidden = YES;
        self.threeCardsView.hidden = NO;
        [self set2CardsInfo:cardsInfo];
        ServiceCardListDataModel *thirdCardData = cardsInfo[2];
       NSString *iconPath = [[BankCardIconManager sharedManager] getBankIconPathWithName: thirdCardData.bankName];
        self.cardImageView3.image = ImageName(iconPath);
        self.cardImageView3.hidden = NO;
        self.cardNum3.text = [self getCardNUmberText:thirdCardData.cardNumber];
        self.cardNum3.hidden = NO;
    }
}

- (void)set2CardsInfo:(NSArray *)cardsInfo {
    ServiceCardListDataModel *firstCardData = cardsInfo[0];
    NSString *iconPath = [[BankCardIconManager sharedManager] getBankIconPathWithName: firstCardData.bankName];
    self.cardImageView1.image = ImageName(iconPath);
    self.cardImageView1.hidden = NO;
    self.cardNum1.text = [self getCardNUmberText:firstCardData.cardNumber];
    self.cardNum1.hidden = NO;
    ServiceCardListDataModel *secondCardData = cardsInfo[1];
    iconPath = [[BankCardIconManager sharedManager] getBankIconPathWithName: secondCardData.bankName];
    self.cardImageView2.image = ImageName(iconPath);
    self.cardImageView2.hidden = NO;
    self.cardNum2.text = [self getCardNUmberText:secondCardData.cardNumber];
    self.cardNum2.hidden = NO;
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

@end
