//
//  RootViewController.m
//  图片轮播
//
//  Created by huchunyuan on 15/8/21.
//  Copyright (c) 2015年 Lafree. All rights reserved.
//
/** 
    本次运用了管理内存的技术
    加载图片时使用可以释放内存的加载方法
    删除距离观看图片距离为2的图片
    支持暂停 放大 缩小 再次观看时恢复原样
 */
#import "RootViewController.h"
@interface RootViewController ()<UIScrollViewDelegate>
@end
@implementation RootViewController
// 只允许横屏
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
}
// 重写dealloc方法
- (void)dealloc{
    self.scrollView = nil;
    self.timer = nil;
    self.music = nil;
    [super dealloc];
}
// 允许转向
- (BOOL)shouldAutorotate{
    return YES;
}
// 搭建界面
- (void)viewDidLoad {
    [super viewDidLoad];
    // 搭建scrollView界面
    [self layoutScrollView];
    // 添加图片
    [self layoutlitllescroll];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"All Alonge With You.mp3" withExtension:nil];
    _music = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_music prepareToPlay];
    [_music play];
    [self time];
    _firstImage = YES;
}
// 创建基础scrollview
- (void)layoutScrollView{
    // 创建对象
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 736, 414)];
    // 设置属性
    _scrollView.contentSize = CGSizeMake(736 * 20, 414);
    // 设置滚动条风格
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 隐藏垂直滚动条
    _scrollView.showsVerticalScrollIndicator = NO;
    // 设置整屏滑动
    _scrollView.pagingEnabled = YES;
    // 设置代理
    _scrollView.delegate = self;
    // 添加父视图
    [self.view addSubview:_scrollView];
    // 释放所有权
    [_scrollView release];
}
// 动态创建每一张图片所需要的scrollview
- (void)layoutlitllescroll{
    // 循环创建imageView 并添加到scrollView上;
    for (int i = 0; i < 20; i++) {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(736*i, 0, 736, 414)];
        scroll.tag = 100+i;
        scroll.delegate = self;
        scroll.maximumZoomScale = 3;
        scroll.minimumZoomScale = 1;
        scroll.zoomScale = 1;
        [_scrollView addSubview:scroll];
    }
}
// 添加图片方法
- (void)addimage:(NSInteger)count{
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:100+count];
    UIImageView *imageConfirm = (UIImageView *)[self.view viewWithTag:200+count];
    // 如果取出的imagview为空 则创建 否则就不创建
    if (imageConfirm == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 736, 414)];
        // 本地文件用bounld添加图片,imageName会一直把图片保存在内存中
        NSString *str = [NSString stringWithFormat:@"%ld",count+1];
        NSString *path = [[NSBundle mainBundle]pathForResource:str ofType:@"jpg"];
        imageView.image = [UIImage imageWithContentsOfFile:path];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 200+count;
        [scroll addSubview:imageView];
        // 添加轻拍手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
        [imageView addGestureRecognizer:tap];
        [tap release];
        [imageView release];
    }
    UIScrollView *scroll2 = (UIScrollView *)[self.view viewWithTag:100+count+1];
    UIImageView *imageConfirm2 = (UIImageView *)[self.view viewWithTag:200+count+1];
    // 如果取出的imagview为空 则创建 否则就不创建
    if (imageConfirm2 == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 736, 414)];
        // 本地文件用bounld添加图片,imageName会一直把图片保存在内存中
        NSString *str = [NSString stringWithFormat:@"%ld",count+2];
        NSString *path = [[NSBundle mainBundle]pathForResource:str ofType:@"jpg"];
        imageView.image = [UIImage imageWithContentsOfFile:path];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 200+count+1;
        [scroll2 addSubview:imageView];
        // 添加轻拍手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
        [imageView addGestureRecognizer:tap];
        [tap release];
        [imageView release];
    }
    if (count != 0) {
        UIScrollView *scroll3 = (UIScrollView *)[self.view viewWithTag:100+count-1];
        UIImageView *imageConfirm3 = (UIImageView *)[self.view viewWithTag:200+count-1];
        // 如果取出的imagview为空 则创建 否则就不创建
        if (imageConfirm3 == nil) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 736, 414)];
            // 本地文件用bounld添加图片,imageName会一直把图片保存在内存中
            NSString *str = [NSString stringWithFormat:@"%ld",count];
            NSString *path = [[NSBundle mainBundle]pathForResource:str ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 200+count-1;
            [scroll3 addSubview:imageView];
            // 添加轻拍手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
            [imageView addGestureRecognizer:tap];
            [tap release];
            [imageView release];
        }
    }
    
}
// 不显示时删除图片方法
- (void)removeimage:(NSInteger)count{
    if (_count == 0) {
        UIImageView *image1 = (UIImageView *)[self.view viewWithTag:200+18];
        image1.image = nil;
        [image1 removeFromSuperview];
        UIImageView *image2 = (UIImageView *)[self.view viewWithTag:200+19];
        image2.image = nil;
        [image2 removeFromSuperview];
        return;
    }
    if (_count > 1) {
        // 为了保证不看到图片删除 就删掉之前2张前的图片
        UIImageView *image2 = (UIImageView *)[self.view viewWithTag:200+count-2];
        image2.image = nil;
        [image2 removeFromSuperview];
        UIImageView *image3 = (UIImageView *)[self.view viewWithTag:200+count+2];
        image3.image = nil;
        [image3 removeFromSuperview];
        // 当图片归零时删除最后两张
    }
}
// 提交缩放的view
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (_count == 0) {
        UIImageView *imageview = (UIImageView *)[self.view viewWithTag:200+_count];
        return imageview;
    }
    UIImageView *imageview = (UIImageView *)[self.view viewWithTag:200+_count-1];
    return imageview;
}
// 开始缩放
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    // 停止time
    [self removeTime];
    // 再次轻拍时继续time
    _b = YES;
}
// 轻拍手势
- (void)taptap:(UITapGestureRecognizer *)tap{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"继续了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    if (_b) {
        // 继续
        _b = NO;
        alert.message = @"继续";
        [alert show];
        [self time];
    }else{
        // 停止
        _b = YES;
        [self removeTime];
        alert.message = @"停止了";
        [alert show];
        NSLog(@"123");
    }
}
// 自动移动
- (void)move{
    if (_count == 20) {
        _count = 0;
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    // 创建移动动画
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_scrollView setContentOffset:CGPointMake(736*_count, 0)animated:YES];
    [UIView commitAnimations];
    // 添加图片
    [self addimage:_count];
    // 删除距离当前为2的照片
    [self removeimage:_count];
    [self resumeZoom];
    // 计数器加一
    _count++;
}
// 将上一张图片和ScrollView的contentSize恢复大小
- (void)resumeZoom{
    // 当图片等于0时恢复120的大小
    if (_count == 0) {
        UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:120];
        scroll.zoomScale = 1;
    }
    // 恢复大小后 同时也恢复显示内容的size
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:100+_count-1];
    scroll.zoomScale = 1;
    scroll.contentSize = CGSizeMake(736, 414);
    UIScrollView *scroll2 = (UIScrollView *)[self.view viewWithTag:100+_count+1];
    scroll2.zoomScale = 1;
    scroll2.contentSize = CGSizeMake(736, 414);
}
// 计时器
- (void)time{
    // 当count等于0时 先执行一次方法搭建界面
    if (_count == 0) {
        [self move];
    }
    // 计时器 每2秒执行一次move方法
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(move) userInfo:nil repeats:YES];
}
// 停止计时器方法
- (void)removeTime{
    [_timer invalidate];
}
// 当最下层scrollview检测到拖动时 停止time方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTime];
    _b = YES;
}
// 当scrollview结束拖拽
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 计算当前下标
    _count = _scrollView.contentOffset.x/736;
    // 执行move方法加载图片
    [self move];
}
// 内存泄露警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
