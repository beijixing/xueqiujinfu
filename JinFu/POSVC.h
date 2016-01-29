//
//  POSVC.h
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceTypeDataModel.h"
@interface POSVC : BaseViewController

@property (strong, nonatomic) IBOutlet UITextView *descTextView;
@property (strong, nonatomic) ServiceTypeDataModel *posInfo;
- (IBAction)buyProtectionButtonClick:(UIButton *)sender;
@end
