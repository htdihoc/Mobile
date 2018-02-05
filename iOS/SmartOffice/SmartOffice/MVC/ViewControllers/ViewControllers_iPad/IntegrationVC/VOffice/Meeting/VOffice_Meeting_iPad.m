//
//  VOffice_Meeting_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_Meeting_iPad.h"
#import "VOfficeProcessor.h"
#import "MeetingModel.h"
#import "WorkNotDataCell.h"
#import "Common.h"
#import "NSException+Custom.h"
@interface VOffice_Meeting_iPad() <VOfficeProtocol>
{
    NSIndexPath *_lastIndex;
}
@end

@implementation VOffice_Meeting_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblTitle.text = LocalizedString(@"VOffice_Meeting_iPad_Lịch_họp_gần_nhất");
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [self loadData];
    //    [self registerCellWith:@"VOffice_MeetingCell_iPad"];
}

- (void)loadData {
    
    if(!self.isViewDetail) {
        if ([Common checkNetworkAvaiable]) {
            //Get list Meetings
            [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
            [VOfficeProcessor getListScheduleVOFromWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
                [self dismissHub];
                if (success) {
                    NSArray *scheduleDictList = resultDict[@"data"];
                    NSError *error = nil;
                    self.itemsToShow = [MeetingModel arrayOfModelsFromDictionaries:scheduleDictList error:&error];
                    [self.baseTableView reloadData];
                }else{
                    DLog(@"List Schedule: ERROR");
                    if (exception == nil) {
                        DLog(@"List Schedule: ERROR : %@", resultDict);
                    }else{
                        //Exception
                    }
                    
                }
            }];
        } else {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
    }
    else
    {
        self.itemsToShow = [self.delegate listItemsToShow];
        [self.baseTableView reloadData];
        if (self.itemsToShow.count > 0) {
            [self selectItemsAt:[self.delegate lastIndex]];
        }
        
    }
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsToShow.count == 0 ? 1 : self.itemsToShow.count;
    //return self.itemsToShow.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemsToShow.count == 0) {
        static NSString* Identifier = @"WorkNotDataCell";
        WorkNotDataCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil){
            [tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            
        }
        [cell setupUIWithContent:LocalizedString(@"Hiện tại Đ/C không có lịch họp nào")];
        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
        return cell;
    }else{
        static NSString *ID_MeetingCell = @"VOffice_MeetingCell_iPad";
        VOffice_MeetingCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_MeetingCell];
        if(cell == nil){
            [tableView registerNib:[UINib nibWithNibName:ID_MeetingCell bundle:nil] forCellReuseIdentifier:ID_MeetingCell];
            cell = [tableView dequeueReusableCellWithIdentifier:ID_MeetingCell];
            
        }
        MeetingModel *model = self.itemsToShow[indexPath.row];
        [cell updateDataByModel:model];
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _lastIndex = indexPath;
    if(!self.isViewDetail)
    {
        [self deSelectRow:indexPath];
        
            if (self.listItemsToShow.count > 0) {
                VOffice_ListMeetingMain_iPad *meetingDetail = NEW_VC_FROM_NIB(VOffice_ListMeetingMain_iPad, @"VOffice_ListMeetingMain_iPad");
                meetingDetail.delegate = self;
                [self pushIntegrationVC:meetingDetail];
            }
    }
    else
    {
        //change content view
        [self.delegate didSelectRow:indexPath];
    }
}


#pragma mark PassingMasterMeetingModel
- (NSArray *)listItemsToShow
{
    return self.itemsToShow;
}
- (MeetingModel *)getMeetingModelWith:(NSIndexPath *)indexPath
{
    return self.listItemsToShow[indexPath == nil ? 0 : indexPath.row];
}
- (NSIndexPath *)lastIndex
{
    return _lastIndex;
}
@end
