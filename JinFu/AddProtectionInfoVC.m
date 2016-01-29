//
//  AddProtectionInfoVC2.m
//  JinFu
//
//  Created by 郑光龙 on 15/12/19.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "AddProtectionInfoVC.h"
#import "UserInfoInputCell.h"
#import "AddCardNumberCell.h"
#import "UploadImageCell.h"
#import "TotalPaymentCell.h"
#import "CommitCell.h"
#import "UnauthoPayServiceVC.h"
#import "ServicePeriodCell.h"
#import "UIImageExt.h"
#import "AFNetManager.h"

@interface AddProtectionInfoVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
{
//    int addedCardNumberCnt;
    NSMutableArray *_inputPlaceHoldersArr;
//    ServiceInfoModel *_unauthorizedInfo;
    __block BOOL bShowPullDownList;
    
    NSMutableArray *_servicePeriodArr;
    NSMutableArray *_servicePriceArr;
    NSMutableDictionary *_periodInfoDict;
    NSMutableArray *_shownServiceTimeArr;
    
    
    UIImagePickerController *imagePicker;
    NSString *_imageFullPath;
    
    NSInteger _uploadImageViewtag;
    
    NSString *requstUrlString;
}
@end

@implementation AddProtectionInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    addedCardNumberCnt = 0;
    _inputPlaceHoldersArr = [NSMutableArray arrayWithObjects:@"姓名",@"身份证号",@"手机号",@"填写卡号(最多3个)", nil];
    self.addProtectionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    bShowPullDownList = false;
    if (!self.unauthorizedInfo) {
        self.unauthorizedInfo = [[ServiceInfoModel alloc] init];
    }
    _servicePeriodArr = [[NSMutableArray alloc] init];
    _servicePriceArr = [[NSMutableArray alloc] init];
    _shownServiceTimeArr = [[NSMutableArray alloc] init];
    [self getServicePeriodAndPrice];
    
    self.navigationItem.title = @"盗刷保障";
    [self configNavigationLeftButton];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)getServicePeriodAndPrice {
  NSString *serviceTime1 = self.serviceInfo.serviceCycle;
  NSString *serviceTime1Money =  self.serviceInfo.servicePrice;
    [ToolBox  splitString:serviceTime1 withCharacter:@"," andSubstrArr:_servicePeriodArr];
    [ToolBox  splitString:serviceTime1Money withCharacter:@"," andSubstrArr:_servicePriceArr];
    
    _periodInfoDict = [[NSMutableDictionary alloc] initWithObjects:_servicePriceArr forKeys:_servicePeriodArr];
//    DLog(@"_servicePeriodArr  =%@", _servicePeriodArr);
    if ([_servicePeriodArr count] > 0){
        self.unauthorizedInfo.servicePeriod = [_servicePeriodArr objectAtIndex:0];
    }
    
    for (NSString *str in _servicePeriodArr) {
        [_shownServiceTimeArr addObject:[NSString stringWithFormat:@"%@月", str]];
//        NSInteger period = [str integerValue];
//        CGFloat showPeriod = (CGFloat)period/12.0;
//        if (showPeriod > 0.2 && showPeriod < 1) {
//            [_shownServiceTimeArr addObject:@"半年"];
//        }else{
//            [_shownServiceTimeArr addObject:[NSString stringWithFormat:@"%.0f年", showPeriod]];
//        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3) {
        return 44;
    }else if(indexPath.row <= 3+self.addedCardNumberCnt) {
        return 88;
    }else if (indexPath.row == 4+self.addedCardNumberCnt) {
        return (bShowPullDownList ? 85: 44);
    }else if (indexPath.row == 5+self.addedCardNumberCnt) {
        return 120;
    }else if (indexPath.row == 6+self.addedCardNumberCnt) {
        return 44;
    }else if (indexPath.row == 7+self.addedCardNumberCnt) {
        return 120;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8+self.addedCardNumberCnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 3) {
        return [self getInputCellOfTableview:tableView andIndexPath:indexPath];
        
    }else if(indexPath.row <= 3+self.addedCardNumberCnt) {
        return [self getAddCardCellOfTableview:tableView andIndexPath:indexPath];
    
    }else if (indexPath.row == 4+self.addedCardNumberCnt) {
        return [self getServicePeriodCellOfTableview:tableView andIndexPath:indexPath];
    }else if (indexPath.row == 5+self.addedCardNumberCnt) {
        return [self getUploadImageCellOfTableview:tableView andIndexPath:indexPath];
    }else if (indexPath.row == 6+self.addedCardNumberCnt) {
        return [self getTotalPaymentCellOfTableview:tableView andIndexPath:indexPath];
    }else if (indexPath.row == 7+self.addedCardNumberCnt) {
        return [self getCommitCellOfTableview:tableView andIndexPath:indexPath];
    }
    return [[UITableViewCell alloc] init];
}

