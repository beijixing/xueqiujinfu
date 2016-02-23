//
//  EditRemindDateCell.m
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "EditRemindDateCell.h"


@interface EditRemindDateCell()
{
    PullDownMenu *_remindDate;
    PullDownMenu *_remindTimeMenu;
}
@end

@implementation EditRemindDateCell

- (void)awakeFromNib {
    
   CGFloat dateBaseXpos = CGRectGetMaxX(self.remindTipLB.frame);
    _remindDate = [[PullDownMenu alloc] initWithFrame:CGRectMake(dateBaseXpos+5, 4, MainScreenWidth/4, 35)];
    _remindDate.hideListFrame = CGRectMake(dateBaseXpos+5, 8, MainScreenWidth/4, 35);
    _remindDate.showListFrame = CGRectMake(dateBaseXpos+5, 8, MainScreenWidth/4, 80);
    _remindDate.indicatorImageName = @"arrow-left";
    [self.contentView addSubview:_remindDate];

    CGFloat timeBaseXpos = dateBaseXpos+5 + MainScreenWidth/4+5;
    CGFloat timeWidth = MainScreenWidth - timeBaseXpos - 20;
    _remindTimeMenu = [[PullDownMenu alloc] initWithFrame:CGRectMake(timeBaseXpos, 4, timeWidth, 35)];
    _remindTimeMenu.hideListFrame = CGRectMake(timeBaseXpos, 8, timeWidth, 35);
    _remindTimeMenu.showListFrame = CGRectMake(timeBaseXpos, 8, timeWidth, 80);
    _remindTimeMenu.indicatorImageName = @"arrow-left";
    [self.contentView addSubview:_remindTimeMenu];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setBlock {
    _remindDate.showListViewEvent = self.showListViewEvent;
    _remindDate.hideListViewEvent = self.hideListViewEvent;
    _remindDate.getSelectedDataIdx = self.getDateText;
    
    _remindTimeMenu.showListViewEvent = self.showListViewEvent;
    _remindTimeMenu.hideListViewEvent = self.hideListViewEvent;
    _remindTimeMenu.getSelectedDataIdx = self.getTimeText;
}
- (void)setPullMenuState:(BOOL)state {
    _remindDate.showList = state;
    _remindTimeMenu.showList = state;
}
- (void)setDate:(NSInteger)date andTime:(NSInteger)time {
    _remindDate.defaultDataId = date;
    _remindTimeMenu.defaultDataId = time;
}

//- (void)setShowSmallImageView:(BOOL)show {
//    [_remindDate showAmallImageView:show];
//    [_remindTimeMenu showAmallImageView:show];
//}
- (void)setDateDataSoure:(NSArray *)dateData andTimeDataSource:(NSArray *)timeData {
    DLog(@"dateData = %@ timeData = %@", dateData, timeData);
    _remindDate.dataSource = dateData;
    _remindTimeMenu.dataSource = timeData;
}

- (void)setPullMenuBackgroundColor:(UIColor *)backgroundColor {
    _remindDate.backgroundColor = backgroundColor;
    _remindTimeMenu.backgroundColor = backgroundColor;
}
@end
