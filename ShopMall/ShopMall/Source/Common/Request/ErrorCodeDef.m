//
//  ErrorCodeDef.c
//  DrPalm
//
//  Created by KingsleyYau_lion on 12-3-26.
//  Copyright (c) 2012年 KingsleyYau. All rights reserved.
//

#import "ErrorCodeDef.h"
#import "LanguageDef.h"

#define ErrCodeToLocalizedString(keyString) NSLocalizedStringFromTable(keyString, @"ErrorCodeString", nil)

#define ErrCodeInvalidSchoolKey     ErrCodeToLocalizedString(@"ErrCode_InvalidSchoolKey")   //无效School参数
#define ErrCodeUnopenSchoolGatway   ErrCodeToLocalizedString(@"ErrCode_UnopenSchoolGatway") //学校未开通网关
#define ErrCodeSendBugError         ErrCodeToLocalizedString(@"ErrCode_SendBugError")       //申报故障或建议错误
#define ErrCodeUnkownClientType     ErrCodeToLocalizedString(@"ErrCode_UnkownClientType")   //未知客户端类型
#define ErrCodeNoNewPacket          ErrCodeToLocalizedString(@"ErrCode_NoNewPacket")        //没有新资源包
#define ErrCodePacketNotExist       ErrCodeToLocalizedString(@"ErrCode_PacketNotExist")     //资源包不存在
#define ErrCodeUnkownError          ErrCodeToLocalizedString(@"ErrCode_UnkownError")        //未知错误

#define ErrCodeAccountNotExist      ErrCodeToLocalizedString(@"ErrCode_AccountNotExist")    //帐号不存在
#define ErrCodeLoginInfoNotMatch    ErrCodeToLocalizedString(@"ErrCode_LoginInfoNotMatch")  //帐号或密码错误
#define ErrCodeLoginParamEmpty      ErrCodeToLocalizedString(@"ErrCode_LoginParamEmpty")    //登录帐号、密码、学校ID为空
#define ErrCodeInvalidSessionKey    ErrCodeToLocalizedString(@"ErrCode_InvalidSessionKey")  //无效SessionKey
#define ErrCodeInvalidProfileKey    ErrCodeToLocalizedString(@"ErrCode_InvalidProfileKey")  //无效ProfileKey

#define ErrCodeInvalidSchoolId          ErrCodeToLocalizedString(@"ErrCode_InvalidSchoolId")
#define ErrCodeAccounTypeEmpty          ErrCodeToLocalizedString(@"ErrCode_AccounTypeEmpty")
#define ErrCodeAccountTypeNotCorrect    ErrCodeToLocalizedString(@"ErrCode_AccountTypeNotCorrect")
#define ErrCodeAccountRightForbidden    ErrCodeToLocalizedString(@"ErrCode_AccountRightForbidden")
#define ErrCodeAccountBlockup           ErrCodeToLocalizedString(@"ErrCode_AccountBlockup")
#define ErrCodeAccountEmailEmpty        ErrCodeToLocalizedString(@"ErrCode_AccountEmailEmpty")  

#define ErrCodeNotTeacher           ErrCodeToLocalizedString(@"ErrCode_NotTeacher")         //非教师身份
#define ErrCodeOrgNotExist          ErrCodeToLocalizedString(@"ErrCode_OrgNotExist")        //组织不存在

