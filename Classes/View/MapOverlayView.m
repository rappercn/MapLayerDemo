//
//  MapOverlayView.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapOverlayView.h"
#import "TileOverlay.h"
#import "MapTileOverlay.h"
//#import "ASIHTTPRequest.h"
//#import "ASINetworkQueue.h"

#pragma mark Private methods
@interface MapOverlayView()
- (NSUInteger)zoomLevelForMapRect:(MKMapRect)mapRect;
- (NSUInteger)zoomLevelForZoomScale:(MKZoomScale)zoomScale;
- (NSUInteger)worldTileWidthForZoomLevel:(NSUInteger)zoomLevel;
- (CGPoint)mercatorTileOriginForMapRect:(MKMapRect)mapRect;
@end

#pragma mark -
#pragma mark Implementation

@implementation MapOverlayView

#pragma mark Private utility methods
/**
 * Given a MKMapRect, this returns the zoomLevel based on 
 * the longitude width of the box.
 *
 * This is because the Mercator projection, when tiled,
 * normally operates with 2^zoomLevel tiles (1 big tile for
 * world at zoom 0, 2 tiles at 1, 4 tiles at 2, etc.)
 * and the ratio of the longitude width (out of 360º)
 * can be used to reverse this.
 *
 * This method factors in screen scaling for the iPhone 4:
 * the tile layer will use the *next* zoomLevel. (We are given
 * a screen that is twice as large and zoomed in once more
 * so that the "effective" region shown is the same, but
 * of higher resolution.)
 */
- (NSUInteger)zoomLevelForMapRect:(MKMapRect)mapRect {
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    CGFloat lon_ratio = region.span.longitudeDelta/360.0;
    NSUInteger z = (NSUInteger)(log(1/lon_ratio)/log(2.0)-1.0);
    
    z += ([[UIScreen mainScreen] scale] - 1.0);
    return z;
}
/**
 * Similar to above, but uses a MKZoomScale to determine the
 * Mercator zoomLevel. (MKZoomScale is a ratio of screen points to
 * map points.)
 */
- (NSUInteger)zoomLevelForZoomScale:(MKZoomScale)zoomScale {
    CGFloat realScale = zoomScale / [[UIScreen mainScreen] scale];
    NSUInteger z = (NSUInteger)(log(realScale)/log(2.0)+20.0);

    z += ([[UIScreen mainScreen] scale] - 1.0);
    return z;
}
/**
 * Shortcut to determine the number of tiles wide *or tall* the
 * world is, at the given zoomLevel. (In the Spherical Mercator
 * projection, the poles are cut off so that the resulting 2D
 * map is "square".)
 */
- (NSUInteger)worldTileWidthForZoomLevel:(NSUInteger)zoomLevel {
    return (NSUInteger)(pow(2,zoomLevel));
}

/**
 * Given a MKMapRect, this reprojects the center of the mapRect
 * into the Mercator projection and calculates the rect's top-left point
 * (so that we can later figure out the tile coordinate).
 *
 * See http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Derivation_of_tile_names
 */
- (CGPoint)mercatorTileOriginForMapRect:(MKMapRect)mapRect {
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    // Convert lat/lon to radians
    CGFloat x = (region.center.longitude) * (M_PI/180.0); // Convert lon to radians
    CGFloat y = (region.center.latitude) * (M_PI/180.0); // Convert lat to radians
    y = log(tan(y)+1.0/cos(y));
    
    // X and Y should actually be the top-left of the rect (the values above represent
    // the center of the rect)
    x = (1.0 + (x/M_PI)) / 2.0;
    y = (1.0 - (y/M_PI)) / 2.0;
    
    return CGPointMake(x, y);
}
//-(void) loadFileFromUrl:(NSURL*)fileUrl savePath:(NSString*)savePath metadata:(NSDictionary *)metadata {
//
//    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:fileUrl];
//    [request setDownloadDestinationPath:savePath];
//    [request setAllowResumeForFileDownloads:YES];
//    [request setDelegate:self];
//    [request setTimeOutSeconds:20];
//    [request setNumberOfTimesToRetryOnTimeout:1];
//    request.userInfo = metadata;
////    [request startAsynchronous];
//    
//    ASINetworkQueue   * queue = [[[ASINetworkQueue alloc] init] autorelease];
//    [queue setMaxConcurrentOperationCount:2];
//    [queue setShowAccurateProgress:YES];
//    [queue addOperation:request];
////    [queueDictionary setObject:queue forKey:fileName];
//    [queue go];
//}

