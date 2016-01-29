//
//  IncomeDetailTableViewCell.h
//  JinFu
//
//  Created by 山东远邦 on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeDetailTableViewCell : UITableViewCell
//收入明细
@property (nonatomic,retain)UILabel * labelName;
@property (nonatomic,retain)UILabel * labelNum;
@property (nonatomic,retain)UILabel * labelDate;


//提现明细
@property (nonatomic,retain)UILabel * labelGetDate;
@property (nonatomic,retain)UILabel * labelGetNum;
@end
