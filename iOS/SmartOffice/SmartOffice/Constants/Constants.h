//
//  Constants.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define API_ERR_CODE_SUCCESS                    @"200"
#define API_ERR_CODE_FAIL                       @"1"

#define FR_MORE_SCR_HEIGHT                      320
#define FR_TABBAR_HEIGHT                        44
#define DELAY_SEARCH_UTIL_QUERY_UNCHANGED_FOR_TIME_OFFSE  0.5 * NSEC_PER_SEC
#define LIMIT_SIZE_IMAGE_TO_RESIZE	197152	//597152 - 197152

//Use this for request api with params pageSize to pagging load
#define PAGE_SIZE_NUMBER						20

typedef NS_ENUM (NSInteger, ResponseCode) {
    RESP_CODE_SUCCESS = 0,
    RESP_CODE_SUCCESS_VT = 200,
    RESP_CODE_UNKNOWN = -1,
    RESP_CODE_EXCEPTION = 2000,
    RESP_CODE_EXCEPTION_NO_INTERNET = 50,
    RESP_CODE_EXCEPTION_ERROR_SERVER = 61,
    RESP_CODE_EXCEPTION_UNKNOWN_SESSION = 70,
    RESP_CODE_EXCEPTION_EXPIRE_SESSION  = 71,
    RESP_CODE_REQUEST_INPROCESS  = 201,
    RESP_CODE_REQUEST_NOTCONNECT  = 1001,
    RESP_CODE_DOMAIN_NOT_COMPLETE  = 8
    
};

#endif /* Constants_h */

//UserRole
typedef enum : NSInteger {
    UserRoleID_Manager1 = 336952,		//... improve later sysRoleId = 336953 hoặc sysRoleId = 336952
    UserRoleID_Manager2 = 336953,	// ...
    UserRoleID_Normal
} UserRoleID;

#pragma Doc_Type
typedef enum : NSInteger {
    DocType_Waiting = 0, //Chờ ký duyệt
    DocType_Flash,		//Chờ ký nháy
    DocType_Express		//Hoả tốc
} DocType;

//Follow by API VT supplies
typedef enum : NSInteger {
    DocApiType_Unknown = -1,
    DocApiType_Text = 0,
    DocApiType_Doc = 1
} DocApiType;


//State Doc
typedef enum : NSInteger {
    StateDoc_Flash = 5,
    StateDoc_WaitingSign = 0,
    StateDoc_Express = 2
} StateDoc;
//ScheduleType
typedef enum : NSInteger {
    ScheduleType_None = 0, //... improve later
    ScheduleType_Next	  // ...
} ScheduleType;


//WorkType

//loại (1 - việc được giao; 2 - việc tôi giao; 3 - công việc của cá nhân khác; 4 - công việc cá nhân việc riêng; 5 - việc phối hợp; Bổ sung 1 type = 6 - việc đă chuyển và type = 7 là bao gồm loại 1,2,3)
typedef enum : NSInteger {
    WorkType_All = -1,
    WorkType_Combined = 5,	  //Công việc kết hợp
    WorkType_WasAssinged = 1, //Công việc được giao
    WorkType_CreateMySelf = 4 //Công việc tự tạo
} WorkType;
//if (commandType == 2) {
//	//Personal
//	iconName = @"work_perform_icon";
//}else if (commandType == 4){
//	//Combined
//	iconName = @"work_combinated_icon";
//}else{
//	//Other - Được giao
//	iconName = @"work_other_icon";
//}
//return iconName;

typedef enum : NSInteger {
	CommandTypeWork_Personal = 2, //Công việc cá nhân
	CommandTypeWork_Combinated = 4,	  //Công việc kết hợp
	CommandTypeWork_Assigned = 1, //Công việc được giao
} CommandTypeWork;

//WorkStatus
//typedef enum : NSInteger {
//	WorkType_All = -1,
//	WorkType_Combined = 5,	  //Công việc kết hợp
//	WorkType_WasAssinged = 1, //Công việc được giao
//	WorkType_CreateMySelf = 4 //Công việc tự tạo
//} WorkStatus;
//(4 - Chưa thực hiện; 5 - Đang thực hiện; 6 - Đă hoàn thành; 7 - đă quá hạn
//TTNS TimeKeepingType
typedef enum : NSInteger {
    TimeKeepingType_Base = 0,
    TimeKeepingType_Week,
    //    TimeKeepingType_Calendar
} TimeKeepingType;

/*
 TTNS
 */
