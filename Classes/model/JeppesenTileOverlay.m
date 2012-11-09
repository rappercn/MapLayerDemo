#import "JeppesenTileOverlay.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Util.h"

@implementation JeppesenTileOverlay
@synthesize boundingMapRect; // from <MKOverlay>
@synthesize coordinate;      // from <MKOverlay>
@synthesize defaultAlpha;
@synthesize tag;
@synthesize showMap, showShipMap;
-(id) init {
    self = [super init];
    
    defaultAlpha = 1;
    
    // I am still not well-versed in map projections, but the Google Mercator projection
    // is slightly off from the "standard" Mercator projection, used by MapKit. (GMerc is used
    // by the demo tileserver to serve to the Google Maps API script in a user's
    // browser.)
    //
    // My understanding is that this is due to Google Maps' use of a Spherical Mercator
    // projection, where the poles are cut off -- the effective map ending at approx. +/- 85º.
    // MapKit does not(?), therefore, our origin point (top-left) must be moved accordingly.
    
    boundingMapRect = MKMapRectWorld;
    boundingMapRect.origin.x += 1048600.0;
    boundingMapRect.origin.y += 1048600.0;
    coordinate = CLLocationCoordinate2DMake(0, 0);
    
    return self;
}

- (NSString *)urlForPointWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel {
    
    NSString *mapPath;
    NSString *ret = nil;
//    if (zoomLevel <= 1) {
        mapPath = [Util getCachePath:[@"map" stringByAppendingFormat:@"/%d", zoomLevel]];
//        ret = [mapPath stringByAppendingFormat:@"/LN%d/R%08x/C%08x.jpg", zoomLevel, y, x];
//    } else {
//        mapPath = [Util getCachePath:[@"map" stringByAppendingFormat:@"/L%02d", zoomLevel]];
//        ret = [mapPath stringByAppendingFormat:@"/L%02d/R%08x/C%08x.jpg", zoomLevel - 2, y, x];
//    }
    ret = [mapPath stringByAppendingFormat:@"/%d-%d-%d.jpg", zoomLevel, x, y];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ret]) {
//        NSLog(@"%@",ret);
        if (zoomLevel <= 1) {
            ret = [@"http://map.ctrack.com.cn/ChartMap" stringByAppendingFormat:@"/LN%d/R%08x/C%08x.jpg", zoomLevel, y, x];
        } else {
            ret = [@"http://map.ctrack.com.cn/ChartMap" stringByAppendingFormat:@"/L%02d/R%08x/C%08x.jpg", zoomLevel - 2, y, x];
        }
    }
    
    //    NSString* ret = [NSString stringWithFormat:@"http://tile.openstreetmap.org/%d/%d/%d.png",zoomLevel,x,y];
    //    NSLog(@"%@",ret);
    return ret;
}
- (NSString *)urlForShipWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel {
    NSString *shipMapPath = [[Util getCachePath] stringByAppendingFormat:@"/shipmap/%d/%d-%d-%d.png",zoomLevel, zoomLevel, x, y];

    if ([[NSFileManager defaultManager] fileExistsAtPath:shipMapPath]) {
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:shipMapPath error:nil];
        NSDate *cDate = [attrs objectForKey:NSFileCreationDate];
        NSInteger interval = [[NSDate date] timeIntervalSinceDate:cDate];
        if (interval > 3600) {
            if (zoomLevel > 6) {
                int lvl = pow(2, zoomLevel - 5);
                int row = y / lvl;
                int col = x / lvl;
                shipMapPath = [@"http://map.ctrack.com.cn/CustomMap/mctShipGps" stringByAppendingFormat:@"/%d/R%d/C%d/%d-%d-%d.png", zoomLevel, row, col, zoomLevel, x, y];
            } else {
                shipMapPath = [@"http://map.ctrack.com.cn/CustomMap/mctShipGps" stringByAppendingFormat:@"/%d/%d-%d-%d.png", zoomLevel, zoomLevel, x, y];
            }
        }
    } else {
        if (zoomLevel > 6) {
            int lvl = pow(2, zoomLevel - 5);
            int row = y / lvl;
            int col = x / lvl;
            shipMapPath = [@"http://map.ctrack.com.cn/CustomMap/mctShipGps" stringByAppendingFormat:@"/%d/R%d/C%d/%d-%d-%d.png", zoomLevel, row, col, zoomLevel, x, y];
        } else {
            shipMapPath = [@"http://map.ctrack.com.cn/CustomMap/mctShipGps" stringByAppendingFormat:@"/%d/%d-%d-%d.png", zoomLevel, zoomLevel, x, y];
        }
    }
    return shipMapPath;
}
- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    return YES;
}
@end
