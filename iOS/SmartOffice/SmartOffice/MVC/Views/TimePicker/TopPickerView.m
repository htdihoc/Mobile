//
//  TopPickerView.m
//  DrawMenu
//
//  Created by NguyenVanTu on 5/11/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import "TopPickerView.h"
#import "NSString+SizeOfString.h"
@interface TopPickerView()
@end
@implementation TopPickerView
@synthesize startTimeLayer = _startTimeLayer;
@synthesize endTimeLayer = _endTimeLayer;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawItemsToView];
}
- (void)drawItemsToView
{
    if (_startTimeLayer == nil) {
        _startTimeLayer = [CustomShapeLayer layer];
        _startTimeLayer.fillColor = CommonColor_Blue.CGColor;
        _startTimeLayer.identifer = @"Left";
        [self.layer addSublayer:_startTimeLayer];
        
        _endTimeLayer = [CustomShapeLayer layer];
        _endTimeLayer.fillColor = AppColor_MainAppTintColor.CGColor;
        _endTimeLayer.identifer = @"Right";
        [self.layer addSublayer:_endTimeLayer];
        
       
        
        CGRect viewBound = self.frame;
        CGFloat piceWidth = viewBound.size.width*0.1f;
        CGFloat piceWidthHalfWidth = piceWidth*0.5;
        CGRect leftBounds = CGRectMake(0, 0, viewBound.size.width/2, viewBound.size.height);
        
        UIBezierPath *leftPath = [UIBezierPath bezierPath];
        [leftPath moveToPoint: CGPointMake(0, 0)];
        [leftPath addLineToPoint: CGPointMake(leftBounds.size.width-piceWidthHalfWidth, 0)];
        [leftPath addLineToPoint: CGPointMake(leftBounds.size.width+piceWidthHalfWidth, leftBounds.size.height/2)];
        [leftPath addLineToPoint: CGPointMake(leftBounds.size.width-piceWidthHalfWidth, leftBounds.size.height)];
        [leftPath addLineToPoint: CGPointMake(0, leftBounds.size.height)];
        [leftPath closePath];
        
        _startTimeLayer.path = leftPath.CGPath;
        
        CGRect rightBounds = CGRectMake(viewBound.size.width/2, 0, viewBound.size.width/2, viewBound.size.height);
        UIBezierPath *rightPath = [UIBezierPath bezierPath];
        [rightPath moveToPoint: CGPointMake(rightBounds.origin.x-piceWidthHalfWidth, 0)];
        [rightPath addLineToPoint: CGPointMake(rightBounds.origin.x + rightBounds.size.width, 0)];
        [rightPath addLineToPoint: CGPointMake(rightBounds.origin.x + rightBounds.size.width, rightBounds.size.height)];
        [rightPath addLineToPoint: CGPointMake(rightBounds.origin.x-piceWidthHalfWidth, rightBounds.size.height)];
        [rightPath addLineToPoint: CGPointMake(rightBounds.origin.x + piceWidthHalfWidth, rightBounds.size.height/2)];
        [rightPath closePath];
        
        _endTimeLayer.path = rightPath.CGPath;
        [self addLabels:piceWidth];
        [self addBottomLayer:leftBounds endTimeLayerRect:rightBounds];
    }
}
- (void)addLabels:(CGFloat)piceWidth
{
    CGFloat margin = 4;
    CGFloat leftMargin = 16;
    CGFloat widthPerLabel = self.frame.size.width/2 - leftMargin;
    CGFloat heightPerLabel = self.frame.size.height/3.5 - margin;
    self.lbl_StartTimeTile = [[CATextLayer alloc] init];
    [self.lbl_StartTimeTile setFontSize:widthPerLabel/13];
    [self setDefaultFor:self.lbl_StartTimeTile frame:CGRectMake(leftMargin, 4*margin, widthPerLabel, heightPerLabel)];
    self.lbl_EndTimeTile = [[CATextLayer alloc] init];
    [self.lbl_EndTimeTile setFontSize:widthPerLabel/13];
    [self setDefaultFor:self.lbl_EndTimeTile frame:CGRectMake(widthPerLabel + piceWidth + leftMargin, 4*margin, widthPerLabel, heightPerLabel)];
    
    self.lbl_StartTimeDay = [[CATextLayer alloc] init];
    [self.lbl_StartTimeDay setFontSize:widthPerLabel/9];
    [self setDefaultFor:self.lbl_StartTimeDay frame:CGRectMake(leftMargin, heightPerLabel + margin, widthPerLabel, heightPerLabel)];
    self.lbl_EndTimeDay = [[CATextLayer alloc] init];
    [self.lbl_EndTimeDay setFontSize:widthPerLabel/9];
    [self setDefaultFor:self.lbl_EndTimeDay frame:CGRectMake(widthPerLabel + piceWidth + leftMargin, heightPerLabel + margin, widthPerLabel, heightPerLabel)];
    
    self.lbl_StartTimeDetail = [[CATextLayer alloc] init];
    [self.lbl_StartTimeDetail setFontSize:widthPerLabel/11];
    [self setDefaultFor:self.lbl_StartTimeDetail frame:CGRectMake(leftMargin, 2*heightPerLabel + margin, widthPerLabel, heightPerLabel)];
    self.lbl_EndTimeDetail = [[CATextLayer alloc] init];
    [self.lbl_EndTimeDetail setFontSize:widthPerLabel/11];
    [self setDefaultFor:self.lbl_EndTimeDetail frame:CGRectMake(widthPerLabel + piceWidth + leftMargin, 2*heightPerLabel + margin, widthPerLabel, heightPerLabel)];
    
    [self setStringToStartDateTitle:LocalizedString(@"TopPickerView_Thời_gian_bắt_đầu")];
    [self setStringToEndDateTitle:LocalizedString(@"TopPickerView_Thời_gian_kết_thúc")];
    
    [self.lbl_StartTimeDay setString:@"dd/mm/yyy"];
    [self.lbl_EndTimeDay setString:@"dd/mm/yyy"];
    
    [self.lbl_StartTimeDetail setString:@"              "];
    [self.lbl_EndTimeDetail setString:@"              "];
    
    [_startTimeLayer addSublayer:self.lbl_StartTimeTile];
    [_startTimeLayer addSublayer:self.lbl_StartTimeDay];
    [_startTimeLayer addSublayer:self.lbl_StartTimeDetail];
    
    [_endTimeLayer addSublayer:self.lbl_EndTimeTile];
    [_endTimeLayer addSublayer:self.lbl_EndTimeDay];
    [_endTimeLayer addSublayer:self.lbl_EndTimeDetail];
    
}
- (void)addLeftImageLayer:(CustomShapeLayer *)layer frameToAdd:(CGRect)rect
{
    self.leftImage = [[CALayer alloc] init];
    [self addImageToLayer:layer subLayer:self.leftImage frameToAdd:rect];
}
- (void)addRightImageLayer:(CustomShapeLayer *)layer frameToAdd:(CGRect)rect
{
    self.rightImage = [[CALayer alloc] init];
    [self addImageToLayer:layer subLayer:self.rightImage frameToAdd:rect];
}
- (void)addImageToLayer:(CustomShapeLayer *)layer subLayer:(CALayer *)subLayer frameToAdd:(CGRect)rect
{
        [subLayer setContents:(id)[UIImage imageNamed:@"whiteCheckList"].CGImage];
        [subLayer setFrame:rect];
        [layer addSublayer:subLayer];
}

