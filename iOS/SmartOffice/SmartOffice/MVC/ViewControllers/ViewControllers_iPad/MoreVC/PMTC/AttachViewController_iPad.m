//
//  AttachViewController_iPad.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 8/8/29 H.
//  Copyright © 29 Heisei ITSOL. All rights reserved.
//

#import "AttachViewController_iPad.h"
#import "PMTC_SendInvoiceViewController_iPad.h"


@interface AttachViewController_iPad ()

@property (strong, nonatomic) PMTC_SendInvoiceViewController_iPad *sendbill;

@end

@implementation AttachViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewController];
    self.buttonSendInvoice.backgroundColor = AppColor_MainAppTintColor;
}

- (void) addViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PMTC_SendInvoiceViewController_iPad" bundle:nil];
    self.sendbill = (PMTC_SendInvoiceViewController_iPad *)[storyboard instantiateViewControllerWithIdentifier:@"PMTC_SendInvoiceViewController_iPad"];
    self.sendbill.widthCollection = self.widthCollection;
    self.sendbill.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
    [self addChildViewController:self.sendbill];
    [self.view addSubview:self.sendbill.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)cancelAction:(id)sender {
    self.view.hidden = YES;
}

- (IBAction)sendbillAction:(id)sender {
    
}

@end
