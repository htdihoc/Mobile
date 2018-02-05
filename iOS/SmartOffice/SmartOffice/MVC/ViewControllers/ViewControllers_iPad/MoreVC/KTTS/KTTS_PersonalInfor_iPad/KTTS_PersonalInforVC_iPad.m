//
//  KTTS_PersonalInforVC_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_PersonalInforVC_iPad.h"
#import "KTTS_ConfirmProperty_iPad.h"
#import "KTTS_ContentAssetBBBG_VC_iPad.h"
#import "KTTS_CancelStatus_VC_iPad.h"
#import "WorkNoDataView.h"
#import "MZFormSheetController.h"
#import "WYPopoverController.h"
#import "ContentFilterVC.h"
#import "DismissTimeKeeping.h"
#import "KTTSProcessor.h"
#import "PropertyInfoModel.h"
#import "BBBGAssetModel.h"
#import "DetailBBBGModel.h"
#import "SOErrorView.h"
#import "Common.h"
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"


@interface KTTS_PersonalInforVC_iPad () <UITableViewDataSource, UITableViewDelegate, SOSearchBarViewDelegate, UITextFieldDelegate, WYPopoverControllerDelegate, ContentFilterVCDelegate, KTTS_ListPropertyDelegate_iPad, KTTS_DetailPropertyViewDelegate_iPad, KTTS_ContentBBBGView_Delegate_iPad, SOErrorViewDelegate, MZFormSheetBackgroundWindowDelegate> {
    
    WYPopoverController *popoverController;
    WorkFilterType _filterTypeTTTS;
    WorkFilterType _filterTypeBBBG;
    SOErrorView *soErrorView;
    BOOL _isLoadedAllMission;
    NSInteger *typeStt;
    
}

@property (strong, nonatomic) NSMutableArray *TTTS_data_array, *BBBG_data_array;
@property (strong, nonatomic) NSMutableArray *data_TTNS, *data_BBBG;
@property (assign, nonatomic) NSInteger countTTTS, countBBBG;
@property (nonatomic) bool isloadmoreTTTS, isloadmoreBBBG;
@property (assign, nonatomic) NSInteger startTTTS, startBBBG, limit;
@property (strong, nonatomic) NSArray *data_FilterTTTS, *data_FilterBBBG;
@property (nonatomic) BOOL isFiltered, isSelect;
@end

