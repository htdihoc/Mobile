//
//  Config.h
//  SpeedTest
//
//  Created by Nguyen Thanh Huy on 7/3/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define APP_BUNDLE                  [[NSBundle mainBundle] infoDictionary]
#define APP_NAME                    [APP_BUNDLE objectForKey:@"CFBundleDisplayName"]
#define APP_ID                      [APP_BUNDLE objectForKey:@"CFBundleDisplayName"]
#define APP_TYPE                    @"iOS"

#define KSYS_APP_LANG_DEFAULT               @"VN"
#define KSYS_APP_LANG_EN                    @"EN"

//Base URL
//#define URL_SERVICE_ROOT             @"http://www1.itsol.vn:9090/smartoffice/" //ITSol server

//+++ public VT sv
//#define URL_SERVICE_ROOT               @"http://203.190.173.94:8087/smartoffice/api/v1/"

//+++Local VT Server
//#define URL_SERVICE_ROOT               @"http://10.60.108.222:8087/smartoffice/api/v1/"


//Use At Home
#define URL_SERVICE_ROOT               @"http://smartoffice.myitsol.com/smartoffice/api/v1/"

//Viettel API
//http://203.190.173.94:8087/smartoffice/api/v1/


typedef void (^Callback)(BOOL success, id resultDict, NSException *exception);


#endif /* Config_h */
