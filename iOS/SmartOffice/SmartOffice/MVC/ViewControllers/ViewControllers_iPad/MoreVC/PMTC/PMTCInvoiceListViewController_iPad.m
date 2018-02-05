//
//  PMTCInvoiceListViewController_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 9/27/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "PMTCInvoiceListViewController_iPad.h"
#import "PMTC_AttachedDocument_VC.h"
#import "PMTC_DetailAttached_VC.h"
#import "DocumentTypeListViewController_iPad.h"
#import "PMTC_ListDocumentViewController_iPad.h"
#import "PMTCProcessor.h"
#import "DocumentTypeListModel.h"
#import "SOErrorView.h"
#import "Common.h"

@interface PMTCInvoiceListViewController_iPad () <SOErrorViewDelegate> {
    
    SOErrorView *_errorView;
    NSMutableArray *documentType;
    DocumentTypeListModel *typeListModel;
}
@property (strong, nonatomic) NSArray *data_PMTC;
@property (strong, nonatomic) DocumentTypeListViewController_iPad *documentTypeList;
@property (strong, nonatomic) PMTC_ListDocumentViewController_iPad *documentAttachList;

@end

@implementation PMTCInvoiceListViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    documentType = [NSMutableArray new];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.TTNS_title = @"";
    self.TTNS_buttonTitles = @[[[NavButton_iPad alloc]initWithTitle:LocalizedString(@"KMORE_PMTC")], LocalizedString(@"PMTC_ATTACH_VOUCHER")];
}

- (void)loadData
{
    if ([Common checkNetworkAvaiable]) {
        [self.PMTC_ListDocumentTypeView setHidden:NO];
        [self.PMTC_ListDocumentView setHidden:NO];
        if (_errorView) {
            [_errorView setHidden:YES];
        }
        [self addContainerView];
    }
    else
    {
        [self addErrorView: LocalizedString(@"Mất kết nối mạng")];
    }
}

- (void)addContainerView {
    self.documentTypeList = NEW_VC_FROM_NIB(DocumentTypeListViewController_iPad, @"DocumentTypeListViewController_iPad");
    [self displayVC:self.documentTypeList container:self.PMTC_ContentListView];
    
    
       
//    self.documentAttachList = NEW_VC_FROM_NIB(PMTC_ListDocumentViewController_iPad, @"PMTC_ListDocumentViewController_iPad");
//    self.documentAttachList.documentType = @"";
//    self.documentAttachList.pageSize = 20;
//    self.documentAttachList.pageNumber = 0;
//    [self displayVC:self.documentAttachList container:self.PMTC_ContentDetailView];
}



#pragma mark SOErrorViewDelegate
- (void)didRefreshOnErrorView:(SOErrorView *)errorView
{
    [self loadData];
}

- (void)addErrorView:(NSString *)content {
    [self.PMTC_ListDocumentTypeView setHidden:YES];
    [self.PMTC_ListDocumentView setHidden:YES];
    if (!_errorView) {
        [self addNoNetworkView];
    }
    else
    {
        [_errorView setHidden:NO];
    }
    [_errorView setErrorInfo:content];
}

- (void)addNoNetworkView
{
    [self.view addSubview:[self getErrorView]];
}
- (SOErrorView *)getErrorView
{
    _errorView = [[SOErrorView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height - 70) inforError:nil];
    [_errorView setBackgroundColor:[UIColor clearColor]];
    _errorView.delegate = self;
    return _errorView;
}



@end
