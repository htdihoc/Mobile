//
//  TVNoConnect.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 9/13/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TVReloadDelegate <NSObject>

- (void) reloadWhenLostConnection;

@end

@interface TVNoConnect : UIView

@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (weak, nonatomic) id<TVReloadDelegate> delegate;

@end
