//
//  SwsBrowsePictureView.h
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwsBrowsePictureViewDelegate <NSObject>

@optional

- (void)returnSwsBrowsePictureViewIndex:(NSInteger)index;

@end

@interface SwsBrowsePictureView : UIScrollView

@property (nonatomic, weak) id <SwsBrowsePictureViewDelegate> touchDelegate;

/** SwsBrowsePictureView */
- (SwsBrowsePictureView *)initWithFrame:(CGRect)frame
                   dataSource:(NSMutableArray *)dataSource
                        index:(NSInteger)index
                      isCycle:(BOOL) isCycle
                     delegate:(id)delegate;

/**  showInView */
- (void)showInView:(UIView *)view;

@end
