//
//  AttachFileDetailCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/28/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttachFileDetailDelegate <NSObject>

- (void)showCameraUpdate;
- (void)showLibraryUpdate;

@end

@interface AttachFileDetailCell : UITableViewCell

@property (weak, nonatomic) id <AttachFileDetailDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *attacgFileTittle;


@property (weak, nonatomic) IBOutlet UIButton *camera_button;
@property (weak, nonatomic) IBOutlet UIButton *image_button;

@end
