//
//  DetailMissionVC.m
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailMissionVC.h"
#import "DetailMissionCell.h"
#import "MissionModel.h"
#import "DetailMissionModel.h"
#import "Common.h"
#import "VOfficeProcessor.h"
#import "VOffice_DetailMission_iPad.h"
#import "DetailMissionVC.h"
#import "DiscussionListVC.h"

@interface DetailMissionVC (){
    DetailMissionModel *_detailModel;
}
@property(strong, nonatomic)VOffice_MissionDetailController* missionDetailController;
@end

@implementation DetailMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Dynamic Cell
    self.tblContent.rowHeight = UITableViewAutomaticDimension;
    self.tblContent.estimatedRowHeight = 80.0; // set to whatever your "average" cell height is
    self.missionDetailController = [[VOffice_MissionDetailController alloc] init];
    [self createUI];
    //Load Data
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
    [self setupColor];
    [self setupNav];
}
- (void)setupColor{
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
}

- (void)setupNav{
    self.backTitle  = LocalizedString(@"VOffice_DetailMission_iPad_Chi_tiết_nhiệm_vụ");
    self.subTitle   = self.subTitle;
    self.rightTitle = LocalizedString(@"kVOFF_GOTO_VOFFICE_TITLE_BUTTON");
}


#pragma mark - Load Data
- (void)loadData{
    [[Common shareInstance] showHUDWithTitle:@"Loading..." inView:self.tblContent];
    [self.missionDetailController loadData:_missionModel completion:^(BOOL success, DetailMissionModel *missionDetail, NSException *exception,NSDictionary *error) {
        [[Common shareInstance] dismissHUD];
        if (success) {
            _detailModel = missionDetail;
            [_tblContent reloadData];
        }else{
            if (exception) {
                [self handleErrorFromResult:nil withException:exception inView:self.view];
            }
            else
            {
                [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
            }
        }
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
    [self pushToChatView];
}


#pragma mark - UITableView DataSource
//Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_detailModel) {
        return 0;
    } else if (self.segmentCurrent == 0) {
        return 8;
    } else {
        return  7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID_CELL = @"DetailMissionCell_ID";
    DetailMissionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    [cell setupDataByModel:_detailModel atIndex:indexPath.row];
    return cell;
}

@end
