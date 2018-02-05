//
//  TTNS_WorkList.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_WorkList.h"

@interface TTNS_WorkList ()

@end

@implementation TTNS_WorkList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backTitle = LocalizedString(@"TTNS_CheckListWork_Nội_dung_công_việc");
    self.array = [[NSArray alloc]initWithObjects:@"Loại công việc 1", @"Loại công việc 2", @"Loại công việc 3", @"Loại công việc 4", @"Loại công việc 6", @"Loại công việc 7", @"Loại công việc 8", nil];
    // Do any additional setup after loading the view from its nib.
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
