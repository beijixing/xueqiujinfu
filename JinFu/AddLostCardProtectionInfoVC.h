//
//  AddLostCardProtectionInfoVC.h
//  JinFu
//
//  Created by ybon on 15/12/28.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfoModel.h"
#import "ServiceTypeDataModel.h"

@interface AddLostCardProtectionInfoVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *addProtectionInfoTabe;
@property (strong, nonatomic) ServiceTypeDataModel *serviceInfo;
@property (strong, nonatomic) ServiceInfoModel *unauthorizedInfo;
@property (nonatomic) NSInteger addedCardNumberCnt;
@property (nonatomic) NSInteger operationType;//0添加保障，1续保，2审核未过重新编辑保障
@end
