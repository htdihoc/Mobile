//
//  More_SurveyVC_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/19/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "More_SurveyVC_iPad.h"
#import "More_ListSurvey_iPad.h"

@interface More_SurveyVC_iPad ()

@end

@implementation More_SurveyVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self addListSurveyVC];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.VOffice_title        = @"";
    self.VOffice_buttonTitles = @[@"More", @"Survey"];
    
}

- (void)addListSurveyVC {
    More_ListSurvey_iPad *listSurvey = [[More_ListSurvey_iPad alloc] initWithNibName:@"More_ListSurvey_iPad" bundle:nil];
    [self displayVC:listSurvey container:self.containerView1];
}

@end
