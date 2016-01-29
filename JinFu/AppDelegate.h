//
//  AppDelegate.h
//  JinFu
//
//  Created by ybon on 15/12/16.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property BOOL isLogin;
- (void)sendPushChanelIdToServer;
@end

