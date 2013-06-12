//
//  UITableView+DragRefreshAndLoad.h
//  LoadMore
//
//  Created by openthread on 2/11/13.
//  Copyright (c) 2013 CannonInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol UITableViewDragLoadDelegate <NSObject>

@optional
//Called when table trigger a refresh event.
- (void)dragTableDidTriggerRefresh:(UITableView *)tableView;

//When trigger a load more event, refresh will be canceled. Then this method will be called.
//Cancel operations(Network requests, etc.) related to refresh in this method.
- (void)dragTableRefreshCanceled:(UITableView *)tableView;

//Called when table trigger a load more event.
- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView;

//When trigger a refresh event, load more will be canceled. Then this method will be called.
//Cancel operations(Network requests, etc.) related to load more in this method.
- (void)dragTableLoadMoreCanceled:(UITableView *)tableView;

@end

@interface UITableView (DragLoad)

//Get setted `dragDelegate`
@property (nonatomic, readonly) id<UITableViewDragLoadDelegate> dragDelegate;

//When `dragDelegate` setted, the refresh header and load more footer will be init magically.
//Set `dragDelegate` to nil will remove refresh header and load more footer.
//Generally, assign a unique `refreshDatePermanentKey` for each dragable UITableView. Or UITableViews use the same `refreshDatePermanentKey` will share refresh date.
- (void)setDragDelegate:(id<UITableViewDragLoadDelegate>)dragDelegate refreshDatePermanentKey:(NSString *)refreshDatePermanentKey;

//If you want to hide refresh view, set this property to `NO`.
@property (nonatomic, assign) BOOL shouldShowRefreshView;

//If you want to hide load more view, set this property to `NO`.
@property (nonatomic, assign) BOOL shouldShowLoadMoreView;

//Stop refresh programmatically. Will not change the refresh date.
//For typical use, call this when refresh request canceled.
- (void)stopRefresh;

//Finish refresh programmatically.Will change the refresh date.
//For typical use, call this when refresh request completed.
- (void)finishRefresh;

//Stop load more programmatically
- (void)stopLoadMore;

//Finish load more programmatically(Same function with `stopLoadMore` in this ver.)
- (void)finishLoadMore;

//Trigger drag events programmatically
- (void)triggerRefresh;
- (void)triggerLoadMore;

@end
