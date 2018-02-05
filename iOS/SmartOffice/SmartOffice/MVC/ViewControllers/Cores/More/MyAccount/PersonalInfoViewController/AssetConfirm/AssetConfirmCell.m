//
//  AssetConfirmCell.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "AssetConfirmCell.h"

@interface AssetConfirmCell() <KPDropMenuSelectedDelegate>

@end

@implementation AssetConfirmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // set ui
    [self setUserInterfaceObject:self.view_type];
    [self setUserInterfaceObject:self.text_number_not_used];
    [self setUserInterfaceObject:self.tv_reason];
    
    _view_type.items = @[@"Báo mất", @"Báo hỏng", @"Báo không sử dụng"];
    _view_type.selectedDelegate = self;
    
    _datePicker = [UIDatePicker new];
    _pickerDoneButton = [UIButton new];
    _format = [NSDateFormatter new];
    _dateFromString = [NSDate new];
    [_format setDateFormat:@"dd/MM/yyyy"];
    _dateTextField.text = [_format stringFromDate: [NSDate date]];
    _tv_reason.text = @"";
    _text_number_not_used.text = @"1";
    [self selectDateAuto];
}

- (IBAction)selectDateAction:(id)sender {
    _datePicker.frame = CGRectMake(0, 50, self.frame.size.width, 200);
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_datePicker];
    [self selectDateAuto];
}

- (void) selectDateAuto {
    _dateFromString = [_format dateFromString:_dateTextField.text];
    NSTimeInterval timeInMiliseconds = [_dateFromString timeIntervalSince1970]*1000;
    _date = timeInMiliseconds;
}

- (void) selectDate {
    _dateTextField.text = [_format stringFromDate:_datePicker.date];
}

- (void)itemSelected:(NSInteger)index {
    _type = index + 1;
}

- (void) setUserInterfaceObject: (UIView *)object {
    object.layer.borderWidth = 0.5;
    object.layer.borderColor = RGB(204, 204, 204).CGColor;
    object.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
