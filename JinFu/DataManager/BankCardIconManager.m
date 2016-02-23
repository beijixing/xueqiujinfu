//
//  BankCardIcon.m
//  JinFu
//
//  Created by ybon on 16/1/4.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "BankCardIconManager.h"

@interface BankCardIconManager()
{
    NSDictionary *_bankCardIconDict;
}
@end

@implementation BankCardIconManager




+(instancetype)sharedManager {
    static BankCardIconManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BankCardIconManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSString *resPath = [[NSBundle mainBundle] pathForResource:@"BankNameAndIcon" ofType:@"plist"];
        _bankCardIconDict = [NSDictionary dictionaryWithContentsOfFile:resPath];
    }
    return self;
}

- (NSString *)getBankIconPathWithName:(NSString *)bankName {
    NSString *iconPath = [_bankCardIconDict objectForKey:bankName];
    return iconPath;
}
@end
