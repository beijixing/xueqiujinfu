//
//  MyProtectionCell.m
//  JinFu
//
//  Created by ybon on 16/2/25.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "MyProtectionCell.h"
#import "Masonry.h"
#import "CardAndNumberCell.h"
#import "ServiceCardListDataModel.h"
#import "BankCardIconManager.h"

#define  TipTextColor ColorWithRGB(100, 100, 100)
@interface MyProtectionCell ()<UITableViewDataSource, UITableViewDelegate>
{
    float _scale;
    NSArray *_dataArr;
    UITableView *_cardList;
}
//银行卡信息
@property (strong, nonatomic) UIView *onlyOneCardView;
@property (strong, nonatomic) UIView *threeCardsView;
//pos隐藏信息
@property (strong, nonatomic) UILabel *tianhouLable;
@property (strong, nonatomic) UILabel *fuwuLabel;
@property (strong, nonatomic) UILabel *fuwuqixianLable;
@property (strong, nonatomic) UILabel *yueLabel;
@property (strong, nonatomic) UILabel *fuwuqiLabel;
@end
@implementation MyProtectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _scale = [UIScreen mainScreen].bounds.size.width/320;
        
        self.bankCardBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bankCardBg4"]];
        [self.contentView addSubview:self.bankCardBg];
        
        self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diu-ka-bao-zhang"]];
        [self.contentView addSubview:self.icon];
        
        self.title = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial Rounded MT Bold" size:16.0] text:@"丢卡保障"];
        [self.contentView addSubview:self.title];
        
        self.lineImage = [[UIImageView alloc] init];
        self.lineImage.backgroundColor = ColorWithRGB(220, 220, 220);
        [self.contentView addSubview:self.lineImage];
        
        self.operationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.operationButton setTitle:@"申请赔付" forState:UIControlStateNormal];
        [self.operationButton setBackgroundImage:[UIImage imageNamed:@"payStateBg2"] forState:UIControlStateNormal];
        [self.operationButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.operationButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
        [self.contentView addSubview:self.operationButton];
        
        self.endTime = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:12.0] text:@"服务截止日期11.12"];
        self.endTime.textColor = TipTextColor;
        [self.contentView addSubview: self.endTime];

        
        self.CDTime = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial Rounded MT Bold" size:16] text:@"185"];
        self.CDTime.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: self.CDTime];
        self.tianhouLable = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:12.0] text:@"天后"];
        self.tianhouLable.textAlignment = NSTextAlignmentCenter;
        self.tianhouLable.textColor = TipTextColor;
        [self.contentView addSubview: self.tianhouLable];
        
        self.fuwuLabel = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:12.0] text:@"服务卡号"];
        self.fuwuLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.fuwuLabel.numberOfLines = 2;
        self.fuwuLabel.textColor = TipTextColor;
        [self.contentView addSubview: self.fuwuLabel];
        
        //设置行间距
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.fuwuLabel.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5*_scale];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.fuwuLabel.text length])];
        [self.fuwuLabel setAttributedText:attributedString1];
        [self.fuwuLabel sizeToFit];
        
        
        self.fuwuqixianLable = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:12.0] text:@"服务期限"];
        self.fuwuqixianLable.lineBreakMode = NSLineBreakByCharWrapping;
        self.fuwuqixianLable.numberOfLines = 2;
        self.fuwuqixianLable.textColor = TipTextColor;
        [self.contentView addSubview: self.fuwuqixianLable];
        
        NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:self.fuwuqixianLable.text];
        NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle2 setLineSpacing:5*_scale];
        [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [self.fuwuqixianLable.text length])];
        [self.fuwuqixianLable setAttributedText:attributedString2];
        [self.fuwuqixianLable sizeToFit];
    
        self.servicePeriod = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20.0] text:@"01"];
        self.servicePeriod.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: self.servicePeriod];
        
        self.yueLabel = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:13.0] text:@"月"];
        self.yueLabel.textColor = TipTextColor;
        [self.contentView addSubview: self.yueLabel];
        
        self.fuwuqiLabel = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:12.0] text:@"服务期："];
        self.fuwuqiLabel.textAlignment = NSTextAlignmentCenter;
        self.fuwuqiLabel.textColor = TipTextColor;
        [self.contentView addSubview: self.fuwuqiLabel];
        
        self.serviceStartAndEndTime = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial" size:12.0] text:@"2015.12.01-2016.06.09"];
        self.serviceStartAndEndTime.textColor = TipTextColor;
        [self.contentView addSubview: self.serviceStartAndEndTime];
        
        self.buyServiceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.buyServiceButton setTitle:@"购买续保" forState:UIControlStateNormal];
        
        [self.buyServiceButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buyServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.buyServiceButton setBackgroundColor:ColorWithRGB(255, 197, 30)];
        self.buyServiceButton.layer.cornerRadius = 4.0f;
        self.buyServiceButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        [self.contentView addSubview:self.buyServiceButton];
       
        //银行卡信息
        self.onlyOneCardView = [[UIView alloc] init];
        [self.contentView addSubview:self.onlyOneCardView];
        
        self.bankIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_beijing"]];
        [self.onlyOneCardView addSubview:self.bankIcon];
        
        self.bankName = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0] text:@"建设银行"];
        [self.onlyOneCardView addSubview: self.bankName];
        self.cardLast4Num = [ToolBox createLabelWithFrame:CGRectZero font:[UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0] text:@"9556"];
        [self.onlyOneCardView addSubview: self.cardLast4Num];
