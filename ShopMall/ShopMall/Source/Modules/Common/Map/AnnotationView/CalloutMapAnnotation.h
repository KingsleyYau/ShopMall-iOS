#import <Foundation/Foundation.h>

@interface CalloutMapAnnotation : MAShape /*NSObject <MKAnnotation>*/ {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic, assign) NSInteger tag;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

@end