#define ErrCodeEventStartDateEmpty  ErrCodeToLocalizedString(@"ErrCode_EventStartDateEmpty")//发布event起始时间为空
#define ErrCodeEventEndDateEmpty    ErrCodeToLocalizedString(@"ErrCode_EventEndDateEmpty")  //发布event结束时间为空
#define ErrCodeReceiverIDEmpty      ErrCodeToLocalizedString(@"ErrCode_ReceiverIDEmpty")    //发布event接收者ID列表为空
#define ErrCodeReceiverNameEmpty    ErrCodeToLocalizedString(@"ErrCode_ReceiverNameEmpty")  //发布event接收者名字列表为空
#define ErrCodeEventLocationEmpty   ErrCodeToLocalizedString(@"ErrCode_EventLocationEmpty") //发布event地点为空
#define ErrCodeEventTypeEmpty       ErrCodeToLocalizedString(@"ErrCode_EventTypeEmpty")     //发布event类型为空
#define ErrCodeEventTitleEmpty      ErrCodeToLocalizedString(@"ErrCode_EventTitleEmpty")    //发布event标题为空
#define ErrCodeEventContentEmpty    ErrCodeToLocalizedString(@"ErrCode_EventContentEmpty")  //发布event内容为空
#define ErrCodeEventUnknowError     ErrCodeToLocalizedString(@"ErrCode_EventUnknowError")   //发布event未知异常
#define ErrCodeEventInvalidEventID  ErrCodeToLocalizedString(@"ErrCode_EventInvalidEventID")//无效event ID

#define ErrCodeNewsIdEmpty          ErrCodeToLocalizedString(@"ErrCode_NewsIdEmpty")
#define ErrCodeNewsVerifyEmpty      ErrCodeToLocalizedString(@"ErrCode_NewsVerifyEmpty")
#define ErrCodeNewsNotExist         ErrCodeToLocalizedString(@"ErrCode_NewsNotExist")
#define ErrCodeNewsUnknowError      ErrCodeToLocalizedString(@"ErrCode_NewsUnknowError")

#define ErrCodeAccountAlreadyExist      ErrCodeToLocalizedString(@"ErrCode_AccountAlreadyExist")
#define ErrCodePhoneNumberNotCorrect    ErrCodeToLocalizedString(@"ErrCode_PhoneNumberNotCorrect")
#define ErrCodePhoneNumberOnly          ErrCodeToLocalizedString(@"ErrCode_PhoneNumberOnly")
#define ErrCodeCheckCodeEmpty           ErrCodeToLocalizedString(@"ErrCode_CheckCodeEmpty")
#define ErrCodeCheckCodeInvalid         ErrCodeToLocalizedString(@"ErrCode_CheckCodeInvalid")
#define ErrCodeCheckCodeNotCorrect      ErrCodeToLocalizedString(@"ErrCode_CheckCodeNotCorrect")

#define ErrCodeActivityNotExist         ErrCodeToLocalizedString(@"ErrCode_ActivityNotExist")
#define ErrCodeAccountForbidden         ErrCodeToLocalizedString(@"ErrCode_AccountForbidden")
#define ErrCodeActivityNotStart         ErrCodeToLocalizedString(@"ErrCode_ActivityNotStart")
#define ErrCodeActivityTooShort         ErrCodeToLocalizedString(@"ErrCode_ActivityTooShort")
#define ErrCodeGiftCheckedAll           ErrCodeToLocalizedString(@"ErrCode_GiftCheckedAll")
#define ErrCodeActivityTheOne           ErrCodeToLocalizedString(@"ErrCode_ActivityTheOne")
#define ErrCodeActivityInvalid          ErrCodeToLocalizedString(@"ErrCode_ActivityInvalid")
#define ErrCodeGiftCheckCodeEmpty       ErrCodeToLocalizedString(@"ErrCode_GiftCheckCodeEmpty")
#define ErrCodeGiftCheckedAll2          ErrCodeToLocalizedString(@"ErrCode_GiftCheckedAll2")
#define ErrCodeAccountNumberNull        ErrCodeToLocalizedString(@"ErrCode_AccountNumberNull")
#define ErrCodeAccountNumberNotExist    ErrCodeToLocalizedString(@"ErrCode_AccountNumberNotExist")
#define ErrCodeCheckCodeNotExist        ErrCodeToLocalizedString(@"ErrCode_CheckCodeNotExist")
#define ErrCodeGiftGetAll               ErrCodeToLocalizedString(@"ErrCode_GiftGetAll")
#define ErrCodeCouponCheckedAll         ErrCodeToLocalizedString(@"ErrCode_CouponCheckedAll")
#define ErrCodeActivityIDEmpty          ErrCodeToLocalizedString(@"ErrCode_ActivityIDEmpty")
#define ErrCodeGiftIDEmpty              ErrCodeToLocalizedString(@"ErrCode_GiftIDEmpty")
#define ErrCodeBonusNotEnough           ErrCodeToLocalizedString(@"ErrCode_BonusNotEnough")
#define ErrCodeGiftGetAll2              ErrCodeToLocalizedString(@"ErrCode_GiftGetAll2")
#define ErrCodeGiftCheckedAll3          ErrCodeToLocalizedString(@"ErrCode_GiftCheckedAll3")

