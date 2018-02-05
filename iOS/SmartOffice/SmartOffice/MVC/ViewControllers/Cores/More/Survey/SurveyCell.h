//
//  SurveyCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_status;
@property (weak, nonatomic) IBOutlet UILabel *name_survey;
@property (weak, nonatomic) IBOutlet UILabel *start_date;
@property (weak, nonatomic) IBOutlet UILabel *end_date;

@property (nonatomic, weak) IBOutlet UIView *viewOne;
@property (nonatomic, weak) IBOutlet UIView *viewTwo;
@property (nonatomic, weak) IBOutlet UIImageView *imageOne;
@property (nonatomic, weak) IBOutlet UIImageView *imageTwo;

@end
