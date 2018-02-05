//
//  KTTSViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 9/13/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTSViewController.h"
#import "KTTSTableViewCell.h"
#import "Common.h"
#import "KTTSProcessor.h"
#import "PropertyInfoModel.h"
#import "BBBGAssetModel.h"
#import "SVPullToRefresh.h"
#import "DetailTTTSCell.h"
#import "BBBGTableViewCell.h"
#import "SOErrorView.h"
#import "ContentFilterVC.h"
#import "WYPopoverController.h"
#import "KTTS_ConfirmProperty_iPad.h"
#import "MZFormSheetController.h"
#import "KTTS_CancelStatus_VC_iPad.h"
#import "KTTS_ContentAssetBBBG_VC_iPad.h"
#import "Reachability.h"

@interface KTTSViewController () <UITableViewDelegate, UITableViewDataSource, SOSearchBarViewDelegate, SOErrorViewDelegate, ContentFilterVCDelegate, WYPopoverControllerDelegate, SendRequestDelegate> {
    DetailTTTSCell *tttsCell;
    BBBGTableViewCell *bbbgCell;
    SOErrorView *soErrorView;
    ContentFilterVC *filterViewController;
    WYPopoverController *popoverController;
    WorkFilterType _filterTypeTTTS;
    WorkFilterType _filterTypeBBBG;
    PropertyInfoModel *propertyinfo;
    DetailBBBGModel *detailBBBG;
}

@property (nonatomic) int Screen;
@property (nonatomic) int limit, startTTTS, startBBBG, limitTTTS, limitBBBG, index;
@property (strong, nonatomic) NSMutableArray *api_data_TTTS, *api_data_BBBG, *api_data_detailBBBG;
@property (strong, nonatomic) NSArray *data_FilterTTTS, *data_FilterBBBG, *data_FilterDetailBBBG;
@property (strong, nonatomic) NSMutableArray *TTTS_data, *BBBG_data, *DetailBBBG;
@property (nonatomic) int TTTS_RecordTotal, BBBG_RecordTotal, countDetailBBBG;
@property (nonatomic) bool isloadmoreTTTS, isloadmoreBBBG;
@property (nonatomic) BOOL isFiltered, isDetailFilter, isSelect;
@property (nonatomic) NSInteger isSelected;

@end

@implementation KTTSViewController

- (void)viewWillAppear:(BOOL)animated {
    [self countRecordTotal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self addTitle:@"KTTS12"];
    self.VOffice_buttonTitles = @[@"Thông tin tài sản cá nhân"];
    self.disableBackIcon = YES;
    _Screen = 0;
    _limit = 20;
    _startTTTS = 0;
    _startBBBG = 0;
    _api_data_TTTS = [NSMutableArray new];
    _api_data_BBBG = [NSMutableArray new];
    _api_data_detailBBBG = [NSMutableArray new];
    _TTTS_data = [NSMutableArray new];
    _BBBG_data = [NSMutableArray new];
    _DetailBBBG = [NSMutableArray new];
    _data_FilterTTTS = [NSArray new];
    _data_FilterBBBG = [NSArray new];
    _data_FilterDetailBBBG = [NSArray new];
    self.isloadmoreTTTS = true;
    self.isloadmoreBBBG = true;
    self.search_view.searchBar.placeholder = LocalizedString(@"SearchSerial...");
    self.detailSearchView.searchBar.placeholder = LocalizedString(@"SearchSerial.");
    self.kttsTableView.rowHeight = UITableViewAutomaticDimension;
    self.kttsTableView.estimatedRowHeight = 180;
    self.detailKTTSTableView.rowHeight = UITableViewAutomaticDimension;
    self.detailKTTSTableView.estimatedRowHeight = 590;
    [self hideDetailTableView];
    [self showErrorKTTSView];
    self.search_view.delegate = self;
    self.detailSearchView.delegate = self;
    self.search_view.searchBar.placeholder = LocalizedString(@"SearchSerial...");
    [[Common shareInstance] showCustomHudInView:self.view];
}

- (void) showErrorKTTSView {
    soErrorView = (SOErrorView *)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    soErrorView.delegate = self;
    soErrorView.frame = self.kttsView.bounds;
    soErrorView.lblErrorInfo.text = @"Mất kết nối hệ thống";
    [self.kttsView addSubview:soErrorView];
    soErrorView.hidden = YES;
}

