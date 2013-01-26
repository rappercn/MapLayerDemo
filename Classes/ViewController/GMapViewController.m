//
//  GMapViewController.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GMapViewController.h"
#import "MKMapView+Additions.h"
#import "MapOverlayView.h"
#import "MapTileOverlay.h"
#import "ShipTileOverlay.h"
#import "ShipDetailViewController.h"
#import "MapRulerView.h"
#import "TyphoonPointAnnotation.h"
#import "TyphoonPointAnnotationView.h"
#import "TyphTipAnnotation.h"
#import "TyphTipAnnotationView.h"
#import "ShipAnnotation.h"
#import "ShipAnnotationView.h"
#import "TyphoonDetailViewController.h"
#import "ShipTipAnnotation.h"
#import "ShipTipAnnotationView.h"
#import "ShipNameOverlay.h"
#import "ShipNameOverlayView.h"
#import "MUtil.h"


@implementation GMapViewController
@synthesize gmapView;

static const int kCRulerTag = 10;
#define TILE_RECT 256
#define PATH_TITLE @"path"
#define FORE_TITLE @"fore"
#define NM_RATE 1.852
#define R_34KT @"34kt"
#define R_50KT @"50kt"
#define R_64KT @"64kt"
#define SHOW_TIP_LEVEL 4
#define MAX_SHIP_COUNT 99
-(void)removeShipsFromMapByArray:(NSMutableArray*)removeArray {
    if (removeArray == nil || [removeArray count] == 0) {
        return;
    }
    for (id<MKAnnotation> anno in removeArray) {
        if ([anno isKindOfClass:[ShipAnnotation class]]) {
            if (((ShipAnnotation*)anno).selected) {
                [gmapView deselectAnnotation:anno animated:YES];
            }
        }
    }
//    if (currentShipAnnotation != nil && [removeArray containsObject:currentShipAnnotation]) {
//        [gmapView deselectAnnotation:currentShipAnnotation animated:YES];
//        currentShipAnnotation = nil;
//    }
    [gmapView removeAnnotations:removeArray];
}
-(void)removeAllShipFromMap {
    NSMutableArray *removeArray = [[NSMutableArray alloc] init];
    for (id<MKAnnotation> anno in gmapView.annotations) {
        if ([anno isKindOfClass:[ShipAnnotation class]] || [anno isKindOfClass:[ShipTipAnnotation class]]) {
            [removeArray addObject:anno];
        }
    }
    [self removeShipsFromMapByArray:removeArray];
    RELEASE_SAFELY(removeArray);
}
-(void)addShipNameOverlay {
    ShipNameOverlay *nameOverlay = [[ShipNameOverlay alloc] initWithMapRect:gmapView.visibleMapRect];
    [gmapView addOverlay:nameOverlay];
    RELEASE_SAFELY(nameOverlay);
}
-(void)removeShipNameOverlay {
    for (id<MKOverlay> overlay in gmapView.overlays) {
        if ([overlay isKindOfClass:[ShipNameOverlay class]]) {
            [gmapView removeOverlay:overlay];
            return;
        }
    }
}
-(BOOL)markUsedPosition:(CGPoint)pt {
    int x = pt.x / 10;
    int y = pt.y / 10;
    if (posDict[[NSString stringWithFormat:@"%d-%d", x, y]] != nil) {
        return NO;
    }
    posDict[[NSString stringWithFormat:@"%d-%d", x, y]] = @"1";
    return YES;
}
-(void)markUsedPositionWithArray:(NSArray*)array {
    for (NSMutableDictionary *shipdict in array) {
        CLLocationCoordinate2D coord;
        if (useMap) {
            coord = [mapUtil getFakeCoordinateWithLatitude:[shipdict[@"lat"] floatValue] andLongitude:[shipdict[@"lon"] floatValue]];
        } else {
            coord = CLLocationCoordinate2DMake([shipdict[@"lat"] floatValue], [shipdict[@"lon"] floatValue]);
        }
        CGPoint pt = [gmapView convertCoordinate:coord toPointToView:gmapView];
        [self markUsedPosition:pt];
    }
}

