//
//  ImportBillVC.h
//  JinFu
//
//  Created by ybon on 15/12/17.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "BaseViewController.h"

@interface ImportBillVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *billCount;
@property (strong, nonatomic) IBOutlet UITableView *billsTableView;
@property (strong, nonatomic) IBOutlet UILabel *importPercent;
@property (strong, nonatomic) IBOutlet UIImageView *progressImage;

@end
