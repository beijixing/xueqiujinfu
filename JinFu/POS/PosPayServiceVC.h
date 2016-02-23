//
//  PayServiceVC.h
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfoModel.h"

@interface PosPayServiceVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *payServiceInfoTable;
@property (strong, nonatomic) ServiceInfoModel *unautoProtectionInfo;
@end
