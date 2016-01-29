//
//  LPCTools.m
//  UIGestureRecognizer
//
//  Created by 神丶宁静致远 on 15/9/1.
//  Copyright (c) 2015年 LPC. All rights reserved.
//

#import "QGTools.h"

@implementation QGTools

//工厂模式
//创建按钮
+ (UIButton *)createButton:(CGRect)frame bgColor:(UIColor *)bgColor title:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag action:(SEL)action vc:(id)vc
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = bgColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

//创建标签
+ (UILabel *)createLabel:(CGRect)frame text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor tag:(NSInteger)tag
{
    UILabel * label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = text;
    label.textAlignment = textAlignment;
    label.textColor = textColor;
    label.backgroundColor = bgColor;
    label.tag = tag;
    
    return label ;
}
//创建TextField
+ (UITextField *)creatTextField:(CGRect)frame bgColor:(UIColor *)bgColor borderStyle:(UITextBorderStyle)borderStyle placeHolder:(NSString *)placeHolder keyboardType:(UIKeyboardType)keyboardType tag:(NSInteger)tag font:(UIFont *)font secureTextEntry:(BOOL)secureTextEntry clearButtonMode:(UITextFieldViewMode)clearButtonMode
{
    UITextField * textField = [[UITextField alloc]init];
    textField.frame = frame;
    textField.font = font;
    textField.backgroundColor = bgColor;
    textField.borderStyle = borderStyle;
    textField.placeholder = placeHolder;
    textField.keyboardType = keyboardType;
    textField.tag = tag;
    textField.secureTextEntry = secureTextEntry;
    textField.clearButtonMode = clearButtonMode;
    return textField;
}
//返回随机颜色
+ (UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
}

@end
