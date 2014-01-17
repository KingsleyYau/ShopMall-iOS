//
//  CommonRequestDefine.h
//  DrPalm
//
//  Created by KingsleyYau on 12-11-20.
//  Copyright (c) 2012年 KingsleyYau. All rights reserved.
//

#ifndef DrPalm_CommonRequestDefine_h
#define DrPalm_CommonRequestDefine_h

#pragma mark - 公共协议解析 ()
#define LBSAPPID        @"lbsappid"
#define SESSION_KEY     @"sessionkey"
#define DeviceToken     @"devicetoken"
#define DeviceType      @"devicetype"
#define LAT             @"lat"
#define LNG             @"lng"
#define Range           @"range"
#define Keyword         @"keyword"

#define RankOfScore    20
#define Score          @"score"
#define Score1         @"score1"
#define Score2         @"score2"
#define Score3         @"score3"
#define Score4         @"score4"


#define TotalRecordCount    @"totalrecordcount"
#define PageCur             @"curpage"
#define PageMaxRow          @"pagemaxrow"
#define PageMaxRowValue 14               // 每页最大纪录数目

#define OPCODE          @"code"
#define OPRET           @"opret"
#define OPFLAG          @"opflag"
#define OPSUCCESS       @"1"
#define OPFAIL          @"0"

#pragma mark - 公共协议 ()
#pragma mark - 设置用户邮箱
#define SetUserMail_Path       @"setusermail"
#define SetUserMail_Mail       @"mail"

#pragma mark - Push设置
#define SetPushInfo_Path       @"pushinfo/"
#define IfPush                 @"ifpush"
#define IfSound                @"ifsound"
#define IfShake                @"ifshake"
#define PushTime               @"pushtime"
#define Start                  @"start"
#define End                    @"end"

#pragma mark - 报Bug
#define SubmitProblem_Path          @"submitproblem.gw"
#define SubmitProblem_Problem       @"problem"
#define SubmitProblem_Suggestion    @"suggestion"

#pragma mark - 注册
#define GetCheckCode_Path           @"getmobilecode.gw"
#define RegisterPhoneNumber_Path    @"regmemberbymobile.gw"
#define RegisterEmail_Path          @"regmemberbyemail.gw"
#define RegisterPhoneNumber         @"phonenumber"
#define RegisterPassword            @"password"
#define RegisterUserName            @"username"
#define ResgisterCheckCode          @"checkcode"
#define ResgisterEmail              @"email"
#define RegisterMessage             @"msgtext"
#define Modify_Path                 @"changepwd.gw"
#define ModifyOldPassword           @"oldpassword"
#define ModifyNewPassword           @"newpassword"


#pragma mark - 登陆注销
#define Login_Path             @"login.gw"
#define Logout_Path            @"logout.gw"
#define DeviceType_IPhone      @"10"
#define UserInfo               @"userinfo"
#define UserID                 @"userid"
#define UserPwd                @"pwd"
#define UserName               @"nickname"
#define UserIcon               @"avatar"
#define UserScoreSp            @"spscore"
#define UserScoreOth           @"otherscore"
#define UserLevel              @"level"
#define UserInfoCount          @"myinfocount"
#define UserCheckInCount       @"checkincount"
#define UserReviewCount        @"reviewcount"
#define UserPhotoCount         @"photocount"
#define UserFavShopCount       @"favoshopcount"
#define UserFavShopInfoCount   @"favoshopinfocount"

#pragma mark - 上传头像
#define UploadMemberFace_Path  @"uploadmemberimg.gw"
#define MemberFaceParam        @"ufile"
#define MemberFaceFileName     @"userface.jpg"

#pragma mark - 签到
#define SignIn_Path            @"mobilesignin.gw"
#define SignOut_Path           @"mobilesignout.gw"
#define Refresh_Path           @"mobilelbs.gw"
#define CityOwn                @"owncity"

#pragma mark - 获取城市
#define CityList_Path          @"allcity.gw"
#define Cities                 @"cities"
#define CityAreaCode           @"cityareacode"
#define CityID                 @"cityid"
#define CityName               @"cityname"
#define CityChar               @"firstchar" 
#define CityRegionName         @"region"
#define CityIsHot              @"ishot"
#define CityIsPromo            @"ispromo"
#define CityTop                @"topcity"

#pragma mark - 获取城市顶层分类
#define CityNearList_Path      @"nearshopcoutinfo.gw"
#define CityCategories         @"categorynavs"
#define CityHyShopCount        @"hyfshopcount"
#define CityDsfShopCount       @"dsfshopcount"

#pragma mark - 获取商圈分类
#define RegionList_Path        @"regions.gw"
#define RegionParent           @"parentid"
#define Regions                @"regions"
#define RegionID               @"regionid"
#define RegionName             @"regionname"

