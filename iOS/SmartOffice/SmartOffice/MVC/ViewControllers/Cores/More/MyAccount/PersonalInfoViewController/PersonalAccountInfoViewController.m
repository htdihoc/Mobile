//
//  PersonalInfoViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "PersonalAccountInfoViewController.h"
#import "PersonalAccInfoCell.h"
#import "PropertyDetailsViewController.h"
#import "BBBGAssetViewController.h"
#import "PropertyInfoModel.h"
#import "BBBGAssetModel.h"
#import "KTTSProcessor.h"
#import "Common.h"
#import "SOErrorView.h"
#import "ContentFilterVC.h"
#import "WYPopoverController.h"
#import "SVPullToRefresh.h"
#import "Reachability.h"

@interface PersonalAccountInfoViewController () <UITableViewDataSource, UITableViewDelegate, TTNS_BaseNavViewDelegate, SOErrorViewDelegate, WYPopoverControllerDelegate, ContentFilterVCDelegate, SOSearchBarViewDelegate, UITextFieldDelegate> {
    SOErrorView *soErrorView;
    WorkFilterType _filterTypeTTTS;
    WorkFilterType _filterTypeBBBG;
    WYPopoverController *popoverController;
    UIButton *rightButton;
    ContentFilterVC *filterViewController;
}
//personalAccInfoTableView
@property (weak, nonatomic) IBOutlet UILabel *total_record;
@property (weak, nonatomic) IBOutlet UITableView *infoAssetsTableView;
@property (weak, nonatomic) IBOutlet UITableView *bbbgAssetsTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentview;
@property (nonatomic) int switchScreen;
@property (strong, nonatomic) NSMutableArray *TTTS_data_array, *BBBG_data_array;
@property (strong, nonatomic) NSMutableArray *dataBBBGArr;
@property (strong, nonatomic) NSArray *filterDataBBBGArr;
@property (strong, nonatomic) NSMutableArray *data_TTTS, *data_BBBG;
@property (assign, nonatomic) NSInteger countTTTS, countBBBG;
@property (nonatomic) bool isloadmoreTTTS, isloadmoreBBBG;
@property (assign, nonatomic) NSInteger startTTTS, startBBBG, limit;
@property (strong, nonatomic) NSArray *data_FilterTTTS, *data_FilterBBBG;
@property (strong, nonatomic) NSMutableArray *data_TTTS_First, *data_BBBG_First;
@property (nonatomic) BOOL isFiltered;

@end

@implementation PersonalAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchview.delegate = self;
    self.searchview.searchBar.placeholder = LocalizedString(@"SearchSerial...");
    self.noResultLabel.hidden = YES;
    
    self.startTTTS = 0;
    self.startBBBG = 0;
    self.limit = 20;
    self.isloadmoreTTTS = true;
    self.isloadmoreBBBG = true;
    [self initErrorView];
    
    self.label_Badge.clipsToBounds = YES;
    self.label_Badge.layer.cornerRadius = 8;
    
    self.dataBBBGArr = [NSMutableArray new];
    self.TTTS_data_array = [NSMutableArray new];
    self.BBBG_data_array = [NSMutableArray new];
    self.data_TTTS = [NSMutableArray new];
    self.data_BBBG = [NSMutableArray new];
    self.data_FilterTTTS = [NSArray new];
    self.data_FilterBBBG = [NSArray new];
    self.data_TTTS_First = [NSMutableArray new];
    self.data_BBBG_First = [NSMutableArray new];
    self.infoAssetsTableView.estimatedRowHeight = 190;
    self.infoAssetsTableView.rowHeight = UITableViewAutomaticDimension;
    self.bbbgAssetsTableView.estimatedRowHeight = 190;
    self.bbbgAssetsTableView.rowHeight = UITableViewAutomaticDimension;
    self.switchScreen = 0;
    self.backTitle = @"Thông tin tài sản cá nhân";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    [[Common shareInstance] showCustomHudInView:self.view];
    [self reloadAllData];
    
    NSDictionary *parameter = @{
                                @"employeeId": @"102026",
                                @"start": IntToString(self.startBBBG),
                                @"keyword": self.searchview.text,
                                @"limit": IntToString(1000)
                                };
    [KTTSProcessor postKTTS_BBBG:parameter handle:^(id result, NSString *error) {
        NSArray *array = result[@"listMinuteHandOver"];

        [self.dataBBBGArr addObjectsFromArray:array];
        NSPredicate *p = [NSPredicate predicateWithFormat:@"status = %d", 0];
        self.filterDataBBBGArr = [self.dataBBBGArr filteredArrayUsingPredicate:p];
        self.label_Badge.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.filterDataBBBGArr.count];
        if(self.filterDataBBBGArr.count == 0){
            self.label_Badge.hidden = YES;
        }else {
            self.label_Badge.hidden = NO;
        }
    } onError:^(NSString *Error) {
    } onException:^(NSString *Exception) {
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        float fractionalPage = scrollView.contentOffset.x / scrollView.frame.size.width;
        NSInteger page = lround(fractionalPage);
        if (page == 0) {
            self.segmentview.selectedSegmentIndex = 0;
            [self segmentAction:nil];
        }else if (page == 1){
            self.segmentview.selectedSegmentIndex = 1;
            [self segmentAction:nil];
        }
    }
    
}

