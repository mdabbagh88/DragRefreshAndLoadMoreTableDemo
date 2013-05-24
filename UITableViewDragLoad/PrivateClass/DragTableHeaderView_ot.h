//
//  DragTableHeaderView_ot.h
//
//  Created by openthread on 02/13/13
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define REFRESH_TRIGGER_HEIGHT              (-60.0f)

@class DragTableHeaderView_ot;

@protocol DragTableHeaderDelegate_ot

- (void)dragTableHeaderDidTriggerRefresh:(DragTableHeaderView_ot*)view;

@end

@interface DragTableHeaderView_ot : UIView

- (id)initWithFrame:(CGRect)frame datePermanentStoreKey:(NSString *)datePermanentStoreKey;

@property (nonatomic,assign) NSObject<DragTableHeaderDelegate_ot> *delegate;
@property (nonatomic,readonly) BOOL isLoading;
@property (nonatomic,assign) BOOL shouldShowDate;

- (void)dragTableDidScroll:(UIScrollView *)scrollView;
- (void)dragTableDidEndDragging:(UIScrollView *)scrollView;

- (void)triggerLoading:(UIScrollView *)scrollView;

//Prevent animation conflict when loadmore triggerd. Pass `NO` to `shouldChangeContentInset` when loadmore triggered.
- (void)endLoading:(UIScrollView *)scrollView shouldUpdateRefreshDate:(BOOL)shouldUpdate shouldChangeContentInset:(BOOL)shouldChangeContentInset;

@end
