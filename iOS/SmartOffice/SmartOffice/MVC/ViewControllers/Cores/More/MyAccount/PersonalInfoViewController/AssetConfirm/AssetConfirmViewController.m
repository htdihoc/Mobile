//
//  AssetConfirmViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "AssetConfirmViewController.h"
#import "BBBGAssetCell.h"
#import "AssetConfirmCell.h"
#import "KPDropMenu.h"
#import "KTTSProcessor.h"
#import "UIAlertView+Blocks.h"

@interface AssetConfirmViewController () <TTNS_BaseNavViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    BBBGAssetCell *bbbgCell;
    AssetConfirmCell *assetConfirmCell;
}

@property (weak, nonatomic) IBOutlet UITableView *assetconfirmTableView;

@end

@implementation AssetConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backTitle = @"Xác nhận tài sản";
    self.assetconfirmTableView.estimatedRowHeight = 190;
    self.assetconfirmTableView.rowHeight = UITableViewAutomaticDimension;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
    [assetConfirmCell.datePicker removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        bbbgCell = (BBBGAssetCell *)[tableView dequeueReusableCellWithIdentifier:@"bBBGAssetCell"];
        if (bbbgCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BBBGAssetCell" owner:self options:nil];
            bbbgCell = [nib objectAtIndex:0];
        }
        bbbgCell.btn_view_detail.tag = indexPath.row;
        bbbgCell.selectionStyle = UIAccessibilityTraitNone;
        return bbbgCell;
    } else {
        assetConfirmCell = (AssetConfirmCell *)[tableView dequeueReusableCellWithIdentifier:@"assetConfirmCell"];
        if (assetConfirmCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AssetConfirmCell" owner:self options:nil];
            assetConfirmCell = [nib objectAtIndex:0];
        }
        assetConfirmCell.selectionStyle = UIAccessibilityTraitNone;
        return assetConfirmCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return UITableViewAutomaticDimension;
    } else {
        return 480;
    }
}

- (IBAction)confirmAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Xác nhận" message:@"Bạn chắc chắn muốn gửi xác nhận này?" delegate:self cancelButtonTitle:@"Hủy" otherButtonTitles:@"Gửi", nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [self sendConfirmAction];
            break;
        default:
            break;
    }
}

- (void) sendConfirmAction {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"merEntityId": IntToString(_merEntityId),
                                @"count": assetConfirmCell.text_number_not_used.text,
                                @"date": IntToString(assetConfirmCell.date),
                                @"type": IntToString(assetConfirmCell.type),
                                @"reason": assetConfirmCell.tv_reason.text
                                };
    [KTTSProcessor postKTTS_CONFIRM_TTTS:parameter handle:^(id result, NSString *error) {
        [self hideCustomHUB];
        if (self.delegate) {
            [self.delegate successAssetConfirmVC];
        }
    } onError:^(NSString *Error) {
        [self hideCustomHUB];
        [UIAlertView showWithTitle:@"Thông báo" message:Error style:UIAlertViewStyleDefault cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            //close alert
            DLog(@"Alert button index: %ld", buttonIndex);
            if (self.delegate) {
                [self.delegate errorAssetConfirmVC];
            }
        }];
    } onException:^(NSString *Exception) {
        [self hideCustomHUB];
        [UIAlertView showWithTitle:@"Thông báo" message:LocalizedString(@"Mất kết nối mạng") style:UIAlertViewStyleDefault cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            //close alert
            DLog(@"Alert button index: %ld", buttonIndex);
            if (self.delegate) {
                [self.delegate errorAssetConfirmVC];
            }
        }];
    }];
}

- (void) hideCustomHUB {
    [[Common shareInstance] dismissCustomHUD];
}

- (void)confirmAssetWithType:(NSInteger)type number:(NSInteger)number date:(NSInteger)date reason:(NSString *)reason {
    
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
