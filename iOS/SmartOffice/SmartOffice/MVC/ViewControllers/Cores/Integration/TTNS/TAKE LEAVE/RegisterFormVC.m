//
//  RegisterFormVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "RegisterFormVC.h"
#import "RegisterFormCell.h"
#import "RegTakeLeaveVC.h"
#import "LeavePersonalReasonVC.h"
#import "SickLeaveFormVC.h"
#import "BirthLeaveFormVC.h"
#import "CompassionateLeaveVC.h"

typedef enum : NSInteger{
    typeNghiPhep = 0,
    typeNghiViecRieng,
    typeNghiOm,
    typeNghiConOm,
    typeNghiVoSinhCon
}typeRegisterMoveScreen;

@interface RegisterFormVC ()<UITableViewDataSource, UITableViewDelegate>{
@protected NSArray *imgArray;
@protected NSArray *titleArray;
@protected BOOL isSickLeave;
}

@end

@implementation RegisterFormVC

#pragma mark lifecycler
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupArray];
    self.backTitle      = LocalizedString(@"TTNS_TAO_MOI_DON");
}

#pragma mark UI
- (void)setupArray{
    titleArray = @[LocalizedString(@"TTNS_NGHI_PHEP"),
                   LocalizedString(@"TTNS_NGHI_VIEC_RIENG"),
                   LocalizedString(@"TTNS_NGHI_OM"),
                   LocalizedString(@"TTNS_NGHI_CON_OM"),
                   LocalizedString(@"TTNS_NGHI_VO_SINH_CON")];
    
    imgArray   = @[@"icon_home",
                   @"icon_ngi_viec_rieng",
                   @"icon_ngi_om", @"icon_children",
                   @"icon_ngi_vo_sinh"];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"RegisterFormCell";
    RegisterFormCell *cell          = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[RegisterFormCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.typeRegisterLB.text    = titleArray[indexPath.row];
    cell.iconTypeRegister.image = [UIImage imageNamed:imgArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == typeNghiPhep) {
        CompassionateLeaveVC *regTakeLeaveVC = NEW_VC_FROM_NIB(CompassionateLeaveVC, @"CompassionateLeaveVC");
         [self.navigationController pushViewController:regTakeLeaveVC animated:YES];
    } else if(indexPath.row == typeNghiViecRieng){
        LeavePersonalReasonVC *leavePersonalReasonVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LeavePersonalReasonVC"];
        [self.navigationController pushViewController:leavePersonalReasonVC animated:YES];
        
    } else if(indexPath.row == typeNghiOm || indexPath.row == typeNghiConOm) {
        SickLeaveFormVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SickLeaveFormVC"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        BirthLeaveFormVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BirthLeaveFormVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark UIAction
- (IBAction)backAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
@end
