//
//  CommitCell.m
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "CommitCell.h"

@interface CommitCell ()
{
}
@end
@implementation CommitCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBAgreeProtocol:(BOOL)bAgreeProtocol {
    if(_bAgreeProtocol != bAgreeProtocol){
        _bAgreeProtocol = bAgreeProtocol;
        if (_bAgreeProtocol) {
            self.agreeImage.image = ImageName(@"selected");
        }
        else
        {
            self.agreeImage.image = ImageName(@"unselect");
        }
    }
    
}

- (IBAction)agreeProtocolButtonClick:(UIButton *)sender {
    self.bAgreeProtocol = !self.bAgreeProtocol;
    if (self.agreeProtocolAction) {
        self.agreeProtocolAction(self.bAgreeProtocol);
    }
}

- (IBAction)commitButtonClick:(UIButton *)sender {
    if (self.commitButtonAction) {
        self.commitButtonAction();
    }
}
@end
