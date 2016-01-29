//
//  BillDetailCellThree.h
//  JinFu
//
//  Created by ybon on 15/12/23.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillDetailCellThree : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *date;

@property (strong, nonatomic) IBOutlet UILabel *payway;
@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet UILabel *place;
@end
