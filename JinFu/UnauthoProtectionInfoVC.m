//
//  unauthoProtectionInfoVC.m
//  JinFu
//
//  Created by 郑光龙 on 15/12/19.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "UnauthoProtectionInfoVC.h"
#import "ProtectionTitleCell.h"
#import "UnauthoPayServiceVC.h"

@interface UnauthoProtectionInfoVC ()

@end

@implementation UnauthoProtectionInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.protectionInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cellName";
    ProtectionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProtectionTitleCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
