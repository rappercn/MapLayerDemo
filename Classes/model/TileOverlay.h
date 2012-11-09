#import <MapKit/MapKit.h>


@protocol TileOverlay <MKOverlay>

@property (nonatomic) CGFloat defaultAlpha;
- (NSString *)urlForPointWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel;
- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale;
@optional
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) BOOL showMap;
@property (nonatomic, assign) BOOL showShipMap;
@property (nonatomic, assign) BOOL mapOverlay;
- (NSString *)urlForShipWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel;
@end
