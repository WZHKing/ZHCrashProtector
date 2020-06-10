//
//  ViewController.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import "ViewController.h"
#import "TimerProtectorViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *titles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        [self timerProtectorTest];
    } else if (row == 1) {
        [self selectorProtectorTest];
    } else if (row == 2) {
        [self subThreadUIProtectorTest];
    } else {
        [self containerProtectorTest];
    }
}

#pragma mark - private methods
- (void)timerProtectorTest
{
    TimerProtectorViewController *vc = [[TimerProtectorViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectorProtectorTest
{
    //instance sel protector
    [self performSelector:NSSelectorFromString(@"instanceProtector")];
    
    //class sel protector
    [UIViewController performSelector:NSSelectorFromString(@"classProtector")];
}

- (void)subThreadUIProtectorTest
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
        self.tableView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50);
    });
}

- (void)containerProtectorTest
{
    NSString *d = nil;
    @[@"a", @"b", @"c", d];
    
    NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:@{@(1):@(1), @(2):@(2)}];
    [mudic removeObjectForKey:d];
    [mudic setObject:d forKey:@"3"];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (NSArray *)titles
{
    if (_titles == nil) {
        _titles = @[@"TimerProtector", @"SelectorProtector",
                    @"SubThreadUIProtector", @"ContainerProtector"];
    }
    return _titles;
}
@end
