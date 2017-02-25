//
//  ViewController.m
//  ZXCDemo
//
//  Created by 张绪川 on 16/11/26.
//  Copyright © 2016年 张. All rights reserved.
//

#import "ViewController.h"

#import "ZXCRollingBanner.h"


@interface ViewController ()<ZXCRollingBannerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray * imgArr = [NSMutableArray array];
    for (int i = 0 ; i < 5; i++) {
        UIImage * img = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        [imgArr addObject:img];
    }
    
    NSArray * urlArr = @[@"http://ohvjgcwh9.bkt.clouddn.com/0.jpg",
                         @"http://ohvjgcwh9.bkt.clouddn.com/1.jpg",
                         @"http://ohvjgcwh9.bkt.clouddn.com/2.jpg",
                         @"http://ohvjgcwh9.bkt.clouddn.com/3.jpg"];
    
    
    
    CGFloat width =  [UIScreen mainScreen].bounds.size.width;
    ZXCRollingBanner * sc = [[ZXCRollingBanner alloc]initWithFrame:CGRectMake(0, 0,width , 200)];
    sc.delegate = self;
    sc.placeholderImage = [UIImage imageNamed:@"placeholder.jpg"];
    
    
//    [sc setImageWithImgArr:imgArr];
    
    [sc setImageWithUrlArr:urlArr];
    
//    [sc tapWihtBlock:^(NSInteger tapIndex) {
//        NSLog(@"block点击:%ld",tapIndex);
//    }];

//    [sc scrollWithBlock:^(NSInteger currentIndex) {
//        NSLog(@"通过block得到的滚动索引:%ld",currentIndex);
//    }];

    [self.view addSubview:sc];


}


#pragma mark - zxcAdScrollViewDelegate

-(void)scrollToIndex:(NSInteger)index{
    NSLog(@"当前显示索引%ld",index);
}

-(void)tapAtIndex:(NSInteger)index{
    NSLog(@"点击索引%ld",index);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
