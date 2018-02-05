//
//  NSDate+Utilities.h
//  mPOS_iOS
//
//  Created by Cuong Ta on 12/07/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//


#import "SOPieChartView.h"
#import "MagicPieLayer.h"

@interface SOPieChartView () {
    NSInteger selectedIdx;
}
@end

@implementation SOPieChartView

+ (Class)layerClass
{
    return [PieLayer class];
}

- (id)init
{
    self = [super init];
    if(self){
        //[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        //[self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //[self setup];
    }
    return self;
}

- (void)setupWithHalfPie:(BOOL)isHalfPie maxRadius:(CGFloat)maxRadius minRadius:(CGFloat)minRadius
{
    self.layer.maxRadius = maxRadius;
    self.layer.minRadius = minRadius;
    self.layer.animationDuration = 0.6;
    if (isHalfPie) {
        self.layer.startAngle = 0;
        self.layer.endAngle = 180;
    }else{
        self.layer.startAngle = 0;
        self.layer.endAngle = 360;
    }

    self.layer.showTitles = ShowTitlesIfEnable;
    if ([self.layer.self respondsToSelector:@selector(setContentsScale:)])
    {
        //self.layer.contentsScale = [[UIScreen mainScreen] scale];
    }
    
    
    //UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //tap.numberOfTapsRequired = 1;
    //tap.numberOfTouchesRequired = 1;
    //[self addGestureRecognizer:tap];
}

- (void)setCenterDisplace:(BOOL)centerDisplace {
    _centerDisplace = centerDisplace;
    
    [self animateChanges];
}

- (void)handleTap:(UITapGestureRecognizer*)tap
{
    if(tap.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint pos = [tap locationInView:tap.view];
    PieElement* tappedElem = [self.layer pieElemInPoint:pos];
    if(!tappedElem)
        return;
    NSInteger newIdx = [self.layer.values indexOfObject:tappedElem];
    if (newIdx == selectedIdx) {
        selectedIdx = NSNotFound;
    } else {
        selectedIdx = newIdx;
    }
    
    [self animateChanges];
}

- (void)animateChanges
{
    [PieElement animateChanges:^{
        NSInteger i = 0;
        for(PieElement* elem in self.layer.values){
            elem.centrOffset = (i==selectedIdx && _centerDisplace) ? 20 : 0;
            elem.maxRadius = (i==selectedIdx && !_centerDisplace) ? @(120) : nil;
            i++;
        }
    }];
}

@end
