//
//  KTTSTableViewCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 9/13/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import ""

@interface KTTSTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *selectedView;

@property (weak, nonatomic) IBOutlet UILabel *value_cell_number;

@property (weak, nonatomic) IBOutlet UILabel *value_goods_name;
@property (weak, nonatomic) IBOutlet UILabel *value_number;
@property (weak, nonatomic) IBOutlet UILabel *value_serial;
@property (weak, nonatomic) IBOutlet UILabel *value_status;


@property (weak, nonatomic) IBOutlet UILabel *title_name;
@property (weak, nonatomic) IBOutlet UILabel *titleNumberAndDate;
@property (weak, nonatomic) IBOutlet UILabel *title_SerialAndName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_status_constraint;

//- (void) setDataDetailBBBGWithArray:(DetailBBBGModel *)array;

@end
