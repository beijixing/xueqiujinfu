//
//  EditRemindDateCell.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PullDownMenu2.h"
#import "PullDownMenu.h"

@interface EditRemindDateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *preRemindDays;
@property (weak, nonatomic) IBOutlet UIImageView *daysArrow;
@property (weak, nonatomic) IBOutlet UILabel *remindTime;
@property (weak, nonatomic) IBOutlet UIImageView *timeArrow;

@property (strong, nonatomic) IBOutlet UILabel *remindTipLB;
@property (nonatomic, copy) ShowAndHideListViewEvent showListViewEvent;
@property (nonatomic, copy) ShowAndHideListViewEvent hideListViewEvent;
@property (nonatomic, copy) GetSelectedDataIdxBlock getDateText;
@property (nonatomic, copy) GetSelectedDataIdxBlock getTimeText;

- (void)setBlock;
- (void)setPullMenuState:(BOOL)state;
- (void)setDate:(NSInteger)date andTime:(NSInteger)time;
//- (void)setIndicatorImageName:(NSString *)imageName andSize:(CGSize)size;
- (void)setDateDataSoure:(NSArray *)dateData andTimeDataSource:(NSArray *)timeData;
- (void)setPullMenuBackgroundColor:(UIColor *)backgroundColor;
//- (void)setShowSmallImageView:(BOOL)show;
//- (void)
@end
