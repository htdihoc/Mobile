//
//  AssetConfirmViewController.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"

@protocol AssetConfirmViewControllerDelegate
- (void)successAssetConfirmVC;
- (void)errorAssetConfirmVC;
@end

@interface AssetConfirmViewController : TTNS_BaseVC

@property (nonatomic, weak) id<AssetConfirmViewControllerDelegate>delegate;
@property (nonatomic) NSUInteger merEntityId;

@end