- (UserInfoInputCell *)getInputCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"UserInfoInputCell";
    UserInfoInputCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoInputCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        if ( self.unauthorizedInfo.name != nil ) {
            cell.inputTF.text = self.unauthorizedInfo.name;
        }else
        {
            cell.inputTF.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
        }
        
        ( self.operationType != 0 ) ? (cell.inputTF.enabled = NO ):(cell.inputTF.enabled = YES);
        
    }else if (indexPath.row == 1){
            if ( self.unauthorizedInfo.identityCard != nil ) {
                cell.inputTF.text = self.unauthorizedInfo.identityCard;
            }else
            {
                cell.inputTF.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
            }
        ( self.operationType != 0 ) ? (cell.inputTF.enabled = NO ):(cell.inputTF.enabled = YES);
        
    }else if (indexPath.row ==2){
            if ( self.unauthorizedInfo.phoneNumber != nil ) {
                cell.inputTF.text = self.unauthorizedInfo.phoneNumber;
            }else
            {
                cell.inputTF.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
            }
    }
    
    cell.getInputText = ^(NSString *text){
        NSString *inputStr = [NSString stringWithString:text];
        if (indexPath.row == 0) {
            self.unauthorizedInfo.name = inputStr;
        }else if (indexPath.row == 1){
            self.unauthorizedInfo.identityCard = inputStr;
        }else if (indexPath.row == 2 )
        {
            self.unauthorizedInfo.phoneNumber = inputStr;
        }
    };
    return cell;
}

- (AddCardNumberCell *)getAddCardCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"AddCardNumberCell";
    AddCardNumberCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddCardNumberCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([self.unauthorizedInfo.cardNumberArr count] > indexPath.row - 3 && ![[self.unauthorizedInfo.cardNumberArr objectAtIndex:indexPath.row-3] isEqualToString:@""]) {
         cell.cardNumberTf.text = [NSString stringWithFormat:@"%@", self.unauthorizedInfo.cardNumberArr[indexPath.row-3]];
        DLog(@"cell.cardNumberTf.text = %@", cell.cardNumberTf.text);
    }else
    {
        DLog(@"%@", _inputPlaceHoldersArr[indexPath.row]);
        cell.cardNumberTf.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
    }
    ( self.operationType != 0 ) ? (cell.cardNumberTf.enabled = NO ):(cell.cardNumberTf.enabled = YES);
    
    if ([self.unauthorizedInfo.bankNameArr count] > indexPath.row - 3 && ![[self.unauthorizedInfo.bankNameArr objectAtIndex:indexPath.row-3] isEqualToString:@""]) {
        cell.bankNameTF.text = [NSString stringWithFormat:@"%@", self.unauthorizedInfo.bankNameArr[indexPath.row-3]];
    }else
    {
        cell.bankNameTF.placeholder =  @"银行名称";
    }
    ( self.operationType != 0 ) ? (cell.bankNameTF.enabled = NO ):(cell.bankNameTF.enabled = YES);
    
    if (indexPath.row < 3+self.addedCardNumberCnt) {
        cell.buttonView.hidden = YES;
    }
    cell.buttonViewAction = ^{
        if (self.operationType != 0) {
            return;
        }
        
        self.addedCardNumberCnt++;
        if (self.addedCardNumberCnt >2){
            self.addedCardNumberCnt = 2;
            [ToolBox showAlertInfo:@"最多添加3个信用卡"];
            return ;
        }
        [_inputPlaceHoldersArr addObject:@"填写卡号(最多3个)"];
        [self.addProtectionTable reloadData];
        DLog(@"buttonViewAction");
    };
    
    cell.getCardNumber = ^(NSString *cardNumber) {
        if (cardNumber.length == 0) {//信用卡号长度
            [ToolBox showAlertInfo:@"请填入正确的信用卡号"];
            return;
        }
        NSString *inputStr = [NSString stringWithString:cardNumber];
        [self.unauthorizedInfo.cardNumberArr replaceObjectAtIndex:indexPath.row-3 withObject:inputStr];
    };
    
    cell.getBankName = ^(NSString *bankName){
        if (bankName.length == 0) {//信用卡号长度
            [ToolBox showAlertInfo:@"请填入银行名称"];
            return;
        }
        NSString *inputStr = [NSString stringWithString:bankName];
        [self.unauthorizedInfo.bankNameArr replaceObjectAtIndex:indexPath.row-3 withObject:inputStr];
    };
    return cell;
}

