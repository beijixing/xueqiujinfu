//
//  ServiceNotPassInfoVC.m
//  JinFu
//
//  Created by ybon on 15/12/31.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "ServiceNotPassInfoVC.h"
#import "AddPosInfoVC.h"
#import "AddLostCardProtectionInfoVC.h"
#import "AddProtectionInfoVC.h"
#import "AddPhoneServiceInfoVC.h"

@interface ServiceNotPassInfoVC ()

@end

@implementation ServiceNotPassInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.unPassDescTextView.text = self.desc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reeditButtonClick:(UIButton *)sender {
    if (self.serviceType == 1) {
        //四个服务重新编辑
        AddLostCardProtectionInfoVC *lostCardVc = [[AddLostCardProtectionInfoVC alloc] init];
        lostCardVc.serviceInfo = self.serviceBaseData;
        lostCardVc.unauthorizedInfo = self.serviceInfo;
        lostCardVc.operationType = self.operationType;
        lostCardVc.addedCardNumberCnt = self.addedCardNumberCnt;
        [self.navigationController pushViewController:lostCardVc animated:YES];
    }else if (self.serviceType == 2){
        AddProtectionInfoVC *protectionInfoVc = [[AddProtectionInfoVC alloc] init];
        protectionInfoVc.serviceInfo = self.serviceBaseData;
        protectionInfoVc.unauthorizedInfo = self.serviceInfo;
        protectionInfoVc.addedCardNumberCnt = self.addedCardNumberCnt;
        protectionInfoVc.operationType = self.operationType;
        [self.navigationController pushViewController:protectionInfoVc animated:YES];
    
    }else if (self.serviceType == 3){
        AddPhoneServiceInfoVC *phoneServiceVc = [[AddPhoneServiceInfoVC alloc] init];
        phoneServiceVc.serviceInfo = self.serviceBaseData;
        phoneServiceVc.unauthorizedInfo = self.serviceInfo;
        phoneServiceVc.addedCardNumberCnt = self.addedCardNumberCnt;
        phoneServiceVc.operationType = self.operationType;
        [self.navigationController pushViewController:phoneServiceVc animated:YES];
        
    }else if (self.serviceType == 4){
        AddPosInfoVC *posInfoVc = [[AddPosInfoVC alloc] init];
        posInfoVc.posInfo = self.serviceBaseData;
        posInfoVc.unauthorizedInfo = self.serviceInfo;
        posInfoVc.operationType = self.operationType;
        [self.navigationController pushViewController:posInfoVc animated:YES];
    }
}
@end