- (void)didRefreshOnErrorView:(SOErrorView *)errorView {
    [self showDetailTableView];
    [self reloadDataTableView];
}

- (void) countRecordTotal {
    [self TTTS];
    [self BBBG];
}

- (void) TTTS {
//    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"102026",
                                @"type": @"1"
                                };
    [KTTSProcessor postCountDataTTTS:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        self.limitTTTS = [result[@"return"] intValue];
        [self showTotalAllRecords];
        [self getDataTTTS];
    } onError:^(NSString *Error) {
        [self showErrorServer];
    } onException:^(NSString *Exception) {
        [self showLostConnectKTTSView];
    }];
}

- (void) BBBG {
//    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"102026",
                                @"type": @"2"
                                };
    [KTTSProcessor postCountDataTTTS:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        self.limitBBBG = [result[@"return"] intValue];
        [self showTotalAllRecords];
        [self getDataBBBG];
    } onError:^(NSString *Error) {
        [self showErrorServer];
    } onException:^(NSString *Exception) {
        [self showLostConnectKTTSView];
    }];
}

// MARK: - Request Data Thông tin tài sản
- (void) getDataTTTS {
//    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"102026",
                                @"start": IntToString(_startTTTS),
                                @"keyword": _search_view.searchBar.text,
                                @"limit": IntToString(_limit)
                                };
    [KTTSProcessor postKTTS_THONG_TIN_TAI_SAN:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSArray *array = result[@"listMerEntity"];
        [self.api_data_TTTS addObjectsFromArray:array];
        [self showTotalAllRecords];
        [self.kttsTableView reloadData];
        [self selectFirstTableView];
    } onError:^(NSString *Error) {
        [self showErrorServer];
    } onException:^(NSString *Exception) {
        [self showLostConnectKTTSView];
    }];
}

// MARK: - Request Data BBBG
- (void) getDataBBBG {
//    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"102026",
                                @"start": IntToString(self.startBBBG),
                                @"keyword": _search_view.searchBar.text,
                                @"limit": IntToString(self.limit)
                                };
    [KTTSProcessor postKTTS_BBBG:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSArray *array = result[@"listMinuteHandOver"];
        [self.api_data_BBBG addObjectsFromArray:array];
        [self showTotalAllRecords];
        [self.kttsTableView reloadData];
        [self selectFirstTableView];
    } onError:^(NSString *Error) {
        [self showErrorServer];
    } onException:^(NSString *Exception) {
        [self showLostConnectKTTSView];
    }];
}

- (void) getCountDataDetailBBBG:(NSInteger)sender {
//    [[Common shareInstance] showCustomHudInView:self.view];
    [_api_data_detailBBBG removeAllObjects];
    [self.detailKTTSTableView setContentOffset:CGPointZero animated:NO];
    NSDictionary *parameter = @{
                                @"idBBBGTSCN": IntToString(sender)
                                };
    [KTTSProcessor postCountDataDetailBBBG:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        self.countDetailBBBG = [result[@"return"] intValue];
        [self getDataDetailBBBG:sender];
    } onError:^(NSString *Error) {
        // todo
        [[Common shareInstance] dismissCustomHUD];
        [self showError];
    } onException:^(NSString *Exception) {
        [self showToastNotConnect];
    }];
}

- (void) getDataDetailBBBG:(NSInteger)sender {
//    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"idBBBGTSCN": IntToString(sender),
                                @"start": IntToString(0),
                                @"keyword": self.detailSearchView.searchBar.text,
                                @"limit": IntToString(self.countDetailBBBG)
                                };
    [KTTSProcessor postDetailBBBG:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSArray *array = result[@"listMerEntity"];
        [_api_data_detailBBBG addObjectsFromArray:array];
        [self.detailKTTSTableView reloadData];
    } onError:^(NSString *Error) {
        // todo
        [[Common shareInstance] dismissCustomHUD];
        [self showError];
    } onException:^(NSString *Exception) {
        [self showToastNotConnect];
    }];
}

