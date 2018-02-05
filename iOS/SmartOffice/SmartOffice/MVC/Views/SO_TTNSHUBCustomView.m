//
//  SO_HUDCustomView.m
//  SmartOffice
//
//  Created by Kaka on 8/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SO_TTNSHUBCustomView.h"

@interface SO_TTNSHUBCustomView(){
    
}
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@end

@implementation SO_TTNSHUBCustomView
+ (instancetype)sharedInstance
{
    static SO_TTNSHUBCustomView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SO_TTNSHUBCustomView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
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
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [SO_TTNSHUBCustomView sharedInstance].imgIndicator.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.25
                                               delay:0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              
                                              [SO_TTNSHUBCustomView sharedInstance].imgIndicator.transform = CGAffineTransformMakeRotation(0);
                                          }
                                          completion:^(BOOL finished){
                                              if ([SO_TTNSHUBCustomView sharedInstance].stop) {
                                                  return;
                                              }
                                              [[SO_TTNSHUBCustomView sharedInstance] startAnimation];
                                          }];
                         [self setNeedsDisplay];
                     }];
}
@end
