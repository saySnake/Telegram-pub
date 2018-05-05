#ifndef _MESSAGE_DEF_H
#define _MESSAGE_DEF_H

#define _OS_WINDOWS                1
#define _OS_ANDROID_MOBILE         2
#define _OS_IOS_MOBILE             3

#define _DEVICE_PC                     1
#define _DEVICE_MOBILE                 2


#define  MSG_TYPE_IM     0             //基本消息
#define  MSG_TYPE_LONG   1             //大消息
#define  MSG_TYPE_SP     2             //闪屏
#define  MSG_TYPE_SPIC   3             //系统小图片
#define  MSG_TYPE_FILE   4             //文件
#define  MSG_TYPE_PIC    5             //图片文件
#define  MSG_TYPE_AUDIO  6             //音频文件
#define  MSG_TYPE_VIDEO  7             //视频文件
#define  MSG_TYPE_PROMPT 8             //提示消息

#define _EVENT_UI_EVT_MSG         100000
#define _REQUEST_HTTP_MSG         200000



#define  _EVENT_REPORT_RUNSUCCESS          _EVENT_UI_EVT_MSG + 1
#define  _EVENT_REPORT_SENDFILEPROGRESS    _EVENT_UI_EVT_MSG + 2
#define  _EVENT_REPORT_GETFILEPROGRESS     _EVENT_UI_EVT_MSG + 3


#define _REQUEST_HTTP_MAKELOGIN              _REQUEST_HTTP_MSG   + 101
#define _REQUEST_HTTP_MAKEREGISTER           _REQUEST_HTTP_MSG   + 102
#define _REQUEST_HTTP_SETAPNSTOKEN           _REQUEST_HTTP_MSG   + 103
#define _REQUEST_HTTP_CHECKVERSION           _REQUEST_HTTP_MSG   + 104
#define _REQUEST_HTTP_CHECKNETWORK           _REQUEST_HTTP_MSG   + 105


#define _REQUEST_HTTP_DOWNLOADTREDHISTORY    _REQUEST_HTTP_MSG   + 201
#define _REQUEST_HTTP_CREATEREDPACKET        _REQUEST_HTTP_MSG   + 202
#define _REQUEST_HTTP_PAYREDPACKET           _REQUEST_HTTP_MSG   + 203

#define _REQUEST_HTTP_UPLOADLEAVETEXT        _REQUEST_HTTP_MSG   + 301
#define _REQUEST_HTTP_DOWNLOADLEAVETEXT      _REQUEST_HTTP_MSG   + 302
#define _REQUEST_HTTP_DELLEAVETEXT           _REQUEST_HTTP_MSG   + 303

#define _REQUEST_HTTP_SETPAYPASS             _REQUEST_HTTP_MSG   + 401
#define _REQUEST_HTTP_MODIFYPAYPASS          _REQUEST_HTTP_MSG   + 402
#define _REQUEST_HTTP_GETSURPLUS             _REQUEST_HTTP_MSG   + 403
#define _REQUEST_HTTP_GETALLASSETS           _REQUEST_HTTP_MSG   + 404


#endif