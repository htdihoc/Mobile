//
//  QLTT_InfoDetailVC.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_InfoDetailVC.h"
#import "NSException+Custom.h"
#import "Common.h"
#import "SVPullToRefresh.h"
#import "NSString+Util.h"
typedef enum: NSUInteger {
    QLTT_InfoDetailVC_Content = 0,
    QLTT_InfoDetailVC_Document,
} QLTT_InfoDetailVCSection;

@interface QLTT_InfoDetailVC () <UITableViewDelegate, UITableViewDataSource, QLTT_PreviewVCDelegate, QLTT_InfoDetailDelegate, QLTT_InfoDetailContentCellDelegate>
{
    BOOL isActive;
    NSIndexPath *_lastIndex;
    BOOL _firstReload;
    __weak QLTT_InfoDetailVC *weakSelf;
}
@end

@implementation QLTT_InfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateModel:)
                                                 name:@"updateQLTTMasterDocumentModel"
                                               object:nil];
    self.qltt_InfoDetail.tbl_ListDocument.alwaysBounceVertical = NO;
    [self initValues];
    [self reloadData];
}
- (void) updateModel:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"updateQLTTMasterDocumentModel"])
    {
        [self reloadData];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"updateQLTTMasterDocumentModel"
                                                  object:nil];
}
- (void)dismissVC:(UIGestureRecognizer *)recognizer
{
    CGPoint tapLocation = [recognizer locationInView:self.qltt_InfoDetail.tbl_ListDocument];
    NSIndexPath *indexPath = [self.qltt_InfoDetail.tbl_ListDocument indexPathForRowAtPoint:tapLocation];
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        recognizer.cancelsTouchesInView = NO;
    }
    if ([self.delegate respondsToSelector:@selector(dismissVC:)])
    {
        [self.delegate dismissVC:recognizer];
    }
}
- (void)initValues
{
    weakSelf = self;
    self.qltt_InfoDetail.delegate = self;
    self.qltt_InfoDetail.tbl_ListDocument.delegate = self;
    self.qltt_InfoDetail.tbl_ListDocument.dataSource = self;
    [self.qltt_InfoDetail.tbl_ListDocument registerNib:[UINib nibWithNibName:@"QLTT_InfoDetailContentCell" bundle:nil] forCellReuseIdentifier:@"QLTT_InfoDetailContentCell"];
    [self.qltt_InfoDetail.tbl_ListDocument registerNib:[UINib nibWithNibName:@"QLTT_InfoDetailDocumentCell" bundle:nil] forCellReuseIdentifier:@"QLTT_InfoDetailDocumentCell"];

    self.qltt_InfoDetail.tbl_ListDocument.showsPullToRefresh = NO;
    [self.qltt_InfoDetail.tbl_ListDocument addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        
        if ([Common checkNetworkAvaiable]) {
            [self.delegate loadDetailDocumentWith:nil isRefresh:YES];
            [self reloadData];
        }else
        {
            [self dismissRefreshActivity];
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
        //Refresh data here
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
    } position:SVPullToRefreshPositionTop];
}
- (void)reloadData
{
    isActive = NO;
    [self dismissRefreshActivity];
    if ([self.delegate getMasterDocumentDetailModel].fileAttachment.count == 0) {
        _firstReload = YES;
    }
    [self.qltt_InfoDetail enterDataToView:[self.delegate getMasterDocumentDetailModel]];
    [self.qltt_InfoDetail reloadTableView];
    
}
- (void)dismissRefreshActivity
{
    [weakSelf.qltt_InfoDetail.tbl_ListDocument.pullToRefreshView stopAnimating];
}
- (void)loadDataAt:(NSInteger)index{
    //    @"document/20170529/559837/zyzWONQofqYfFWD1QrVrUowxXwU=.png"
    if ([[[[self fileType] mimeTypeForFileAtPath] componentsSeparatedByString:@"/"].firstObject isEqualToString:@"audio"] || [[[[self fileType] mimeTypeForFileAtPath] componentsSeparatedByString:@"/"].firstObject isEqualToString:@"video"])
    {
        [self handleErrorFromResult:nil withException:[NSException initWithString:LocalizedString(@"Ứng dụng chưa hỗ trợ mở định dạng này")] inView:self.view];
        return;
        
    }
    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    [QLTT_InfoDetailController loadData:[self.delegate getMasterDocumentDetailModel].fileAttachment[index].filePath completion:^(BOOL success, NSData *resultData, NSException *exception, NSDictionary *error) {
        [self dismissHub];
        if (exception) {
            [self handleErrorFromResult:nil withException:exception inView:self.view];
            return;
        }
        if (success) {
            if (resultData.length/1024.0f/1024.0f < 300) {
                QLTT_PreviewVC *previewVC;
                previewVC = NEW_VC_FROM_NIB(QLTT_PreviewVC, @"QLTT_PreviewVC");
                previewVC.dataToShow = resultData;
                previewVC.fileType = [self fileType];
                
                if ([self.delegate respondsToSelector:@selector(isPushPreview:)]) {
                    [self.delegate isPushPreview:YES];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate pushVC:previewVC];
                });
            }
            else
            {
                [self handleErrorFromResult:nil withException:[NSException initWithString:LocalizedString(@"Dung lượng file lớn hơn 300MB")] inView:self.view];
            }
            
        }
        else
        {
            if ([[error valueForKey:@"resultCode"] integerValue] == 201) {
                [self handleErrorFromResult:nil withException:[NSException initWithString:LocalizedString(@"Tệp tin không tồn tại")] inView:self.view];
            }else{
                [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
            }
            
            
        }
    }];
    
}
#pragma mark QLTT_PreviewPDF
- (NSString *)fileType
{
    return [[self.delegate getMasterDocumentDetailModel].fileAttachment[_lastIndex.row].filePath pathExtension];
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == QLTT_InfoDetailVC_Document) {
        _lastIndex = indexPath;
        [self loadDataAt:indexPath.row];
    } else {
        return;
    }
    
}

