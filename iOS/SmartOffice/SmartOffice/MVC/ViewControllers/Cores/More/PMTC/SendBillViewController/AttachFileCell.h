//
//  AttachFileCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/28/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttachFileDelegate <NSObject>

- (void)showCamera;
- (void)showLibrary;

@end

@interface AttachFileCell : UITableViewCell

@property (weak, nonatomic) id <AttachFileDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *attacgFileTittle;


@property (weak, nonatomic) IBOutlet UIButton *camera_button;
@property (weak, nonatomic) IBOutlet UIButton *image_button;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_camera;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_library;


@end
