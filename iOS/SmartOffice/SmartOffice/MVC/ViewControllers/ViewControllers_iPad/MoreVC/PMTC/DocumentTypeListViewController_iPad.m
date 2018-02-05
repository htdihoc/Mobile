//
//  DocumentTypeListViewController_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 9/28/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "DocumentTypeListViewController_iPad.h"
#import "documentListTypeCell_iPad.h"
#import "PMTCProcessor.h"
#import "Common.h"
#import "SOErrorView.h"
#import "WorkNoDataView.h"
#import "DocumentTypeListModel.h"
#import "PMTC_ListDocumentViewController_iPad.h"
#import "SVPullToRefresh.h"

@interface DocumentTypeListViewController_iPad () <UITableViewDelegate, UITableViewDataSource, SOSearchBarViewDelegate, TTNS_BaseNavViewDelegate, SOErrorViewDelegate> {
    SOErrorView *soErrorView;
    NSMutableArray *documentType;
    DocumentTypeListModel *documentTypeListModel;
    documentListTypeCell_iPad *documentListCell;
    PMTC_ListDocumentViewController_iPad *detailAttached_VC;
}
@property (strong, nonatomic) NSArray *data_FilterPMTC;

@end

@implementation DocumentTypeListViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.typeDocumentListTable.delegate = self;
    self.typeDocumentListTable.dataSource = self;
    self.searchView.delegate = self;
    documentType = [NSMutableArray new];
    [self getNumberDocmentType];
    [self setupUI];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.typeDocumentListTable selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionNone];
    if (documentType.count > 0) {
        [self tableView:self.typeDocumentListTable didSelectRowAtIndexPath:indexPath];
    } else {
        [self addNoDataView];
    }
}

- (void)setupUI {
    self.searchView.placeholder = LocalizedString(@"PMTC_SEARCH_BY_NAME");

    self.searchView.tintColor = AppColor_MainAppBackgroundColor;
    _searchView.layer.borderWidth = 1;
    _searchView.layer.borderColor = AppColor_BorderForView.CGColor;
    [self.typeDocumentListTable setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
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
            [self.typeDocumentListTable reloadData];
        } else {
            [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả")];
            [self.typeDocumentListTable reloadData];
        }
    } else {
        [self removeContentLabel];
        self.data_FilterPMTC = documentType;
        [self.typeDocumentListTable reloadData];
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
            [self.typeDocumentListTable reloadData];
            self.typeDocumentListTable.hidden = NO;
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
    self.typeDocumentListTable.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
}


- (void) errorServer {
    soErrorView.hidden = NO;
    self.typeDocumentListTable.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
}
- (void) donotInternet {
    soErrorView.hidden = NO;
    self.typeDocumentListTable.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
    [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối Internet" inView: self.view];
}

- (void) addNoDataView {
    WorkNoDataView *workNoDataView  = (WorkNoDataView*)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    workNoDataView.contenLB.text    = LocalizedString(@"PMTC_NOT_DOCUMENT");
    [self.typeDocumentListTable addSubview:workNoDataView];
}

- (void) getDataPMTCListDocumentType {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"arg0": self.searchView.searchBar.text
                                };
    [PMTCProcessor postPMTC_searchDocumentCategory:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        [self.typeDocumentListTable reloadData];
    } onError:^(NSString *Error) {
        [self errorServerTTTS];
    } onException:^(NSString *Exception) {
        [self donotInternet];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

//- (void)getListDocumentTypeModel {
//    self.docType = self.data_FilterPMTC[0];
//    self.sizePage = 20;
//    self.numberPage = 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_FilterPMTC.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID_CELL = @"documentListTypeCell_iPad";
    documentListTypeCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"documentListTypeCell_iPad" bundle:nil] forCellReuseIdentifier:ID_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    }
    documentTypeListModel = self.data_FilterPMTC[indexPath.row];
    self.docType = documentTypeListModel.value;
    self.sizePage = 20;
    self.numberPage = 0;
    cell.typeDocumentLabel.text = documentTypeListModel.name;
    [self.typeDocumentListTable addPullToRefreshWithActionHandler:^{
        [self.typeDocumentListTable.pullToRefreshView stopAnimating];
        [self reloadDataTableView];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.lastIndex = indexPath;
    detailAttached_VC = NEW_VC_FROM_NIB(PMTC_ListDocumentViewController_iPad, @"PMTC_ListDocumentViewController_iPad");
    documentTypeListModel = self.data_FilterPMTC[indexPath.row];
    detailAttached_VC.documentType = documentTypeListModel.value;
    detailAttached_VC.pageSize = 20;
    detailAttached_VC.pageNumber = 0;
}

- (void)reloadDataTableView {
    [documentType removeAllObjects];
    [self getNumberDocmentType];
    [self.typeDocumentListTable reloadData];
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}




@end
