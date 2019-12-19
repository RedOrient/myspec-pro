//
//  IntlSDKCommonDefine.h
//  IntlSDK
//
//  Created by Jeol Yu on 2019/11/25.
//  Copyright © 2019年 ycgame. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef IntlSDKCommonDefine_h
#define IntlSDKCommonDefine_h



//Level
#define YC_SDK_CODE_LEVEL_MASK                      0xF

#define YC_SDK_CODE_LEVEL_0                         0x0  //Low Level   Message
#define YC_SDK_CODE_LEVEL_1                         0x1  // |
#define YC_SDK_CODE_LEVEL_2                         0x2  // |
#define YC_SDK_CODE_LEVEL_3                         0x3  // |
#define YC_SDK_CODE_LEVEL_4                         0x4  // |
#define YC_SDK_CODE_LEVEL_5                         0x5  // |
#define YC_SDK_CODE_LEVEL_6                         0x6  // |
#define YC_SDK_CODE_LEVEL_7                         0x7  // |
#define YC_SDK_CODE_LEVEL_8                         0x8  // |          Warning
#define YC_SDK_CODE_LEVEL_9                         0x9  // |
#define YC_SDK_CODE_LEVEL_10                        0xA  // |
#define YC_SDK_CODE_LEVEL_11                        0xB  // |
#define YC_SDK_CODE_LEVEL_12                        0xC  // |
#define YC_SDK_CODE_LEVEL_13                        0xD  // |
#define YC_SDK_CODE_LEVEL_14                        0xE  // |
#define YC_SDK_CODE_LEVEL_15                        0xF  //Hight Level Error

#define YC_SDK_MSG                              YC_SDK_CODE_LEVEL_0
#define YC_SDK_WARNING                          YC_SDK_CODE_LEVEL_8
#define YC_SDK_ERROR                            YC_SDK_CODE_LEVEL_15


//===========================================================
// Dommain
//Domain Mask
#define     YC_SDK_DOMAIN_MASK                          0xF0
// API
#define        YC_SDK_SDK_DOMAIN                           0xF0
// 通知功能
#define        YC_SDK_NOTIFICATION_DOMAIN                  0x20
// 应用内购
#define        YC_SDK_IAP_DOMAIN                           0x30
// Media Library
#define     YC_SDK_MEDIA_LIBRARY_DOMAIN                 0x40
// Share
#define     YC_SDK_SHARE_DOMAIN                         0x50
// UserCenter
#define     YC_SDK_USER_CENTER_DOMAIN                   0x60
// WebView
#define     YC_SDK_WEB_VIEW_DOMAIN                      0x70


//===========================================================
//Module
#define     YC_SDK_MODULE_MASK                          0xFF00
//StoreKit(OS)
#define        YC_SDK_SK_MODULE                            0x0100
//APNs(OS)
#define        YC_SDK_APNS_MODULE                          0x0200
//Library(OS)
#define     YC_SDK_LIBR_MODULE                          0x0300

//Notification
#define     YC_SDK_NOTIFICATION_MODULE                  0x1100
//IAP
#define     YC_SDK_IAP_MODULE                           0x1200
//Verify IAP
#define     YC_SDK_IAP_VERIFY_MODULE                    0x1300 //废弃
//Library
#define     YC_SDK_MEDIA_LIBR_MODULE                    0x1400
//UserCenter
#define     YC_SDK_USER_CENTER_MODULE                   0x1500
//UserCenterPresistent
#define     YC_SDK_USER_CENTER_PRESISTENT_MODULE        0x1600
//General WEB Command
#define     YC_SDK_GENERAL_WEB_COMMAND_MODULE           0x1700
//REPORT_NOTIFICATION_ID_API
#define        YC_SDK_REPORT_NOTIFICATION_ID_API_MODULE    0x3100
//YC_IAP_VERIFY_API
#define     YC_SDK_IAP_VERIFY_API_MODULE                0x3200
//Auto LoginAPI
#define     YC_SDK_AUTO_LOGIN_API_MODULE                0x3300
//YC_IAP_REPORT_API
#define     YC_IAP_REPORT_API_MODULE                    0x3400
//YC_IAP_PRODUCT_VERIFY_API
#define     YC_IAP_PRODUCT_VERIFY_API_MODULE            0x3500

//极光推送
#define        YC_JPUSH_MODULE                             0xE100
//Tencent
#define     YC_TENCENT_MODULE                           0xE200
//WeChat
#define     YC_WECHAT_MODULE                            0xE300
//Weibo
#define     YC_WEIBO_MODULE                             0xE400


//===========================================================

#define        YC_SDK_BUSY                                 YC_SDK_WARNING | (0x01 << 16)

