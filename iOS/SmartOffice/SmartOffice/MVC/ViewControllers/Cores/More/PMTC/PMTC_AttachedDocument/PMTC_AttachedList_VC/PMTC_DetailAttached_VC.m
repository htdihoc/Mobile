//
//  PMTC_DetailAttached_VC.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "PMTC_DetailAttached_VC.h"
#import "PMTC_DetailAttached_Cell.h"
#import "DocumentCategoryModel.h"
#import "PMTCProcessor.h"
#import "Common.h"
#import "SOErrorView.h"
#import "WorkNoDataView.h"
#import "VoucherDetailViewController.h"
#import "SVPullToRefresh.h"
#import "NSString+StringToDate.h"


@interface PMTC_DetailAttached_VC ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, TTNS_BaseNavViewDelegate, SOErrorViewDelegate, SOSearchBarViewDelegate, UITextFieldDelegate> {
    SOErrorView *soErrorView;
    NSMutableArray *documentList;
    DocumentCategoryModel *listDocumentModel;
    
}
@property (strong, nonatomic) NSArray *data_FilterDetailPMTC;

@end

@implementation PMTC_DetailAttached_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initErrorView];
    [self setupUI];
    documentList = [NSMutableArray new];
    [self getDataListDocument];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
}

- (void)setupUI {
    self.backTitle = self.main_title;
    self.search_view.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    
    self.search_view.placeholder = LocalizedString(@"PMTC_SEARCH_BY_NAME_AND_MORE");
    self.search_view.tintColor = AppColor_MainAppBackgroundColor;
    
    self.search_view.layer.borderWidth = 1;
    self.search_view.layer.borderColor = AppColor_MainAppBackgroundColor.CGColor;

        if (IS_IPAD) {
            self.cst_searchViewToTop.constant = 0;
        } else {
            self.cst_searchViewToTop.constant = 64;
        }
}

- (void) initErrorView {
    soErrorView = (SOErrorView *)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    soErrorView.delegate = self;
    soErrorView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
    soErrorView.lblErrorInfo.text = @"Mất kết nối hệ thống";
    [self.view addSubview:soErrorView];
    soErrorView.hidden = YES;
}

- (void)didRefreshOnErrorView:(SOErrorView *)errorView {
    [self getDataListDocument];
}

- (void)getDataListDocument {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"arg0": self.documentType,
                                @"arg2": [NSNumber numberWithInteger:self.pageSize],
                                @"arg3": [NSNumber numberWithInteger:self.pageNumber]
                                };
    [PMTCProcessor postPMTC_getDocumentByCategory:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        [documentList removeAllObjects];
        NSArray *array = result;
//        [documentList addObjectsFromArray:array];
        array = [DocumentCategoryModel arrayOfModelsFromDictionaries:array error:nil];
        documentList = [NSMutableArray arrayWithArray:[self sortArray:array]];
        self.data_FilterDetailPMTC = documentList;
        if (documentList.count > 0 ) {
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
- (void) errorServer {
    soErrorView.hidden = NO;
    self.tableView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
}
- (void) donotInternet {
    soErrorView.hidden = NO;
//    self.tableView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
    [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối Internet" inView: self.view];
}

- (void) addNoDataView {
    WorkNoDataView *workNoDataView  = (WorkNoDataView*)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text    = LocalizedString(@"PMTC_NO_DATA");
    [self.tableView addSubview:workNoDataView];
}

#pragma mark SOSearchBarViewDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self dismissKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self getDataPMTCListDocumentDetail];
    [self dismissKeyboard];
    return YES;
}

- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText {
    if ([searchText length] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"documentNo contains[cd] %@ or content contains[cd] %@ or documentDate contains[cd] %@",searchText, searchText, searchText];
        self.data_FilterDetailPMTC = [documentList filteredArrayUsingPredicate:predicate];
        if ([self.data_FilterDetailPMTC count] > 0) {
            [self removeContentLabel];
            [self.tableView reloadData];
        } else {
            [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả")];
            [self.tableView reloadData];
        }
    } else {
        [self removeContentLabel];
        self.data_FilterDetailPMTC = documentList;
        [self.tableView reloadData];
    }
}

- (void) getDataPMTCListDocumentDetail {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"arg0": self.documentType,
                                @"arg1": self.search_view.searchBar.text,
                                @"arg2": [NSNumber numberWithInteger:self.pageSize],
                                @"arg3": [NSNumber numberWithInteger:self.pageNumber]
                                };
    [PMTCProcessor postPMTC_searchDocumentByCategory:parameter handle:^(id result, NSString *error) {
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

- (void) errorServerTTTS {
    soErrorView.hidden = NO;
    self.tableView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
}


- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_FilterDetailPMTC.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID_CELL = @"DetailAttached_Cell";
    PMTC_DetailAttached_Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PMTC_DetailAttached_Cell" bundle:nil] forCellReuseIdentifier:ID_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    }
    
    listDocumentModel = self. data_FilterDetailPMTC[indexPath.row];
    NSString *title = listDocumentModel.content;
    NSString *serial = listDocumentModel.documentNo;
    
    NSString *result = [self convertDate:listDocumentModel.documentDate];
    
    NSString *titleSerial = LocalizedString(@"PMTC_DETAIL_VOUCHER_NO");
    NSString *titleDate = LocalizedString(@"PMTC_DETAIL_VOUCHER_DATE");
    
    cell.lbl_Title.text  = [NSString stringWithFormat:@"%@", title];
    cell.lbl_Serial.text = [NSString stringWithFormat:@"%@: %@", titleSerial, serial];
    cell.lbl_Date.text = [NSString stringWithFormat:@"%@: %@", titleDate, result];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self.tableView.pullToRefreshView stopAnimating];
        [self reloadDataTableView];
    }];
    return cell;
}

- (void) reloadDataTableView {
    if ([Common checkNetworkAvaiable]) {
        [documentList removeAllObjects];
        [self getDataListDocument];
        [self.tableView reloadData];
    } else {
        [self showToastWithMessage:@"Mất kết nối Internet"];
    }
    
}

- (NSArray *)sortArray:(NSArray *)data
{
    NSArray *sortedArray;
    sortedArray = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [[(DocumentCategoryModel *)a documentDate] convertStringToDateWith:DATE_DOCUMENT_FROM_SERVER];
        NSDate *second = [[(DocumentCategoryModel *)b documentDate] convertStringToDateWith:DATE_DOCUMENT_FROM_SERVER];
        return [second compare:first];
    }];
    return sortedArray;
}

- (NSString *)convertDate:(NSString *)inDate {
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
    NSDate *date = [dateFormat dateFromString:inDate];
    NSDateFormatter *convert = [[NSDateFormatter alloc]init];
    [convert setDateFormat:@"dd/MM/yyyy"];
    NSString *result = [convert stringFromDate:date];
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VoucherDetailViewController *voucherDetail_VC = NEW_VC_FROM_STORYBOARD(@"VoucherDetail", @"VoucherDetailViewController");
    listDocumentModel = documentList[indexPath.row];
    voucherDetail_VC.contentSeriaString = listDocumentModel.documentNo;
    voucherDetail_VC.contentDateString = [self convertDate:listDocumentModel.documentDate];
    voucherDetail_VC.contentString = listDocumentModel.content;
    voucherDetail_VC.documentType = listDocumentModel.documentType;
    [self.navigationController pushViewController:voucherDetail_VC animated:YES];
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}


@end
