//
//  TVNoConnect.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 9/13/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TVNoConnect.h"

@implementation TVNoConnect

- (void)layoutSubviews {
    
}

- (IBAction)reloadAction:(id)sender {
    [self.delegate reloadWhenLostConnection];
}

@end
