//
//  KTTS_ListPropertyCell_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTTS_ListPropertyCell_iPad : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel * lbl_numberOfRow;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *counterView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (weak, nonatomic) IBOutlet UILabel *title_goods_name;

@property (weak, nonatomic) IBOutlet UILabel *title_number;

@property (weak, nonatomic) IBOutlet UILabel *title_serial;

@property (weak, nonatomic) IBOutlet UILabel *title_status;

@property (weak, nonatomic) IBOutlet UILabel *lbl_goods_name;

@property (weak, nonatomic) IBOutlet UILabel *lbl_number;

@property (weak, nonatomic) IBOutlet UILabel *lbl_serial;

@property (weak, nonatomic) IBOutlet UILabel *lbl_status;















@end
