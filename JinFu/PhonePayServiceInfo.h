//
//  PhonePayServiceInfo.h
//  JinFu
//
//  Created by ybon on 15/12/29.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfoModel.h"

@interface PhonePayServiceInfo : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *phoneServiceInfoTable;
@property (strong, nonatomic) ServiceInfoModel *unautoProtectionInfo;

@end
