//
//  StolenPayViewController.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/31.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "StolenPayViewController.h"
#import "QGConfig.h"
#import "QGTools.h"
#import "AFNetManager.h"
#import "UIImageExt.h"
#import "AFNetworking.h"
#define SUBHEIGHT (SCREEN_height-64)/16
@interface StolenPayViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UIImagePickerController *imagePicker;
    NSString *_imageFullPath;
    BOOL _isAgreen;
    UIAlertView * alert;
    UIButton * buttonRex;
    NSString * strImageId;
    NSInteger k;
}
@end

@implementation StolenPayViewController
{
    UITextField * ufName;
    UITextField * ufBankName;
    UITextField * ufPhone;
    UITextField * ufBankNumer;
    UITextField * ufCost;
    UILabel * labelUpload;
    UIScrollView *_scrollView;
    UIImageView * buttonAgreenImage;
    UIButton * bbtn1;
    UIButton * bbtn2;
    UIButton * bbtn3;
    UIButton * bbtn4;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"盗刷赔付申请";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initScrollView];
    _isAgreen = NO;
    alert = [[UIAlertView alloc] init];
    
    k= 0;
}
- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREEN_height-64)];
    CGFloat content = 568;
    _scrollView.contentSize = CGSizeMake(SCREEN_width, content);
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    [self initUI];
    
}
- (void)initUI
{
    ufName = [QGTools creatTextField:CGRectMake(20*SCALE, 10, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"姓名" keyboardType:UIKeyboardTypeDefault tag:1001 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    [_scrollView addSubview:ufName];
    ufPhone = [QGTools creatTextField:CGRectMake(20*SCALE, 60, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"手机号码" keyboardType:UIKeyboardTypeDefault tag:1001 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    [_scrollView addSubview:ufPhone];
    ufBankName = [QGTools creatTextField:CGRectMake(20*SCALE, 110, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"身份证号" keyboardType:UIKeyboardTypeDefault tag:1003 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    [_scrollView addSubview:ufBankName];
    ufBankNumer = [QGTools creatTextField:CGRectMake(20*SCALE, 160, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"卡片号码" keyboardType:UIKeyboardTypeDefault tag:1003 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    [_scrollView addSubview:ufBankNumer];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10*SCALE, 210, MainScreenWidth, 80)];
    //view.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:view];

    bbtn1 = [QGTools createButton:CGRectMake(30, 205, (MainScreenWidth-30-60)/4, 60) bgColor:[UIColor clearColor] title:nil titleColor:nil tag:120 action:@selector(bbtn1Clicked:) vc:self];
    [bbtn1 setBackgroundImage:[UIImage imageNamed:@"矢量智能对象 拷贝 4.png"] forState:UIControlStateNormal];
    bbtn2 = [QGTools createButton:CGRectMake((30 +(MainScreenWidth-30-60)/4 +10), 205, (MainScreenWidth-30-60)/4, 60) bgColor:[UIColor clearColor] title:nil titleColor:nil tag:125 action:@selector(bbtn2Clicked:) vc:self];
    [bbtn2 setBackgroundImage:[UIImage imageNamed:@"矢量智能对象 拷贝 4.png"] forState:UIControlStateNormal];
    bbtn3 = [QGTools createButton:CGRectMake((30 +(MainScreenWidth-30-60)/4*2 +20), 205, (MainScreenWidth-30-60)/4, 60) bgColor:[UIColor clearColor] title:nil titleColor:nil tag:130 action:@selector(bbtn3Clicked:) vc:self];
    [bbtn3 setBackgroundImage:[UIImage imageNamed:@"矢量智能对象 拷贝 4.png"] forState:UIControlStateNormal];
    bbtn4 = [QGTools createButton:CGRectMake((30 +(MainScreenWidth-30-60)/4*3 +30), 205, (MainScreenWidth-30-60)/4, 60) bgColor:[UIColor clearColor] title:nil titleColor:nil tag:135 action:@selector(bbtn4Clicked:) vc:self];
    [bbtn4 setBackgroundImage:[UIImage imageNamed:@"矢量智能对象 拷贝 4.png"] forState:UIControlStateNormal];
    [_scrollView addSubview:bbtn1];
    [_scrollView addSubview:bbtn2];
    [_scrollView addSubview:bbtn3];
    [_scrollView addSubview:bbtn4];
    UILabel * labelNN = [[UILabel alloc] initWithFrame:CGRectMake(40*SCALE, 270, (MainScreenWidth-80), 30)];
    labelNN.text = @"请您上传证件的照片(支持jpg、png,每张照片不超过3M,最多上传4张)";
    labelNN.font = [UIFont systemFontOfSize:11];
    labelNN.numberOfLines = 2;
    labelNN.textColor = [UIColor grayColor];
    [_scrollView addSubview:labelNN];
    ufCost = [QGTools creatTextField:CGRectMake(20*SCALE, 305, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"赔付金额:" keyboardType:UIKeyboardTypeDefault tag:1003 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    [_scrollView addSubview:ufCost];
    //创建同意协议勾选 imageview
    UIButton * buttonAgreen = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonAgreen.frame = CGRectMake(32*SCALE, 363, 15*SCALE, 15);
    //buttonAgreen.frame = CGRectMake(35*SCALE, 350, 10*SCALE, 20);
    [buttonAgreen setImage:[UIImage imageNamed:@"unselect@2x.png"] forState:UIControlStateNormal];
    [buttonAgreen setImage:[UIImage imageNamed:@"fuwutiaokuan-tongyi@2x.png"] forState:UIControlStateSelected];
    [buttonAgreen addTarget:self action:@selector(btnTapClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonAgreen.tag = 1990;
    [buttonAgreen setSelected:NO];
    [_scrollView addSubview:buttonAgreen];
    UILabel * labelAgreen = [[UILabel alloc]initWithFrame:CGRectMake(50*SCALE, 360, 80*SCALE, 20)];
    labelAgreen.text = @"同意服务条款";
    labelAgreen.font = [UIFont systemFontOfSize:13];
    labelAgreen.textColor = [UIColor colorWithRed:0.63f green:0.64f blue:0.64f alpha:1.00f];
    [_scrollView addSubview:labelAgreen];
    //创建提交 按钮btnCommit
    UIButton * btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCommit.frame = CGRectMake(30*SCALE, 380, 260*SCALE, 60);
    [btnCommit setImage:[UIImage imageNamed:@"buyBg@2x.png"] forState:UIControlStateNormal];
    btnCommit.tag = 1201;
    [btnCommit addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btnCommit];
    //创建注 textView
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(10*SCALE, 450, 300*SCALE, 100)];
    textView.delegate = self;
    //添加滚动区域
    //textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.font = [UIFont systemFontOfSize:13];
    textView.text = @"呵呵，我会让你明白，良辰从不说空话。别让我碰到你，如果在我的地盘，我有一百种方法让你们待不下去，可你，却无可奈何。呵呵，良辰最喜欢对那些自认为能力出众的人出手，你只需要记住，我叫叶良辰。";
    textView.layer.cornerRadius = 5.0f;
    textView.layer.masksToBounds = YES;
    textView.textColor = [UIColor grayColor];
    textView.userInteractionEnabled = NO;
    textView.backgroundColor = [UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:1.0f];
     
    [_scrollView addSubview:textView];

}
- (void)btnTapClicked:(UIButton *)btn
{
    btn.selected =! btn.selected;
    if (btn.selected) {
        
    }else{
        
    }
    
}
- (void)bbtn1Clicked:(UIButton *)sender
{
    k=1;
    [self setImagePhoto];
    
}
- (void)bbtn2Clicked:(UIButton *)sender
{
    k=2;
    [self setImagePhoto];
    
}
- (void)bbtn3Clicked:(UIButton *)sender
{
    k= 3;
    [self setImagePhoto];
}
- (void)bbtn4Clicked:(UIButton *)sender
{
    k= 4;
    [self setImagePhoto];
}
- (void)setImagePhoto
{

        //一个菜单列表 选择照相机还是 相册
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择照片方式"
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *alertActionOne = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self openXiangCe];
                
            }];
            [alertController addAction:alertActionOne];
            
            UIAlertAction *alertActionTwo = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self openCamera];
                
            }];
            [alertController addAction:alertActionTwo];
            
            UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAlertAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else {
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
            sheet.delegate = self;
            [sheet showInView:self.view];
        }
    
}
#pragma mark -- UIActionSheet代理方法实现
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // 打开相册
        [self openXiangCe];
    } else if (buttonIndex == 1) {
        // 打开拍照
        [self openCamera];
    }
    
}

//打开相册
-(void)openXiangCe {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
     DLog(@"打开相册");
}

//打开相机
-(void)openCamera {
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

// 相册相关的代理方法的实现 取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 选中某个相片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) { //如果打开相册
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //压缩图片
        image = [image imageByScalingAndCroppingForSize:CGSizeMake(320, 320)];
        
        DLog(@"选中相册");
    }
    else {//如果打开的是照相机
        [picker dismissViewControllerAnimated:YES completion:nil];
        //image = [info objectForKey:UIImagePickerControllerEditedImage]; //得到编辑后的照片
        image = [info objectForKey:UIImagePickerControllerOriginalImage]; //获取原始的照片
        //压缩图片
        image = [image imageByScalingAndCroppingForSize:CGSizeMake(320, 320)];
        DLog(@"打开相机");
        
        

        if (k==1) {
            [bbtn1 setImage:image forState:UIControlStateNormal];
        }else if (k==2){
            [bbtn2 setImage:image forState:UIControlStateNormal];
        }else if (k==3){
            [bbtn3 setImage:image forState:UIControlStateNormal];
        }else if(k==4){
            [bbtn4 setImage:image forState:UIControlStateNormal];
        }
        
    }
    // 将图片名字命名为当前时间保存至沙盒目录
    NSString *imagePath = [NSString stringWithFormat:@"%ld.png", (long)[[NSDate date] timeIntervalSince1970]];
    // 将图片保存至沙盒目录
    _imageFullPath= [self saveImages:image WithName:imagePath];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:_imageFullPath];
        NSData *mydata=UIImageJPEGRepresentation(savedImage , 0.5);
        NSString * loadURL = [HostUrl stringByAppendingString:uploadFile];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:loadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             DLog(@"formData==%@",formData);
             //name 为服务器规定的图片字段 mimeType 为图片类型
             [formData appendPartWithFileData:mydata name:@"fileImg" fileName:@"imghea.jpg" mimeType:@"image/jpeg"];
             
         } success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             DLog(@"responseObject == %@",responseObject);
             //DLog(@"success == %@",responseObject[@"success"]);
             strImageId = responseObject[@"id"];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             DLog(@"－－－－－－－－  error==%@",error);
         }];
      }

