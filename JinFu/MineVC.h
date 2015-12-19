//
//  MineVC.h
//  JinFu
//
//  Created by ybon on 15/12/16.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *userHead;
@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (strong, nonatomic) IBOutlet UITableView *mineTableView;



@end
