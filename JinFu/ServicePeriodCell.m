//
//  ServicePeriodCell.m
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "ServicePeriodCell.h"

@interface ServicePeriodCell()
{
    PullDownMenu *_pullDown;
    CGRect _mineFrame;
}
@end
@implementation ServicePeriodCell

- (void)awakeFromNib {
    // Initialization code
    
    DLog(@"ServicePeriodCell");
    
    _pullDown = [[PullDownMenu alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, 4, 100, 35)];
    _pullDown.hideListFrame = CGRectMake(MainScreenWidth - 120, 4, 100, 35);
    _pullDown.showListFrame = CGRectMake(MainScreenWidth - 120, 4, 100, 80);
    _pullDown.indicatorImageName = @"icon-right";
    [self.contentView addSubview:_pullDown];
    _mineFrame = self.frame;
}

- (void)setBlock{
    _pullDown.showListViewEvent = self.showListViewEvent;
    _pullDown.hideListViewEvent = self.hideListViewEvent;
    _pullDown.getSelectedDataIdx = self.getSelectedText;
}

- (void)setPullMenuState:(BOOL)state {
    _pullDown.showList = state;
}

- (void)setSelectDataIdx:(NSInteger)idx {
    _pullDown.defaultDataId = idx;
}

//- (void)setIndicatorImageName:(NSString *)imageName {
//    _pullDown.indicatorImageView.image = ImageName(imageName);
//}

- (void)setpullMenuDataSoure:(NSArray *)dataSource {
    _pullDown.dataSource = dataSource;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
