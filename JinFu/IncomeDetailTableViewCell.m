//
//  IncomeDetailTableViewCell.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "IncomeDetailTableViewCell.h"
#import "QGConfig.h"
@implementation IncomeDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //CGRectMake(20+100*i*SCALE, 80, 80*SCALE, 30)
        //客户名称
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.labelName = [[UILabel alloc]init];
        self.labelName.frame = CGRectMake(35*SCALE, 5, 80*SCALE, 30);
        [self.contentView addSubview:self.labelName];
        //收入金额
        self.labelNum = [[UILabel alloc]init];
        self.labelNum.frame = CGRectMake(135*SCALE, 5, 80*SCALE, 30);
        self.labelNum.textColor = [UIColor colorWithRed:250.0/255 green:211.0f/255 blue:115.0f/255 alpha:1.0f];
        [self.contentView addSubview:self.labelNum];
        //收入日期
        self.labelDate = [[UILabel alloc]init];
        self.labelDate.frame = CGRectMake(230*SCALE, 5, 100*SCALE, 30);
        self.labelDate.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.labelDate];
        
        //提现cell
        //
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.labelGetDate = [[UILabel alloc]init];
        self.labelGetDate.frame = CGRectMake(70*SCALE, 5, 100*SCALE, 30);
        self.labelGetDate.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.labelGetDate];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.labelGetNum = [[UILabel alloc]init];
        self.labelGetNum.frame = CGRectMake(180*SCALE, 5, 80*SCALE, 30);
        self.labelGetNum.textColor = [UIColor redColor];
        self.labelGetNum.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.labelGetNum];
        
    }
    return self;
}

@end
