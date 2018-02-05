//
//  ImageCollectionViewCell.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteImageButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageCollection;

- (IBAction)deleteImageAction:(id)sender;


@end
