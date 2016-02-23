//
//  NewMessageNotificationVC.m
//  JinFu
//
//  Created by ybon on 15/12/21.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "NewMessageNotificationVC.h"
#import "LxxPlaySound.h"
@interface NewMessageNotificationVC ()

@end

@implementation NewMessageNotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)NewMessageSwichClicked:(UISwitch *)sender {
}
- (IBAction)soundSwichClicked:(UISwitch *)sender {
    if (self.swichSound.isOn) {
        LxxPlaySound *playSound =[[LxxPlaySound alloc]initForPlayingSystemSoundEffectWith:@"low_power.caf" ofType:@"caf"];
        [playSound play];
         
    }
    
    
}
- (IBAction)shakeSwichClicked:(UISwitch *)sender {
    if (self.swichShake.isOn) {
        LxxPlaySound *playSound =[[LxxPlaySound alloc]initForPlayingVibrate];
        [playSound play];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
