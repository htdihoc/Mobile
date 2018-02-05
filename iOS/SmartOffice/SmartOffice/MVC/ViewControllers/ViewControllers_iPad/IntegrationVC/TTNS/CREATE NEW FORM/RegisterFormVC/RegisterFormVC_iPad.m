//
//  RegisterFormVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "RegisterFormVC_iPad.h"
#import "RegisterFormCell_iPad.h"

@interface RegisterFormVC_iPad ()<UITableViewDataSource, UITableViewDelegate>{
@protected NSArray *imgArray;
@protected NSArray *titleArray;
}
// Create Delegate : ID

@end

@implementation RegisterFormVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupArray];
}

- (void)setupArray{
    titleArray = @[LocalizedString(@"TTNS_NGHI_PHEP"), LocalizedString(@"TTNS_NGHI_VIEC_RIENG"), LocalizedString(@"TTNS_NGHI_OM"), LocalizedString(@"TTNS_NGHI_CON_OM"),LocalizedString(@"TTNS_NGHI_VO_SINH_CON")];
    imgArray   = @[@"icon_home", @"icon_ngi_viec_rieng", @"icon_ngi_om", @"icon_children", @"icon_ngi_vo_sinh"];
}

// MARK:- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *cellIdentifier = @"RegisterFormCell_iPad";
    //    RegisterFormCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //
    //    if(cell == nil){
    //        [tableView registerNib:[UINib nibWithData:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    //        cell                        = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //        cell.selectionStyle         = UITableViewCellSelectionStyleNone;
    //    }
    //    cell.typeRegisterLB.text = titleArray[indexPath.row];
    //    cell.iconTypeRegister.image = [UIImage imageNamed:imgArray[indexPath.row]];
    //    return cell;
    
    static NSString* Identifier         = @"RegisterFormCell_iPad";
    
    RegisterFormCell_iPad *cell              = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
        cell                            = [tableView dequeueReusableCellWithIdentifier:Identifier];
        cell.selectionStyle             = UITableViewCellSelectionStyleNone;
    }
    
    cell.typeRegisterLB.text = titleArray[indexPath.row];
    cell.iconTypeRegister.image = [UIImage imageNamed:imgArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
