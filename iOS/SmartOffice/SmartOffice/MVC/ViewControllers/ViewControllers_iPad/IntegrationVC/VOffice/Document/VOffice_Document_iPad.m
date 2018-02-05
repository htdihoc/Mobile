//
//  VOffice_Document_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_Document_iPad.h"
#import "SumDocModel.h"
#import "WorkNotDataCell.h"
#import "VOfficeProcessor.h"
@interface VOffice_Document_iPad () <VOfficeProtocol>
{
    NSInteger _lastIndex;
	NSMutableArray *_listDoc;
}
@property (strong, nonatomic) SumDocModel *docModel;
@end

@implementation VOffice_Document_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
	_listDoc = [NSMutableArray arrayWithCapacity:3];
    self.lblTitle.text = LocalizedString(@"VOffice_Document_iPad_Văn_bản");
    self.baseTableView.estimatedRowHeight = 80;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [self initValues];
    [self loadData];
}

//Update data for listDoc
- (void)updateDataForListDocFromSumDoc:(SumDocModel *)model{
	if (!model) {
		return;
	}
	if (model.countTextWaitSign > 0) {
		[_listDoc addObject:@(DocType_Waiting)];
	}
	if (model.countTextWaitingInitial > 0) {
		[_listDoc addObject:@(DocType_Flash)];
	}
	if (model.countTextSigned > 0) {
		[_listDoc addObject:@(DocType_Express)];
	}
	
}
- (void)initValues
{
    _docModel = [[SumDocModel alloc] init];
}
- (void)loadData
{
    [_listDoc removeAllObjects];
    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    dispatch_group_t group = dispatch_group_create(); // 2
	
	//Sum Express Doc
	dispatch_group_enter(group);
	[VOfficeProcessor searchExpressDocByTitle:@"" startRecord:0 isSum:YES callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		if (success) {
			if ([resultDict[@"data"] count] == 0) {
				//No Data
				_docModel.countTextSigned = 0;
			}else{
				NSDictionary *sumDict = [resultDict[@"data"] objectAtIndex:0];
				NSInteger sumDoc = [sumDict[@"total"] integerValue];
				_docModel.countTextSigned = sumDoc;
			}
		}else{
			DLog(@"Sum Doc: ERROR");
			if (exception == nil) {
				//Error from server
				DLog(@"Sum Doc: %@", resultDict);
				
			}else{
				//Exception
			}
		}
		dispatch_group_leave(group);
	}];
	
	//Sum Flash Doc
	dispatch_group_enter(group);
	[VOfficeProcessor searchNormalDocByTitle:@"" docType:DocType_Flash startRecord:0 isSum:YES callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		DLog(@"Sum Flash Doc: %@", resultDict);
		if (success) {
			_docModel.countTextWaitingInitial = [resultDict[@"data"] integerValue];
		}
        else
        {
            DLog(@"");
        }
		dispatch_group_leave(group);
	}];
	//Sum Doc Waiting Sign: Ký duyệt
	dispatch_group_enter(group);
	[VOfficeProcessor searchNormalDocByTitle:@"" docType:DocType_Waiting startRecord:0 isSum:YES callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
		DLog(@"SumWaiting Sign: %@", resultDict);
		if (success) {
			_docModel.countTextWaitSign = [resultDict[@"data"] integerValue];
		}
        else
        {
            DLog(@"");
        }
		dispatch_group_leave(group);
	}];

    //All task completed
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{ // 4
        [self dismissHub];
		[self updateDataForListDocFromSumDoc:_docModel];
        [self.baseTableView reloadData];
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	if (_listDoc.count == 0) {
//		return 1;
//	}
    return _listDoc.count;
}
#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_docModel.countTextSigned == 0 && _docModel.countTextWaitSign == 0 && _docModel.countTextWaitingInitial == 0) {
        static NSString* identifier = @"WorkNotDataCell";
        WorkNotDataCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            [tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setupUIWithContent:LocalizedString(@"Hiện tại Đ/C không có văn bản nào")];
        return cell;
        
    }
    else
    {
        static NSString* identifier = @"VOffice_DocumentCell_iPad";
        VOffice_DocumentCell_iPad *docCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(docCell == nil){
            [tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
            docCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            docCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //Fixed data
        [docCell updateValue:_docModel forType:[_listDoc[indexPath.row] integerValue]];
        return docCell;
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deSelectRow:indexPath];
    if (_listDoc.count == 0) {
        return;
    }
    _lastIndex = [_listDoc[indexPath.row] integerValue];
    VOffice_ListDocumentMain_iPad *documentMainVC = NEW_VC_FROM_NIB(VOffice_ListDocumentMain_iPad, @"VOffice_ListDocumentMain_iPad");
    documentMainVC.delegate = self;
    [self pushIntegrationVC:documentMainVC];
}

#pragma mark - VOfficeProtocol
- (DocType)docType
{
    return _lastIndex;
}
- (void)setDocType:(DocType)docType
{
    _lastIndex = docType;
}
@end
