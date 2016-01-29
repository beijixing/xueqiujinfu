//
//  FeedBackVC.m
//  JinFu
//
//  Created by ybon on 15/12/18.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "FeedBackVC.h"
#import "AFNetManager.h"
@interface FeedBackVC ()<UITextFieldDelegate, UITextViewDelegate>

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contactWayTF.delegate = self;
    self.feedBackContent.delegate = self;
    self.navigationItem.title = @"意见反馈";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    self.view.userInteractionEnabled = YES;
}


- (void)tapGesture:(UIGestureRecognizer *)gesture {
//    [self.contactWayTF resignFirstResponder];
//    [self.feedBackContent resignFirstResponder];
    [self.view endEditing:YES];
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
        NSString *content = [[NSString stringWithFormat:@"%@", self.feedBackContent.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *contact = [[NSString stringWithFormat:@"%@", self.contactWayTF.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *memberId = [[NSString stringWithFormat:@"%@", @"1010"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:content, @"content", contact, @"contact", memberId, @"memberId", nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedBackNotification:) name:FeedBack object:nil];
        [[AFNetManager sharedManager] postDataToServerWithHostUrl:[NSString stringWithFormat:@"%@%@",HostUrl,FeedBack] andParameters:parameters andNotificationName:FeedBack];
    }
}

- (void)feedBackNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FeedBack object:nil];
    DLog(@"%@",resultDic);
    NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
    NSString *msg = [responseObject objectForKey:@"MSG"];
    [ToolBox showAlertInfo:msg];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = @"";
    return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请留下您的意见（最多输入100字）";
    }
    return true;
}
@end