#pragma mark - 获取行业分类       
#define CategoryList_Path      @"allcategories.gw"
#define CategoryParent         @"parentid"
#define Categories             @"categories"
#define CategoryID             @"categoryid"
#define CategoryIcon           @"categoryfavicon"
#define CategoryName           @"categoryname"
#define CategoryOrderID        @"categoryorderid"

#pragma mark - 获取排行榜分类
#define RankList_Path          @"allcatranks.gw"
#define CatRanks               @"catranks"
#define Ranks                  @"ranks"
#define RankID                 @"catrankid"
#define RankName               @"catrankname"
#define RankIcon               @"catrankfavicon"

#pragma mark - 获取积分分类
#define CreditList_Path        @"allcredittypes.gw"
#define CrediTypes             @"credittypes"
#define CreditID               @"credittypeid"
#define CreditName             @"credittypename"
#define CreditIcon             @"credittypeicon"

#pragma mark - 获取排序分类
#define SortList_Path          @"allshopsorttypes.gw"
#define Sorts                  @"shopsorttypes"
#define SortID                 @"sortid"
#define SortName               @"sortname"

#pragma mark - 获取商户
#define ShopList_Path          @"searchshopslist.gw"
#define ShopDetail_Path        @"shopinfo.gw"
#define ShopInfo               @"shopinfo"
#define Shops                  @"shops"
#define ShopID                 @"shopid"
#define ShopName               @"shopname"
#define ShopEngName            @"ename"
#define ShopBranchName         @"branchname"
#define ShopAddDate            @"adddate"
#define ShopLastDate           @"lastdate"
#define ShopAddress            @"address"
#define ShopWriteup            @"writeup"
#define ShopPhone              @"phoneno"
#define ShopPhone2             @"phoneno2"
#define ShopIfDiscount         @"ifdiscount"
#define ShopIfPromo            @"ifpromo"
#define ShopIfGift             @"ifgift"
#define ShopIfCard             @"ifcard"
#define ShopIfHyf              @"ifhyf"
#define ShopIfDsf              @"ifdsf"
#define ShopScore              @"score"
#define ShopScore1             @"score1"
#define ShopScore2             @"score2"
#define ShopScore3             @"score3"
#define ShopScore4             @"score4"
#define ShopScoreText          @"scoretext"
#define ShopTrafficInfo        @"trafficinfo"
#define ShopInfoSituation      @"infosituation"
#define ShopInfoCount          @"infototal"
#define ShopInfoLastTitle      @"curinfotitle"
#define ShopDefaultPic         @"defaultpic"
#define ShopPriceAvg           @"avgprice"
#define ShopPriceText          @"pricetext"

#pragma mark 网友推荐
#define ShopRecommendTags      @"recommendtags"
#define ShopRecommendTag       @"recommendtag"
#define ShopRecommendID        @"recommentid"

#pragma mark 最后评论
#define ShopCommentSituation        @"commentsituation"
#define ShopCommentTotal            @"commenttotal"
#define ShopCommentCuruser          @"curuser"
#define ShopCommentCurcommentStar   @"curcommentstar"
#define ShopCommentCurcomment       @"curcomment"
#define ShopCommentCurcommentTime   @"curcommenttime"

#pragma mark 最后签到
#define ShopSignSituation        @"signsituation"
#define ShopSignTotal            @"signtotal"
#define ShopSignCuruser          @"curuser"
#define ShopSignDetail           @"cursigndetail"
#define ShopSignCurSignTime      @"cursigntime"

#pragma mark - 其他会员信息
#define CustomUserID         @"userid"
#define CustomUserName       @"usernickname"
#define CustomUserIcon       @"userface"

#pragma mark - 获取商户点评
#define ShopComment_Path       @"getshopreviews.gw"
#define Comments               @"reviews"
#define CommentID              @"reviewid"
#define CommmentBody           @"reviewbody"
#define CommentTime            @"posttime"

#pragma mark - 获取商户签到
#define ShopSign_Path          @"getshopsignins.gw"
#define Signs                  @"signins"
#define SignID                 @"signid"
#define SignBody               @"signbody"
#define SignAtachment          @"attachedimg"
#define SignTime               @"signtime"

#pragma mark - 获取商户图片
#define ShopImage_Path         @"getshopimages.gw"
#define Images                 @"shopimgs"
#define ImageID                @"imgid"
#define ImageName              @"imgname"
#define ImageType              @"imgtype"
#define ImageThumbUrl          @"thumburl"
#define ImageFullUrl           @"fullurl"
#define ImageUploadUser        @"uploaduser"
#define ImageUploadTime        @"uploadtime"
#define ImageStar              @"star"
#define ImagePrice             @"price"
#define ImageTag               @"tag"

#pragma mark - 获取商户产品
#define ShopProduct_Path       @"getshopproducts.gw"
#define Products               @"products"
#define ProductID              @"proid"
#define ProductName            @"proname"
#define ProductDefaultPic      @"defaultpic"

