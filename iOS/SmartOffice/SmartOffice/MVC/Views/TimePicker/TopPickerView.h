//
//  TopPickerView.h
//  DrawMenu
//
//  Created by NguyenVanTu on 5/11/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomShapeLayer.h"
@interface TopPickerView : UIView
@property(nonatomic, strong) CustomShapeLayer *startTimeLayer;
@property(nonatomic, strong) CustomShapeLayer *endTimeLayer;

@property(nonatomic, strong) CATextLayer *lbl_StartTimeTile;
@property(nonatomic, strong) CATextLayer *lbl_EndTimeTile;

@property(nonatomic, strong) CATextLayer *lbl_StartTimeDay;
@property(nonatomic, strong) CATextLayer *lbl_EndTimeDay;

@property(nonatomic, strong) CATextLayer *lbl_StartTimeDetail;
@property(nonatomic, strong) CATextLayer *lbl_EndTimeDetail;

@property(nonatomic, strong) CALayer *leftBottomIcon;
@property(nonatomic, strong) CALayer *rightBottomIcon;
@property(nonatomic, strong) CALayer *leftImage;
@property(nonatomic, strong) CALayer *rightImage;
- (void)drawItemsToView;
- (void)setStringToStartDateTitle:(NSString *)stringToShow;
- (void)setStringToEndDateTitle:(NSString *)stringToShow;

- (void)setStringToStartDate:(NSString *)stringToShow;
- (void)setStringToEndDate:(NSString *)stringToShow;

- (void)setStringToStartDateDetail:(NSString *)stringToShow;
- (void)setStringToEndDateDetail:(NSString *)stringToShow;
@end
