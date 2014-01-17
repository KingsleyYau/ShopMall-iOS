#import <UIKit/UIKit.h>
#import "PZPhotoView.h"
@class RequestImageView;

@protocol RequestImageViewDelegate <NSObject>
@optional
- (UIImage *)imageForDefault:(RequestImageView *)imageView;
- (BOOL)isSupportAllType:(RequestImageView *)imageView;
- (void)photoViewDidSingleTap:(RequestImageView *)imageView;
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView;
@end

@interface RequestImageView : UIView {
}
+ (UIImage *)placeholderImage;
+ (UIImage *)placeholderDefaultImage;
+ (UIImage *)placeholderUrlEmptyImage;
+ (UIImage *)imageForContentType:(NSString *)type;

+ (BOOL)isImageType:(NSString*)type;
+ (BOOL)isSupportType:(NSString*)type;

- (void)loadImage;
- (void)requestImage;
- (void)displayDefaultImage;
- (BOOL)displayImage;

@property (nonatomic, assign) IBOutlet id <RequestImageViewDelegate> delegate;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSData *downLoadImageData;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, assign) UIActivityIndicatorView *loadingView;
@property (nonatomic, assign) UIImageView *imageView;
@property (nonatomic) UIViewContentMode contentMode;
@property (nonatomic, assign) BOOL isWebView;
@property (nonatomic, assign) UIWebView *webView;
@property (nonatomic, assign) BOOL isPhotoView;
@property (nonatomic, assign) PZPhotoView *pZPhotoView;
@property (nonatomic, assign) BOOL animated;
@end
