//
//  PropertyDetailsViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "PropertyDetailsViewController.h"
#import "PropertyDetailsCell.h"
#import "AssetConfirmViewController.h"
#import "KTTSProcessor.h"
#import "KTTS_CancelStatus_VC_iPad.h"
#import "MZFormSheetController.h"

typedef NS_ENUM(NSInteger, Status) {
    isCancelStatus = 0,     // xác nhận
    isConfirmStatus = 1,    // hủy
    isAllStatus = 2         // xác nhận và hủy
};

@interface PropertyDetailsViewController () <UITableViewDataSource, UITableViewDelegate, TTNS_BaseNavViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *propertyDetailsTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelOrConfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (nonatomic) Status status;

@end

@implementation PropertyDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.typeKTTS == 1) {
        self.btnCancelOrConfirm.hidden = NO;
        self.btnCancel.hidden = NO;
        self.btnConfirm.hidden = NO;
        self.hightBtnCancelOrConfirm.constant = 50;
        self.hightBtnCancel.constant = 50;
        self.hightBtnConfirm.constant = 50;
    } else {
        self.btnCancelOrConfirm.hidden = YES;
        self.btnCancel.hidden = YES;
        self.btnConfirm.hidden = YES;
        self.hightBtnCancelOrConfirm.constant = 0;
        self.hightBtnCancel.constant = 0;
        self.hightBtnConfirm.constant = 0;
    }
    
    switch (self.isColorButton) {
        case isCancelStatus: {
            [self setColorCancel];
        }
            break;
        case isConfirmStatus: {
            [self setColorConfirm];
        }
            break;
        case isAllStatus: {
            self.btnCancelOrConfirm.hidden = YES;
            break;
        }
        default:
            break;
    }
    self.backTitle = @"Chi tiết tài sản";
    self.propertyDetailsTableView.estimatedRowHeight = 445;
    self.propertyDetailsTableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PropertyDetailsCell *cell = (PropertyDetailsCell *)[tableView dequeueReusableCellWithIdentifier:@"propertyDetailsCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PropertyDetailsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.value_commodity_code.text = self.value_commodity_code;
    cell.value_commodity_name.text = self.value_commodity_name;
    cell.value_unit.text = self.value_unit;
    cell.value_number.text = self.value_number;
    cell.value_serial.text = self.value_serial;
    cell.value_manufacturer.text = self.value_manufacturer;
    cell.value_aspect.text = self.value_aspect;
    cell.value_expiry_date.text = self.value_expiry_date;
    cell.value_asset_type.text = self.value_asset_type;
    cell.value_use_time.text = self.value_use_time;
    cell.value_price.text = self.value_price;
    cell.value_status.text = self.value_status;
    
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)btnCancelOrConfirmAction:(id)sender {
    switch (self.isColorButton) {
        case isCancelStatus:
        {
            [self actionShowCancelStatusVC];
        }
            break;
        case isConfirmStatus:
        {
            [self pushConfirmViewController];
        }
            break;
        default:
            break;
    }
}

- (void)actionShowCancelStatusVC {
    KTTS_CancelStatus_VC_iPad *vc = NEW_VC_FROM_NIB(KTTS_CancelStatus_VC_iPad, @"KTTS_CancelStatus_VC_iPad");
    vc.merEntityId = IntToString(self.merEntityId);
    vc.strStatus = self.value_status;
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_HEIGHT_LANDSCAPE-40, 200);
    //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.cornerRadius = 12;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
        {
            [self cancelNotification];
        }
            break;
            
        default:
            break;
    }
}

// TO DO ...
- (void) cancelNotification {
//    NSDictionary *parameter = @{
//                                @"merEntityId": IntToString(self.merEntityId),
//                                @"type": IntToString(self.count)
//                                };
//    [KTTSProcessor postCancelNotification:parameter handle:^(id result, NSString *error) {
//        
//    }];
}

// red
- (void) setColorCancel {
    self.status = isConfirmStatus;
    self.btnCancelOrConfirm.backgroundColor = RGB(240, 82, 83);
    [self.btnCancelOrConfirm setTitle:@"Hủy thông báo" forState:UIControlStateNormal];
}

// blue
- (void) setColorConfirm {
    self.status = isCancelStatus;
    self.btnCancelOrConfirm.backgroundColor = RGB(14, 133, 188);
    [self.btnCancelOrConfirm setTitle:@"Xác nhận tài sản" forState:UIControlStateNormal];
}

- (void) pushConfirmViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AssetConfirm" bundle:nil];
    AssetConfirmViewController *assetConfirm = (AssetConfirmViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AssetConfirmViewController"];
    assetConfirm.merEntityId = self.merEntityId;
    [self.navigationController pushViewController:assetConfirm animated:YES];
}

- (IBAction)cancelAction:(id)sender {
    [self actionShowCancelStatusVC];
}

- (IBAction)confirmAction:(id)sender {
    [self pushConfirmViewController];
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

@end
