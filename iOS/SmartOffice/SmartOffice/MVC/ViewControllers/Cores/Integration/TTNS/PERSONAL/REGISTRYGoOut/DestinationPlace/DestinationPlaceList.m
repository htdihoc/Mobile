//
//  DestinationPlaceList.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DestinationPlaceList.h"
#import "Common.h"
#import "TTNSProcessor.h"
#import "WorkPlaceModel.h"
#import "DestinationListTableViewCell.h"

@interface DestinationPlaceList (){
    
}

@end

@implementation DestinationPlaceList


#pragma mark lifecycler
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backTitle = LocalizedString(@"TTNS_CheckListPlace_Danh_sách_địa_điểm");
    [self loadingData];
    [self.baseTableView reloadData];
}

#pragma mark request server

- (void)loadingData{
    [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
    [TTNSProcessor getListWorkPlaceWithType:@"ALL" callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success){
            DLog(@"get list workplace success: %@", resultDict);
            NSArray *data = [resultDict valueForKey:@"data"];
            self.array  = [WorkPlaceModel arrayOfModelsFromDictionaries:data error:nil];
            [self.baseTableView reloadData];
            [[Common shareInstance]dismissHUD];
        } else {
            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            [[Common shareInstance]dismissHUD];
        }
    }];
}

- (void)putBackData{
    WorkPlaceModel *model = self.array[self.indexSelect];
    NSString *address = [NSString stringWithFormat:@"%@ - %@", model.dataSource, model.name];
    
    if(self.delegate){
        [self.delegate didFinishChoiseWorkPlace:self workPlaceId:model.workPlaceId address:address];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DestinationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DestinationListTableViewCell class]) forIndexPath:indexPath];
    
    WorkPlaceModel *model = self.array[indexPath.row];
    NSString *address = [NSString stringWithFormat:@"%@ - %@", model.dataSource, model.name];
    cell.lbl_Address.text = address;
    
    if([self.lastIndex isEqual:indexPath])
    {
        cell.img_Check.hidden = NO;
    }
    else
    {
        cell.img_Check.hidden = YES;
    }
    
    if (cell.img_Check.hidden == NO) {
        DLog(@"%ld: NO", (long)indexPath.row);
    }
    
    return cell;
}



@end
