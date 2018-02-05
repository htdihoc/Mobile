//
//  BBBGAssetViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BBBGAssetViewController.h"
#import "BBBGAssetCell.h"
#import "PropertyDetailsViewController.h"
#import "KTTSProcessor.h"
#import "DetailBBBGModel.h"

@interface BBBGAssetViewController () <TTNS_BaseNavViewDelegate, UITableViewDataSource, UITableViewDelegate, SOSearchBarViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *BBBGAssetTableView;
@property (weak, nonatomic) IBOutlet UILabel *total_record;

@property (strong, nonatomic) NSMutableArray *BBBG_data_array, *data_BBBG;
@property (strong, nonatomic) NSArray *data_FilterBBBG;
@property (assign, nonatomic) NSInteger start;
@property (assign, nonatomic) NSInteger limit;
@property (nonatomic) BOOL isFiltered;
@property (assign, nonatomic) NSInteger countBBBG;

@end

@implementation BBBGAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.start = 0;
    self.limit = 20;
    
    self.search_view.searchBar.placeholder = LocalizedString(@"SearchSerial...");
    
    self.nameBBBG1.text = self.bbbgModelAsset.minuteHandOverCode;
    self.nameBBBG2.text = self.bbbgModelAsset.minuteHandOverCode;
    self.reasonBBBG2.text = [NSString stringWithFormat:@"Lý do : %@", self.bbbgModelAsset.description];
    
    switch (self.isStatus) {
        case 0:
        {
            // đã bàn giao, chưa xác nhận
            self.height_asset_name_view.constant = 0;
            self.statusBBBG2.text = @"Trạng thái : Đã bàn giao, chưa xác nhận";
        }
            break;
        case 1:
        {
            // đã xác nhận
            self.height_button_view.constant = 0;
            self.height_refuse_view.constant = 0;
            self.statusBBBG2.text = @"Trạng thái : Đã xác nhận";
        }
            break;
        case 2:
        {
            // đã từ chối
            self.height_button_view.constant = 0;
            self.height_asset_name_view.constant = 0;
            self.statusBBBG2.text = @"Trạng thái : Bị từ chối";
        }
            break;
        default:
            break;
    }
    [self.view layoutIfNeeded];
    
    self.BBBG_data_array = [NSMutableArray new];
    self.data_BBBG = [NSMutableArray new];
    self.backTitle = @"BBBG tài sản";
    self.BBBGAssetTableView.estimatedRowHeight = 190;
    self.BBBGAssetTableView.rowHeight = UITableViewAutomaticDimension;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    self.search_view.delegate = self;
    [self countData];
}

- (void) countData {
    NSDictionary *parameter = @{
                                @"idBBBGTSCN": self.id_BBBG_detail
                                };
    [KTTSProcessor postCountDataDetailBBBG:parameter handle:^(id result, NSString *error) {
        self.countBBBG = [result[@"return"] integerValue];
        self.total_record.text = IntToString(self.countBBBG);
        [self getData];
    } onError:^(NSString *Error) {
        //
    } onException:^(NSString *Exception) {
        //
    }];
}

- (void) getData {
    NSDictionary *parameter = @{
                                @"idBBBGTSCN": self.id_BBBG_detail,
                                @"start": IntToString(0),
                                @"keyword": self.search_view.text,
                                @"limit": IntToString(self.countBBBG)
                                };
    [KTTSProcessor postDetailBBBG:parameter handle:^(id result, NSString *error) {
        NSArray *array = result[@"listMerEntity"];
        [self.BBBG_data_array addObjectsFromArray:array];
        [self.BBBGAssetTableView reloadData];
    } onError:^(NSString *Error) {
        //
    } onException:^(NSString *Exception) {
        //
    }];
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark SOSearchBarViewDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self dismissKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self getData];
    return YES;
}

- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText {
    [self searchlocalwith:searchText];
}

