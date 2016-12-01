//
//  ViewController.m
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import "ViewController.h"
#import "SwsBrowsePictureView.h"

@interface ViewController () <SwsBrowsePictureViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

#pragma mark - image
- (IBAction)touchImage:(UIButton *)sender {
    
    NSMutableArray *dataSource = [NSMutableArray array];
    for (UIImageView *imageView in _imageViewArray) {
        
        [dataSource addObject:imageView.image];
    }
    
    SwsBrowsePictureView *browseView = [[SwsBrowsePictureView alloc] initWithFrame:self.view.frame dataSource:dataSource index:sender.tag isCycle:YES delegate:self];
    [browseView showInView:self.view];
}

#pragma mark - imageName
- (IBAction)imageName:(UIButton *)sender {
    
    NSMutableArray *dataSource = [NSMutableArray array];

    for (int i = 0; i < 6; i ++) {
        
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
        [dataSource addObject:imageName];
    }
    
    SwsBrowsePictureView *browseView = [[SwsBrowsePictureView alloc] initWithFrame:self.view.frame dataSource:dataSource index:3 isCycle:NO delegate:self];
    [browseView showInView:self.view];
}

#pragma mark - Url
- (IBAction)URL:(UIButton *)sender {
    
    NSMutableArray *dataSource = [NSMutableArray arrayWithObjects:@"http://pic10.nipic.com/20101103/5063545_000227976000_2.jpg",@"http://pic41.nipic.com/20140519/18505720_094832590165_2.jpg",@"http://d.hiphotos.bdimg.com/album/whcrop%3D657%2C370%3Bq%3D90/sign=2c994e578a82b9013df895711cfd9441/09fa513d269759eede0805bbb2fb43166d22df62.jpg",@"http://pic63.nipic.com/file/20150405/9448607_131532608000_2.jpg",@"http://img.taopic.com/uploads/allimg/111020/6462-11102012191612.jpg",@"http://pic27.nipic.com/20130311/1056319_114419500000_2.jpg", nil];
    SwsBrowsePictureView *browseView = [[SwsBrowsePictureView alloc] initWithFrame:self.view.frame dataSource:dataSource index:0 isCycle:NO delegate:self];
    [browseView showInView:self.view];
}

#pragma mark - SwsBrowsePictureViewDelegate
- (void)returnSwsBrowsePictureViewIndex:(NSInteger)index {
    
    NSLog(@"%ld",index);
}

@end
