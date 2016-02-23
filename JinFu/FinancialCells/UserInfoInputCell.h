//
//  UserInfoInputCell.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GetInputTextBlock)(NSString *);
@interface UserInfoInputCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *inputTF;
@property (nonatomic ,copy) GetInputTextBlock getInputText;
@end
