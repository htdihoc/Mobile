//
//  AttachImageTableViewCell.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttachFileDelegate <NSObject>

- (void)showCamera;
- (void)showLibrary;

@end

@interface AttachImageTableViewCell : UITableViewCell

@property (weak, nonatomic) id <AttachFileDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *attachTittle;
@property (weak, nonatomic) IBOutlet UIView *attachView;

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@property (weak, nonatomic) IBOutlet UIButton *libraryButton;

- (IBAction)cameraAction:(id)sender;

- (IBAction)libraryAction:(id)sender;

@end
