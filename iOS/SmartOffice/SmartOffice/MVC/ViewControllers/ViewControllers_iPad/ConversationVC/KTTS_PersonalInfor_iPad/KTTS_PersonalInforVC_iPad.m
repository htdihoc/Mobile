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


@interface KTTS_PersonalInforVC_iPad () <UITableViewDataSource, UITableViewDelegate, WYPopoverControllerDelegate, ContentFilterVCDelegate, KTTS_ListPropertyDelegate_iPad, KTTS_DetailPropertyViewDelegate_iPad, KTTS_ContentBBBGView_Delegate_iPad, SOErrorViewDelegate, MZFormSheetBackgroundWindowDelegate> {
    
    WYPopoverController *popoverController;
    WorkFilterType _filterType;
    SOErrorView *soErrorView;
    
}

@property (strong, nonatomic) NSMutableArray *TTTS_data_array;
@property (strong, nonatomic) NSMutableArray *BBBG_data_array;

@property (assign, nonatomic) NSInteger countTTTS;
@property (assign, nonatomic) NSInteger countBBBG;

@end

@implementation KTTS_PersonalInforVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.VOffice_title        = @"";
    self.VOffice_buttonTitles = @[@"More", @"KTTS"];
    self.switchScreen = 0;
    self.contentBBBG.hidden = YES;
    _propertyDetail.btn_Confirm.alpha = 0;
    [self initValues];
    self.containerView.backgroundColor      = AppColor_MainAppBackgroundColor;
    self.listProperty.backgroundColor       = AppColor_MainAppBackgroundColor;
    self.contentBBBG.backgroundColor        = AppColor_MainAppBackgroundColor;
    
    soErrorView = (SOErrorView *)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    soErrorView.delegate = self;
    soErrorView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-194);
    soErrorView.lblErrorInfo.text = @"Mất kết nối hệ thống";
    [self.listProperty.bottomView addSubview:soErrorView];
    soErrorView.hidden = YES;
    
    self.TTTS_data_array = [NSMutableArray new];
    self.BBBG_data_array = [NSMutableArray new];
    
    self.propertyDetail.delegate = self;
    self.contentBBBG.delegate = self;
    [self.listProperty.tbl_ListProperty registerNib:[UINib nibWithNibName:@"KTTS_ListPropertyCell_iPad" bundle:nil] forCellReuseIdentifier:@"KTTS_ListPropertyCell_iPad"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    [self countDataTTTS];
    [self countDataBBBG];
    
    self.listProperty.tbl_ListProperty.delegate = self;
    self.listProperty.tbl_ListProperty.dataSource = self;
    self.listProperty.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) errorServerTTTS {
    soErrorView.hidden = NO;
    self.listProperty.tbl_ListProperty.hidden = YES;
    self.propertyDetail.tbl_Detail.hidden = YES;
    self.contentBBBG.bottomView.hidden = YES;
    [self addView:soErrorView toView:self.listProperty.bottomView];
}

- (void) donotInternet {
    self.listProperty.tbl_ListProperty.hidden = YES;
    self.propertyDetail.tbl_Detail.hidden = YES;
    self.contentBBBG.bottomView.hidden = YES;
    [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối Internet" inView: self.listProperty.bottomView];
}

- (void) didRefreshOnErrorView:(SOErrorView *)errorView {
    [self countDataTTTS];
    [self countDataBBBG];
}

- (void) selectFirstTableView {
    if (self.listProperty.tbl_ListProperty.hidden == NO) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.listProperty.tbl_ListProperty selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:self.listProperty.tbl_ListProperty didSelectRowAtIndexPath:indexPath];
    }
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)initValues{
    _filterType     = WorkFilterType_All;
}

-(void) loadData {
    [[Common shareInstance] showHUDWithTitle:@"Loading..." inView:self.view];
    
}

//- (void)detailTextDocWithComplete:(Callback)callBack{
// [VOfficeProcessor getDetailDoctByID:_docId byDocType:_type callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
//     callBack(success, resultDict, exception);
//  }];

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
    NSArray *contentFilter = @[@"- Tất cả -", @"Hỏng", @"Mất", @"Không sử dụng"];
    ContentFilterVC *filterVC = [[ContentFilterVC alloc] initWithFilterSelected:_filterType content:contentFilter];
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

