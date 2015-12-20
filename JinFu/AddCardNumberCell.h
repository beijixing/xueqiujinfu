//
//  AddCardNumberCell.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCardNumberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTf;
- (IBAction)addButtonClick:(UIButton *)sender;

@end
