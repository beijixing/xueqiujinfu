//
//  UploadImageCell.h
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TappedImageViewActionBlock)(NSInteger);
@interface UploadImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;
@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (nonatomic, copy) TappedImageViewActionBlock tappedImageAction;
- (void)setUploadedImage:(NSArray *)imageNameArr;
@end
