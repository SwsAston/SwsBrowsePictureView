//
//  SwsBrowsePictureView.m
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import "SwsBrowsePictureView.h"
#import "SwsScalePictureView.h"

#define Width   self.bounds.size.width
#define Height  self.bounds.size.height

#define ImageOfFile(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

@interface SwsBrowsePictureView () <UIScrollViewDelegate, SwsScalePictureViewDelegate>

@property(nonatomic, strong)NSMutableArray *allDataSource;
@property(nonatomic, strong)NSMutableArray *threeDataSource;
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, assign)BOOL isCycle;

@property(nonatomic, strong)UIView *leftView;
@property(nonatomic, strong)UIView *centerView;
@property(nonatomic, strong)UIView *rightView;

@property(nonatomic, strong)SwsScalePictureView *leftPictureView;
@property(nonatomic, strong)SwsScalePictureView *centerPictureView;
@property(nonatomic, strong)SwsScalePictureView *rightPicutreView;

@end

@implementation SwsBrowsePictureView

- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(NSMutableArray *)dataSource
                        index:(NSInteger)index
                      isCycle:(BOOL)isCycle
                     delegate:(id)delegate {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        _allDataSource = dataSource;
        _index = index;
        _isCycle = isCycle;
        _touchDelegate = delegate;
        if (_allDataSource.count == 0) {
            
            return self;
        }
        [self initUI];
        [self initDataSource];
        [self loadImageData];
    }
    return self;
}

- (void)initUI {
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.delegate = self;
    self.pagingEnabled = YES;
    self.bounces = NO;
    
    self.contentSize = CGSizeMake(3 * Width, Height);
    
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    [self addSubview:_leftView];
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(Width, 0, Width, Height)];
    [self addSubview:_centerView];
    
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(2 * Width, 0, Width, Height)];
    [self addSubview:_rightView];
    
    if (_allDataSource.count < 3) {
        
        if (_allDataSource.count == 1) {
            
            _threeDataSource = _allDataSource;
            self.contentSize = CGSizeMake(Width, 0);
        } else {
            
            if (_isCycle) {
                
                if (_index == 0) {
                    
                    _threeDataSource = [NSMutableArray arrayWithArray:@[_allDataSource.lastObject,_allDataSource.firstObject,_allDataSource.lastObject]];
                } else {
                    
                    _threeDataSource = [NSMutableArray arrayWithArray:@[_allDataSource.firstObject,_allDataSource.lastObject,_allDataSource.firstObject]];
                }
            } else {
                
                _threeDataSource = _allDataSource;
                self.contentSize = CGSizeMake(2 * Width, 0);
            }
        }
    }
}

- (void)initDataSource {
    
    if (_index == 0) {
        if (_isCycle) {
            
            if (_allDataSource.count >= 3) {
                
                _threeDataSource = [NSMutableArray arrayWithArray:@[_allDataSource.lastObject,_allDataSource.firstObject,_allDataSource[1]]];
            } else {
                
                _threeDataSource = [NSMutableArray arrayWithArray:@[_allDataSource.lastObject,_allDataSource.firstObject,_allDataSource.lastObject]];
            }
        } else {
            
            if (_allDataSource.count >= 3) {
                
                _threeDataSource = [NSMutableArray arrayWithArray:@[_allDataSource.firstObject,_allDataSource[1],_allDataSource[2]]];
            }
        }
    } else if (_index == _allDataSource.count - 1) {
        
        if (_isCycle) {
            
            _threeDataSource = [NSMutableArray arrayWithArray:@[_allDataSource[_allDataSource.count - 2],_allDataSource.lastObject,_allDataSource.firstObject]];
        } else {
            
            if (_allDataSource.count >= 3) {
                
                _threeDataSource = [NSMutableArray arrayWithArray:@[_allDataSource[_allDataSource.count - 3],_allDataSource[_allDataSource.count - 2],_allDataSource.lastObject]];
            }
        }
    } else {
        
        _threeDataSource = [NSMutableArray arrayWithArray:@[_allDataSource[_index - 1],_allDataSource[_index],_allDataSource[_index + 1]]];
    }
}

