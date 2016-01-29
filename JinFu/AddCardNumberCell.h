//
//  AddCardNumberCell.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AddRowViewClickBlock) (void);
typedef void (^GetAddedCardInfoBlock)(NSString *);

@interface AddCardNumberCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTf;
@property (strong, nonatomic) IBOutlet UITextField *bankNameTF;

@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (nonatomic, copy)AddRowViewClickBlock buttonViewAction;
@property (nonatomic, copy)GetAddedCardInfoBlock getCardNumber;
@property (nonatomic, copy)GetAddedCardInfoBlock getBankName;

@end
