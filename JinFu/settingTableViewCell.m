//
//  settingTableViewCell.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/23.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "settingTableViewCell.h"
#define SCALE [UIScreen mainScreen].bounds.size.width/320
@implementation settingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(50*SCALE, 5, 200*SCALE, 20)];
        [self.contentView addSubview:self.title];
        self.IconiView = [[UIImageView alloc]initWithFrame:CGRectMake(15*SCALE, 5, 20*SCALE, 20)];
        [self.contentView addSubview:self.IconiView];
        self.RightiView = [[UIImageView alloc]initWithFrame:CGRectMake(290*SCALE, 5, 10*SCALE, 15)];
        [self.contentView addSubview:self.RightiView];
    }
    return self;
}
@end
