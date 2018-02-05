//
//  QLTT_PreviewVC.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_PreviewVC.h"
#import "NSException+Custom.h"
#import "NSString+Util.h"
#import "ZoomRotatePanImageView.h"
#import "UIView+BorderView.h"
#import <AVFoundation/AVFoundation.h>
@interface QLTT_PreviewVC () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *img_View;
@property (strong, nonatomic) AVAudioPlayer *player;
@end

@implementation QLTT_PreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.img_View setBorderForView];
    [self.webView setBorderForView];
    self.backTitle = LocalizedString(@"QLTT_PreviewVC");
    self.webView.scalesPageToFit = YES;
    [self addNavView];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML='';"];
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
    [self.webView setDelegate:nil];
    [self.webView loadData:[NSData new] MIMEType:@"" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
    [self.webView removeFromSuperview];
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    [self.player pause];
    NSError *error;
    self.player=[[AVAudioPlayer alloc] initWithData:[NSData new] error:&error];
    self.player = nil;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    DLog(@"didFinish:");
    [self dismissHub];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"didFail:");
    [self dismissHub];
    [self handleErrorFromResult:nil withException:[NSException initWithString:LocalizedString(@"Không mở được tài liệu")] inView:self.view];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *mymeType = [self.fileType mimeTypeForFileAtPath];
    if ([[mymeType componentsSeparatedByString:@"/"].firstObject isEqualToString:@"image"]) {
        [self.img_View setHidden:NO];
        [self.webView setHidden:YES];
        
        for(UIView *subView in self.img_View.subviews)
        {
            [subView removeFromSuperview];
        }
        
        ZoomRotatePanImageView *imgV = [[ZoomRotatePanImageView alloc] initWithFrame:self.img_View.frame];
        imgV.image = [UIImage imageWithData:self.dataToShow];
        [self addView:imgV toView:self.img_View];
        
    }
    if ([[mymeType componentsSeparatedByString:@"/"].firstObject isEqualToString:@"audio"] || [[mymeType componentsSeparatedByString:@"/"].firstObject isEqualToString:@"video"])
    {
        NSError *error;
        self.player=[[AVAudioPlayer alloc] initWithData:self.dataToShow error:&error];
        
        
        if (error)
            [self handleErrorFromResult:nil withException:[NSException initWithString:LocalizedString(@"Không mở được tài liệu")] inView:self.view];
        else
        {
            [self.player play];
        }
        
    }
    else
    {
        [self.webView setHidden:NO];
        [self.img_View setHidden:YES];
        self.webView.delegate = self;
        [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        [self.webView loadData:self.dataToShow
                      MIMEType:[self.fileType mimeTypeForFileAtPath]
              textEncodingName:@""
                       baseURL:[NSURL URLWithString:@""]];
    }
    
}


- (NSString *)mimeTypeForData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            return @"image/tiff";
            break;
        case 0x25:
            return @"application/pdf";
            break;
        case 0xD0:
            return @"application/vnd";
            break;
        case 0x46:
            return @"text/plain";
            break;
        default:
            return @"application/octet-stream";
    }
    return nil;
}
@end