- (ServicePeriodCell *)getServicePeriodCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"ServicePeriodCell";
    ServicePeriodCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServicePeriodCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setpullMenuDataSoure:_shownServiceTimeArr];
    if ( self.unauthorizedInfo.servicePeriod != nil) {
        NSInteger idx = [_servicePeriodArr indexOfObject:self.unauthorizedInfo.servicePeriod];
        NSString *inputStr = [NSString stringWithString:_shownServiceTimeArr[idx]];
        [cell setSelectDataIdx:idx];
    }else {
        [cell setSelectDataIdx:0];;
    }
    
    DLog(@"getServicePeriodCellOfTableview");
    cell.showListViewEvent=^{
        DLog(@"cell.showListViewEvent");
        bShowPullDownList = YES;
        [tableview reloadData];
    };
    
    cell.hideListViewEvent = ^{
        DLog(@"cell.hideListViewEvent");
        bShowPullDownList = NO;
        [tableview reloadData];
    };
    cell.getSelectedText = ^(NSInteger idx, NSString *text){
//        NSInteger idx = [_shownServiceTimeArr indexOfObject:text];
        NSString *inputStr = [NSString stringWithString:_servicePeriodArr[idx]];
        self.unauthorizedInfo.servicePeriod = inputStr;
    };
    
    [cell setBlock];
    [cell setPullMenuState:bShowPullDownList];
    return cell;
}

- (UploadImageCell *)getUploadImageCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"UploadImageCell";
    UploadImageCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UploadImageCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.tappedImageAction = ^(NSInteger imageViewTag){
        DLog(@"imageViewTag = %ld", imageViewTag);
        _uploadImageViewtag = imageViewTag;
        [self tackPhotoBtnClick];
    };
    
    [cell setUploadedImage:self.unauthorizedInfo.uploadedImagePathsArr];
    
    
    return cell;
}

- (TotalPaymentCell *)getTotalPaymentCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"TotalPaymentCell";
    TotalPaymentCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TotalPaymentCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *price =  [_periodInfoDict objectForKey:self.unauthorizedInfo.servicePeriod];
//    [_unauthorizedInfo.cardNumberArr ];
    int i = 0;
    for (NSString *cardNumber in self.unauthorizedInfo.cardNumberArr) {
        if (![cardNumber isEqualToString:@""]) {
            i ++;
        }
    }
    
    cell.totalCount.text = [NSString stringWithFormat:@"￥%ld", [price integerValue] * i] ;
    self.unauthorizedInfo.totalCost = [NSString stringWithFormat:@"%ld", [price integerValue] * i];
    return cell;
}

- (CommitCell *)getCommitCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"CommitCell";
    CommitCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommitCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.agreeProtocolAction = ^(BOOL bAgree){
        self.unauthorizedInfo.agreeProtol = bAgree;
    };
    
    cell.bAgreeProtocol = self.unauthorizedInfo.agreeProtol;
    cell.commitButtonAction = ^(){
        [self commitProtectionInfo];
    };
    
    return cell;
}


