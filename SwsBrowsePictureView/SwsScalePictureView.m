//
//  SwsScalePictureView.m
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import "SwsScalePictureView.h"

#define Width   self.bounds.size.width
#define Height  self.bounds.size.height

#define Max_Scale 1.8f
#define Min_Scale 1.0f

@interface SwsScalePictureView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGSize imageSize;

@end

@implementation SwsScalePictureView

- (SwsScalePictureView *)initWithFrame:(CGRect)frame
                                 image:(UIImage *)image
                              delegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        
        _image = image;
        _touchDelegate = delegate;
        [self setMaxMinZoomScale];
        [self setDefaultState];
    }
    return self;
}

- (void)setMaxMinZoomScale {
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.delegate = self;
    
    self.maximumZoomScale = Max_Scale;
    self.minimumZoomScale = Min_Scale;
}

#pragma mark - setDefaultState
- (void)setDefaultState {
    
    [self initUI];
    [self changeSize];
    [self addGestureRecognizer];
}

- (void)initUI {
    
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.backgroundColor = [UIColor grayColor];
    _contentView.userInteractionEnabled = YES;
    [self addSubview:_contentView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    _imageView.image = _image;
    _imageSize = [self sizeThatFits:_imageView.bounds.size];
    
    _contentView.frame = CGRectMake(0, 0, _imageSize.width, _imageSize.height);
    _imageView.bounds = CGRectMake(0, 0, _imageSize.width, _imageSize.height);
    _imageView.center = CGPointMake(_imageSize.width / 2, _imageSize.height / 2);
    
    self.contentSize = _imageSize;
    
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    _imageView.clipsToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    [_contentView addSubview:_imageView];
    
}

#pragma mark - imageSize
- (CGSize)sizeThatFits:(CGSize)size {
    
    CGSize imageSize = CGSizeMake(self.imageView.image.size.width / self.imageView.image.scale,
                                  self.imageView.image.size.height / self.imageView.image.scale);
    
    CGFloat widthRatio = imageSize.width / size.width;
    CGFloat heightRatio = imageSize.height / size.height;
    
    if (widthRatio > heightRatio) {
        
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    return imageSize;
}

#pragma mark - ChangeSize
- (void)changeSize {
    
    CGRect frame = _contentView.frame;
    CGFloat top = 0, left = 0;
    
    if (self.contentSize.width < self.bounds.size.width) {
        
        left = (self.bounds.size.width - self.contentSize.width) * 0.5f;
    }
    
    if (self.contentSize.height < self.bounds.size.height) {
        
        top = (self.bounds.size.height - self.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

#pragma mark - AddGestureRecognizer
- (void)addGestureRecognizer {
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [_contentView addGestureRecognizer:doubleTapGestureRecognizer];
    
    UITapGestureRecognizer *onceTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self addGestureRecognizer:onceTapGestureRecognizer];
    
    [onceTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
}

- (void)tapHandler:(UITapGestureRecognizer *)tap {
    
    if (1 == tap.numberOfTapsRequired) {
        
        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(onceTouchSwsScalePictureView)]) {
            
            [_touchDelegate onceTouchSwsScalePictureView];
        }
    } else {
        
        if (self.zoomScale > self.minimumZoomScale) {
            
            [self setZoomScale:self.minimumZoomScale animated:YES];
        } else if (self.zoomScale < self.maximumZoomScale) {
            
            CGPoint location = [tap locationInView:tap.view];
            CGRect zoomToRect = CGRectMake(0, 0, 50, 50);
            zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect) / 2, location.y - CGRectGetHeight(zoomToRect) / 2);
            [self zoomToRect:zoomToRect animated:YES];
        }
    }
}

#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _contentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    [self changeSize];
}

#pragma mark - SetImage
- (void)setImage:(UIImage *)image {
    
    _image = image;
    
    [_imageView removeFromSuperview];
    [_contentView removeFromSuperview];
    _imageView = nil;
    _contentView = nil;
    
    [self setDefaultState];
}

@end
