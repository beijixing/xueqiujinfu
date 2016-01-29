//
//  MySettingsViewController.h
//  JinFu
//
//  Created by 山东远邦 on 15/12/23.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    SET_XXXTZ = 1,
    SET_QCHC,
    SET_GYWM,
    SET_TCDL
}SET_FOUDATION;
@interface MySettingsViewController : UIViewController
@property (nonatomic,retain)UIView * popupView;
@end
@interface EPListItem : NSObject

@property (nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString * iconName;

@property (nonatomic,assign)SET_FOUDATION type;

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)iconName type:(SET_FOUDATION)type;

@end
