//
//  CompensateDataModel.m
//  JinFu
//
//  Created by ybon on 16/2/3.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "CompensateDataModel.h"

@implementation CompensateDataModel
+(instancetype)getInstanceWithDataDict:(NSDictionary*)dataDict {
    CompensateDataModel *dataModel = [[CompensateDataModel alloc] initWithDataict:dataDict];
    return dataModel;
}

- (instancetype)initWithDataict:(NSDictionary*)dataDict {
    self = [super init];
    if (self) {
        self.compensateTitle = [self getTitleWithType:[[dataDict objectForKey:@"type"] integerValue]];
        self.stateStr = [self getStateWithStatus:[[dataDict objectForKey:@"status"] integerValue]];
        self.state = [[dataDict objectForKey:@"status"] integerValue];
        self.compensateType = [[dataDict objectForKey:@"type"] integerValue];
        self.appyTime = [self getTimeWithTimeDict:[dataDict objectForKey:@"addTime"]];
        self.imageArr = [self getImagesWithImageFiles:[dataDict objectForKey:@"fileImgFile"]];
        self.userName = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"member"][@"realname"]];
        self.IDNum = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"idcard"]];
        self.TelNum = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"phone"]];
        self.creditCard = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"credit"]];
        self.amount = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"cost"]];
        self.remark = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"handleContent"]];
    }
    return self;
}

- (NSMutableArray *)getImagesWithImageFiles:(NSArray*)arr {
    if (arr.count == 0) {
        return [[NSMutableArray alloc] init];
    }
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (NSDictionary *fileDict in arr) {
        NSMutableString *hostUrl = [NSMutableString stringWithString:HostUrl];
        NSString* realurl = [hostUrl substringToIndex:[hostUrl length]-1];
        NSString *imagePath = [NSString stringWithFormat:@"%@%@/%@",realurl, [fileDict objectForKey:@"path"], [fileDict objectForKey:@"name"]];
        [imageArr addObject:imagePath];
    }
    return imageArr;
}


- (NSString *)getTitleWithType:(NSInteger)type {
    NSString *retStr = @"";
    if (type == 1) {
        retStr = @"丢卡赔付";
    }else if(type == 2) {
        retStr = @"盗刷赔付";
    }else if (type == 3) {
        
    }else if (type == 4) {
    
    }
    return retStr;
}

- (NSString *)getStateWithStatus:(NSInteger)status {
    NSString *retStr = @"";
    if (status == 0) {
        retStr = @"待审核";
    }else if(status == 1) {
        retStr = @"已通过";
    }else if (status == 2) {
        retStr = @"未通过";
    }
    return retStr;
}

- (NSString *)getTimeWithTimeDict:(NSDictionary *)dict {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"time"] doubleValue]/1000];
    NSMutableString *dateStr = [NSMutableString stringWithString:date.description];
    [dateStr replaceOccurrencesOfString:@"-" withString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(0, dateStr.length)];
    NSString *retStr = [dateStr substringToIndex:10];
    return retStr;
}
@end
