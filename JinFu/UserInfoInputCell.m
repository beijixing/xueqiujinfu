//
//  UserInfoInputCell.m
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "UserInfoInputCell.h"

@implementation UserInfoInputCell

- (void)awakeFromNib {
    // Initialization code
    self.inputTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    DLog(@"textFieldShouldBeginEditing");
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    DLog(@"textFieldDidEndEditing");
    if (self.getInputText) {
        self.getInputText(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
