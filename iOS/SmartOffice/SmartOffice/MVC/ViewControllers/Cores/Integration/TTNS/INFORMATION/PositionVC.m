//
//  PositionVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "PositionVC.h"
#import "PositionCell.h"
#import "TTNSProcessor.h"
#import "TTNS_SalaryProcessModel.h"
#import "Common.h"


@interface PositionVC ()<UITableViewDataSource, UITableViewDelegate, TTNS_BaseNavViewDelegate>{
    
    NSMutableArray *_salaryArray;
}


@end

@implementation PositionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backTitle = @"Diễn biến lương chức danh";
    
    _salaryArray = [NSMutableArray new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navView.delegate = self;
    
    [self loadData];
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

- (void)loadData {
    [TTNSProcessor getSalaryProcess:[GlobalObj getInstance].ttns_employID callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if (success) {
//            NSDictionary *data      = [resultDict valueForKey:@"data"];
//            NSDictionary *entity    = [data valueForKey:@"entity"];
//            _salaryModel = [[TTNS_SalaryProcessModel alloc] initWithDictionary:entity error:nil];
            
            NSArray *data   = resultDict[@"data"][@"entity"];
            _salaryArray = [TTNS_SalaryProcessModel arrayOfModelsFromDictionaries:data error:nil];
            [self.tableView reloadData];
        } else {
            [self handleErrorFromResult:resultDict withException:nil inView:self.view];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _salaryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* Identifier         = @"PositionCell";
    
    PositionCell *cell                  = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
        cell                            = [tableView dequeueReusableCellWithIdentifier:Identifier];
        cell.selectionStyle             = UITableViewCellSelectionStyleNone;
    }
    // setupCell
    
    TTNS_SalaryProcessModel *salaryModel = _salaryArray[indexPath.row];
    
    NSString *date = [[Common shareInstance] fullNormalStringDateFromServerDate:salaryModel.signDate serverFormatDate:@"dd/MM/yyyy"];
    cell.dateLB.text = [NSString stringWithFormat:@"%@", date];
    cell.salaryLB.text= [NSString stringWithFormat:@"%@", salaryModel.hscd];
    cell.positionLB.text = [NSString stringWithFormat:@"%@", salaryModel.salaryWage];
    
    if (salaryModel.salaryPosition == nil) {
        cell.salaryLB.text = [NSString stringWithFormat:@"Không có data !"];
        cell.salaryLB.textColor = AppColor_BorderForCancelButton;
    } else {
        cell.salaryLB.text = [NSString stringWithFormat:@"%@", salaryModel.salaryPosition];

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   // return UITableViewAutomaticDimension;
    return 180;
}

@end