#pragma mark MKOverlayView methods

/**
 * Called by MapKit when a tile is on the visible space of the map.
 * This method tests the cache to see if a tile is available to be drawn.
 * If not, an asynchronous HTTP request is performed.
 *
 * Returns YES if a tile can be draw immediately. MapKit will then call
 * drawMapRect:zoomScale:context:.
 *
 * Returns NO if significant processing (HTTP requests, etc.) must be performed
 * before a tile can be drawn. MapKit will skip over this tile and only
 * attempt to reload this if the tile leaves and re-enters the view. (A reload
 * can be forced by calling setNeedsDisplayInMapRect:zoomScale:)
 */
- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    
    if (downloaded) {
        return YES;
    }
    
    NSUInteger zoomLevel = [self zoomLevelForZoomScale:zoomScale];
    CGPoint mercatorPoint = [self mercatorTileOriginForMapRect:mapRect];
    
    // Hook on TileOverlay that allows an overlay to limit the boundaries it attempts to load.
    if ([(id<TileOverlay>)self.overlay canDrawMapRect:mapRect zoomScale:zoomScale] != YES) {
        return NO;
    }
    
    NSUInteger tilex = floor(mercatorPoint.x * [self worldTileWidthForZoomLevel:zoomLevel]);
    NSUInteger tiley = floor(mercatorPoint.y * [self worldTileWidthForZoomLevel:zoomLevel]);
    
//    NSLog(@"step1 %d,%d,%d,---- %.1f,%.1f", zoomLevel, tilex, tiley, mapRect.origin.x,mapRect.origin.y);
    
//    NSLog(@"%@", [Util getCachePath]);
    NSString *url = [(id<TileOverlay>)self.overlay urlForPointWithX:tilex andY:tiley andZoomLevel:zoomLevel];
    if (![url hasPrefix:@"http"]) {
        return YES;
    }
    
    //    id<TileOverlay> overlay = (id<TileOverlay>)self.overlay;
    //    [overlay setTag:0];
    //    ASIHTTPRequest *req = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    self.metadata = @{
//        @"mr_origin_x" : @(mapRect.origin.x),
//        @"mr_origin_y" : @(mapRect.origin.y),
//        @"mr_size_w" : @(mapRect.size.width),
//        @"mr_size_h" : @(mapRect.size.height),
//        @"zoomScale" : @(zoomScale),
//        @"zoomLevel" : @(zoomLevel),
//        @"tilex" : @(tilex),
//        @"tiley" : @(tiley)
//    };
//    NSDictionary *metaData = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithDouble:mapRect.origin.x], @"mr_origin_x",
//                              [NSNumber numberWithDouble:mapRect.origin.y], @"mr_origin_y",
//                              [NSNumber numberWithDouble:mapRect.size.width], @"mr_size_w",
//                              [NSNumber numberWithDouble:mapRect.size.height], @"mr_size_h",
//                              [NSNumber numberWithFloat:zoomScale], @"zoomScale",
//                              [NSNumber numberWithInt:zoomLevel], @"zoomLevel",
//                              [NSNumber numberWithInt:tilex], @"tilex",
//                              [NSNumber numberWithInt:tiley], @"tiley",
//                              nil];
    
    NSString *savePath = [(id<TileOverlay>)self.overlay imageSavePathWithX:tilex andY:tiley andZoomLevel:zoomLevel];

    [ApplicationDelegate.imageDownloader
                         downloadMapImageFrom:url
                         toFile:savePath
                         onCompletion:^() {
                             downloaded = YES;
                             [self setNeedsDisplayInMapRect:mapRect zoomScale:zoomScale];
//                             [self finishDownload];
                         } onError:^(NSError *error){
                             downloaded = YES;
//                             NSLog(@"%@", error);
//                             if (tiley==0 && tilex != 0) {
//                                 int i=1;
//                             }
                             [self setNeedsDisplayInMapRect:mapRect zoomScale:zoomScale];
//                             [self finishDownload];
                         }];
    
//    [self loadFileFromUrl:[NSURL URLWithString:url] savePath:savePath metadata:metaData];
    return NO;
}

/**
 * If the above method returns YES, this method performs the actual screen render
 * of a particular tile.
 *
 * You should never perform long processing (HTTP requests, etc.) from this method
 * or else your application UI will become blocked. You should make sure that
 * canDrawMapRect ONLY EVER returns YES if you are positive the tile is ready
 * to be rendered.
 */
- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    id<TileOverlay> overlay = (id<TileOverlay>)self.overlay;
    
    NSUInteger zoomLevel = [self zoomLevelForZoomScale:zoomScale];
    CGPoint mercatorPoint = [self mercatorTileOriginForMapRect:mapRect];
    
    NSUInteger tilex = floor(mercatorPoint.x * [self worldTileWidthForZoomLevel:zoomLevel]);
    NSUInteger tiley = floor(mercatorPoint.y * [self worldTileWidthForZoomLevel:zoomLevel]);
//    NSLog(@"draw map %d,%d,%d,---- %.1f,%.1f", zoomLevel, tilex, tiley, mapRect.origin.x,mapRect.origin.y);
    UIGraphicsPushContext(context);

    NSString *mapPath = [overlay urlForPointWithX:tilex andY:tiley andZoomLevel:zoomLevel];
    UIImage *map = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:mapPath]) {
//        NSLog(@"map exist,draw map normal");
        map = [UIImage imageWithContentsOfFile:mapPath];
//        NSLog(@"draw map:%@", mapPath);
//        NSLog(@"draw map for %d,%d,%d", zoomLevel, tilex, tiley);
    } else if ([overlay isKindOfClass:[MapTileOverlay class]]) {
//        NSLog(@"map not exist,need to draw numm map");
        map = [UIImage imageNamed:@"null.jpg"];
//        NSLog(@"draw nil map for %d,%d,%d,%@", zoomLevel, tilex, tiley);
    }
//    map = [UIImage imageNamed:@"null.jpg"];
    if (map != nil) {
        [map drawInRect:[self rectForMapRect:mapRect] blendMode:kCGBlendModeNormal alpha:overlay.defaultAlpha];
    }

    UIGraphicsPopContext();
    downloaded = NO;
}

//#pragma mark -
//#pragma mark Asynconnection Delegate
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    if (request.responseStatusCode != 200) {
//        //        if ([request.url.path hasSuffix:@".jpg"]) {
//        [[NSFileManager defaultManager] removeItemAtPath:request.downloadDestinationPath error:nil];
////        UIImage *img = [UIImage imageNamed:@"null.jpg"];
////        NSData *imgData = UIImageJPEGRepresentation(img, 1);
////        [imgData writeToFile:request.downloadDestinationPath atomically:YES];
////        [img release];
//        //        }
//        return;
//    }
//    
//    NSDictionary *mdata = (NSDictionary *)[request userInfo];
//    NSNumber *mr_origin_x = [mdata objectForKey:@"mr_origin_x"];
//    NSNumber *mr_origin_y = [mdata objectForKey:@"mr_origin_y"];
//    NSNumber *mr_size_w = [mdata objectForKey:@"mr_size_w"];
//    NSNumber *mr_size_h = [mdata objectForKey:@"mr_size_h"];
//    
//    MKMapRect mapRect = MKMapRectMake(
//                                      [mr_origin_x doubleValue],
//                                      [mr_origin_y doubleValue],
//                                      [mr_size_w doubleValue],
//                                      [mr_size_h doubleValue]);
//    NSNumber *zoomScaleNumber = [mdata objectForKey:@"zoomScale"];
//    MKZoomScale zoomScale = [zoomScaleNumber floatValue];
////    NSNumber *zoomLevelNumber = [mdata objectForKey:@"zoomLevel"];
////    NSInteger zoomLevel = [zoomLevelNumber intValue];
////    NSNumber *tx = [mdata objectForKey:@"tilex"];
////    NSInteger tilex = [tx intValue];
////    NSNumber *ty = [mdata objectForKey:@"tiley"];
////    NSInteger tiley = [ty intValue];
//    
////    if ([request.url.path hasSuffix:@".jpg"]) {
////        [self loadSpotMap:zoomLevel tilex:tilex tiley:tiley metadata:mdata];
////    }
//    [self setNeedsDisplayInMapRect:mapRect zoomScale:zoomScale];
//    //    req = nil;
//}

//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//	NSError *error = [request error];
//	NSLog(@"%@", error);
//    //    [req release];
//    //    req = nil;
//}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
//    if (self.netOperation) {
//        [self.netOperation cancel];
//        self.netOperation = nil;
//    }
    [super dealloc];
}


@end
