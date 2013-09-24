#DragRefreshAndLoadMoreTable

Create 'pull down to refresh' and 'pull up to load more' table view with friendly interface.
Under MIT lisence.

Supports iOS4.3 - iOS7, tested in SDK6.1 - SDK7, runtime iOS4.3 - iOS7.0.

#Screen shots

![ScreenShot1](https://raw.github.com/OpenFibers/DragRefreshAndLoadMoreTableDemo/master/ScreenShot/ScreenShot1.png "Drag down to refresh 1")

![ScreenShot2](https://raw.github.com/OpenFibers/DragRefreshAndLoadMoreTableDemo/master/ScreenShot/ScreenShot2.png "Drag down to refresh 2")

![ScreenShot3](https://raw.github.com/OpenFibers/DragRefreshAndLoadMoreTableDemo/master/ScreenShot/ScreenShot3.png "Drag up to load more")

#How to use

1. Copy UITableViewDragLoad folder to your project.
2. \#import "UITableView+DragLoad.h"
3. Init a `UITableView`, then set its `dragDelegate` property, implement methods in `UITableViewDragLoadDelegate`. You should control your own data sources and request in this four callback methods:

```
- (void)dragTableDidTriggerRefresh:(UITableView *)tableView;
- (void)dragTableRefreshCanceled:(UITableView *)tableView;
- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView;
- (void)dragTableLoadMoreCanceled:(UITableView *)tableView;
```

Then Drag it.

#Interface and delegate:

Control data sources and requests in delegate methods.
Control layouts in `DragLoadUI` category methods.
Control header/footer hide or show, stop or trigger load by code in `
DragLoad` category methods.

```
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
@property (nonatomic, assign) BOOL showRefreshView;

//If you want to hide load more view, set this property to `NO`.
@property (nonatomic, assign) BOOL showLoadMoreView;

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

@interface UITableView (DragLoadUI)

//Sub controls
@property (nonatomic, readonly) UIActivityIndicatorView *headerLoadingIndicator;
@property (nonatomic, readonly) UIActivityIndicatorView *footerLoadingIndicator;

@property (nonatomic, readonly) UILabel *headerLoadingStatusLabel;
@property (nonatomic, readonly) UILabel *headerRefreshDateLabel;
@property (nonatomic, readonly) UILabel *footerLoadingStatusLabel;

@property (nonatomic, readonly) UIView *headerBackgroundView;
@property (nonatomic, readonly) UIView *footerBackgroundView;

//Texts
@property (nonatomic, retain) NSString *headerPullDownText;//Default is "Pull down to refresh..."
@property (nonatomic, retain) NSString *headerReleaseText;//Default is "Release to refresh..."
@property (nonatomic, retain) NSString *headerLoadingText;//Default is "Loading..."

@property (nonatomic, retain) NSString *footerPullUpText;//Default is "Pull up to load more..."
@property (nonatomic, retain) NSString *footerReleaseText;//Default is "Release to load more..."
@property (nonatomic, retain) NSString *footerLoadingText;//Default is "Loading..."

@property (nonatomic, retain) NSString *headerDateFormatText;//Default is "MM/dd/yyyy hh:mm:a"
@property (nonatomic, retain) NSString *headerRefreshDateFormatText;//Default is "Last Updated: %@"

@end

```