//
//  DragRefreshTableFooterView_ot.h
//  LoadMore
//
//  Created by openthread on 2/12/13.
//  Copyright (c) 2013 CannonInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define LOADMORE_TRIGGER_HEIGHT              (44.0f)

@class DragTableFooterView_ot;

@protocol DragTableFooterDelegate_ot

- (void)dragTableFooterDidTriggerLoadMore:(DragTableFooterView_ot*)view;

@end

@interface DragTableFooterView_ot : UIView

@property (nonatomic,assign) NSObject<DragTableFooterDelegate_ot> *delegate;
@property (nonatomic,readonly) BOOL isLoading;

- (void)dragTableDidScroll:(UIScrollView *)scrollView;
- (void)dragTableDidEndDragging:(UIScrollView *)scrollView;

- (void)triggerLoading:(UIScrollView *)scrollView;
- (void)endLoading:(UIScrollView *)scrollView shouldChangeContentInset:(BOOL)shouldChangeContentInset;

@end
