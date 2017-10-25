##简介

![展示图](./show.jpg)

zxcRollingBanner是一个简单的图片广告滚动视图


###下载&使用

1.使用时直接将/ZXCRollingBanner文件夹拖入目标项目工程即可



###初始化方法
```
//视图初始化时必须设置Frame
- (instancetype)initWithFrame:(CGRect)frame;


//直接使用图片数组
-(void)setImageWithImgArr:(NSArray<UIImage *>*)imgArr;

//使用URL数组(该方法必须使用SDWebImage)
-(void)setImageWithUrlArr:(NSArray<NSString *>*)urlArr;


//当前点击的图片回调,与代理方法"-(void)scrollToIndex:(NSInteger)index"作用相同
-(void)tapWihtBlock:(void(^)(NSInteger tapIndex))block;


//当前显示的图片回调,与代理方法"-scrollToIndex:(NSInteger)index"作用相同
-(void)scrollWithBlock:(void(^)(NSInteger currentIndex))block;


//注意:两个block回调方法会和代理方法同时执行,只需实现其中任意即可

```

###代理方法


```
//<zxcAdScrollViewDelegate>


//当前显示图片索引
-(void)scrollToIndex:(NSInteger)index;


//被点击图片索引
-(void)tapAtIndex:(NSInteger)index;


```


###属性

```
//代理属性,若需要获取显示或者点击的索引值需要设置
@property ( nonatomic,weak) id<zxcAdScrollViewDelegate> delegate ;

//占位图
@property ( nonatomic,strong) UIImage * placeholderImage ;


//滚动间隔时长,若不设置默认3秒
@property (nonatomic,assign) NSInteger  rollingInterval;


```



###Demo


```
    NSArray * urlArr = @[@"http://ohvjgcwh9.bkt.clouddn.com/0.jpg",
                         @"http://ohvjgcwh9.bkt.clouddn.com/1.jpg",
                         @"http://ohvjgcwh9.bkt.clouddn.com/2.jpg",
                         @"http://ohvjgcwh9.bkt.clouddn.com/3.jpg"];
    
    
    zxcRollingBanner * sc = [[zxcRollingBanner alloc]initWithFrame:CGRectMake(0, 0,300 , 200)];
    sc.placeholderImage = [UIImage imageNamed:@"placeholder.jpg"];
    
    [sc setImageWithUrlArr:urlArr];
    
    [sc tapWihtBlock:^(NSInteger tapIndex) {
        NSLog(@"点击:%ld",tapIndex);
    }];

    [sc scrollWithBlock:^(NSInteger currentIndex) {
        NSLog(@"当前显示索引:%ld",currentIndex);
    }];

    [self.view addSubview:sc];
    
    


```


###注意

1.项目中重复给ZXCRollingBanner赋值更新图片是直接调用两个设置数据方法即可,方法调用时会自动清除之前数据

2.Demo下载完整后请先执行pod install

3.部分功能依赖于SDWebImage