- (void)addBottomLayer:(CGRect)startTimeLayerRect endTimeLayerRect:(CGRect)endTimeLayerRect
{
    //change image when ....
    self.leftBottomIcon = [[CALayer alloc] init];
    [self.leftBottomIcon setContents:(id)[UIImage imageNamed:@"triangleDown"].CGImage];
    [self.leftBottomIcon setFrame:CGRectMake(startTimeLayerRect.origin.x + startTimeLayerRect.size.width/2 - 25, startTimeLayerRect.origin.y + startTimeLayerRect.size.height - 15, 25, 15)];
    [_startTimeLayer addSublayer:self.leftBottomIcon];
    

    self.rightBottomIcon = [[CALayer alloc] init];
    [self.rightBottomIcon setContents:(id)[UIImage imageNamed:@"triangleDown"].CGImage];
    [self.rightBottomIcon setFrame:CGRectMake(endTimeLayerRect.origin.x + endTimeLayerRect.size.width/2, endTimeLayerRect.origin.y + endTimeLayerRect.size.height - 15, 25, 15)];
    [self.rightBottomIcon setHidden:YES];
    [_endTimeLayer addSublayer:self.rightBottomIcon];
}
- (void)setDefaultFor:(CATextLayer *)label frame:(CGRect)frame
{
    [label setFont:@"Helvetica"];
    [label setAlignmentMode:kCAAlignmentLeft];
    [label setForegroundColor:[[UIColor whiteColor] CGColor]];
    [label setFrame:frame];
}
- (void)setStringToStartDateTitle:(NSString *)stringToShow
{
    [self setStringForLayer:self.lbl_StartTimeTile string:stringToShow];
}
- (void)setStringToEndDateTitle:(NSString *)stringToShow
{
    [self setStringForLayer:self.lbl_EndTimeTile string:stringToShow];
}
- (void)setStringToStartDate:(NSString *)stringToShow
{
    [self setStringForLayer:self.lbl_StartTimeDay string:stringToShow];
}
- (void)setStringToEndDate:(NSString *)stringToShow
{
    [self setStringForLayer:self.lbl_EndTimeDay string:stringToShow];
}
- (void)setStringToStartDateDetail:(NSString *)stringToShow
{
    if (self.leftImage == nil && ![stringToShow isEqualToString:@""]) {
        CGRect rect =  self.lbl_StartTimeDetail.frame;
        CGFloat widthStartString = [self getWidthText:self.lbl_StartTimeDetail];
        [self addLeftImageLayer:_startTimeLayer frameToAdd:CGRectMake(rect.origin.x +  widthStartString + 25, rect.origin.y + 5, 15, 10)];
    }
    [self setStringForLayer:self.lbl_StartTimeDetail string:stringToShow];
}
- (void)setStringToEndDateDetail:(NSString *)stringToShow
{
    if (self.rightImage && ![stringToShow isEqualToString:@""]) {
        CGRect rect =  self.lbl_EndTimeDetail.frame;
        CGFloat widthEndString = [self getWidthText:self.lbl_EndTimeDetail];
        [self addRightImageLayer:_endTimeLayer frameToAdd:CGRectMake(rect.origin.x +  widthEndString + 25, rect.origin.y + 5, 15, 10)];
    }
    [self setStringForLayer:self.lbl_EndTimeDetail string:stringToShow];
}
- (void)setStringForLayer:(CATextLayer *)textLayer string:(NSString *)string
{
    NSString *stringToShow = string;
    if(string.length > 20)
    {
        stringToShow = [NSString stringWithFormat:@"%@...", [stringToShow substringToIndex:17]];
    }
    [textLayer setString:stringToShow];
}

- (CGFloat)getWidthText:(CATextLayer *)textLayer
{
    UIFont *fontString = [UIFont systemFontOfSize:textLayer.frame.size.width/11];
    NSString *endString = textLayer.string;
    CGFloat widthEndString = [endString widthOfString:fontString];
    return widthEndString;
}
@end