- (void)loadImageData {
    
    for (int i = 0; i < _threeDataSource.count; i ++) {
        
        id imageData  = _threeDataSource[i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
        
        switch (i) {
            case 0:
                if (!_leftPictureView) {
                    
                    if ([imageData isKindOfClass:[NSString class]]) {
                        
                        if ([imageData hasPrefix:@"http"]) {
//                            
//                            [imageView sd_setImageWithURL:[NSURL URLWithString:imageData] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                
//                                if (imageView.image) {
//                                    
//                                    _leftPictureView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
//                                    [_leftView addSubview:_leftPictureView];
//                                }
//                            }];
                            
                            /** 没SDWebImage */
                            imageView.image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageData]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                            _leftPictureView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
                            [_leftView addSubview:_leftPictureView];
                        } else {
                            
                            imageView.image = ImageOfFile(imageData);
                            _leftPictureView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
                            [_leftView addSubview:_leftPictureView];
                        }
                        
                    } else if ([imageData isKindOfClass:[UIImage class]]){
                        
                        imageView.image = imageData;
                        _leftPictureView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
                        [_leftView addSubview:_leftPictureView];
                    }
                }
                break;
            case 1:
                if (!_centerPictureView) {
                    
                    if ([imageData isKindOfClass:[NSString class]]) {
                        
                        if ([imageData hasPrefix:@"http"]) {
                            
//                            [imageView sd_setImageWithURL:[NSURL URLWithString:imageData] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                
//                                if (imageView.image) {
//                                    
//                                    _centerPictureView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
//                                    [_centerView addSubview:_centerPictureView];
//                                }
//                            }];
                            
                            /** 没SDWebImage */
                            imageView.image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageData]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                            _centerPictureView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
                            [_centerView addSubview:_centerPictureView];
                        } else {
                            
                            imageView.image = ImageOfFile(imageData);
                            _centerPictureView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
                            [_centerView addSubview:_centerPictureView];
                        }
                        
                    } else if ([imageData isKindOfClass:[UIImage class]]){
                        
                        imageView.image = imageData;
                        _centerPictureView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
                        [_centerView addSubview:_centerPictureView];
                    }
                }
                break;
            case 2:
                if (!_rightPicutreView) {
                    
                    if ([imageData isKindOfClass:[NSString class]]) {
                        
                        if ([imageData hasPrefix:@"http"]) {
                            
//                            [imageView sd_setImageWithURL:[NSURL URLWithString:imageData] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                
//                                if (imageView.image) {
//                                    
//                                    _rightPicutreView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
//                                    [_rightView addSubview:_rightPicutreView];
//                                }
//                            }];
                            
                            /** 没SDWebImage */
                            imageView.image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageData]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                            _rightPicutreView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
                            [_rightView addSubview:_rightPicutreView];
                        } else {
                            
                            imageView.image = ImageOfFile(imageData);
                            _rightPicutreView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
                            [_rightView addSubview:_rightPicutreView];
                        }
                        
                    } else if ([imageData isKindOfClass:[UIImage class]]){
                        
                        imageView.image = imageData;
                        _rightPicutreView = [[SwsScalePictureView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) image:imageView.image delegate:self];
                        [_rightView addSubview:_rightPicutreView];
                    }
                }
                break;
            default:
                break;
        }
    }
    
    if (_allDataSource.count < 3) {
        
        if (_isCycle) {
            
            self.contentOffset = CGPointMake(Width, 0);
        } else {
            
            self.contentOffset = CGPointMake(_index * Width, 0);
        }
        return;
    }
    
    if (_isCycle) {
        
        self.contentOffset = CGPointMake(Width, 0);
    } else {
        
        if (_index == 0) {
            
            self.contentOffset = CGPointMake(0, 0);
        } else if (_index == _allDataSource.count - 1) {
            
            self.contentOffset = CGPointMake(Width * 2, 0);
        } else {
            
            self.contentOffset = CGPointMake(Width, 0);
        }
    }
}

