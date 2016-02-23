//
//  BaseTableHeaderFooterView.m
//  TXiOSClient
//
//  Created by dsc on 15/5/7.
//  Copyright (c) 2015年 liguohui. All rights reserved.
//

#import "TableHeaderView.h"
#import "UIView+Addition.h"

@implementation TableHeaderView
{
    UILabel *_titleLabel;   //  标题
    UIView *_sectionTitleView;  //  承载标题的view
    UIImageView *_indicatorImgView; //  指示图标
    UIImageView *_headerBg;
    UILabel *_monthLabel;//月份
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _headerBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableHeaderBg"]];
        [self.contentView addSubview:_headerBg];
        
        _sectionTitleView = [[UIView alloc] initWithFrame:CGRectZero];
        _sectionTitleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionDidTaped:)];
        [_sectionTitleView addGestureRecognizer:tapGesture];
        [self.contentView addSubview:_sectionTitleView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_sectionTitleView addSubview:_titleLabel];
        
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _monthLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _monthLabel.numberOfLines = 0;
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font = [UIFont systemFontOfSize:14];
        _monthLabel.textColor = [UIColor orangeColor];
//        [_monthLabel setMyViewLayerBoardColor:[UIColor colorWithRed:0 green:1.0f blue:1.0f alpha:1.0] AndBoardWidth:1 AndCornerRadius:10];
        
        [_sectionTitleView addSubview:_monthLabel];
        
        _indicatorImgView = [[UIImageView alloc] init];
        _indicatorImgView.size = CGSizeMake(8, 16);
        _indicatorImgView.image = [UIImage imageNamed:@"iconfont-qianjin"];
        [_sectionTitleView addSubview:_indicatorImgView];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.layer.cornerRadius = 10;
    _sectionTitleView.frame = self.contentView.bounds;
    _headerBg.frame = self.contentView.bounds;
    _titleLabel.frame = CGRectMake(60, 0, self.contentView.width - 60, self.contentView.height);
    
    float monthLabelOriginX = 2 * MainScreenWidth/320;
    _monthLabel.frame = CGRectMake(monthLabelOriginX, self.contentView.centerY - 15, 40 * MainScreenWidth/320, 30);
    
    _indicatorImgView.right = self.contentView.width - 20;
    _indicatorImgView.centerY = self.contentView.centerY;
}

- (void)setSectionTitle:(NSString *)sectionTitle
{
    _titleLabel.text = sectionTitle;
}

- (void)setMonth:(NSString *)month {
    _monthLabel.text = month;
}

-(void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    [UIView animateWithDuration:0.25 animations:^{
        if (isOpen) {
            _indicatorImgView.transform = CGAffineTransformMakeRotation(M_PI/2);

        }else {
            _indicatorImgView.transform = CGAffineTransformMakeRotation(0);
        }
    }];
}

-(void)setContentBGColor:(UIColor *)contentBGColor
{
    self.contentView.backgroundColor = contentBGColor;
}

#pragma mark - tap action
- (void)sectionDidTaped:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(headerViewDidTaped:sectionIndex:)]) {
        [self.delegate headerViewDidTaped:self sectionIndex:self.sectionIndex];
    }
}


@end