@implementation KTTS_PersonalInforVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.VOffice_title        = @"";
    self.VOffice_buttonTitles = @[@"More"];
    self.switchScreen = 0;
    self.contentBBBG.hidden = YES;
    _propertyDetail.btn_Confirm.alpha = 0;
    self.containerView.backgroundColor      = AppColor_MainAppBackgroundColor;
    self.listProperty.backgroundColor       = AppColor_MainAppBackgroundColor;
    self.contentBBBG.backgroundColor        = AppColor_MainAppBackgroundColor;
    
    soErrorView = (SOErrorView *)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    soErrorView.delegate = self;
    soErrorView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-194);
    soErrorView.lblErrorInfo.text = @"Mất kết nối hệ thống";
    [self.listProperty.bottomView addSubview:soErrorView];
    soErrorView.hidden = YES;
    
    self.startTTTS = 0;
    self.startBBBG = 0;
    self.limit = 20;
    self.isloadmoreTTTS = true;
    self.isloadmoreBBBG = true;
    
    self.TTTS_data_array = [NSMutableArray new];
    self.BBBG_data_array = [NSMutableArray new];
    self.data_TTNS = [NSMutableArray new];
    self.data_BBBG = [NSMutableArray new];
    self.data_FilterTTTS = [NSArray new];
    self.data_FilterBBBG = [NSArray new];
    
    self.propertyDetail.delegate = self;
    self.contentBBBG.delegate = self;
    [self.listProperty.tbl_ListProperty registerNib:[UINib nibWithNibName:@"KTTS_ListPropertyCell_iPad" bundle:nil] forCellReuseIdentifier:@"KTTS_ListPropertyCell_iPad"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    self.listProperty.tbl_ListProperty.delegate = self;
    self.listProperty.tbl_ListProperty.dataSource = self;
    self.listProperty.tbl_ListProperty.estimatedRowHeight = 190;
    self.listProperty.tbl_ListProperty.rowHeight = UITableViewAutomaticDimension;
    self.listProperty.delegate = self;
    self.listProperty.searchview.delegate = self;
    self.listProperty.searchview.searchBar.placeholder = LocalizedString(@"SearchSerial..");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) loadmoreTableView {
    switch (self.switchScreen) {
        case 0:
        {
            if (self.startTTTS + 20 < self.countTTTS && self.isloadmoreTTTS == true) {
                self.startTTTS = self.startTTTS + 20;
                [self getDataTTTS];
            } else {
                self.isloadmoreTTTS = false;
            }
        }
            break;
        case 1:
        {
            if (self.startBBBG + 20 < self.countBBBG && self.isloadmoreBBBG == true) {
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

- (void) errorServerTTTS {
    soErrorView.hidden = NO;
    self.listProperty.tbl_ListProperty.hidden = YES;
    self.propertyDetail.tbl_Detail.hidden = YES;
    self.contentBBBG.bottomView.hidden = YES;
    [self addView:soErrorView toView:self.listProperty.bottomView];
    [[Common shareInstance] dismissCustomHUD];
}

- (void) donotInternet {
    self.listProperty.tbl_ListProperty.hidden = YES;
    self.propertyDetail.tbl_Detail.hidden = YES;
    self.contentBBBG.bottomView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
    [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối mạng" inView: self.listProperty.bottomView];
}

- (void) didRefreshOnErrorView:(SOErrorView *)errorView {
    [self countDataTTTS];
    [self countDataBBBG];
}

- (void) selectFirstTableView {
    if (!_isFiltered) {
        if (self.switchScreen == 0) {
            if (self.TTTS_data_array.count > 0) {
                if (self.listProperty.tbl_ListProperty.hidden == NO) {
                    [self selectFirstRow];
                }
                _propertyDetail.tbl_Detail.hidden = NO;
            } else {
                _propertyDetail.tbl_Detail.hidden = YES;
            }
        } else {
            if (self.BBBG_data_array.count > 0) {
                if (self.listProperty.tbl_ListProperty.hidden == NO) {
                    [self selectFirstRow];
                }
                self.contentBBBG.tbl_Content.hidden = NO;
            } else {
                self.contentBBBG.tbl_Content.hidden = YES;
            }
        }
    } else {
        if (self.switchScreen == 0) {
            if (self.data_FilterTTTS.count > 0) {
                if (self.listProperty.tbl_ListProperty.hidden == NO) {
                    [self selectFirstRow];
                }
                _propertyDetail.tbl_Detail.hidden = NO;
            } else {
                _propertyDetail.tbl_Detail.hidden = YES;
            }
        } else {
            if (self.data_FilterBBBG.count > 0) {
                if (self.listProperty.tbl_ListProperty.hidden == NO) {
                    [self selectFirstRow];
                }
                self.contentBBBG.tbl_Content.hidden = NO;
            } else {
                self.contentBBBG.tbl_Content.hidden = YES;
            }
        }
    }
}

- (void) selectFirstRow {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (self.isSelect == NO) {
        [self.listProperty.tbl_ListProperty selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        self.isSelect = YES;
    } else {
        [self.listProperty.tbl_ListProperty selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    [self tableView:self.listProperty.tbl_ListProperty didSelectRowAtIndexPath:indexPath];
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

-(void) loadData {
    [[Common shareInstance] showHUDWithTitle:@"Loading..." inView:self.view];
    
}

#pragma mark UISearchBarViewDelegate
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
    [self searchlocalwith:searchText];
}

- (void) searchlocalwith:(NSString *)searchText {
    switch (self.switchScreen) {
        case 0:
        {
            if (searchText.length == 0) {
                _isFiltered = NO;
                [self.listProperty.tbl_ListProperty reloadData];
                [self selectFirstTableView];
            } else {
                _isFiltered = YES;
                NSPredicate *p = [NSPredicate predicateWithFormat:@"catMerName CONTAINS[cd] %@ or serialNumber CONTAINS[cd] %@ or privateManagerName CONTAINS[cd] %@", searchText, searchText, searchText];
                self.data_FilterTTTS = [self.TTTS_data_array filteredArrayUsingPredicate:p];
                [self.listProperty.tbl_ListProperty reloadData];
                [self selectFirstTableView];
            }
        }
            break;
        case 1:
        {
            if (searchText.length == 0) {
                _isFiltered = NO;
                [self.listProperty.tbl_ListProperty reloadData];
                [self selectFirstTableView];
            } else {
                _isFiltered = YES;
                NSPredicate *p = [NSPredicate predicateWithFormat:@"minuteHandOverCode CONTAINS[cd] %@ or employeeMinuteHandOVerName CONTAINS[cd] %@", searchText, searchText];
                self.data_FilterBBBG = [self.BBBG_data_array filteredArrayUsingPredicate:p];
                [self.listProperty.tbl_ListProperty reloadData];
                [self selectFirstTableView];
            }
        }
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

#pragma mark Show View
- (void)showViewNoData {
    _listProperty.tbl_ListProperty.hidden = YES;
    _propertyDetail.hidden = YES;
    
    WorkNoDataView *workNoDataView = (WorkNoDataView *)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 0, self.listProperty.bottomView.frame.size.width, self.listProperty.bottomView.frame.size.height);
    workNoDataView.contenLB.text = @"Hiện tại đ/c không có tài sản nào";
    [self.listProperty.bottomView addSubview:workNoDataView];
}

- (void)showPopOver:(UIButton *)sender
{
    NSArray *contentFilter = @[];
    if (_switchScreen == 0) {
        contentFilter = @[@"Tất cả", @"Hỏng", @"Mất", @"Không sử dụng"];
        ContentFilterVC *filterVC = [[ContentFilterVC alloc] initWithFilterSelected:_filterTypeTTTS content:contentFilter];
        filterVC.preferredContentSize = CGSizeMake(240, contentFilter.count*44);
        filterVC.delegate = self;
        filterVC.modalInPopover = NO;
        popoverController = [[WYPopoverController alloc] initWithContentViewController:filterVC];
        popoverController.delegate = self;
        popoverController.passthroughViews = @[sender];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        popoverController.wantsDefaultContentAppearance = NO;
        
        [popoverController presentPopoverFromRect:sender.bounds
                                           inView:sender
                         permittedArrowDirections:WYPopoverArrowDirectionAny
                                         animated:YES
                                          options:WYPopoverAnimationOptionFadeWithScale];
    } else {
        contentFilter = @[@"Tất cả", @"Đã xác nhận", @"Đã từ chối", @"Đã bàn giao"];
        ContentFilterVC *filterVC = [[ContentFilterVC alloc] initWithFilterSelected:_filterTypeBBBG content:contentFilter];
        filterVC.preferredContentSize = CGSizeMake(240, contentFilter.count*44);
        filterVC.delegate = self;
        filterVC.modalInPopover = NO;
        popoverController = [[WYPopoverController alloc] initWithContentViewController:filterVC];
        popoverController.delegate = self;
        popoverController.passthroughViews = @[sender];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        popoverController.wantsDefaultContentAppearance = NO;
        
        [popoverController presentPopoverFromRect:sender.bounds
                                           inView:sender
                         permittedArrowDirections:WYPopoverArrowDirectionAny
                                         animated:YES
                                          options:WYPopoverAnimationOptionFadeWithScale];
    }
}

- (void)showConfirmVC {
    KTTS_ConfirmProperty_iPad *vc = NEW_VC_FROM_NIB(KTTS_ConfirmProperty_iPad, @"KTTS_ConfirmProperty_iPad");
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    vc.lbl_assetName.text = _propertyDetail.value_commodity_name;
    vc.lbl_assetCount.text = _propertyDetail.value_number;
    vc.lbl_assetSerial.text = _propertyDetail.value_serial;
    vc.tv_quantity.text = _propertyDetail.value_number;
    
    //    vc.view_kindOfReport.title = @"Lựa chọn";
    
    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE - (SCREEN_WIDTH_LANDSCAPE/2), SCREEN_HEIGHT_LANDSCAPE - (SCREEN_HEIGHT_LANDSCAPE/2.5));
    //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.cornerRadius = 12;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

- (void) actionShowConfirmBBBGAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Xác nhận" message:@"Bạn chắc chắn muốn xác nhận BBBG Tài sản này?" delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:@"Xác nhận", nil];
    [alert show];
}

- (void)actionShowRefuseAlert {
    DismissTimeKeeping *content = [[DismissTimeKeeping alloc] initWithNibName:@"DismissTimeKeeping" bundle:nil];
    [self showAlert:content title:@"Lý do từ chối"
    leftButtonTitle:@"Huỷ"
   rightButtonTitle:@"Từ chối"
         leftHander:nil
        rightHander:nil];
}

- (void)actionShowCancelStatusVC {
    KTTS_CancelStatus_VC_iPad *vc = NEW_VC_FROM_NIB(KTTS_CancelStatus_VC_iPad, @"KTTS_CancelStatus_VC_iPad");
    vc.merEntityId = IntToString(self.propertyDetail.merEntityId);
    vc.strStatus = self.propertyDetail.value_status;
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_HEIGHT_LANDSCAPE/2, SCREEN_WIDTH_LANDSCAPE/2 - 40);
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




#pragma mark Get DATA
- (void) countDataTTTS {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"169202",
                                @"type": @"1"
                                };
    [KTTSProcessor postCountDataTTTS:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        self.countTTTS = [result[@"return"] integerValue];
        self.listProperty.tbl_ListProperty.hidden = NO;
        self.propertyDetail.tbl_Detail.hidden = NO;
        self.contentBBBG.bottomView.hidden = NO;
        soErrorView.hidden = YES;
        [self getDataTTTS];
    } onError:^(NSString *Error) {
        [self donotInternet];
    } onException:^(NSString *Exception) {
        [self errorServerTTTS];
    }];
}

- (void) getDataTTTS {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"169202",
                                @"start": IntToString(_startTTTS),
                                @"keyword": self.listProperty.searchview.searchBar.text,
                                @"limit": IntToString(_limit)
                                };
    [KTTSProcessor postKTTS_THONG_TIN_TAI_SAN:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSArray *array = result[@"listMerEntity"];
        [self.TTTS_data_array addObjectsFromArray:array];
        self.listProperty.lbl_PropretyCount.text = IntToString(self.countTTTS);
        [self.listProperty.tbl_ListProperty reloadData];
        [self selectFirstTableView];
    } onError:^(NSString *Error) {
        [self donotInternet];
    } onException:^(NSString *Exception) {
        [self errorServerTTTS];
    }];
}

- (void) countDataBBBG {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"169202",
                                @"type": @"2"
                                };
    [KTTSProcessor postCountDataTTTS:parameter handle:^(id result, NSString *error) {
        self.countBBBG = [result[@"return"] integerValue];
        self.listProperty.tbl_ListProperty.hidden = NO;
        self.propertyDetail.tbl_Detail.hidden = NO;
        self.contentBBBG.bottomView.hidden = NO;
        soErrorView.hidden = YES;
        [self getDataBBBG];
    } onError:^(NSString *Error) {
        [self donotInternet];
    } onException:^(NSString *Exception) {
        [self errorServerTTTS];
    }];
}

-(NSNumber *)sttNumber:(NSInteger *)index {
    NSNumber *result = [NSNumber numberWithInteger:*index];
    return result;
}

- (void) getDataBBBG {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"employeeId": @"169202",
                                @"start": IntToString(_startBBBG),
                                @"keyword": self.listProperty.searchview.searchBar.text,
                                @"limit": IntToString(_limit)
                                };
    [KTTSProcessor postKTTS_BBBG:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSArray *array = result[@"listMinuteHandOver"];
        [self.BBBG_data_array addObjectsFromArray:array];
        [self.listProperty.tbl_ListProperty reloadData];
    } onError:^(NSString *Error) {
        [self donotInternet];
    } onException:^(NSString *Exception) {
        [self errorServerTTTS];
    }];
}

- (void)setBBBGBadge {
    for (int i = 0; i < [self.BBBG_data_array count]; i++) {
    }
    
}

-(void)switchSegment:(UISegmentedControl *)segment {
    self.isSelect = NO;
    NSUInteger selectedSegment = self.listProperty.sgm_WorkType.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:{
            self.listProperty.lbl_PropretyCount.text = IntToString(self.countTTTS);
            self.switchScreen = 0;
            [self.listProperty.tbl_ListProperty reloadData];
            [self selectFirstTableView];
            self.propertyDetail.hidden = NO;
            self.contentBBBG.hidden = YES;
            self.listProperty.searchview.searchBar.placeholder = LocalizedString(@"SearchSerial..");
        }
            break;
            
        case 1:{
            self.switchScreen = 1;
            self.listProperty.lbl_PropretyCount.text = IntToString(self.countBBBG);
            [self.listProperty.tbl_ListProperty reloadData];
            [self selectFirstTableView];
            self.propertyDetail.hidden = YES;
            self.contentBBBG.hidden = NO;
            self.listProperty.searchview.searchBar.placeholder = LocalizedString(@"SearchCodeBBBG..");
        }
        default:
            break;
    }
}

