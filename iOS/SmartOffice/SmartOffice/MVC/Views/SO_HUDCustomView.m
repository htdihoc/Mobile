//
//  SO_HUDCustomView.m
//  SmartOffice
//
//  Created by Kaka on 8/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SO_HUDCustomView.h"

@interface SO_HUDCustomView(){
	
}
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@end

@implementation SO_HUDCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
////  CuongTT - override
//hud.mode = MBProgressHUDModeCustomView;
//
//UIView * test_indicator = [UIView new];
//hud.customView = test_indicator;
//
//UIImage * logo_image = [UIImage imageNamed:@"HUD_SO_logo.png"];
//UIImage * loading_image = [UIImage imageNamed:@"HUD_SO_loading.png"];
//
//UIImageView * logo_image_view = [[UIImageView alloc] initWithImage:logo_image];
//UIImageView * loading_image_view = [[UIImageView alloc] initWithImage:loading_image];
//
//[logo_image_view setFrame:CGRectMake(logo_image_view.frame.origin.x
//									 + (loading_image.size.width - logo_image.size.width) / 2
//									 , logo_image_view.frame.origin.y
//									 + (loading_image.size.height - logo_image.size.height) / 2
//									 , logo_image_view.frame.size.width
//									 , logo_image_view.frame.size.height)];
//
//[test_indicator setFrame:CGRectMake(0, 0, loading_image.size.width, loading_image.size.height)];
//
//[test_indicator addSubview:logo_image_view];
//[test_indicator addSubview:loading_image_view];
//
//NSInteger rotations = 2;
//CGFloat duration = 2.0f;
//NSInteger repeat = 120;
//
//CABasicAnimation* rotationAnimation;
//rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
//rotationAnimation.duration = duration;
//rotationAnimation.cumulative = YES;
//rotationAnimation.repeatCount = repeat;
//
//[loading_image_view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//- (id)init
//{
//	self = [super init];
//	if(self){
//		[self setup];
//	}
//	return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//	self = [super initWithCoder:aDecoder];
//	if(self){
//		[self setup];
//	}
//	return self;
//}
//
//- (id)initWithFrame:(CGRect)frame
//{
//	self = [super initWithFrame:frame];
//	if(self){
//		[self setup];
//	}
//	return self;
//}

//#pragma mark - Main
//- (void)setup{
//	//  CuongTT - override
//	UIImage * logo_image = [UIImage imageNamed:@"HUD_SO_logo.png"];
//	UIImage * loading_image = [UIImage imageNamed:@"HUD_SO_loading.png"];
//	
//	
//	//UIImage *logo_image = [[UIImage imageNamed:@"HUD_SO_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//	//UIImage *loading_image = [[UIImage imageNamed:@"HUD_SO_loading"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//	
//	UIImageView * logo_image_view = [[UIImageView alloc] initWithImage:logo_image];
//	UIImageView * loading_image_view = [[UIImageView alloc] initWithImage:loading_image];
//	
//	[logo_image_view setFrame:CGRectMake(logo_image_view.frame.origin.x
//										 + (loading_image.size.width - logo_image.size.width) / 2
//										 , logo_image_view.frame.origin.y
//										 + (loading_image.size.height - logo_image.size.height) / 2
//										 , logo_image_view.frame.size.width
//										 , logo_image_view.frame.size.height)];
//	
//	[self setFrame:CGRectMake(0, 0, loading_image.size.width, loading_image.size.height)];
//	logo_image_view.center = self.center;
//	[self addSubview:logo_image_view];
//	[self addSubview:loading_image_view];
//	
//	//Make animation
//	NSInteger rotations = 2;
//	CGFloat duration = 2.0f;
//	NSInteger repeat = 120;
//	
//	CABasicAnimation* rotationAnimation;
//	rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//	rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
//	rotationAnimation.duration = duration;
//	rotationAnimation.cumulative = YES;
//	rotationAnimation.repeatCount = repeat;
//	
//	[loading_image_view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//	[self setNeedsDisplay];
//}

#pragma mark - init data
- (void)awakeFromNib{
	[super awakeFromNib];
	[self setNeedsDisplay];
	//[self startAnimation];
}

- (void)layoutSubviews{
	[super layoutSubviews];
	[self startAnimation];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	self.backgroundColor = [UIColor clearColor];
	NSString *className = NSStringFromClass([self class]);
	_customConstraints = [[NSMutableArray alloc] init];
	UIView *view = nil;
	NSArray *objects = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
	for (id object in objects) {
		if ([object isKindOfClass:[UIView class]]) {
			view = object;
			break;
		}
	}
	
	if (view != nil) {
		_containerView = view;
		_containerView.backgroundColor = [UIColor clearColor];
		view.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:view];
		[self setNeedsUpdateConstraints];
	}
	
	/* This sample to use custom view
	 NSString *className = NSStringFromClass([self class]);
	 UIView *rootView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
	 rootView.frame = self.bounds;
	 rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
	 [self addSubview:rootView];
	 [self setNeedsUpdateConstraints];
	 */
}

- (void)updateConstraints
{
	[self removeConstraints:self.customConstraints];
	[self.customConstraints removeAllObjects];
	
	if (self.containerView != nil) {
		UIView *view = self.containerView;
		NSDictionary *views = NSDictionaryOfVariableBindings(view);
		
		[self.customConstraints addObjectsFromArray:
		 [NSLayoutConstraint constraintsWithVisualFormat:
		  @"H:|[view]|" options:0 metrics:nil views:views]];
		[self.customConstraints addObjectsFromArray:
		 [NSLayoutConstraint constraintsWithVisualFormat:
		  @"V:|[view]|" options:0 metrics:nil views:views]];
		[self addConstraints:self.customConstraints];
	}
	[super updateConstraints];
	
	//Start animation
	//[self startAnimation];
}

#pragma mark - Main Animation with indicator
- (void)startAnimation{
	
	/* +++ Only use on current visible view
	[UIView animateWithDuration:0.35 delay:0 options: UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
		_imgIndicator.transform = CGAffineTransformRotate(_imgIndicator.transform, M_PI);
	} completion:^(BOOL finished) {
		//[self setNeedsDisplay];
	}];
	*/
	
	[UIView animateWithDuration:0.25
						  delay:0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 
						_imgIndicator.transform = CGAffineTransformMakeRotation(M_PI);
					 }
					 completion:^(BOOL finished){
						 
						 [UIView animateWithDuration:0.25
											   delay:0
											 options:UIViewAnimationOptionCurveLinear
										  animations:^{
											  
											  _imgIndicator.transform = CGAffineTransformMakeRotation(0);
										  }
										  completion:^(BOOL finished){
                                              if (self.stop) {
                                                  return;
                                              }
											 [self startAnimation];
										  }];
						 [self setNeedsDisplay];
					 }];
	//Make animation
	
	//Use this: Simple more smoothly
	/*
	CABasicAnimation *rotation;
	rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rotation.fromValue = [NSNumber numberWithFloat:0];
	rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
	rotation.duration = 0.5; // Speed
	rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
	[_imgIndicator.layer addAnimation:rotation forKey:@"Spin"];
	[self setNeedsDisplay]
	*/
}
@end
