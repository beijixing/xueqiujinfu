//
//  CardNumberAndDateCell.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardNumberAndDateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTF;
@property (weak, nonatomic) IBOutlet UIButton *addButtonClick;
@property (weak, nonatomic) IBOutlet UILabel *billDate;

@end