#pragma Mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.switchScreen == 0) {
        if (_isFiltered) {
            return self.data_FilterTTTS.count;
        } else {
            return self.TTTS_data_array.count;
        }
    } else if (self.switchScreen == 1) {
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
    
    static NSString *ID_CELL = @"KTTS_ListPropertyCell_iPad";
    KTTS_ListPropertyCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    [cell.lbl_goods_name sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.lbl_numberOfRow.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    
    switch (self.switchScreen) {
        case 0:{
            
            if (!_isFiltered) {
                self.data_TTNS = [PropertyInfoModel arrayOfModelsFromDictionaries:self.TTTS_data_array error:nil];
            } else {
                self.data_TTNS = [PropertyInfoModel arrayOfModelsFromDictionaries:self.data_FilterTTTS error:nil];
            }
            
            PropertyInfoModel *propertyinfo = self.data_TTNS[indexPath.row];
            
            cell.title_goods_name.text                  = @"Tên tài sản:";
            cell.title_number.text                      = @"Số lượng:";
            cell.title_serial.text                      = @"Serial:";
            cell.title_status.text                      = @"Trạng thái:";
            
            cell.lbl_goods_name.text                    = propertyinfo.catMerName;
            cell.lbl_number.text                        = IntToString(propertyinfo.count);
            cell.lbl_serial.text                        = propertyinfo.serialNumber;
            cell.lbl_status.text                        = propertyinfo.privateManagerName;
            
            cell.lbl_status.textColor       = RGB(254, 94, 8);
            
            if (indexPath.row == self.TTTS_data_array.count - 1) {
                [self loadmoreTableView];
            }
            
        }
            break;
            
        case 1:{
            
            if (!_isFiltered) {
                self.data_BBBG = [BBBGAssetModel arrayOfModelsFromDictionaries:self.BBBG_data_array error:nil];
            } else {
                self.data_BBBG = [BBBGAssetModel arrayOfModelsFromDictionaries:self.data_FilterBBBG error:nil];
            }
            
            BBBGAssetModel *bbbg = self.data_BBBG[indexPath.row];
            
            cell.title_goods_name.text                  = @"Mã BBBG:";
            cell.title_number.text                      = @"Ngày bàn giao:";
            cell.title_serial.text                      = @"Người bàn giao:";
            cell.title_status.text                      = @"Trạng thái:";
            
            cell.lbl_goods_name.text                    = bbbg.minuteHandOverCode;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970: (bbbg.minuteHandOverDate/1000)];
            NSDateFormatter *format = [NSDateFormatter new];
            [format setDateFormat: @"dd/MM/yyyy"];
            cell.lbl_number.text                        = [format stringFromDate:date];
            cell.lbl_serial.text                        = bbbg.employeeMinuteHandOVerName;
            
            switch (bbbg.status) {
                case 0:{
                    cell.lbl_status.text            = @"Đã bàn giao";
                    cell.lbl_status.textColor       = RGB(254, 94, 8);
                }
                    break;
                case 1:{
                    cell.lbl_status.text            = @"Đã xác nhận";
                    cell.lbl_status.textColor       = RGB(2, 127, 185);
                }
                    break;
                case 2:{
                    cell.lbl_status.text            = @"Đã từ chối";
                    cell.lbl_status.textColor       = RGB(245, 8, 8);
                }
                    break;
                default:{
                    cell.lbl_status.text            = @"Không xác định";
                }
                    break;
            }
            
            if (indexPath.row == self.BBBG_data_array.count - 1) {
                [self loadmoreTableView];
            }
        }
        default:
            break;
    }
    
    [self.listProperty.tbl_ListProperty addPullToRefreshWithActionHandler:^{
        [self.self.listProperty.tbl_ListProperty.pullToRefreshView stopAnimating];
        [self reloadDataTableView];
    }];
    
    return cell;
}

