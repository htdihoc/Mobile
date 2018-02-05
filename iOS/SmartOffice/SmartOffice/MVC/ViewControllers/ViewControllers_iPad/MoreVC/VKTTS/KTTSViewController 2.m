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

@interface KTTSViewController () <UITableViewDelegate, UITableViewDataSource, SOSearchBarViewDelegate, SOErrorViewDelegate> {
    DetailTTTSCell *tttsCell;
    BBBGTableViewCell *bbbgCell;
    SOErrorView *soErrorView;
}

@property (nonatomic) int Screen;
@property (nonatomic) int limit, startTTTS, startBBBG, limitTTTS, limitBBBG;
@property (strong, nonatomic) NSMutableArray *api_data_TTTS, *api_data_BBBG, *api_data_detailBBBG;
@property (strong, nonatomic) NSArray *data_FilterTTTS, *data_FilterBBBG;
@property (strong, nonatomic) NSMutableArray *TTTS_data, *BBBG_data;
@property (nonatomic) int TTTS_RecordTotal, BBBG_RecordTotal, countDetailBBBG;
@property (nonatomic) bool isloadmoreTTTS, isloadmoreBBBG;
@property (nonatomic) BOOL isFiltered, isDetailFilter, isSelect;

@end

@implementation KTTSViewController

- (void)viewWillAppear:(BOOL)animated {
    [self countRecordTotal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _Screen = 0;
    _limit = 20;
    _startTTTS = 0;
    _startBBBG = 0;
    _api_data_TTTS = [NSMutableArray new];
    _api_data_BBBG = [NSMutableArray new];
    _api_data_detailBBBG = [NSMutableArray new];
    _TTTS_data = [NSMutableArray new];
    _BBBG_data = [NSMutableArray new];
    _data_FilterTTTS = [NSArray new];
    _data_FilterBBBG = [NSArray new];
    self.isloadmoreTTTS = true;
    self.isloadmoreBBBG = true;
    self.search_view.searchBar.placeholder = LocalizedString(@"SearchSerial...");
    self.detailSearchView.searchBar.placeholder = LocalizedString(@"SearchSerial.");
    self.kttsTableView.rowHeight = UITableViewAutomaticDimension;
    self.kttsTableView.estimatedRowHeight = 180;
    self.detailKTTSTableView.rowHeight = UITableViewAutomaticDimension;
    self.detailKTTSTableView.estimatedRowHeight = 590;
    [self hideDetailTableView];
    
    self.search_view.delegate = self;
    self.detailSearchView.delegate = self;
}

- (void) showErrorView {
    soErrorView = (SOErrorView *)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    soErrorView.delegate = self;
    soErrorView.frame = self.kttsView.bounds;
    soErrorView.lblErrorInfo.text = @"Mất kết nối hệ thống";
    [self.view addSubview:soErrorView];
    soErrorView.hidden = YES;
}

- (void)didRefreshOnErrorView:(SOErrorView *)errorView {
    [self reloadDataTableView];
}

- (void) countRecordTotal {
    [self TTTS];
    [self BBBG];
}

- (void) TTTS {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"169202",
                                @"type": @"1"
                                };
    [KTTSProcessor postCountDataTTTS:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        self.limitTTTS = [result[@"return"] intValue];
        self.recordTotal.text = IntToString(self.limitTTTS);
        [self getDataTTTS];
    } onError:^(NSString *Error) {
        [self showErrorServer];
    } onException:^(NSString *Exception) {
        [self showLostConnectKTTSView];
    }];
}

- (void) BBBG {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"169202",
                                @"type": @"2"
                                };
    [KTTSProcessor postCountDataTTTS:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        self.limitBBBG = [result[@"return"] intValue];
        [self getDataBBBG];
    } onError:^(NSString *Error) {
        [self showErrorServer];
    } onException:^(NSString *Exception) {
        [self showLostConnectKTTSView];
    }];
}

