#import "RequestImageView.h"
#import "ResourceManager.h"
#import "ConnectionWrapper.h"
#import "../ImageDefine.h"
@interface RequestImageView () <ConnectionWrapperDelegate, PZPhotoViewDelegate>{
    
}
@property (nonatomic, retain) ConnectionWrapper *connection;

@end
@implementation RequestImageView

@synthesize delegate, imageUrl, imageData, downLoadImageData, contentType, loadingView, imageView, contentMode, webView, isWebView, isPhotoView, pZPhotoView;
+ (UIImage *)placeholderImage {
    static NSString * const placeholderImageName = RequestImageViewPlaceholder;
    UIImage *placeholderImage = nil;
    if (!placeholderImage) {
        placeholderImage = [[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:placeholderImageName]] retain];
    }
    return placeholderImage;
}
+ (UIImage *)placeholderDefaultImage {
    static NSString * const placeholderDefaultImageName = RequestImageViewPlaceholderPreView;
    UIImage *placeholderImage = nil;
    if (!placeholderImage) {
        placeholderImage = [[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:placeholderDefaultImageName]] retain];
    }
    return placeholderImage;
}
+ (UIImage *)placeholderUrlEmptyImage {
    static NSString * const placeholderUrlEmptyImageName = RequestImageViewPlaceholderEmpty;
    UIImage *placeholderImage = nil;
    if (!placeholderImage) {
        placeholderImage = [[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:placeholderUrlEmptyImageName]] retain];
    }
    return placeholderImage;
}
- (void)displayDefaultImage {
    CGRect frame = self.frame;
    if(nil == self.imageView) {
        self.imageView = [[[UIImageView alloc] initWithImage:nil] autorelease]; // image is set below
        [self addSubview:self.imageView];
        self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.imageView.contentMode = self.contentMode;
        self.imageView.userInteractionEnabled = TRUE;
        //[imageView setContentStretch:CGRectMake(0.5f, 0.5f, 0.f, 0.f)];
        self.imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewSingleTap:)] autorelease];
        [self.imageView addGestureRecognizer:singleTap];
    }
    
    // 加载中显示默认图标
    self.imageView.hidden = NO;
    self.imageView.image = [RequestImageView placeholderDefaultImage];
}
- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.delegate = nil;
        self.connection = nil;
        self.imageUrl = nil;
        self.imageData = nil;
        self.loadingView = nil;
        self.imageView = nil;
        self.contentType = nil;
        self.webView = nil;
        self.isWebView = NO;
        self.pZPhotoView = nil;
        self.isPhotoView = NO;
        self.opaque = YES;
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.animated = NO;
    }
    return self;
}
- (void)loadImage {
    //self.contentType = nil;
    if(self.pZPhotoView) {
        self.pZPhotoView.hidden = YES;
    }
    if(self.webView) {
        webView.hidden = YES;
    }
    if(self.imageView) {
        self.imageView.image = nil;
        self.imageView.hidden = YES;
    }
    if ([self.connection isConnected]) {
        [self.connection cancel];
//        MIT_MobileAppDelegate *appDelegate = (MIT_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate hideNetworkActivityIndicator];
    }
    if (self.loadingView) {
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
    }
    // show cached image if available
    if (self.imageData) {
        // otherwise try to fetch the image from
        [self displayImage];
    } else {
        [self requestImage];
    }
}

