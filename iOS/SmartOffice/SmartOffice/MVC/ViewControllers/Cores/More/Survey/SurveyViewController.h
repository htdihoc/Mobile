//
//  SurveyViewController.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseVC.h"

@protocol HideViewDelegate <NSObject>

- (void) hidenView;
- (void) showView;
- (void) didselectDelegate:(NSString *)stringUrl;

@end

@interface SurveyViewController : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UILabel *navigation_title;
@property (weak, nonatomic) id<HideViewDelegate> delegate;
@property (nonatomic) BOOL iPad;
@property (assign, nonatomic) NSInteger countSurvey;

@end