-(CGPoint)getLabelPositionByShipPoint:(CGPoint)shipPt withWidth:(CGFloat)width {
//    static NSInteger viewWidth = gmapView.bounds.size.width;
//    static int viewHeight = gmapView.bounds.size.height;
    CGPoint retPt = CGPointMake(-1, -1);
    CGPoint *points = malloc(sizeof(CGPoint) * 4);
    int w = ((int)(width / 10) * 10);
    points[0] = CGPointMake(shipPt.x - w - 10, shipPt.y - 20);
    points[1] = CGPointMake(shipPt.x + 20, shipPt.y - 20);
    points[2] = CGPointMake(shipPt.x - w - 10, shipPt.y + 10);
    points[3] = CGPointMake(shipPt.x + 20, shipPt.y + 10);
    for (int i = 0; i < 4; i++) {
        if (points[i].x < 0) {
            points[i].x = 0;
        }
        if (points[i].y < 0) {
            points[i].y = 0;
        }
        if (points[i].x > gmapView.bounds.size.width) {
            points[i].x = gmapView.bounds.size.width;
        }
        if (points[i].y > gmapView.bounds.size.height) {
            points[i].y = gmapView.bounds.size.height;
        }
        BOOL useable = YES;
        for (int start = points[i].x / 10; start < (points[i].x + width) / 10; start++) {
//            int x = points[i].x / 10;
            int y = points[i].y / 10;
            if (posDict[[NSString stringWithFormat:@"%d-%d", start, y]] != nil) {
                useable = NO;
                break;
            }
        }
        if (useable) {
            retPt.x = (int)(points[i].x / 10);
            retPt.x *= 10;
            retPt.y = (int)(points[i].y / 10);
            retPt.y *= 10;
            for (int start = points[i].x / 10; start < (points[i].x + width) / 10; start++) {
                int y = points[i].y / 10;
                posDict[[NSString stringWithFormat:@"%d-%d", start, y]] = @"1";
            }
            break;
        }
    }
    free(points);
    return retPt;
}
-(void)addShipNameAtCoordinate:(CLLocationCoordinate2D) coord andText:(NSString*)shipname{
//    CGPoint pt = [gmapView convertCoordinate:coord toPointToView:gmapView];
//    if (!CGRectContainsPoint(gmapView.bounds, pt)) {
//        return;
//    }
//    UILabel *label = [[UILabel alloc] init];
//    label.text = shipname;
//    label.backgroundColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.7];
//    label.font = [UIFont systemFontOfSize:9];
//    label.layer.borderColor = [[UIColor blackColor] CGColor];
//    label.layer.borderWidth = 1.0;
//    label.textAlignment = UITextAlignmentCenter;
//    [label sizeToFit];
//    CGRect frame = label.frame;
//    frame.size.width += 6;
//    CGPoint pos = [self getLabelPositionByShipPoint:pt withWidth:frame.size.width];
//    if (pos.x != -1) {
//        frame.origin = pos;
//        label.frame = frame;
//        [gmapView addSubview:label];
//    }
//    RELEASE_SAFELY(label);
}
-(void)addShipAnnotationWithData:(NSDictionary*)shipdict andType:(NSInteger)annoType select:(BOOL)select  {
    CLLocationCoordinate2D coord;
    if (useMap) {
        coord = [mapUtil getFakeCoordinateWithLatitude:[shipdict[@"lat"] floatValue] andLongitude:[shipdict[@"lon"] floatValue]];
    } else {
        coord = CLLocationCoordinate2DMake([shipdict[@"lat"] floatValue], [shipdict[@"lon"] floatValue]);
    }

    ShipAnnotation *shipanno = [[ShipAnnotation alloc] initWithShipDictionary:shipdict];
    shipanno.annotationType = annoType;
    shipanno.coordinate = coord;
    [gmapView addAnnotation:shipanno];
    if (select) {
        [gmapView selectAnnotation:shipanno animated:YES];
    }
    RELEASE_SAFELY(shipanno);
    // add ship name
    if (!(annoType == kCShipTypeNormal)) {
        [self addShipNameAtCoordinate:coord andText:
         [ApplicationDelegate makeShipNameByCnName:[shipdict objectForKey:@"shipnamecn"]
              engName:[shipdict objectForKey:@"shipname"]
                  imo:[shipdict objectForKey:@"imo"]]];
    }
}
//-(void)addShipTipAnnotationWithData:(NSDictionary*)shipdict andType:(NSInteger)annoType {
// 去掉显示船名 2012.12.16
//    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[shipdict objectForKey:@"lat"] floatValue], [[shipdict objectForKey:@"lon"] floatValue]);
//    NSString *dispName = shipdict[@"shipnamecn"];
//    if (dispName == nil || [dispName isEqualToString:@""]) {
//        dispName = shipdict[@"shipname"];
//    }
//    
//    ShipTipAnnotation *tipanno = [[ShipTipAnnotation alloc] initWithShipId:shipdict[@"shipid"] dispName:dispName annoType:annoType];
//    tipanno.coordinate = coord;
//    [gmapView addAnnotation:tipanno];
//    RELEASE_SAFELY(tipanno);
//}
-(void)addShipIconWithArray:(NSArray*)shipArray withAnnotationType:(NSInteger)annoType showBadge:(BOOL)showBadge
{
    NSMutableArray *removeArray = [[NSMutableArray alloc] init];
    NSMutableArray *existShipidArray = [[NSMutableArray alloc] init];
    for (id<MKAnnotation> anno in gmapView.annotations) {
        if ([anno isKindOfClass:[ShipAnnotation class]]) {
            ShipAnnotation *shipanno = (ShipAnnotation*)anno;
            if (shipanno.annotationType == kCShipTypeMyTeam || shipanno.annotationType == kCShipTypeFollowed) {
                [existShipidArray addObject:shipanno.shipdict[@"shipid"]];
                continue;
            }
            NSArray *shownArray = [shipArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(shipid == %@)", shipanno.shipdict[@"shipid"]]];
            if ([shownArray count] > 0) {
                [existShipidArray addObject:shipanno.shipdict[@"shipid"]];
                continue;
            }
            [removeArray addObject:anno];
            for (id<MKAnnotation> an in gmapView.annotations) {
                if ([an isKindOfClass:[ShipTipAnnotation class]]) {
                    ShipTipAnnotation *tipAnno = (ShipTipAnnotation*)an;
                    if (tipAnno._shipid == shipanno.shipdict[@"shipid"]) {
                        [removeArray addObject:an];
                        break;
                    }
                }
            }
        }
    }

    [self removeShipsFromMapByArray:removeArray];
    RELEASE_SAFELY(removeArray);

    [self markUsedPositionWithArray:shipArray];
    for (NSDictionary *shipdict in shipArray) {
        if ([existShipidArray containsObject:shipdict[@"shipid"]]) {
            continue;
        }
        [self addShipAnnotationWithData:shipdict andType:annoType select:NO];
//        if (!(annoType == kCShipTypeNormal && ![[NSUserDefaults standardUserDefaults] boolForKey:@"showShipName"])) {
        
    }
    RELEASE_SAFELY(existShipidArray)
    if (showBadge) {
        [ApplicationDelegate showShipCountOnTabbarWith:[shipArray count]];
    }
}
-(void)removeTyphoon {
    NSMutableArray *removeArray = [[NSMutableArray alloc] init];
    for (MKPointAnnotation *anno in gmapView.annotations) {
        if ([anno isKindOfClass:[TyphoonPointAnnotation class]] || [anno isKindOfClass:[TyphTipAnnotation class]]) {
            [removeArray addObject:anno];
        }
        
//        if ([anno isKindOfClass:[TyphoonPointAnnotation class]] || [anno isKindOfClass:[TyphTipAnnotation class]]) {
//            [gmapView removeAnnotation:anno];
//        }
    }
    [gmapView removeAnnotations:removeArray];
    RELEASE_SAFELY(removeArray);
    
    removeArray = [[NSMutableArray alloc] init];
    for (id<MKOverlay> overlay in gmapView.overlays) {
        if ([overlay isKindOfClass:[MKCircle class]] || [overlay isKindOfClass:[MKPolygon class]] || [overlay isKindOfClass:[MKPolyline class]]) {
            [removeArray addObject:overlay];
        }
    }
    [gmapView removeOverlays:removeArray];
    RELEASE_SAFELY(removeArray);
}
-(void)addTyphoonTip {

    if (zoomLevel < SHOW_TIP_LEVEL) {
        return;
    }
    if (doingAddTyphoonTip) {
        return;
    }
    doingAddTyphoonTip = YES;
    for (NSString *key in typForeDic.allKeys) {
        NSArray *ary = [typForeDic objectForKey:key];
        int i = 0;
        for (NSDictionary *dic in ary) {
            if (i > 0) {
                TyphTipAnnotation *tipAnno = [[TyphTipAnnotation alloc] initWithTyphoonTime:[dic objectForKey:@"typhoonTime"] typhoonName:nil];
                float lat = [[dic objectForKey:@"lat"] floatValue];
                float lon = [[dic objectForKey:@"lon"] floatValue];
                CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake(lat, lon);
                tipAnno.coordinate = coord;
                [gmapView addAnnotation:tipAnno];
//                [tipAnno release];
            }
            i++;
        }
    }
    
    for (NSString *key in typPathDic.allKeys) {
        NSArray *ary = [typPathDic objectForKey:key];
        int i = 0;
        for (NSDictionary *dic in ary) {
            if (i == [ary count] - 1) {
                break;
            }
            TyphTipAnnotation *tipAnno = [[TyphTipAnnotation alloc] initWithTyphoonTime:[dic objectForKey:@"typhoonTime"] typhoonName:nil];
            float lat = [[dic objectForKey:@"lat"] floatValue];
            float lon = [[dic objectForKey:@"lon"] floatValue];
            CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake(lat, lon);
            tipAnno.coordinate = coord;
            [gmapView addAnnotation:tipAnno];
//            [tipAnno release];
            i++;
        }
    }
    doingAddTyphoonTip = NO;
}
-(void)addTyphoonPoints:(NSArray*)tArray routeTitle:(NSString*)title {
    if (tArray && tArray.count > 1) {
        CLLocationCoordinate2D coordintes[[tArray count]];
        int i = 0;
        float prevLat = 0;
        float prevLon = 0;
        int lineCount = 0;
        for (NSDictionary *tpt in tArray) {
            float lat = [[tpt objectForKey:@"lat"] floatValue];
            float lon = [[tpt objectForKey:@"lon"] floatValue];
            CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake(lat, lon);
            
            // 是否从地图的一边到另一边（经度）
            if (fabs(lon - prevLon) > 180) {
                float latDis = lat - prevLat;
//                float a = lon - prevLon;
//                float b = abs(a);
//                float c = 360.0 - b;
                float lonDis = 360.0 - fabs(lon - prevLon);
                float prevDis = 180.0 - fabs(prevLon);
                float tweenLat = prevDis / lonDis * latDis + prevLat;
                // 生成补间点
                if (prevLon > 0) {
                    CLLocationCoordinate2D tweenPoint = CLLocationCoordinate2DMake(tweenLat, 180.0);
                    coordintes[lineCount] = tweenPoint;
                } else {
                    CLLocationCoordinate2D tweenPoint = CLLocationCoordinate2DMake(tweenLat, -180.0);
                    coordintes[lineCount] = tweenPoint;
                }
                // 因为已跨整个地图，先画线
                MKPolyline *line = [MKPolyline polylineWithCoordinates:coordintes count:lineCount+1];
                line.title = title;
                [gmapView addOverlay:line];
                RELEASE_SAFELY(line);
                
                // 另一侧的补间点作为下次画线的起点
                if (lon > 0) {
                    CLLocationCoordinate2D tweenPoint = CLLocationCoordinate2DMake(tweenLat, 180.0);
                    coordintes[0] = tweenPoint;
                } else {
                    CLLocationCoordinate2D tweenPoint = CLLocationCoordinate2DMake(tweenLat, -180.0);
                    coordintes[0] = tweenPoint;
                }
                lineCount = 1;
            }
            coordintes[lineCount] = coord;
            lineCount ++;
            
            TyphoonPointAnnotation *tAnno = [[TyphoonPointAnnotation alloc] initWithTitle:[tpt objectForKey:@"enName"]
                                                                                 subTitle:[tpt objectForKey:@"typhoonTime"]];
            tAnno.typhoonSpeed = [[tpt objectForKey:@"windSpeed"] floatValue];
            tAnno.coordinate = coord;
//            coordintes[i] = coord;
            
            if (i == [tArray count] - 1 && title == PATH_TITLE) {
                TyphTipAnnotation *tipAnno = [[TyphTipAnnotation alloc] initWithTyphoonTime:[tpt objectForKey:@"typhoonTime"] typhoonName:[tpt objectForKey:@"enName"]];
                tipAnno.coordinate = coord;
                [gmapView addAnnotation:tipAnno];
//                [tipAnno release];
//                tAnno.typhoonName = [tpt objectForKey:@"enName"];
                float kt34 = [[tpt objectForKey:@"radius34kt"] floatValue];
                float kt50 = [[tpt objectForKey:@"radius50kt"] floatValue];
                float kt64 = [[tpt objectForKey:@"radius64kt"] floatValue];
                if (kt34 > 0) {
                    MKCircle *windRing = [MKCircle circleWithCenterCoordinate:coord radius:kt34 * NM_RATE * 1000];
                    windRing.title = R_34KT;
                    [gmapView addOverlay:windRing];
#warning add release sentence
                }
                if (kt50 > 0) {
                    MKCircle *windRing = [MKCircle circleWithCenterCoordinate:coord radius:kt50 * NM_RATE * 1000];
                    windRing.title = R_50KT;
                    [gmapView addOverlay:windRing];
                }
                if (kt64 > 0) {
                    MKCircle *windRing = [MKCircle circleWithCenterCoordinate:coord radius:kt64 * NM_RATE * 1000];
                    windRing.title = R_64KT;
                    [gmapView addOverlay:windRing];
                }
            }
            i++;
            [gmapView addAnnotation:tAnno];
            prevLon = lon;
            prevLat = lat;
//            [tAnno release];
        }
        MKPolyline *line = [MKPolyline polylineWithCoordinates:coordintes count:lineCount];
        line.title = title;
        [gmapView addOverlay:line];
//        RELEASE_SAFELY(line);
    }
}
-(void)drawTyphoon{
//    if (typForeDic.count == typPathDic.count) {
        for (NSString* key in typForeDic.allKeys) {
            NSArray* tmpAry = [typForeDic objectForKey:key];
            if (tmpAry) {
                [self addTyphoonPoints:tmpAry routeTitle:FORE_TITLE];
            }
        }
        for (NSString* key in typPathDic.allKeys) {
            NSArray* tmpAry = [typPathDic objectForKey:key];
            if (tmpAry) {
                [self addTyphoonPoints:tmpAry routeTitle:PATH_TITLE];
            }
        }
        [self addTyphoonTip];
//    }
}
-(void)getTyphoonInfo{

    NSInteger interval = 9999;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"typids_"] != nil) {
        NSDate *last = (NSDate*)[[NSUserDefaults standardUserDefaults] valueForKey:@"typids_"];
        interval = [[NSDate date] timeIntervalSinceDate:last];
    }
    
    NSString *typFolder = [Util getCachePath:@"typhoon"];
    NSString *pathFile = [typFolder stringByAppendingString:@"/path.plist"];
    NSString *foreFile = [typFolder stringByAppendingString:@"/fore.plist"];
    
    if (interval > 300) {
        [[NSFileManager defaultManager] removeItemAtPath:pathFile error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:foreFile error:nil];
        [Util getTyphoonsIdOnComp:^(NSObject *responseData) {
            NSArray *idArray = (NSArray*)responseData;
            if (idArray) {
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                [def setValue:nil forKey:@"typids"];
                [def setValue:[NSDate date] forKey:@"typids_"];
                [def synchronize];
                
                if (typForeDic) {
                    RELEASE_SAFELY(typForeDic);
                }
                typForeDic = [[NSMutableDictionary alloc] init];
                if (typPathDic) {
                    RELEASE_SAFELY(typPathDic);
                }
                typPathDic = [[[NSMutableDictionary alloc] init] retain];
                NSLog(@"idarray:%d",idArray.count);
                for (NSString *tid in idArray) {
                    [Util getTyphoonLastForecastById:tid onComp:^(NSObject *responseData) {
                        [typForeDic setValue:responseData forKey:tid];
                        NSLog(@"typForeDic:%d",typForeDic.count);
                        NSLog(@"typhoon forecast : %@", tid);
                        if ([typForeDic count] == [idArray count]) {
                            [typForeDic writeToFile:foreFile atomically:YES];
                            [self drawTyphoon];
                        }
                    }];
                    [Util getTyphoonPathById:tid onComp:^(NSObject *responseData) {
                        [typPathDic setValue:responseData forKey:tid];
                        NSLog(@"typForeDic:%d",typForeDic.count);
                        NSLog(@"typhoon path : %@", tid);
                        if ([typPathDic count] == [idArray count]) {
                            [typPathDic writeToFile:pathFile atomically:YES];
                            [self drawTyphoon];
                        }
                    }];
                }
            }
        }];
    } else {
        // read content from file
        if ([[NSFileManager defaultManager] fileExistsAtPath:foreFile]) {
            typForeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:foreFile];
            typPathDic = [[NSMutableDictionary alloc] initWithContentsOfFile:pathFile];
            [self drawTyphoon];
//            return;
        }
    }
}
-(void)segButtonSelected:(id)sender
{
    [self removeAllShipFromMap];
    UISegmentedControl* seg = (UISegmentedControl*) sender;
    showtype = seg.selectedSegmentIndex;
    if (seg.selectedSegmentIndex == 0) {
        ApplicationDelegate.shipRedBorder = YES;
        [self addShipIconWithArray:ApplicationDelegate.myShipsTeam withAnnotationType:kCShipTypeMyTeam showBadge:NO];
    } else if(seg.selectedSegmentIndex == 1) {
        ApplicationDelegate.shipRedBorder = YES;
        [self addShipIconWithArray:ApplicationDelegate.myFocusShips withAnnotationType:kCShipTypeMyTeam showBadge:NO];
    }else if(seg.selectedSegmentIndex == 2) {
        ApplicationDelegate.shipRedBorder = NO;
        [self addShipIconWithArray:normalShipArray withAnnotationType:kCShipTypeMyTeam showBadge:NO];
    }
}
-(void)showReloadProgress {
    if (self.navigationItem.rightBarButtonItem.customView != nil) {
        return;
    }
//    NSLog(@"show progress bar....");
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navigationItem.rightBarButtonItem.customView = actView;
    [actView startAnimating];
    RELEASE_SAFELY(actView);
}
-(void)hideReloadProgress {
//    NSLog(@"hide progress bar....");
    UIActivityIndicatorView *actView = (UIActivityIndicatorView*)self.navigationItem.rightBarButtonItem.customView;
    [actView stopAnimating];
    [actView removeFromSuperview];
    //        [actView release];
    self.navigationItem.rightBarButtonItem.customView = nil;
}
-(void)reloadMapViewRuler
{
    CGSize mySize = CGSizeMake(0, 0);
//    int level = -1;
    int distance = 0;
    for (int i = 0; i < meterArray.count; i++) {
        NSString *meter = [meterArray objectAtIndex:i];
        distance = [meter intValue];
        MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance(gmapView.centerCoordinate, distance * NM_RATE, distance * NM_RATE);
        CGRect myRect = [gmapView convertRegion:rgn toRectToView: nil];
        if (myRect.size.width > 50 && myRect.size.width < 90) {
            mySize = myRect.size;
//            level = i;
//            NSLog(@"level %d, distance %d", i, distance);
            break;
        }
    }
    double level = [gmapView getZoomLevel];
    if (level > -1) {
        if (zoomLevel >= SHOW_TIP_LEVEL && level < SHOW_TIP_LEVEL) {
            for (MKPointAnnotation *anno in gmapView.annotations) {
                if ([anno isKindOfClass:[TyphTipAnnotation class]]) {
                    TyphTipAnnotation *an = (TyphTipAnnotation*)anno;
                    if (an.typhoonName == nil) {
                        [gmapView removeAnnotation:anno];
                    }
                }
            }
        } else if (zoomLevel < SHOW_TIP_LEVEL && level >= SHOW_TIP_LEVEL) {
            zoomLevel = level;
            [self addTyphoonTip];
        }
        zoomLevel = level;
    }

    
    if (mySize.width > 0) {
        MapRulerView *ruler = (MapRulerView*) [gmapView viewWithTag:kCRulerTag];
        if (ruler == nil) {
            ruler = [[MapRulerView alloc] initWithFrame:CGRectMake(10, self.view.bounds.size.height - 50, mySize.width, 20)];
            ruler.tag = kCRulerTag;
            [gmapView addSubview:ruler];
            RELEASE_SAFELY(ruler);
        }
        ruler.rulerWidth = mySize.width;
        if (distance >= 1000 * NM_RATE) {
            ruler.mksText = [NSString stringWithFormat:@"%d海里", distance / 1000];
        } else {
            ruler.mksText = [NSString stringWithFormat:@"%d米", distance];
        }
        ruler.backgroundColor = [UIColor clearColor];
        CGRect frame = ruler.frame;
        if (frame.size.width != mySize.width) {
            frame.size.width = mySize.width;
            ruler.frame = frame;
        }
        [ruler setNeedsDisplay];
    }
}
//-(void)reloadShipMapOverlaysWithShowShip:(BOOL)showship {
////    NSLog(@"--------------");
////    [gmapView removeOverlays:gmapView.overlays];
////    JeppesenTileOverlay *overlay = [[JeppesenTileOverlay alloc] init];
////    overlay.showShipMap = showship;
////    if (currentMap == MAP_CUSTOM) {
////        overlay.showMap = YES;
////    } else {
////        overlay.showMap = NO;
////    }
////    [gmapView addOverlay:overlay];
////    [overlay release];
////    NSLog(@"+++++++++++++++++");
//}
-(void)reloadMapViewOverlays
{
//    NSString *mapType = [[NSUserDefaults standardUserDefaults] valueForKey:@"mapType"];
//    if (mapType == nil) {
//        mapType = [[NSString alloc] initWithFormat:@"%d", MAP_CUSTOM];
//        [[NSUserDefaults standardUserDefaults] setValue:mapType forKey:@"mapType"];
//    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (useMap == [def boolForKey:@"useMap"] && showTyphoon == [def boolForKey:@"showTyphoon"]) {
        return;
    }
    
