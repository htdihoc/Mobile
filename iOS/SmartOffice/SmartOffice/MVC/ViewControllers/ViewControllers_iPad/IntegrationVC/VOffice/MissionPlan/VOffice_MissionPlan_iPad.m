//
//  VOffice_MissingPlan_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_MissionPlan_iPad.h"
#import "VOffice_MissionCell_iPad.h"
#import "VOffice_ListMissionMain_iPad.h"
#import "WorkNotDataCell.h"
#import "TaskCell.h"
#import "ListMissionVC.h"
#import "VOffice_HeaderMissionView.h"
#import "Common.h"
@interface VOffice_MissionPlan_iPad () <VOffice_ListMissionMain_iPadDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSArray *_listGroupPerformedMission;
    NSArray *_listGroupShippedMission;
    NSIndexPath *_lastIndex;
    MissionType     _missionType;
    ListMissionType _listType;
}
@property (nonatomic, strong) VOffice_TaskController* taskController;
@end

@implementation VOffice_MissionPlan_iPad

- (void)viewDidLoad {
    self.spaceTop = 40;
    [super viewDidLoad];
    self.lblTitle.text = LocalizedString(@"VOffice_MissionPlan_iPad_Nhiệm_vụ");
    //    self.array = @[@"1", @"1", @"1", @"1"];
    _missionType = MissionType_All;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.taskController = [[VOffice_TaskController alloc] init];
    [self addHeaderToMissionVC];
    [self loadData];
}
- (void)addHeaderToMissionVC
{
    VOffice_HeaderMissionView *headerView = [[VOffice_HeaderMissionView alloc] initWithFrame:self.view.frame];
    [self addHeaderView:headerView];
}
- (void)loadData
{
    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    [self.taskController loadData:^(BOOL success, NSArray *listGroupPerformedMission, NSArray *listGroupShippedMission, NSArray *exceptions, NSArray *exceptionCodes) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self dismissHub];
			if (success) {
				_listGroupPerformedMission = listGroupPerformedMission;
				_listGroupShippedMission = listGroupShippedMission;
				[self.baseTableView reloadData];
				//Fake scroll data
				//[self.baseTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_listGroupPerformedMission.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
				//[self.baseTableView setContentOffset:CGPointZero animated:NO];
				//[self.baseTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_listGroupPerformedMission.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
			}
			else
			{
				[self handleErrorFromResult:exceptionCodes.firstObject withException:exceptionCodes.firstObject inView:self.view];
			}
		});
		
	}];
}

- (NSInteger)getSumePerformedMission
{
    NSInteger sum = 0;
    for(MissionGroupModel *model in _listGroupPerformedMission)
    {
        sum = sum + model.msDelayProgressNumber + model.msUnProgressNumber;
    }
    return sum;
}

- (NSInteger)getSumShippedMission
{
    NSInteger sum = 0;
    for(MissionGroupModel *model in _listGroupShippedMission)
    {
        sum = sum + model.msDelayProgressNumber + model.msUnProgressNumber;
    }
    return sum;
}
#pragma mark - UITableViewDataSource
//Header
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
	// Background color
	view.tintColor = RGB(242, 244, 249);
	
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    [header.textLabel setFont:AppFont_MainFontWithSize(14)];
    header.textLabel.textAlignment = NSTextAlignmentLeft;
    
    //Add arrow bottom image
    //UIImage *arrow = [UIImage imageNamed:@"arrow_bottom_icon"];
    //UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - arrow.size.width - 15, (view.frame.size.height - arrow.size.height) / 2, 18, 11)];
    //icon.image = arrow;
    //[view addSubview:icon];
    
    UIView *baseLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1)];
    baseLine.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:baseLine];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case ListMissionType_Perform:
            return [NSString stringWithFormat:@"     %@", LocalizedString(@"KVOFF_PERFORM_TITLE")];
            break;
        case ListMissionType_Shipped :
            return [NSString stringWithFormat:@"     %@", LocalizedString(@"KVOFF_SHIPPED_TITLE")];
            break;
        default:
            break;
    }
    
    return nil;
}


//Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	if (_listGroupShippedMission == nil && _listGroupPerformedMission == nil) {
		return 0;
	}
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{	
	if (section == ListMissionType_Perform) { //So value begins 1
		if (_listGroupPerformedMission == nil) {
			return 0;
		}
		return _listGroupPerformedMission.count > 0 ?  _listGroupPerformedMission.count : 1;
	}else{
		if (_listGroupShippedMission == nil) {
			return 0;
		}
		return _listGroupShippedMission.count > 0 ? _listGroupShippedMission.count : 1;
	}

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == ListMissionType_Perform) {
        if (_listGroupPerformedMission.count == 0) {
            static NSString* Identifier = @"WorkNotDataCell";
            [self registerCellWith:Identifier];
            WorkNotDataCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil){
                [tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell setupUIWithContent: LocalizedString(@"VOffice_ListMissionMain_iPad_Hiện_tại_đ/c_không_có_nhiệm_vụ_thực_hiện")];
            return cell;
            
        }else{
            static NSString *ID_CELL = @"VOffice_MissionCell_iPad";
            [self registerCellWith:ID_CELL];
            VOffice_MissionCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
			if(cell == nil){
				[tableView registerNib:[UINib nibWithNibName:ID_CELL bundle:nil] forCellReuseIdentifier:ID_CELL];
				cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
            MissionGroupModel *model = _listGroupPerformedMission[indexPath.row];
            [cell setupDataByModel:model];
            return cell;
        }
    }else{
        if (_listGroupShippedMission.count == 0) {
            static NSString* Identifier = @"WorkNotDataCell";
            [self registerCellWith:Identifier];
            WorkNotDataCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil){
                [tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell setupUIWithContent: LocalizedString(@"VOffice_ListWorkMain_iPad_Hiện_tại_đ/c_không_có_nhiệm_vụ_giao_đi")];
            return cell;
        }else{
            static NSString *ID_CELL = @"VOffice_MissionCell_iPad";
            [self registerCellWith:ID_CELL];
            VOffice_MissionCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
			if(cell == nil){
				[tableView registerNib:[UINib nibWithNibName:ID_CELL bundle:nil] forCellReuseIdentifier:ID_CELL];
				cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
            MissionGroupModel *model = _listGroupShippedMission[indexPath.row];
            [cell setupDataByModel:model];
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == ListMissionType_Perform - 1) {
        return _listGroupPerformedMission.count > 0 ?  70.0f : 100;
    }else{
        return _listGroupShippedMission.count > 0 ? 70 : 100;
    }
    return 70.0f;
}
//Add More Button
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _listType = indexPath.section;
    _lastIndex = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MissionGroupModel *model;
    if (indexPath.section == ListMissionType_Perform) {
        if (_listGroupPerformedMission.count == 0) {
            return;
        }
        model = _listGroupPerformedMission[indexPath.row];
    }else{
        if (_listGroupShippedMission.count == 0) {
            return;
        }
        model = _listGroupShippedMission[indexPath.row];
    }
    
    VOffice_ListMissionMain_iPad *listMissionMain = NEW_VC_FROM_NIB(VOffice_ListMissionMain_iPad, @"VOffice_ListMissionMain_iPad");
    listMissionMain.delegate = self;
    [listMissionMain setMissionType:_missionType missionGroupModel:model];
    [self pushIntegrationVC:listMissionMain];
}

#pragma mark VOffice_ListMissionMain_iPadDelegate
- (MissionGroupModel *)didSelectRow:(NSInteger)index
{
    if (_listType == ListMissionType_Perform) {
        return _listGroupPerformedMission[index];
    }
    else
    {
        return _listGroupShippedMission[index];
    }
    
}

- (NSArray *)getListmMsGroupName
{
    NSMutableArray *listGroupName = [NSMutableArray new];
    if (_listType == ListMissionType_Perform) {
        for (int index = 0; index < _listGroupPerformedMission.count; index++) {
            NSString *groupName = ((MissionGroupModel *)_listGroupPerformedMission[index]).msGroupName;
            [listGroupName addObject:groupName];
        }
        
    }
    else
    {
        for (int index = 0; index < _listGroupShippedMission.count; index++) {
            NSString *groupName = ((MissionGroupModel *)_listGroupShippedMission[index]).msGroupName;
            [listGroupName addObject:groupName];
        }
    }
    return listGroupName;
}

- (NSIndexPath *)getCurrentIndexPath
{
    return _lastIndex;
}

- (NSInteger)getcurrentListType
{
    return _listType;
}
- (NSInteger)getcurrentMissionType
{
    return _missionType;
}
- (void)setcurrentMissionType:(NSInteger)misstionType
{
    _listType = misstionType;
}
@end