#pragma mark - 获取商户推荐
#define ShopRecommend_Path     @"getshoprecommends.gw"
#define Recommends             @"recommends"
#define RecommendID            @"recommendid"
#define RecommendType          @"recommendtype"
#define RecommendTitle         @"recommendtitle"
#define RecommendAtachment     @"attachedimg"

#pragma mark - 获取具体商户资讯列表
#define ShopInfoList_Path      @"shopinfolist.gw"


#pragma mark - 获取商户资讯类型
#define ShopNewsType_Path      @"allinfotypes.gw"
#define ShopNewsTypes          @"infotypes"
#define ShopNewsTypeID         @"infotypeid"
#define ShopNewsTypeName       @"infotypename"
#define ShopNewsTypeIcon       @"infotypeicon"

#pragma mark - 获取商户资讯排行榜
#define ShopNewsRank_Path  @"allinforanks.gw"
#define ShopTypeRanks          @"inforanks"
#define ShopNewsRanks          @"ranks"
#define ShopNewsRankID         @"inforankid"
#define ShopNewsRankName       @"inforankname"
#define ShopNewsTypeRankIcon   @"inforankfavicon"
#define ShopNewsRankType       @"inforanktype"

#pragma mark - 获取商户资讯
#define ShopNewsList_Path           @"searchinfolist.gw"
#define ShopNewsRankList_Path       @"rankinfolist.gw"
#define ShopNewsDetail_Path         @"infodetail.gw"
#define ShopNewses                  @"infolist"
#define ShopNewsDetail              @"infodetail"
#define ShopNewsID                  @"infoid"
#define ShopNewsTitle               @"infotitle"
#define ShopNewsDesc                @"infodesc"
#define ShopNewsSmsInfo             @"smsinfo"
#define ShopNewsBeginDate           @"begindate"
#define ShopNewsEndDate             @"enddate"
#define ShopNewsInfoBeginDate       @"infobegindate"
#define ShopNewsInfoEndDate         @"infoenddate"
#define ShopNewsDefaultPic          @"defaultpic"
#define ShopNewsDetailPhoto         @"infophoto"

#define ShopNewsGetType             @"gettype"
#define ShopNewsGetTips             @"gettips"
#define ShopNewsShowType            @"showtype"
#define ShopNewsShowTips            @"showtips"
#define ShopNewsBuyTips             @"buytips"

#pragma mark - 资讯图片保存
#define ShopNewsPhoto_Path        @"getinfoimg.gw"

#pragma mark - 资讯手机短信下载
#define ShopNewsSms_Path        @"getinfosms.gw"
#pragma mark - 资讯手机短信购买
#define ShopNewsBuySms_Path     @"buymyinfo.gw"

#pragma mark - 提交商户签到
#define ShopSignCommit_Path    @"postsignin.gw"
#define SignAttachmentParam    @"attachedimg"
#define SignAttachmentFileName @"attachedimg.jpg"

#pragma mark - 提交商户点评
#define ShopCommentCommit_Path @"postshopreview.gw"

#pragma mark - 提交商户图片
#define ShopImageCommit_Path   @"postshopimg.gw"
#define ImageParam             @"shopimg"
#define ImageFileName          @"shopimg.jpg"

#pragma mark - 收藏商户
#define ShopBookmark_Path       @"postshopfavorite.gw" 

#pragma mark - 取消收藏商户
#define ShopUnBookmark_Path     @"cancelshopfavorite.gw" 

#pragma mark - 会员私人信息协议()
#pragma mark - 获取我的信息
#define MemberInfo_Path             @"getmyaccinfo.gw"
#pragma mark - 获取我的签到
#define MemberSign_Path             @"getmysignins.gw"
#pragma mark - 获取我的点评
#define MemberComment_Path          @"getmyreviews.gw"
#pragma mark - 获取我的图片               
#define MemberPicture_Path          @"getmyimages.gw"
#pragma mark - 获取我的收藏商户
#define MemberBookmarkShop_Path         @"getmyshops.gw"


#pragma mark - 获取我的券券
#define MemberShopNews_Path             @"getmyinfolist.gw"
#define MemberShopNewsDetail_Path       @"myinfodetail.gw"
#define ShopPersonalNewses              @"myinfolist"
#define ShopPersonalNewsesDetail        @"myinfo"
#define ShopPersonalNewsID              @"myinfoid"
#define ShopPersonalNewsUseTime         @"usetime"
#define ShopPersonalNewsGetTime         @"gettime"
#define ShopPersonalNewsCancelTime      @"canceltime"
#define ShopPersonalNewsVericode        @"vericode"
#define ShopPersonalNewsUrl             @"barimgurl"
#define ShopPersonalNewsStatus          @"status"
#endif
