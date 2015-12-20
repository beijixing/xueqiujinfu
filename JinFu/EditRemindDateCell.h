//
//  EditRemindDateCell.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditRemindDateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *preRemindDays;
@property (weak, nonatomic) IBOutlet UIImageView *daysArrow;
@property (weak, nonatomic) IBOutlet UILabel *remindTime;
@property (weak, nonatomic) IBOutlet UIImageView *timeArrow;

@end
