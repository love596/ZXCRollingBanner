//
//  zxcRollingBanner.m
//  ZXCDemo
//
//  Created by zhang on 16/12/16.
//  Copyright © 2016年 张绪川. All rights reserved.
//

#import "ZXCRollingBanner.h"
#import <UIImageView+WebCache.h>

@interface ZXCRollingBanner ()<UIScrollViewDelegate>

///
@property ( nonatomic,strong) UIScrollView * scrollView ;
///
@property ( nonatomic,strong) UIPageControl * pageControl ;
///
@property ( nonatomic,strong) NSMutableArray * dataSource ;
///
@property ( nonatomic,strong) NSTimer * timer ;


@property (nonatomic,copy) void (^scrollBlock) (NSInteger currentIndex);

@property (nonatomic,copy) void (^tapBlock) (NSInteger tapIndex);

@end

@implementation ZXCRollingBanner


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化滚动时间
        _scrollTime = 3;
        //创建子视图
        [self buildView];
        
        
    }
    return self;
}

- (void)dealloc
{
    if (_timer != nil) {
        [_timer invalidate];
    }
}


-(void)buildView{
    
    [self addSubview:self.scrollView];
    
    [self addSubview:self.pageControl];
    
}

//填充子视图-0  
-(void)setImageWithUrlArr:(NSArray<NSString *> *)urlArr{
    
    self.dataSource = [NSMutableArray arrayWithArray:urlArr];
    
    self.pageControl.numberOfPages = self.dataSource.count;
    self.pageControl.currentPage = 0;
    
    for (int i = 0; i< self.dataSource.count+1; i++) {
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        imgView.contentMode = UIViewContentModeScaleToFill;
        
        if(i == self.dataSource.count){
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.dataSource[0]] placeholderImage:self.placeholderImage options:SDWebImageRefreshCached|SDWebImageAllowInvalidSSLCertificates];
            
            [self.scrollView addSubview:imgView];
            break;
            //最后一项的特殊处理
        }
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.dataSource[i]] placeholderImage:self.placeholderImage options:SDWebImageRefreshCached|SDWebImageAllowInvalidSSLCertificates];
        
        [self.scrollView addSubview:imgView];
        
        
        
        
    }
    //显示包含内容大小
    self.scrollView.contentSize = CGSizeMake((self.dataSource.count+1)*self.bounds.size.width, self.bounds.size.height);
    
    [self delayScroll];
}

//填充子视图-1
-(void)setImageWithImgArr:(NSArray<UIImage *> *)imgArr{
    
    self.dataSource = [NSMutableArray arrayWithArray:imgArr];
    
    self.pageControl.numberOfPages = self.dataSource.count;
    self.pageControl.currentPage = 0;
    
    for (int i = 0; i< self.dataSource.count+1; i++) {
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        imgView.contentMode = UIViewContentModeScaleToFill;
        
        if(i == self.dataSource.count){
            
            imgView.image = self.dataSource[0];
            
            [self.scrollView addSubview:imgView];
            break;
            //最后一项的特殊处理
        }
        
        imgView.image = self.dataSource[i];
        
        
        
        [self.scrollView addSubview:imgView];
        
        
    }
    //显示包含内容大小
    self.scrollView.contentSize = CGSizeMake((self.dataSource.count+1)*self.bounds.size.width, self.bounds.size.height);
    
    [self delayScroll];
    
    
}



#pragma mark - 组件方法

-(void)delayScroll{
    //延迟执行
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.timer setFireDate:[NSDate distantPast]];
    });
}

-(void)pageing:(UIPageControl *)pgc{
    NSInteger  currentPage = pgc.currentPage;
    ///调整滚动页
    [self.scrollView setContentOffset:CGPointMake(currentPage*_scrollView.bounds.size.width, 0) animated:YES];
}


-(void)timerGo:(NSTimer *)timer{
    NSInteger currentPage = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    //修改滚动视图的偏移量
    [self.scrollView setContentOffset:CGPointMake((currentPage+1) * _scrollView.bounds.size.width, 0) animated:YES];
}

-(void)tap:(UITapGestureRecognizer*)gesture{
    
    NSInteger  index = [self getVisbleIndex];
    [self.delegate tapAtIndex:index];
    
    if (_tapBlock) {
        _tapBlock(index);
    }
}

-(NSInteger)getVisbleIndex{
    NSInteger currentPage = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    NSInteger wholePage = self.scrollView.contentSize.width/self.scrollView.bounds.size.width;
    
    if (wholePage == currentPage+1) {
        currentPage = 0;
    }
    return currentPage;
}

#pragma mark --操作回调

-(void)tapWihtBlock:(void(^)(NSInteger tapIndex))block{
    _tapBlock = block;
}

-(void)scrollWithBlock:(void(^)(NSInteger currentIndex))block{
    _scrollBlock = block;
}

#pragma mark - 控制事件

-(void)start{
    [self.timer setFireDate:[NSDate distantFuture]];
    
}

-(void)stop{
    [self.timer setFireDate:[NSDate distantPast]];
    
}



#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //滚动停止
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSInteger wholePage = scrollView.contentSize.width/scrollView.bounds.size.width;
    
    if (wholePage == currentPage+1) {
        currentPage = 0;
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    self.pageControl.currentPage = currentPage;
    
    [self.delegate scrollToIndex:currentPage];
    
    if (_scrollBlock) {
        _scrollBlock(currentPage);
    }
}

#pragma mark - 懒加载

-(NSMutableArray*)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(UIPageControl*)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width-140, self.bounds.size.height-30, 150, 30)];
        _pageControl.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 15);
        _pageControl.currentPageIndicatorTintColor =[UIColor colorWithWhite:0.7 alpha:0.9];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.1 alpha:0.8];
        [_pageControl addTarget:self action:@selector(pageing:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageControl;
}

-(UIScrollView*)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator =NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}


-(NSTimer*)timer{
    if (_timer == nil) {
        
        __weak typeof(self) weakSelf = self;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollTime target:weakSelf selector:@selector(timerGo:) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
