#ifndef _API_INTERFACE_H_
#define _API_INTERFACE_H_


#ifndef EXPORT_DLL
#ifdef WIN32
#define EXPORT_DLL __declspec(dllexport)
#else
#define EXPORT_DLL 
#endif
#endif

class TAPIPacket;
class TDBManager;
class TExtInterface;

#include <string>
using namespace std;

typedef void TUICallBack(int method,int status,int dialogID,const char* argresult);

class TAPIInterface
{
public:
    EXPORT_DLL TAPIInterface();
    EXPORT_DLL ~TAPIInterface();

    EXPORT_DLL void    Init();
    EXPORT_DLL void    Release();

    EXPORT_DLL void    SetCallBack(TUICallBack* pUICallBack);
    EXPORT_DLL void    SetMobileInfo(const char * brand,const char * modelNum,const char* sysversion);
    EXPORT_DLL void    SetWinInfo(const char * platform,int bitnumber);
    EXPORT_DLL void    SetAppVersion(const char* version);

    EXPORT_DLL void    SetPushToken(const char *token);
    EXPORT_DLL void    SetServerInfo(const char *serverAddr,int serverPor);
   
    EXPORT_DLL void    SetUserInfo(const char* mobule,const char* pin,const char* name,const char* teleacc);
    

    EXPORT_DLL void    SetUCInfo(const char* uid,const char* token);
    EXPORT_DLL void    SetProInfo(const char* token);
    EXPORT_DLL void    SetOtcInfo(const char* token);

	EXPORT_DLL int     UseOpenssl(const char* certfile,const char* keyfile,const char* password);

    EXPORT_DLL void    SetDeviceType(int deviceType);
    EXPORT_DLL int     SetDatabase(const char* dbName);
    
    EXPORT_DLL int     GetUserID();
    EXPORT_DLL char*   GetLoginMobile();

    EXPORT_DLL void    SetFileDir(const char* filePath);
    EXPORT_DLL int     Run();
    
    EXPORT_DLL char*   EncodeArgument(const char* key,const char* value);
    EXPORT_DLL char*   DecodeArgument(const char* arg,const char* key);

    EXPORT_DLL int     CreateDialogID();
    EXPORT_DLL void    CheckVersion();

public: 
	EXPORT_DLL int     CheckNetwork();
	

    EXPORT_DLL int     MakeRegister();
    EXPORT_DLL int     MakeLogin();
    EXPORT_DLL int     MakeLogout();
    EXPORT_DLL void    CancelLogin();

    EXPORT_DLL void    ChangePassword(const char* newpassword);
    EXPORT_DLL void    ChangeMobile(const char*  mobile,const char* mobile1,const char* mobile2,const char* mobile3);
    

    EXPORT_DLL long   DBExecSql(char* sql);
    EXPORT_DLL int    DBGetRecordCount(long sqlparam);
    EXPORT_DLL int    DBGetIntValue(long sqlparam,int row,int col);
    EXPORT_DLL char*  DBGetStrValue(long sqlparam,int row,int col);
    EXPORT_DLL void   DBRelease(long sqlparam);

    EXPORT_DLL char*  GetVersion();


    EXPORT_DLL int    DownloadRedHistory();
    EXPORT_DLL int    CreateRedPacket(const char* total,int number,int type,int moneytype,const char* recvusers,const char* content,const char* password);
    EXPORT_DLL int    PayRedPacket(const char* uri);
 
    EXPORT_DLL int    UploadLeaveText(int serviceType,int relactionID,const char* text);
    EXPORT_DLL int    DownloadLeaveText(int serviceType,int relactionID);
    EXPORT_DLL int    DeleteLeaveText(int serviceType,int relactionID,int msgID);

	EXPORT_DLL int    GetAssetsSurplus();
	EXPORT_DLL int    GetAllAssets();
	EXPORT_DLL int    SetPayPass(const char* password);
	EXPORT_DLL int    ModifyPayPass(const char* oldpass,const char* newpass);


    EXPORT_DLL int   IsLogined();

public://http
    void   OnReportUI(TAPIPacket* pInfo);
    void   OnReportUI(int method,int status,int dialogID,string resultArg);

    void   OnHttpResult(TAPIPacket* pInfo);
    void   OnSipResult(TAPIPacket* pInfo);
    
    TDBManager* GetDatabase();
    


private:
    void   PutInfomation(TAPIPacket* pInfo);
    TUICallBack*    m_pUICallBack;
    TDBManager*     m_pDatabase;
    TExtInterface*  m_pExtInterface;
    
    
};
#endif