- (void) reloadDataTableView {
    self.startTTTS = 0;
    self.startBBBG = 0;
    switch (self.switchScreen) {
        case 0:
            [self.TTTS_data_array removeAllObjects];
            [self countDataTTTS];
            break;
        case 1:
            [self.BBBG_data_array removeAllObjects];
            [self countDataBBBG];
            break;
        default:
            break;
    }
    [self.self.listProperty.tbl_ListProperty reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadDataTableView];
}

#pragma Mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.switchScreen) {
        case 0:{
            _propertyDetail.tbl_Detail.hidden = NO;
            _propertyDetail.btn_Confirm.alpha = 1;
            PropertyInfoModel *propertyInfor = self.data_TTNS[indexPath.row];
            _propertyDetail.value_status = propertyInfor.privateManagerName;
            //            propertyDetails.isStatus = propertyinfo.stt;
            _propertyDetail.value_commodity_code = propertyInfor.catMerCode;
            _propertyDetail.value_commodity_name = propertyInfor.catMerName;
            _propertyDetail.value_unit = propertyInfor.unitName;
            _propertyDetail.value_number = IntToString(propertyInfor.count);
            _propertyDetail.value_serial = propertyInfor.serialNumber;
            _propertyDetail.value_manufacturer = propertyInfor.companyName;
            _propertyDetail.value_aspect = propertyInfor.statusName;
            //            propertyDetails.value_expiry_date = propertyinfo.minuteHandOverDate;
            _propertyDetail.value_asset_type = propertyInfor.stationCode;
            //            propertyDetails.value_use_time = propertyInfor;
            _propertyDetail.value_price = IntToString(propertyInfor.assetPrice);
            _propertyDetail.merEntityId = propertyInfor.merEntityId;
        }
            break;
        case 1:{
            BBBGAssetModel *bbbgModel = self.data_BBBG[indexPath.row];
            _contentBBBG.id_BBBG_detail = IntToString(bbbgModel.minuteHandOverId);
            _contentBBBG.goods_name = bbbgModel.minuteHandOverCode;
            _contentBBBG.isStatus = bbbgModel.status;
            [self.contentBBBG getData];
        }
        default:
            break;
    }
    [_propertyDetail.tbl_Detail reloadData];
}