- (void)showConfirmVC {
    KTTS_ConfirmProperty_iPad *vc = NEW_VC_FROM_NIB(KTTS_ConfirmProperty_iPad, @"KTTS_ConfirmProperty_iPad");
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    vc.lbl_assetName.text = _propertyDetail.value_commodity_name;
    vc.lbl_assetCount.text = _propertyDetail.value_number;
    vc.lbl_assetSerial.text = _propertyDetail.value_serial;
    
    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE - (SCREEN_WIDTH_LANDSCAPE/2), SCREEN_HEIGHT_LANDSCAPE - (SCREEN_HEIGHT_LANDSCAPE/2.5));
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

- (void)showAlertForCancel {
    UIAlertController * alert   = [UIAlertController
                                 alertControllerWithTitle:@"Xác nhận"
                                 message:@"Bạn có chắc chắn muốn HUỶ thông báo xác nhận tài sản cho bên KTTS ? "
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton    = [UIAlertAction
                                actionWithTitle:@"Gửi"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //  _propertyDetail.isConfirm = YES;
                                }];
    UIAlertAction* noButton     = [UIAlertAction
                               actionWithTitle:@"Đóng"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //
                               }];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)actionShowConfirmAlert {
    UIAlertController * alert   = [UIAlertController
                                 alertControllerWithTitle:@"Xác nhận"
                                 message:@"Bạn chắc chắn muốn xác nhận BBBG Tài sản này ?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton    = [UIAlertAction
                                actionWithTitle:@"Xác nhận"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //  _propertyDetail.isConfirm = YES;
                                }];
    UIAlertAction* noButton     = [UIAlertAction
                               actionWithTitle:@"Đóng"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //
                               }];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)actionShowRefuseAlert {
    DismissTimeKeeping *content = [[DismissTimeKeeping alloc] initWithNibName:@"DismissTimeKeeping" bundle:nil];
    [self showAlert:content title:@"Lý do từ chối"
                            leftButtonTitle:@"Huỷ"
                            rightButtonTitle:@"Từ chối"
                            leftHander:nil
                            rightHander:nil];
}

#pragma mark Get DATA
- (void) getDataTTTS {
    NSDictionary *parameter = @{
                                @"employeeId": @"169202",
                                @"start": IntToString(0),
                                @"limit": IntToString(self.countTTTS)
                                };
    [KTTSProcessor postKTTS_THONG_TIN_TAI_SAN:parameter handle:^(id result, NSString *error) {
        NSArray *array = result[@"listMerEntity"];
        self.TTTS_data_array = (NSMutableArray *)[self.TTTS_data_array arrayByAddingObjectsFromArray:array];
        self.TTTS_data_array = [PropertyInfoModel arrayOfModelsFromDictionaries:array error:nil];
        self.listProperty.lbl_PropretyCount.text = IntToString(self.countTTTS);
        [self.listProperty.tbl_ListProperty reloadData];
        [self selectFirstTableView];
    } onError:^(NSString *Error) {
        //
    } onException:^(NSString *Exception) {
        //
    }];
}

- (void) countDataTTTS {
    NSDictionary *parameter = @{
                                @"employeeId": @"169202",
                                @"type": @"1"
                                };
    [KTTSProcessor postCountDataTTTS:parameter handle:^(id result, NSString *error) {
        self.countTTTS = [result[@"return"] integerValue];
        self.listProperty.tbl_ListProperty.hidden = NO;
        self.propertyDetail.tbl_Detail.hidden = NO;
        self.contentBBBG.bottomView.hidden = NO;
        soErrorView.hidden = YES;
        [self getDataTTTS];
    } onError:^(NSString *Error) {
        [self errorServerTTTS];
    } onException:^(NSString *Exception) {
        [self donotInternet];
    }];
}

- (void) countDataBBBG {
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
        [self errorServerTTTS];
    } onException:^(NSString *Exception) {
        [self donotInternet];
    }];
}

