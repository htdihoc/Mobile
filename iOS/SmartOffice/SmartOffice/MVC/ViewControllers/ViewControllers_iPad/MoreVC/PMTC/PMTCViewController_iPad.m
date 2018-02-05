//
//  PMTCViewController_iPad.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 7/6/29 H.
//  Copyright © 29 Heisei ITSOL. All rights reserved.
//

#import "PMTCViewController_iPad.h"
#import "PMTCViewController.h"
#import "AttachedCell.h"
#import "AttachViewController_iPad.h"
#import "PMTCInvoiceListViewController_iPad.h"

@interface PMTCViewController_iPad () <UITableViewDataSource, UITableViewDelegate, TTNS_BaseNavViewDelegate>

@property (strong, nonatomic) AttachViewController_iPad *attach;
@property (strong, nonatomic) PMTCViewController *pmtc;

@end

@implementation PMTCViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCreditView];
    [self addAttachView];
    self.VOffice_buttonTitles = @[@"Phần mềm tài chính"];
    self.disableBackIcon = YES;
}

- (void) addCreditView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PMTC" bundle:nil];
    self.pmtc = (PMTCViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PMTCViewController"];
    self.pmtc.view.frame = CGRectMake(0, -45, self.view_credit_info.frame.size.width, self.view_credit_info.frame.size.height);
    [self.pmtc.segmented_view setHidden:YES];
    [self addChildViewController:self.pmtc];
    self.pmtc.constrain_height_segment.constant = 0;
    [self.view_credit_info addSubview:self.pmtc.view];
}

- (void) addAttachView {
    self.image_attach_pmtc = [NSMutableArray arrayWithObjects:@"send_Invoice", @"attach_Voucher", nil];
    self.title_attach_pmtc = [NSMutableArray arrayWithObjects:LocalizedString(@"PMTC_SEND_INVOICE"), LocalizedString(@"PMTC_ATTACH_VOUCHER"), nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"attachedCell";
    AttachedCell *attachedCell = (AttachedCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (attachedCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachedCell" owner:self options:nil];
        attachedCell = [nib objectAtIndex:0];
    }
    attachedCell.title_attach.text = [self.title_attach_pmtc objectAtIndex:indexPath.row];
    attachedCell.image_attach.image = [UIImage imageNamed:self.image_attach_pmtc[indexPath.row]];
    [attachedCell.image_attach sizeToFit];
    attachedCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return attachedCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self addAttachViewController];
            break;
        case 1:
            [self addInvoiceList];
            break;
        default:
            break;
    }
}

- (void)addAttachViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AttachViewController_iPad" bundle:nil];
    self.attach = (AttachViewController_iPad *)[storyboard instantiateViewControllerWithIdentifier:@"AttachViewController_iPad"];
    self.attach.widthCollection = self.view_attach.frame.size.width;
    self.attach.view.frame = CGRectMake(0, 0, self.view_attach.frame.size.width, self.view_attach.frame.size.height);
    [self addChildViewController:self.attach];
    [self.view_attach addSubview:self.attach.view];
}

- (void)addInvoiceList {
    PMTCInvoiceListViewController_iPad *vc = NEW_VC_FROM_STORYBOARD(@"PMTCInvoiceListViewController_iPad", @"PMTCInvoiceListViewController_iPad");
    [self.navigationController pushViewController:vc animated:YES];
}

@end