#pragma mark UITableViewDataSource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == QLTT_InfoDetailVC_Document) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 24)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, tableView.frame.size.width, 18)];
        label.textColor = AppColor_TittleTextColor;
        label.backgroundColor = AppColor_MainAppBackgroundColor;
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        NSString *string = LocalizedString(@"QLTT_InfoDetail_Thông_tin_tài_liệu_đính_kèm");
        [label setText:string];
        [view addSubview:label];
        view.backgroundColor = AppColor_MainAppBackgroundColor;
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == QLTT_InfoDetailVC_Document) {
        return 32;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == QLTT_InfoDetailVC_Content) {
        if([[self.delegate getMasterDocumentDetailModel].description checkSpace] || [self.delegate getMasterDocumentDetailModel].description == nil)
        {
            return QLTT_InfoDetailVC_Content;
        }
        else
        {
            return QLTT_InfoDetailVC_Document;
        }
        
    } else {
        return [self.delegate getMasterDocumentDetailModel].fileAttachment.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //info detailView
    static NSString *ID_CellContent = @"QLTT_InfoDetailContentCell";
    static NSString *ID_CELLDocument = @"QLTT_InfoDetailDocumentCell";
    if (indexPath.section == QLTT_InfoDetailVC_Content) {
        QLTT_InfoDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CellContent];
        cell.delegate = self;
        [cell enterDataToView:[self.delegate getMasterDocumentDetailModel] index:indexPath.row];
        return cell;
    } else {
        QLTT_InfoDetailDocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELLDocument];
        QLTTFileAttachmentModel *model = [self.delegate getMasterDocumentDetailModel].fileAttachment[indexPath.row];
        [cell setupdataForView:model];
        return cell;
    }
}

#pragma mark QLTT_InfoDetailContentCellDelegate
- (void)viewMore
{
    isActive = !isActive;
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:index, nil];
    [self.qltt_InfoDetail.tbl_ListDocument reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (BOOL)isActive
{
    return isActive;
}
@end
