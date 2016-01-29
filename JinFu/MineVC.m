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
#import "MySettingsViewController.h"
#import "PopularizeRigesterViewController.h"
#import "MyInComeViewController.h"
#import "AppDelegate.h"
#import "RegisterSucceedViewController.h"
#import "AFNetworking.h"
#import "AFNetManager.h"
#import "ValueAddedVC.h"
#import "DBManager.h"
#import "UserInfoModel.h"
#import "AFNetworkReachabilityManager.h"
#define LoginMemberUsername @"http://192.168.1.39:8080/finaServ/member/info.do"
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
    
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {
        self.userName.text = [UserInfoModel sharedUserInfo].realName;
        self.userName.textAlignment = NSTextAlignmentCenter;
    }else{
        NSString * URL = LoginMemberUsername;
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
        [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if (![self isBlankString:dic[@"realname"]]) {
                self.userName.text = dic[@"realname"];
                [UserInfoModel sharedUserInfo].realName = [NSString stringWithFormat:@"%@", dic[@"realname"]];
                [[DBManager sharedDBManager] saveUserInfo:[UserInfoModel sharedUserInfo]];
                DLog(@"userName == %@",dic[@"realname"]);
                DLog(@"NSDictionary ========== %@",dic);
                self.userName.textAlignment = NSTextAlignmentCenter;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error:%@",error);
        }];
    }
    
    cellDataArr = [[NSMutableArray alloc] init];
    //定制返回按钮
    UIBarButtonItem *blackItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = blackItem;
    //返回按钮白色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];//用于返回按钮
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
    DLog(@"indexpath section = %ld", indexPath.section);
   
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:[[ValueAddedVC alloc] init] animated:YES];
    }
    if (indexPath.section == 1) {
        [self enterPromoter];
    }
    if (indexPath.section == 2)
    {
        [self.navigationController pushViewController:[[FeedBackVC alloc] init] animated:YES];
    }
    if (indexPath.section == 3) {
        [self.navigationController pushViewController:[[MySettingsViewController alloc] init] animated:YES];
    }
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)enterPromoter {
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {
        if ([[UserInfoModel sharedUserInfo].promoter isEqualToString:@"true"]) {
            MyInComeViewController * vc = [[MyInComeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        NSString * sURL = [HostUrl stringByAppendingString:PopulerRegister];
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:sURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dictJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            DLog(@"推广员是否注册：%@",dictJSON);
            [[NSUserDefaults standardUserDefaults] setObject:dictJSON[@"result"] forKey:@"isRigest"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([dictJSON[@"result"] intValue] == 0) {
                PopularizeRigesterViewController * popvc = [[PopularizeRigesterViewController alloc]init];
                [self.navigationController pushViewController:popvc animated:YES];
            }
            if ([dictJSON[@"result"] intValue] == 1)
            {
                [UserInfoModel sharedUserInfo].promoter = @"true";
                [[DBManager sharedDBManager] saveUserInfo:[UserInfoModel sharedUserInfo]];
                MyInComeViewController * vc = [[MyInComeViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@",error);
        }];
    }
}
@end