- (void) searchlocalwith:(NSString *)searchText {
    if (searchText.length == 0) {
        _isFiltered = NO;
        [self.BBBGAssetTableView reloadData];
    } else {
        _isFiltered = YES;
        NSPredicate *p = [NSPredicate predicateWithFormat:@"catMerName CONTAINS[cd] %@ or serialNumber CONTAINS[cd] %@", searchText, searchText];
        self.data_FilterBBBG = [self.BBBG_data_array filteredArrayUsingPredicate:p];
        [self.BBBGAssetTableView reloadData];
    }
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isFiltered) {
        return self.data_FilterBBBG.count;
    } else {
        return self.BBBG_data_array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_isFiltered) {
        self.data_BBBG = [DetailBBBGModel arrayOfModelsFromDictionaries: self.BBBG_data_array error:nil];
    } else {
        self.data_BBBG = [DetailBBBGModel arrayOfModelsFromDictionaries: self.data_FilterBBBG error:nil];
    }
    
    DetailBBBGModel *detailBBBGModel = self.data_BBBG[indexPath.row];
    
    BBBGAssetCell *bbbgCell = (BBBGAssetCell *)[tableView dequeueReusableCellWithIdentifier:@"bBBGAssetCell"];
    if (bbbgCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BBBGAssetCell" owner:self options:nil];
        bbbgCell = [nib objectAtIndex:0];
    }
    bbbgCell.view_cell_number.text = IntToString(indexPath.row+1);
    bbbgCell.value_goods_name.text = detailBBBGModel.catMerName;
    bbbgCell.value_number.text = IntToString(detailBBBGModel.count);
    bbbgCell.value_serial.text = detailBBBGModel.serialNumber;
    
    switch (detailBBBGModel.stt) {
        case 0:
        {
            bbbgCell.value_status.text = @"Chưa xác nhận";
            bbbgCell.value_status.textColor = RGB(254, 94, 8);
        }
            break;
        case 1:
        {
            bbbgCell.value_status.text = @"Đã xác nhận";
            bbbgCell.value_status.textColor = RGB(2, 127, 185);
        }
            break;
        case 2:
        {
            bbbgCell.value_status.text = @"Bị từ chối";
            bbbgCell.value_status.textColor = RGB(254, 8, 8);
        }
            break;
        default:
        {
            bbbgCell.value_status.text = @"Không xác định";
        }
            break;
    }
    
    [bbbgCell.btn_view_detail addTarget:self action:@selector(viewBBBGDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    bbbgCell.btn_view_detail.tag = indexPath.row;
    bbbgCell.selectionStyle = UIAccessibilityTraitNone;
    return bbbgCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushViewControllerWith:indexPath.row];
}

- (void) viewBBBGDetailAction:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
//    NSLog(@"%ld", (long)button.tag);
    [self pushViewControllerWith:button.tag];
}

- (void) pushViewControllerWith:(NSInteger)index {
    DetailBBBGModel *detailBBBGModel = self.data_BBBG[index];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyDetails" bundle:nil];
    PropertyDetailsViewController *propertyDetails = (PropertyDetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PropertyDetailsViewController"];
    
    propertyDetails.isStatus = detailBBBGModel.stt;
    propertyDetails.typeKTTS = 2;
    propertyDetails.value_commodity_code = detailBBBGModel.catMerCode;
    propertyDetails.value_commodity_name = detailBBBGModel.catMerName;
    propertyDetails.value_unit = detailBBBGModel.unitName;
    propertyDetails.value_number = IntToString(detailBBBGModel.count);
    propertyDetails.value_serial = detailBBBGModel.serialNumber;
    propertyDetails.value_manufacturer = detailBBBGModel.companyName;
    propertyDetails.value_aspect = detailBBBGModel.statusName;
    propertyDetails.merEntityId = detailBBBGModel.merEntityId;
    
    NSDate *date_1 = [NSDate dateWithTimeIntervalSince1970: (detailBBBGModel.minuteHandOverDate/1000)];
    NSDateFormatter *format_1 = [NSDateFormatter new];
    [format_1 setDateFormat: @"dd/MM/yyyy"];
    propertyDetails.value_expiry_date = [format_1 stringFromDate:date_1];
    
    propertyDetails.value_asset_type = detailBBBGModel.stationCode;
    
    NSDate *date_2 = [NSDate dateWithTimeIntervalSince1970: (detailBBBGModel.usedDate/1000)];
    NSDateFormatter *format_2 = [NSDateFormatter new];
    [format_2 setDateFormat: @"dd/MM/yyyy"];
    propertyDetails.value_use_time = [format_2 stringFromDate:date_2];
    
    propertyDetails.value_price = IntToString(detailBBBGModel.assetPrice);
    //    propertyDetails.value_status = detailBBBGModel.privateManagerName;
    
    [self.navigationController pushViewController:propertyDetails animated:YES];
}

- (IBAction)btnRefuseAction:(id)sender {
    
}

- (IBAction)btnAcceptAction:(id)sender {
    
}
@end
