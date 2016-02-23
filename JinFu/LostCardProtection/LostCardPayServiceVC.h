//
//  LostCardPayServiceVC.h
//  JinFu
//
//  Created by ybon on 15/12/28.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfoModel.h"

@interface LostCardPayServiceVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *lostCardinfoTable;
@property (strong, nonatomic) ServiceInfoModel *unautoProtectionInfo;
@end
