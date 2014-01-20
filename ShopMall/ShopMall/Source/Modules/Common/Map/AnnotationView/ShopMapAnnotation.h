#import <Foundation/Foundation.h>

#define ShopAnnotationImage @"shop/shop-annotation.png"

@interface ShopMapAnnotation : MAShape /*NSObject <MKAnnotation>*/ {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
	//NSString *_title;
}

//@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSInteger tag;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