- (void) initErrorView {
    soErrorView = (SOErrorView *)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    soErrorView.delegate = self;
    soErrorView.frame = CGRectMake(0, 0, self.contentview.frame.size.width, self.contentview.frame.size.height);
    soErrorView.lblErrorInfo.text = @"Mất kết nối hệ thống";
    [self.contentview addSubview:soErrorView];
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
    self.startTTTS = 0;
    self.startBBBG = 0;
    [self.TTTS_data_array removeAllObjects];
    [self.BBBG_data_array removeAllObjects];
    [self getDataTTTS];
    [self getDataBBBG];
    [self dismissKeyboard];
    return YES;
}

- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText {
    NSString *tmpSearchText = [searchText stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    [self searchlocalwith:tmpSearchText];
}

- (void) searchlocalwith:(NSString *)searchText {
    switch (self.switchScreen) {
        case 0:
        {
            if (searchText.length == 0) {
                _isFiltered = NO;
                [self.infoAssetsTableView reloadData];
                [self.bbbgAssetsTableView reloadData];
                self.total_record.text = IntToString(self.countTTTS);

                if (self.countTTTS > 0) {
                    self.noResultLabel.hidden = YES;
                }else{
                    self.noResultLabel.hidden = NO;
                }
            } else {
                _isFiltered = YES;
                NSPredicate *p = [NSPredicate predicateWithFormat:@"catMerName CONTAINS[cd] %@ or serialNumber CONTAINS[cd] %@ or privateManagerName CONTAINS[cd] %@", searchText, searchText, searchText];
                self.data_FilterTTTS = [self.TTTS_data_array filteredArrayUsingPredicate:p];
                [self.infoAssetsTableView reloadData];
                [self.bbbgAssetsTableView reloadData];
                self.total_record.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.data_FilterTTTS.count];

                if (self.data_FilterTTTS.count > 0) {
                    self.noResultLabel.hidden = YES;
                }else{
                    self.noResultLabel.hidden = NO;
                }
            }
        }
            break;
        case 1:
        {
            if (searchText.length == 0) {
                _isFiltered = NO;
                [self.infoAssetsTableView reloadData];
                [self.bbbgAssetsTableView reloadData];
                self.total_record.text = IntToString(self.countBBBG);
                if (self.countBBBG > 0) {
                    self.noResultLabel.hidden = YES;
                }else{
                    self.noResultLabel.hidden = NO;
                }
            } else {
                _isFiltered = YES;
                NSPredicate *p = [NSPredicate predicateWithFormat:@"minuteHandOverCode CONTAINS[cd] %@ or employeeMinuteHandOVerName CONTAINS[cd] %@", searchText, searchText];
                self.data_FilterBBBG = [self.BBBG_data_array filteredArrayUsingPredicate:p];
                [self.infoAssetsTableView reloadData];
                [self.bbbgAssetsTableView reloadData];
                self.total_record.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.data_FilterBBBG.count];
                if (self.data_FilterBBBG.count > 0) {
                    self.noResultLabel.hidden = YES;
                }else{
                    self.noResultLabel.hidden = NO;
                }
            }
        }
        default:
            break;
    }
}

