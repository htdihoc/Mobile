//
//  Voffice_PersonJoinTableViewCell.h
//  VOFFICE_ListOfMeetingSchedules_iPad
//
//  Created by NguyenDucBien on 4/28/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmployeeModel;
@interface VOffice_PersonJoinCell_iPad : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageAvata;
@property (weak, nonatomic) IBOutlet UILabel *labelNamePerson;
@property (weak, nonatomic) IBOutlet UILabel *labelPosition;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
- (void)setupDataFromModel:(EmployeeModel *)model;
- (void)setupDataByName:(NSString *)employeeName position:(NSString *)position;
@end
