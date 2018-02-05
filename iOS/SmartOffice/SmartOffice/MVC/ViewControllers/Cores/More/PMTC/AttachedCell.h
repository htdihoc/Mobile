//
//  AttachedCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image_attach;
@property (weak, nonatomic) IBOutlet UILabel *title_attach;

@property (weak, nonatomic) IBOutlet UIImageView *image_arrow;


@end
