//
//  AddPosInfoVC.h
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfoModel.h"
#import "ServiceTypeDataModel.h"

@interface AddPosInfoVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) ServiceTypeDataModel *posInfo;
@property (strong, nonatomic) IBOutlet UITableView *addPosInfoTable;
@property (strong, nonatomic) ServiceInfoModel *unauthorizedInfo;
@property (nonatomic) NSInteger operationType;//0添加保障，2审核未过重新编辑保障

@end
