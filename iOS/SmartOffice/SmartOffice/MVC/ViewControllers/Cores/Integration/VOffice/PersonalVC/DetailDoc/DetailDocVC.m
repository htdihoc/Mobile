//
//  DetailDocVC.m
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailDocVC.h"
#import "DetailNormalDocCell.h"
#import "DetailProfileDocCell.h"
#import "VOfficeProcessor.h"

#import "DocModel.h"
#import "Common.h"

#import "DocDetailModel.h"
#import "TextDetailModel.h"
#import "DiscussionListVC.h"

@interface DetailDocVC (){
	DocDetailModel *_docDetail;
	TextDetailModel *_textDetail;
}

@end

@implementation DetailDocVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self createUI];
	
	//Dynamic Cell
	self.tblContent.rowHeight = UITableViewAutomaticDimension;
	self.tblContent.estimatedRowHeight = 70.0f;
	 // set to whatever your "average" cell height is
	
	[self loadData];
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
    self.backTitle      = LocalizedString(@"Chi tiết văn bản");
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
	[self detailTextDocWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		if (success) {
			NSDictionary *dictModel = resultDict[@"data"];
			if (_type == DocType_Express) {
				_docDetail = [[DocDetailModel alloc] initWithDictionary:dictModel error:nil];
			}else{
				_textDetail = [[TextDetailModel alloc] initWithDictionary:dictModel error:nil];
			}
		}else{
			[self handleErrorFromResult:resultDict withException:exception inView:self.tblContent];
		}
		[_tblContent reloadData];
		[[Common shareInstance] dismissHUD];
	}];
}

#pragma mark - Call API Detail
- (void)detailTextDocWithComplete:(Callback)callBack{
	[VOfficeProcessor getDetailDoctByID:_docId byDocType:_type callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		callBack(success, resultDict, exception);
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

- (IBAction)onReminderButtonClicked:(id)sender {
    [self pushToReminderView];
}

- (IBAction)onChatButtonClicked:(id)sender {
    [self pushToChatView];
}


#pragma mark - UITableView DataSource
//Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	if (_type == DocType_Express) {
		if (_docDetail && _docDetail.listMainSigner.count > 0) {
			return 2;
		}
		return 1;
	}else{
		if (_textDetail && _textDetail.listSubmitter.count > 0) {
			return 2;
		}
		return 1;
	}
	return 2;
}

//Header
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//	if (section == DetailDocSectionType_Profile) {
//		return 20.0f;
//	}
//	return 0.0f;
//}

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
	if (section == DetailDocSectionType_Profile) {
		return @"Danh sách ký duyệt";
	}
	
	return nil;
}


//Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == DetailDocSectionType_Info) {
		if (_type == DocType_Express) {
			if (_docDetail == nil) {
				return 0;
			}
		}else{
			if (_textDetail == nil) {
				return 0;
			}
		}
		return 6;
	}else{
		if (_type == DocType_Express) {
			if (_docDetail == nil) {
				return 0;
			}else{
				return _docDetail.listMainSigner.count;
			}
		}else{
			if (_textDetail == nil) {
				return 0;
			}else{
				return _textDetail.listSubmitter.count;
			}
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == DetailDocSectionType_Info) {
		static NSString *ID_CELL = @"DetailNormalDocCell_ID";
		DetailNormalDocCell *normalCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
		id model = (_type == DocType_Express? _docDetail : _textDetail);
		normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
		[normalCell setupData:model atIndex:indexPath.row];
		return normalCell;
	}else{
		static NSString *ID_CELL = @"DetailProfileDocCell_ID";
		DetailProfileDocCell *profileCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
		profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSArray *arrMembers  = (_type == DocType_Express? _docDetail.listMainSigner : _textDetail.listSubmitter);
		
		if (arrMembers.count > 0) {
			BOOL isDoc = (_type == DocType_Express? YES : NO);
			[profileCell setupDataFromModel:arrMembers[indexPath.row] forDoc:isDoc];
		}
		return profileCell;
	}
	return nil;
}

@end
