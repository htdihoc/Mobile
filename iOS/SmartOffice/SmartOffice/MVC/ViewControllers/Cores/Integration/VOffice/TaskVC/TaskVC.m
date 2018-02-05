//
//  TaskVC.m
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TaskVC.h"
#import "SegmentChartView.h"
#import "TaskCell.h"
#import "SOTableViewRowAction.h"
#import "ListMissionVC.h"
#import "VOfficeProcessor.h"
#import "Common.h"
#import "MissionModel.h"
#import "NSArray+LinqExtensions.h"
#import "NSDictionary+LinqExtensions.h"
#import "MissionGroupModel.h"
#import "WorkNotDataCell.h"
#import "VOffice_TaskController.h"

#import "SOCycleView.h"

/*
	This class like Mission on DB (Viettel)
 */


@interface TaskVC ()<UITableViewDelegate, UITableViewDataSource>{
	NSMutableArray *_listGroupPerformedMission;
	NSMutableArray *_listGroupShippedMission;
}
@property (nonatomic, strong) VOffice_TaskController* taskController;
@property (weak, nonatomic) IBOutlet SegmentChartView *segmentChart;
@end

@implementation TaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	//_listGroupPerformedMission = @[].mutableCopy;
	//_listGroupShippedMission = @[].mutableCopy;

	[self createUI];
    self.taskController = [[VOffice_TaskController alloc] init];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DLog(@"Task appear");
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CreateUI
- (void)createUI{
	_lblDelayProgress.text = LocalizedString(@"MISSION_STATUS_DELAY_PROGRESS_LABEL");
	_lblUnInprogress.text = LocalizedString(@"MISSION_STATUS_UN_INPROGRESS_LABEL");
	_dotNotProgress.backgroundColor = AppColor_NotProgressPersonalChartColor;
	_dotSlowProgress.backgroundColor =  AppColor_SlowProgressPersonalChartColor;
}

#pragma mark - Load Data
- (void)loadData
{

	[[Common shareInstance] showCustomHudInView:self.view];
    [self.taskController loadData:^(BOOL success, NSArray *listGroupPerformedMission, NSArray *listGroupShippedMission, NSArray *exceptions, NSArray *exceptionCodes) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[[Common shareInstance] dismissCustomHUD];
			if (success) {
				if (!_listGroupShippedMission) {
					_listGroupShippedMission = @[].mutableCopy;
				}
				if (!_listGroupPerformedMission) {
					_listGroupPerformedMission = @[].mutableCopy;
				}

				_listGroupPerformedMission = [[NSMutableArray alloc] initWithArray:listGroupPerformedMission];
				_listGroupShippedMission = [[NSMutableArray alloc] initWithArray:listGroupShippedMission];
				[self.tblContent reloadData];
			}
			else
			{
				[self handleErrorFromResult:nil withException:exceptions.firstObject inView:self.view];
			}
		});
	}];
}

#pragma mark - Group Util
- (NSMutableArray *)groupObjectsFromMissionModelArray:(NSArray *)missionArrar byType:(MissionType)type{
	NSMutableArray *groupedArr = @[].mutableCopy;
	//GroupBY
	NSDictionary* groupedByOrgAssignId = [missionArrar linq_groupBy:^id(id item) {
		if (type == ListMissionType_Shipped) {
			return [item orgPerformId];
		}
		return [item orgAssignId];
	}];
	
	//Parse dict group to new Array group model
	for (NSString *key in groupedByOrgAssignId.allKeys) {
		NSArray *missions = groupedByOrgAssignId[key];
		NSString *groupName = @"";
		NSString *groupId;
		if (missions.count > 0) {
			if (type == ListMissionType_Shipped) {
				groupName = [missions.firstObject ORG_PERFORM_NAME];
				groupId = [missions.firstObject orgPerformId];
			}else{
				groupName = [missions.firstObject ORG_ASSIGN_NAME];
				groupId = [missions.firstObject orgAssignId];
			}
			NSInteger countDelay = [missions linq_count:^BOOL(MissionModel *item) {
				return item.status == MissionStatus_DelayProgress;
			}];
			NSInteger countUnInProgress = [missions linq_count:^BOOL(MissionModel *item) {
				return item.status == MissionStatus_UnInprogress;
			}];
			MissionGroupModel *group = [[MissionGroupModel alloc] initWithName:groupName delayProgressNumber:countDelay unInprogress:countUnInProgress groupId:groupId];
			[groupedArr addObject:group];
		}
	}
	return groupedArr;
}

#pragma mark - Load data From API
- (void)loadSumPerformedMissionWithComplete:(Callback)completeHandler{
	[VOfficeProcessor getAllListMissionByType:ListMissionType_Perform callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		completeHandler(success, resultDict, exception);
	}];
}


- (void)loadSumShippedMissionWithComplete:(Callback)completeHandler{
	[VOfficeProcessor getAllListMissionByType:ListMissionType_Shipped callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		completeHandler(success, resultDict, exception);
	}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
//Header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = RGB(242, 244, 249);
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    [header.textLabel setFont:AppFont_MainFontWithSize(14)];
    header.textLabel.textAlignment = NSTextAlignmentLeft;
	
	/*
    //Add arrow bottom image
    UIImage *arrow = [UIImage imageNamed:@"arrow_bottom_icon"];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - arrow.size.width - 15, (view.frame.size.height - arrow.size.height) / 2, 18, 11)];
    icon.image = arrow;
    [view addSubview:icon];
	icon.hidden = YES;
    */
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
            return LocalizedString(@"KVOFF_PERFORM_TITLE");
            break;
        case ListMissionType_Shipped:
			return LocalizedString(@"KVOFF_SHIPPED_TITLE");
            break;
        default:
            break;
    }
    
    return nil;
}


//Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	if (_listGroupPerformedMission == nil && _listGroupShippedMission == nil) {
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == ListMissionType_Perform) {
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.section == ListMissionType_Perform) {
		if (_listGroupPerformedMission.count == 0) {
			static NSString* Identifier = @"WorkNotDataCell";
			WorkNotDataCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
			if(cell == nil){
				[tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
				cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			[cell setupUIWithContent: LocalizedString(@"VOffice_ListMissionMain_iPad_Hiện_tại_đ/c_không_có_nhiệm_vụ_thực_hiện")];
			return cell;

		}else{
			static NSString *ID_CELL = @"TaskCell_ID";
			TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
			MissionGroupModel *model = _listGroupPerformedMission[indexPath.row];
			[cell setupDataByModel:model];
			return cell;
		}
	}else{
		if (_listGroupShippedMission.count == 0) {
			static NSString* Identifier = @"WorkNotDataCell";
			WorkNotDataCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
			if(cell == nil){
				[tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
				cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			[cell setupUIWithContent: LocalizedString(@"VOffice_ListWorkMain_iPad_Hiện_tại_đ/c_không_có_nhiệm_vụ_giao_đi")];
			return cell;
		}else{
			static NSString *ID_CELL = @"TaskCell_ID";
			TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
			MissionGroupModel *model = _listGroupShippedMission[indexPath.row];
			[cell setupDataByModel:model];
			return cell;
		}
	}
 }

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	MissionGroupModel *model;
	if (indexPath.section == ListMissionType_Perform ) {
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
	ListMissionVC *_listMission = [self.storyboard instantiateViewControllerWithIdentifier:@"ListMissionVC"];
	_listMission.listType = indexPath.section ;
	_listMission.groupModel = model;
	[AppDelegateAccessor.navIntegrationVC pushViewController:_listMission animated:YES];
}

@end
