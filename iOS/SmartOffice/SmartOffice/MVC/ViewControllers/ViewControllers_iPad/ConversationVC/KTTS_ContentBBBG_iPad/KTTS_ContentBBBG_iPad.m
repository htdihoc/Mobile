//
//  KTTS_ContentBBBG_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/25/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_ContentBBBG_iPad.h"
#import "KTTS_ContentBBBG_CELL_iPad.h"
#import "KTTS_ContentAssetBBBG_VC_iPad.h"
#import "BBBGAssetModel.h"
#import "KTTSProcessor.h"
#import "DetailBBBGModel.h"

@interface KTTS_ContentBBBG_iPad () {
@protected KTTS_ContentAssetBBBG_VC_iPad *contentVC;
}
@end

@implementation KTTS_ContentBBBG_iPad

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.start = 0;
    self.limit = 10;
    self.id_BBBG_detail = @"0";
    self.BBBG_data_array_detail = [NSMutableArray new];
    
    self.tbl_Content.delegate = self;
    self.tbl_Content.dataSource = self;
    self.tbl_Content.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tbl_Content registerNib:[UINib nibWithNibName:@"KTTS_ContentBBBG_CELL_iPad" bundle:nil] forCellReuseIdentifier:@"KTTS_ContentBBBG_CELL_iPad"];
}

- (void) getData {
    NSDictionary *parameter = @{
                                @"idBBBGTSCN": self.id_BBBG_detail,
                                @"start": IntToString(self.start),
                                @"limit": IntToString(self.limit)
                                };
    [KTTSProcessor postDetailBBBG:parameter handle:^(id result, NSString *error) {
        NSArray *array = result[@"listMerEntity"];
        self.BBBG_data_array_detail = (NSMutableArray *)[self.BBBG_data_array_detail arrayByAddingObjectsFromArray:array];
        self.BBBG_data_array_detail = [DetailBBBGModel arrayOfModelsFromDictionaries: array error:nil];
        //   self.total_record.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.BBBG_data_array.count];
        [self.tbl_Content reloadData];
        [self setupUI];
    } onError:^(NSString *Error) {
        //
    } onException:^(NSString *Exception) {
        //
    }];
}

- (void)setupUI {
    
    self.lbl_contentBBBG.text = [NSString stringWithFormat:@"Chi tiết %@", self.goods_name];
    
    switch (self.isStatus) {
        case 0:
        {
            self.heightMiddleView.constant = 80;
            self.btn_confirm.hidden = NO;
            self.btn_refuse.hidden = NO;
        }
            break;
        case 1:{
            self.heightMiddleView.constant = 0;
            self.btn_confirm.hidden = YES;
            self.btn_refuse.hidden = YES;
        }
            break;
        case 2:{
            self.heightMiddleView.constant = 80;
            self.btn_confirm.hidden = YES;
            self.btn_refuse.hidden = YES;
        }
            break;
        default:
            break;
    }
    [self layoutIfNeeded];
    
}


#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.BBBG_data_array_detail.count;
}

#pragma mark TableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID_CELL = @"KTTS_ContentBBBG_CELL_iPad";
    KTTS_ContentBBBG_CELL_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KTTS_ContentBBBG_CELL_iPad" bundle:nil] forCellReuseIdentifier:ID_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    }
    
    cell.lbl_cellNumber.text = IntToString(indexPath.row + 1);
    DetailBBBGModel *detailBBBGModel = self.BBBG_data_array_detail[indexPath.row];
    cell.lbl_assetName.text = detailBBBGModel.catMerName;
    cell.lbl_assetCount.text = IntToString(detailBBBGModel.count);
    cell.lbl_assetSerial.text = detailBBBGModel.catMerCode;
    
    switch (detailBBBGModel.stt) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UIAccessibilityTraitNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate actionShowContentVC:(int)indexPath.row array: self.BBBG_data_array_detail];
}
@end
