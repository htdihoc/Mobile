//
//  BBBGTableViewCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 9/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBBGAssetModel.h"
#import "DetailBBBGModel.h"

@interface BBBGTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *value_cell_number;

@property (weak, nonatomic) IBOutlet UILabel *value_asset_name;
@property (weak, nonatomic) IBOutlet UILabel *value_number;
@property (weak, nonatomic) IBOutlet UILabel *value_serial;

- (void) setDataDetailBBBGWithArray:(DetailBBBGModel *)array;

@end
