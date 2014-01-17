//
//  ShopRequestOperator.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-18.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopRequestOperator.h"
#import "ShopDataManager.h"
#import "SignInManager.h"
#import "LoginManager.h"
#import "NSString+MD5HexDigest.h"
@interface ShopRequestOperator() {
    
}
@property (nonatomic, retain) RequestOperator *requestOperator;

#pragma mark - 公共协议 ()
- (void)handleCheckCode:(id)json;
- (void)handleRegisterPhoneNumber:(id)json;
- (void)handleRegisterEmail:(id)json;
- (void)handleUploadUserFace:(id)json;
- (void)handleModifyPassword:(id)json;

- (void)handleLogin:(id)json;
- (void)handleLogout:(id)json;

- (void)handleSignIn:(id)json;
- (void)handleSignOut:(id)json;
- (void)handleRefresh:(id)json;

- (void)handleSetUsrMail:(id)json;
- (void)handleSetPushInfo:(id)json;
- (void)handleSubmitProblem:(id)json;

#pragma mark - 分类和排序协议 ()
- (void)handleUpdateCityList:(id)json;
- (void)handleUpdateCityCategoryList:(id)json;
- (void)handleUpdateCategoryList:(id)json;
- (void)handleUpdateCreditList:(id)json;
- (void)handleUpdateSortList:(id)json;
- (void)handleUpdateRegionList:(id)json;
- (void)handleUpdateRankList:(id)json;

#pragma mark - 商户协议 ()
- (void)handleUpdateShopList:(id)json;
- (void)handleUpdateShopListByRank:(id)json;
- (void)handleUpdateShopDetail:(id)json;

- (void)handleUpdateShopSign:(id)json;
- (void)handleUpdateShopComment:(id)json;
- (void)handleUpdateShopPicture:(id)json;
- (void)handleUpdateShopRecommend:(id)json;
- (void)handleUpdateShopProduct:(id)json;
- (void)handleUpdateShopInfoList:(id)json;

- (void)handleCommitShopSign:(id)json;
- (void)handleCommitShopComment:(id)json;
- (void)handleCommitShopPicture:(id)json;
//- (void)handleCommitShopRecommend:(id)json;
- (void)handleCommitShopBookmark:(id)json;
- (void)handleCommitUnShopBookmark:(id)json;

#pragma mark - 商户资讯协议 ()
- (void)handleUpdateShopNewsTypeList:(id)json;
- (void)handleUpdateShopNewsRankList:(id)json;
- (void)handleUpdateShopNewsList:(id)json;
- (void)handleUpdateShopNewsDetail:(id)json;
- (void)handleGetShopNewsSms:(id)json;
- (void)handleGetShopNewsDetailPhoto:(id)json;

#pragma mark - 会员私人信息协议 ()
- (void)handleUpdateMemberShopNewsList:(id)json;
- (void)handleUpdateMemberBookmarkShopList:(id)json;
- (void)handleUpdateMemberSignList:(id)json;
- (void)handleUpdateMemberCommentList:(id)json;
- (void)handleUpdateMemberImageList:(id)json;
@end