typedef enum : NSInteger {
    UnKnown = -1,
    Waiting,    //Chưa phê duyệt
    Approved,   //Đã phê duyệt
    Reject,     //Từ chối
    Approved2,
    LatedDay,     //Ngày công phê duyệt muộn
    Lock           //Bị Khoá
} TimeKeepingCalendarType;

typedef enum : NSUInteger{
    GetListRegister_All = 0,
    GetListRegister_Xin_nghi_phep = 1,
    GetListRegister_Xin_nghi_om   = 3,
    GetListRegister_xin_nghi_con_om = 5,
    GetListRegister_xin_nghi_viec_rieng = 7
}GetListRegister;

typedef enum : NSUInteger{
    StatusType_SIGN     = 0, // chua trinh ky
    StatusType_Approval = 1, // da phe duyet
    StatusType_Refuse = 2, // Bị từ chối
    StatusType_NotApproval = 3 // dang cho phê duyệt
}StatusType;

typedef enum : NSUInteger{
    TTNS_Type_NghiPhep=1,
    TTNS_Type_NghiOm = 3,
    TTNS_Type_NghiConOm = 5,
    TTNS_Type_NghiViecRieng = 7
}TTNS_Type;

typedef enum : NSUInteger{
    TTNS_Manage_CheckOut=0,
    TTNS_Manage_TimeKeeping,
    TTNS_Manage_EmployInfo
}TTNS_Manage_Type;

typedef enum : NSUInteger{
    TTNS_Person,
    TTNS_Manager
}TTNS_Role;


/*
 TTNS register in out
 */

typedef enum:NSUInteger{
    typeALL = 0,
    typeRegister_xin_Nghi_phep = 1,
    typeRegister_xin_Nghi_Om = 3,
    typeRegister_xin_Nghi_Con_Om = 5,
    typeRegister_xin_Nghi_Viec_Rieng = 7,
    typeRegister_xin_Nghi_Vo_Sinh = 9
}typeRegister;


/*
 TTNS Detail leaves Confirmed
 */

typedef enum: NSUInteger {
    DetailLeaveSectionType_Info = 0,
    DetailLeaveSectionType_Handler,
    DetailLeaveSectionType_ContentHandler,
    DetailLeaveSectionType_ManagerUnit,
} DetailLeaveSectionType;

/*
 PMTC SendInvoice
 */

//Docs status
typedef enum : NSUInteger{
	UrgentDocStatus_Normal = 1,    //Bình thường
	UrgentDocStatus_Urgency = 0,	  // Khẩn
	UrgentDocStatus_Express = 3
}UrgentDocStatus;

typedef enum : NSUInteger{
	UrgentTextStatus_Normal = 1,    //Bình thường
	UrgentTextStatus_Urgency = 0	  // Khẩn
}UrgentTextStatus;

typedef enum: NSUInteger {
    SignStatus_Noprocess = 0,                   //Chưa xử lý
    SignStatus_LetterRefusesToApprove = 1,      //Văn thư từ chối duyệt
    SignStatus_RefusalToApprove = 2,            //Từ chối duyệt
    SignStatus_Noprocess2 = 3,                  //Chưa xử lý
    SignStatus_Signed = 4,                      //Đã ký duyệt
    SignStatus_LetterSigned = 41,               //Văn thư đã ký duyệt
    SignStatus_SignedBlink = 42,                //Đã ký nháy
} SignStatus;


typedef enum: NSUInteger {
    DetailSendInvoiceSectionType_Info = 0,
    DetailSendInvoiceSectionType_Attach,
    DetailSendInvoiceSectionType_Image,
} DetailSendInvoiceSectionType;


////Detail Work field
//typedef enum : NSUInteger {
//	DetailWorkIndexType_TenCV,
//	DetailWorkIndexType_NoiDungCV,
//	DetailWorkIndexType_LoaiCV,
//	DetailWorkIndexType_NgayGiao,
//	DetailWorkIndexType_ThoiHan,
//	DetailWorkIndexType_TrangThai,
//	DetailWorkIndexType_TanSuatBaoCao,
//	DetailWorkIndexType_PhoiHop
//} DetailWorkIndexType;


//ListWorkType - Using on ListWorkVC
typedef enum : NSUInteger{
    ListWorkType_Perform = 1,     //Loại Công việc thực hiện
    ListWorkType_Shipped = 0	  // Loại công việc giao đi
}ListWorkType;

typedef enum : NSUInteger{
	ListMissionType_Perform = 0,     //Loại nhiệm vụ thực hiện
	ListMissionType_Shipped = 1		// Loại nhiệm vụ giao đi
}ListMissionType;