//    useMap = [def boolForKey:@"useMap"];
//    showTyphoon = [def boolForKey:@"showTyphoon"];
    
    if (useMap != [def boolForKey:@"useMap"]) {
        for (id<MKOverlay> overlay in gmapView.overlays) {
            // 仅移除地图和船位图层
            if ([overlay isKindOfClass:[ShipTileOverlay class]] || [overlay isKindOfClass:[MapTileOverlay class]]) {
                [gmapView removeOverlay:overlay];
            }
        }
//        [gmapView removeOverlays:gmapView.overlays];
        useMap = [def boolForKey:@"useMap"];
        if (useMap) {
            MapTileOverlay *mapOverlay = [[MapTileOverlay alloc] init];
            [gmapView addOverlay:mapOverlay];
            RELEASE_SAFELY(mapOverlay);
        }
        ShipTileOverlay *shipOverlay = [[ShipTileOverlay alloc] init];
        [gmapView addOverlay:shipOverlay];
        RELEASE_SAFELY(shipOverlay);
        // 重新绘制船舶
        [self segButtonSelected:segmentedControl];
    }
//    [gmapView removeOverlays:gmapView.overlays];
//    NSLog(@"remove all overlays");

    MapRulerView *ruler = (MapRulerView*) [gmapView viewWithTag:kCRulerTag];
    if (ruler != nil) {
        CGRect rulerFrame = ruler.frame;
        rulerFrame.origin.x = -200;
    } else {
        [self reloadMapViewRuler];
    }

    NSLog(@"ship overlay added at reloadmapviewoverlays......");

    if (showTyphoon != [def boolForKey:@"showTyphoon"]) {
        showTyphoon = [def boolForKey:@"showTyphoon"];
        if (showTyphoon) {
            [self getTyphoonInfo];
        } else {
            [self removeTyphoon];
        }
    }

    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
        UIImageView *logo = [gmapView mapLogo];
        if (!useMap) {
            logo.frame = CGRectMake(240.0, 340, 69, 23);
        } else {
            logo.frame = CGRectMake(-240.0, 340, 69, 23);
        }
    }
}
-(void)showShipInRect {

    [self showReloadProgress];
    CLLocationCoordinate2D pt0 = [gmapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:gmapView];
    // 按照地图实际高度计算后总有误差（多取了若干），所以此处在高度上乘以一个系数

    double w = gmapView.frame.size.width;
    double h = gmapView.frame.size.height;
    CLLocationCoordinate2D pt1 = [gmapView convertPoint:CGPointMake(w, h) toCoordinateFromView:gmapView];

//    NSLog(@"%f, %f",pt0.latitude, pt0.longitude);
//    NSLog(@"%f, %f",pt1.latitude, pt1.longitude);
    
//    CGPoint ppp = [gmapView convertCoordinate:pt0 toPointToView:gmapView];
//    NSLog(@"%f, %f",ppp.x, ppp.y);
//    ppp = [gmapView convertCoordinate:pt1 toPointToView:gmapView];
//    NSLog(@"%f, %f",ppp.x, ppp.y);
    
    if (useMap) {
        pt0 = [mapUtil getRealCoordinateWithLatitude:pt0.latitude andLongitude:pt0.longitude];
        pt1 = [mapUtil getRealCoordinateWithLatitude:pt1.latitude andLongitude:pt1.longitude];
    }
//    NSLog(@"%f, %f",pt0.latitude, pt0.longitude);
//    NSLog(@"%f, %f",pt1.latitude, pt1.longitude);
    
    
    NSString *urlString = [INTERFACE_URL stringByAppendingFormat:@"checkVehicleDistributionRet&param_dleft=%f&param_dtop=%f&param_dright=%f&param_dbottom=%f&param_numlimit=499",pt0.longitude, pt0.latitude, pt1.longitude, pt1.latitude];
    
//    BOOL startRequest = (taskUrl == nil);
//    taskUrl = [urlString retain];
//    if (!requesting) {
//        [self doNextTaskWithPrevUrl:nil];
//    }

#warning comment the op cancel action
//    if (requesting) {
//        [mkNetOp cancel];
//    }
//    requesting = YES;
    mkNetOp = [ApplicationDelegate.apiEngine requestDataFrom:urlString onCompletion:^(NSObject *responseData) {
        if ([(NSArray*)responseData count] > 0) {
            
            for (id<TileOverlay> overlay in gmapView.overlays) {
                if ([overlay isKindOfClass:[ShipTileOverlay class]]) {
                    [gmapView removeOverlay:overlay];
//                    NSLog(@"remove overlay.........");
                    break;
                }
            }
            RELEASE_SAFELY(normalShipArray);
            normalShipArray = [(NSArray*)responseData retain];
            [self addShipIconWithArray:normalShipArray withAnnotationType:kCShipTypeNormal showBadge:YES];
        } else {
            //        [self reloadShipMapOverlaysWithShowShip:YES];
            [self removeAllShipFromMap];
            BOOL exist = NO;
            for (id<TileOverlay> overlay in gmapView.overlays) {
                if ([overlay isKindOfClass:[ShipTileOverlay class]]) {
                    exist = YES;
                    break;
                }
            }
            if (!exist) {
//                NSLog(@"add overlay--------------");
                ShipTileOverlay *shipOverlay = [[ShipTileOverlay alloc] init];
                [gmapView addOverlay:shipOverlay];
                [shipOverlay release];
            }
            [ApplicationDelegate showShipCountOnTabbarWith:0];
        }
//        requesting = NO;
        [self hideReloadProgress];
    } onError:^(NSError *error) {
//        requesting = NO;
//        taskUrl = nil;
        [self hideReloadProgress];
    }];
}
-(void)hideShipInRect {
    NSMutableArray *removeArray = [[NSMutableArray alloc] init];
    for (MKPointAnnotation *anno in gmapView.annotations) {
        if ([anno isKindOfClass:[ShipAnnotation class]]) {
            if ([(ShipAnnotation*)anno annotationType] == kCShipTypeNormal) {
                [removeArray addObject:anno];
            }
        }
    }
    [self removeShipsFromMapByArray:removeArray];
    RELEASE_SAFELY(removeArray);
    
    for (id<TileOverlay> overlay in gmapView.overlays) {
        if ([overlay isKindOfClass:[ShipTileOverlay class]]) {
            return;
        }
    }
    ShipTileOverlay *shipOverlay = [[ShipTileOverlay alloc] init];
    [gmapView addOverlay:shipOverlay];
    [shipOverlay release];
    NSLog(@"ship overlay added.....");
}
-(void)reloadAll {
    if (zoomLevel > 8) {
        if (showtype == 2) {
            [self showShipInRect];
        }
    } else {
        if (showtype == 2) {
            [self hideShipInRect];
        }
    }    
}

