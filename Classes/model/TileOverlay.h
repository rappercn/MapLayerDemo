#import <MapKit/MapKit.h>


@protocol TileOverlay <MKOverlay>

@property (nonatomic) CGFloat defaultAlpha;
- (NSString *)urlForPointWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel;
- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale;
@optional
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) BOOL showMap;
@property (nonatomic, assign) BOOL showShipMap;
- (NSString *)urlForShipWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel;
- (NSString *)imageSavePathWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel;
@end
