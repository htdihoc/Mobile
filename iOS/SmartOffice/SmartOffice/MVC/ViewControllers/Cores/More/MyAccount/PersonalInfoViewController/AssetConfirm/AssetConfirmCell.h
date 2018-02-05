//
//  AssetConfirmCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDropMenu.h"

@interface AssetConfirmCell : UITableViewCell

@property (strong, nonatomic) IBOutlet KPDropMenu *view_type;
@property (weak, nonatomic) IBOutlet UITextField *text_number_not_used;
@property (weak, nonatomic) IBOutlet UITextView *tv_reason;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIButton *pickerDoneButton;
@property (strong, nonatomic) NSDateFormatter *format;
@property (strong, nonatomic) NSDate *dateFromString;

@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger date;

@end
