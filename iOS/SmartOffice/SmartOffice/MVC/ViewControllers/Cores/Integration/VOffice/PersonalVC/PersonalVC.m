//
//  PersonalVC.m
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "PersonalVC.h"
#import "WorkPersonalCell.h"
#import "MeetingCell.h"
#import "DocCell.h"

#import "SumWorkModel.h"
#import "PersionaModel.h"
#import "MeetingModel.h"
#import "SumDocModel.h"

#import "VOfficeProcessor.h"
#import "Common.h"

#import "ListWorkVC.h"
#import "ListDocVC.h"
#import "SOTableViewRowAction.h"

#import "DetailMeetingVC.h"
#import "DiscussionListVC.h"

#import "WorkNotDataCell.h"

@interface PersonalVC ()<WorkPersonalCellDelegate>{
	PersionaModel *_perModel;
}

@end

typedef enum : NSUInteger {
    PersonalSectionType_Job = 0,
    PersonalSectionType_Meeting,
    PersonalSectionType_Docs,
} PersonalSectionType;

@implementation PersonalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	//initial Data
	//_perModel = [[PersionaModel alloc] init];
	
	//Load Data
	[self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DLog(@"Personal appear");

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Load Data
- (void)loadData{
	[self excuteAPI];
}
//Get Sum Perform Work
- (void)sumNotProgressPerformWorkWithComplete:(Callback)callBack{
	[VOfficeProcessor searchSumTask:@[@(WorkStatus_UnInprogress)]  listTaskType:ListWorkType_Perform callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		callBack(success, resultDict, exception);
	}];
}


- (void)sumOverduePerformWorkWithComplete:(Callback)callBack{
	[VOfficeProcessor searchSumTask:@[@(WorkStatus_Delay)] listTaskType:ListWorkType_Perform callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		callBack(success, resultDict, exception);
	}];
}
//ShippedWork
- (void)sumNotProgressShippedWorkWithComplete:(Callback)callBack{
	[VOfficeProcessor searchSumTask:@[@(WorkStatus_UnInprogress)] listTaskType:ListWorkType_Shipped callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		callBack(success, resultDict, exception);
	}];
}

- (void)sumOverdueShippedWorkWithComplete:(Callback)callBack{
	[VOfficeProcessor searchSumTask:@[@(WorkStatus_Delay)] listTaskType:ListWorkType_Shipped callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		callBack(success, resultDict, exception);
	}];
}

