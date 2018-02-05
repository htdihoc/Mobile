//
//  ImageCollectionViewCell.h
//  SmartOffice
//
//  Created by NguyenDucBien on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell
- (IBAction)deleteImageAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@end
