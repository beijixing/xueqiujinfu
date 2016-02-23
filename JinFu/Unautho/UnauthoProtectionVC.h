//
//  UnauthoProtectionVC.h
//  JinFu
//
//  Created by ybon on 15/12/18.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceTypeDataModel.h"
@interface UnauthoProtectionVC : BaseViewController
@property (strong, nonatomic) IBOutlet UITextView *descTextView;
- (IBAction)buyServiceBtnClick:(UIButton *)sender;
@property(strong, nonatomic) ServiceTypeDataModel *serviceInfo;
@end
