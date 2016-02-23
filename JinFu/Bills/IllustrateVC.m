//
//  IllustrateVC.m
//  JinFu
//
//  Created by ybon on 16/1/19.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "IllustrateVC.h"

@interface IllustrateVC ()

@end

@implementation IllustrateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGetureEvent:)];
    [self.view addGestureRecognizer:tapGesture];

    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1500);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1500)];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"liucheng" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    imageView.image = image;
    [scrollView addSubview:imageView];
    [self.view addSubview:scrollView];
}

- (void)tapGetureEvent:(UIGestureRecognizer *)gesture {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
