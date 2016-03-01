//
//  MyCardTableViewCell.m
//  JinFu
//
//  Created by ybon on 16/2/23.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "MyCardTableViewCell.h"
#import "Masonry.h"

#define TipTextColor ColorWithRGB(100, 100, 100)
#define TipTextFontSize 12.0
@interface MyCardTableViewCell ()<UITextFieldDelegate>
{
    float _scale;
    BOOL bShowListView;
    UITapGestureRecognizer *hideGesture;
}

@property (strong, nonatomic) UILabel *cdTimeTip;
@property (strong, nonatomic) UILabel *debtTip;
@property (strong, nonatomic) UILabel *minPayTip;
@property (strong, nonatomic) UILabel *creditLineTip;
@property (strong, nonatomic) UILabel *integeralTip;
@property (strong, nonatomic) UILabel *periodTip;
@property (strong, nonatomic) UIImageView *indicator;
@property (strong, nonatomic) UIImageView *redDotImage;
@property (strong, nonatomic) UIImageView *greenDotImage;
@property (strong, nonatomic) UIImageView *orangeDotImage;
@property (strong, nonatomic) UIImageView *moneyFlagImage;

@property (strong, nonatomic) UIImageView *lineImage1;
@property (strong, nonatomic) UIImageView *lineImage2;

@property (strong, nonatomic) UIButton *upaidButton;
@property (strong, nonatomic) UIButton *paidButton;
@property (strong, nonatomic) UIButton *payPartButton;
@property (strong, nonatomic) UITextField *payPartTF;

@end