#pragma mark KTTS_DetailPropertyViewDelegate_iPad

- (void)buttonShowConfirmVC:(UIButton *)sender{
    if (_propertyDetail.isConfirm == YES) {
        // [self showAlertForCancel];
        [self actionShowCancelStatusVC];
    }
    else {
        [self showConfirmVC];
    }
}

- (void) actionShowContentVC:(int)index array:(NSMutableArray *)array {
    KTTS_ContentAssetBBBG_VC_iPad *vc = NEW_VC_FROM_NIB(KTTS_ContentAssetBBBG_VC_iPad, @"KTTS_ContentAssetBBBG_VC_iPad");
    vc.goods_name = _contentBBBG.goods_name;
    
    array = [DetailBBBGModel arrayOfModelsFromDictionaries: array error:nil];
    DetailBBBGModel *detailBBBG = array[index];
    vc.minuteHandOverId = IntToString(detailBBBG.minuteHandOverId);
    vc.isStatus = detailBBBG.stt;
    vc.value_commodity_code = detailBBBG.catMerCode;
    vc.value_commodity_name = detailBBBG.catMerName;
    vc.value_unit = detailBBBG.unitName;
    vc.value_number = IntToString(detailBBBG.count);
    vc.value_serial = detailBBBG.serialNumber;
    vc.value_manufacturer = detailBBBG.companyName;
    vc.value_aspect = detailBBBG.statusName;
    
    NSDate *date_1 = [NSDate dateWithTimeIntervalSince1970: (detailBBBG.minuteHandOverDate/1000)];
    NSDateFormatter *format_1 = [NSDateFormatter new];
    [format_1 setDateFormat: @"dd/MM/yyyy"];
    vc.value_expiry_date = [format_1 stringFromDate:date_1];
    vc.value_asset_type = detailBBBG.stationCode;
    NSDate *date_2 = [NSDate dateWithTimeIntervalSince1970: (detailBBBG.usedDate/1000)];
    NSDateFormatter *format_2 = [NSDateFormatter new];
    [format_2 setDateFormat: @"dd/MM/yyyy"];
    vc.value_use_time = [format_2 stringFromDate:date_2];
    vc.value_price = IntToString(detailBBBG.assetPrice);
    //    propertyDetails.value_status = detailBBBGModel.privateManagerName;
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
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

#pragma mark VOffice_ListView_iPadDelegate
- (void)buttonPressed:(UIButton *)sender{
    [self showPopOver:sender];
}

#pragma mark - WYPopoverController Delegate
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller{
    popoverController.delegate = nil;
    popoverController = nil;
}

#pragma mark - ContentFilterVCDelegate
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
                    [self filterStatus:IntToString(1)];
                    break;
                case 2:
                    [self filterStatus:IntToString(2)];
                    break;
                case 3:
                    [self filterStatus:IntToString(0)];
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

- (void) filterStatus:(NSString *)status {
    _isFiltered = YES;
    NSPredicate *p = [NSPredicate predicateWithFormat:@"status = %d", status.integerValue];
    self.data_FilterBBBG = [self.BBBG_data_array filteredArrayUsingPredicate:p];
    [self.listProperty.tbl_ListProperty reloadData];
    [self selectFirstTableView];
}

@end
