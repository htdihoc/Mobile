//
//  QLTT_PreviewVC.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "ViewController.h"
@protocol QLTT_PreviewVCDelegate
- (NSData *)getDataToShow;
- (NSString *)fileType;
@end
@interface QLTT_PreviewVC : BaseVC
//@property (nonatomic, weak) id<QLTT_PreviewVCDelegate> delegate;
@property (nonatomic, strong) NSData *dataToShow;
@property (nonatomic, strong) NSString *fileType;
@end
