//
//  DetailMeetingVC.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailMeetingVC.h"
#import "DetailMeetingCell.h"
#import "DetailParticipantMeetingCell.h"
#import "DetailMeetingModel.h"
#import "VOfficeProcessor.h"
#import "MeetingModel.h"
#import "Common.h"
#import "DetailMeetingModel.h"

#import "DiscussionListVC.h"

typedef enum : NSUInteger {
    DetailMeetingSectionType_Info = 0,
    DetailMeetingSectionType_Profile,
} DetailMeetingSectionType;

@interface DetailMeetingVC (){
	DetailMeetingModel *_detail;
	NSMutableArray *_listProfiles;
}
@end

@implementation DetailMeetingVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(MeetingModel *)model{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		_listProfiles = @[].mutableCopy;
		self.meetingModel = model;
		/*
		NSArray *items = [model.participant componentsSeparatedByString:@"-"];
		[items enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
			if (obj.length > 0) {
				[_listProfiles addObject:obj];
			}
		}];
		 */
		_listProfiles = [NSMutableArray arrayWithArray:model.listMembers];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    
    //Dynamic Cell
    self.tblContent.dataSource = self;
    self.tblContent.delegate = self;
    self.tblContent.rowHeight = UITableViewAutomaticDimension;
    self.tblContent.estimatedRowHeight = 80.0; // set to whatever your "average" cell height is	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	//No use detail Meeting model now
	//[self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - CreateUI
- (void)createUI{
    self.backTitle      = LocalizedString(@"Chi tiết cuộc họp");
    self.rightTitle     = LocalizedString(@"kVOFF_GOTO_VOFFICE_TITLE_BUTTON");
    [self setupColor];
}

- (void)setupColor{
    //	_topView.backgroundColor = AppColor_MainAppTintColor;
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
}

#pragma mark - LoadData
- (void)loadData{
	[[Common shareInstance] showHUDWithTitle:@"Loading..." inView:self.tblContent];
	[VOfficeProcessor detailMeetingByID:_meetingModel.meetingId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		if (success) {
			NSDictionary *dictModel = resultDict[@"data"];
			_detail = [[DetailMeetingModel alloc] initWithDictionary:dictModel error:nil];
		}else{
			[self handleErrorFromResult:resultDict withException:exception inView:self.view];
		}
		[_tblContent reloadData];
		[[Common shareInstance] dismissHUD];
	}];
}

#pragma mark - Actions

- (void)btnRightAction{
    // Handler click item right button here !
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onGotoVOfficeButtonClicked:(id)sender {
}

/*
- (IBAction)onReminderButtonClicked:(id)sender {
    [self pushToReminderView];
}

- (IBAction)onChatButtonClicked:(id)sender {
	DLog(@"Chat Action On Meeting Detail");
}
*/
#pragma mark - UITableView DataSource
//Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

//Header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	/*
	if (_detail == nil) {
		return 0;
	}
	 */
    if (section == DetailMeetingSectionType_Profile) {
        return 20.0f;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor whiteColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:RGB(102, 102, 102)];
    [header.textLabel setFont:AppFont_MainFontWithSize(14)];
    header.textLabel.textAlignment = NSTextAlignmentLeft;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == DetailMeetingSectionType_Profile) {
        return LocalizedString(@"    Thành phần tham gia");
    }
    
    return nil;
}


//Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	/*
	if (_detail == nil) {
		return 0;
	}
	 */
    if (section == DetailMeetingSectionType_Info) {
        return 5;
    }
    else
    {
		//return _meetingModel.listParticipates.count;
		return  _listProfiles.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == DetailMeetingSectionType_Info) {
        static NSString *ID_CELL = @"DetailMeetingCell_ID";
        DetailMeetingCell *normalCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
		if(normalCell == nil){
			[tableView registerNib:[UINib nibWithNibName:@"DetailMeetingCell" bundle:nil] forCellReuseIdentifier:ID_CELL];
			normalCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
		}
		normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [normalCell setupData:_meetingModel atIndex:indexPath.row];
        return normalCell;
    }else{
        static NSString *ID_CELL = @"DetailParticipantMeetingCell_ID";
        DetailParticipantMeetingCell *profileCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
		if(profileCell == nil){
			[tableView registerNib:[UINib nibWithNibName:@"DetailParticipantMeetingCell" bundle:nil] forCellReuseIdentifier:ID_CELL];
			profileCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
		}
		profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (_listProfiles.count > 0) {
			[profileCell setupDataFromModel:_meetingModel.listMembers[indexPath.row]];
			//[profileCell setupDataByName:_listProfiles[indexPath.row] position:@""];
		}
        return profileCell;
    }
    return nil;
}

#pragma mark - Action On Bottom View
#pragma mark BottomDelegate
- (void)didSelectChatButton
{
    [self pushToChatView];
}
- (void)didSelectReminderButton
{
    DLog(@"select reminder");
	[self pushToReminderView];
}
@end
