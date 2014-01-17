#import <Foundation/Foundation.h>
@interface SelfMapAnnotation : MAShape/*NSObject <MKAnnotation>*/ {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
	//NSString *_title;
}

//@property (nonatomic, retain) NSString *title;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