#pragma mark -- ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat xOff = scrollView.contentOffset.x / Width;
    
    if (_threeDataSource.count == 1) {
        
        _index = 0;
        return;
    }
    if (_threeDataSource.count == 2) {
        
        if (!_isCycle) {
            
            _index = xOff;
            return;
        }
    }
    if (xOff == 0) {    //向右滑动
        
        if (_index == 0) {
            
            if (!_isCycle) {
                
                return;
            } else {
                
                _index = _allDataSource.count - 1;
            }
        } else {
            
            _index = _index - 1;
        }
        if (_index == 0) {
            if (!_isCycle) {
                
                return;
            }
        }
        
        [self initDataSource];
        
        if (_centerPictureView.image) {
            
            _rightPicutreView.image = _centerPictureView.image;
        }
        if (_leftPictureView.image) {
            
            _centerPictureView.image = _leftPictureView.image;
        }
        
        id imageData = _threeDataSource.firstObject;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
        
        if ([imageData isKindOfClass:[NSString class]]) {
            
            if ([imageData hasPrefix:@"http"]) {
                
//                [imageView sd_setImageWithURL:[NSURL URLWithString:imageData] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    
//                    if (imageView.image) {
//                        
//                        _leftPictureView.image = imageView.image;
//                        
//                    }
//                }];
                
                /** 没SDWebImage */
                imageView.image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageData]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                _leftPictureView.image = imageView.image;
            } else {
                
                imageView.image = ImageOfFile(imageData);
                _leftPictureView.image = imageView.image;
            }
        } else if ([imageData isKindOfClass:[UIImage class]]){
            
            imageView.image = imageData;
            _leftPictureView.image = imageView.image;
        }
    } else if (xOff == 2) {   //向左滑动
        
        if (_index == _allDataSource.count - 1) {
            
            if (!_isCycle) {
                
                return;
            } else {
                
                _index = 0;
            }
        } else {
            
            _index = _index + 1;
        }
        if (_index == _allDataSource.count -1) {
            
            if (!_isCycle) {
                
                return;
            }
        }
        
        [self initDataSource];
        
        if (_centerPictureView.image) {
            
            _leftPictureView.image = _centerPictureView.image;
        }
        if (_rightPicutreView.image) {
            
            _centerPictureView.image = _rightPicutreView.image;
        }
        
        id imageData = _threeDataSource.lastObject;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
        
        if ([imageData isKindOfClass:[NSString class]]) {
            
            if ([imageData hasPrefix:@"http"]) {
                
                
//                [imageView sd_setImageWithURL:[NSURL URLWithString:imageData] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    
//                    if (imageView.image) {
//                        
//                        _rightPicutreView.image = imageView.image;
//                        
//                    }
//                }];
                
                /** 没SDWebImage */
                imageView.image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageData]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                _rightPicutreView.image = imageView.image;
                
            } else {
                
                imageView.image = ImageOfFile(imageData);
                _rightPicutreView.image = imageView.image;
            }
            
        } else if ([imageData isKindOfClass:[UIImage class]]){
            
            imageView.image = imageData;
            _rightPicutreView.image = imageView.image;
            
        }
    } else {
        
        if (_index == 0) {
            
            _index = 1;
        } else if(_index == _allDataSource.count - 1) {
            
            _index = _allDataSource.count - 2;
        }
    }
    scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}

#pragma mark - SwsScalePictureViewDelegate
- (void)onceTouchSwsScalePictureView {
    
    if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(returnSwsBrowsePictureViewIndex:)]) {
        
        [_touchDelegate returnSwsBrowsePictureViewIndex:_index];
    }
    [self dismiss];
}

#pragma mark - show / dismiss
- (void)showInView:(UIView *)view {
    
    self.alpha = 0;
    [view addSubview:self];
    __weak SwsBrowsePictureView *browseView = self;
    [UIView animateWithDuration:.3 animations:^{
        
        browseView.alpha = 1;
    }];
}

- (void)dismiss {
    
    [self removeFromSuperview];
}

@end
