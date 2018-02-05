//
//  AlertFlatView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/17/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "AlertFlatView.h"

@interface AlertFlatView ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_Content;

@end

@implementation AlertFlatView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lbl_Content.text = self.content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
