//
//  AppDelegate.m
//  MD5Demo
//
//  Created by 谢涛 on 15/4/17.
//  Copyright (c) 2015年 X.T. All rights reserved.
//

#import "MyMD5.h"
#import "CommonCrypto/CommonDigest.h"

@implementation MyMD5

+ (NSString *)md5:(NSString *) inPutText {
    const char *cStr = [inPutText UTF8String];
//    const char *cStr = [inPutText cStringUsingEncoding:NSUTF16StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    NSString *upercaseStr = [ret uppercaseString];
    return upercaseStr;
}

@end
