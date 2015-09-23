//
//  RootViewController.h
//  图片轮播
//
//  Created by huchunyuan on 15/8/21.
//  Copyright (c) 2015年 Lafree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface RootViewController : UIViewController
@property (nonatomic,retain)UIScrollView *scrollView;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,retain)NSTimer *timer;
@property (nonatomic,assign)BOOL b;
@property (nonatomic,strong)AVAudioPlayer *music;
@property (nonatomic,assign)BOOL firstImage;
@end
