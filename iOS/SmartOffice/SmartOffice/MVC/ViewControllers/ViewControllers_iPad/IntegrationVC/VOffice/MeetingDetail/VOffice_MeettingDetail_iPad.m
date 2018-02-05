//
//  Voffice_MeettingScheduleDetail_iPad.m
//  VOFFICE_ListOfMeetingSchedules
//
//  Created by NguyenDucBien on 4/28/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import "VOffice_MeettingDetail_iPad.h"
#import "DetailMeetingModel.h"
#import "VOffice_MeetingDetailController.h"
typedef enum: NSUInteger {
    DetailMeetingSectionType_Info = 0,
    DetailMeetingSectionType_Person,
} DetailMeetingSectionType;


@interface VOffice_MeettingDetail_iPad () {
    NSMutableArray *_listProfiles;
    //    DetailMeetingModel *_detail;
    
}
@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *checkOutTableVIew;

@end

@implementation VOffice_MeettingDetail_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblTitle.text = LocalizedString(@"VOffice_MeetingDetail_iPad_Chi_tiết_lịch_họp");
    [self.lblTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    self.lblTitle.textColor = AppColor_TittleTextColor;
    self.btn_VOffice.hidden = NO;
//    self.baseTableView.rowHeight = UITableViewAutomaticDimension;
    self.baseTableView.estimatedRowHeight = 70;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [self calculateParticipant];
    
}

- (void)loadMeetingDetail
{
    [self.delegate showLoading];
    [VOffice_MeetingDetailController loadMeetingDetail:[self.delegate getCurrentMeetingModel].meetingId completion:^(BOOL success, DetailMeetingModel *meetingDetail, NSException *exception, NSDictionary *error) {
        [self.delegate dismissLoading];
        if (success) {
            //            _detail = meetingDetail;
        }
        else
        {
            if (exception) {
                [self handleErrorFromResult:nil withException:exception inView:self.view];
                return;
            }
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
        }
    }];
}
- (void)calculateParticipant
{
    if (self) {
        _listProfiles = @[].mutableCopy;
        NSArray *items = [[self.delegate getCurrentMeetingModel].participant componentsSeparatedByString:@"-"];
        [items enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.length > 0) {
                [_listProfiles addObject:obj];
            }
        }];
    }
}
-(void)reloadData
{
    [self.baseTableView reloadData];
}
- (void)didSelectVOffice
{
    [self.delegate didSelectVOffice];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == DetailMeetingSectionType_Person) {
        return 30.0f;
    }
    return 0.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
//}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *identifier = @"defaultHeader";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    SOInsectTextLabel* currentHeaderView = [[SOInsectTextLabel alloc] initWithFrame:headerView.textLabel.frame isSubLabel:YES];
    currentHeaderView.text = LocalizedString(@"VOffice_MeetingDetail_iPad_Thành_phần_tham_gia");
    currentHeaderView.font = [UIFont systemFontOfSize:16];
    currentHeaderView.textColor = AppColor_MainTextColor;
    return currentHeaderView;
}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == DetailMeetingSectionType_Person) {
//        return LocalizedString(@"VOffice_MeetingDetail_iPad_Thành_phần_tham_gia");
//    }
//    
//    return nil;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == DetailMeetingSectionType_Info) {
        return 5;
        
    } else {
        MeetingModel *currentMeetingModel = [self.delegate getCurrentMeetingModel];
        return  currentMeetingModel.listMembers.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == DetailMeetingSectionType_Info) {
        static NSString *ID_CELL = @"VOffice_MeetingDetailCell_iPad";
        VOffice_MeetingDetailCell_iPad *normalCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        if(normalCell == nil){
            [tableView registerNib:[UINib nibWithNibName:ID_CELL bundle:nil] forCellReuseIdentifier:ID_CELL];
            normalCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        }
        normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [normalCell setupData:[self.delegate getCurrentMeetingModel] atIndex:indexPath.row];
        return normalCell;
    }else{
        static NSString *ID_CELL = @"VOffice_PersonJoinCell_iPad";
        VOffice_PersonJoinCell_iPad *profileCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        if(profileCell == nil){
            [tableView registerNib:[UINib nibWithNibName:ID_CELL bundle:nil] forCellReuseIdentifier:ID_CELL];
            profileCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        }
        profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_listProfiles.count > 0) {
            //[profileCell setupDataFromModel:_meetingModel.listParticipates[indexPath.row]];
            [profileCell setupDataFromModel:[self.delegate getCurrentMeetingModel].listMembers[indexPath.row]];
        }
        return profileCell;
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 30, 0, 0)];
    }
}

@end