//        self.onlyOneCardView.hidden = YES;
        [self.contentView addSubview:self.onlyOneCardView];
        
    
        self.threeCardsView = [[UIView alloc] init];
        self.threeCardsView.backgroundColor = [UIColor clearColor];
        self.threeCardsView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.threeCardsView];
//        self.threeCardsView.hidden = YES;
        
        _cardList = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _cardList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cardList.showsHorizontalScrollIndicator = NO;
        _cardList.showsVerticalScrollIndicator = NO;
        _cardList.dataSource = self;
        _cardList.delegate = self;
        _cardList.transform = CGAffineTransformMakeRotation(-M_PI / 2);//横向滚动
        _cardList.backgroundColor = [UIColor clearColor];
        [self.threeCardsView addSubview:_cardList];
        [self.contentView addSubview:self.threeCardsView];

        [self layoutSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bankCardBg.frame = self.bounds;
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*_scale, 30*_scale));
        make.left.mas_equalTo(25*_scale);
        make.top.mas_equalTo(25*_scale);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100*_scale, 20*_scale));
        make.left.mas_equalTo(self.icon.mas_right).offset(15*_scale);
        make.top.mas_equalTo(20*_scale);
    }];
    
    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120*_scale, 15*_scale));
        make.left.mas_equalTo(self.title.mas_left);
        make.top.mas_equalTo(self.title.mas_bottom);
    }];
    
    [self.lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 30*_scale));
        make.left.mas_equalTo(self.endTime.mas_right).offset(20*_scale);
        make.top.mas_equalTo(20*_scale);
    }];
    
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22*_scale);
        make.right.mas_equalTo(-25*_scale);
        make.left.mas_equalTo(self.lineImage.mas_right).offset(20*_scale);
        make.top.mas_equalTo(25*_scale);
    }];
    
    [self.CDTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50*_scale, 20*_scale));
        make.centerX.mas_equalTo(self.icon.mas_centerX);
        make.top.mas_equalTo(self.icon.mas_bottom).offset(15*_scale);
    }];
    
    [self.tianhouLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*_scale, 20*_scale));
        make.centerX.mas_equalTo(self.icon.mas_centerX);
        make.top.mas_equalTo(self.CDTime.mas_bottom);
    }];
    
    [self.fuwuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25*_scale, 40*_scale));
        make.left.mas_equalTo(self.endTime.mas_left);
        make.top.mas_equalTo(self.CDTime.mas_top);
    }];
    
    [self.threeCardsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50*_scale);
        make.top.mas_equalTo(self.CDTime.mas_top);
        make.left.mas_equalTo(self.fuwuLabel.mas_right).offset(2*_scale);
        make.right.mas_equalTo(self.fuwuqixianLable.mas_left).offset(-5*_scale);
    }];
    
    [_cardList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60*_scale, 115*_scale));
        make.center.mas_equalTo(self.threeCardsView);
    }];
    [_cardList reloadData];
    
    [self.onlyOneCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50*_scale);
        make.top.mas_equalTo(self.CDTime.mas_top).offset(0);
        make.left.mas_equalTo(self.fuwuLabel.mas_right);
        make.right.mas_equalTo(self.fuwuqixianLable.mas_left).offset(-5*_scale);
    }];
    
    [self.bankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*_scale, 30*_scale));
        make.left.mas_equalTo(10*_scale);
        make.top.mas_equalTo(5*_scale);
    }];
    
    [self.bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60*_scale, 15*_scale));
        make.left.mas_equalTo(self.bankIcon.mas_right).offset(5*_scale);
        make.top.mas_equalTo(self.bankIcon.mas_top).offset(0*_scale);
    }];
    
    [self.cardLast4Num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60*_scale, 15*_scale));
        make.left.mas_equalTo(self.bankName.mas_left);
        make.top.mas_equalTo(self.bankName.mas_bottom).offset(0*_scale);
    }];
    
    [self.fuwuqixianLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.servicePeriod.mas_left).offset(-2*_scale);
        make.size.mas_equalTo(CGSizeMake(25*_scale, 40*_scale));
        make.top.mas_equalTo(self.CDTime.mas_top);
    }];
    
    [self.servicePeriod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40*_scale, 35*_scale));
        make.right.mas_equalTo(self.yueLabel.mas_left).offset(-2*_scale);
        make.top.mas_equalTo(self.CDTime.mas_top).offset(2*_scale);
    }];
    
    [self.yueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15*_scale, 15*_scale));
        make.right.mas_equalTo(self.operationButton.mas_right);
        make.centerY.mas_equalTo(self.servicePeriod.mas_centerY);
    }];
    
    [self.fuwuqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50*_scale, 20*_scale));
        make.left.mas_equalTo(self.tianhouLable.mas_left);
        make.top.mas_equalTo(self.tianhouLable.mas_bottom).offset(25*_scale);
    }];
    
    [self.serviceStartAndEndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fuwuqiLabel.mas_centerY);
        make.height.mas_equalTo(20*_scale);
        make.left.mas_equalTo(self.fuwuqiLabel.mas_right).offset(2*_scale);
        make.right.mas_equalTo(self.buyServiceButton.mas_left).offset(2*_scale);
    }];
    
    [self.buyServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60*_scale, 20*_scale));
        make.right.mas_equalTo(self.operationButton.mas_right);
        make.centerY.mas_equalTo(self.fuwuqiLabel.mas_centerY);
    }];
}


