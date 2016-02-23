//
//  LostCardPaymentsDetailVC.h
//  JinFu
//
//  Created by ybon on 16/2/3.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompensateDataModel.h"
@interface UnauthorizedPaymentsDetailVC : BaseViewController
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *IDcard;
@property (strong, nonatomic) IBOutlet UILabel *TelNum;
@property (strong, nonatomic) IBOutlet UILabel *creditCarsNumber;
@property (strong, nonatomic) IBOutlet UILabel *compensateAmount;
@property (strong, nonatomic) IBOutlet UILabel *state;
@property (strong, nonatomic) IBOutlet UITextView *desTextview;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;
- (void)setImages:(NSArray *)imageNameArr;
@property(nonatomic, strong)CompensateDataModel *dataModel;
@end