- (void) filterStatus:(NSString *)status {

        [self.BBBG_data_array removeAllObjects];
        NSDictionary *parameter = @{
                                    @"employeeId": @"102026",
                                    @"start": IntToString(self.startBBBG),
                                    @"keyword": self.searchview.text,
                                    @"limit": IntToString(1000)
                                    };
        [KTTSProcessor postKTTS_BBBG:parameter handle:^(id result, NSString *error) {
            [[Common shareInstance] dismissCustomHUD];
            NSArray *array = result[@"listMinuteHandOver"];

            [self.BBBG_data_array addObjectsFromArray:array];

            //Filler
            _isFiltered = YES;
            NSPredicate *p = [NSPredicate predicateWithFormat:@"status = %d", status.integerValue];
            self.data_FilterBBBG = [self.BBBG_data_array filteredArrayUsingPredicate:p];
            [self.infoAssetsTableView reloadData];
            [self.bbbgAssetsTableView reloadData];
            self.total_record.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.data_FilterBBBG.count];
            if (self.data_FilterBBBG.count > 0) {
                self.noResultLabel.hidden = YES;
            }else{
                self.noResultLabel.hidden = NO;
            }
            
            [self.bbbgAssetsTableView reloadData];
        } onError:^(NSString *Error) {
            [self errorServerTTTS];
        } onException:^(NSString *Exception) {
            [self donotInternet];
        }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

- (void) addRightBarButton {
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 200, 44);
    [rightButton setImage:[UIImage imageNamed:@"filter_iphone"] forState:UIControlStateNormal];
    [self.navView addRightBarButton:rightButton isButtonTile:NO];
}