//HTTP ERROR
#define        YC_SDK_HTTP_RESPONSE_INCORRECT              YC_SDK_WARNING | (0x02 << 16)
#define        YC_SDK_HTTP_FAIL                            YC_SDK_ERROR | (0x03 << 16)

// JSON
#define        YC_SDK_JSON_INCORRECT                       YC_SDK_ERROR | (0x04 << 16)


#define     YC_SDK_INVALID_OPERATION                    (0x0F << 16)
#define     YC_SDK_INVALID_ARGUMENT                     (0x0E << 16)
//===========================================================
//User Center
#define     YC_USER_CENTER_AUTO_LOGIN_API_UID_NOT_MATCH         YC_SDK_USER_CENTER_DOMAIN | YC_SDK_REPORT_NOTIFICATION_ID_API_MODULE | YC_SDK_ERROR   | (0x12 << 16)

// Web Page
#define YC_WEB_PAGE_LOAD_FAILED                                 YC_SDK_WEB_VIEW_DOMAIN | YC_SDK_GENERAL_WEB_COMMAND_MODULE | YC_SDK_ERROR | (0x13 << 16)
//===========================================================
//Weibo API
#define     YC_SHARE_WEIBO_REQUEST_SUCCESS                      YC_SDK_SHARE_DOMAIN | YC_WEIBO_MODULE | YC_SDK_MSG   | (0x11 << 16)
#define     YC_SHARE_WEIBO_REQUEST_FAILED                       YC_SDK_SHARE_DOMAIN | YC_WEIBO_MODULE | YC_SDK_ERROR | (0x12 << 16)
#define     YC_SHARE_WEIBO_RESPONSE_SUCCESS                     YC_SDK_SHARE_DOMAIN | YC_WEIBO_MODULE | YC_SDK_MSG   | (0x13 << 16)
#define     YC_SHARE_WEIBO_RESPONSE_ERROR                       YC_SDK_SHARE_DOMAIN | YC_WEIBO_MODULE | YC_SDK_ERROR | (0x14 << 16)
#define     YC_SHARE_WEIBO_REG_FAILED                           YC_SDK_SHARE_DOMAIN | YC_WEIBO_MODULE | YC_SDK_ERROR | (0x15 << 16)
//WeChat API
#define     YC_SHARE_WECHAT_REQUEST_SUCCESS                     YC_SDK_SHARE_DOMAIN | YC_WECHAT_MODULE | YC_SDK_MSG   | (0x11 << 16)
#define     YC_SHARE_WECHAT_REQUEST_FAILED                      YC_SDK_SHARE_DOMAIN | YC_WECHAT_MODULE | YC_SDK_ERROR | (0x12 << 16)
#define     YC_SHARE_WECHAT_RESPONSE_SUCCESS                    YC_SDK_SHARE_DOMAIN | YC_WECHAT_MODULE | YC_SDK_MSG   | (0x13 << 16)
#define     YC_SHARE_WECHAT_RESPONSE_ERROR                      YC_SDK_SHARE_DOMAIN | YC_WECHAT_MODULE | YC_SDK_ERROR | (0x14 << 16)
#define     YC_SHARE_WECHAT_REG_FAILED                          YC_SDK_SHARE_DOMAIN | YC_WECHAT_MODULE | YC_SDK_ERROR | (0x15 << 16)
//Tencent API
#define     YC_SHARE_TENCENT_REQUEST_SUCCESS                     YC_SDK_SHARE_DOMAIN | YC_TENCENT_MODULE | YC_SDK_MSG   | (0x11 << 16)
#define     YC_SHARE_TENCENT_REQUEST_FAILED                      YC_SDK_SHARE_DOMAIN | YC_TENCENT_MODULE | YC_SDK_ERROR | (0x12 << 16)
#define     YC_SHARE_TENCENT_RESPONSE_SUCCESS                    YC_SDK_SHARE_DOMAIN | YC_TENCENT_MODULE | YC_SDK_MSG   | (0x13 << 16)
#define     YC_SHARE_TENCENT_RESPONSE_ERROR                      YC_SDK_SHARE_DOMAIN | YC_TENCENT_MODULE | YC_SDK_ERROR | (0x14 << 16)

//===========================================================
//Photo Library
#define     YC_PHOTO_LIBRARY_SAVE_FAILED                YC_SDK_MEDIA_LIBRARY_DOMAIN | YC_SDK_LIBR_MODULE | YC_SDK_ERROR | (0x11 << 16)
#define     YC_PHOTO_LIBRARY_SAVE_SUCCESS               YC_SDK_MEDIA_LIBRARY_DOMAIN | YC_SDK_LIBR_MODULE | YC_SDK_MSG   | (0x10 << 16)
#define     YC_PHOTO_LIBRARY_NOT_AUTHED                 YC_SDK_MEDIA_LIBRARY_DOMAIN | YC_SDK_LIBR_MODULE | YC_SDK_ERROR | (0x12 << 16)
#define     YC_PHOTO_LIBRARY_AUTHED                     YC_SDK_NOTIFICATION_MODULE   YC_SDK_MEDIA_LIBRARY_DOMAIN | YC_SDK_LIBR_MODULE | YC_SDK_MSG   | (0x13 << 16)

