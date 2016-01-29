//
//  UnauthoPayServiceVC.h
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfoModel.h"

@interface UnauthoPayServiceVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *unautoProtectionInfoTable;
@property (strong, nonatomic) ServiceInfoModel *unautoProtectionInfo;
@end
