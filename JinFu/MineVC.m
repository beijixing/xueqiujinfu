//
//  MineVC.m
//  JinFu
//
//  Created by ybon on 15/12/16.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "MineVC.h"
#import "MineTableCell.h"
#import "FeedBackVC.h"
@interface MineVC ()
{
    NSMutableArray *cellDataArr;
}
@end

@implementation MineVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的主页";
    self.mineTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.view.backgroundColor = ViewMainColor;
    self.mineTableView.backgroundColor = ViewMainColor;
    
    
    cellDataArr = [[NSMutableArray alloc] init];
    [self initCellData];
}

- (void)initCellData {
    NSArray *zengzhi = [NSArray arrayWithObjects:@"icon-zhengzhifuwu", @"增值服务", nil];
    [cellDataArr addObject:zengzhi];
    
    NSArray *tuiguang = [NSArray arrayWithObjects:@"icon-yewutuiguang", @"业务推广", nil];
    [cellDataArr addObject:tuiguang];
    
    NSArray *yijian = [NSArray arrayWithObjects:@"icon-yijianfankui", @"意见反馈", nil];
    [cellDataArr addObject:yijian];
    
    NSArray *shezhi = [NSArray arrayWithObjects:@"icon-wodeshezhi", @"我的设置", nil];
    [cellDataArr addObject:shezhi];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellNaem = @"cellName";
    MineTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNaem];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineTableCell" owner:self options:nil] lastObject];
    }
    
    NSArray *cellData = [cellDataArr objectAtIndex:indexPath.section];
    cell.iconImage.image = [UIImage imageNamed:cellData[0]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = cellData[1];
    [cell setMyViewLayerBoardColor:[UIColor whiteColor] AndBoardWidth:1 AndCornerRadius: 5];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexpath section = %ld", indexPath.section);
    
    if (indexPath.section == 2)
    {
        [self.navigationController pushViewController:[[FeedBackVC alloc] init] animated:YES];
    }
        
}

@end
