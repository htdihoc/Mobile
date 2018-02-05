//
//  DetailWorkVC.m
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailWorkVC.h"
#import "DetailWorkCell.h"
#import "VOfficeProcessor.h"
#import "WorkModel.h"
#import "DetailWorkModel.h"
#import "Common.h"
#import "DiscussionListVC.h"

@interface DetailWorkVC (){
	DetailWorkModel *_detailWork;
}

@end

@implementation DetailWorkVC

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view
	[self createUI];
	
	//Dynamic Cell
	self.tblContent.rowHeight = UITableViewAutomaticDimension;
	self.tblContent.estimatedRowHeight = 70.0f;
	[self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CreateUI
- (void)createUI{
	[self setupColor];
    [self setupNav];
}
- (void)setupColor{
	self.view.backgroundColor = AppColor_MainAppBackgroundColor;
}

- (void)setupNav{
    self.backTitle  = LocalizedString(@"Chi tiết công việc");
    self.subTitle   = self.subTitle;
    self.rightTitle = LocalizedString(@"kVOFF_GOTO_VOFFICE_TITLE_BUTTON");
}

#pragma mark - LoadData
- (void)loadData{
	[[Common shareInstance] showHUDWithTitle:@"Loading.." inView:self.view];
	[VOfficeProcessor getDetailWorkFromId:_workModel.taskId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		if (success) {
			NSDictionary *dictModel = resultDict[@"data"];
			_detailWork = [[DetailWorkModel alloc] initWithDictionary:dictModel error:nil];
			[self.tblContent reloadData];
		}else{
			//Parse Error here
			[self handleErrorFromResult:resultDict withException:exception inView:self.view];
		}
		[[Common shareInstance] dismissHUD];
	}];
}

#pragma mark - Actions

- (void)btnRightAction{
    // Action Right Item Button here
}

- (IBAction)onReminderButtonClicked:(id)sender {
    [self pushToReminderView];
}

- (IBAction)onChatButtonClicked:(id)sender {
	DLog(@"Chat action");
	[self pushToChatView];
}

#pragma mark - UITableView DataSource
//Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (_segmentCurrent == ListWorkType_Perform) {
		return [Common numberRowsOfCommandTypeWork:_detailWork.commandType];
	}
	return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *ID_CELL = @"DetailWorkCell_ID";
	DetailWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
	[cell setupDataByModel:_detailWork atIndex:indexPath.row withSegment:(long)_segmentCurrent];
	return cell;
}

@end
