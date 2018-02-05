//
//  VOffice_DocumentTypicalDetail_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_DocumentTypicalDetail_iPad.h"
#import "VOffice_DocumentTypicalDetailCell_iPad.h"
#import "VOffice_DocumentTypicalProfileDetailCell_iPad.h"
#import "VOfficeProcessor.h"
#import "Common.h"
#import "DocDetailModel.h"
#import "TextDetailModel.h"
#import "SOInsectTextLabel.h"
@interface VOffice_DocumentTypicalDetail_iPad () <UITableViewDataSource, UITableViewDelegate>
{
    DocDetailModel *_docDetail;
    TextDetailModel *_textDetail;
}
@end

@implementation VOffice_DocumentTypicalDetail_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btn_VOffice.hidden = NO;
    self.baseTableView.estimatedRowHeight = 72;
    self.baseTableView.rowHeight = UITableViewAutomaticDimension;
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.lblTitle.text = LocalizedString(@"VOffice_DocumentTypicalDetail_iPad_Chi_tiết_văn_bản");
    [self.lblTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    self.lblTitle.textColor = AppColor_TittleTextColor;
    [self setupColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.baseTableView addGestureRecognizer:tap];
	
	//Only none on this view
	[self.baseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}
- (void)didTapOnTableView:(UIGestureRecognizer*) recognizer
{
    CGPoint tapLocation = [recognizer locationInView:self.baseTableView];
    NSIndexPath *indexPath = [self.baseTableView indexPathForRowAtPoint:tapLocation];
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        recognizer.cancelsTouchesInView = NO;
    }
    [self.delegate endEditVC];
}
- (void)clearData
{
    _docDetail = nil;
    _textDetail = nil;
}
- (void)reloadData
{
    [self.baseTableView reloadData];
}
- (void)setupColor{
    //	_topView.backgroundColor = AppColor_MainAppTintColor;
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
}
- (void)didSelectVOffice
{
    [self.delegate didSelectVOffice];
}
#pragma mark - LoadData
- (void)loadData:(NSString *)docId{
    if (self.delegate) {
        DocType type = [self.delegate docType];
        [self.delegate showLoading];
        [self detailTextDocWithComplete:docId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [self.delegate removeDetailContentLabel];
            [self.delegate dismissLoading];
            if (![self.delegate canShowDetail]) {
                [self clearData];
                [self reloadData];
                return;
            }
            if (success) {
                NSDictionary *dictModel = resultDict[@"data"];
                if (type == DocType_Express) {
                    _docDetail = [[DocDetailModel alloc] initWithDictionary:dictModel error:nil];
                }else{
                    _textDetail = [[TextDetailModel alloc] initWithDictionary:dictModel error:nil];
                }
            }else{
                [self clearData];
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            }
            [self reloadData];
        }];
    }
    
}

#pragma mark - Call API Detail
- (void)detailTextDocWithComplete:(NSString *)docId callBack:(Callback)callBack{
    DocType docType = [self.delegate docType];
    [VOfficeProcessor getDetailDoctByID:docId byDocType:docType callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}
#pragma mark - UITableView DataSource
//Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![Common checkNetworkAvaiable]) {
        return 0;
    }
    if ([self.delegate docType] == DocType_Express) {
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == DetailDocSectionType_Profile) {
        return 35.0f;
    }
    return 0.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *identifier = @"defaultHeader";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    
    SOInsectTextLabel* currentHeaderView = [[SOInsectTextLabel alloc] initWithFrame:headerView.textLabel.frame isSubLabel:YES];
    currentHeaderView.text = LocalizedString(@"VOffice_DocumentTypicalDetail_iPad_Danh_sách_ký_duyệt");
    currentHeaderView.font = [UIFont systemFontOfSize:16];
    currentHeaderView.textColor = AppColor_MainTextColor;
    
    return currentHeaderView;
}

//Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == DetailDocSectionType_Info) {
        return 6;
    }else{
        if ([self.delegate docType] == DocType_Express) {
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
        static NSString *ID_CELL = @"VOffice_DocumentTypicalDetailCell_iPad";
        [self.baseTableView registerNib:[UINib nibWithNibName:ID_CELL bundle:nil] forCellReuseIdentifier:ID_CELL];
        VOffice_DocumentTypicalDetailCell_iPad *normalCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        id model = ([self.delegate docType] == DocType_Express? _docDetail : _textDetail);
        normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [normalCell setupData:model atIndex:indexPath.row];
        return normalCell;
    }else{
        static NSString *ID_CELL = @"VOffice_DocumentTypicalProfileDetailCell_iPad";
        [self.baseTableView registerNib:[UINib nibWithNibName:ID_CELL bundle:nil] forCellReuseIdentifier:ID_CELL];
        VOffice_DocumentTypicalProfileDetailCell_iPad *profileCell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *arrMembers  = ([self.delegate docType] == DocType_Express? _docDetail.listMainSigner : _textDetail.listSubmitter);
        
        if (arrMembers.count > 0) {
            [profileCell setupDataFromModel:arrMembers[indexPath.row] type:[self.delegate docType]];
        }
        return profileCell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	/* Not check this now
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
	*/
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 30, 0, 0)];
    }
}

@end
