//
//  SO_HUDCustomView.h
//  SmartOffice
//
//  Created by Kaka on 8/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SO_HUDCustomView : UIView{
	
}
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UIImageView *imgIndicator;
@property BOOL stop;
- (void)startAnimation;
@end
