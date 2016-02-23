//
//  MySettingsViewController.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/23.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "MySettingsViewController.h"
#import "settingTableViewCell.h"
#import "NewMessageNotificationVC.h"
#import "AboutUSVC.h"
#import "AFNetManager.h"
#import "UserInfoModel.h"
#import "DBManager.h"

#import "SDImageCache.h"
#import "CustomAlertView.h"
#import "AddSpaceView.h"
#import "LoginVC.h"
#define SCALE [UIScreen mainScreen].bounds.size.width/320
@interface MySettingsViewController ()<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic,retain)UITableView * tableView;
@property (nonatomic,retain)NSArray * arrayItems;
@property (nonatomic,retain)UIAlertView * alert;
@end

@implementation MySettingsViewController
{
    UIView * _view;
    UIImageView * _iViewCenter;
    UIActivityIndicatorView *circle;
    AddSpaceView * addSpaceView;
    
}
@class EPListItem;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"我的设置";
    self.navigationController.navigationBar.barTintColor = [UIColor yellowColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self initUI];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)initData
{
    _arrayItems = @[
                    @[
                        [EPListItem itemWithTitle:@"新消息通知" icon:@"xinxiaoxitongzhi@2x.png" type:SET_XXXTZ],
                        [EPListItem itemWithTitle:@"清除缓存" icon:@"qingchuhuancun@2x.png" type:SET_QCHC],
                        [EPListItem itemWithTitle:@"关于我们" icon:@"guanyuwomen@2x.png" type:SET_GYWM],
                        [EPListItem itemWithTitle:@"退出登录" icon:@"tuichudneglu@2x.png" type:SET_TCDL],
                        ]
                    ];
}
- (void)initUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 44*4) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview: _tableView];

}
#pragma mark - UITatableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrayItems.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayItems[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    EPListItem * item = _arrayItems[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image=[UIImage imageNamed:item.iconName];
    cell.textLabel.text=item.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//UITableViewCell分割线左边部分缺少一些的解决方法
-(void)viewDidLayoutSubviews {
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EPListItem * item = _arrayItems[indexPath.section][indexPath.row];
    switch (item.type) {
        case SET_XXXTZ:
            [self pushToDetailVC:item.type];
            break;
        case SET_QCHC:
            [self pushToDetailVC:item.type];
            break;
        case SET_GYWM:
            [self pushToDetailVC:item.type];
            break;
        case SET_TCDL:
            [self pushToDetailVC:item.type];
            break;
        default:
            break;
    }
}
- (void)pushToDetailVC:(SET_FOUDATION)type
{
    switch (type) {
        case SET_XXXTZ:
            [self.navigationController pushViewController:[[NewMessageNotificationVC alloc] init] animated:YES];
            break;
        case SET_QCHC:
            [self clearCache];
            
            break;
        case SET_GYWM:
            [self.navigationController pushViewController:[[AboutUSVC alloc]init] animated:YES];
            break;
        case SET_TCDL:
//            _alert = [[UIAlertView alloc]initWithTitle:@"你确定退出么？" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            _alert.delegate = self;
//            [_alert addButtonWithTitle:@"取消"];
//              [_alert show];
            [self createAlertViewCustom];
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        DLog(@"确定");
        //退出登录回到登录页面
        LoginVC *loginVc = [[LoginVC alloc] init];
        [self presentViewController:loginVc animated:YES completion:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberExitNotification:) name:MemberExit object:nil];
        [[AFNetManager sharedManager] getDataFromServerWithHostUrl:[NSString stringWithFormat:@"%@%@", HostUrl, MemberExit] andParameters:@"" andNotificationName:MemberExit];
    }else if (buttonIndex == 1) {
        DLog(@"取消");
    }
}
- (void)createAlertViewCustom
{
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:nil
                                                                message:@"确定要退出么?"
                                                               delegate:self
                                                      cancelButtonTitle:@""
                                                      otherButtonTitles: @"",nil];
    //    [alertView addCustomerSubview:myView];
    [alertView show];
}
-(void)clearCache
{
    [[SDImageCache sharedImageCache]cleanDisk];
    _popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake((150-80)/2, 20, 80, 80)];
    [imageV setImage:[UIImage imageNamed:@"qinchuhuancun-tanch@2x.png"]];
    [_popupView addSubview:imageV];
    [self performSelector:@selector(clearn) withObject:nil afterDelay:2.0];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 20+80+10, 140, 30)];
    label.text = @"正在清理缓存";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    [_popupView addSubview:label];
    self.popupView.layer.cornerRadius = 12;
    self.popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    addSpaceView = [[AddSpaceView alloc] initWithParentView:window.rootViewController.view];
    self.popupView.center = addSpaceView.center;
    [addSpaceView setDelegate:self];
    [addSpaceView addSubview:self.popupView];
    [addSpaceView show];
}

- (void)memberExitNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MemberExit object:nil];
    NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
    DLog(@"resultDic = %@", responseObject);
    
    NSString *flag = [responseObject objectForKey:@"flag"];
    if ([flag isEqualToString:@"1"]) {
        [UserInfoModel sharedUserInfo].loginSuccess = @"false";
        [[DBManager sharedDBManager] deleteUserInfo];
    }
}
- (void)clearn
{
    [self closeAddSpaceView:addSpaceView];
}
    
- (void)closeAddSpaceView:(AddSpaceView *)spaceView
{
    [spaceView close];
}

- (void)disappear:(NSTimer *)timer
{
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
}

    
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
@end
@implementation EPListItem

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)iconName type:(SET_FOUDATION)type
{
    EPListItem * item = [[EPListItem alloc]init];
    item.title = title;
    item.iconName = iconName;
    item.type = type;
    return item;
}

@end