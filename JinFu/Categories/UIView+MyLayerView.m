//
//  UIView+MyLayerView.m
//  zglTest
//
//  Created by 郑光龙 on 15/10/27.
//  Copyright © 2015年 郑光龙. All rights reserved.
//

#import "UIView+MyLayerView.h"

@implementation UIView (MyLayerView)

- (void)setMyViewLayerBoardColor:(UIColor *)boardColor AndBoardWidth:(CGFloat)boardWidth AndCornerRadius:(CGFloat)radius
{
    self.layer.borderColor = [boardColor CGColor];
    self.layer.borderWidth = boardWidth;
    self.layer.cornerRadius = radius;
}

- (void)addDottedLineWithWidth:(CGFloat)lineWidth andColor:(UIColor *)lineColor {
    CGRect frame = self.frame;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    //    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:CGRectGetWidth(borderLayer.bounds)/2].CGPath;
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    //虚线边框
    borderLayer.lineDashPattern = @[@8, @8];
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:borderLayer];
}
@end
