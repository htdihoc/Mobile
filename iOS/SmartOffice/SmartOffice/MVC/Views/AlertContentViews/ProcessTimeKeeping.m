//
//  Demo1.m
//  Demo
//
//  Created by NguyenDucBien on 4/10/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import "ProcessTimeKeeping.h"
#import "ButtonCheckBox.h"



@interface ProcessTimeKeeping ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_WorkType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Place;

@end

@implementation ProcessTimeKeeping

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextForViews];
    [self.cbFullTime setSelected:YES];
    [self.cbAtUnit setSelected:YES];
}
- (void)setupTextForViews
{
    _lbl_WorkType.text = LocalizedString(@"TTNS_ProcessTimeKeeping_Loại_công");
    _lbl_Place.text = LocalizedString(@"TTNS_ProcessTimeKeeping_Địa_điểm");
    _lbFullTime.text = LocalizedString(@"TTNS_ProcessTimeKeeping_Đi_làm_cả_ngày");
    _lbPartTime.text = LocalizedString(@"TTNS_ProcessTimeKeeping_Đi_làm_nửa_ngày");
    _lbOff.text = LocalizedString(@"TTNS_ProcessTimeKeeping_Nghỉ");
    _lbAtUnit.text = LocalizedString(@"TTNS_Tại_đơn_vị");
    _lbUnitInViettel.text = LocalizedString(@"TTNS_ProcessTimeKeeping_Đơn_vị_trong_Viettel");
    _lbUnitOutViettel.text = LocalizedString(@"TTNS_ProcessTimeKeeping_Đơn_vị_ngoài_Viettel");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)checkRefreshWorkType {
    [self.cbFullTime refresh];
    [self.cbPartTime refresh];
    [self.cbOff refresh];
    
    self.lbAtUnit.alpha = 1;
    self.lbUnitInViettel.alpha = 1;
    self.lbUnitOutViettel.alpha = 1;
}

- (void)checkRefreshAddress {
    
    [self.cbAtUnit refresh];
    [self.cbUnitInViettel refresh];
    [self.cbUnitOutViettel refresh];

}

- (IBAction)checkFullTime:(ButtonCheckBox *)sender {
    [self checkInButtonCheckbox];
    [self checkRefreshWorkType];
    [sender setSelected:!sender.selected];
}

- (IBAction)checkPartTime:(ButtonCheckBox *)sender {
    [self checkInButtonCheckbox];
    [self checkRefreshWorkType];
    [sender setSelected:!sender.selected];
}

- (IBAction)checkOff:(ButtonCheckBox *)sender {
    [self checkRefreshWorkType];
    [sender setSelected:!sender.selected];
    [self checkOffButtonCheckbox];
}

- (IBAction)checkAtUnit:(ButtonCheckBox *)sender {
    [self checkRefreshAddress];
    [sender setSelected:!sender.selected];
 
}

- (IBAction)checkUnitInViettel:(ButtonCheckBox *)sender {
    [self checkRefreshAddress];
    [sender setSelected:!sender.selected];

}

- (IBAction)checkUnitOutViettel:(ButtonCheckBox *)sender {
    [self checkRefreshAddress];
    [sender setSelected:!sender.selected];

}

- (void)checkOffButtonCheckbox {
    [self.cbAtUnit setSelected:NO];
    [self.cbUnitInViettel setSelected:NO];
    [self.cbUnitOutViettel setSelected:NO];
    [self.cbAtUnit setEnabled:NO];
    [self.cbUnitInViettel setEnabled:NO];
    [self.cbUnitOutViettel setEnabled:NO];
    
    self.lbAtUnit.alpha = 0.5;
    self.lbUnitInViettel.alpha = 0.5;
    self.lbUnitOutViettel.alpha = 0.5;
}

- (void)checkInButtonCheckbox {
    [self.cbAtUnit setEnabled:YES];
    [self.cbUnitInViettel setEnabled:YES];
    [self.cbUnitOutViettel setEnabled:YES];
}

- (NSString *)getValueTypeWork {
        if (_cbFullTime.isSelected == TRUE) {
            return @"WORK";
        } else if (_cbPartTime.isSelected == TRUE) {
            return @"WORK_HALF_DAY";
        } else{
            return @"LEAVE";
        }
}

- (NSString *)getValueAddress {
        if (_cbAtUnit.isSelected == TRUE) {
            return @"DEFAULT";
        } else if (_cbUnitInViettel.isSelected == TRUE) {
            return @"ONSITE_IN";
        } else{
            return @"ONSITE_OUT";
        }
}

- (NSDictionary *)getValue{
    return @{@"valueTypeWork" : [self getValueTypeWork], @"valueAddress":[self getValueAddress]};
}


@end
