//
//  NSDate+Utilities.h
//  mPOS_iOS
//
//  Created by Cuong Ta on 12/07/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PieLayer;

@interface SOPieChartView : UIView
@property (nonatomic, assign) BOOL centerDisplace;
@end

@interface SOPieChartView (ex)
@property(nonatomic,readonly,retain) PieLayer *layer;

- (void)setupWithHalfPie:(BOOL)isHalfPie maxRadius:(CGFloat)maxRadius minRadius:(CGFloat)minRadius;
@end