- (BOOL)displayImage {
    BOOL wasSuccessful = NO;

    CGRect frame = self.frame;

    if(nil == self.pZPhotoView) {
        self.pZPhotoView = [[[PZPhotoView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        [self addSubview:self.pZPhotoView];
        self.pZPhotoView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.pZPhotoView.photoViewDelegate = self;
    }

    if(nil == self.webView) {
        self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.scalesPageToFit = YES;
        [self addSubview:self.webView];
        UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewSingleTap:)] autorelease];
        [self.webView addGestureRecognizer:singleTap];
    }

    if(nil == self.imageView) {
        self.imageView = [[[UIImageView alloc] initWithImage:nil] autorelease]; // image is set below
        [self addSubview:self.imageView];
        self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.imageView.contentMode = self.contentMode;
        self.imageView.userInteractionEnabled = TRUE;
        //[imageView setContentStretch:CGRectMake(0.5f, 0.5f, 0.f, 0.f)];
        self.imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewSingleTap:)] autorelease];
        [self.imageView addGestureRecognizer:singleTap];
    }

    
    [loadingView stopAnimating];
    loadingView.hidden = YES;
    imageView.hidden = YES;
    webView.hidden = YES;
    pZPhotoView.hidden = YES;
    
    //add by JiangBo
    if(self.imageUrl.length <= 0)
    {
        self.imageView.hidden = NO;
        if([self.delegate respondsToSelector:@selector(imageForDefault:)]) {
            self.imageView.image = [self.delegate imageForDefault:self];
        }
        else {
            self.imageView.image = [RequestImageView placeholderUrlEmptyImage];
        }
        return YES;
    }
    
    // don't show imageView if imageData isn't actually a valid image
    if(self.imageData) {
        wasSuccessful = YES;
        UIImage *image = [UIImage imageWithData:self.imageData];
        if(image) {
            // 可以拉伸缩放的图片
            if(isPhotoView) {
                self.pZPhotoView.hidden = NO;
                [self.pZPhotoView prepareForReuse];
                [self.pZPhotoView displayImage:image];
            }
            else {
                // 静态图片
                self.imageView.image = image;
                self.imageView.hidden = NO;
                if(self.animated) {
                    self.animated = NO;
                    self.imageView.alpha = 0.0;
                    [UIView animateWithDuration:0.5 animations:^{
                        //动画的内容
                        self.imageView.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        //动画结束
                        self.imageView.alpha = 1.0;
                    }];
                }
            }
        }
        else {
            if([RequestImageView isSupportType:self.contentType]) {
                // 有数据,查看是否支持类型,尝试用webview打开
                webView.hidden = NO;
                [webView loadData:self.imageData MIMEType:self.contentType textEncodingName:nil baseURL:nil];
            }
            else {
                // 非支持类型则显示默认图标
                wasSuccessful = NO;
            }
        }
    }
    else if([RequestImageView isSupportType:self.contentType]){
        // 没有数据,判断支持类型,显示对应图标
        self.imageView.hidden = NO;
        self.imageView.image = [RequestImageView imageForContentType:self.contentType];
        wasSuccessful = YES;
    }
    if(!wasSuccessful) {
        UIImage *imageDefault = nil;
//        if ([self.delegate respondsToSelector:@selector(imageForDefault:)]) {
//            // 自定义失败图标
//            imageDefault = [self.delegate imageForDefault:self];
//        }
        if( nil == imageDefault ){
            // 平铺方式
            //            self.backgroundColor = [UIColor colorWithPatternImage:[RequestImageView placeholderImage]];
            // 不能显示则显示默认图标
            self.imageView.hidden = NO;
            self.imageView.image = [RequestImageView placeholderImage];
        }
        else {
            // 平铺方式
            //            self.backgroundColor = [UIColor colorWithPatternImage:imageDefault];
            // 不能显示则显示默认图标
            self.imageView.hidden = NO;
            self.imageView.image = [RequestImageView placeholderImage];

        }
    }
    return wasSuccessful;
}

- (void)layoutSubviews {
//    imageView.frame = self.bounds;
//    if (self.loadingView) {
//        loadingView.center = CGPointMake(self.center.x - loadingView.frame.size.width / 2, self.center.y - loadingView.frame.size.height / 2);
//    }
}

- (void)requestImage {
    // TODO: don't attempt to load anything if there's no net connection
    self.animated = YES;
    if ([[self.imageUrl pathExtension] length] == 0) {
        [self displayImage];
        return;
    }
    
    if ([self.connection isConnected]) {
        [self displayImage];
        return;
    }
    
    if (!self.connection) {
        self.connection = [[[ConnectionWrapper alloc] initWithDelegate:self] autorelease];
    }
    NSLog(@"RequestView imageurl:%@", self.imageUrl);
    if([self.connection requestDataFromURL:[NSURL URLWithString:self.imageUrl] allowCachedResponse:YES]) {
        // 可以下载
        self.imageData = nil;
        
        [self displayDefaultImage];
        if (!self.loadingView) {
            self.loadingView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            [self addSubview:self.loadingView];
            
            self.loadingView.center = CGPointMake(self.center.x - loadingView.frame.size.width / 2, self.center.y - loadingView.frame.size.height / 2);
            self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        }
        //imageView.hidden = YES;
        pZPhotoView.hidden = YES;
        webView.hidden = YES;
        self.loadingView.hidden = NO;
        [self bringSubviewToFront:self.loadingView];
        [self.loadingView startAnimating];
    }
    else {
        [self displayImage];
    }

}

