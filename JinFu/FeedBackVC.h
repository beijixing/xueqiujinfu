//
//  FeedBackVC.h
//  JinFu
//
//  Created by ybon on 15/12/18.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackVC : UIViewController
- (IBAction)feedBackButtonClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *contactWayTF;

@property (strong, nonatomic) IBOutlet UITextView *feedBackContent;
@end