- (void)commitProtectionInfo{
    NSMutableString *idcardImgs = [[NSMutableString alloc] init];
    for (NSString *str in self.unauthorizedInfo.uploadImageIdsArr) {
        if (![str isEqualToString:@""]) {
            [idcardImgs appendFormat:@"%@,",str];
        }
    }
    
    NSMutableString *cards = [[NSMutableString alloc] init];
    //检测卡号是否为空
    BOOL bBreak = false;
    for (int i = 0; i <= self.addedCardNumberCnt; i++) {
        NSString *cardStr = self.unauthorizedInfo.cardNumberArr[i];
        if ([cardStr isEqualToString:@""]) {
            [ToolBox showAlertInfo:@"银行卡号不能为空"];
            bBreak = true;
            break;
        }
    }
    
    if (bBreak) {
        return;
    }
    
    bBreak = false;
    for (int i = 0; i <= self.addedCardNumberCnt; i++) {
        NSString *cardStr = self.unauthorizedInfo.bankNameArr[i];
        if ([cardStr isEqualToString:@""]) {
            [ToolBox showAlertInfo:@"银行名称不能为空"];
            bBreak = true;
            break;
        }
    }
    if (bBreak) {
        return;
    }
    
    //拼接卡号参数
    for (NSString *str in self.unauthorizedInfo.cardNumberArr ) {
        if (![str isEqualToString:@""]) {
            [cards appendFormat:@"%@,",str];
        }
    }
    //拼接银行名称参数
    NSMutableString *bankName = [[NSMutableString alloc] init];
    for (NSString *str in self.unauthorizedInfo.bankNameArr ) {
        if (![str isEqualToString:@""]) {
            [bankName appendFormat:@"%@,",str];
        }
    }

    if (self.unauthorizedInfo.name == nil || [self.unauthorizedInfo.name isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"姓名不能为空"];
        return;
    }else if(self.unauthorizedInfo.phoneNumber == nil || [self.unauthorizedInfo.phoneNumber isEqualToString:@""]){
        [ToolBox showAlertInfo:@"手机号不能为空"];
        return;
    }else if (self.unauthorizedInfo.identityCard == nil || [self.unauthorizedInfo.identityCard isEqualToString:@""]){
        [ToolBox showAlertInfo:@"身份证号不能为空"];
        return;
    }else if([idcardImgs isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"请上传证件图片"];
        return;
    }else if(!self.unauthorizedInfo.agreeProtol) {
        [ToolBox showAlertInfo:@"是否同意服务条款"];
        return;
    }else{
        NSDictionary *parasDct;
        if (self.operationType == 0) {
            requstUrlString = AddSwingCardService;
            parasDct = [self getAddSwingCardServiceParameters:cards andIDImages:idcardImgs andBankName:bankName];
        }else if (self.operationType == 1){
            requstUrlString = ContSwingCardService;
            parasDct = [self getContSwingCardServiceParameters:cards andIDImages:idcardImgs andBankName:bankName];
        }else if (self.operationType == 2){
            requstUrlString = EditSwingCardService;
            parasDct = [self getContSwingCardServiceParameters:cards andIDImages:idcardImgs andBankName:bankName];
        }else if (self.operationType == 3){
            requstUrlString = CEditSwingCardService;
            parasDct = [self getContSwingCardServiceParameters:cards andIDImages:idcardImgs andBankName:bankName];
        }
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSwingCardServiceNotification:) name:requstUrlString object:nil];
    [[AFNetManager sharedManager] postDataToServerWithHostUrl:[NSString stringWithFormat:@"%@%@",HostUrl, requstUrlString] andParameters:parasDct andNotificationName:requstUrlString];
    }
}

//添加未通过重新编辑和续保编辑以及续保未通过重新编辑的参数一样
- (NSDictionary *)getContSwingCardServiceParameters:(NSString *)cards andIDImages:(NSString *)idcardImgs andBankName:(NSString *)bankName{
    NSDictionary *parasDct = @{
                               @"serviceId":self.serviceInfo.serviceId,
                               @"memberId":@"",
                               @"memberName":self.unauthorizedInfo.name,
                               @"contact":self.unauthorizedInfo.phoneNumber,
                               @"serviceCycle":self.unauthorizedInfo.servicePeriod,
                               @"cost":self.unauthorizedInfo.totalCost,
                               @"identityCard":self.unauthorizedInfo.identityCard,
                               @"idcardImg":idcardImgs,
                               @"cards":cards,
                               @"cardName":bankName,
                               @"id":self.unauthorizedInfo.productId
                               };
    return parasDct;
}

