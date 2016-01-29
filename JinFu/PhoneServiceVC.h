//
//  PhoneServiceVC.h
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceTypeDataModel.h"

@interface PhoneServiceVC : BaseViewController
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) ServiceTypeDataModel *serviceInfo;

- (IBAction)buyProtectionButtonClick:(UIButton *)sender;
@end
