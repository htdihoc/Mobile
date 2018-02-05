//
//  AbsentInfo.h
//  ChartsDemo
//
//  Created by NguyenVanTu on 4/13/17.
//  Copyright © 2017 dcg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseChartViewController.h"
#import <Charts/Charts.h>
#import "TTNS_CheckPointModel.h"
@protocol AbsentInfoDelegate
- (void)didDissmissView;
- (TTNS_CheckPointModel *)getCheckPoint;
@end
@interface AbsentInfo : UIViewController
@property (nonatomic, weak, nullable) id <AbsentInfoDelegate> absentViewDelegate;
@end
