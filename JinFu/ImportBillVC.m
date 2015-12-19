//
//  ImportBillVC.m
//  JinFu
//
//  Created by ybon on 15/12/17.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "ImportBillVC.h"
#import "ImportBillTableCell.h"
#import "AFNetManager.h"

@interface ImportBillVC ()

@end

@implementation ImportBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = ViewMainColor;
    self.billsTableView.backgroundColor = [UIColor whiteColor];
    
    [self.billsTableView setMyViewLayerBoardColor:[UIColor whiteColor] AndBoardWidth:1 AndCornerRadius:10];
    
    
    if ([self.billsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.billsTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        
    }
    
    if ([self.billsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.billsTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressNotification:) name:ImportBills object:nil];
    
//    NSString *parameter = [NSString stringWithFormat:@"%@email=%@&password=%@",Login, self.emailAccountTF.text, self.emailPswdTF.text];
    [[AFNetManager sharedManager] getDataFromServerWithHostUrl:HostUrl andParameters:ImportBills andNotificationName:ImportBills];
    
    
    
//    ImportBills
    
}

- (void)progressNotification:(NSNotification *)notification {
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cellName";
    ImportBillTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ImportBillTableCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.bankName.text = @"中国人民银行";
    cell.billDate.text = @"2015年10月29日";
    
    return cell;
}

@end
