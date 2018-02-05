//
//  QLTT_AlertVC.m
//  SmartOffice
//
//  Created by NguyenDucBien on 7/25/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_AlertVC.h"
#import "MZFormSheetController.h"

@interface QLTT_AlertVC ()

@end

@implementation QLTT_AlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionClose:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
    }];
}
@end