- (void) getDataBBBG {
    NSDictionary *parameter = @{
                                @"employeeId": @"169202",
                                @"start": IntToString(0),
                                @"limit": IntToString(self.countBBBG)
                                };
    [KTTSProcessor postKTTS_BBBG:parameter handle:^(id result, NSString *error) {
        NSArray *array = result[@"listMinuteHandOver"];
        self.BBBG_data_array = (NSMutableArray *)[self.BBBG_data_array arrayByAddingObjectsFromArray:array];
        self.BBBG_data_array = [BBBGAssetModel arrayOfModelsFromDictionaries: array error:nil];
        [self.listProperty.tbl_ListProperty reloadData];
    } onError:^(NSString *Error) {
        [self errorServerTTTS];
    } onException:^(NSString *Exception) {
        [self donotInternet];
    }];
}

-(void)switchSegment:(UISegmentedControl *)segment {
    NSUInteger selectedSegment = self.listProperty.sgm_WorkType.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:{
            self.listProperty.lbl_PropretyCount.text = IntToString(self.countTTTS);
            self.switchScreen = 0;
            [self.listProperty.tbl_ListProperty reloadData];
            self.propertyDetail.hidden = NO;
            self.contentBBBG.hidden = YES;
            self.listProperty.searchBar.placeholder = @"Tìm kiếm theo mã Serial, tên tài sản, mã trạm...";
        }
            break;
            
        case 1:{
            self.switchScreen = 1;
            self.listProperty.lbl_PropretyCount.text = IntToString(self.countBBBG);
            [self.listProperty.tbl_ListProperty reloadData];
            self.propertyDetail.hidden = YES;
            self.contentBBBG.hidden = NO;
            self.listProperty.searchBar.placeholder = @"Mã BBBG, người bàn giao...";
            
            if (self.propertyDetail.tbl_Detail.hidden == NO) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.propertyDetail.tbl_Detail selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
                [self tableView:self.propertyDetail.tbl_Detail didSelectRowAtIndexPath:indexPath];
            }
        }
        default:
            break;
    }
}

#pragma Mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.switchScreen == 0) {
        return _TTTS_data_array.count;
    } else if (self.switchScreen == 1){
        return _BBBG_data_array.count;
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
            PropertyInfoModel *propertyinfo = self.TTTS_data_array[indexPath.row];
            cell.title_goods_name.text                  = @"Tên tài sản:";
            cell.title_number.text                      = @"Số lượng:";
            cell.title_serial.text                      = @"Serial:";
            cell.title_status.text                      = @"Trạng thái:";
            
            cell.lbl_goods_name.text                    = propertyinfo.catMerName;
            cell.lbl_number.text                        = IntToString(propertyinfo.count);
            cell.lbl_serial.text                        = propertyinfo.serialNumber;
            cell.lbl_status.text                        = propertyinfo.privateManagerName;
        }
            break;
            
        case 1:{
            BBBGAssetModel *bbbg = self.BBBG_data_array[indexPath.row];
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
        }
        default:
            break;
    }
    NSLog(@" %d", self.switchScreen);
    return cell;
}

#pragma Mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.switchScreen) {
        case 0:{
            _propertyDetail.tbl_Detail.hidden = NO;
            _propertyDetail.btn_Confirm.alpha = 1;
            PropertyInfoModel *propertyInfor = self.TTTS_data_array[indexPath.row];
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
        }
            break;
        case 1:{
            BBBGAssetModel *bbbgModel = self.BBBG_data_array[indexPath.row];
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
        [self showAlertForCancel];
    }
    else {
        [self showConfirmVC];
    }
}

- (void) actionShowContentVC:(int)index array:(NSMutableArray *)array {
    KTTS_ContentAssetBBBG_VC_iPad *vc = NEW_VC_FROM_NIB(KTTS_ContentAssetBBBG_VC_iPad, @"KTTS_ContentAssetBBBG_VC_iPad");
    vc.goods_name = _contentBBBG.goods_name;
    
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
    NSLog(@"press");
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
- (void)didSelectedFilterVC:(ContentFilterVC *)filterVC withFilterType:(WorkFilterType)filterType{
    //Reload data here
    _filterType = filterType;
    [popoverController dismissPopoverAnimated:YES];
}
@end
