//
//  TimerProtectorViewController.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import "TimerProtectorViewController.h"

@interface CountDownView : UIView
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) UILabel *contentLabel;
@end

@implementation CountDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30];
        label.text = @"0";
        [self addSubview:label];
        _contentLabel = label;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
//        [_timer fire];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc is come, timer will be invalidate");
    [_timer invalidate];
    _timer = nil;
}

- (void)timerFire:(NSTimer *)timer
{
    NSInteger count = [_contentLabel.text integerValue];
    count++;
    _contentLabel.text = [NSString stringWithFormat:@"%@", @(count)];
}

@end

@interface TimerProtectorViewController ()

@end

@implementation TimerProtectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CountDownView *v = [[CountDownView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:v];
}

@end
