//
//  Demo1.h
//  Demo
//
//  Created by NguyenDucBien on 4/10/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonCheckBox.h"

//typedef enum {
//    cbFullTime,
//    cbPartTime,
//    cbOff
//} WorkType;


typedef enum {
    cbAtUnit,
    cbUnitInViettel,
    cbkUnitOutViettel
} Address;

@interface ProcessTimeKeeping : UIViewController
@property (weak, nonatomic) IBOutlet ButtonCheckBox *cbFullTime;

@property (weak, nonatomic) IBOutlet ButtonCheckBox *cbPartTime;

@property (weak, nonatomic) IBOutlet ButtonCheckBox *cbOff;

@property (weak, nonatomic) IBOutlet ButtonCheckBox *cbAtUnit;

@property (weak, nonatomic) IBOutlet ButtonCheckBox *cbUnitInViettel;

@property (weak, nonatomic) IBOutlet ButtonCheckBox *cbUnitOutViettel;

@property (weak, nonatomic) IBOutlet UILabel *lbFullTime;

@property (weak, nonatomic) IBOutlet UILabel *lbPartTime;

@property (weak, nonatomic) IBOutlet UILabel *lbOff;

@property (weak, nonatomic) IBOutlet UILabel *lbAtUnit;

@property (weak, nonatomic) IBOutlet UILabel *lbUnitInViettel;

@property (weak, nonatomic) IBOutlet UILabel *lbUnitOutViettel;

    
- (IBAction)checkFullTime:(ButtonCheckBox *)sender;

- (IBAction)checkPartTime:(ButtonCheckBox *)sender;

- (IBAction)checkOff:(ButtonCheckBox *)sender;

- (IBAction)checkAtUnit:(ButtonCheckBox *)sender;

- (IBAction)checkUnitInViettel:(ButtonCheckBox *)sender;

- (IBAction)checkUnitOutViettel:(ButtonCheckBox *)sender;

- (NSDictionary *)getValue;



@end
