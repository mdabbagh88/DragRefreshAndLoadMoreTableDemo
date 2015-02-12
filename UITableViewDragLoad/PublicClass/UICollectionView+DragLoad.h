//
//  UICollectionView+DragRefreshAndLoad.h
//  LoadMore
//
//  Created by openthread on 2/11/13.
//  Copyright (c) 2013 CannonInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol UICollectionViewDragLoadDelegate <NSObject>

@optional
//Called when table trigger a refresh event.
- (void)dragTableDidTriggerRefresh:(UICollectionView *)collectionView;

//When trigger a load more event, refresh will be canceled. Then this method will be called.
//Cancel operations(Network requests, etc.) related to refresh in this method.
- (void)dragTableRefreshCanceled:(UICollectionView *)collectionView;

//Called when table trigger a load more event.
- (void)dragTableDidTriggerLoadMore:(UICollectionView *)collectionView;

//When trigger a refresh event, load more will be canceled. Then this method will be called.
//Cancel operations(Network requests, etc.) related to load more in this method.
- (void)dragTableLoadMoreCanceled:(UICollectionView *)collectionView;

@end

@interface UICollectionView (DragLoad)

//Get setted `dragDelegate`
@property (nonatomic, readonly) id<UICollectionViewDragLoadDelegate> dragDelegate;

//When `dragDelegate` setted, the refresh header and load more footer will be init magically.
//Set `dragDelegate` to nil will remove refresh header and load more footer.
//Generally, assign a unique `refreshDatePermanentKey` for each dragable UICollectionView. Or UICollectionViews use the same `refreshDatePermanentKey` will share refresh date.
- (void)setDragDelegate:(id<UICollectionViewDragLoadDelegate>)dragDelegate refreshDatePermanentKey:(NSString *)refreshDatePermanentKey;

//If you want to hide refresh view, set this property to `NO`.
@property (nonatomic, assign) IBInspectable BOOL showRefreshView;

//If you want to hide load more view, set this property to `NO`.
@property (nonatomic, assign) IBInspectable BOOL showLoadMoreView;

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

- (void)DL_stopPullToRefresh:(NSInteger)page isOffline:(BOOL)isOffline;

@end

@interface UICollectionView (DragLoadUI)

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
