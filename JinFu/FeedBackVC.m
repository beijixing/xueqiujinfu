//
//  FeedBackVC.m
//  JinFu
//
//  Created by ybon on 15/12/18.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "FeedBackVC.h"
#import "AFNetManager.h"
@interface FeedBackVC ()

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)feedBackButtonClick:(UIButton *)sender {
    
    if ([self.feedBackContent.text length] == 0)
    {
        [ToolBox showAlertInfo:@"请输入您的意见"];
        return;
    }else if ( [self.contactWayTF.text length] == 0) {
        
        [ToolBox showAlertInfo:@"请输入联系方式"];
        return;
    }else {
//        http://192.168.1.81:8080/linkfoot/opinion/addOpinion.do ? content= & memberId = & contact =
        
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedBackNotification:) name:@"FeedBack" object:nil];
//        
//        NSString *parameter = [NSString stringWithFormat:@"%@content=%@&contact=%@&memberId=%@",@"linkfoot/opinion/addOpinion.do?", self.feedBackContent.text, self.contactWayTF.text, @"1010"];
//        
//        
//        
//        [[AFNetManager sharedManager] getDataFromServerWithHostUrl:@"http://192.168.1.81:8080/" andParameters:parameter andNotificationName:@"FeedBack"];

        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[NSString stringWithFormat:@"%@", self.feedBackContent.text] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"content", [[NSString stringWithFormat:@"%@", self.contactWayTF.text] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"contact", @"1010", @"memberId", nil];
        
        [[AFNetManager sharedManager] postDataToServerWithHostUrl:@"http://192.168.1.81:8080/linkfoot/opinion/addOpinion.do?" andParameters:parameters andNotificationName:@"FeedBack"];
    }
    
    NSLog(@"login btn click");
    
    
}

- (void)feedBackNotification:(NSNotification *)notification {
    
    
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FeedBack" object:nil];
    NSLog(@"%@",resultDic);
    
    NSLog(@"registerNotification");
}
@end