#pragma mark - View Delegate
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(100.0f, 8.0f, 180.0f, 30.0f) ];
        [segmentedControl insertSegmentWithTitle:@"船队" atIndex:0 animated:YES];
        [segmentedControl insertSegmentWithTitle:@"关注" atIndex:1 animated:YES];
        [segmentedControl insertSegmentWithTitle:@"全部" atIndex:2 animated:YES];
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
        //    segmentedControl.momentary = YES; 
        segmentedControl.multipleTouchEnabled=NO; 
        [segmentedControl addTarget:self action:@selector(segButtonSelected:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = segmentedControl;
//        [segmentedControl release]; 
        self.title = @"海图";
        self.tabBarItem.image = [UIImage imageNamed:@"earthLogo"];
        
        UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload.png"] style:UIBarButtonItemStylePlain target:self action:@selector(reloadAll)];
        self.navigationItem.rightBarButtonItem = reloadButton;
        [reloadButton release];
    }
    
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [gmapView setDelegate:self];
    mapUtil = [[MUtil alloc] init];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    useMap = ![def boolForKey:@"useMap"];
    showTyphoon = ![def boolForKey:@"showTyphoon"];
    showShipName = [def boolForKey:@"showShipName"];
    
    meterArray = [[NSArray arrayWithObjects:
                  @"5000000", @"2000000", @"1000000", @"500000",
                  @"200000", @"100000", @"100000", @"50000",
                  @"20000", @"10000", @"5000", @"2000",
                  @"1000", @"500", @"200", @"100",
                  @"100", @"50", nil] retain];
    feetArray = [NSArray arrayWithObjects:
                 @"", @"", @"", @"",
                 @"", @"", @"", @"",
                 @"", @"", @"", @"",
                 @"", @"", @"", @"",
                 @"", @"", @"", @"",
                 nil];
    
    double clon = [def doubleForKey:@"centerLongitude"];
    double clat = [def doubleForKey:@"centerLatitude"];
    double latd = [def doubleForKey:@"latitudeDelta"];
    double lond = [def doubleForKey:@"longitudeDelta"];
    if (latd + lond != 0) {
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(clat, clon);
        MKCoordinateSpan span = MKCoordinateSpanMake(latd, lond);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        gmapView.region = region;
    }
    segmentedControl.selectedSegmentIndex = 0;
    [self segButtonSelected:segmentedControl];
    posDict = [[NSMutableDictionary alloc] init];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadMapViewOverlays];
