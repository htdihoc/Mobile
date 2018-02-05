//
//  PersonalAccInfoCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalAccInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *view_number_cell;
@property (weak, nonatomic) IBOutlet UILabel *lb_cell_number;
@property (weak, nonatomic) IBOutlet UIButton *cell_view_detail;



@property (weak, nonatomic) IBOutlet UILabel *lb_goods_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_number;
@property (weak, nonatomic) IBOutlet UILabel *lb_serial;
@property (weak, nonatomic) IBOutlet UILabel *lb_status;

@property (weak, nonatomic) IBOutlet UILabel *title_goods_name;
@property (weak, nonatomic) IBOutlet UILabel *title_number;
@property (weak, nonatomic) IBOutlet UILabel *title_serial;
@property (weak, nonatomic) IBOutlet UILabel *title_status;


@end
