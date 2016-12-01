//
//  SwsScalePictureView.h
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwsScalePictureViewDelegate <NSObject>

@optional

- (void)onceTouchSwsScalePictureView;

@end

@interface SwsScalePictureView : UIScrollView

@property (nonatomic, weak) id <SwsScalePictureViewDelegate> touchDelegate;

@property (nonatomic, strong) UIImage *image;

/** SwsScalePictureView */
- (SwsScalePictureView *)initWithFrame:(CGRect)frame
                    image:(UIImage *)image
                     delegate:(id)delegate;


@end