- (void)uploadImageNotification:(NSNotification *) notification{
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UpLoadImage object:nil];
    DLog(@"resultDic = %@", resultDic);
   
    
}
- ( NSString *) saveImages:(UIImage*)image WithName:(NSString*)imageName {
    
    //将图片保存到沙盒
    //保存文件到沙盒
    //获取沙盒中Documents目录路径
    //        DLog(@"%@",documents);
    
    //拼接文件绝对路径
    DLog(@"str imageName = %@", imageName);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // 获得图片的全路径
    NSString *fullpath = [documentsDirectory stringByAppendingPathComponent: imageName];
    NSData* imageData = UIImagePNGRepresentation(image);
    
    //保存
    [imageData writeToFile:fullpath atomically:NO];
    
    return fullpath;
}
- (void)btnClicked:(UIButton *)btn
{
    
    if (ufName.text == nil || [ufName.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"姓名不能为空"];
        return;
    }
    if (ufPhone.text == nil || [ufPhone.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"手机号码不能为空"];
        return;
    }
    if (ufBankName.text == nil || [ufBankName.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"身份证号不能为空"];
        return;
    }
    if (ufBankNumer.text == nil || [ufBankNumer.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"信用卡号码不能为空"];
        return;
    }
    if (ufCost.text == nil || [ufCost.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"请填写赔付金额"];
        return;
    }
   UIButton * btnARE = (UIButton *)[self.view viewWithTag:1990];
    if (btnARE.selected == YES) {
        NSDictionary * parameters = @{@"cost":ufCost.text,@"name":ufName.text,@"phone":ufPhone.text,@"idcard":ufBankName.text,@"credit":ufBankNumer.text,@"type":@2,@"fileImg":strImageId};
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddPaymentNotifications:) name:AddPayment object:nil];
        [[AFNetManager sharedManager] postDataToServerWithHostUrl:[NSString stringWithFormat:@"%@%@",HostUrl,AddPayment] andParameters:parameters andNotificationName:AddPayment];
    }else{
        alert.title = @"是否同意授权?";
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(disappear:) userInfo:nil repeats:YES];
    }
}
- (void)AddPaymentNotifications:(NSNotification *) notification{
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddPayment object:nil];
    DLog(@"resultDic = %@", resultDic);
    if ([resultDic objectForKey:@"responseObject"]) {
        NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
        NSString *msg = [responseObject objectForKey:@"MSG"];
        [ToolBox showAlertInfo:msg];
        DLog(@"sssssssssssssssssssss");
    }
}
- (void)disappear:(NSTimer *)timer
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
@end
