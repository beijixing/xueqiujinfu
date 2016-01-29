//
//  ServicePeriodCell.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullDownMenu.h"
@interface ServicePeriodCell : UITableViewCell

@property (nonatomic, copy) ShowAndHideListViewEvent showListViewEvent;
@property (nonatomic, copy) ShowAndHideListViewEvent hideListViewEvent;
@property (nonatomic, copy) GetSelectedDataIdxBlock getSelectedText;
- (void)setBlock;
- (void)setPullMenuState:(BOOL)state;
- (void)setSelectDataIdx:(NSInteger)idx;
//- (void)setIndicatorImageName:(NSString *)imageName;
- (void)setpullMenuDataSoure:(NSArray *)dataSource;
@end
