//
//  JFTabBarController.m
//  JinFu
//
//  Created by ybon on 15/12/16.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "JFTabBarController.h"
#import "HomeVC.h"
#import "FinancialVC.h"
#import "MineVC.h"

@interface JFTabBarController ()

@end

@implementation JFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:[[HomeVC alloc] init]];
    homeNav.tabBarItem.title = @"账单";
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar1_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.image = [[UIImage imageNamed:@"tabBar1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UINavigationController *finNav = [[UINavigationController alloc] initWithRootViewController:[[FinancialVC alloc] init]];
    finNav.tabBarItem.title = @"金服";
    finNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar2_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    finNav.tabBarItem.image = [[UIImage imageNamed:@"tabBar2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:[[MineVC alloc] init]];
    mineNav.tabBarItem.title = @"我";
    mineNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar3_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.image = [[UIImage imageNamed:@"tabBar3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ;
//    [UIColor colorWithRed:160/255 green:160/255 blue:160/255 alpha:1.0]
//    [UIColor colorWithRed:240/255 green:190/255 blue:20/255 alpha:1.0]
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorWithRGB(160, 160, 160), NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:15.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorWithRGB(240, 190, 20), NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    self.viewControllers = @[homeNav, finNav, mineNav];
}
@end