- (NSDictionary *)getAddSwingCardServiceParameters:(NSString *)cards andIDImages:(NSString *)idcardImgs andBankName:(NSString *)bankName{
    NSDictionary *parasDct = @{
                               @"serviceId":self.serviceInfo.serviceId,
                               @"memberId":@"",
                               @"memberName":self.unauthorizedInfo.name,
                               @"contact":self.unauthorizedInfo.phoneNumber,
                               @"serviceCycle":self.unauthorizedInfo.servicePeriod,
                               @"cost":self.unauthorizedInfo.totalCost,
                               @"identityCard":self.unauthorizedInfo.identityCard,
                               @"idcardImg":idcardImgs,
                               @"cards":cards,
                               @"cardName":bankName
                               };
    return parasDct;
}

- (void)addSwingCardServiceNotification:(NSNotification *) notification{
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:requstUrlString object:nil];
    DLog(@"resultDic = %@", resultDic);
    if ([resultDic objectForKey:@"responseObject"]) {
        NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
        NSString *msg = [responseObject objectForKey:@"MSG"];
        [ToolBox showAlertInfo:msg];
        if (self.operationType == 0 || self.operationType == 1) {//到付款页面
            UnauthoPayServiceVC *payserviceVc = [[UnauthoPayServiceVC alloc] init];
            payserviceVc.unautoProtectionInfo = self.unauthorizedInfo;
            [self.navigationController pushViewController:payserviceVc animated:YES];
        }
        
    }else{
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"tableView");
    if (indexPath.row == 4+self.addedCardNumberCnt) {
        bShowPullDownList = !bShowPullDownList;
        [tableView reloadData];
    }
}


//上传图片
- (void)tackPhotoBtnClick{
    DLog(@"点击拍照");
    
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
    }
    else {//如果打开的是照相机
        [picker dismissViewControllerAnimated:YES completion:nil];
        //image = [info objectForKey:UIImagePickerControllerEditedImage]; //得到编辑后的照片
        image = [info objectForKey:UIImagePickerControllerOriginalImage]; //获取原始的照片
        //压缩图片
        image = [image imageByScalingAndCroppingForSize:CGSizeMake(320, 320)];
    }
    
    
//    [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    // 获取当前时间
    //    NSDate *datenow = [NSDate date];
    // 将图片名字命名为当前时间保存至沙盒目录
    NSString *imagePath = [NSString stringWithFormat:@"%ld.png", (long)[[NSDate date] timeIntervalSince1970]];
    
    // 将图片保存至沙盒目录
     _imageFullPath= [self saveImage:image WithName:imagePath];
    //    creditCardInfo.cardImagePath = _imageFullPath;
    //    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //    NSString * str_Base64 = [[NSString alloc] init];
    //    str_Base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //    // 上传图片文件
    //[self uploadTheApplicationForAsid:[newCreateDictionary objectForKey:@"asid"] imageDataString:str_Base64 imageNameString:str];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImageNotification:) name:UpLoadImage object:nil];

    [[AFNetManager sharedManager] uploadImageWithURLString:[NSString stringWithFormat:@"%@%@",HostUrl, UpLoadImage] andParameters:nil andImagePath:_imageFullPath andNotificationName:UpLoadImage];
}

- (void)uploadImageNotification:(NSNotification *) notification{
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UpLoadImage object:nil];
    DLog(@"resultDic = %@", resultDic);
    if (resultDic) {
        NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
        [self.unauthorizedInfo.uploadImageIdsArr replaceObjectAtIndex:_uploadImageViewtag withObject:[responseObject objectForKey:@"id"]];
        
        [self.unauthorizedInfo.uploadedImagePathsArr replaceObjectAtIndex:_uploadImageViewtag withObject:_imageFullPath];
        [self.addProtectionTable reloadData];
    }else{
    
    }
    
}

- ( NSString *) saveImage:(UIImage*)image WithName:(NSString*)imageName {
    
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
@end
