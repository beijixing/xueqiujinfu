//
//  UploadImageCell.m
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "UploadImageCell.h"
#import "UIImageView+WebCache.h"
@interface UploadImageCell()
{
    NSArray *_imageViewArr;
}
@end

@implementation UploadImageCell

- (void)awakeFromNib {
    // Initialization code
    
    _imageViewArr = [[NSArray alloc] initWithObjects:self.firstImage, self.secondImage, self.thirdImage, self.fourthImage, nil];
    
    for (UIImageView *imageView in _imageViewArr) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tapGesture];
    }
}

- (void)imageViewTapped:(UIGestureRecognizer *)tapGeture {
    UIView *tapedView = tapGeture.view;
    self.tappedImageAction(tapedView.tag);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUploadedImage:(NSArray *)imageNameArr {
    NSInteger imageNameCnt = 0;
    for (NSString *str in imageNameArr) {
        if (![str isEqualToString:@""]) {
            imageNameCnt++;
        }
    }
    
    for (int i = 0; i< [_imageViewArr count]; i++) {
        UIImageView *imageView = [_imageViewArr objectAtIndex:i];
        if (i>imageNameCnt) {
            imageView.userInteractionEnabled = NO;
        }else if (i < imageNameCnt ){
            NSString *imageName = [imageNameArr objectAtIndex:i];
            DLog(@"imageName = %@" , imageName);
            if ([imageName hasPrefix:@"http"]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
            }else{
                imageView.image = ImageName(imageName);
            }
            NSArray* subviews = imageView.subviews;
            for (UIView *view in subviews) {
                view.hidden = YES;
            }
        }
    }
}

@end
