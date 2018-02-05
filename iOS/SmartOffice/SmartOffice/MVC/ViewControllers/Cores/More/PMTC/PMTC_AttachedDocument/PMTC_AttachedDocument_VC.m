//
//  PMTC_AttachedDocument_VC.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "PMTC_AttachedDocument_VC.h"
#import "PMTC_AttachedDocument_Cell.h"
#import "PMTC_DetailAttached_VC.h"
#import "PMTCProcessor.h"
#import "Common.h"
#import "SOErrorView.h"
#import "WorkNoDataView.h"
#import "DocumentTypeListModel.h"
#import "SVPullToRefresh.h"


@interface PMTC_AttachedDocument_VC () <UITableViewDelegate, UITableViewDataSource, SOSearchBarViewDelegate, TTNS_BaseNavViewDelegate, SOErrorViewDelegate> {
    SOErrorView *soErrorView;
    NSMutableArray *documentType;
    DocumentTypeListModel *documentTypeListModel;
    PMTC_AttachedDocument_Cell *documentListCell;
        
}

@property (strong, nonatomic) NSArray *data_FilterPMTC;

@end

@implementation PMTC_AttachedDocument_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.search_view.delegate = self;
    documentType = [NSMutableArray new];
    [self getNumberDocmentType];
    [self setupUI];
    [self checkIpad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    
}

- (void)checkIpad {
    if (IS_IPAD) {
        self.cst_NaviIphone.constant = 0;
    } else {
        self.cst_NaviIphone.constant = 64;
    }
}

- (void)setupUI {
    self.backTitle = LocalizedString(@"PMTC_ATTACH_VOUCHER");
    self.search_view.placeholder = LocalizedString(@"PMTC_SEARCH_BY_NAME");
    _lbl_Header.text = LocalizedString(@"PMTC_LIST_OF_TYLE_DOCUMENTS");
    self.search_view.tintColor = AppColor_MainAppBackgroundColor;
    _search_view.layer.borderWidth = 1;
    _search_view.layer.borderColor = AppColor_BorderForView.CGColor;
    _headerView.layer.borderWidth = 1;
    _headerView.layer.borderColor = AppColor_BorderForView.CGColor;
    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
}

- (void) initErrorView {
    soErrorView = (SOErrorView *)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    soErrorView.delegate = self;
    soErrorView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
    soErrorView.lblErrorInfo.text = @"Mất kết nối hệ thống";
    [self.view addSubview:soErrorView];
    soErrorView.hidden = YES;
}

#pragma mark SOSearchBarViewDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self dismissKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self getDataPMTCListDocumentType];
    [self dismissKeyboard];
    return YES;
}

- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText {
    if ([searchText length] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@ or value contains[cd] %@" ,searchText, searchText];
        self.data_FilterPMTC = [documentType filteredArrayUsingPredicate:predicate];
        if ([self.data_FilterPMTC count] > 0) {
            [self removeContentLabel];
            [self.tableView reloadData];
        } else {
            [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả")];
            [self.tableView reloadData];
        }
    } else {
        [self removeContentLabel];
        self.data_FilterPMTC = documentType;
        [self.tableView reloadData];
    }
}

- (void)didRefreshOnErrorView:(SOErrorView *)errorView {
    [self getNumberDocmentType];
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void) getNumberDocmentType {
    [[Common shareInstance] showCustomHudInView:self.view];
    [PMTCProcessor postPMTC_getDocumentCategory:nil handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSArray *array = result;
        [documentType addObjectsFromArray:array];
        documentType = [DocumentTypeListModel arrayOfModelsFromDictionaries:array error:nil];
        self.data_FilterPMTC = documentType;
        if (documentType.count > 0 ) {
            [self.tableView reloadData];
            self.tableView.hidden = NO;
            soErrorView.hidden = YES;
        } else {
            [self addNoDataView];
        }
    } onError:^(NSString *Error) {
        [self errorServer];
    } onException:^(NSString *Exception) {
        [self donotInternet];
    }];
}

- (void) errorServerTTTS {
    soErrorView.hidden = NO;
    self.tableView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
}


- (void) errorServer {
    soErrorView.hidden = NO;
    self.tableView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
}
- (void) donotInternet {
    soErrorView.hidden = NO;
    self.tableView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
    [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối Internet" inView: self.view];
}

- (void) addNoDataView {
    WorkNoDataView *workNoDataView  = (WorkNoDataView*)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    workNoDataView.contenLB.text    = LocalizedString(@"PMTC_NOT_DOCUMENT");
    [self.tableView addSubview:workNoDataView];
}

- (void) getDataPMTCListDocumentType {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"arg0": self.search_view.searchBar.text
                                };
    [PMTCProcessor postPMTC_searchDocumentCategory:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        [self.tableView reloadData];
    } onError:^(NSString *Error) {
        [self errorServerTTTS];
    } onException:^(NSString *Exception) {
        [self donotInternet];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_FilterPMTC.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID_CELL = @"AttachedDocument_Cell";
    PMTC_AttachedDocument_Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PMTC_AttachedDocument_Cell" bundle:nil] forCellReuseIdentifier:ID_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    }
    documentTypeListModel = self.data_FilterPMTC[indexPath.row];
    cell.lbl_DocumentName.text = documentTypeListModel.name;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self.tableView.pullToRefreshView stopAnimating];
        [self reloadDataTableView];
    }];
    return cell;
}

- (void)reloadDataTableView {
    [documentType removeAllObjects];
    [self getNumberDocmentType];
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PMTC_DetailAttached_VC *detailAttached_VC = NEW_VC_FROM_NIB(PMTC_DetailAttached_VC, @"PMTC_DetailAttached_VC");
    documentTypeListModel = self.data_FilterPMTC[indexPath.row];
    detailAttached_VC.main_title = documentTypeListModel.name;
    detailAttached_VC.documentType = documentTypeListModel.value;
    detailAttached_VC.pageSize = 20;
    detailAttached_VC.pageNumber = 0;
    [self.navigationController pushViewController:detailAttached_VC animated:YES];
}

- (void) selectFirstRow {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    if (documentType.count > 0) {
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

@end
