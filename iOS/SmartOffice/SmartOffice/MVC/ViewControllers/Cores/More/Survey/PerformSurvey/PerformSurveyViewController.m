//
//  PerformSurveyViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "PerformSurveyViewController.h"
#import "Reachability.h"
#import "Common.h"

@interface PerformSurveyViewController () <TTNS_BaseNavViewDelegate>

@property (nonatomic) BOOL wasLoaded;

@end

@implementation PerformSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.errLoadWebView.hidden = YES;
//    self.refressBtn.layer.cornerRadius = 8; // this value vary as per your desire
//    self.refressBtn.clipsToBounds = YES;
//    self.viewRefressBtn.layer.cornerRadius = 8; // this value vary as per your desire
//    self.viewRefressBtn.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:234.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    self.backTitle = LocalizedString(@"KMORE_PERFORM_SURVEY");
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
//        [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối mạng" inView: self.view];
        self.viewNoNetWork.hidden = NO;
        self.webView.hidden = YES;
    } else {
        self.webView.hidden = NO;
        self.viewNoNetWork.hidden = YES;
        NSURL *url = [NSURL URLWithString:_stringURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:urlRequest];
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.frame = CGRectMake(0, 0, 160, 160);
        CGPoint superCenter = CGPointMake(CGRectGetMidX([self.webView bounds]), CGRectGetMidY([self.webView bounds]));
        [_activityIndicator setCenter:superCenter];
        [self.webView addSubview:_activityIndicator];
        self.webView.delegate = self;
        [self.activityIndicator startAnimating];
    }
    
}

#pragma mark - UIWebViewDelegate Protocol Methods

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
//    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.activityIndicator stopAnimating];
    self.errLoadWebView.hidden = NO;
    self.errLoadWebView.text = @"Dữ liệu bị lỗi";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)refressDataAction:(id)sender {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        //        [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối mạng" inView: self.view];
        self.viewNoNetWork.hidden = NO;
    } else {
        self.viewNoNetWork.hidden = YES;
        NSURL *url = [NSURL URLWithString:_stringURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:urlRequest];
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.frame = CGRectMake(0, 0, 160, 160);
        CGPoint superCenter = CGPointMake(CGRectGetMidX([self.webView bounds]), CGRectGetMidY([self.webView bounds]));
        [_activityIndicator setCenter:superCenter];
        [self.webView addSubview:_activityIndicator];
        self.webView.delegate = self;
        [self.activityIndicator startAnimating];
    }
}

@end