@implementation ShopRequestOperator
@synthesize delegate;
@synthesize requestOperator = _requestOperator;
#pragma mark - 构造 ()
- (id)init {
    self = [super init];
    if(self)
    {
        _requestOperator = [[RequestOperator alloc] init];
        _requestOperator.delegate = self;
        [self cancel];
    }
    return self;
}
- (void)dealloc {
    [self cancel];
    self.delegate = nil;
    self.requestOperator = nil;
    [super dealloc];
}
-(void)cancel {
    _status = ShopRequestOperator_None;
    [self.requestOperator cancel];
}
#pragma mark - 请求回调 (RequestOperatorDelegate)
- (void)requestFinish:(id)json {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    switch (_status) {
        case ShopRequestOperatorStatus_SetUserMail:{
            [self handleSetUsrMail:json];
            break;
        }
        case ShopRequestOperatorStatus_SetPushInfo:{
            [self handleSetPushInfo:json];
            break;
        }
        case ShopRequestOperatorStatus_SubmitProblem:{
            [self handleSubmitProblem:json];
            break;
        }
        case ShopRequestOperatorStatus_RegisterCheckCode:{
            [self handleCheckCode:json];
            break;
        }
        case ShopRequestOperatorStatus_RegisterPhone:{
            [self handleRegisterPhoneNumber:json];
            break;
        }
        case ShopRequestOperatorStatus_RegisterEmail:{
            [self handleRegisterEmail:json];
            break;
        }
        case ShopRequestOperatorStatus_UploadUserFace:{
            [self handleUploadUserFace:json];
            break;
        }
        case ShopRequestOperatorStatus_Login:{
            [self handleLogin:json];
            break;
        }
        case ShopRequestOperatorStatus_Logout:{
            [self handleLogout:json];
            break;
        }
        case ShopRequestOperatorStatus_ModifyPassword: {
            [self handleModifyPassword:json];
            break;
        }
        case ShopRequestOperatorStatus_SignIn:{
            [self handleSignIn:json];
            break;
        }
        case ShopRequestOperatorStatus_SignOut:{
            [self handleSignOut:json];
            break;
        }
        case ShopRequestOperatorStatus_Refresh:{
            [self handleRefresh:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateCityList:{
            [self handleUpdateCityList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateCityCategory:{
            [self handleUpdateCityCategoryList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateRegionList:{
            [self handleUpdateRegionList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateCategory:{
            [self handleUpdateCategoryList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateCredit:{
            [self handleUpdateCreditList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateSort:{
            [self handleUpdateSortList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateRankList:{
            [self handleUpdateRankList:json];
            break;
        }
            // 商户
        case ShopRequestOperatorStatus_UpdateShopList:{
            [self handleUpdateShopList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopListByRank:{
            [self handleUpdateShopListByRank:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopDetail:{
            [self handleUpdateShopDetail:json];
            break;
        }
            // 图片,推荐,签到,产品,推荐
        case ShopRequestOperatorStatus_UpdateShopPicture:{
            [self handleUpdateShopPicture:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopComment:{
            [self handleUpdateShopComment:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopSign:{
            [self handleUpdateShopSign:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopProduct:{
            [self handleUpdateShopProduct:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopRecommend:{
            [self handleUpdateShopRecommend:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopInfoList:{
            [self handleUpdateShopInfoList:json];
            break;
        }
            
        case ShopRequestOperatorStatus_CommitShopBookmark:{
            [self handleCommitShopBookmark:json];
            break;
        }
        case ShopRequestOperatorStatus_CommitShopUnBookmark:{
            [self handleCommitUnShopBookmark:json];
            break;
        }
            // 提交 图片,推荐,签到,推荐
        case ShopRequestOperatorStatus_CommitShopPicture:{
            [self handleCommitShopPicture:json];
            break;
        }
        case ShopRequestOperatorStatus_CommitShopComment:{
            [self handleCommitShopComment:json];
            break;
        }
        case ShopRequestOperatorStatus_CommitShopSign:{
            [self handleCommitShopSign:json];
            break;
        }
            // 资讯
        case ShopRequestOperatorStatus_UpdateShopNewsType:{
            [self handleUpdateShopNewsTypeList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopNewsRankList:{
            [self handleUpdateShopNewsRankList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopNewsList:{
            [self handleUpdateShopNewsList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopNewsDetail:{
            [self handleUpdateShopNewsDetail:json];
            break;
        }
        case ShopRequestOperatorStatus_GetShopNewsSms:{
            [self handleGetShopNewsSms:json];
            break;
        }
        case ShopRequestOperatorStatus_BuyShopNewsSms:{
            [self handleBuyShopNewsSms:json];
            break;
        }
        case ShopRequestOperatorStatus_GetShopNewsPhoto:{
            [self handleGetShopNewsDetailPhoto:json];
            break;
        }
            // 会员
        case ShopRequestOperatorStatus_UpdateMembeShopNewsList:{
            [self handleUpdateMemberShopNewsList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateMembeShopNewsDetail:{
            [self handleUpdateShopPersonalNewsDetail:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateMemberBookmarkShopList:{
            [self handleUpdateMemberBookmarkShopList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateMemberSignList:{
            [self handleUpdateMemberSignList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateMembeCommentList:{
            [self handleUpdateMemberCommentList:json];
            break;
        }
        case ShopRequestOperatorStatus_UpdateMemberPictureList:{
            [self handleUpdateMemberImageList:json];
            break;
        }
        default:{
            dispatch_async(dispatch_get_main_queue(), ^{
                if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                    [self.delegate requestFinish:json requestType:_status];
                }
            });
            break;
        }
    }
    [pool drain];
}
- (void)requestFail:(NSString*)error {
    // 网络请求失败
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:error requestType:_status];
        }
    });
}
#pragma mark - 公共协议 ()
#pragma mark -
#pragma mark 获取验证码
- (BOOL)getCheckCode:(NSString *)phoneNumber {
    [self cancel];
    _status = ShopRequestOperatorStatus_RegisterCheckCode;
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    if(phoneNumber.length > 0) {
        [paramDict setObject:phoneNumber forKey:RegisterPhoneNumber];
    }
    return [self.requestOperator sendSingleGet:GetCheckCode_Path paramDict:paramDict];
}
- (void)handleCheckCode:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 手机注册
- (BOOL)registerPhoneNumber:(NSString *)phoneNumber pwd:(NSString *)pwd checkCode:(NSString *)checkCode userName:(NSString *)userName{
    [self cancel];
    _status = ShopRequestOperatorStatus_RegisterPhone;
    NSMutableArray *postArray = [NSMutableArray array];
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    NSString *sessionKey = @"";
    if(signInManager.sessionKey.length > 0) {
        sessionKey = signInManager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }
    if(phoneNumber.length > 0) {
        // 用户名
        [postArray addObject:[self.requestOperator buildPostParam:UserID content:phoneNumber]];
    }
    if(pwd.length > 0) {
        // 密码
        [postArray addObject:[self.requestOperator buildPostParam:RegisterPassword content:pwd]];
    }
    if(checkCode.length >0) {
        // 验证码
        [postArray addObject:[self.requestOperator buildPostParam:ResgisterCheckCode content:checkCode]];
    }
    if(userName.length > 0) {
        // 网名
        [postArray addObject:[self.requestOperator buildPostParam:RegisterUserName content:userName]];
    }
    return [self.requestOperator sendSinglePost:RegisterPhoneNumber_Path paramArray:postArray];
}
- (void)handleRegisterPhoneNumber:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 邮箱注册
- (BOOL)registerEmail:(NSString *)email pwd:(NSString *)pwd userName:(NSString *)userName {
    [self cancel];
    _status = ShopRequestOperatorStatus_RegisterEmail;
    NSMutableArray *postArray = [NSMutableArray array];
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    NSString *sessionKey = @"";
    if(signInManager.sessionKey.length > 0) {
        sessionKey = signInManager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }
    if(email.length > 0) {
        // 用户名
        [postArray addObject:[self.requestOperator buildPostParam:UserID content:email]];
        // 邮箱
        [postArray addObject:[self.requestOperator buildPostParam:ResgisterEmail content:email]];
    }
    if(pwd.length > 0) {
        // 密码
        [postArray addObject:[self.requestOperator buildPostParam:RegisterPassword content:pwd]];
    }
    if(userName.length > 0) {
        // 网名
        [postArray addObject:[self.requestOperator buildPostParam:RegisterUserName content:userName]];
    }
    return [self.requestOperator sendSinglePost:RegisterEmail_Path paramArray:postArray];
}
- (void)handleRegisterEmail:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 上传头像
- (BOOL)uploadUserFace:(UIImage *)image {
    [self cancel];
    _status = ShopRequestOperatorStatus_UploadUserFace;
    NSMutableArray *postArray = [NSMutableArray array];
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    NSString *sessionKey = @"";
    if(signInManager.sessionKey.length > 0) {
        sessionKey = signInManager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    NSString *userID = @"";
    if(user.userID.length > 0) {
        userID = user.userID;
        [postArray addObject:[self.requestOperator buildPostParam:UserID content:userID]];
    }
    // 头像
    if(image) {
        NSData *data = UIImageJPEGRepresentation(image, 0.3f);
        [postArray addObject:[self.requestOperator buildFilePostParam:MemberFaceParam contentType:@"image/jpg" data:data fileName:MemberFaceFileName]];
    }
    return [self.requestOperator sendSinglePost:UploadMemberFace_Path paramArray:postArray];
}
- (void)handleUploadUserFace:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 修改密码
- (BOOL)modifyPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword {
    [self cancel];
    _status = ShopRequestOperatorStatus_ModifyPassword;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    NSString *sessionKey = @"";
    if(signInManager.sessionKey.length > 0) {
        sessionKey = signInManager.sessionKey;
        [paramDict setObject:sessionKey forKey:SESSION_KEY];
    }
    
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        [paramDict setObject:user.userID forKey:UserID];
    }
    if(oldPassword.length > 0) {
        [paramDict setObject:[[oldPassword toMD5String] lowercaseString] forKey:ModifyOldPassword];
    }
    if(newPassword.length >0) {
        [paramDict setObject:newPassword forKey:ModifyNewPassword];
    }
    
    return [self.requestOperator sendSingleGet:Modify_Path paramDict:paramDict];
}
- (void)handleModifyPassword:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 登录
- (BOOL)login:(NSString*)user pwd:(NSString*)pwd {
    [self cancel];
    _status = ShopRequestOperatorStatus_Login;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    NSString *sessionKey = @"";
    if(signInManager.sessionKey.length > 0) {
        sessionKey = signInManager.sessionKey;
        [paramDict setObject:sessionKey forKey:SESSION_KEY];
    }
    if(user.length > 0) {
        [paramDict setObject:user forKey:UserID];
    }
    if(pwd.length >0) {
        [paramDict setObject:pwd forKey:UserPwd];
    }
    
    return [self.requestOperator sendSingleGet:Login_Path paramDict:paramDict];
}
- (void)handleLogin:(id)json {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
//            [self.delegate requestFinish:json requestType:_status];
//        }
//    });
    if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
        [self.delegate requestFinish:json requestType:_status];
    }
    return;
}
#pragma mark 注销
- (BOOL)logout {
    [self cancel];
    _status = ShopRequestOperatorStatus_Logout;
    
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
//    LoginManager* loginmanage = LoginManagerInstance();
//    if(loginmanage.sessionKey.length > 0)
//        [paramDict setObject:SESSION_KEY forKey:loginmanage.sessionKey];
    return [self.requestOperator sendSingleGet:Logout_Path paramDict:paramDict];
}
- (void)handleLogout:(id)json {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
//            [self.delegate requestFinish:json requestType:_status];
//        }
//    });
    if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
        [self.delegate requestFinish:json requestType:_status];
    }
}
#pragma mark 签到
- (BOOL)signIn:(NSString*)token lat:(CGFloat)lat lon:(CGFloat)lon{
    [self cancel];
    _status = ShopRequestOperatorStatus_SignIn;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    if(token.length > 0) {
        [paramDict setObject:token forKey:DeviceToken];
    }

    // 纬度
    NSString *latString = [NSString stringWithFormat:@"%.8f", lat];
    [paramDict setObject:latString forKey:LAT];
    // 经度
    NSString *lonString = [NSString stringWithFormat:@"%.8f", lon];
    [paramDict setObject:lonString forKey:LNG];
    
    return [self.requestOperator sendSingleGet:SignIn_Path paramDict:paramDict];
}
- (void)handleSignIn:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 刷新定位
- (BOOL)refresh:(NSString *)sessionKey lat:(CGFloat)lat lon:(CGFloat)lon{
    [self cancel];
    _status = ShopRequestOperatorStatus_Refresh;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    [paramDict setObject:sessionKey forKey:SESSION_KEY];
    // 纬度
    NSString *latString = [NSString stringWithFormat:@"%.8f", lat];
    [paramDict setObject:latString forKey:LAT];
    // 经度
    NSString *lonString = [NSString stringWithFormat:@"%.8f", lon];
    [paramDict setObject:lonString forKey:LNG];
    return [self.requestOperator sendSingleGet:Refresh_Path paramDict:paramDict];
}
- (void)handleRefresh:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 签出
- (BOOL)signOut:(NSString *)sessionKey{
    [self cancel];
    _status = ShopRequestOperatorStatus_SignOut;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    [paramDict setObject:SESSION_KEY forKey:sessionKey];
    return [self.requestOperator sendSingleGet:SignOut_Path paramDict:paramDict];
}
- (void)handleSignOut:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
    return;
}
#pragma mark 设置用户邮箱
- (BOOL)setUserMail:(NSString*)mail {
    [self cancel];
    _status = ShopRequestOperatorStatus_SetUserMail;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
//    LoginManager* loginmanager = LoginManagerInstance();
//    [paramDict setObject:SESSION_KEY forKey:loginmanager.sessionKey];
    [paramDict setObject:mail forKey:SetUserMail_Mail];
    
    return [self.requestOperator sendSingleGet:SetUserMail_Path paramDict:paramDict];
}
- (void)handleSetUsrMail:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark Push设置
- (BOOL)setPushInfo:(BOOL)ifPush isVibrate:(BOOL)isVibrate isSound:(BOOL)isSound
          fromTime:(NSString*)fromTime toTime:(NSString*)toTime {
    [self cancel];
    _status = ShopRequestOperatorStatus_SetPushInfo;
    
    NSMutableArray *postArray = [NSMutableArray array];
    
//    // sessionkey
//    LoginManager* loginmanager = LoginManagerInstance();
//    NSString *sessionKey = @"";
//    if(loginmanager.sessionKey.length > 0)
//        sessionKey = loginmanager.sessionKey;
//    [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    //ifPush
    [postArray addObject:[self.requestOperator buildPostParam:IfPush content:ifPush?@"1":@"0"]];
    //ifShake
    [postArray addObject:[self.requestOperator buildPostParam:IfShake content:isVibrate?@"1":@"0"]];
    //ifSound
    [postArray addObject:[self.requestOperator buildPostParam:IfSound content:isSound?@"1":@"0"]];
    //PushTime
    NSString *pushtime = [NSString stringWithFormat:@"[{\"%@\":\"%@\",\"%@\":\"%@\"}]", Start, fromTime, End, toTime];
    [postArray addObject:[self.requestOperator buildPostParam:PushTime content:pushtime]];
    
    return [self.requestOperator sendSinglePost:SetPushInfo_Path paramArray:postArray];
}
- (void)handleSetPushInfo:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 报Bug
- (BOOL)submitProblem:(NSString*)problem suggestion:(NSString*)suggestion {
    [self cancel];
    _status = ShopRequestOperatorStatus_SubmitProblem;
    
    NSMutableArray *postArray = [NSMutableArray array];
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    NSString *sessionKey = @"";
    if(signInManager.sessionKey.length > 0) {
        sessionKey = signInManager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:sessionKey]];
    }
    
    if(problem.length > 0) {
        //problem
        [postArray addObject:[self.requestOperator buildPostParam:SubmitProblem_Problem content:problem]];
    }
    if(suggestion.length > 0) {
        //suggestion
        [postArray addObject:[self.requestOperator buildPostParam:SubmitProblem_Suggestion content:suggestion]];
    }
    
    return [self.requestOperator sendSinglePost:SubmitProblem_Path paramArray:postArray];
}
- (void)handleSubmitProblem:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}

#pragma mark - 分类和排序协议 ()
#pragma mark -
#pragma mark 获取城市列表
- (BOOL)updateCityList {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateCityList;
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    return [self.requestOperator sendSingleGet:CityList_Path paramDict:paramDict];
}
- (void)handleUpdateCityList:(id)json {
    id foundValue = [json objectForKey:Cities];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    [ShopDataManager cityInsertWithDict:dict];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取当前城市顶层行业
- (BOOL)updateCityCategoryList {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateCityCategory;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    // sessinKey
    SignInManager *signInManager = SignInManagerInstance();
    NSString *sessionKey = @"";
    if(signInManager.sessionKey.length > 0) {
        sessionKey = signInManager.sessionKey;
        [paramDict setObject:sessionKey forKey:SESSION_KEY];
    }

    
    if([[ShopDataManager cityCurrent].cityID isEqualToNumber:[ShopDataManager cityGPS].cityID]) {
        // 当前城市和定位城市一样
        // 经度
        NSString *latString = [NSString stringWithFormat:@"%.8f", signInManager.checkInLocation.coordinate.latitude];
        [paramDict setObject:latString forKey:LAT];
        // 纬度
        NSString *lonString = [NSString stringWithFormat:@"%.8f", signInManager.checkInLocation.coordinate.longitude];
        [paramDict setObject:lonString forKey:LNG];
    }
    else {
        // 经度
        NSString *latString = [NSString stringWithFormat:@"%.8f", [[ShopDataManager cityCurrent].lat doubleValue]];
        [paramDict setObject:latString forKey:LAT];
        // 纬度
        NSString *lonString = [NSString stringWithFormat:@"%.8f", [[ShopDataManager cityCurrent].lon doubleValue]];
        [paramDict setObject:lonString forKey:LNG];
    }



    return [self.requestOperator sendSingleGet:CityNearList_Path paramDict:paramDict];
}
- (void)handleUpdateCityCategoryList:(id)json {
    id foundValue = [json objectForKey:CityCategories];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    ShopCategory *category = [ShopDataManager categaoryInsertWithDict:dict];
                    City *city = [ShopDataManager cityCurrent];
                    [city addCategoryObject:category];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取行业分类
- (BOOL)updateCategoryList:(NSNumber *)parentCategoryID {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateCategory;
    self.requestOperator.paramOperation = parentCategoryID;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    // 父分类ID
    if(parentCategoryID) {
        NSString *lonString = [NSString stringWithFormat:@"%@", parentCategoryID];
        [paramDict setObject:lonString forKey:CategoryParent];
    }
    return [self.requestOperator sendSingleGet:CategoryList_Path paramDict:paramDict];
}
- (void)handleUpdateCategoryList:(id)json {
    id foundValue = [json objectForKey:Categories];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 标记分类为已经加载子分类
            ShopCategory *parentCategory = [ShopDataManager categaoryInsertWithId:self.requestOperator.paramOperation];
            parentCategory.isAlreadyLoad = [NSNumber numberWithBool:YES];
            
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    [ShopDataManager categaoryInsertWithDict:dict];
                }
            }
            [CoreDataManager saveData];
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });

    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取行业排行榜
- (BOOL)updateRankList {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateRankList;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    return [self.requestOperator sendSingleGet:RankList_Path paramDict:paramDict];
}
- (void)handleUpdateRankList:(id)json {
    id foundValue = [json objectForKey:CatRanks];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    ShopCategory *category = [ShopDataManager categaoryInsertWithDict:dict];
                    id foundValueRank = [dict objectForKey:Ranks];
                    if(nil != category && nil != foundValueRank && [NSNull null] != foundValueRank) {
                        if([foundValueRank isKindOfClass:[NSArray class]]) {
                            for(NSDictionary* dictRank in (NSArray*)foundValueRank) {
                                [ShopDataManager rankInsertWithDict:dictRank categoryID:category.categoryID];
                            }
                        }
                    }
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取积分分类
- (BOOL)updateCreditList {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateCredit;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];

    return [self.requestOperator sendSingleGet:CreditList_Path paramDict:paramDict];
}
- (void)handleUpdateCreditList:(id)json {
    id foundValue = [json objectForKey:CrediTypes];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    [ShopDataManager creditInsertWithDict:dict];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });

    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取排序分类
- (BOOL)updateSortList {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateSort;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    return [self.requestOperator sendSingleGet:SortList_Path paramDict:paramDict];
}
- (void)handleUpdateSortList:(id)json {
    id foundValue = [json objectForKey:Sorts];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    [ShopDataManager sortInsertWithDict:dict];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取商区分类
- (BOOL)updateRegionList:(NSNumber *)parentRegionID {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateRegionList;
    self.requestOperator.paramOperation = parentRegionID;
    
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    NSString *valueString = @"";
    
    // 当前城市
    City *city = [ShopDataManager cityCurrent];
    if(city.cityID) {
        valueString = [NSString stringWithFormat:@"%@", city.cityID];
        [paramDict setObject:valueString forKey:CityID];
    }
    
    // 父商区ID
    if(parentRegionID) {
        valueString = [NSString stringWithFormat:@"%@", parentRegionID];
        [paramDict setObject:valueString forKey:RegionParent];
    }
    return [self.requestOperator sendSingleGet:RegionList_Path paramDict:paramDict];
}
- (void)handleUpdateRegionList:(id)json {
    id foundValue = [json objectForKey:Regions];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 标记父商区为已经发送请求子商区并成功
            Region *parentRegion = [ShopDataManager regionWithId:self.requestOperator.paramOperation];
            parentRegion.isAlreadyLoad = [NSNumber numberWithBool:YES];
            
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    Region *region = [ShopDataManager regionInsertWithDict:dict];
                    [[ShopDataManager cityCurrent] addRegionObject:region];
                }
            }
            
             
            [CoreDataManager saveData];
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}

#pragma mark - 商户协议 ()
#pragma mark -
#pragma mark 获取商户列表
- (BOOL)updateShopList:(NSInteger)distance category:(NSNumber *)categoryID creditID:(NSNumber *)creditID regionID:(NSNumber *)regionID sortID:(NSNumber *)sortID searchKey:(NSString *)searchKey curMaxRow:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopList;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
     NSMutableDictionary *paramRetainDict =  [NSMutableDictionary dictionary];
    NSString *valueString = @"";
    
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }

    // 距离
    if(0 != distance) {
        // 不是全城
        valueString = [NSString stringWithFormat:@"%d", distance];
        [paramDict setObject:valueString forKey:Range];
        
        // 纬度
        valueString = [NSString stringWithFormat:@"%.8f", signInManager.checkInLocation.coordinate.latitude];
        [paramDict setObject:valueString forKey:LAT];
        
        // 经度
        valueString = [NSString stringWithFormat:@"%.8f", signInManager.checkInLocation.coordinate.longitude];
        [paramDict setObject:valueString forKey:LNG];
    }
    
    // 城市
    if([ShopDataManager cityCurrent].cityID) {
        valueString = [NSString stringWithFormat:@"%@", [ShopDataManager cityCurrent].cityID];
        [paramDict setObject:valueString forKey:CityID];
    }
    
    // 商区
    if(regionID && ![regionID isEqualToNumber:[ShopDataManager topRegion].regionID]) {
        valueString = [NSString stringWithFormat:@"%@", regionID];
        [paramDict setObject:valueString forKey:RegionID];
        [paramRetainDict setObject:regionID forKey:RegionID];
    }
    // 行业
    if(categoryID && ![categoryID isEqualToNumber:[ShopDataManager topCategory].categoryID]) {
        valueString = [NSString stringWithFormat:@"%@", categoryID];
        [paramDict setObject:valueString forKey:CategoryID];
    }
    // 积分
    if(creditID && ![creditID isEqualToNumber:[ShopDataManager topCredit].creditID]) {
        valueString = [NSString stringWithFormat:@"%@", creditID];
        [paramDict setObject:valueString forKey:CreditID];
        [paramRetainDict setObject:creditID forKey:CreditID];
    }
    // 排序
    if(sortID && ![sortID isEqualToNumber:[ShopDataManager topShopSortType].sortID]) {
        valueString = [NSString stringWithFormat:@"%@", sortID];
        [paramDict setObject:valueString forKey:SortID];
    }
    // 关键字
    if(searchKey) {
        [paramDict setObject:searchKey forKey:Keyword];
    }
    self.requestOperator.paramOperation = paramRetainDict;
    return [self.requestOperator sendSingleGet:ShopList_Path paramDict:paramDict];
}
- (void)handleUpdateShopList:(id)json {
    id foundValue = [json objectForKey:Shops];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                NSInteger index = 0;
                id value = [json objectForKey:PageCur];
                if(nil != value && [NSNull null] && [value isKindOfClass:[NSNumber class]]) {
                     index = ([value integerValue] - 1) * PageMaxRowValue;
                }
                for(NSDictionary* dict in (NSArray *)foundValue) {
                    Shop *shop = [ShopDataManager shopInsertWithDict:dict];
                    shop.sortOrder = [NSNumber numberWithInteger:index++];
                    
                    if(self.requestOperator.paramOperation && [self.requestOperator.paramOperation isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dictParam = self.requestOperator.paramOperation;
                        if([dictParam objectForKey:CreditID]) {
                            Credit *credit = [ShopDataManager creditInsertWithId:[dictParam objectForKey:CreditID]];
                            [shop addCreditObject:credit];
                        }
                        if([dictParam objectForKey:RegionID]) {
                            Region *region = [ShopDataManager regionInsertWithId:[dictParam objectForKey:RegionID]];
                            shop.region = region;
                        }
                    }
//                    if(self.requestOperator.paramOperation) {
//                        Credit *credit = [ShopDataManager creditInsertWithId:self.requestOperator.paramOperation];
//                        [shop addCreditObject:credit];
//                    }
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });

    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取排行榜商户列表
- (BOOL)updateShopListByRank:(NSNumber *)categoryID rankID:(NSNumber *)rankID curMaxRow:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopListByRank;
    self.requestOperator.paramOperation = [ShopDataManager rankWithId:rankID categoryID:categoryID];
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    NSString *valueString = @"";
    
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 城市
    if([ShopDataManager cityCurrent].cityID) {
        valueString = [NSString stringWithFormat:@"%@", [ShopDataManager cityCurrent].cityID];
        [paramDict setObject:valueString forKey:CityID];
    }
    
    // 排行榜
    if(rankID) {
        valueString = [NSString stringWithFormat:@"%@", rankID];
        [paramDict setObject:valueString forKey:RankID];
    }
    return [self.requestOperator sendSingleGet:ShopList_Path paramDict:paramDict];
}
- (void)handleUpdateShopListByRank:(id)json {
    id foundValue = [json objectForKey:Shops];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                NSInteger index = 0;
                id value = [json objectForKey:PageCur];
                if(nil != value && [NSNull null] && [value isKindOfClass:[NSNumber class]]) {
                    index = ([value integerValue] - 1) * PageMaxRowValue;
                }
                for(NSDictionary* dict in (NSArray *)foundValue) {
                    Shop *shop = [ShopDataManager shopInsertWithDict:dict];
                    shop.sortOrder = [NSNumber numberWithInteger:index];
                    if(self.requestOperator.paramOperation) {
                        [shop addRankObject:self.requestOperator.paramOperation];
                    }
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
        
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取商户详细
- (BOOL)updateShopDetail:(NSNumber *)shopID {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopDetail;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 城市
    Shop *shop = [ShopDataManager shopWithId:shopID];
    if(shop) {
        valueString = [NSString stringWithFormat:@"%@", shop.city.cityID];
        [paramDict setObject:valueString forKey:CityID];
    }
    else {
        if([ShopDataManager cityCurrent].cityID) {
            valueString = [NSString stringWithFormat:@"%@", [ShopDataManager cityCurrent].cityID];
            [paramDict setObject:valueString forKey:CityID];
        }
    }
    // 商户ID
    if(shopID) {
        valueString = [NSString stringWithFormat:@"%@", shopID];
        [paramDict setObject:valueString forKey:ShopID];
    }
    
    return [self.requestOperator sendSingleGet:ShopDetail_Path paramDict:paramDict];
}
- (void)handleUpdateShopDetail:(id)json {
    id foundValue = [json objectForKey:ShopInfo];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSDictionary class]]) {
                [ShopDataManager shopInsertWithDict:foundValue];
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取商户签到列表
- (BOOL)updateShopSign:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopSign;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 城市
    if([ShopDataManager cityCurrent].cityID) {
        valueString = [NSString stringWithFormat:@"%@", [ShopDataManager cityCurrent].cityID];
        [paramDict setObject:valueString forKey:CityID];
    }
    
    // 商户ID
    if(shopID) {
        self.requestOperator.paramOperation = shopID;
        NSString *valueString = [NSString stringWithFormat:@"%@", shopID];
        [paramDict setObject:valueString forKey:ShopID];
    }
    
    return [self.requestOperator sendSingleGet:ShopSign_Path paramDict:paramDict];
}
- (void)handleUpdateShopSign:(id)json {
    id foundValue = [json objectForKey:Signs];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    [ShopDataManager signInsertWithDict:dict shopID:self.requestOperator.paramOperation];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取商户点评列表
- (BOOL)updateShopComment:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopComment;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }

    // 城市
    if([ShopDataManager cityCurrent].cityID) {
        valueString = [NSString stringWithFormat:@"%@", [ShopDataManager cityCurrent].cityID];
        [paramDict setObject:valueString forKey:CityID];
    }
    
    // 商户ID
    if(shopID) {
        self.requestOperator.paramOperation = shopID;
        NSString *valueString = [NSString stringWithFormat:@"%@", shopID];
        [paramDict setObject:valueString forKey:ShopID];
    }
    
    return [self.requestOperator sendSingleGet:ShopComment_Path paramDict:paramDict];
}
- (void)handleUpdateShopComment:(id)json {
    id foundValue = [json objectForKey:Comments];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    [ShopDataManager commentInsertWithDict:dict shopID:self.requestOperator.paramOperation];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取商户图片列表
- (BOOL)updateShopPicture:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopPicture;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 城市
    if([ShopDataManager cityCurrent].cityID) {
        valueString = [NSString stringWithFormat:@"%@", [ShopDataManager cityCurrent].cityID];
        [paramDict setObject:valueString forKey:CityID];
    }
    
    // 商户ID
    if(shopID) {
        self.requestOperator.paramOperation = shopID;
        NSString *valueString = [NSString stringWithFormat:@"%@", shopID];
        [paramDict setObject:valueString forKey:ShopID];
    }
    
    return [self.requestOperator sendSingleGet:ShopImage_Path paramDict:paramDict];
}
- (void)handleUpdateShopPicture:(id)json {
    id foundValue = [json objectForKey:Images];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    NSNumber *shopID = self.requestOperator.paramOperation;
                    [ShopDataManager shopImagensertWithDict:dict shopID:shopID];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取商户推荐列表
- (BOOL)updateShopRecommend:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopRecommend;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 商户ID
    if(shopID) {
        self.requestOperator.paramOperation = shopID;
        NSString *valueString = [NSString stringWithFormat:@"%@", shopID];
        [paramDict setObject:valueString forKey:ShopID];
    }
    
    return [self.requestOperator sendSingleGet:ShopRecommend_Path paramDict:paramDict];
}
- (void)handleUpdateShopRecommend:(id)json {
    id foundValue = [json objectForKey:Recommends];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    [ShopDataManager recommendInsertWithDict:dict shopID:self.requestOperator.paramOperation];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取商户产品列表
- (BOOL)updateShopProduct:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopProduct;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 商户ID
    if(shopID) {
        self.requestOperator.paramOperation = shopID;
        NSString *valueString = [NSString stringWithFormat:@"%@", shopID];
        [paramDict setObject:valueString forKey:ShopID];
    }
    
    return [self.requestOperator sendSingleGet:ShopProduct_Path paramDict:paramDict];
}
- (void)handleUpdateShopProduct:(id)json {
    id foundValue = [json objectForKey:Products];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    [ShopDataManager productInsertWithDict:dict shopID:self.requestOperator.paramOperation];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取商户资讯列表
- (BOOL)updateShopInfoList:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopInfoList;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 城市
    if([ShopDataManager cityCurrent].cityID) {
        valueString = [NSString stringWithFormat:@"%@", [ShopDataManager cityCurrent].cityID];
        [paramDict setObject:valueString forKey:CityID];
    }
    
    // 商户ID
    if(shopID) {
        self.requestOperator.paramOperation = shopID;
        NSString *valueString = [NSString stringWithFormat:@"%@", shopID];
        [paramDict setObject:valueString forKey:ShopID];
    }
    
    return [self.requestOperator sendSingleGet:ShopInfoList_Path paramDict:paramDict];
}
- (void)handleUpdateShopInfoList:(id)json {
    id foundValue = [json objectForKey:ShopNewses];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    ShopNews *shopNews = [ShopDataManager shopNewsInsertWithDict:dict];
                    shopNews.city = [ShopDataManager currentInfo].cityCurrent;
                    Shop *shop = [ShopDataManager shopInsertWithId:self.requestOperator.paramOperation];
                    shopNews.shop = shop;
                }
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 提交商户签到
- (BOOL)submitShopSign:(NSNumber *)shopID score:(NSInteger)score body:(NSString *)body image:(UIImage *)image {
    [self cancel];
    _status = ShopRequestOperatorStatus_CommitShopSign;
    
    NSMutableArray *postArray = [NSMutableArray array];
    NSString *valueString = @"";
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:valueString]];
    }
    // 商户
    if(shopID) {
        valueString = [NSString stringWithFormat:@"%@", shopID];
        [postArray addObject:[self.requestOperator buildPostParam:ShopID content:valueString]];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [postArray addObject:[self.requestOperator buildPostParam:UserID content:valueString]];
    }
    // 评分
    valueString = [NSString stringWithFormat:@"%d", score];
    [postArray addObject:[self.requestOperator buildPostParam:Score content:valueString]];
    // 内容
    if(body.length > 0) {
        [postArray addObject:[self.requestOperator buildPostParam:SignBody content:body]];
    }
    // 附件
    if(image) {
        NSData *data = UIImageJPEGRepresentation(image, 0.3f);
        [postArray addObject:[self.requestOperator buildFilePostParam:SignAttachmentParam contentType:@"image/jpg" data:data fileName:SignAttachmentFileName]];
    }
    return [self.requestOperator sendSinglePost:ShopSignCommit_Path paramArray:postArray];
}
- (void)handleCommitShopSign:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 提交商户点评
- (BOOL)submitShopComment:(NSNumber *)shopID score:(NSInteger)score scorePdu:(NSInteger)scorePdu scoreEnv:(NSInteger)scoreEnv scoreSrv:(NSInteger)scoreSrv scoreOth:(NSInteger)scoreOth body:(NSString *)body {
    [self cancel];
    _status = ShopRequestOperatorStatus_CommitShopComment;
    
    NSMutableArray *postArray = [NSMutableArray array];
    NSString *valueString = @"";
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:valueString]];
    }
    // 商户
    if(shopID) {
        valueString = [NSString stringWithFormat:@"%@", shopID];
        [postArray addObject:[self.requestOperator buildPostParam:ShopID content:valueString]];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [postArray addObject:[self.requestOperator buildPostParam:UserID content:valueString]];
    }
    // 评分
    valueString = [NSString stringWithFormat:@"%d", score];
    [postArray addObject:[self.requestOperator buildPostParam:Score content:valueString]];
    valueString = [NSString stringWithFormat:@"%d", scorePdu];
    [postArray addObject:[self.requestOperator buildPostParam:Score1 content:valueString]];
    valueString = [NSString stringWithFormat:@"%d", scoreEnv];
    [postArray addObject:[self.requestOperator buildPostParam:Score2 content:valueString]];
    valueString = [NSString stringWithFormat:@"%d", scoreSrv];
    [postArray addObject:[self.requestOperator buildPostParam:Score3 content:valueString]];
    valueString = [NSString stringWithFormat:@"%d", scoreOth];
    [postArray addObject:[self.requestOperator buildPostParam:Score4 content:valueString]];
    // 内容
    if(body.length > 0) {
        [postArray addObject:[self.requestOperator buildPostParam:CommmentBody content:body]];
    }
    return [self.requestOperator sendSinglePost:ShopCommentCommit_Path paramArray:postArray];
}
- (void)handleCommitShopComment:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 提交商户图片
- (BOOL)submitShopImage:(NSNumber *)shopID imageType:(NSString *)imageType imageName:(NSString *)imageName star:(NSInteger)star price:(NSInteger)price image:(UIImage *)image {
    [self cancel];
    _status = ShopRequestOperatorStatus_CommitShopPicture;
    
    NSMutableArray *postArray = [NSMutableArray array];
    NSString *valueString = @"";
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:valueString]];
    }
    // 商户
    if(shopID) {
        valueString = [NSString stringWithFormat:@"%@", shopID];
        [postArray addObject:[self.requestOperator buildPostParam:ShopID content:valueString]];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [postArray addObject:[self.requestOperator buildPostParam:UserID content:valueString]];
    }
    // 类型
    if(imageType.length > 0) {
        valueString = imageType;
        [postArray addObject:[self.requestOperator buildPostParam:ImageType content:valueString]];
    }
    // 图片名
    if(imageName.length > 0) {
        valueString = imageName;
        [postArray addObject:[self.requestOperator buildPostParam:ImageName content:valueString]];
    }
    // 评分
    valueString = [NSString stringWithFormat:@"%d", star];
    [postArray addObject:[self.requestOperator buildPostParam:ImageStar content:valueString]];
    // 价格
    valueString = [NSString stringWithFormat:@"%d", price];
    [postArray addObject:[self.requestOperator buildPostParam:ImagePrice content:valueString]];
    // 附件
    if(image) {
        NSData *data = UIImageJPEGRepresentation(image, 0.3f);
        [postArray addObject:[self.requestOperator buildFilePostParam:ImageParam contentType:@"image/jpg" data:data fileName:ImageFileName]];
    }
    return [self.requestOperator sendSinglePost:ShopImageCommit_Path paramArray:postArray];
}
- (void)handleCommitShopPicture:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 收藏商户
- (BOOL)submitShopBookmark:(NSNumber *)shopID {
    [self cancel];
    _status = ShopRequestOperatorStatus_CommitShopBookmark;
    
    NSMutableArray *postArray = [NSMutableArray array];
    NSString *valueString = @"";
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:valueString]];
    }
    // 商户
    if(shopID) {
        valueString = [NSString stringWithFormat:@"%@", shopID];
        [postArray addObject:[self.requestOperator buildPostParam:ShopID content:valueString]];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [postArray addObject:[self.requestOperator buildPostParam:UserID content:valueString]];
    }
    return [self.requestOperator sendSinglePost:ShopBookmark_Path paramArray:postArray];
}
- (void)handleCommitShopBookmark:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 取消收藏商户
- (BOOL)submitShopUnBookmark:(NSNumber *)shopID {
    [self cancel];
    _status = ShopRequestOperatorStatus_CommitShopUnBookmark;
    
    NSMutableArray *postArray = [NSMutableArray array];
    NSString *valueString = @"";
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [postArray addObject:[self.requestOperator buildPostParam:SESSION_KEY content:valueString]];
    }
    // 商户
    if(shopID) {
        valueString = [NSString stringWithFormat:@"%@", shopID];
        [postArray addObject:[self.requestOperator buildPostParam:ShopID content:valueString]];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [postArray addObject:[self.requestOperator buildPostParam:UserID content:valueString]];
    }
    return [self.requestOperator sendSinglePost:ShopUnBookmark_Path paramArray:postArray];
}
- (void)handleCommitUnShopBookmark:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}

#pragma mark - 商户资讯协议 ()
#pragma mark 获取商户资讯分类
- (BOOL)updateShopNewsTypeList {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopNewsType;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    return [self.requestOperator sendSingleGet:ShopNewsType_Path paramDict:paramDict];
}
- (void)handleUpdateShopNewsTypeList:(id)json {
    id foundValue = [json objectForKey:ShopNewsTypes];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    [ShopDataManager shopNewsTypeInsertWithDict:dict];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取商户资讯排行榜
- (BOOL)updateShopNewsRankList {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopNewsRankList;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    return [self.requestOperator sendSingleGet:ShopNewsRank_Path paramDict:paramDict];
}
- (void)handleUpdateShopNewsRankList:(id)json {
    id foundValue = [json objectForKey:ShopTypeRanks];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    ShopNewsType *shopNewsType = [ShopDataManager shopNewsTypeInsertWithDict:dict];
                    id foundValueRank = [dict objectForKey:ShopNewsRanks];
                    if(nil != shopNewsType && nil != foundValueRank && [NSNull null] != foundValueRank) {
                        if([foundValueRank isKindOfClass:[NSArray class]]) {
                            for(NSDictionary* dictRank in (NSArray*)foundValueRank) {
                                [ShopDataManager shopNewsRankInsertWithDict:dictRank shopNewsTypeID:shopNewsType.shopNewsTypeID];
                            }
                        }
                    }
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });

    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取商户资讯列表
- (BOOL)updateShopNewsList:(NSNumber *)categoryID shopTypeID:(NSNumber *)shopTypeID creditID:(NSNumber *)creditID searchKey:(NSString *)searchKey curMaxRow:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopNewsList;
    NSMutableDictionary *paramDict  = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramRetainDict =  [NSMutableDictionary dictionary];
    NSString *valueString = @"";
    
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
//    // 全城
//    valueString = [NSString stringWithFormat:@"%d", 1000000];
//    [paramDict setObject:valueString forKey:Range];
//    
//    // 纬度
//    valueString = [NSString stringWithFormat:@"%f", signInManager.checkInLocation.coordinate.latitude];
//    [paramDict setObject:valueString forKey:LAT];
//    
//    // 经度
//    valueString = [NSString stringWithFormat:@"%f", signInManager.checkInLocation.coordinate.longitude];
//    [paramDict setObject:valueString forKey:LNG];
    
    // 城市
    if([ShopDataManager cityCurrent].cityID) {
        valueString = [NSString stringWithFormat:@"%@", [ShopDataManager cityCurrent].cityID];
        [paramDict setObject:valueString forKey:CityID];
    }
    // 行业
    if(categoryID && ![categoryID isEqualToNumber:[ShopDataManager topCategory].categoryID]) {
        valueString = [NSString stringWithFormat:@"%@", categoryID];
        [paramDict setObject:valueString forKey:CategoryID];
        [paramRetainDict setObject:categoryID forKey:CategoryID];
    }
    // 积分
    if(creditID && ![creditID isEqualToNumber:[ShopDataManager topCredit].creditID]) {
        valueString = [NSString stringWithFormat:@"%@", creditID];
        [paramDict setObject:valueString forKey:CreditID];
        [paramRetainDict setObject:creditID forKey:CreditID];
    }    
    // 关键字
    if(searchKey) {
        [paramDict setObject:searchKey forKey:Keyword];
    }
    self.requestOperator.paramOperation = paramRetainDict;
    return [self.requestOperator sendSingleGet:ShopNewsList_Path paramDict:paramDict];
}
- (void)handleUpdateShopNewsList:(id)json {
    id foundValue = [json objectForKey:ShopNewses];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    ShopNews *shopNews = [ShopDataManager shopNewsInsertWithDict:dict];
                    City *city = [ShopDataManager cityCurrent];
                    [city addShopNewsObject:shopNews];
                    if(self.requestOperator.paramOperation && [self.requestOperator.paramOperation isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dictParam = self.requestOperator.paramOperation;
                        if([dictParam objectForKey:CreditID]) {
                            Credit *credit = [ShopDataManager creditInsertWithId:[dictParam objectForKey:CreditID]];
                            [shopNews addCreditObject:credit];
                        }
                        if([dictParam objectForKey:CategoryID]) {
                            ShopCategory *category = [ShopDataManager categaoryInsertWithId:[dictParam objectForKey:CategoryID]];
                            shopNews.category = category;
                        }
                    }
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark - 获取排行榜商户资讯列表
- (BOOL)updateShopListByRank:(NSNumber *)cityID shopTypeID:(NSNumber *)shopTypeID creditID:(NSNumber *)creditID rankID:(NSNumber *)rankID curMaxRow:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopListByRank;
    self.requestOperator.paramOperation = [ShopDataManager shopNewsRankWithId:rankID shopNewsTypeID:shopTypeID];
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    NSString *valueString = @"";
    
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 城市
    if(cityID) {
        valueString = [NSString stringWithFormat:@"%@", cityID];
        [paramDict setObject:valueString forKey:CityID];
    }
    
    // 排行榜
    if(rankID) {
        valueString = [NSString stringWithFormat:@"%@", rankID];
        [paramDict setObject:valueString forKey:ShopNewsRankType];
    }
    return [self.requestOperator sendSingleGet:ShopNewsRankList_Path paramDict:paramDict];
}
#pragma mark 获取商户资讯详细
- (BOOL)updateShopNewsDetail:(NSNumber *)shopNewsID {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateShopNewsDetail;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 商户资讯ID
    if(shopNewsID) {
        valueString = [NSString stringWithFormat:@"%@", shopNewsID];
        [paramDict setObject:valueString forKey:ShopNewsID];
    }
    
    return [self.requestOperator sendSingleGet:ShopNewsDetail_Path paramDict:paramDict];
}
- (void)handleUpdateShopNewsDetail:(id)json {
    id foundValue = [json objectForKey:ShopNewsDetail];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSDictionary class]]) {
                [ShopDataManager shopNewsInsertWithDict:foundValue];
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取商户资讯图片
- (BOOL)getShopNewsDetailPhoto:(NSNumber *)shopNewsID {
    _status = ShopRequestOperatorStatus_GetShopNewsPhoto;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [paramDict setObject:valueString forKey:UserID];
    }
    
    // 商户资讯ID
    if(shopNewsID) {
        valueString = [NSString stringWithFormat:@"%@", shopNewsID];
        [paramDict setObject:valueString forKey:ShopNewsID];
        self.requestOperator.paramOperation = shopNewsID;
    }
    
    return [self.requestOperator sendSingleGet:ShopNewsPhoto_Path paramDict:paramDict];
}
- (void)handleGetShopNewsDetailPhoto:(id)json {
    id foundValue = [json objectForKey:ShopNewsDetailPhoto];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSString class]]) {
                [ShopDataManager shopNewsPhotoInsertWithDict:json shopNewsID:self.requestOperator.paramOperation];
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 资讯手机短信下载
- (BOOL)getShopNewsInfoSms:(NSNumber *)shopNewsID phoneNumber:(NSString *)phoneNumber {
    _status = ShopRequestOperatorStatus_GetShopNewsSms;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [paramDict setObject:valueString forKey:UserID];
    }
    
    // 商户资讯ID
    if(shopNewsID) {
        valueString = [NSString stringWithFormat:@"%@", shopNewsID];
        [paramDict setObject:valueString forKey:ShopNewsID];
    }
    
    // 电话号码
    if(phoneNumber.length > 0) {
        valueString = phoneNumber;
        [paramDict setObject:valueString forKey:RegisterPhoneNumber];
    }
    
    return [self.requestOperator sendSingleGet:ShopNewsSms_Path paramDict:paramDict];
}
- (void)handleGetShopNewsSms:(id)json {
    if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
        [self.delegate requestFinish:json requestType:_status];
    }
}
#pragma mark 资讯手机短信购买
- (BOOL)buyShopNewsInfoSms:(NSNumber *)shopNewsID phoneNumber:(NSString *)phoneNumber{
    _status = ShopRequestOperatorStatus_BuyShopNewsSms;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [paramDict setObject:valueString forKey:UserID];
    }
    
    // 商户资讯ID
    if(shopNewsID) {
        valueString = [NSString stringWithFormat:@"%@", shopNewsID];
        [paramDict setObject:valueString forKey:ShopNewsID];
    }
    
    // 电话号码
    if(phoneNumber.length > 0) {
        valueString = phoneNumber;
        [paramDict setObject:valueString forKey:RegisterPhoneNumber];
    }
    
    return [self.requestOperator sendSingleGet:ShopNewsBuySms_Path paramDict:paramDict];
}
- (void)handleBuyShopNewsSms:(id)json {
    if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
        [self.delegate requestFinish:json requestType:_status];
    }
}

#pragma mark - 会员私人信息协议 ()
#pragma mark 获取我的信息
- (BOOL)updateMemberInfo {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateMemberInfo;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    NSString *valueString = @"";
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [paramDict setObject:valueString forKey:UserID];
    }
    
    return [self.requestOperator sendSingleGet:MemberInfo_Path paramDict:paramDict];
}
- (void)handleUpdateMemberInfo:(id)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
            [self.delegate requestFinish:json requestType:_status];
        }
    });
}
#pragma mark 获取我的券券列表
- (BOOL)updateMemberShopNewList:(NSNumber *)status curMaxRow:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateMembeShopNewsList;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    NSString *valueString = @"";
    
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [paramDict setObject:valueString forKey:UserID];
    }
    
    // status
    if(status) {
        valueString = [NSString stringWithFormat:@"%@", status];
        [paramDict setObject:valueString forKey:ShopPersonalNewsStatus];
    }
    return [self.requestOperator sendSingleGet:MemberShopNews_Path paramDict:paramDict];
}
- (void)handleUpdateMemberShopNewsList:(id)json {
    id foundValue = [json objectForKey:ShopPersonalNewses];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    ShopPersonalNews *item = [ShopDataManager shopPersonalNewsInsertWithDict:dict];
                    item.user = [ShopDataManager userCurrent];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取我的券券详细
- (BOOL)updateShopPersonalNewsDetail:(NSNumber *)shopPersonalNewsID {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateMembeShopNewsDetail;
    NSMutableDictionary* paramDict  = [NSMutableDictionary dictionary];
    
    NSString *valueString;
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    
    // 商户资讯ID
    if(shopPersonalNewsID) {
        valueString = [NSString stringWithFormat:@"%@", shopPersonalNewsID];
        [paramDict setObject:valueString forKey:ShopPersonalNewsID];
    }
    
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [paramDict setObject:valueString forKey:UserID];
    }
    
    return [self.requestOperator sendSingleGet:MemberShopNewsDetail_Path paramDict:paramDict];
}
- (void)handleUpdateShopPersonalNewsDetail:(id)json {
    id foundValue = [json objectForKey:ShopPersonalNewsesDetail];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSDictionary class]]) {
                [ShopDataManager shopPersonalNewsInsertWithDict:foundValue];
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取我的签到列表
- (BOOL)updateMemberSignList:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateMemberSignList;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    NSString *valueString = @"";
    
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [paramDict setObject:valueString forKey:UserID];
    }
    return [self.requestOperator sendSingleGet:MemberSign_Path paramDict:paramDict];
}
- (void)handleUpdateMemberSignList:(id)json {
    id foundValue = [json objectForKey:Signs];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    Sign *sign = [ShopDataManager signInsertWithDict:dict shopID:nil];
                    sign.user = [ShopDataManager userCurrent];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取我的点评列表
- (BOOL)updateMemberCommentList:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateMembeCommentList;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    NSString *valueString = @"";
    
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [paramDict setObject:valueString forKey:UserID];
    }
    return [self.requestOperator sendSingleGet:MemberComment_Path paramDict:paramDict];
}
- (void)handleUpdateMemberCommentList:(id)json {
    id foundValue = [json objectForKey:Comments];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    Comment *comment = [ShopDataManager commentInsertWithDict:dict shopID:nil];
                    comment.user = [ShopDataManager userCurrent];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取我的图片信息列表
- (BOOL)updateMemberImageListList:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateMemberPictureList;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    NSString *valueString = @"";
    
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [paramDict setObject:valueString forKey:UserID];
    }
    return [self.requestOperator sendSingleGet:MemberPicture_Path paramDict:paramDict];
}
- (void)handleUpdateMemberImageList:(id)json {
    id foundValue = [json objectForKey:Images];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                for(NSDictionary* dict in (NSArray*)foundValue) {
                    ShopImage *shopImage = [ShopDataManager shopImagensertWithDict:dict shopID:nil];
                    shopImage.user = [ShopDataManager userCurrent];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
#pragma mark 获取我的收藏商户列表
- (BOOL)updateMemberBookmarkList:(NSInteger)curMaxRow {
    [self cancel];
    _status = ShopRequestOperatorStatus_UpdateMemberBookmarkShopList;
    
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    NSString *valueString = @"";
    
    // 每页最大纪录数
    valueString = [NSString stringWithFormat:@"%d", PageMaxRowValue];
    [paramDict setObject:valueString forKey:PageMaxRow];
    
    // 当次需要获取结果的第几页
    if(curMaxRow % PageMaxRowValue == 0) {
        // 当前显示最大纪录数目 为 每页最大纪录数目的倍数,表示还有更多
        NSInteger curPage = curMaxRow / PageMaxRowValue + 1;
        valueString = [NSString stringWithFormat:@"%d", curPage];
        [paramDict setObject:valueString forKey:PageCur];
    }
    else {
        // 没有更多
        if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
            [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
        }
        return NO;
    }
    
    // sessionkey
    SignInManager *signInManager = SignInManagerInstance();
    if(signInManager.sessionKey.length > 0) {
        valueString = signInManager.sessionKey;
        [paramDict setObject:valueString forKey:SESSION_KEY];
    }
    // 用户名
    User *user = [ShopDataManager userCurrent];
    if(user.userID.length > 0) {
        valueString = user.userID;
        [paramDict setObject:valueString forKey:UserID];
    }
    return [self.requestOperator sendSingleGet:MemberBookmarkShop_Path paramDict:paramDict];
}
- (void)handleUpdateMemberBookmarkShopList:(id)json {
    id foundValue = [json objectForKey:Shops];
    if(nil != foundValue && [NSNull null] != foundValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([foundValue isKindOfClass:[NSArray class]]) {
                NSInteger index = 0;
                id value = [json objectForKey:PageCur];
                if(nil != value && [NSNull null] && [value isKindOfClass:[NSNumber class]]) {
                    index = ([value integerValue] - 1) * PageMaxRowValue;
                }
                for(NSDictionary* dict in (NSArray *)foundValue) {
                    Shop *shop = [ShopDataManager shopInsertWithDict:dict];
                    shop.sortOrder = [NSNumber numberWithInteger:index];
                    [shop addUserBookmarkObject:[ShopDataManager userCurrent]];
                }
                [CoreDataManager saveData];
            }
            if([self.delegate respondsToSelector:@selector(requestFinish:requestType:)]){
                [self.delegate requestFinish:json requestType:_status];
            }
        });
        
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(requestFail:requestType:)]){
                [self.delegate requestFail:CommonRequestPotocolError requestType:_status];
            }
        });
    }
}
@end
