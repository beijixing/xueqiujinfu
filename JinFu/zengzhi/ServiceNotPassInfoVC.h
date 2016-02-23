//
//  ServiceNotPassInfoVC.h
//  JinFu
//
//  Created by ybon on 15/12/31.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfoModel.h"
#import "ServiceTypeDataModel.h"


/*
 addedCardNumberCnt
 operationType
 */
@interface ServiceNotPassInfoVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *unPassDescTextView;
@property (strong, nonatomic) ServiceInfoModel *serviceInfo;
@property (strong, nonatomic) ServiceTypeDataModel *serviceBaseData;
@property (nonatomic) NSInteger addedCardNumberCnt;
@property (nonatomic) NSInteger operationType;
@property (nonatomic) NSInteger serviceType;
@property (strong, nonatomic) NSString *desc;
- (IBAction)reeditButtonClick:(UIButton *)sender;
@end
