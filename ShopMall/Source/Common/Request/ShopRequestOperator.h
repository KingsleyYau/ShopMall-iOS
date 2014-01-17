//
//  ShopRequestOperator.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-18.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "RequestOperator.h"

typedef enum{
    ShopRequestOperator_None,
    ShopRequestOperatorStatus_RegisterCheckCode,
    ShopRequestOperatorStatus_RegisterPhone,
    ShopRequestOperatorStatus_RegisterEmail,
    ShopRequestOperatorStatus_UploadUserFace,
    ShopRequestOperatorStatus_ModifyPassword,
    ShopRequestOperatorStatus_Login,
    ShopRequestOperatorStatus_Logout,
    ShopRequestOperatorStatus_SignIn,
    ShopRequestOperatorStatus_SignOut,
    ShopRequestOperatorStatus_Refresh,
    ShopRequestOperatorStatus_SetUserMail,
    ShopRequestOperatorStatus_SetPushInfo,
    ShopRequestOperatorStatus_SubmitProblem,
    
    ShopRequestOperatorStatus_UpdateCityList,
    ShopRequestOperatorStatus_UpdateCityCategory,
    ShopRequestOperatorStatus_UpdateCategory,
    ShopRequestOperatorStatus_UpdateRegionList,
    ShopRequestOperatorStatus_UpdateCredit,
    ShopRequestOperatorStatus_UpdateSort,
    ShopRequestOperatorStatus_UpdateRankList,
    ShopRequestOperatorStatus_UpdateShopList,
    ShopRequestOperatorStatus_UpdateShopListByRank,
    
    ShopRequestOperatorStatus_UpdateShopDetail,
    ShopRequestOperatorStatus_UpdateShopPicture,
    ShopRequestOperatorStatus_UpdateShopComment,
    ShopRequestOperatorStatus_UpdateShopSign,
    ShopRequestOperatorStatus_UpdateShopRecommend,
    ShopRequestOperatorStatus_UpdateShopProduct,
    ShopRequestOperatorStatus_UpdateShopInfoList,
    
    ShopRequestOperatorStatus_CommitShopPicture,
    ShopRequestOperatorStatus_CommitShopComment,
    ShopRequestOperatorStatus_CommitShopSign,
    ShopRequestOperatorStatus_CommitShopRecommend,
    ShopRequestOperatorStatus_CommitShopBookmark,
    ShopRequestOperatorStatus_CommitShopUnBookmark,
    
    ShopRequestOperatorStatus_UpdateShopNewsType,
    ShopRequestOperatorStatus_UpdateShopNewsRankList,
    ShopRequestOperatorStatus_UpdateShopNewsList,
    ShopRequestOperatorStatus_UpdateShopNewsDetail,
    ShopRequestOperatorStatus_GetShopNewsPhoto,
    ShopRequestOperatorStatus_GetShopNewsSms,
    ShopRequestOperatorStatus_BuyShopNewsSms,
    
    ShopRequestOperatorStatus_UpdateMemberInfo,
    ShopRequestOperatorStatus_UpdateMembeShopNewsList,
    ShopRequestOperatorStatus_UpdateMembeShopNewsDetail,
    ShopRequestOperatorStatus_UpdateMemberSignList,
    ShopRequestOperatorStatus_UpdateMembeCommentList,
    ShopRequestOperatorStatus_UpdateMemberPictureList,
    ShopRequestOperatorStatus_UpdateMemberBookmarkShopList,
    
}ShopRequestOperatorStatus;

@protocol ShopRequestOperatorDelegate <NSObject>
@optional
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type;
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type;
@end

@interface ShopRequestOperator : NSObject <RequestOperatorDelegate> {
    ShopRequestOperatorStatus  _status;
    RequestOperator *_requestOperator;
}

@property (nonatomic,assign)  id<ShopRequestOperatorDelegate> delegate;
// 取消请求
- (void)cancel;
#pragma mark - 公共协议 ()
#pragma mark 获取验证码
- (BOOL)getCheckCode:(NSString *)phoneNumber;
#pragma mark 手机注册
- (BOOL)registerPhoneNumber:(NSString *)phoneNumber pwd:(NSString *)pwd checkCode:(NSString *)checkCode userName:(NSString *)userName;
#pragma mark 邮箱注册
- (BOOL)registerEmail:(NSString *)email pwd:(NSString *)pwd userName:(NSString *)userName;
#pragma mark 上传头像
- (BOOL)uploadUserFace:(UIImage *)image;
#pragma mark 修改密码
- (BOOL)modifyPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;
#pragma mark 登录
- (BOOL)login:(NSString*)user pwd:(NSString*)pwd;
#pragma mark 注销
- (BOOL)logout;
#pragma mark 签到
- (BOOL)signIn:(NSString *)token lat:(CGFloat)lat lon:(CGFloat)lon;
#pragma mark 刷新定位
- (BOOL)refresh:(NSString *)sessionKey lat:(CGFloat)lat lon:(CGFloat)lon;
#pragma mark 签出
- (BOOL)signOut:(NSString *)sessionKey;
#pragma mark 设置用户邮箱
- (BOOL)setUserMail:(NSString*)mail;
#pragma mark Push设置
- (BOOL)setPushInfo:(BOOL)ifPush isVibrate:(BOOL)isVibrate isSound:(BOOL)isSound
          fromTime:(NSString*)fromTime toTime:(NSString*)toTime;