//    AppDelegate *delegate = [AppDelegate getAppDelegate];
    NSDictionary *ship = ApplicationDelegate.seletedShip;
    if (ship != nil) {
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([ship[@"lat"] doubleValue], [ship[@"lon"] doubleValue]);
        MKMapRect r = [gmapView visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate(coor);
        r.origin.x = pt.x - r.size.width * 0.5;
        r.origin.y = pt.y - r.size.height * 0.5;
        [gmapView setVisibleMapRect:r animated:YES];
        
        ShipAnnotation *anno = nil;
        for (int i = 0; i < [gmapView.annotations count]; i++) {
            id<MKAnnotation> annotation = [gmapView.annotations objectAtIndex:i];
            if ([annotation isKindOfClass:[ShipAnnotation class]]) {
                NSDictionary *dict = [(ShipAnnotation*)annotation shipdict];
                if ([dict[@"shipid"] isEqualToString: ship[@"shipid"]]) {
                    anno = (ShipAnnotation*)annotation;
                    break;
                }
            }
        }
        
        if (anno == nil) {
            [self addShipAnnotationWithData:ship andType:kCShipTypeFocus select:YES];
//            anno = [[ShipAnnotation alloc] initWithShipDictionary:ship];
//            anno.coordinate = coor;
//            [self.gmapView addAnnotation:anno];
        }
        
        ApplicationDelegate.seletedShip = nil;
    }

//    gmapView.layer.backgroundColor =[UIColor blueColor].CGColor;
//    gmapView.layer.cornerRadius =20.0;
//    gmapView.layer.frame = CGRectMake(0, 0, 100, 100);// CGRectInset(gmapView.layer.frame, 20, 20);
    
//    CALayer *sublayer = [CALayer layer];
//    sublayer.backgroundColor = [UIColor blueColor].CGColor;
//    sublayer.shadowOffset = CGSizeMake(0, 3);
//    sublayer.shadowRadius = 5.0;
//    sublayer.shadowColor = [UIColor blackColor].CGColor;
//    sublayer.shadowOpacity = 0.8;
//    sublayer.frame = CGRectMake(30, 30, 128, 192);
//    [gmapView.layer addSublayer:sublayer];
}
-(void)viewWillDisappear:(BOOL)animated
{
    MKCoordinateRegion region = gmapView.region;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setDouble:region.center.longitude forKey:@"centerLongitude"];
    [ud setDouble:region.center.latitude forKey:@"centerLatitude"];
    [ud setDouble:region.span.latitudeDelta forKey:@"latitudeDelta"];
    [ud setDouble:region.span.longitudeDelta forKey:@"longitudeDelta"];
    [ud synchronize];
}
-(void)dealloc {
    [super dealloc];
    RELEASE_SAFELY(mkNetOp);
    RELEASE_SAFELY(segmentedControl);
    RELEASE_SAFELY(normalShipArray);
    RELEASE_SAFELY(posDict);
}