@implementation MyCardTableViewCell
/*
 @property (strong, nonatomic) UIImageView *bankCardBg;
 @property (strong, nonatomic) UILabel *deadDate;
 @property (strong, nonatomic) UIImageView *cardIcon;
 @property (strong, nonatomic) UILabel *cardNameAndNumber;
 @property (strong, nonatomic) UILabel *cdTime;
 @property (strong, nonatomic) UILabel *debt;
 @property (strong, nonatomic) UILabel *minPay;
 @property (strong, nonatomic) UILabel *creditLine;
 @property (strong, nonatomic) UILabel *integeral;
 @property (strong, nonatomic) UILabel *period;
 @property (strong, nonatomic) UILabel *leftDaysToNextBillDay;
 //付款状态相关
 @property (strong, nonatomic) UIView *payButtonView;
 @property (strong, nonatomic) UIImageView *payStateBgImageView;
 @property (strong, nonatomic) UILabel *payStateLabel;
 @property (strong, nonatomic) UIView *pullView;
 @property (strong, nonatomic) UITextField *payPartTF;
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.bankCardBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bankCardBg1"]];
        [self.contentView addSubview:self.bankCardBg];
        
        self.cardIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bank3"]];
        [self.contentView addSubview:self.cardIcon];
        
        self.cardNameAndNumber = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:14] text:@""];
        [self.contentView addSubview:self.cardNameAndNumber];
        
        self.cnyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CNY"]];
        [self.contentView addSubview:self.cnyImage];
        
        self.deadDate = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@""];
        self.deadDate.textColor = TipTextColor;
        [self.contentView addSubview:self.deadDate];
    
        self.lineImage = [[UIImageView alloc] init];
        self.lineImage.backgroundColor = ColorWithRGB(220, 220, 220);
        [self.contentView addSubview:self.lineImage];
        
        self.cdTime = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial Rounded MT Bold" size:25] text:@"55"];
        self.cdTime.textColor = [UIColor redColor];
        self.cdTime.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.cdTime];
        
        self.cdTimeTip = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@"天后"];
        self.cdTimeTip.textColor = TipTextColor;
        self.cdTimeTip.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.cdTimeTip];
		
        self.debt = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@""];
        self.debt.textColor = [UIColor redColor];
        self.debt.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.debt];
        self.debtTip = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@"应还"];
        self.debtTip.textColor = TipTextColor;
        self.debtTip.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.debtTip];
		
        self.minPay = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@""];
        self.minPay.textColor = TipTextColor;
        self.minPay.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.minPay];
        self.minPayTip = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@"最低"];
        self.minPayTip.textColor = TipTextColor;
        self.minPayTip.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.minPayTip];
		
        self.creditLine = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@"50000"];
        self.creditLine.textAlignment = NSTextAlignmentRight;
        self.creditLine.textColor = TipTextColor;
        [self.contentView addSubview:self.creditLine];
        self.creditLineTip = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@"额度"];
        self.creditLineTip.textColor = TipTextColor;
        self.creditLineTip.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.creditLineTip];
		
        self.integeral = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@""];
        self.integeral.textColor = TipTextColor;
        self.integeral.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.integeral];
        self.integeralTip = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@"积分"];
        self.integeralTip.textColor = TipTextColor;
        self.integeralTip.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.integeralTip];
		
        self.period = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@""];
        self.period.textColor = TipTextColor;
        [self.contentView addSubview:self.period];
        self.periodTip = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@"账单期："];
        self.periodTip.textColor = TipTextColor;
        self.periodTip.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.periodTip];
		
        self.leftDaysToNextBillDay = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:TipTextFontSize] text:@"15"];
        self.leftDaysToNextBillDay.textAlignment = NSTextAlignmentCenter;
        self.leftDaysToNextBillDay.textColor = [UIColor orangeColor];
        self.leftDaysToNextBillDay.backgroundColor = ColorWithRGB(230, 230, 230);
        [self.contentView addSubview:self.leftDaysToNextBillDay];
        
        self.rightOperation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowWithCircle"]];
        [self.contentView addSubview:self.rightOperation];
        
        
        self.payStateBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payStateBg0"]];
        [self.contentView addSubview:self.payStateBgImageView];
        self.payStateLabel = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:14] text:@"未还款"];
        self.payStateLabel.textColor = [UIColor whiteColor];
        self.payStateLabel.textAlignment = NSTextAlignmentCenter;
        [self.payStateBgImageView addSubview:self.payStateLabel];
        
        self.indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-bai"]];
        [self.payStateBgImageView addSubview:self.indicator];
        
        _scale = [UIScreen mainScreen].bounds.size.width/320;
        [self layoutSubviews];
        
        
        //下拉菜单
        self.pullView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullviewBg"]];
        self.pullView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.pullView];
        
        self.redDotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payState0"]];
        [self.pullView addSubview:self.redDotImage];
        
        self.greenDotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payState1"]];
        [self.pullView addSubview:self.greenDotImage];
        
        self.orangeDotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payState2"]];
        [self.pullView addSubview:self.orangeDotImage];
    
        self.moneyFlagImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"￥"]];
        [self.pullView addSubview:self.moneyFlagImage];
        
        self.upaidButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.upaidButton setTitle:@"未还款" forState:UIControlStateNormal];
        [self.upaidButton addTarget:self action:@selector(unpayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.upaidButton setTintColor:TipTextColor];
        self.upaidButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0];

        [self.pullView addSubview:self.upaidButton];
        
        self.lineImage1 = [[UIImageView alloc] init];
        self.lineImage1.backgroundColor = ColorWithRGB(240, 240, 240);
        [self.pullView addSubview:self.lineImage1];
        
        self.lineImage2 = [[UIImageView alloc] init];
        self.lineImage2.backgroundColor = ColorWithRGB(240, 240, 240);
        [self.pullView addSubview:self.lineImage2];
        
        self.paidButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.paidButton setTitle:@"已还款" forState:UIControlStateNormal];
        [self.paidButton addTarget:self action:@selector(paidButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.paidButton setTintColor:TipTextColor];
        self.paidButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        [self.pullView addSubview:self.paidButton];
        
        self.payPartButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.payPartButton setTitle:@"部分还款" forState:UIControlStateNormal];
        [self.payPartButton addTarget:self action:@selector(payPartButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.payPartButton setTintColor:TipTextColor];
        self.payPartButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        [self.pullView addSubview:self.payPartButton];
        
        self.payPartTF = [[UITextField alloc] init];
        self.payPartTF.delegate = self;
        self.payPartTF.borderStyle = UITextBorderStyleNone;
        self.payPartTF.font = [UIFont fontWithName:@"Arial" size:12.0];
        self.payPartTF.backgroundColor = ColorWithRGB(250, 250, 250);
        self.payPartTF.layer.cornerRadius = 4;
        self.payPartTF.layer.borderColor = ColorWithRGB(220, 220, 220).CGColor;
        self.payPartTF.layer.borderWidth = 1.0;
        [self.pullView addSubview:self.payPartTF];
        self.pullView.hidden = YES;
        
        //UITapGestureRecognizer
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent)];
        [self.payStateBgImageView  addGestureRecognizer:tapGesture];
        self.payStateBgImageView.userInteractionEnabled = YES;
        bShowListView = false;

    }
    return self;
}


- (void)hideGestureEvent {
    bShowListView = false;
    self.pullView.hidden = YES;
    if (hideGesture) {
        [self.contentView removeGestureRecognizer:hideGesture];
        hideGesture = nil;
    }
}

- (void)tapGestureEvent{
    bShowListView = !bShowListView;
    if (bShowListView) {
        self.pullView.hidden = NO;
        hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGestureEvent)];
        [self.contentView  addGestureRecognizer:hideGesture];
    }else{
        self.pullView.hidden = YES;
    }
}


- (void)unpayButtonClick:(UIButton *)sender {
    if (self.getPayState)
    {
        self.getPayState(0, 0.0);
    }
    
    self.payStateLabel.text = @"未还款";
    self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg0"];

}
- (void)paidButtonClick:(UIButton *)sender {
    if (self.getPayState) {
        self.getPayState(1, 0.0);
    }
    
    self.payStateLabel.text = @"已还款";
    self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg1"];
}
- (void)payPartButtonClick:(UIButton *)sender {
    if (self.getPayState) {
        if ([self.payPartTF.text isEqualToString:@""] ||  [self.payPartTF.text integerValue] == 0) {
            [ToolBox showAlertInfo:@"请输入付款金额"];
        }else{
            self.getPayState(3, [self.payPartTF.text floatValue]);
            self.payStateLabel.text = self.payPartTF.text;
            self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg2"];
        }
        
    }

}

- (void)setPayState:(NSString *)state andPaidNum:(NSString *)paid {
    bShowListView = false;
    self.pullView.hidden = YES;
    if ([state isEqualToString:@"0"]) {
        self.payStateLabel.text = @"未还款";
        self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg0"];
    }else if ([state isEqualToString:@"1"]) {
        self.payStateLabel.text = @"已还款";
        self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg1"];
    }else if ([state isEqualToString:@"3"]) {
        self.payStateLabel.text = [NSString stringWithFormat:@"%@", paid];
        self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg2"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bankCardBg.frame = self.contentView.bounds;
    [self.cardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*_scale, 30*_scale));
        make.left.mas_equalTo(20*_scale);
        make.top.mas_equalTo(15*_scale);
    }];
    
    [self.cardNameAndNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100*_scale, 30));
        make.left.mas_equalTo(self.cardIcon.mas_right).offset(10*_scale);
        make.top.mas_equalTo(10*_scale);
    }];
    
    [self.cnyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20*_scale, 10*_scale));
        make.left.mas_equalTo(self.cardIcon.mas_right).offset(10*_scale);
        make.top.mas_equalTo(self.cardNameAndNumber.mas_bottom).offset(-5);
    }];
    
    [self.deadDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75*_scale, 10*_scale));
        make.left.mas_equalTo(self.cnyImage.mas_right).offset(5*_scale);
        make.top.mas_equalTo(self.cardNameAndNumber.mas_bottom).offset(-5);
    }];
    
    [self.lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1.0, 25.0*_scale));
        make.left.mas_equalTo(self.cardNameAndNumber.mas_right).offset(30*_scale);
        make.top.mas_equalTo(20*_scale);
    }];
    
    [self.payStateBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineImage.mas_right).offset(25*_scale);
        make.height.mas_equalTo(25*_scale);
        make.right.mas_equalTo(-25*_scale);
        make.top.mas_equalTo(20*_scale);
    }];
    
    [self.payStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.indicator.mas_left).offset(-5*_scale);
        make.left.mas_equalTo(5.0*_scale);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6*_scale, 6*_scale));
        make.right.mas_equalTo(-8*_scale);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.cdTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*_scale, 25*_scale));
        make.top.mas_equalTo(self.cardIcon.mas_bottom).offset(18*_scale);
        make.centerX.mas_equalTo(self.cardIcon.mas_centerX);
    }];
    
    [self.cdTimeTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*_scale, 20*_scale));
        make.top.mas_equalTo(self.cdTime.mas_bottom);
        make.centerX.mas_equalTo(self.cardIcon.mas_centerX);
    }];
    
    [self.debtTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*_scale, 20*_scale));
        make.top.mas_equalTo(self.cdTime.mas_top);
        make.left.mas_equalTo(self.cardIcon.mas_right).offset(10*_scale);
    }];
    
    [self.debt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20*_scale);
        make.top.mas_equalTo(self.cdTime.mas_top);
        make.left.mas_equalTo(self.debtTip.mas_right);
        make.right.mas_equalTo(self.creditLineTip.mas_left).offset(-10*_scale);
    }];
    
    [self.minPayTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*_scale, 20*_scale));
        make.bottom.mas_equalTo(self.cdTimeTip.mas_bottom);
        make.left.mas_equalTo(self.cardIcon.mas_right).offset(10*_scale);
    }];
    
    [self.minPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20*_scale);
        make.bottom.mas_equalTo(self.cdTimeTip.mas_bottom);
        make.left.mas_equalTo(self.debtTip.mas_right);
        make.right.mas_equalTo(self.creditLineTip.mas_left).offset(-10*_scale);
    }];
    
    [self.creditLineTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*_scale, 20*_scale));
        make.top.mas_equalTo(self.cdTime.mas_top);
        make.centerX.mas_equalTo(self.lineImage.mas_centerX);
    }];
    
    [self.creditLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20*_scale);
        make.top.mas_equalTo(self.cdTime.mas_top);
        make.left.mas_equalTo(self.creditLineTip.mas_right);
        make.right.mas_equalTo(self.payStateBgImageView.mas_right);
    }];
    
    [self.integeralTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*_scale, 20*_scale));
        make.bottom.mas_equalTo(self.cdTimeTip.mas_bottom);
        make.centerX.mas_equalTo(self.lineImage.mas_centerX);
    }];
    
    [self.integeral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20*_scale);
        make.bottom.mas_equalTo(self.cdTimeTip.mas_bottom);
        make.left.mas_equalTo(self.creditLineTip.mas_right);
        make.right.mas_equalTo(self.payStateBgImageView.mas_right);
    }];
    
    [self.leftDaysToNextBillDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25*_scale, 25*_scale));
        make.top.mas_equalTo(self.cdTimeTip.mas_bottom).offset(22*_scale);
        make.centerX.mas_equalTo(self.cardIcon.mas_centerX);
    }];
    self.leftDaysToNextBillDay.layer.cornerRadius = 12.5*_scale;
    self.leftDaysToNextBillDay.layer.masksToBounds = YES;
    
    
    [self.periodTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60*_scale, 25*_scale));
        make.top.mas_equalTo(self.cdTimeTip.mas_bottom).offset(22*_scale);
        make.left.mas_equalTo(self.leftDaysToNextBillDay.mas_right).offset(10*_scale);
    }];
    
    [self.period mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cdTimeTip.mas_bottom).offset(22*_scale);
        make.height.mas_equalTo(25*_scale);
        make.left.mas_equalTo(self.periodTip.mas_right).offset(2*_scale);
        make.right.mas_equalTo(self.rightOperation.mas_left).offset(-5*_scale);
    }];
    
    [self.rightOperation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25*_scale, 25*_scale));
        make.top.mas_equalTo(self.cdTimeTip.mas_bottom).offset(22*_scale);
        make.right.mas_equalTo(self.payStateBgImageView.mas_right);
    }];
    
    //下拉菜单
    [self.pullView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120*_scale, 100*_scale));
        make.top.mas_equalTo(self.payStateBgImageView.mas_bottom).offset(-5*_scale);
        make.right.mas_equalTo(self.payStateBgImageView.mas_right).offset(5*_scale);
    }];
    
    [self.redDotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10*_scale, 10*_scale));
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(20);
    }];
    
    [self.upaidButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50*_scale, 15*_scale));
        make.centerY.mas_equalTo(self.redDotImage.mas_centerY);
        make.left.mas_equalTo(self.redDotImage.mas_right);
    }];
    
    [self.lineImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90*_scale, 1));
        make.top.mas_equalTo(self.upaidButton.mas_bottom).offset(4*_scale);
        make.left.mas_equalTo(20);
    }];
    
    
    [self.greenDotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10*_scale, 10*_scale));
        make.top.mas_equalTo(self.lineImage1.mas_bottom).offset(8*_scale);
        make.left.mas_equalTo(20);
    }];
    
    [self.paidButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50*_scale, 15*_scale));
        make.centerY.mas_equalTo(self.greenDotImage.mas_centerY);
        make.left.mas_equalTo(self.greenDotImage.mas_right);
    }];
    
    [self.lineImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90*_scale, 1));
        make.top.mas_equalTo(self.paidButton.mas_bottom).offset(4*_scale);
        make.left.mas_equalTo(20);
    }];
    
    
    [self.orangeDotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10*_scale, 10*_scale));
        make.top.mas_equalTo(self.lineImage2.mas_bottom).offset(8*_scale);
        make.left.mas_equalTo(20);
    }];
    
    [self.payPartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60*_scale, 15*_scale));
        make.centerY.mas_equalTo(self.orangeDotImage.mas_centerY);
        make.left.mas_equalTo(self.orangeDotImage.mas_right);
    }];
    
    [self.moneyFlagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10*_scale, 12*_scale));
        make.top.mas_equalTo(self.payPartButton.mas_bottom).offset(5*_scale);
        make.left.mas_equalTo(20);
    }];
    
    [self.payPartTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60*_scale, 16*_scale));
        make.centerY.mas_equalTo(self.moneyFlagImage.mas_centerY);
        make.left.mas_equalTo(self.moneyFlagImage.mas_right).offset(8*_scale);
    }];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
