//
//  CardNumberAndDateCell.m
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "CardNumberAndDateCell.h"

@implementation CardNumberAndDateCell

- (void)awakeFromNib {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonViewClick)];
    [self.addButtonView addGestureRecognizer:tapGesture];
    self.cardNumberTF.delegate = self;
    self.billDateTF.delegate = self;
    self.bankNameTF.delegate = self;
}

- (void)buttonViewClick {
    if (self.buttonViewAction) {
        self.buttonViewAction();
    }
//    DLog(@"buttonViewClick");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    DLog(@"textFieldDidEndEditing");
    if (self.cardNumberBlcok && textField == self.cardNumberTF) {
        self.cardNumberBlcok(textField.text);
    }
    
    if (self.billDateBlcok && textField == self.billDateTF) {
        self.billDateBlcok(textField.text);
    }
    
    if (self.bankNameBlcok && textField == self.bankNameTF) {
        self.bankNameBlcok(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
