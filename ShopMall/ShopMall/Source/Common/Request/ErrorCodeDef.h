//
//  ErrorCodeDef.h
//  DrPalm
//
//  Created by KingsleyYau_lion on 12-3-5.
//  Copyright (c) 2012年 KingsleyYau. All rights reserved.
//

#ifndef DrPalm_ErrorCodeDef_h
#define DrPalm_ErrorCodeDef_h

#define InvalidSchoolKey        @"100001"   //无效School参数
#define UnopenSchoolGatway      @"100002"   //学校未开通网关
#define SendBugError            @"100051"   //
#define UnkownClientType        @"100060"   //未知客户端类型
#define NoNewPacket             @"100061"   //没有新资源包
#define PacketNotExist          @"100062"   //没有资源包
#define UnkownError             @"100099"   //未知错误

#define InvalidKey13            @"199013"   // 导购平台id,无效SessionKey,经纬度为空
#define LoginInfoNotMatch       @"199014"   // 
#define LoginParamEmpty         @"199015"   //登录帐号、密码、学校ID为空
#define InvalidSessionKey       @"199016"   // 无效SessionKey
//#define InvalidSessionKey       @"199017"   // 无效SessionKey


#define InvalidProfileKey       @"200005"   //无效ProfileKey
#define InvalidSchoolId         @"200006"   //SCHOOLID不可为空
#define AccounTypeEmpty         @"200007"   //用户类型不能为空
#define AccountTypeNotCorrect   @"200008"   //用户类型不匹配
#define AccountRightForbidden   @"200009"   //用户没有兑奖权限
#define AccountBlockup          @"200010"   //用户已经停用
#define AccountEmailEmpty       @"200011"   //用户邮箱为空


#define NotTeacher              @"500001"   //非教师身份
#define OrgNotExist             @"500002"   //组织不存在

#define EventStartDateEmpty     @"600001"   //发布event起始时间为空
#define EventEndDateEmpty       @"600002"   //发布event结束时间为空
#define ReceiverIDEmpty         @"600003"   //发布event接收者ID列表为空
#define ReceiverNameEmpty       @"600004"   //发布event接收者名字列表为空
#define EventLocationEmpty      @"600005"   //发布event地点为空
#define EventTypeEmpty          @"600006"   //发布event类型为空
#define EventTitleEmpty         @"600007"   //发布event标题为空
#define EventContentEmpty       @"600008"   //发布event内容为空
#define EventUnknowError        @"600009"   //发布event未知异常
#define EventInvalidEventID     @"600010"   //无效event ID

#define NewsIdEmpty             @"700001"   // 新闻ID不可为空
#define NewsVerifyEmpty         @"700002"   // 新闻审核状态（1：同意；0：不同意）不可为空
#define NewsNotExist            @"700003"   // 新闻不存在
#define NewsUnknowError         @"700004"   // 审核新闻未知错误

#define AccountAlreadyExist     @"800001"   // 账号和手机号码存在
#define PhoneNumberNotCorrect   @"800002"   // 手机号码必须11位
#define PhoneNumberOnly         @"800003"   // 输入的不是手机号码
#define CheckCodeEmpty          @"800004"   // 验证码为空
#define CheckCodeInvalid        @"800005"   // 验证码过期
#define CheckCodeNotCorrect     @"800006"   // 验证码不正确

#define ActivityNotExist        @"900001"   // 活动不存在
#define AccountForbidden        @"900002"   // 账号停用
#define ActivityNotStart        @"900003"   // 非活动时间
#define ActivityTooShort        @"900004"   // 参与间隔没到
#define GiftCheckedAll          @"900005"   // 已达奖品数上限
#define ActivityTheOne          @"900006"   // 只能中一次
#define ActivityInvalid         @"900007"   // 失效活动
#define GiftCheckCodeEmpty      @"900008"   // 兑奖码为空
#define GiftCheckedAll2         @"900009"   // 奖品已经兑换完毕
#define AccountNumberNull       @"900010"   // 会员卡号不能为空
#define AccountNumberNotExist   @"900011"   // 会员卡号不存在
#define CheckCodeNotExist       @"900012"   // 兑奖码不存在
#define GiftGetAll              @"900013"   // 已达发放礼品数上限
#define CouponCheckedAll        @"900014"   // 已达发放优惠卷上限
#define ActivityIDEmpty         @"900015"   // 活动ID不可为空
#define GiftIDEmpty             @"900016"   // 礼品ID不可为空
#define BonusNotEnough          @"900017"   // 当前用户积分不足以参与本兑换活动
#define GiftGetAll2             @"900018"   // 当前礼品已发放完毕
#define GiftCheckedAll3         @"900019"   // 当前礼品已兑换完毕

NSString* ErrorCodeToString(NSString* errorCode);
#endif
