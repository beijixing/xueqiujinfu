//
//  CommitCell.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *agreeStateImage;

- (IBAction)agreeProtocolButtonClick:(UIButton *)sender;
- (IBAction)commitButtonClick:(UIButton *)sender;
@end
