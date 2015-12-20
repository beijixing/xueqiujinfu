//
//  unauthoProtectionInfoVC.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/19.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnauthoProtectionInfoVC : BaseViewController< UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *protectionInfoTable;

@end
