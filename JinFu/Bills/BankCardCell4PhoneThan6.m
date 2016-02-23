//
//  BankCardCell4PhoneThan6.m
//  JinFu
//
//  Created by ybon on 16/1/27.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "BankCardCell4PhoneThan6.h"

@interface BankCardCell4PhoneThan6()<UITextFieldDelegate>
{
    BOOL bShowListView;
    UITapGestureRecognizer *hideGesture;
}

@end
@implementation BankCardCell4PhoneThan6

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent)];
    [self.payButtonView  addGestureRecognizer:tapGesture];
    bShowListView = false;
    self.payPartTF.delegate = self;
    
}

- (void)hideGestureEvent {
    bShowListView = false;
    self.pullView.hidden = YES;
    if (hideGesture) {
        [self.contentView removeGestureRecognizer:hideGesture];
        hideGesture = nil;
    }
}

- (void)tapGestureEvent{
    bShowListView = !bShowListView;
    if (bShowListView) {
        self.pullView.hidden = NO;
        hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGestureEvent)];
        [self.contentView  addGestureRecognizer:hideGesture];
    }else{
        self.pullView.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)billDetailButtonClick:(UIButton *)sender {
    if (self.billDetailButtonAction) {
        self.billDetailButtonAction(sender);
    }
}
- (IBAction)unpayButtonClick:(UIButton *)sender {
    if (self.getPayState)
    {
        self.getPayState(0, 0.0);
    }
    
    self.payStateLabel.text = @"未还款";
    self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg0"];
}

- (IBAction)paidButtonClick:(UIButton *)sender {
    if (self.getPayState) {
        self.getPayState(1, 0.0);
    }
    
    self.payStateLabel.text = @"已还款";
    self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg1"];
}

- (IBAction)payPartButtonClick:(UIButton *)sender {
    if (self.getPayState) {
        if ([self.payPartTF.text isEqualToString:@""] ||  [self.payPartTF.text integerValue] == 0) {
            [ToolBox showAlertInfo:@"请输入付款金额"];
        }else{
            self.getPayState(3, [self.payPartTF.text floatValue]);
            self.payStateLabel.text = self.payPartTF.text;
            self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg2"];
        }
        
    }
}

- (void)setPayState:(NSString *)state andPaidNum:(NSString *)paid {
    bShowListView = false;
    self.pullView.hidden = YES;
    if ([state isEqualToString:@"0"]) {
        self.payStateLabel.text = @"未还款";
        self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg0"];
    }else if ([state isEqualToString:@"1"]) {
        self.payStateLabel.text = @"已还款";
        self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg1"];
    }else if ([state isEqualToString:@"3"]) {
        self.payStateLabel.text = [NSString stringWithFormat:@"%@", paid];
        self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg2"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //    if (self.getPayState) {
    //        self.getPayState(1, [self.payPartTF.text floatValue]);
    //    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
