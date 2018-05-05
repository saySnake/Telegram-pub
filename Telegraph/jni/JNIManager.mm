//
//  JNIManager.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/5.
//

#import "JNIManager.h"

@implementation JNIManager

#import "apiinterface.h"
#import "messagedef.h"

static TAPIInterface  *m_pJniInterface = NULL;
static const char* m_sVersion ="1";
static const char* m_sServer ="199.10.10.10";
static const int   m_nServerPort = 80;

void InitInterface()
{
    if(m_pJniInterface != NULL)
        return;
    
    m_pJniInterface = new TAPIInterface();
}

void ReleaseInterface()
{
    if(m_pJniInterface == NULL)
        return ;
    
    delete m_pJniInterface ;
    m_pJniInterface = NULL;
}

void JNI_CallBack(int method,int status,int dialogID,const char* arg1)
{
    printf(".......callback:%d,%d,%d",method,status,dialogID);
}


-(void)StartJni
{
    InitInterface();
    m_pJniInterface->Init();
    m_pJniInterface->SetCallBack(JNI_CallBack);
    m_pJniInterface->SetAppVersion(m_sVersion);
    m_pJniInterface->SetMobileInfo("apple","8plus","8.1");
    
    
    m_pJniInterface->SetDeviceType(_DEVICE_MOBILE);
    m_pJniInterface->SetServerInfo(m_sServer,m_nServerPort);
    
    
    m_pJniInterface->Run();
}


@end
