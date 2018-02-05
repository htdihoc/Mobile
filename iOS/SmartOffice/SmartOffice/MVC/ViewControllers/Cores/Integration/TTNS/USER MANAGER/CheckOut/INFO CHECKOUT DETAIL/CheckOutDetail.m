//
//  CheckIn.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CheckOutDetail.h"
#import "InfoEmployDetailCell.h"
#import "InfoEmployCheckOut.h"
#import "SOTableViewRowAction.h"
#import "DismissTimeKeeping.h"
#import "CheckOutDetailModel.h"
#import "CheckOutDetailCell.h"

#import "ReasonModel.h"
#import "WorkPlaceModel.h"
#import "DetailRegisterInOutModel.h"

#import "Common.h"
#import "TTNSProcessor.h"

@interface CheckOutDetail () <UITableViewDataSource, UITableViewDelegate>
{
@protected CheckOutDetailModel *infoEmployDetail;
@protected ReasonModel *reasonModel;
@protected WorkPlaceModel *workPlaceModel;
@protected DetailRegisterInOutModel *model;
@protected NSArray *keys;
@protected NSArray *values;
}
@end

@implementation CheckOutDetail



#pragma mark LifeCycler
- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBtnAttribute = [[BottomButton alloc] initWithDefautRedColor:LocalizedString(@"CheckOutDetail_Từ_chối")];
    self.rightBtnAttribute = [[BottomButton alloc] initWithDefautBlueColor:LocalizedString(@"CheckOutDetail_Phê_duyệt")];
    self.backTitle = LocalizedString(@"CheckOutDetail_Thông_tin_đăng_ký");
    [self registerCellWith:@"CheckOutDetailCell"];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.backgroundColor = [UIColor whiteColor];
    [self loadingData];
    [self generateData];
  
}

#pragma mark UI

- (void)setupUI{
    
}

- (void)updateUI{
    
}


- (void)generateData
{
    keys = @[LocalizedString(@"CheckOutDetail_Nơi_đến"), LocalizedString(@"CheckOutDetail_Lý_do_đăng_ký"), LocalizedString(@"CheckOutDetail_Lý_do_chi_tiết"), LocalizedString(@"CheckOutDetail_Thời_gian_ra_ngoài")];
    values = @[@"Linh đàm hoàng mai",
               @"Gặp đối tác",
               @"Bàn về UX và UI",
               @"8h00 - 9hh00"];
    infoEmployDetail = [[CheckOutDetailModel alloc] initWithDesticationPlace:@"Linh đàm hoàng mai" reason:@"Gặp đối tác" reasonDetail:@"Bàn về UX và UI" timeInterval:@"8h00 - 9hh00" state:0];
    
    [self.baseTableView reloadData];
}

- (NSString *)getValueWithKey:(NSString *)key
{
    return [infoEmployDetail valueForKey:key];
}


#pragma mark networking
- (void)loadingData{
    [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
    [TTNSProcessor getListRegisterWithId:self.empOutRegId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success){
            NSDictionary *data = [resultDict valueForKey:@"data"];
            model = [[DetailRegisterInOutModel alloc]initWithDictionary:data
                                                                  error:nil];
            [self loadDetailReason:model.reasonOutId workPlaceDetail:model.workPlaceId];
            [self.baseTableView reloadData];
            [[Common shareInstance]dismissHUD];
        } else {
            [[Common shareInstance]dismissHUD];
            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
        }
    }];
    
}

- (void)loadDetailReason:(NSInteger)reasonId workPlaceDetail:(NSInteger)workPlaceId{
    
    dispatch_group_t group = dispatch_group_create();
    // 1.
    dispatch_group_enter(group);
    [self getReasonDetail:reasonId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success){
            NSDictionary *data = [resultDict valueForKey:@"data"];
            reasonModel = [[ReasonModel alloc]initWithDictionary:data error:nil];
        } else {
            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
        }
        dispatch_group_leave(group);
    }];
    
    // 2.
    dispatch_group_enter(group);
    [self getWorkPlace:workPlaceId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success){
            NSDictionary *data = [resultDict valueForKey:@"data"];
            workPlaceModel = [[WorkPlaceModel alloc]initWithDictionary:data error:nil];
        } else {
            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
        }
        dispatch_group_leave(group);
    }];
    // all task complete
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self updateUI];
    });
}

#pragma mark request server

- (void)getRegisterDetail:(NSInteger)empOutRegId callBack:(Callback)callBack{
    [TTNSProcessor getListRegisterWithId:empOutRegId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
        // loading ( )
        
    }];
}

- (void)getReasonDetail:(NSInteger)reasonId callBack:(Callback)callBack{
    [TTNSProcessor getReasonWithId:reasonId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

- (void)getWorkPlace:(NSInteger)workPlaceId callBack:(Callback)callBack{
    [TTNSProcessor getWorkPlaceWithID:workPlaceId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}



#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"CheckOutDetailCell";
    
    CheckOutDetailCell *cell             = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CheckOutDetailCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lblTitle.text = keys[indexPath.row];
    cell.lblContent.text = values[indexPath.row];
    return cell;
}

#pragma mark IBAction

@end
