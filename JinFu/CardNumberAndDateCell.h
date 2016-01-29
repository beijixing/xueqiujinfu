//
//  CardNumberAndDateCell.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AddCellBlock) (void);
typedef void (^GetCardInfoBlock)(NSString *);


@interface CardNumberAndDateCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *billDateTF;
@property (strong, nonatomic) IBOutlet UIView *addButtonView;
@property (nonatomic, copy) AddCellBlock buttonViewAction;
@property (nonatomic, copy) GetCardInfoBlock cardNumberBlcok;
@property (nonatomic, copy) GetCardInfoBlock billDateBlcok;
@property (nonatomic, copy) GetCardInfoBlock bankNameBlcok;
@end
