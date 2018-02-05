//
//  JTCalendarMenuView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMenuView.h"

#import "JTCalendarManager.h"

typedef NS_ENUM(NSInteger, JTCalendarPageMode) {
    JTCalendarPageModeFull,
    JTCalendarPageModeCenter,
    JTCalendarPageModeCenterLeft,
    JTCalendarPageModeCenterRight
};

@interface JTCalendarMenuView (){
    CGSize _lastSize;
    
    UIView *_leftView;
    UIView *_centerView;
    UIView *_rightView;
    
    JTCalendarPageMode _pageMode;
}

@end

@implementation JTCalendarMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.clipsToBounds = YES;
    
    _contentRatio = 1.;
    
    {
        _scrollView = [UIScrollView new];
        [self addSubview:_scrollView];
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
        _scrollView.clipsToBounds = NO;
    }
    
    self.btn_Next = [[CalendarButtonController alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 0, 50, 50)];
    [self.btn_Next addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_Next.stateCalenderButton = kNext;
    [self.btn_Next setImage:[UIImage imageNamed:@"icon_blueForward"] forState:UIControlStateNormal];
    [self addSubview:self.btn_Next];
    
    //addLayout
    self.btn_Next.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.btn_Next attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:90];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.btn_Next attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.btn_Next attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.btn_Next attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    [self addConstraints:@[left, top, height, width]];
    
    
    
    self.btn_Back = [[CalendarButtonController alloc] initWithFrame:CGRectMake(20, 0, 50, 50)];
    [self.btn_Back addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_Back.stateCalenderButton = kBack;
    [self.btn_Back setImage:[UIImage imageNamed:@"icon_blueBack"] forState:UIControlStateNormal];
    [self addSubview:self.btn_Back];
    
    //addLayout
    self.btn_Back.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *leftBackButton = [NSLayoutConstraint constraintWithItem:self.btn_Back attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-90];
    NSLayoutConstraint *topBackButton = [NSLayoutConstraint constraintWithItem:self.btn_Back attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *heightBackButton = [NSLayoutConstraint constraintWithItem:self.btn_Back attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    NSLayoutConstraint *widthBackButton = [NSLayoutConstraint constraintWithItem:self.btn_Back attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    [self addConstraints:@[leftBackButton, topBackButton, heightBackButton, widthBackButton]];
}
- (void) action:(CalendarButtonController *) sender {
    [sender setSelected:true];
    switch (sender.stateCalenderButton) {
        case kNext:
            [self.manager.delegate calendarLoadNextPage];
            break;
        default:
            [self.manager.delegate calendarLoadPreviousPage];
            break;
    }
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resizeViewsIfWidthChanged];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_scrollView.contentSize.width <= 0){
        return;
    }

    [_manager.scrollManager updateHorizontalContentOffset:(_scrollView.contentOffset.x / _scrollView.contentSize.width)];
}

- (void)resizeViewsIfWidthChanged
{
    CGSize size = self.frame.size;
    if(size.width != _lastSize.width){
        _lastSize = size;
        
        [self repositionViews];
    }
    else if(size.height != _lastSize.height){
        _lastSize = size;
        
        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, 0, _scrollView.frame.size.width, size.height);
        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, size.height);
        
        _leftView.frame = CGRectMake(_leftView.frame.origin.x, 0, _scrollView.frame.size.width, size.height);
        _centerView.frame = CGRectMake(_centerView.frame.origin.x, 0, _scrollView.frame.size.width, size.height);
        _rightView.frame = CGRectMake(_rightView.frame.origin.x, 0, _scrollView.frame.size.width, size.height);
    }
}

- (void)repositionViews
{
    // Avoid vertical scrolling when the view is in a UINavigationController
    _scrollView.contentInset = UIEdgeInsetsZero;
    
    {
        CGFloat width = self.frame.size.width * _contentRatio;
        CGFloat x = (self.frame.size.width - width) / 2.;
        CGFloat height = self.frame.size.height;
        
        _scrollView.frame = CGRectMake(x, 0, width, height);
        _scrollView.contentSize = CGSizeMake(width, height);
    }
    
    CGSize size = _scrollView.frame.size;
    
    switch (_pageMode) {
        case JTCalendarPageModeFull:
            _scrollView.contentSize = CGSizeMake(size.width * 3, size.height);
            
            _leftView.frame = CGRectMake(0, 0, size.width, size.height);
            _centerView.frame = CGRectMake(size.width, 0, size.width, size.height);
            _rightView.frame = CGRectMake(size.width * 2, 0, size.width, size.height);
            
            _scrollView.contentOffset = CGPointMake(size.width, 0);
            break;
        case JTCalendarPageModeCenter:
            _scrollView.contentSize = size;
            
            _leftView.frame = CGRectMake(- size.width, 0, size.width, size.height);
            _centerView.frame = CGRectMake(0, 0, size.width, size.height);
            _rightView.frame = CGRectMake(size.width, 0, size.width, size.height);
            
            _scrollView.contentOffset = CGPointZero;
            break;
        case JTCalendarPageModeCenterLeft:
            _scrollView.contentSize = CGSizeMake(size.width * 2, size.height);
            
            _leftView.frame = CGRectMake(0, 0, size.width, size.height);
            _centerView.frame = CGRectMake(size.width, 0, size.width, size.height);
            _rightView.frame = CGRectMake(size.width * 2, 0, size.width, size.height);
            
            _scrollView.contentOffset = CGPointMake(size.width, 0);
            break;
        case JTCalendarPageModeCenterRight:
            _scrollView.contentSize = CGSizeMake(size.width * 2, size.height);
            
            _leftView.frame = CGRectMake(- size.width, 0, size.width, size.height);
            _centerView.frame = CGRectMake(0, 0, size.width, size.height);
            _rightView.frame = CGRectMake(size.width, 0, size.width, size.height);
            
            _scrollView.contentOffset = CGPointZero;
            break;
    }
}

- (void)setPreviousDate:(NSDate *)previousDate
            currentDate:(NSDate *)currentDate
               nextDate:(NSDate *)nextDate
{
    NSAssert(currentDate != nil, @"currentDate cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    if(!_leftView){
        _leftView = [_manager.delegateManager buildMenuItemView];
        [_scrollView addSubview:_leftView];
        
        _centerView = [_manager.delegateManager buildMenuItemView];
        [_scrollView addSubview:_centerView];
        
        _rightView = [_manager.delegateManager buildMenuItemView];
        [_scrollView addSubview:_rightView];
    }
    
    [_manager.delegateManager prepareMenuItemView:_leftView date:previousDate];
    [_manager.delegateManager prepareMenuItemView:_centerView date:currentDate];
    [_manager.delegateManager prepareMenuItemView:_rightView date:nextDate];
    
    BOOL haveLeftPage = [_manager.delegateManager canDisplayPageWithDate:previousDate];
    BOOL haveRightPage = [_manager.delegateManager canDisplayPageWithDate:nextDate];
        
    if(_manager.settings.pageViewHideWhenPossible){
        _leftView.hidden = !haveLeftPage;
        _rightView.hidden = !haveRightPage;
    }
    else{
        _leftView.hidden = NO;
        _rightView.hidden = NO;
    }
}

- (void)updatePageMode:(NSUInteger)pageMode
{
    if(_pageMode == pageMode){
        return;
    }
    
    _pageMode = pageMode;
    [self repositionViews];
}

@end
