//
//  LostCardVC.h
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceTypeDataModel.h"
@interface LostCardVC : BaseViewController
@property(nonatomic, strong) ServiceTypeDataModel *serviceInfo;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
- (IBAction)buyProtectionButtonClick:(UIButton *)sender;
@end
