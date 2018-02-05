//
//  AttachImageUpdateTableViewCell.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AttachFileDelegateUpdate <NSObject>

- (void)showCamera;
- (void)showLibrary;

@end

@interface AttachImageUpdateTableViewCell : UITableViewCell

@property (weak, nonatomic) id <AttachFileDelegateUpdate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *attachFileLabel;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
- (IBAction)cameraButtonAction:(id)sender;
- (IBAction)libraryButtonAction:(id)sender;

@end