- (void)didTapRightButton {
    if (popoverController.popoverVisible) {
        [popoverController dismissPopoverAnimated:YES];
        return;
    }
    NSArray *contentFilter = @[];
    switch (self.switchScreen) {
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
    filterViewController.delegate = self;
    filterViewController.preferredContentSize = CGSizeMake(240, contentFilter.count*44);
    filterViewController.modalInPopover = NO;
    popoverController = [[WYPopoverController alloc] initWithContentViewController:filterViewController];
    popoverController.passthroughViews = @[rightButton];
    popoverController.delegate = self;
    popoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    popoverController.wantsDefaultContentAppearance = NO;
    
    [popoverController presentPopoverFromRect:rightButton.bounds
                                       inView:rightButton
                     permittedArrowDirections:WYPopoverArrowDirectionAny
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
}

- (void)didSelectedFilterVC:(ContentFilterVC *)filterVC withFilterType:(NSInteger)filterType {
    switch (self.switchScreen) {
        case 0:
        {
            _filterTypeTTTS = filterType;
            switch (filterType) {
                case 0:
                    [self searchlocalwith:@""];
                    break;
                case 1:
                    [self searchlocalwith:@"Hỏng"];
                    break;
                case 2:
                    [self searchlocalwith:@"Mất"];
                    break;
                case 3:
                    [self searchlocalwith:@"KSD"];
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            _filterTypeBBBG = filterType;
            switch (filterType) {
                case 0:
                    [self searchlocalwith:@""];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addRightBarButton];
}

- (void) errorServerTTTS {
    soErrorView.hidden = NO;
    self.infoAssetsTableView.hidden = NO;
    self.bbbgAssetsTableView.hidden = NO;
    [[Common shareInstance] dismissCustomHUD];
}

- (void) donotInternet {
    soErrorView.hidden = NO;
    self.infoAssetsTableView.hidden = NO;
    self.bbbgAssetsTableView.hidden = NO;
    [[Common shareInstance] dismissCustomHUD];
    [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối mạng" inView: self.contentview];
}

- (void) didRefreshOnErrorView:(SOErrorView *)errorView {
    [self reloadAllData];
}

- (void) reloadAllData {
    [self countDataTTTS];
    [self countDataBBBG];
}

- (void) countDataTTTS {
//    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"102026",
                                @"type": @"1"
                                };
    [KTTSProcessor postCountDataTTTS:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        self.countTTTS = [result[@"return"] integerValue];
        self.infoAssetsTableView.hidden = NO;
        [self getDataTTTS];
    } onError:^(NSString *Error) {
        [self errorServerTTTS];
    } onException:^(NSString *Exception) {
        [self donotInternet];
    }];
}

- (void) countDataBBBG {
//    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"102026",
                                @"type": @"2"
                                };
    [KTTSProcessor postCountDataTTTS:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        self.countBBBG = [result[@"return"] integerValue];
        self.bbbgAssetsTableView.hidden = NO;
        [self getDataBBBG];
    } onError:^(NSString *Error) {
        [self errorServerTTTS];
    } onException:^(NSString *Exception) {
        [self donotInternet];
    }];
}
//PropertyInfoModel
- (void) getDataTTTS {
//    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"102026",
                                @"start": IntToString(self.startTTTS),
                                @"keyword": self.searchview.searchBar.text,
                                @"limit": IntToString(self.limit)
                                };
    [KTTSProcessor postKTTS_THONG_TIN_TAI_SAN:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSArray *array = result[@"listMerEntity"];
        if (self.data_TTTS_First.count == 0) {
            [self.data_TTTS_First addObjectsFromArray:array];
            [self.TTTS_data_array addObjectsFromArray:array];
        }else{
            if ([self.data_TTTS_First isEqualToArray:array]) {
                
            }else{
                [self.TTTS_data_array addObjectsFromArray:array];
            }
        }

        if (self.switchScreen == 0) {
            self.total_record.text = IntToString(self.countTTTS);
            if (self.countTTTS > 0) {
                self.noResultLabel.hidden = YES;
            } else {
                self.noResultLabel.hidden = NO;
            }
        }
        [self.infoAssetsTableView reloadData];
    } onError:^(NSString *Error) {
        [self errorServerTTTS];
    } onException:^(NSString *Exception) {
        [self donotInternet];
    }];
}
//BBBGAssetModel
- (void) getDataBBBG {
//    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"102026",
                                @"start": IntToString(self.startBBBG),
                                @"keyword": self.searchview.text,
                                @"limit": IntToString(self.limit)
                                };
    [KTTSProcessor postKTTS_BBBG:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSArray *array = result[@"listMinuteHandOver"];

        if (self.data_BBBG_First.count == 0) {
            [self.data_BBBG_First addObjectsFromArray:array];
            [self.BBBG_data_array addObjectsFromArray:array];
        }else{
            if ([self.data_BBBG_First isEqualToArray:array]) {
                
            }else{
                [self.BBBG_data_array addObjectsFromArray:array];
            }
        }
        
        if (self.switchScreen == 1) {
            self.total_record.text = IntToString(self.countBBBG);
            if (self.countBBBG > 0) {
                self.noResultLabel.hidden = YES;
            } else {
                self.noResultLabel.hidden = NO;
            }
        }
        [self.bbbgAssetsTableView reloadData];
    } onError:^(NSString *Error) {
        [self errorServerTTTS];
    } onException:^(NSString *Exception) {
        [self donotInternet];
    }];
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.infoAssetsTableView) {
        if (_isFiltered) {
            return self.data_FilterTTTS.count;
        } else {
            return self.TTTS_data_array.count;
        }
    } else if (tableView == self.bbbgAssetsTableView) {
        if (_isFiltered) {
            return self.data_FilterBBBG.count;
        } else {
            return self.BBBG_data_array.count;
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"personalAccInfoCell";
    PersonalAccInfoCell *personalAccInfoCell = (PersonalAccInfoCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    [personalAccInfoCell.lb_goods_name sizeToFit];
    personalAccInfoCell.selectionStyle = UIAccessibilityTraitNone;
    personalAccInfoCell.lb_cell_number.text = IntToString(indexPath.row+1);
    
    if (tableView == self.infoAssetsTableView) {
        if (!_isFiltered) {
            self.data_TTTS = [PropertyInfoModel arrayOfModelsFromDictionaries:self.TTTS_data_array error:nil];
        } else {
            self.data_TTTS = [PropertyInfoModel arrayOfModelsFromDictionaries:self.data_FilterTTTS error:nil];
        }
        
        PropertyInfoModel *propertyinfo = self.data_TTTS[indexPath.row];
        
        // title
        personalAccInfoCell.title_goods_name.text = @"Tên hàng hóa:";
        personalAccInfoCell.title_number.text = @"Số lượng:";
        personalAccInfoCell.title_serial.text = @"Serial:";
        personalAccInfoCell.lb_status.text = @"Trạng thái:";
        
        // value
        personalAccInfoCell.lb_goods_name.text = propertyinfo.catMerName;
        personalAccInfoCell.lb_number.text = IntToString(propertyinfo.count);
        personalAccInfoCell.lb_serial.text = propertyinfo.serialNumber;
        personalAccInfoCell.lb_status.text = propertyinfo.privateManagerName;
        
        personalAccInfoCell.lb_status.textColor = RGB(254, 94, 8);
        
        if (indexPath.row == self.TTTS_data_array.count - 1) {
            [self loadmoreTableView];
        }
    } else if (tableView == self.bbbgAssetsTableView) {
        if (!_isFiltered) {
            self.data_BBBG = [BBBGAssetModel arrayOfModelsFromDictionaries:self.BBBG_data_array error:nil];
        } else {
            self.data_BBBG = [BBBGAssetModel arrayOfModelsFromDictionaries:self.data_FilterBBBG error:nil];
        }
        
        BBBGAssetModel *bbbg = self.data_BBBG[indexPath.row];
        
        // title
        personalAccInfoCell.title_goods_name.text = @"Mã BBBG:";
        personalAccInfoCell.title_number.text = @"Ngày bàn giao:";
        personalAccInfoCell.title_serial.text = @"Người bàn giao:";
        personalAccInfoCell.lb_status.text = @"Trạng thái:";
        
        // value
        personalAccInfoCell.lb_goods_name.text = bbbg.minuteHandOverCode;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: (bbbg.minuteHandOverDate/1000)];
        NSDateFormatter *format = [NSDateFormatter new];
        [format setDateFormat: @"dd/MM/yyyy"];
        personalAccInfoCell.lb_number.text = [format stringFromDate:date];
        
        personalAccInfoCell.lb_serial.text = bbbg.employeeMinuteHandOVerName;
        
        switch (bbbg.status) {
            case 0:
            {
                personalAccInfoCell.lb_status.text = @"Chưa xác nhận";
                personalAccInfoCell.lb_status.textColor = RGB(254, 94, 8);
            }
                break;
            case 1:
            {
                personalAccInfoCell.lb_status.text = @"Đã xác nhận";
                personalAccInfoCell.lb_status.textColor = RGB(2, 127, 185);
            }
                break;
            case 2:
            {
                personalAccInfoCell.lb_status.text = @"Bị từ chối";
                personalAccInfoCell.lb_status.textColor = RGB(254, 8, 8);
            }
                break;
            default:
            {
                personalAccInfoCell.lb_status.text = @"Không xác định";
            }
                break;
        }
        
        if (indexPath.row == self.BBBG_data_array.count - 1) {
            [self loadmoreTableView];
        }
    } else {
        
    }
    
    personalAccInfoCell.cell_view_detail.tag = indexPath.row;
    [personalAccInfoCell.cell_view_detail addTarget:self action:@selector(viewDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.infoAssetsTableView addPullToRefreshWithActionHandler:^{
        [self.infoAssetsTableView.pullToRefreshView stopAnimating];
        self.isloadmoreBBBG = true;
        self.isloadmoreTTTS = true;
        [self reloadDataTableView];
    }];
    [self.bbbgAssetsTableView addPullToRefreshWithActionHandler:^{
        [self.bbbgAssetsTableView.pullToRefreshView stopAnimating];
        self.isloadmoreBBBG = true;
        self.isloadmoreTTTS = true;
        [self reloadDataTableView];
    }];
    
    return personalAccInfoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushWith:indexPath.row];
}

- (void) reloadDataTableView {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối mạng" inView: self.view];
    } else {
//        self.startTTTS = 0;
//        self.startBBBG = 0;
        switch (self.switchScreen) {
            case 0:
//                [self.TTTS_data_array removeAllObjects];
                if(self.startTTTS < self.countTTTS){
                    [self countDataTTTS];
                }
                break;
            case 1:
//                [self.BBBG_data_array removeAllObjects];
                if(self.startBBBG < self.countBBBG){
                    [self countDataBBBG];
                }
                break;
            default:
                break;
        }
        [self.infoAssetsTableView reloadData];
        [self.bbbgAssetsTableView reloadData];
    }
}

