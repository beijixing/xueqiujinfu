//
//  AddCardNumberCell.m
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "AddCardNumberCell.h"

@implementation AddCardNumberCell

- (void)awakeFromNib {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonViewClick)];
    [self.buttonView addGestureRecognizer:tapGesture];
    self.cardNumberTf.delegate = self;
    self.bankNameTF.delegate = self;
}

- (void)buttonViewClick {
    if (self.buttonViewAction) {
        self.buttonViewAction();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.getCardNumber && self.cardNumberTf == textField) {
        self.getCardNumber(textField.text);
    }else if(self.getBankName && self.bankNameTF == textField) {
        self.getBankName(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
