//
//  PerformSurveyViewController.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseVC.h"

@interface PerformSurveyViewController : TTNS_BaseVC<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *navigation_title;
@property (strong, nonatomic) NSString *stringURL;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errLoadWebView;
@property (weak, nonatomic) IBOutlet UIButton *refressBtn;
@property (weak, nonatomic) IBOutlet UIView *viewRefressBtn;
@property (weak, nonatomic) IBOutlet UIView *viewNoNetWork;

@end
