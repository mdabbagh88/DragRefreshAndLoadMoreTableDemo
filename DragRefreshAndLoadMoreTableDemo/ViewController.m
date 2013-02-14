//
//  ViewController.m
//  LoadMore
//
//  Created by openthread on 2/11/13.
//  Copyright (c) 2013 CannonInc. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+DragLoad.h"

@class FrameObservingView;

@protocol FrameObservingViewDelegate <NSObject>
- (void)frameObservingViewFrameChanged:(FrameObservingView *)view;
@end

@interface FrameObservingView : UIView
@property (nonatomic,assign) id<FrameObservingViewDelegate>delegate;
@end

@implementation FrameObservingView
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.delegate frameObservingViewFrameChanged:self];
}
@end

@interface ViewController ()<UITableViewDragLoadDelegate,UITableViewDataSource,FrameObservingViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation ViewController

- (void)frameObservingViewFrameChanged:(FrameObservingView *)view
{
    _tableView.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FrameObservingView *frameObservingView = [[FrameObservingView alloc] init];
    frameObservingView.delegate = self;
    self.view = frameObservingView;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.frame = CGRectMake(0, 0, 320, 460);
    _tableView.dataSource = self;
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _tableView.shouldShowLoadMoreView = YES;
    [self.view addSubview:_tableView];
}

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    [_tableView performSelector:@selector(finishRefresh) withObject:nil afterDelay:2];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:_tableView selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    [_tableView performSelector:@selector(finishLoadMore) withObject:nil afterDelay:2];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:_tableView selector:@selector(finishLoadMore) object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

@end