// load more.
- (void)loadmoreTableView {
    switch (self.switchScreen) {
        case 0:
        {
            if (self.startTTTS < self.countTTTS && self.isloadmoreTTTS == true) {
                self.startTTTS = self.startTTTS + 20;
                [self getDataTTTS];
            } else {
                self.isloadmoreTTTS = false;
            }
        }
            break;
        case 1:
        {
            if (self.startBBBG < self.countBBBG && self.isloadmoreBBBG == true) {
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

- (IBAction)segmentAction:(id)sender {
    NSUInteger selectedSegment = self.segmentview.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:
        {
            self.switchScreen = 0;
            self.searchview.searchBar.placeholder = LocalizedString(@"SearchSerial...");
            if (_isFiltered) {
                self.total_record.text = IntToString(self.data_FilterTTTS.count);
                if (self.data_FilterTTTS.count > 0) {
                    self.noResultLabel.hidden = YES;
                } else {
                    self.noResultLabel.hidden = NO;
                }
            } else {
                self.total_record.text = IntToString(self.countTTTS);
                if (self.countTTTS > 0) {
                    self.noResultLabel.hidden = YES;
                } else {
                    self.noResultLabel.hidden = NO;
                }
            }
//            [self.infoAssetsTableView reloadData];

                NSLog(@"XEM LAI FRAME NHE:%@", NSStringFromCGRect(self.infoAssetsTableView.frame));
                [self.scrollView scrollRectToVisible:self.infoAssetsTableView.frame animated:YES];
                [UIView animateWithDuration:0.3f animations:^{
                    [self.view layoutIfNeeded];
                }];

        }
            break;
        case 1:
        {
            self.switchScreen = 1;
            self.searchview.searchBar.placeholder = LocalizedString(@"SearchCodeBBBG");
            if (_isFiltered) {
                self.total_record.text = IntToString(self.data_FilterBBBG.count);
                if (self.data_FilterBBBG.count > 0) {
                    self.noResultLabel.hidden = YES;
                } else {
                    self.noResultLabel.hidden = NO;
                }
            } else {
                self.total_record.text = IntToString(self.countBBBG);
                if (self.countBBBG > 0) {
                    self.noResultLabel.hidden = YES;
                } else {
                    self.noResultLabel.hidden = NO;
                }
            }
//            [self.bbbgAssetsTableView reloadData];
            NSLog(@"XEM LAI FRAME NHE:%@", NSStringFromCGRect(self.bbbgAssetsTableView.frame));
            [self.scrollView scrollRectToVisible:self.bbbgAssetsTableView.frame animated:YES];
            [UIView animateWithDuration:0.3f animations:^{
                [self.view layoutIfNeeded];
            }];
        }
            break;
        default:
            break;
    }
}

- (void) viewDetailAction:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    //NSLog(@"%ld", (long)button.tag);
    [self pushWith:button.tag];
    
}

- (void) pushWith:(NSInteger)index {
    switch (self.switchScreen) {
        case 0:
        {
            PropertyInfoModel *propertyinfo = self.data_TTTS[index];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyDetails" bundle:nil];
            PropertyDetailsViewController *propertyDetails = (PropertyDetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PropertyDetailsViewController"];
            propertyDetails.isStatus = propertyinfo.stt;
            propertyDetails.typeKTTS = 1;
            propertyDetails.value_commodity_code = propertyinfo.catMerCode;
            propertyDetails.value_commodity_name = propertyinfo.catMerName;
            propertyDetails.value_unit = propertyinfo.unitName;
            propertyDetails.value_number = IntToString(propertyinfo.count);
            propertyDetails.value_serial = propertyinfo.serialNumber;
            propertyDetails.value_manufacturer = propertyinfo.companyName;
            propertyDetails.value_aspect = propertyinfo.statusName;
            propertyDetails.merEntityId = propertyinfo.merEntityId;
            
            NSDate *date_asset_type = [NSDate dateWithTimeIntervalSince1970: (propertyinfo.minuteHandOverDate/1000)];
            NSDateFormatter *format_asset_type = [NSDateFormatter new];
            [format_asset_type setDateFormat: @"dd/MM/yyyy"];
            propertyDetails.value_expiry_date = [format_asset_type stringFromDate:date_asset_type];
            
            propertyDetails.value_asset_type = propertyinfo.stationCode;
            
            NSDate *date_used_date = [NSDate dateWithTimeIntervalSince1970: (propertyinfo.usedDate/1000)];
            NSDateFormatter *format_used_date = [NSDateFormatter new];
            [format_used_date setDateFormat: @"dd/MM/yyyy"];
            propertyDetails.value_use_time = [format_used_date stringFromDate:date_used_date];
            
            propertyDetails.value_price = IntToString(propertyinfo.assetPrice);
            propertyDetails.value_status = propertyinfo.privateManagerName;
            
            if (propertyinfo.privateManagerName.length == 0) {
                propertyDetails.isColorButton = 1; // status nil
            } else {
                propertyDetails.isColorButton = 0; // status !nil
            }
            
            switch ([propertyinfo.privateManagerName componentsSeparatedByString:@";"].count) {
                case 0:
                    propertyDetails.isColorButton = 1;
                    break;
                case 4:
                    propertyDetails.isColorButton = 0;
                    break;
                default:
                    propertyDetails.isColorButton = 2;
                    break;
            }
            
            [self.navigationController pushViewController:propertyDetails animated:YES];
        }
            break;
        case 1:
        {
            BBBGAssetModel *bbbgModel = self.data_BBBG[index];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BBBGAsset" bundle:nil];
            BBBGAssetViewController *propertyDetails = (BBBGAssetViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BBBGAssetViewController"];
            
            propertyDetails.id_BBBG_detail = IntToString(bbbgModel.minuteHandOverId);
            propertyDetails.isStatus = bbbgModel.status;
            propertyDetails.bbbgModelAsset = bbbgModel;
            
            [self.navigationController pushViewController:propertyDetails animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

@end