#pragma mark - url请求回调 (ConnectionWrapper delegate)
- (void)connection:(ConnectionWrapper *)wrapper handleData:(NSData *)data {
    // TODO: If memory usage becomes a concern, convert images to PNG using UIImagePNGRepresentation(). PNGs use considerably less RAM.
    dispatch_async(dispatch_get_main_queue(), ^{
        // 主线程示图片
        if([wrapper.theURL.absoluteString isEqualToString:self.imageUrl]){
            self.imageData = data;
            self.contentType = wrapper.contentType;
            if ([self.delegate respondsToSelector:@selector(imageViewDidDisplayImage:)]) {
                //                [self.delegate performSelectorOnMainThread:@selector(imageViewDidDisplayImage:) withObject:self waitUntilDone:YES];
                [self.delegate imageViewDidDisplayImage:self];
            }
        }
        [self displayImage];
    });
}
- (BOOL)connection:(ConnectionWrapper *)wrapper startDownload:(NSString*)ct {
    NSLog(@"RequestView self.contentType:%@", ct);
    self.contentType = ct;
    BOOL result = NO;
    if([RequestImageView isImageType:self.contentType]) {
        // 支持下载图片类型
        return YES;
    }
    if([self.delegate respondsToSelector:@selector(isSupportAllType:)]) {
        if([self.delegate isSupportAllType:self]) {
            if([RequestImageView isSupportType:self.contentType]) {
                // 支持下载的所有类型
                return YES;
            }
        }
    }
    
    if(result == NO) {
        // 不执行下载就显示对应内容
        dispatch_async(dispatch_get_main_queue(), ^{
            // 主线程示图片
            [self displayImage];
        });
    }
    return result;
}
-(void)connection:(ConnectionWrapper *)wrapper handleConnectionFailureWithError:(NSError *)error {
    self.imageData = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 主线程示图片
        [self displayImage];
    });
    // will fail to load the image, displays placeholder thumbnail instead
}
- (void)dealloc {
    self.delegate = nil;
    [self.connection cancel];
    self.connection = nil;
    self.imageData = nil;
    self.imageUrl = nil;
    self.contentType = nil;
    self.loadingView = nil;

    for (UIGestureRecognizer *gestureRecognizer in self.webView.gestureRecognizers) {
        [self.webView removeGestureRecognizer:gestureRecognizer];
    }
    
    for (UIGestureRecognizer *gestureRecognizer in self.imageView.gestureRecognizers) {
        [self.imageView removeGestureRecognizer:gestureRecognizer];
    }
    
    self.imageView = nil;
    self.webView = nil;
    self.pZPhotoView = nil;
    [super dealloc];
}
#pragma mark - 伸缩图片回调(PZPhotoViewDelegate)
- (void)photoViewDidSingleTap:(PZPhotoView *)photoView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewDidSingleTap:)]) {
        [self.delegate photoViewDidSingleTap:self];
    }
}
- (void)photoViewDidDoubleTap:(PZPhotoView *)photoView {
    
}
- (void)photoViewDidTwoFingerTap:(PZPhotoView *)photoView {
    
}
- (void)photoViewDidDoubleTwoFingerTap:(PZPhotoView *)photoView {
    
}
- (void)handleViewSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(photoViewDidSingleTap:)]) {
        [self.delegate photoViewDidSingleTap:self];
    }
}
#pragma mark - 判断Content－Type获取对应图标
+ (BOOL)isImageType:(NSString*)type {
    BOOL result = NO;
    if(type.length == 0)
        return result;
    NSArray *supportTypeArray = [NSArray arrayWithObjects:
                                 @"image/png",
                                 @"image/jpeg",
                                 @"image/pjpeg",
                                 @"image/bmp",
                                 @"image/gif",
                                 nil];
    NSString *lowerType = [type lowercaseString];
    for (NSString *supportType in supportTypeArray) {
        if([lowerType rangeOfString:supportType].location != NSNotFound) {
            result = YES;
            break;
        }
    }
    return result;
}
+ (BOOL)isWordType:(NSString*)type {
    BOOL result = NO;
    if(type.length == 0)
        return result;
    NSArray *supportTypeArray = [NSArray arrayWithObjects:
                                 @"application/msword",
                                 @"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                                 nil];
    NSString *lowerType = [type lowercaseString];
    for (NSString *supportType in supportTypeArray) {
        if([lowerType rangeOfString:supportType].location != NSNotFound) {
            result = YES;
            break;
        }
    }
    return result;
}
+ (BOOL)isPdfType:(NSString*)type {
    BOOL result = NO;
    if(type.length == 0)
        return result;
    NSArray *supportTypeArray = [NSArray arrayWithObjects:
                                 @"application/pdf",
                                 @"application/vnd.openxmlformats-officedocument.presentationml.presentation",
                                 nil];
    NSString *lowerType = [type lowercaseString];
    for (NSString *supportType in supportTypeArray) {
        if([lowerType rangeOfString:supportType].location != NSNotFound) {
            result = YES;
            break;
        }
    }
    return result;
}
+ (BOOL)isPptType:(NSString*)type {
    BOOL result = NO;
    if(type.length == 0)
        return result;
    NSArray *supportTypeArray = [NSArray arrayWithObjects:
                                 @"application/vnd.ms-powerpoint",
                                 @"application/vnd.openxmlformats-officedocument.presentationml.presentation",
                                 nil];
    NSString *lowerType = [type lowercaseString];
    for (NSString *supportType in supportTypeArray) {
        if([lowerType rangeOfString:supportType].location != NSNotFound) {
            result = YES;
            break;
        }
    }
    return result;
}
+ (BOOL)isExcelType:(NSString*)type {
    BOOL result = NO;
    if(type.length == 0)
        return result;
    NSArray *supportTypeArray = [NSArray arrayWithObjects:
                                 @"application/vnd.ms-excel",
                                 @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                 nil];
    NSString *lowerType = [type lowercaseString];
    for (NSString *supportType in supportTypeArray) {
        if([lowerType rangeOfString:supportType].location != NSNotFound) {
            result = YES;
            break;
        }
    }
    return result;
}
+ (BOOL)isTxtType:(NSString*)type {
    BOOL result = NO;
    if(type.length == 0)
        return result;
    NSArray *supportTypeArray = [NSArray arrayWithObjects:
                                 @"text/plain",
                                 nil];
    NSString *lowerType = [type lowercaseString];
    for (NSString *supportType in supportTypeArray) {
        if([lowerType rangeOfString:supportType].location != NSNotFound) {
            result = YES;
            break;
        }
    }
    return result;
}
+ (BOOL)isSupportType:(NSString*)type {
    if([RequestImageView isWordType:type] ||[RequestImageView isPdfType:type] ||[RequestImageView isExcelType:type] ||[RequestImageView isTxtType:type]||[RequestImageView isPptType:type])
        return YES;
    return NO;
}
+ (NSString *)typeStringForContentType:(NSString *)type {
    NSString *typeString = @"";
    if([RequestImageView isWordType:type]) {
        // word类型
        typeString = @"word";
    }
    else if([RequestImageView isPdfType:type]) {
        // pdf类型
        typeString = @"pdf";
    }
    else if([RequestImageView isExcelType:type]) {
        // excel类型
        typeString = @"excel";
    }
    else if([RequestImageView isTxtType:type]) {
        // excel类型
        typeString = @"txt";
    }
    else if([RequestImageView isPptType:type])
    {
        // ppt类型
        typeString = @"ppt";
    }
    else {
        typeString = @"";
    }
    return typeString;
}
+ (UIImage *)imageForContentType:(NSString *)type {
    NSString *fileName = [RequestImageView typeStringForContentType:type];
    NSString *placeholderImageName = [NSString stringWithFormat:@"%@-%@.png", RequestImageViewPlaceholderType, fileName];
//    static UIImage *placeholderImage = nil;
//    if (!placeholderImage) {
//        [placeholderImage release];
//        placeholderImage = [[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:placeholderImageName]] retain];
//    }
    UIImage *placeholderImage = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:placeholderImageName]];
    return placeholderImage;
}
@end