typedef enum : NSUInteger{
	WorkPerformSymbolType_Personal = 0, //Biểu tượng Công việc cá nhân
    WorkPerformSymbolType_Combinated,	//Biểu tượng Công việc kết hợp
    WorkPerformSymbolType_Assigned		//Biểu tượng Cong việc được giao
}WorkPerformSymbolType;


// danh sách trạng công việc - null = t́m kiếm tất cả, web dùng tham số này, status : trạng thái công việc (1 - Chưa thực hiện; 2 - Đang thực hiện; 3 - Đă hoàn thành; 0 - đă quá hạn;)}]
typedef enum : NSUInteger {
    WorkStatus_Unknown = -1,
	WorkStatus_Delay = 0,
    WorkStatus_UnInprogress = 1,
    WorkStatus_InProgress = 2,
    WorkStatus_Completed = 3,
	
} WorkStatus;

//Work Filter
typedef enum : NSInteger{
    WorkFilterType_All = 0,
    WorkFilterType_Personal,
    WorkFilterType_Combinated,
    WorkFilterType_WasAssigned
}WorkFilterType;

typedef enum : NSInteger{
    CheckOutState_NotSign = 0,
    CheckOutState_Accept,
    CheckOutState_Reject,
    CheckOutState_Wait
}CheckOutState;
//DOC_TITLE_BY_TITILE
#define kDOC_FLASH			LocalizedString(@"VOffice_DocumentCell_iPad_Ký_nháy")
#define kDOC_WAITING_SIGN	LocalizedString(@"VOffice_DocumentCell_iPad_Chờ_ký_duyệt")
#define kDOC_EXPRESS		LocalizedString(@"VOffice_DocumentCell_iPad_Hoả_tốc")


typedef enum : NSUInteger {
    TabbarItemType_Integration = 0,
    TabbarItemType_Social,
    TabbarItemType_Conversation,
    TabbarItemType_Contact,
    TabbarItemType_More,
    TabbarItemType_Logout
} TabbarItemType;

//DocDetailType
typedef enum : NSUInteger {
    DetailTitleCellType_EXTRAC_WEAK_CONTENT = 0, //Trích yếu nội dung
    DetailTitleCellType_UNIT_RAISE_SIGN,	//Đơn vị trình ký
    DetailTitleCellType_SIGNED_RAISER,// Người trình ký
    DetailTitleCellType_SIGNED_DATE,
    DetailTitleCellType_LEVEL_SECURITY,		// Độ mật
    DetailTitleCellType_LEVEL_URGENT		// Độ khẩn
} DetailTitleCellType;

//DetailDocSectionType
typedef enum : NSUInteger {
    DetailDocSectionType_Info = 0,
    DetailDocSectionType_Profile,
} DetailDocSectionType;


//Mission - Nhiệm vụ
typedef enum : NSInteger{
    MissionType_All = -1,
    MissionType_Combined = 3,				//Nhiệm vụ kết hợp
    MissionType_DirectorateAssigned = 4,	//Nhiệm vụ BGĐ giao
    MissionType_Registered = 6				//Nhiệm vụ đăng ký
}MissionType;

//(Lựa chọn) tim kiếm theo danh sach trạng thái của nhiệm vụ (Chậm tiến độ: 0, Chưa thực hiện: 1,	Đang thực hiện: 2, Đa hoàn thành: 3, Đa kết thúc: 4, Yêu cầu đóng: 5, Đã đóng: 6, Yêu cầu gia hạn: 7, Chưa đóng: 8, Đã chuyển: 9)
typedef enum : NSInteger{
    MissionStatus_DelayProgress = 0, //Chậm tiến độ
    MissionStatus_UnInprogress	= 1,	 //Chưa thực hiện
	MissionStatus_Inprogress = 2, //Đang thực hiện
	MissionStatus_Completed = 3,	//Đã hoàn thành
	MissionStatus_Ended = 4,		//Đã kết thúc
	MissionStatus_RequestClose = 5,	//Yêu cầu đóng
	MissionStatus_Closed = 6,		//Đã đóng
	MissionStatus_RequestExtend = 7,	//
	MissionStatus_NotClose = 8,
	MissionStatus_Moved = 9
}MissionStatus;

typedef enum : NSInteger{
    MissionLevelType_Important	= 1,				//Quan trọng
    MissionLevelType_Normal		= 2					//Bình thường
}MissionLevelType;

