//
//  AddSpaceView.h
//  JinFu
//
//  Created by 山东远邦 on 16/1/12.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSpaceView : UIView<UIGestureRecognizerDelegate>
{
    UIView *parentView;
}
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, assign) id delegate;

- (id)initWithParentView:(UIView *)_parentView;
- (void)show;
- (void)close;

@end