#pragma mark - Loading Data
- (void)excuteAPI{
	if (![Common checkNetworkAvaiable]) {
		[[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Mất kết nối mạng") inView:[super view]];
		return;
	}
	[[Common shareInstance] showCustomHudInView:self.view];
	//self.view.hidden = YES;
	dispatch_group_t group = dispatch_group_create(); // 2
	 __weak PersonalVC *weakSelf = self;
	__block PersionaModel *model = [[PersionaModel alloc] init];
	__block BOOL hasErrorWork = NO;
	__block BOOL hasErrorMeeting = NO;
	__block BOOL haseErrorDoc = NO;
	//1: Sum NotProgress Perform Work: chưa thực hiện
	dispatch_group_enter(group);
	[self sumNotProgressPerformWorkWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		if (success) {
			NSInteger sum = [resultDict[@"data"] integerValue];
			model.performWorkModel.newTask = sum;
		}else{
			hasErrorWork = YES;
		}
		dispatch_group_leave(group);
	}];
	
	//2: Sum Overdue Perform work: Chậm tiến độ
	dispatch_group_enter(group);
	[self sumOverduePerformWorkWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		if (success) {
			NSInteger sum = [resultDict[@"data"] integerValue];
			model.performWorkModel.overdue = sum;
		}else{
			hasErrorWork = YES;
		}
		dispatch_group_leave(group);
	}];
	
	//3: Sum NotProgress shippedWork
	dispatch_group_enter(group);
	[self sumNotProgressShippedWorkWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		if (success) {
			NSInteger sum = [resultDict[@"data"] integerValue];
			model.shippedWorkModel.newTask = sum;
			//_perModel.shippedWorkModel.newTask = 25;
		}else{
			hasErrorWork = YES;
		}
		dispatch_group_leave(group);
	}];
	
	//4: Sum Overdue shippedWork
	dispatch_group_enter(group);
	[self sumOverdueShippedWorkWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		if (success) {
			NSInteger sum = [resultDict[@"data"] integerValue];
			model.shippedWorkModel.overdue = sum;
			//_perModel.shippedWorkModel.overdue = 50;
		}else{
			hasErrorWork = YES;
		}
		dispatch_group_leave(group);
	}];

	//Get list Meetings
	dispatch_group_enter(group);
	[VOfficeProcessor getListScheduleVOFromWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		if (success) {
			NSArray *scheduleDictList = resultDict[@"data"];
			NSError *error = nil;
			model.listSchedule = [MeetingModel arrayOfModelsFromDictionaries:scheduleDictList error:&error];
		}else{
			DLog(@"List Schedule: ERROR");
			if (exception == nil) {
				DLog(@"List Schedule: ERROR : %@", resultDict);
			}else{
				//Exception
			}
			hasErrorMeeting = YES;
		}
		dispatch_group_leave(group);
	}];
	
	//Sum Express Doc
	dispatch_group_enter(group);
	[VOfficeProcessor searchExpressDocByTitle:@"" startRecord:0 isSum:YES callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		if (success) {
			if ([resultDict[@"data"] count] == 0) {
				//No Data
				model.docModel.countTextSigned = 0;
			}else{
				NSDictionary *sumDict = [resultDict[@"data"] objectAtIndex:0];
				NSInteger sumDoc = [sumDict[@"total"] integerValue];
				model.docModel.countTextSigned = sumDoc;
			}
		}else{
			DLog(@"Sum Doc: ERROR");
			if (exception == nil) {
				//Error from server
				DLog(@"Sum Doc: %@", resultDict);
				
			}else{
				//Exception
			}
			haseErrorDoc = YES;
		}
		dispatch_group_leave(group);
	}];
	
	//Sum Doc Flash: Ký nháy
	dispatch_group_enter(group);
	[VOfficeProcessor searchNormalDocByTitle:@"" docType:DocType_Flash startRecord:0 isSum:YES callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		DLog(@"Sum Flash Doc: %@", resultDict);
		if (success) {
			model.docModel.countTextWaitingInitial = [resultDict[@"data"] integerValue];
		}else{
			haseErrorDoc = YES;
		}
		dispatch_group_leave(group);
	}];
	//Sum Doc Waiting Sign: Ký duyệt
	dispatch_group_enter(group);
	[VOfficeProcessor searchNormalDocByTitle:@"" docType:DocType_Waiting startRecord:0 isSum:YES callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		DLog(@"SumWaiting Sign: %@", resultDict);
		if (success) {
			model.docModel.countTextWaitSign = [resultDict[@"data"] integerValue];
		}else{
			haseErrorDoc = YES;
		}
		dispatch_group_leave(group);
	}];
	
	//All task completed
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{ // 4
		self.view.hidden = NO;
		[[Common shareInstance] dismissCustomHUD];
		if (haseErrorDoc || hasErrorWork || hasErrorMeeting) {
			if (_perModel) {
				 [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Không kết nối được đến máy chủ, xin vui lòng kiểm tra và thử lại sau!") inView:self.view];
			}else{
				[[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Mất kết nối tới hệ thống") inView:[super view]];
			}
			return;
		}
		_perModel = model;
		[_perModel updateDataForListDocFromSumDoc:_perModel.docModel];
		[weakSelf.tblContentView reloadData];
		
	});
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
    [header.textLabel setTextColor:RGB(59, 59, 59)];
    [header.textLabel setFont:AppFont_MainFontWithSize(14)];
    header.textLabel.textAlignment = NSTextAlignmentLeft;
    
    //Add arrow bottom image
    UIImage *arrow = [UIImage imageNamed:@"arrow_bottom_icon"];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - arrow.size.width - 15, (view.frame.size.height - arrow.size.height) / 2, 18, 11)];
    icon.image = arrow;
    [view addSubview:icon];
	icon.hidden = YES;
    
    UIView *baseLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1)];
	baseLine.backgroundColor = RGBA(170, 170, 170, 0.5);
    [view addSubview:baseLine];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return LocalizedString(@"KVOFF_SECTION_WORK_TITLE");
            break;
        case 1:
			return LocalizedString(@"KVOFF_SECTION_METTING_TITLE");
            break;
        case 2:
			return LocalizedString(@"KVOFF_SECTION_DOC_TITLE");
        default:
            break;
    }
    
    return nil;
}


//Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	if (_perModel == nil) {
		return 0;
	}
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == PersonalSectionType_Job) {
        return 1;
    }else if (section == PersonalSectionType_Meeting){
		if (_perModel.listSchedule.count == 0) {
			return 1;
		}
        return _perModel.listSchedule.count;
	}else{
		if (_perModel.listDoc.count == 0) {
			return 1;
		}
		return _perModel.listDoc.count;
	}
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == PersonalSectionType_Job) {
		NSInteger sumPerformWork = _perModel.performWorkModel.newTask + _perModel.performWorkModel.overdue;
		NSInteger sumShippedWork = _perModel.shippedWorkModel.newTask + _perModel.shippedWorkModel.overdue;
		if (sumPerformWork == 0 && sumShippedWork == 0) {
			return 100.0f;
		}
        return 240.0f;
    }
    if (indexPath.section == PersonalSectionType_Meeting) {
		if (_perModel.listSchedule.count == 0) {
			return 100;
		}
        return 90.0f;
    }
	if (indexPath.section == PersonalSectionType_Docs) {
		if (_perModel.docModel.countTextSigned == 0 && _perModel.docModel.countTextWaitSign == 0 && _perModel.docModel.countTextWaitingInitial == 0) {
			return 100.0f;
		}
		return 60.0f;
	}
    return 60.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == PersonalSectionType_Meeting) {
		if (_perModel.listSchedule.count > 0) {
			return YES;
		}
	}
	return NO;
}
//Swipe Cell
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section != PersonalSectionType_Meeting) {
		return nil;
	}
	if (_perModel.listSchedule.count == 0) {
		return nil;
	}
	SOTableViewRowAction *chatAction = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
																		  title:@"Chat"
																		   icon:[UIImage imageNamed:@"swipe_cell_chat_icon"]
																		  color:RGB(59, 111, 169)
																		handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
																			//Action here
																			DLog(@"select chat");
																			[self pushToChatView];
																			
																		}];
	
	SOTableViewRowAction *reminderAction = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
																			  title:@"Reminder"
																			   icon:[UIImage imageNamed:@"swipe_cell_reminder_icon"]
																			  color:RGB(255, 150, 0)
																			handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
																				//Action here
																				[self pushToReminderView];
																			}];
	
	return @[chatAction, reminderAction];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == PersonalSectionType_Job) {
		NSInteger sumPerformWork = _perModel.performWorkModel.newTask + _perModel.performWorkModel.overdue;
		NSInteger sumShippedWork = _perModel.shippedWorkModel.newTask + _perModel.shippedWorkModel.overdue;
		if (sumPerformWork == 0 && sumShippedWork == 0) {
			//Return Nodata Cell
			static NSString* Identifier = @"WorkNotDataCell";
			WorkNotDataCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
			if(cell == nil){
				[tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
				cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			
			[cell setupUIWithContent:LocalizedString( @"Hiện tại Đ/C không có công việc nào")];
			return cell;

		}else{
			static NSString *ID_WORK_PERSONAL_CELL = @"WorkPersonalCell_ID";
			WorkPersonalCell *workCell = [tableView dequeueReusableCellWithIdentifier:ID_WORK_PERSONAL_CELL forIndexPath:indexPath];
			workCell.delegate = self;
			//Sample Model
			[workCell setupViewFromModel:_perModel.performWorkModel shippedWork:_perModel.shippedWorkModel];
			return workCell;
		}
    }
	
    if (indexPath.section == PersonalSectionType_Meeting) {
		if (_perModel.listSchedule.count == 0) {
			static NSString* Identifier = @"WorkNotDataCell";
			WorkNotDataCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
			if(cell == nil){
				[tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
				cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;

			}
			[cell setupUIWithContent:LocalizedString(@"Hiện tại Đ/C không có lịch họp nào")];
			return cell;
		}else{
			static NSString *ID_MeetingCell = @"MeetingCell_ID";
			MeetingCell *meetingCell = [tableView dequeueReusableCellWithIdentifier:ID_MeetingCell];
			MeetingModel *model = _perModel.listSchedule[indexPath.row];
			[meetingCell updateDataByModel:model];
			return meetingCell;
		}
	}
    
    if (indexPath.section == PersonalSectionType_Docs) {
		if (_perModel.listDoc.count == 0) {
			static NSString* Identifier = @"WorkNotDataCell";
			WorkNotDataCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
			if(cell == nil){
				[tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
				cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			[cell setupUIWithContent:LocalizedString(@"Hiện tại Đ/C không có văn bản nào")];
			return cell;

		}
        DocCell *docCell = [tableView dequeueReusableCellWithIdentifier:@"DocCell_ID"];
        //Fixed data
        [docCell updateValue:_perModel.docModel forType:[_perModel.listDoc[indexPath.row] integerValue]];
        return docCell;
    }
    
    return nil;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == PersonalSectionType_Meeting)
    {
		//Check list meeting
		if (_perModel.listSchedule.count == 0) {
			return;
		}
		MeetingModel *model =  _perModel.listSchedule[indexPath.row];
		DetailMeetingVC *detailMeetingVC = [[DetailMeetingVC alloc] initWithNibName:@"DetailMeetingVC" bundle:nil model:model];
		[self pushIntegrationVC:detailMeetingVC];
    }
	if (indexPath.section == PersonalSectionType_Job) {
		return;
	}
	
	if (indexPath.section == PersonalSectionType_Docs) {
		if (_perModel.listDoc.count == 0) {
			return;
		}
		DocType doctype = [_perModel.listDoc[indexPath.row] integerValue];
		ListDocVC *listDoc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDocVC"];
		listDoc.docType = doctype;
		[AppDelegateAccessor.navIntegrationVC pushViewController:listDoc animated:YES];
	}
}

#pragma mark - PersonalWorkCell Delegate
- (void)didTapOnChartView:(ChartViewBase *)chartView withType:(ListWorkType)type{
	NSInteger sumPerformWork = _perModel.performWorkModel.newTask + _perModel.performWorkModel.overdue;
	NSInteger sumShippedWork = _perModel.shippedWorkModel.newTask + _perModel.shippedWorkModel.overdue;
	
	//Check Sum work
	if (sumPerformWork == 0 && sumShippedWork == 0) {
		return;
	}
	ListWorkVC *listVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ListWorkVC"];
	listVC.listWorkType = type;
	[AppDelegateAccessor.navIntegrationVC pushViewController:listVC animated:YES];

}
@end
