//
//  CommitCell.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AgreePorotocolBlock)(BOOL);
typedef void(^CommitButtonActionBlock)(void);
@interface CommitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *agreeStateImage;
@property (nonatomic, copy) CommitButtonActionBlock commitButtonAction;
@property (nonatomic, copy) AgreePorotocolBlock agreeProtocolAction;
- (IBAction)agreeProtocolButtonClick:(UIButton *)sender;
- (IBAction)commitButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *agreeImage;
@property (nonatomic) BOOL bAgreeProtocol;


@end