// MARK: - Request Data Thông tin tài sản
- (void) getDataTTTS {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"169202",
                                @"start": IntToString(_startTTTS),
                                @"keyword": _search_view.searchBar.text,
                                @"limit": IntToString(_limit)
                                };
    [KTTSProcessor postKTTS_THONG_TIN_TAI_SAN:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSArray *array = result[@"listMerEntity"];
        [self.api_data_TTTS addObjectsFromArray:array];
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
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"169202",
                                @"start": IntToString(self.startBBBG),
                                @"keyword": _search_view.searchBar.text,
                                @"limit": IntToString(self.limit)
                                };
    [KTTSProcessor postKTTS_BBBG:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSArray *array = result[@"listMinuteHandOver"];
        [self.api_data_BBBG addObjectsFromArray:array];
        [self.kttsTableView reloadData];
        [self selectFirstTableView];
    } onError:^(NSString *Error) {
        [self showErrorServer];
    } onException:^(NSString *Exception) {
        [self showLostConnectKTTSView];
    }];
}

- (void) getCountDataDetailBBBG:(NSInteger)sender {
    [[Common shareInstance] showCustomHudInView:self.view];
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
        
    } onException:^(NSString *Exception) {
        
    }];
}

- (void) getDataDetailBBBG:(NSInteger)sender {
    [[Common shareInstance] showCustomHudInView:self.view];
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
        //
    } onException:^(NSString *Exception) {
        //
    }];
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
                return _api_data_detailBBBG.count;
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
                // title
                kttsCell.title_name.text = @"Tên tài sản:";
                kttsCell.titleNumberAndDate.text = @"Số lượng:";
                kttsCell.title_SerialAndName.text = @"Serial:";
                
                // value
                
                _TTTS_data = [PropertyInfoModel arrayOfModelsFromDictionaries:self.api_data_TTTS error:nil];
                
                PropertyInfoModel *propertyinfo = _TTTS_data[indexPath.row];
                
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
                
                // title
                kttsCell.title_name.text = @"Mã BBBG:";
                kttsCell.titleNumberAndDate.text = @"Ngày bàn giao:";
                kttsCell.title_SerialAndName.text = @"Người bàn giao:";
                
                // value
                
                _BBBG_data = [BBBGAssetModel arrayOfModelsFromDictionaries:_api_data_BBBG error:nil];
                
                BBBGAssetModel *bbbg = _BBBG_data[indexPath.row];
                
                kttsCell.value_goods_name.text = bbbg.minuteHandOverCode;
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: (bbbg.minuteHandOverDate/1000)];
                NSDateFormatter *format = [NSDateFormatter new];
                [format setDateFormat: @"dd/MM/yyyy"];
                kttsCell.titleNumberAndDate.text = [format stringFromDate:date];
                
                kttsCell.value_serial.text = bbbg.employeeMinuteHandOVerName;
                
                switch (bbbg.status) {
                    case 0: {
                        kttsCell.value_status.text = @"Đã bàn giao";
                        kttsCell.value_status.textColor = RGB(254, 94, 8);
                    }
                        break;
                    case 1: {
                        kttsCell.value_status.text = @"Đã xác nhận";
                        kttsCell.value_status.textColor = RGB(2, 127, 185);
                    }
                        break;
                    case 2: {
                        kttsCell.value_status.text = @"Đã từ chối";
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
        
        [self.kttsTableView addPullToRefreshWithActionHandler:^{
            [self.kttsTableView.pullToRefreshView stopAnimating];
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
                bbbgCell.value_cell_number.text = IntToString(indexPath.row+1);
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
    switch (_Screen) {
        case 0: {
            PropertyInfoModel *propertyinfo = _TTTS_data[indexPath.row];
            [tttsCell setDataWithArray:propertyinfo];
        }
            break;
        case 1: {
            // MARK: - GET Data Detail BBBG.
            BBBGAssetModel *bbbgModel = _BBBG_data[indexPath.row];
            [self getCountDataDetailBBBG:bbbgModel.minuteHandOverId];
        }
            break;
        default:
            break;
    }
}

// MARK: - Segment Action
- (IBAction)segmentAction:(id)sender {
    _isSelect = NO;
    NSInteger selectedIndex = self.segment.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            _Screen = 0;
            self.recordTotal.text = IntToString(_limitTTTS);
            self.searchview_detail_constraint.constant = 0;
            break;
        case 1:
            _Screen = 1;
            self.recordTotal.text = IntToString(_limitBBBG);
            self.searchview_detail_constraint.constant = 50;
            break;
        default:
            break;
    }
    [self.detailKTTSTableView reloadData];
    [self.kttsTableView reloadData];
    [self.view layoutIfNeeded];
    [self selectFirstTableView];
}

// MARK: - Search local
-(BOOL)textFieldShouldClear:(UITextField *)textField {
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
        [self searchlocalwith:searchText];
    } else if (textField == self.detailSearchView.searchBar) {
        [self searchDetailLocalWith:searchText];
    }
}

- (void) searchDetailLocalWith:(NSString *) searchText {
    if (searchText.length == 0) {
        _isDetailFilter = NO;
        [self.detailKTTSTableView reloadData];
    } else {
        _isDetailFilter = YES;
//        NSPredicate *p = [NSPredicate predicateWithFormat:@"catMerName CONTAINS[cd] %@ or serialNumber CONTAINS[cd] %@ or privateManagerName CONTAINS[cd] %@", searchText, searchText, searchText];
        // tiep.vu todo...
    }
}

- (void) searchlocalwith:(NSString *)searchText {
    switch (_Screen) {
        case 0:
        {
            if (searchText.length == 0) {
                _isFiltered = NO;
                [self.kttsTableView reloadData];
                [self selectFirstTableView];
            } else {
                _isFiltered = YES;
                NSPredicate *p = [NSPredicate predicateWithFormat:@"catMerName CONTAINS[cd] %@ or serialNumber CONTAINS[cd] %@ or privateManagerName CONTAINS[cd] %@", searchText, searchText, searchText];
                self.data_FilterTTTS = [self.api_data_TTTS filteredArrayUsingPredicate:p];
                [self.kttsTableView reloadData];
                [self selectFirstTableView];
            }
        }
            break;
        case 1:
        {
            if (searchText.length == 0) {
                _isFiltered = NO;
                [self.kttsTableView reloadData];
                [self selectFirstTableView];
            } else {
                _isFiltered = YES;
                NSPredicate *p = [NSPredicate predicateWithFormat:@"minuteHandOverCode CONTAINS[cd] %@ or employeeMinuteHandOVerName CONTAINS[cd] %@", searchText, searchText];
                self.data_FilterBBBG = [self.api_data_BBBG filteredArrayUsingPredicate:p];
                [self.kttsTableView reloadData];
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
                    [self selectFirstRow];
                } else {
                    [self hideDetailTableView];
                }
                break;
            case 1:
                if (self.api_data_BBBG.count > 0) {
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
    self.startTTTS = 0;
    self.startBBBG = 0;
    switch (_Screen) {
        case 0:
            [self.api_data_TTTS removeAllObjects];
            [self TTTS];
            break;
        case 1:
            [self.api_data_BBBG removeAllObjects];
            [self BBBG];
            break;
        default:
            break;
    }
    [self.kttsTableView reloadData];
}

- (void) selectFirstRow {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (self.isSelect == NO) {
        [self.kttsTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        self.isSelect = YES;
    } else {
        [self.kttsTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    [self tableView:self.kttsTableView didSelectRowAtIndexPath:indexPath];
    [self showDetailTableView];
}

- (void) showDetailTableView {
    self.detailKTTSView.hidden = NO;
    self.kttsView.hidden = NO;
}

- (void) hideDetailTableView {
    self.detailKTTSView.hidden = YES;
    self.kttsView.hidden = YES;
}

- (void) showErrorServer {
    [[Common shareInstance] dismissCustomHUD];
    soErrorView.hidden = NO;
    self.kttsView.hidden = YES;
    
}

- (void) showLostConnectKTTSView {
    [[Common shareInstance] dismissCustomHUD];
    soErrorView.hidden = NO;
    self.kttsView.hidden = YES;
}

@end
