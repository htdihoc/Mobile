//
//  VOffice_ListMeetingMain_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_ListMeetingMain_iPad.h"
#import "MeetingModel.h"
#import "Common.h"
#import "NSException+Custom.h"

@interface VOffice_ListMeetingMain_iPad () <VOfficeProtocol>
{
    NSIndexPath *_lastIndex;
}
@property (strong, nonatomic) VOffice_MeettingDetail_iPad *meetingDetail;
@end

@implementation VOffice_ListMeetingMain_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    _lastIndex = [self.delegate lastIndex];
    self.VOffice_title = LocalizedString(@"VOffice_ListMeetingMain_iPad_Danh_sách_lịch_họp");
    self.VOffice_buttonTitles = @[@"VOffice"];
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    [self addContainerViews];
    // Do any additional setup after loading the view from its nib.
}

- (void)addContainerNoDataViews
{
    [self.listMeeting addSubview:[self newNoDataView]];
    [self.listMeetingDetail addSubview:[self newNoDataView]];
}
-(UIView *)newNoDataView{
    WorkNoDataView *nodataView = [[WorkNoDataView alloc] initWithFrame:self.listMeeting.bounds contentData:LocalizedString(@"VOffice_MainView_iPad_Hiện_tại_Đ/c_không có_nhiệm_vụ_nào")];
    nodataView.backgroundColor = [UIColor whiteColor];
    return nodataView;
}
- (void)addContainerViews {
    
    VOffice_Meeting_iPad *_meetingVC = NEW_VC_FROM_NIB(VOffice_Meeting_iPad, @"VOffice_Meeting_iPad");
    _meetingVC.isViewDetail = YES;
    _meetingVC.delegate = self;
    //check if array data isn't empty before selecting the first item
    //    [_meetingVC selectFirstItem];
    [self displayVC:_meetingVC container:self.listMeeting];
    
    
    _meetingDetail = NEW_VC_FROM_NIB(VOffice_MeettingDetail_iPad, @"VOffice_MeettingDetail_iPad");
    _meetingDetail.delegate = self;
    [self displayVC:_meetingDetail container:self.listMeetingDetail];
}

#pragma mark PassingMasterMeetingModel
- (MeetingModel *)getCurrentMeetingModel
{
    if (_lastIndex) {
        return [self.delegate getMeetingModelWith:_lastIndex];
    }
    else
    {
        return nil;
    }
}
- (void)didSelectRow:(NSIndexPath *)indexPath
{
    //    if ([Common checkNetworkAvaiable]) {
    _lastIndex = indexPath;
    //    } else {
    //        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    //    }
    [_meetingDetail reloadData];
    
}
- (NSIndexPath *)lastIndex
{
    return _lastIndex;
}
- (NSArray *)listItemsToShow
{
    return  [self.delegate listItemsToShow];
}
- (void)didSelectVOffice
{
    DLog(@"Tới VOffice");
}

#pragma mark VOfficeDelegate
- (void)showLoading
{
    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
}
- (void)dismissLoading
{
    [self dismissHub];
}
@end