- (void) showTotalAllRecords {
    if (_Screen == 0) { //TTTS count
        if (self.limitTTTS > [self.api_data_TTTS count]) {
            self.recordTotal.text = IntToString(self.limitTTTS);
        } else {
            self.recordTotal.text = IntToString([self.api_data_TTTS count]);
        }
    } else if (_Screen == 1) { //BBBG count
        if (self.limitBBBG > [self.api_data_BBBG count]) {
            self.recordTotal.text = IntToString(self.limitBBBG);
        } else {
            self.recordTotal.text = IntToString([self.api_data_BBBG count]);
        }
    }
}

- (void) loadmoreTableView {
    switch (_Screen) {
        case 0:
        {
            if (self.startTTTS + 20 < self.limitTTTS && self.isloadmoreTTTS == true) {
                self.startTTTS = self.startTTTS + 20;
                [self getDataTTTS];
            } else {
                self.isloadmoreTTTS = false;
            }
        }
            break;
        case 1:
        {
            if (self.startBBBG + 20 < self.limitBBBG && self.isloadmoreBBBG == true) {
                self.startBBBG = self.startBBBG + 20;
                [self getDataBBBG];
            } else {
                self.isloadmoreBBBG = false;
            }
        }
            break;
        default:
            break;
    }
}

// MARK: - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.kttsTableView) {
        switch (_Screen) {
            case 0:
                if (_isFiltered) {
                    return self.data_FilterTTTS.count;
                } else {
                    return _api_data_TTTS.count;
                }
                break;
            case 1:
                if (_isFiltered) {
                    return self.data_FilterBBBG.count;
                } else {
                    return _api_data_BBBG.count;
                }
                break;
            default:
                return 0;
                break;
        }
    } else {
        
        // MARK: - Detail KTTS Datasource Row
        switch (_Screen) {
            case 0:
                if (self.isSelect == NO) {
                    return 1;
                } else {
                    return 0;
                }
                break;
            case 1:
                if (_isDetailFilter) {
                    return self.data_FilterDetailBBBG.count;
                } else {
                    return _api_data_detailBBBG.count;
                }
                break;
            default:
                return 0;
                break;
        }
    }
}