NSString* ErrorCodeToString(NSString* errorCode)
{
    NSString* errorString = errorCode;
    NSInteger iErrorCode = [errorCode integerValue];
    if (iErrorCode >= 199012 && iErrorCode <= 199020) {
        errorString = @"手机会话KEY失效";
    }
    else if(iErrorCode == 199021) {
        errorString = @"会员账号已被注册";
    }
    else if(iErrorCode == 199022) {
        errorString = @"该邮箱已被注册";
    }
    else if(iErrorCode == 199023) {
        errorString = @"该邮箱格式非法";
    }
    else if(iErrorCode == 199024) {
        errorString = @"密码应6-12位数字或字母组成";
    }
    else if(iErrorCode == 199025) {
        errorString = @"账号应至少6位字母或数字组成";
    }
    else if(iErrorCode == 199026) {
        errorString = @"未知原因会员通过邮箱注册失败";
    }
    else if(iErrorCode == 199027) {
        errorString = @"未知原因会员邮箱激活码产生失败";
    }
    else if(iErrorCode == 199028) {
        errorString = @"未知原因发送会员激活邮件败";
    }
    else if(iErrorCode == 199029) {
        errorString = @"非法校验码，无法激活会员";
    }
    else if(iErrorCode == 199030) {
        errorString = @"激活校验码过期失效";
    }
    else if(iErrorCode == 199031) {
        errorString = @"无法凭激活校验码找到会员";
    }
    else if(iErrorCode == 199032) {
        errorString = @"未知原因无法激活邮箱注册会员";
    }
    else if(iErrorCode == 199033) {
        errorString = @"未知原因使用激活校验码失败";
    }
    else if(iErrorCode == 199034) {
        errorString = @"导购平台ID、手机会话KEY、会员账号、会员密码不可为空";
    }
    else if(iErrorCode == 199035) {
        errorString = @"会员密码非法";
    }
    else if(iErrorCode == 199036) {
        errorString = @"无该注册会员";
    }
    else if(iErrorCode == 199037) {
        errorString = @"会员还没有激活或状态无效";
    }
    else if(iErrorCode == 199038) {
        errorString = @"会员密码错误";
    }
    else if(iErrorCode == 199039) {
        errorString = @"无法获取会员统计信息";
    }
    else if(iErrorCode == 199040) {
        errorString = @"导购平台ID、手机会话KEY、会员账号";
    }
    else if(iErrorCode == 199041) {
        errorString = @"导购平台ID、手机号不可为空";
    }
    else if(iErrorCode == 199042) {
        errorString = @"手机号不正确";
    }
    else if(iErrorCode == 199043) {
        errorString = @"未知原因无法生成手机校验码";
    }
    else if(iErrorCode == 199044) {
        errorString = @"短信网关异常，无法发送短信验证码";
    }
    else if(iErrorCode == 199045) {
        errorString = @"账号应为手机号格式";
    }
    else if(iErrorCode == 199046) {
        errorString = @"验证码已使用失效";
    }
    else if(iErrorCode == 199047) {
        errorString = @"未知原因会员注册失败";
    }
    else if(iErrorCode == 199048) {
        errorString = @"上传文件必须是常规图片文件";
    }
    else if(iErrorCode == 199049) {
        errorString = @"导购平台ID、手机会话KEY、城市ID参数不可为空";
    }
    else if(iErrorCode == 199050) {
        errorString = @"经度坐标、纬度坐标及范围必选不可为空";
    }
    else if(iErrorCode == 199051) {
        errorString = @"未知原因无法获取条件商家数量";
    }
    else if(iErrorCode == 199052) {
        errorString = @"未知原因无法获取条件商家列表";
    }
    else if(iErrorCode == 199053) {
        errorString = @"当前页超过总页数范围，无法获取记录";
    }
    else if(iErrorCode == 199054) {
        errorString = @"导购平台ID、手机会话KEY、城市ID参数、排行榜ID不可为空";
    }
    else if(iErrorCode == 199055) {
        errorString = @"排行榜不存在";
    }
    else if(iErrorCode == 199056) {
        errorString = @"导购平台ID、手机会话KEY、商家ID不可为空";
    }
    else if(iErrorCode == 199057) {
        errorString = @"无法获取商家发布的资讯数量";
    }
    else if(iErrorCode == 199058) {
        errorString = @"无法获取商家发布的资讯列表";
    }
    else if(iErrorCode == 199059) {
        errorString = @"无法获取商家点评数量";
    }
    else if(iErrorCode == 199060) {
        errorString = @"无法获取商家点评列表";
    }
    else if(iErrorCode == 199061) {
        errorString = @"无法获取商家签到数量";
    }
    else if(iErrorCode == 199062) {
        errorString = @"无法获取商家签到列表";
    }
    else if(iErrorCode == 199063) {
        errorString = @"未知原因无法获取记录数量";
    }
    else if(iErrorCode == 199064) {
        errorString = @"未知原因无法获查询的列表记录";
    }
    else if(iErrorCode == 199065) {
        errorString = @"导购平台ID、手机会话KEY、会员账号、商家ID、评分、评内容不可为空";
    }
    else if(iErrorCode == 199066) {
        errorString = @"商家不存在";
    }
    else if(iErrorCode == 199067) {
        errorString = @"用户曾提交过相同内容";
    }
    else if(iErrorCode == 199068) {
        errorString = @"内容至少6个字以上内容";
    }
    else if(iErrorCode == 199069) {
        errorString = @"附件图片处理保存出错";
    }
    else if(iErrorCode == 199070) {
        errorString = @"未知原因保存提交内容出错";
    }
    else if(iErrorCode == 199071) {
        errorString = @"推荐类型无法识别";
    }
    else if(iErrorCode == 199072) {
        errorString = @"导购平台ID、手机会话KEY、会员账号、商家ID不可为空";
    }
    
//    if ([errorCode isEqualToString:InvalidSchoolKey]){
//        //无效School参数
//        errorString = ErrCodeInvalidSchoolKey;
//    }
//    else if ([errorCode isEqualToString:UnopenSchoolGatway]){
//        //学校未开通网关
//        errorString = ErrCodeUnopenSchoolGatway;
//    }
//    else if ([errorCode isEqualToString:SendBugError]){
//        //申报故障或建议错误
//        errorString = ErrCodeSendBugError;
//    }
//    else if ([errorCode isEqualToString:UnkownClientType]){
//        //未知客户端类型
//        errorString = ErrCodeUnkownClientType;
//    }
//    else if ([errorCode isEqualToString:NoNewPacket]){
//        //没有新资源包
//        errorString = ErrCodeNoNewPacket;
//    }
//    else if ([errorCode isEqualToString:PacketNotExist]){
//        //资源包不存在
//        errorString = ErrCodePacketNotExist;
//    }
//    else if ([errorCode isEqualToString:UnkownError]){
//        //未知错误
//        errorString = ErrCodeUnkownError;
//    }
//    else if ([errorCode isEqualToString:AccountNotExist]){
//        //帐号不存在
//        errorString = ErrCodeAccountNotExist;
//    }
//    else if ([errorCode isEqualToString:LoginInfoNotMatch]){
//        //帐号或密码错误
//        errorString = ErrCodeLoginInfoNotMatch;
//    }
//    else if ([errorCode isEqualToString:LoginParamEmpty]){
//        //登录帐号、密码、学校ID为空
//        errorString = ErrCodeLoginParamEmpty;
//    }
//    else if ([errorCode isEqualToString:InvalidSessionKey]){
//        //无效SessionKey
//        errorString = ErrCodeInvalidSessionKey;
//    }
//    else if ([errorCode isEqualToString:InvalidProfileKey]){
//        //无效ProfileKey
//        errorString = ErrCodeInvalidProfileKey;
//    }
//    
//    else if ([errorCode isEqualToString:InvalidSchoolId]){
//        errorString = ErrCodeInvalidSchoolId;
//    }
//    else if ([errorCode isEqualToString:AccounTypeEmpty]){
//        errorString = ErrCodeAccounTypeEmpty;
//    }
//    else if ([errorCode isEqualToString:AccountTypeNotCorrect]){
//        errorString = ErrCodeAccountTypeNotCorrect;
//    }
//    else if ([errorCode isEqualToString:AccountRightForbidden]){
//        errorString = ErrCodeAccountRightForbidden;
//    }
//    else if ([errorCode isEqualToString:AccountBlockup]){
//        errorString = ErrCodeAccountBlockup;
//    }
//    else if ([errorCode isEqualToString:AccountEmailEmpty]){
//        errorString = ErrCodeAccountEmailEmpty;
//    }
//    
//    else if ([errorCode isEqualToString:NotTeacher]){
//        //非教师身份
//        errorString = ErrCodeNotTeacher;
//    }
//    else if ([errorCode isEqualToString:OrgNotExist]){
//        //组织不存在
//        errorString = ErrCodeOrgNotExist;
//    }
//    else if ([errorCode isEqualToString:EventStartDateEmpty]){
//        //发布event起始时间为空
//        errorString = ErrCodeEventStartDateEmpty;
//    }
//    else if ([errorCode isEqualToString:EventEndDateEmpty]){
//        //发布event结束时间为空
//        errorString = ErrCodeEventEndDateEmpty;
//    }
//    else if ([errorCode isEqualToString:ReceiverIDEmpty]){
//        //发布event接收者ID列表为空
//        errorString = ErrCodeReceiverIDEmpty;
//    }
//    else if ([errorCode isEqualToString:ReceiverNameEmpty]){
//        //发布event接收者名字列表为空
//        errorString = ErrCodeReceiverNameEmpty;
//    }
//    else if ([errorCode isEqualToString:EventLocationEmpty]){
//        //发布event地点为空
//        errorString = ErrCodeEventLocationEmpty;
//    }
//    else if ([errorCode isEqualToString:EventTypeEmpty]){
//        //发布event类型为空
//        errorString = ErrCodeEventTypeEmpty;
//    }
//    else if ([errorCode isEqualToString:EventTitleEmpty]){
//        //发布event标题为空
//        errorString = ErrCodeEventTitleEmpty;
//    }
//    else if ([errorCode isEqualToString:EventContentEmpty]){
//        //发布event内容为空
//        errorString = ErrCodeEventContentEmpty;
//    }
//    else if ([errorCode isEqualToString:EventUnknowError]){
//        //发布event未知异常
//        errorString = ErrCodeEventUnknowError;
//    }
//    else if ([errorCode isEqualToString:EventInvalidEventID]){
//        //无效event ID
//        errorString = ErrCodeEventInvalidEventID;
//    }
//    /* 活动 */
//    else if ([errorCode isEqualToString:ActivityNotExist]){
//        errorString = ErrCodeEventInvalidEventID;
//    }
//    else if ([errorCode isEqualToString:AccountForbidden]){
//        errorString = ErrCodeAccountForbidden;
//    }
//    else if ([errorCode isEqualToString:ActivityNotStart]){
//        errorString = ErrCodeActivityNotStart;
//    }
//    else if ([errorCode isEqualToString:ActivityTooShort]){
//        errorString = ErrCodeActivityTooShort;
//    }
//    else if ([errorCode isEqualToString:GiftCheckedAll]){
//        errorString = ErrCodeGiftCheckedAll;
//    }
//    else if ([errorCode isEqualToString:ActivityTheOne]){
//        errorString = ErrCodeActivityTheOne;
//    }
//    else if ([errorCode isEqualToString:ActivityInvalid]){
//        errorString = ErrCodeActivityInvalid;
//    }
//    else if ([errorCode isEqualToString:GiftCheckCodeEmpty]){
//        errorString = ErrCodeGiftCheckCodeEmpty;
//    }
//    else if ([errorCode isEqualToString:GiftCheckedAll2]){
//        errorString = ErrCodeGiftCheckedAll2;
//    }
//    else if ([errorCode isEqualToString:AccountNumberNull]){
//        errorString = ErrCodeAccountNumberNull;
//    }
//    else if ([errorCode isEqualToString:AccountNumberNotExist]){
//        errorString = ErrCodeAccountNumberNotExist;
//    }
//    else if ([errorCode isEqualToString:CheckCodeNotExist]){
//        errorString = ErrCodeCheckCodeNotExist;
//    }
//    else if ([errorCode isEqualToString:GiftGetAll]){
//        errorString = ErrCodeGiftGetAll;
//    }
//    else if ([errorCode isEqualToString:CouponCheckedAll]){
//        errorString = ErrCodeCouponCheckedAll;
//    }
//    else if ([errorCode isEqualToString:ActivityIDEmpty]){
//        errorString = ErrCodeActivityIDEmpty;
//    }
//    else if ([errorCode isEqualToString:GiftIDEmpty]){
//        errorString = ErrCodeGiftIDEmpty;
//    }
//    else if ([errorCode isEqualToString:BonusNotEnough]){
//        errorString = ErrCodeBonusNotEnough;
//    }
//    else if ([errorCode isEqualToString:GiftGetAll2]){
//        errorString = ErrCodeGiftGetAll2;
//    }
//    else if ([errorCode isEqualToString:GiftCheckedAll3]){
//        errorString = ErrCodeGiftCheckedAll3;
//    }
//    /* 注册 */
//    else if ([errorCode isEqualToString:AccountAlreadyExist]){
//        errorString = ErrCodeAccountAlreadyExist;
//    }
//    else if ([errorCode isEqualToString:PhoneNumberNotCorrect]){
//        errorString = ErrCodePhoneNumberNotCorrect;
//    }
//    else if ([errorCode isEqualToString:PhoneNumberOnly]){
//        errorString = ErrCodePhoneNumberOnly;
//    }
//    else if ([errorCode isEqualToString:CheckCodeEmpty]){
//        errorString = ErrCodeCheckCodeEmpty;
//    }
//    else if ([errorCode isEqualToString:CheckCodeInvalid]){
//        errorString = ErrCodeCheckCodeInvalid;
//    }
//    else if ([errorCode isEqualToString:CheckCodeNotCorrect]){
//        errorString = ErrCodeCheckCodeNotCorrect;
//    }
//    /* 新闻*/
//    else if ([errorCode isEqualToString:NewsIdEmpty]){
//        errorString = ErrCodeNewsIdEmpty;
//    }
//    else if ([errorCode isEqualToString:NewsVerifyEmpty]){
//        errorString = ErrCodeNewsVerifyEmpty;
//    }
//    else if ([errorCode isEqualToString:NewsNotExist]){
//        errorString = ErrCodeNewsNotExist;
//    }
//    else if ([errorCode isEqualToString:NewsUnknowError]){
//        errorString = ErrCodeNewsUnknowError;
//    }
    return errorString;
}