#pragma mark 报Bug
- (BOOL)submitProblem:(NSString*)problem suggestion:(NSString*)suggestion;

#pragma mark - 分类和排序协议 ()
#pragma mark 获取城市列表
- (BOOL)updateCityList;
#pragma mark 获取当前城市顶层行业
- (BOOL)updateCityCategoryList;
#pragma mark 获取行业分类
- (BOOL)updateCategoryList:(NSNumber *)parentCategoryID;
#pragma mark 获取行业排行榜
- (BOOL)updateRankList;
#pragma mark 获取积分分类
- (BOOL)updateCreditList;
#pragma mark 获取排序分类
- (BOOL)updateSortList;
#pragma mark 获取商圈分类
- (BOOL)updateRegionList:(NSNumber *)parentRegionID;

#pragma mark - 商户协议 ()
#pragma mark 获取商户列表
- (BOOL)updateShopList:(NSInteger)distance category:(NSNumber *)categoryID creditID:(NSNumber *)creditID regionID:(NSNumber *)regionID sortID:(NSNumber *)sortID searchKey:(NSString *)searchKey curMaxRow:(NSInteger)curMaxRow;
#pragma mark 获取排行榜商户列表
- (BOOL)updateShopListByRank:(NSNumber *)categoryID rankID:(NSNumber *)rankID curMaxRow:(NSInteger)curMaxRow;
#pragma mark 获取商户详细
- (BOOL)updateShopDetail:(NSNumber *)shopID;
#pragma mark 获取商户签到列表
- (BOOL)updateShopSign:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow;
#pragma mark 获取商户点评列表
- (BOOL)updateShopComment:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow;
#pragma mark 获取商户图片列表
- (BOOL)updateShopPicture:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow;
#pragma mark 获取商户推荐列表
- (BOOL)updateShopRecommend:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow;
#pragma mark 获取商户产品列表
- (BOOL)updateShopProduct:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow;
#pragma mark 获取商户资讯列表
- (BOOL)updateShopInfoList:(NSNumber *)shopID curMaxRow:(NSInteger)curMaxRow;

#pragma mark 提交商户签到
- (BOOL)submitShopSign:(NSNumber *)shopID score:(NSInteger)score body:(NSString *)body image:(UIImage *)image;
#pragma mark 提交商户点评
- (BOOL)submitShopComment:(NSNumber *)shopID score:(NSInteger)score scorePdu:(NSInteger)scorePdu scoreEnv:(NSInteger)scoreEnv scoreSrv:(NSInteger)scoreSrv scoreOth:(NSInteger)scoreOth body:(NSString *)body;
#pragma mark 提交商户图片
- (BOOL)submitShopImage:(NSNumber *)shopID imageType:(NSString *)imageType imageName:(NSString *)imageName star:(NSInteger)star price:(NSInteger)price image:(UIImage *)image;
#pragma mark 收藏商户
- (BOOL)submitShopBookmark:(NSNumber *)shopID;
#pragma mark 取消收藏商户
- (BOOL)submitShopUnBookmark:(NSNumber *)shopID;

#pragma mark - 商户资讯协议 ()
#pragma mark 获取商户资讯分类
- (BOOL)updateShopNewsTypeList;
#pragma mark 获取商户资讯排行榜
- (BOOL)updateShopNewsRankList;
#pragma mark 获取商户资讯列表
- (BOOL)updateShopNewsList:(NSNumber *)categoryID shopTypeID:(NSNumber *)shopTypeID creditID:(NSNumber *)creditID searchKey:(NSString *)searchKey curMaxRow:(NSInteger)curMaxRow;
#pragma mark 获取排行榜商户资讯列表
- (BOOL)updateShopListByRank:(NSNumber *)cityID shopTypeID:(NSNumber *)shopTypeID creditID:(NSNumber *)creditID rankID:(NSNumber *)rankID curMaxRow:(NSInteger)curMaxRow;
#pragma mark 获取商户资讯详细
- (BOOL)updateShopNewsDetail:(NSNumber *)shopNewsID;
#pragma mark 获取商户资讯图片
- (BOOL)getShopNewsDetailPhoto:(NSNumber *)shopNewsID;
#pragma mark 资讯手机短信下载
- (BOOL)getShopNewsInfoSms:(NSNumber *)shopNewsID phoneNumber:(NSString *)phoneNumber;
#pragma mark 资讯手机短信购买
- (BOOL)buyShopNewsInfoSms:(NSNumber *)shopNewsID phoneNumber:(NSString *)phoneNumber;

#pragma mark - 会员私人信息协议 ()
#pragma mark 获取我的信息
- (BOOL)updateMemberInfo;
#pragma mark 获取我的券券列表
- (BOOL)updateMemberShopNewList:(NSNumber *)status curMaxRow:(NSInteger)curMaxRow;
#pragma mark 获取我的券券详细
- (BOOL)updateShopPersonalNewsDetail:(NSNumber *)shopPersonalNewsID;
#pragma mark 获取我的签到评信息列表
- (BOOL)updateMemberSignList:(NSInteger)curMaxRow;
#pragma mark 获取我的点评信息列表
- (BOOL)updateMemberCommentList:(NSInteger)curMaxRow;
#pragma mark 获取我的图片信息列表
- (BOOL)updateMemberImageListList:(NSInteger)curMaxRow;
#pragma mark 获取我的收藏商户列表
- (BOOL)updateMemberBookmarkList:(NSInteger)curMaxRow;

@end