// MARK: - Detail KTTS Datasource Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // MARK: - TableView KTTS.
    if (tableView == self.kttsTableView) {
        KTTSTableViewCell *kttsCell = (KTTSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"KTTSTableViewCell"];
        if (kttsCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KTTSTableViewCell" owner:self options:nil];
            kttsCell = (KTTSTableViewCell *)[nib objectAtIndex:0];
        }
        
        kttsCell.value_cell_number.text = IntToString(indexPath.row + 1);
        
        // set data
        switch (_Screen) {
            case 0: {
                
                if (_isSelected == indexPath.row) {
                    kttsCell.selectedView.backgroundColor = [UIColor blackColor];
                    kttsCell.selectedView.alpha = 0.1;
                } else {
                    kttsCell.selectedView.backgroundColor = [UIColor clearColor];
                    kttsCell.selectedView.alpha = 1;
                }
                
                // title
                kttsCell.title_name.text = @"Tên tài sản:";
                kttsCell.titleNumberAndDate.text = @"Số lượng:";
                kttsCell.title_SerialAndName.text = @"Serial:";
                
                // value
                if (!_isFiltered) {
                    _TTTS_data = [PropertyInfoModel arrayOfModelsFromDictionaries:self.api_data_TTTS error:nil];
                } else {
                    _TTTS_data = [PropertyInfoModel arrayOfModelsFromDictionaries:self.data_FilterTTTS error:nil];
                }
                
                propertyinfo = _TTTS_data[indexPath.row];
                
                kttsCell.value_goods_name.text = propertyinfo.catMerName;
                kttsCell.value_number.text = IntToString(propertyinfo.count);
                kttsCell.value_serial.text = propertyinfo.serialNumber;
                kttsCell.value_status.text = propertyinfo.privateManagerName;
                
                kttsCell.value_status.textColor = RGB(254, 94, 8);
                
                if (indexPath.row == self.api_data_TTTS.count - 1) {
                    [self loadmoreTableView];
                }
            }
                break;
            case 1: {
                
                if (_isSelected == indexPath.row) {
                    kttsCell.selectedView.backgroundColor = [UIColor blackColor];
                    kttsCell.selectedView.alpha = 0.1;
                } else {
                    kttsCell.selectedView.backgroundColor = [UIColor clearColor];
                    kttsCell.selectedView.alpha = 1;
                }
                
                // title
                kttsCell.title_name.text = @"Mã BBBG:";
                kttsCell.titleNumberAndDate.text = @"Ngày bàn giao:";
                kttsCell.title_SerialAndName.text = @"Người bàn giao:";
                
                // value
                
                if (!_isFiltered) {
                    _BBBG_data = [BBBGAssetModel arrayOfModelsFromDictionaries:_api_data_BBBG error:nil];
                } else {
                    _BBBG_data = [BBBGAssetModel arrayOfModelsFromDictionaries:_data_FilterBBBG error:nil];
                }
                
                BBBGAssetModel *bbbg = _BBBG_data[indexPath.row];
                
                kttsCell.value_goods_name.text = bbbg.minuteHandOverCode;
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: (bbbg.minuteHandOverDate/1000)];
                NSDateFormatter *format = [NSDateFormatter new];
                [format setDateFormat: @"dd/MM/yyyy"];
                kttsCell.value_number.text = [format stringFromDate:date];
                
                kttsCell.value_serial.text = bbbg.employeeMinuteHandOVerName;
                
                switch (bbbg.status) {
                    case 0: {
                        kttsCell.value_status.text = @"Chưa xác nhận";
                        kttsCell.value_status.textColor = RGB(254, 94, 8);
                    }
                        break;
                    case 1: {
                        kttsCell.value_status.text = @"Đã xác nhận";
                        kttsCell.value_status.textColor = RGB(2, 127, 185);
                    }
                        break;
                    case 2: {
                        kttsCell.value_status.text = @"Bị từ chối";
                        kttsCell.value_status.textColor = RGB(254, 8, 8);
                    }
                        break;
                    default: {
                        kttsCell.value_status.text = @"Không xác định";
                    }
                        break;
                }
                if (indexPath.row == self.api_data_BBBG.count - 1) {
                    [self loadmoreTableView];
                }
            }
                
                break;
                
            default:
                break;
        }
        
        kttsCell.selectionStyle = UIAccessibilityTraitNone;
        
        
        [self.kttsTableView addPullToRefreshWithActionHandler:^{
            [self.kttsTableView.pullToRefreshView stopAnimating];
            _isFiltered = NO;
            _filterTypeTTTS = 0;
            _filterTypeBBBG = 0;
            self.isloadmoreBBBG = true;
            self.isloadmoreTTTS = true;
            [self reloadDataTableView];
        }];
        
        return kttsCell;
        
    } else if (tableView == self.detailKTTSTableView) {
        
        // MARK: - Detail TableView KTTS.
        switch (_Screen) {
            case 0: {
                tttsCell = (DetailTTTSCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailTTTSCell"];
                if (tttsCell == nil) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailTTTSCell" owner:self options:nil];
                    tttsCell = (DetailTTTSCell *)[nib objectAtIndex:0];
                }
                tttsCell.delegate = self;
                tttsCell.selectionStyle = UIAccessibilityTraitNone;
                
                return tttsCell;
            }
                break;
            case 1: {
                bbbgCell = (BBBGTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BBBGTableViewCell"];
                if (bbbgCell == nil) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BBBGTableViewCell" owner:self options:nil];
                    bbbgCell = (BBBGTableViewCell *)[nib objectAtIndex:0];
                }
                
                _DetailBBBG = [DetailBBBGModel arrayOfModelsFromDictionaries:self.api_data_detailBBBG error:nil];
                bbbgCell.value_cell_number.text = IntToString(indexPath.row+1);
                detailBBBG = _DetailBBBG[indexPath.row];
                [bbbgCell setDataDetailBBBGWithArray:detailBBBG];
                bbbgCell.selectionStyle = UIAccessibilityTraitNone;
                
                return bbbgCell;
            }
                break;
            default:
                return nil;
                break;
        }
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.kttsTableView) {
        _isSelected = indexPath.row;
        [_kttsTableView reloadData];
        switch (_Screen) {
            case 0: {
                _reason_height_constraint.constant = 0;
                [self.view layoutIfNeeded];
                propertyinfo = _TTTS_data[indexPath.row];
                self.detailAssetName.text = [NSString stringWithFormat:@"Chi tiết %@", propertyinfo.minuteHandOverCode];
                [tttsCell setDataWithArray:propertyinfo];
                _index = (int)indexPath.row;
                
                switch ([propertyinfo.privateManagerName componentsSeparatedByString:@";"].count) {
                    case 0:
                        tttsCell.cancelButton.hidden = YES;
                        tttsCell.confirmButton.hidden = NO;
                        break;
                    case 4:
                        tttsCell.cancelButton.hidden = NO;
                        tttsCell.confirmButton.hidden = YES;
                        break;
                    default:
                        tttsCell.cancelButton.hidden = NO;
                        tttsCell.confirmButton.hidden = NO;
                        break;
                }
            }
                break;
            case 1: {
                // MARK: - GET Data Detail BBBG.
                BBBGAssetModel *bbbgModel = _BBBG_data[indexPath.row];
                self.detailAssetName.text = [NSString stringWithFormat:@"Chi tiết %@", bbbgModel.minuteHandOverCode];
                [self getCountDataDetailBBBG:bbbgModel.minuteHandOverId];
                switch (bbbgModel.status) {
                    case 0:
                        // Đã bàn giao
                        _reason_height_constraint.constant = 0;
                        _reasonView.hidden = YES;
                        [self.view layoutIfNeeded];
                        break;
                    case 1:
                        // Đã xác nhận
                        _reason_height_constraint.constant = 0;
                        _reasonView.hidden = YES;
                        [self.view layoutIfNeeded];
                        break;
                        
                    case 2:
                        // Đã từ chối
                        _reason_height_constraint.constant = 60;
                        _reasonView.hidden = NO;
                        _reasonLabel.text = [NSString stringWithFormat:@"Lý do: %@", bbbgModel.description];
                        [self.view layoutIfNeeded];
                        break;
                    default:
                        break;
                }
                NSLog(@"%li", (long)bbbgModel.status);
            }
                break;
            default:
                break;
        }
    } else if (tableView == self.detailKTTSTableView) {
        _DetailBBBG = [DetailBBBGModel arrayOfModelsFromDictionaries:self.api_data_detailBBBG error:nil];
        detailBBBG = _DetailBBBG[indexPath.row];
        [self showContentBBBGWithArray:(DetailBBBGModel *)detailBBBG];
    }
}

