//
//  DragTableHeaderView_ot.m
//
//  Created by openthread on 02/13/13
//

#import "DragTableHeaderView_ot.h"
#import "DragTableDragState_ot.h"

#define TEXT_COLOR                          [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION             (0.18f)
#define DATE_PERMANENT_STORAGE_KEY_PREFIX   @"DragRefreshTableHeaderView_ot_LastRefresh"

@implementation DragTableHeaderView_ot
{
	DragTableDragState_ot _state;
    BOOL _isLoading;
    NSString *_datePermanentStorageKey;
    NSDate *_lastUpdateDate;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}
@synthesize isLoading = _isLoading;

#pragma mark - UIs
- (UILabel *)loadingStatusLabel
{
    return _statusLabel;
}

- (UILabel *)refreshDateLabel
{
    return _lastUpdatedLabel;
}

- (UIView *)loadingIndicator
{
    return _activityView;
}

#pragma mark - Events

- (id)initWithFrame:(CGRect)frame datePermanentStoreKey:(NSString *)datePermanentStoreKey
{
    if (self = [super initWithFrame:frame])
    {
        _isLoading = NO;
        _datePermanentStorageKey = [DATE_PERMANENT_STORAGE_KEY_PREFIX stringByAppendingString:datePermanentStoreKey];
        _lastUpdateDate = [self getStoredRefreshDate];
        self.shouldShowDate = YES;
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];

        _lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		_lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		_lastUpdatedLabel.textColor = TEXT_COLOR;
		_lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_lastUpdatedLabel.backgroundColor = [UIColor clearColor];
        _lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_lastUpdatedLabel];
		
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor = TEXT_COLOR;
		_statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_statusLabel];
		
        _arrowImage = [CALayer layer];
		_arrowImage.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		_arrowImage.contentsGravity = kCAGravityResizeAspect;
		_arrowImage.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
        _arrowImage.contentsScale = [[UIScreen mainScreen] scale];
		[[self layer] addSublayer:_arrowImage];
		
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:_activityView];
		
		[self setState:DragTableDragStateNormal_ot];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _lastUpdatedLabel.frame = CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f);
    _statusLabel.frame = CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f);
    _arrowImage.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
    _activityView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate
{
	if (self.shouldShowDate)
    {
        if (_lastUpdateDate)
        {
            _lastUpdatedLabel.text = [DragTableHeaderView_ot stringFromDate:_lastUpdateDate];
            [self storeRefreshDate:_lastUpdateDate];
        }
	}
    else
    {
		_lastUpdatedLabel.text = nil;
	}
}

- (void)setState:(DragTableDragState_ot)aState
{
	switch (aState)
    {
		case DragTableDragStatePulling_ot:
        {
			_statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
        }
			break;
		case DragTableDragStateNormal_ot:
        {
			if (_state == DragTableDragStatePulling_ot)
            {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			_statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			[self refreshLastUpdatedDate];
        }
			break;   
		case DragTableDragStateLoading_ot:
        {
			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
        }
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)dragTableDidScroll:(UIScrollView *)scrollView
{
    if (_state != DragTableDragStateLoading_ot && scrollView.isDragging)
    {
		BOOL _loading = _isLoading;
		if (_state == DragTableDragStatePulling_ot && scrollView.contentOffset.y > REFRESH_TRIGGER_HEIGHT && scrollView.contentOffset.y < 0.0f && !_loading)
        {
			[self setState:DragTableDragStateNormal_ot];
		}
        else if (_state == DragTableDragStateNormal_ot && scrollView.contentOffset.y < REFRESH_TRIGGER_HEIGHT && !_loading)
        {
			[self setState:DragTableDragStatePulling_ot];
		}
	}
}

- (void)dragTableDidEndDragging:(UIScrollView *)scrollView
{
	BOOL _loading = _isLoading;
	if (scrollView.contentOffset.y <= REFRESH_TRIGGER_HEIGHT && !_loading)
    {
		if ([_delegate respondsToSelector:@selector(dragTableHeaderDidTriggerRefresh:)])
        {
			[_delegate dragTableHeaderDidTriggerRefresh:self];
            _isLoading = YES;
		}
		[self setState:DragTableDragStateLoading_ot];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		scrollView.contentInset = UIEdgeInsetsMake(-REFRESH_TRIGGER_HEIGHT, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)triggerLoading:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, REFRESH_TRIGGER_HEIGHT)];
    [self dragTableDidEndDragging:scrollView];
}

//Prevent animation conflict when loadmore triggerd. Pass `NO` to `shouldChangeContentInset` when loadmore triggered.
- (void)endLoading:(UIScrollView *)scrollView shouldUpdateRefreshDate:(BOOL)shouldUpdate shouldChangeContentInset:(BOOL)shouldChangeContentInset
{
    if (_isLoading)
    {
        if (shouldChangeContentInset)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            [UIView commitAnimations];
        }
        
        _isLoading = NO;
    }

    if (shouldUpdate)
    {
        _lastUpdateDate = [NSDate date];
    }
	[self setState:DragTableDragStateNormal_ot];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
    return [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
}

- (NSDate *)getStoredRefreshDate
{
    if (!_datePermanentStorageKey)
    {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:_datePermanentStorageKey];
}

- (BOOL)storeRefreshDate:(NSDate *)date
{
    if (!_datePermanentStorageKey)
    {
        return NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:_datePermanentStorageKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