//===========================================================
//IAP
#define YC_IAP_PRODUCT_VERIFY_FAILED                    YC_SDK_IAP_DOMAIN | YC_SDK_IAP_MODULE | YC_SDK_ERROR | (0x11 << 16)

//===========================================================
//Store Kit
#define     YC_IAP_SK_PURCHASED                         YC_SDK_IAP_DOMAIN | YC_SDK_SK_MODULE | YC_SDK_MSG   | (0x11 << 16)
#define     YC_IAP_SK_FAILED                            YC_SDK_IAP_DOMAIN | YC_SDK_SK_MODULE | YC_SDK_ERROR | (0x12 << 16)
#define     YC_IAP_SK_NO_PRODUCT                        YC_SDK_IAP_DOMAIN | YC_SDK_SK_MODULE | YC_SDK_ERROR | (0x13 << 16)
#define     YC_IAP_SK_STATE_RESTOREDDSFS                YC_SDK_IAP_DOMAIN | YC_SDK_SK_MODULE | YC_SDK_ERROR | (0x14 << 16)
#define     YC_IAP_SK_NOT_ALLOWED                       YC_SDK_IAP_DOMAIN | YC_SDK_SK_MODULE | YC_SDK_ERROR | (0x15 << 16)
//===========================================================
//APNs
#define        YC_NOTIFICATION_GET_DEVICE_TOKEN_SUCCESS    YC_SDK_NOTIFICATION_DOMAIN | YC_SDK_APNS_MODULE | YC_SDK_MSG   | (0x11 << 16)    //
#define        YC_NOTIFICATION_GET_DEVICE_TOKEN_FAILED        YC_SDK_NOTIFICATION_DOMAIN | YC_SDK_APNS_MODULE | YC_SDK_ERROR | (0x12 << 16)    //

//===========================================================
//极光推送
#define        YC_JPUSH_MSG_RECEIVE                        YC_SDK_NOTIFICATION_DOMAIN | YC_JPUSH_MODULE | YC_SDK_MSG     | (0x11 << 16) //
#define        YC_JPUSH_CONNECTING                         YC_SDK_NOTIFICATION_DOMAIN | YC_JPUSH_MODULE | YC_SDK_MSG     | (0x12 << 16) //
#define        YC_JPUSH_SETUP                              YC_SDK_NOTIFICATION_DOMAIN | YC_JPUSH_MODULE | YC_SDK_MSG     | (0x13 << 16) //
#define        YC_JPUSH_CLOSE                              YC_SDK_NOTIFICATION_DOMAIN | YC_JPUSH_MODULE | YC_SDK_MSG     | (0x14 << 16) //
#define        YC_JPUSH_DID_REG                            YC_SDK_NOTIFICATION_DOMAIN | YC_JPUSH_MODULE | YC_SDK_MSG     | (0x15 << 16) //
#define        YC_JPUSH_DID_LOGIN                          YC_SDK_NOTIFICATION_DOMAIN | YC_JPUSH_MODULE | YC_SDK_MSG     | (0x16 << 16) //
#define        YC_JPUSH_DID_ERROR                          YC_SDK_NOTIFICATION_DOMAIN | YC_JPUSH_MODULE | YC_SDK_ERROR   | (0x17 << 16) //
#define        YC_JPUSH_FAILED_REG                         YC_SDK_NOTIFICATION_DOMAIN | YC_JPUSH_MODULE | YC_SDK_ERROR   | (0x18 << 16) //

#define        YC_JPUSH_FAILED_GET_REG_ID                  YC_SDK_NOTIFICATION_DOMAIN | YC_JPUSH_MODULE | YC_SDK_ERROR   | (0x1E << 16) //

//===========================================================
#define YCSDKShareDomain                @"com.ycgame.mobilesdk.share"
#define YCSDKMeidaLibraryDomain            @"com.ycgame.mobilesdk.mediaLibrary"
#define YCSDKNotificationDomain            @"com.ycgame.mobilesdk.notification"
#define YCSDKIAPDomain                    @"com.ycgame.mobilesdk.iap"
#define YCSDKDomain                        @"com.ycgame.mobilesdk"
#define YCUnknowDomain                    @"com.ycgame.mobilesdk.unknow"

//===========================================================

#define EMPTY_NSSTRING                    @""

#endif /* IntlSDKCommonDefine_h */
