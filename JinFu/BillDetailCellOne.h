//
//  BillDetailCellOne.h
//  JinFu
//
//  Created by ybon on 15/12/23.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillDetailCellOne : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *totalIntegral;
@property (strong, nonatomic) IBOutlet UILabel *currMonthNewIntegral;

@property (strong, nonatomic) IBOutlet UILabel *lastPaiedAmount;
@property (strong, nonatomic) IBOutlet UILabel *currMonthAmount;

@end