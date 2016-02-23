//
//  CompensateCell.h
//  JinFu
//
//  Created by ybon on 16/2/3.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompensateCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *compensateTitle;
@property (strong, nonatomic) IBOutlet UILabel *applyTime;
@property (strong, nonatomic) IBOutlet UILabel *state;
@property (strong, nonatomic) IBOutlet UIImageView *stateBg;
@end