- (void)buyServiceButtonClick:(UIButton *)sender {
    if (self.buyService)
    {
        self.buyService();
    }
}

- (void)operationButtonClick:(UIButton *)sender
{
    if (self.operationEvevnt) {
        self.operationEvevnt();
    }
    
    if (self.askPay) {
        self.askPay();
    }
}


- (void)setCardsInfo:(NSArray *)cardsInfo {
    if (cardsInfo.count == 1) {
        self.onlyOneCardView.hidden = NO;
        self.threeCardsView.hidden = YES;
        ServiceCardListDataModel *cardData = cardsInfo[0];
        self.bankName.text = [NSString stringWithFormat:@"%@", cardData.bankName];
        
        self.cardLast4Num.text = [self getCardNUmberText:cardData.cardNumber];;
        NSString *iconPath = [[BankCardIconManager sharedManager] getBankIconPathWithName: cardData.bankName];
        self.bankIcon.image = ImageName(iconPath);
    }else {
        self.onlyOneCardView.hidden = YES;
        self.threeCardsView.hidden = NO;
        _dataArr = cardsInfo;
        
    }
}

- (NSString *)getCardNUmberText:(NSString *)cardNumber {
    NSString *cardNumberText;
    if (cardNumber.length < 5) {
        cardNumberText = cardNumber;
    }else {
        cardNumberText = [NSString stringWithFormat:@"%@", [cardNumber substringWithRange:NSMakeRange(cardNumber.length-5, 4)]];
    }
    return cardNumberText;
}

- (void)setPosItemShowState:(BOOL)state {
    if (state) {//显示pos无关的标签
        self.tianhouLable.hidden = YES;
        self.fuwuLabel.hidden = YES;
        self.fuwuqixianLable.hidden = YES;
        self.yueLabel.hidden = YES;
        self.fuwuqiLabel.hidden = YES;
        self.endTime.hidden = YES;
        self.CDTime.hidden = YES;
        self.bankIcon.hidden = YES;
        self.bankName.hidden = YES;
        self.cardLast4Num.hidden = YES;
        self.servicePeriod.hidden = YES;
        self.serviceStartAndEndTime.hidden = YES;
        self.buyServiceButton.hidden = YES;
    }else {
        self.tianhouLable.hidden = NO;
        self.fuwuLabel.hidden = NO;
        self.fuwuqixianLable.hidden = NO;
        self.yueLabel.hidden = NO;
        self.fuwuqiLabel.hidden = NO;
        self.endTime.hidden = NO;
        self.CDTime.hidden = NO;
        self.bankIcon.hidden = NO;
        self.bankName.hidden = NO;
        self.cardLast4Num.hidden = NO;
        self.servicePeriod.hidden = NO;
        self.serviceStartAndEndTime.hidden = NO;
        self.buyServiceButton.hidden = NO;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardAndNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardAndNumberCell"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CardAndNumberCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);//横向滚动
    }
    ServiceCardListDataModel *cardData = _dataArr[indexPath.row];
    cell.cardNumber.text = [self getCardNUmberText:cardData.cardNumber];;
    NSString *iconPath = [[BankCardIconManager sharedManager] getBankIconPathWithName: cardData.bankName];
    cell.cardImageView.image = ImageName(iconPath);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40*_scale;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