// MARK: - Segment Action
- (IBAction)segmentAction:(id)sender {
    _isSelect = NO;
    NSInteger selectedIndex = self.segment.selectedSegmentIndex;
    NSInteger oldScreenIdx = _Screen;
    [self.view endEditing:YES];
    switch (selectedIndex) {
        case 0:
            _Screen = 0;
            self.recordTotal.text = IntToString(_limitTTTS);
            self.searchview_detail_constraint.constant = 0;
            self.search_view.searchBar.placeholder = LocalizedString(@"SearchSerial...");
            break;
        case 1:
            _Screen = 1;
            self.recordTotal.text = IntToString(_limitBBBG);
            self.searchview_detail_constraint.constant = 50;
            self.search_view.searchBar.placeholder = LocalizedString(@"SearchCodeBBBG");
            break;
        default:
            break;
    }
    if (selectedIndex != oldScreenIdx) { //change view
        if ([self.search_view.searchBar.text length] > 0) {
            [self.search_view.searchBar setText:@""];
        }
        _isFiltered = NO;
        _isDetailFilter = NO;
        [self reloadDataTableView];
    } else {
        //do nothing
    }
    /*[self.detailKTTSTableView reloadData];
    [self.kttsTableView reloadData];
    [self.view layoutIfNeeded];
    [self selectFirstTableView];*/
}

// MARK: - Search local
-(BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.search_view.searchBar) {
        [self.view endEditing:YES];
        [self searchlocalwith:@""];
    }
    else if (textField == self.detailSearchView.searchBar) {
        [self.view endEditing:YES];
        [self searchDetailLocalWith:@""];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.startTTTS = 0;
    self.startBBBG = 0;
    [self.api_data_TTTS removeAllObjects];
    [self.api_data_BBBG removeAllObjects];
    [self getDataTTTS];
    [self getDataBBBG];
    [self.view endEditing:YES];
    return YES;
}

- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText {
    if (textField == self.search_view.searchBar) {
        NSString *tmpSearchText = [searchText stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        [self searchlocalwith:tmpSearchText];
    } else if (textField == self.detailSearchView.searchBar) {
        NSString *tmpSearchText = [searchText stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        [self searchDetailLocalWith:tmpSearchText];
    }
}

- (void) searchDetailLocalWith:(NSString *) searchText {
    if (searchText.length == 0) {
        _isDetailFilter = NO;
        self.detailKTTSTableView.hidden = NO;
        [self.detailKTTSTableView reloadData];
    } else {
        _isDetailFilter = YES;
        NSPredicate *p = [NSPredicate predicateWithFormat:@"catMerName CONTAINS[cd] %@ or serialNumber CONTAINS[cd] %@", searchText, searchText];
        self.data_FilterDetailBBBG = [self.api_data_detailBBBG filteredArrayUsingPredicate:p];
        switch (self.data_FilterDetailBBBG.count) {
            case 0:
                self.detailKTTSTableView.hidden = YES;
                break;
            default:
                self.detailKTTSTableView.hidden = NO;
                [self.detailKTTSTableView reloadData];
                break;
        }
    }
}

- (void) searchlocalwith:(NSString *)searchText {
    switch (_Screen) {
        case 0:
        {
            if (searchText.length == 0) {
                _isFiltered = NO;
                [self.kttsTableView reloadData];
                self.recordTotal.text = [NSString stringWithFormat:@"%ld", [self.api_data_TTTS count]];
                [self selectFirstTableView];
            } else {
                _isFiltered = YES;
                NSPredicate *p = [NSPredicate predicateWithFormat:@"catMerName CONTAINS[cd] %@ or serialNumber CONTAINS[cd] %@ or privateManagerName CONTAINS[cd] %@", searchText, searchText, searchText];
                self.data_FilterTTTS = [self.api_data_TTTS filteredArrayUsingPredicate:p];
                [self.kttsTableView reloadData];
                self.recordTotal.text = IntToString(self.data_FilterTTTS.count);
                [self selectFirstTableView];
            }
        }
            break;
        case 1:
        {
            if (searchText.length == 0) {
                _isFiltered = NO;
                [self.kttsTableView reloadData];
                self.recordTotal.text = [NSString stringWithFormat:@"%ld", [self.api_data_BBBG count]];
                [self selectFirstTableView];
            } else {
                _isFiltered = YES;
                NSPredicate *p = [NSPredicate predicateWithFormat:@"minuteHandOverCode CONTAINS[cd] %@ or employeeMinuteHandOVerName CONTAINS[cd] %@", searchText, searchText];
                self.data_FilterBBBG = [self.api_data_BBBG filteredArrayUsingPredicate:p];
                [self.kttsTableView reloadData];
                self.recordTotal.text = IntToString(self.data_FilterBBBG.count);
                [self selectFirstTableView];
            }
        }
        default:
            break;
    }
}

- (void) selectFirstTableView {
    if (!_isFiltered) {
        switch (_Screen) {
            case 0:
                if (self.api_data_TTTS.count > 0) {
                    soErrorView.hidden = YES;
                    [self selectFirstRow];
                } else {
                    [self hideDetailTableView];
                }
                break;
            case 1:
                if (self.api_data_BBBG.count > 0) {
                    soErrorView.hidden = YES;
                    [self selectFirstRow];
                } else {
                    [self hideDetailTableView];
                }
                break;
            default:
                break;
        }
    } else {
        switch (_Screen) {
            case 0:
                if (self.data_FilterTTTS.count > 0) {
                    [self selectFirstRow];
                } else {
                    [self hideDetailTableView];
                }
                break;
            case 1:
                if (self.data_FilterBBBG.count > 0) {
                    [self selectFirstRow];
                } else {
                    [self hideDetailTableView];
                }
                break;
            default:
                break;
        }
    }
}

- (void) reloadDataTableView {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối mạng" inView: self.view];
    } else {
        self.startTTTS = 0;
        self.startBBBG = 0;
        switch (_Screen) {
            case 0:
                [self reloadTTTS];
                break;
            case 1:
                [self reloadBBBG];
                break;
            default:
                break;
        }
        [self.kttsTableView reloadData];
    }
}

// MARK: - Reload TTTS
- (void) reloadTTTS {
    [self.api_data_TTTS removeAllObjects];
    [self TTTS];
}

// MARK: - Reload BBBG
- (void) reloadBBBG {
    [self.api_data_BBBG removeAllObjects];
    [self BBBG];
}

- (void) selectFirstRow {
    [self showDetailTableView];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (self.isSelect == NO) {
        [self.kttsTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        self.isSelect = YES;
    } else {
        [self.kttsTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    [self tableView:self.kttsTableView didSelectRowAtIndexPath:indexPath];
}

- (void) showDetailTableView {
    self.detailKTTSTableView.hidden = NO;
    self.kttsTableView.hidden = NO;
}

- (void) hideDetailTableView {
    self.detailKTTSTableView.hidden = YES;
    self.kttsTableView.hidden = YES;
}

- (void) showErrorServer {
    [[Common shareInstance] dismissCustomHUD];
    [self hideDetailTableView];
    soErrorView.hidden = NO;
}

- (void) showLostConnectKTTSView {
    [[Common shareInstance] dismissCustomHUD];
    soErrorView.hidden = NO;
    [self hideDetailTableView];
    [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Mất kết nối mạng") inView: self.kttsView];
}

- (void) showToastNotConnect {
    [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Mất kết nối mạng") inView: self.view];
}

- (void) showError {
    [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối với hệ thống" inView: self.view];
}

// MARK: - Filter Actions
- (IBAction)filterAction:(id)sender {
    [self.view endEditing:YES];
    NSArray *contentFilter = @[];
    switch (_Screen) {
        case 0: {
            contentFilter = @[@"Tất cả", @"Hỏng", @"Mất", @"Không sử dụng"];
            filterViewController = [[ContentFilterVC alloc] initWithFilterSelected:_filterTypeTTTS content:contentFilter];
        }
            break;
        case 1: {
            contentFilter = @[@"Tất cả", @"Chưa xác nhận", @"Đã xác nhận", @"Bị từ chối"];
            filterViewController = [[ContentFilterVC alloc] initWithFilterSelected:_filterTypeBBBG content:contentFilter];
        }
            break;
        default:
            break;
    }
    filterViewController.preferredContentSize = CGSizeMake(240, contentFilter.count*44);
    filterViewController.delegate = self;
    popoverController = [[WYPopoverController alloc] initWithContentViewController:filterViewController];
    popoverController.delegate = self;
    popoverController.passthroughViews = @[sender];
    popoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    popoverController.wantsDefaultContentAppearance = NO;
    [popoverController presentPopoverFromRect:_filterButton.bounds
                                       inView:sender
                     permittedArrowDirections:WYPopoverArrowDirectionAny
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
}

// MARK: - Delegate Filter
- (void)didSelectedFilterVC:(ContentFilterVC *)filterVC withFilterType:(NSInteger)filterType {
    switch (_Screen) {
        case 0: {
            _filterTypeTTTS = filterType;
            switch (filterType) {
                case 0:
                    //[self searchlocalwith:@""];
                    [self reloadTTTS];
                    break;
                case 1:
                    [self searchlocalwith:@"Hong"];
                    break;
                case 2:
                    [self searchlocalwith:@"Mat"];
                    break;
                case 3:
                    [self searchlocalwith:@"KSD"];
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            _filterTypeBBBG = filterType;
            switch (filterType) {
                case 0:
                    //[self searchlocalwith:@""];
                    [self reloadBBBG];
                    break;
                case 1:
                    [self filterStatus:IntToString(0)];
                    break;
                case 2:
                    [self filterStatus:IntToString(1)];
                    break;
                case 3:
                    [self filterStatus:IntToString(2)];
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    [popoverController dismissPopoverAnimated:YES];
}

// MARK: - Search Local Filter
- (void) filterStatus:(NSString *)status {
    _isFiltered = YES;
    NSPredicate *p = [NSPredicate predicateWithFormat:@"status = %d", status.integerValue];
    self.data_FilterBBBG = [self.api_data_BBBG filteredArrayUsingPredicate:p];
    [self.kttsTableView reloadData];
    self.recordTotal.text = IntToString(self.data_FilterBBBG.count);
    [self selectFirstTableView];
}

//MARK: - Send Request Actions
- (void) sendRequestConfirm {
//    KTTS_ConfirmProperty_iPad *confirmViewController = NEW_VC_FROM_NIB(KTTS_ConfirmProperty_iPad, @"KTTS_ConfirmProperty_iPad");
    UIStoryboard *storyboardConfirm = New_Storyboard(@"AssetConfirm");
    AssetConfirmViewController *confirmViewController = [storyboardConfirm instantiateViewControllerWithIdentifier:@"AssetConfirmViewController"];
    confirmViewController.delegate = self;
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:confirmViewController];
    propertyinfo = _TTTS_data[_index];
    confirmViewController.merEntityId = propertyinfo.merEntityId;
    
    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE - (SCREEN_WIDTH_LANDSCAPE/2), SCREEN_HEIGHT_LANDSCAPE - (SCREEN_HEIGHT_LANDSCAPE/2.5));
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.cornerRadius = 12;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

- (void) sendRequestCancel {
    KTTS_CancelStatus_VC_iPad *cancelViewController = NEW_VC_FROM_NIB(KTTS_CancelStatus_VC_iPad, @"KTTS_CancelStatus_VC_iPad");
    propertyinfo = _TTTS_data[_index];
    cancelViewController.merEntityId = IntToString(propertyinfo.merEntityId);
    cancelViewController.strStatus = propertyinfo.privateManagerName;
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:cancelViewController];
    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_HEIGHT_LANDSCAPE/2, SCREEN_WIDTH_LANDSCAPE/2 - 40);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.cornerRadius = 12;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

// MARK: - Show Content BBBG
- (void) showContentBBBGWithArray:(DetailBBBGModel *)array {
    KTTS_ContentAssetBBBG_VC_iPad *contentAssetViewController = NEW_VC_FROM_NIB(KTTS_ContentAssetBBBG_VC_iPad, @"KTTS_ContentAssetBBBG_VC_iPad");
    
    contentAssetViewController.goods_name = array.catMerName;
    contentAssetViewController.minuteHandOverId = IntToString(array.minuteHandOverId);
    contentAssetViewController.isStatus = array.stt;
    contentAssetViewController.value_commodity_code = array.stationCode;
    contentAssetViewController.value_commodity_name = array.catMerName;
    contentAssetViewController.value_unit = array.unitName;
    contentAssetViewController.value_number = IntToString(array.count);
    contentAssetViewController.value_serial = array.serialNumber;
    contentAssetViewController.value_manufacturer = array.companyName;
    contentAssetViewController.value_aspect = array.statusName;
    
    NSDate *date_1 = [NSDate dateWithTimeIntervalSince1970: (array.minuteHandOverDate/1000)];
    NSDateFormatter *format_1 = [NSDateFormatter new];
    [format_1 setDateFormat: @"dd/MM/yyyy"];
    contentAssetViewController.value_expiry_date = [format_1 stringFromDate:date_1];
    contentAssetViewController.value_asset_type = array.stationCode;
    NSDate *date_2 = [NSDate dateWithTimeIntervalSince1970: (array.usedDate/1000)];
    NSDateFormatter *format_2 = [NSDateFormatter new];
    [format_2 setDateFormat: @"dd/MM/yyyy"];
    contentAssetViewController.value_use_time = [format_2 stringFromDate:date_2];
    contentAssetViewController.value_price = IntToString(array.assetPrice);
    //    propertyDetails.value_status = detailBBBGModel.privateManagerName;
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:contentAssetViewController];
    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE - (SCREEN_WIDTH_LANDSCAPE/2.4), SCREEN_HEIGHT_LANDSCAPE - (SCREEN_HEIGHT_LANDSCAPE/2.5));
    //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.cornerRadius = 12;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

#pragma mark - AssetConfirmViewControllerDelegate

- (void)successAssetConfirmVC {
    [[[MZFormSheetController formSheetControllersStack] lastObject] dismissAnimated:YES completionHandler:nil];
}

- (void)errorAssetConfirmVC {
    //[[[MZFormSheetController formSheetControllersStack] lastObject] dismissAnimated:YES completionHandler:nil];
    DLog(@"errorAssetConfirmVC");
}

@end
