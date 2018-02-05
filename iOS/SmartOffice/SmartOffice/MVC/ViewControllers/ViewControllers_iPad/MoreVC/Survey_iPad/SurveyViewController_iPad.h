//
//  SurveyViewController_iPad.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 8/22/29 H.
//  Copyright © 29 Heisei ITSOL. All rights reserved.
//

#import "PMTC_BaseViewController.h"

@interface SurveyViewController_iPad : PMTC_BaseViewController

@property (weak, nonatomic) IBOutlet UIView *survey_view;
@property (weak, nonatomic) IBOutlet UIView *detail_survey_view;
@property (weak, nonatomic) IBOutlet UIView *viewNoData;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
