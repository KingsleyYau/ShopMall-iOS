#import "SelfMapAnnotation.h"

@interface SelfMapAnnotation()

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@end

@implementation SelfMapAnnotation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
//@synthesize title = _title;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude {
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.title = @"当前位置";
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	self.latitude = newCoordinate.latitude;
	self.longitude = newCoordinate.longitude;
}


@end
