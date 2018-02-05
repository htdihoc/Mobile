//
//  ListSurveyCell.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/19/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListSurveyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStartUpLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDeadlineLabel;





@end
