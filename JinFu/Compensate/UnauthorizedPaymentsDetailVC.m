//
//  LostCardPaymentsDetailVC.m
//  JinFu
//
//  Created by ybon on 16/2/3.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "UnauthorizedPaymentsDetailVC.h"
#import "UIImageView+WebCache.h"

@interface UnauthorizedPaymentsDetailVC ()
{
    NSArray *_imageViewArr;
}
@end

@implementation UnauthorizedPaymentsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageViewArr = [[NSArray alloc] initWithObjects:self.firstImage, self.secondImage, self.thirdImage, self.fourthImage, nil];
    self.userName.text = self.dataModel.userName;
    self.IDcard.text = self.dataModel.IDNum;
    self.TelNum.text = self.dataModel.TelNum;
    self.creditCarsNumber.text = self.dataModel.creditCard;
    self.compensateAmount.text = [NSString stringWithFormat:@"￥%@", self.dataModel.amount];
    self.state.text = self.dataModel.stateStr;
    self.desTextview.text = self.dataModel.remark;
    [self setImages:self.dataModel.imageArr];
    
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.title = @"赔付记录";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImages:(NSArray *)imageNameArr {
    NSInteger imageNameCnt = 0;
    for (NSString *str in imageNameArr) {
        if (![str isEqualToString:@""]) {
            imageNameCnt++;
        }
    }
    for (int i = 0; i< [_imageViewArr count]; i++) {
        UIImageView *imageView = [_imageViewArr objectAtIndex:i];
        imageView.hidden = YES;
        if (i < imageNameCnt ){
            NSString *imageName = [imageNameArr objectAtIndex:i];
            DLog(@"imageName = %@" , imageName);
            if ([imageName hasPrefix:@"http"]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
            }else{
                imageView.image = ImageName(imageName);
            }
            imageView.hidden = NO;
        }
    }
}

@end