#pragma mark - MKMapView Delegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    // If using *several* MKOverlays simultaneously, you could test against the class
    // and return a different MKOverlayView as the handler for that overlay layer type.
    
    // CustomOverlayView handles both TileOverlay types in this demo.
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonView *aView = [[[MKPolygonView alloc] initWithPolygon:(MKPolygon *)overlay] autorelease];
        aView.fillColor=[[UIColor redColor] colorWithAlphaComponent:0.2];
        aView.strokeColor=[[UIColor yellowColor] colorWithAlphaComponent:0.7];
        aView.lineWidth=1;
        return aView;
    } else if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *line = (MKPolyline*)overlay;
        MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:line] autorelease];
        if (line.title == PATH_TITLE) {
            polylineView.strokeColor = [UIColor blueColor];
        } else {
            polylineView.strokeColor = [UIColor orangeColor];
        }
//        polylineView.strokeColor = [UIColor greenColor];
        polylineView.lineWidth = 2.0;
        
        return polylineView;
    } else if([overlay isKindOfClass:[MKCircle class]]) {
		// Create the view for the radius overlay.
        MKCircle *circle = (MKCircle*)overlay;
		MKCircleView *circleView = [[[MKCircleView alloc] initWithOverlay:circle] autorelease];
        UIColor *color;
        if (circle.title == R_34KT) {
            color = [UIColor blueColor];
        } else if (circle.title == R_50KT) {
            color = [UIColor greenColor];
        } else if (circle.title == R_64KT) {
            color = [UIColor redColor];
        }
        circleView.strokeColor = color;
        circleView.fillColor = [color colorWithAlphaComponent:0.1];
        circleView.lineWidth = 1;
		
		return circleView;		
	} else if ([overlay isKindOfClass:[ShipNameOverlay class]]) {
        MKMapPoint *points = malloc(sizeof(MKMapPoint) * gmapView.annotations.count);
        for (int i = 0; i < gmapView.annotations.count; i++) {
            CLLocationCoordinate2D coord = ((MKPointAnnotation*)[gmapView.annotations objectAtIndex:i]).coordinate;
            points[i] = MKMapPointForCoordinate(coord);
        }
//        ShipPoint *ships = malloc(sizeof(ShipPoint) * gmapView.annotations.count);
//        for (int i = 0; i < gmapView.annotations.count; i++) {
//            ships[i].coordinate = ((MKPointAnnotation*)[gmapView.annotations objectAtIndex:i]).coordinate;
////            ships[i].viewPoint = [gmapView convertCoordinate:ships[i].coordinate toPointToView:gmapView];
//        }
        ShipNameOverlayView *nview = [[[ShipNameOverlayView alloc] initWithAnnotations:gmapView.annotations andOverlay:overlay] autorelease];
        return nview;
    }
    MapOverlayView *overlayView = [[MapOverlayView alloc] initWithOverlay:overlay];
    
    return [overlayView autorelease];
}
- (MKAnnotationView *)mapView:(MKMapView *)m 
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[ShipAnnotation class]]) {
        static NSString *shipAnnoViewId = @"shipAnnoViewId";
        ShipAnnotationView *shipView = (ShipAnnotationView *)[gmapView dequeueReusableAnnotationViewWithIdentifier:shipAnnoViewId];
        if (shipView == nil) {
            shipView = [[[ShipAnnotationView alloc] initWithAnnotation:annotation 
                                                       reuseIdentifier:shipAnnoViewId] autorelease];
        }
        shipView.enabled = YES;
        shipView.canShowCallout = YES;
        shipView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return shipView;
    } else if ([annotation isKindOfClass:[TyphoonPointAnnotation class]]) {
        static NSString *typAnnoViewId = @"typAnnoViewId";
        TyphoonPointAnnotationView *anView = (TyphoonPointAnnotationView *)[gmapView dequeueReusableAnnotationViewWithIdentifier:typAnnoViewId];
        if (anView == nil) {
            anView = [[[TyphoonPointAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:typAnnoViewId] autorelease];
        }
        anView.enabled = YES;
        anView.canShowCallout = YES;
        anView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        anView.annotation = annotation;
        return anView;
    } else if ([annotation isKindOfClass:[TyphTipAnnotation class]]) {
        static NSString *tipAnnoViewId = @"tipAnnoViewId";
        TyphTipAnnotationView *tipView = (TyphTipAnnotationView *)[gmapView dequeueReusableAnnotationViewWithIdentifier:tipAnnoViewId];
        if (tipView == nil) {
            tipView = [[[TyphTipAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:tipAnnoViewId] autorelease];
        }
        tipView.enabled = YES;
        tipView.canShowCallout = NO;
        tipView.annotation = annotation;
        return tipView;
    } else if ([annotation isKindOfClass:[ShipTipAnnotation class]]) {
        static NSString *shipTipAnnoViewId = @"shipTipAnnoViewId";
        ShipTipAnnotationView *tipView = (ShipTipAnnotationView *)[gmapView dequeueReusableAnnotationViewWithIdentifier:shipTipAnnoViewId];
        if (tipView == nil) {
            tipView = [[[ShipTipAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:shipTipAnnoViewId] autorelease];
        }
        tipView.enabled = YES;
        tipView.canShowCallout = NO;
        tipView.annotation = annotation;
        return tipView;
    }
    return nil;
}
- (void)mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    if ([view isKindOfClass:[ShipAnnotationView class]]) {
        ShipDetailViewController *next = [[ShipDetailViewController alloc] initWithNibName:@"ShipDetailViewController"];
        next.shipdict = ((ShipAnnotation*)view.annotation).shipdict;
        [self.navigationController pushViewController:next animated:YES];
    } else if ([view isKindOfClass:[TyphoonPointAnnotationView class]]) {
        
    }

}
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self removeShipNameOverlay];
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self reloadMapViewRuler];
    [self reloadAll];
    [self addShipNameOverlay];
//    UILabel *label = [[UILabel alloc] init];
//    label.text = @"hello";
//    [label sizeToFit];
//    [gmapView addSubview:label];
//    RELEASE_SAFELY(label);
}
@end
