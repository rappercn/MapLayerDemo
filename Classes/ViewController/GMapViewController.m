//
//  GMapViewController.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GMapViewController.h"

#import "OSMTileOverlay.h"
#import "MKMapView+Additions.h"
//#import "CustomOverlayView.h"
#import "MapOverlayView.h"
#import "MapTileOverlay.h"
#import "ShipTileOverlay.h"
//#import "JeppesenTileOverlay.h"
#import "ShipData.h"
#import "ShipDetailViewController.h"
#import "MapRulerView.h"
#import "Util.h"
#import "TyphoonPointAnnotation.h"
#import "TyphoonPointAnnotationView.h"
#import "TyphTipAnnotation.h"
#import "TyphTipAnnotationView.h"
#import "ShipAnnotation.h"
#import "ShipAnnotationView.h"
#import "TyphoonDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@implementation GMapViewController
@synthesize levelData, gmapView;

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
-(void)addShipIconWithData:(NSArray*)shipArray withAnnotationType:(NSInteger)annoType
{
    NSLog(@"shiparray count : %d",[shipArray count]);
//    CLLocationCoordinate2D pt0 = [mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:nil];
//    CLLocationCoordinate2D pt1 = [mapView convertPoint:CGPointMake(mapView.bounds.size.width, mapView.bounds.size.height) toCoordinateFromView:nil];
//    MKMapRect maprect = MKMapRectMake(mapView.frame.origin.x, mapView.frame.origin.y, mapView.frame.size.width, mapView.frame.size.height);
//    MKCoordinateRegion region = MKCoordinateRegionForMapRect(maprect);
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (MKPointAnnotation *anno in gmapView.annotations) {
        if ([anno isKindOfClass:[ShipAnnotation class]]) {
            ShipAnnotation *shipanno = (ShipAnnotation*)anno;
            shipanno.annotationType = annoType;
            if (!shipanno.retainFlag) {
                [tempArray addObject:anno];
            }
//            [shipanno release];
//            if ([anno coordinate].latitude < pt0.latitude || [anno coordinate].longitude < pt0.longitude
//                || [anno coordinate].latitude > pt1.latitude || [anno coordinate].longitude > pt1.longitude) {
//                // out of visiblemapret,remove
//                [removeArray addObject:anno];
//                ShipAnnotation *shipanno = (ShipAnnotation*)anno;
//                [onMapShipIdArray removeObject:[shipanno.shipDic objectForKey:@"shipid"]];
//            }
        }
    }
    if ([tempArray count] > 0) {
        [gmapView removeAnnotations:tempArray];
    }
    [tempArray release];

    tempArray = [[NSMutableArray alloc] init];
//    int count = 0;
    for (NSDictionary *shipDict in shipArray) {
//        count ++;
//        if (count > MAX_SHIP_COUNT) {
//            break;
//        }
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[shipDict objectForKey:@"lat"] floatValue], [[shipDict objectForKey:@"lon"] floatValue]);
        ShipAnnotation *shipanno = [[ShipAnnotation alloc] initWithShipDictionary:shipDict];
        shipanno.coordinate = coord;
        [tempArray addObject:shipanno];
        [shipanno release];
    }
    if ([tempArray count] > 0) {
        [gmapView addAnnotations:tempArray];
    }
    [tempArray release];
    tempArray = nil;
    [[AppDelegate getAppDelegate] showShipCountOnTabbarWith:[shipArray count]];
}
-(void)removeTyphoon {
    for (MKPointAnnotation *anno in gmapView.annotations) {
        if ([anno isKindOfClass:[TyphoonPointAnnotation class]] || [anno isKindOfClass:[TyphTipAnnotation class]]) {
            [gmapView removeAnnotation:anno];
        }
    }
    
    [gmapView removeOverlays:gmapView.overlays];
}
-(void)addTyphoonTip {

    if (zoomLevel < SHOW_TIP_LEVEL) {
        return;
    }
    
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
                [tipAnno release];
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
            [tipAnno release];
            i++;
        }
    }
}
-(void)addTyphoonPoints:(NSArray*)tArray routeTitle:(NSString*)title {
    if (tArray && tArray.count > 1) {
        CLLocationCoordinate2D coordintes[[tArray count]];
        int i = 0;
        for (NSDictionary *tpt in tArray) {
            float lat = [[tpt objectForKey:@"lat"] floatValue];
            float lon = [[tpt objectForKey:@"lon"] floatValue];
            CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake(lat, lon);

            TyphoonPointAnnotation *tAnno = [[TyphoonPointAnnotation alloc] initWithTitle:[tpt objectForKey:@"enName"]
                                                                                 subTitle:[tpt objectForKey:@"typhoonTime"]];
            tAnno.typhoonSpeed = [[tpt objectForKey:@"windSpeed"] floatValue];
            tAnno.coordinate = coord;
            coordintes[i] = coord;
            
            if (i == [tArray count] - 1 && title == PATH_TITLE) {
                TyphTipAnnotation *tipAnno = [[TyphTipAnnotation alloc] initWithTyphoonTime:[tpt objectForKey:@"typhoonTime"] typhoonName:[tpt objectForKey:@"enName"]];
                tipAnno.coordinate = coord;
                [gmapView addAnnotation:tipAnno];
                [tipAnno release];
//                tAnno.typhoonName = [tpt objectForKey:@"enName"];
                float kt34 = [[tpt objectForKey:@"radius34kt"] floatValue];
                float kt50 = [[tpt objectForKey:@"radius50kt"] floatValue];
                float kt64 = [[tpt objectForKey:@"radius64kt"] floatValue];
                if (kt34 > 0) {
                    MKCircle *windRing = [MKCircle circleWithCenterCoordinate:coord radius:kt34 * NM_RATE * 1000];
                    windRing.title = R_34KT;
                    [gmapView addOverlay:windRing];
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
            [tAnno release];
        }
        MKPolyline *line = [MKPolyline polylineWithCoordinates:coordintes count:[tArray count]];
        line.title = title;
        [gmapView addOverlay:line];
    }
}
-(void)drawTyphoon{
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
}
-(void)getTyphoonInfo{
    NSArray* tary = [(NSArray*)[NSUserDefaults standardUserDefaults] valueForKey:@"typids"];
    NSInteger interval = 9999;
    if (tary) {
        NSDate *last = (NSDate*)[[NSUserDefaults standardUserDefaults] valueForKey:@"typids_"];
        interval = [[NSDate date] timeIntervalSinceDate:last];
    }
    if (!tary) {
        [Util getTyphoonsId];
        [[NSUserDefaults standardUserDefaults] setValue:tary forKey:@"typids"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"typids_"];
    } else {
        NSDate *last = (NSDate*)[[NSUserDefaults standardUserDefaults] valueForKey:@"typids_"];
        interval = [[NSDate date] timeIntervalSinceDate:last];
    }
    
    NSString *typFolder = [Util getCachePath:@"typhoon"];
    NSString *pathFile = [typFolder stringByAppendingString:@"/path.plist"];
    NSString *foreFile = [typFolder stringByAppendingString:@"/fore.plist"];
    
    if (interval > 3600) {
        tary = [Util getTyphoonsId];
        if (!tary) {
            //show fail message;
        } else {
            [[NSUserDefaults standardUserDefaults] setValue:tary forKey:@"typids"];
            [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"typids_"];
        }
    } else {
        // read content from file
        if ([[NSFileManager defaultManager] fileExistsAtPath:foreFile]) {
            typForeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:foreFile];
            typPathDic = [[NSMutableDictionary alloc] initWithContentsOfFile:pathFile];
            return;
        }
    }
//    NSLog(@"%@",tary);
    
    [[NSFileManager defaultManager] removeItemAtPath:pathFile error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:foreFile error:nil];
//    [[NSFileManager defaultManager] removeItemAtPath:typFolder error:nil];
//    [[NSFileManager defaultManager] createDirectoryAtPath:typFolder withIntermediateDirectories:NO attributes:nil error:nil];
    [typForeDic release];
    typForeDic = [[NSMutableDictionary alloc] init];
    [typPathDic release];
    typPathDic = [[NSMutableDictionary alloc] init];
    for (NSString *tid in tary) {
        NSArray* tmpAry = [Util getTyphoonLastForecast:tid];
        if (tmpAry) {
            [typForeDic setValue:tmpAry forKey:tid];
        }
        tmpAry = [Util getTyphoonPath:tid];
        if (tmpAry) {
            [typPathDic setValue:tmpAry forKey:tid];
        }
    }
    [typForeDic writeToFile:foreFile atomically:YES];
    [typPathDic writeToFile:pathFile atomically:YES];
}
-(void)segButtonSelected:(id)sender
{
    UISegmentedControl* seg = (UISegmentedControl*) sender;
    if (seg.selectedSegmentIndex == 0) {
        [self removeTyphoon];
        UIActivityIndicatorView *actView = (UIActivityIndicatorView*)self.navigationItem.rightBarButtonItem.customView;
        [actView stopAnimating];
        [actView removeFromSuperview];
//        [actView release];
        self.navigationItem.rightBarButtonItem.customView = nil;
    } else {
        [self getTyphoonInfo];
        [self drawTyphoon];
    }
    NSLog(@"segButtonSelected:%d", seg.selectedSegmentIndex);
}
-(void)showReloadProgress {
    if (self.navigationItem.rightBarButtonItem.customView != nil) {
        return;
    }
    NSLog(@"show progress bar....");
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navigationItem.rightBarButtonItem.customView = actView;
    [actView startAnimating];
    [actView release];
}
-(void)hideReloadProgress {
    NSLog(@"hide progress bar....");
    UIActivityIndicatorView *actView = (UIActivityIndicatorView*)self.navigationItem.rightBarButtonItem.customView;
    [actView stopAnimating];
    [actView removeFromSuperview];
    //        [actView release];
    self.navigationItem.rightBarButtonItem.customView = nil;
}
-(MapRulerView*)reloadMapViewRuler
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
            NSLog(@"level %d, distance %d", i, distance);
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
            ruler = [[MapRulerView alloc] initWithFrame:CGRectMake(10, self.view.bounds.size.height - 30, mySize.width, 20)];
            ruler.tag = kCRulerTag;
        }
        ruler.rulerWidth = mySize.width;
        if (distance >= 1000 * NM_RATE) {
            ruler.mksText = [[NSString alloc] initWithFormat:@"%d海里", distance / 1000];
        } else {
            ruler.mksText = [[NSString alloc] initWithFormat:@"%d米", distance];
        }
        ruler.backgroundColor = [UIColor clearColor];
        CGRect frame = ruler.frame;
        if (frame.size.width != mySize.width) {
            frame.size.width = mySize.width;
            ruler.frame = frame;
        }
        [ruler setNeedsDisplay];
//        [ruler setNeedsDisplay];
        return ruler;
    }
    return nil;
}
-(void)reloadShipMapOverlaysWithShowShip:(BOOL)showship {
//    NSLog(@"--------------");
//    [gmapView removeOverlays:gmapView.overlays];
//    JeppesenTileOverlay *overlay = [[JeppesenTileOverlay alloc] init];
//    overlay.showShipMap = showship;
//    if (currentMap == MAP_CUSTOM) {
//        overlay.showMap = YES;
//    } else {
//        overlay.showMap = NO;
//    }
//    [gmapView addOverlay:overlay];
//    [overlay release];
//    NSLog(@"+++++++++++++++++");
}
-(void)reloadMapViewOverlays
{
    NSString *mapType = [[NSUserDefaults standardUserDefaults] valueForKey:@"mapType"];
    if (mapType == nil) {
        mapType = [[NSString alloc] initWithFormat:@"%d", MAP_CUSTOM];
        [[NSUserDefaults standardUserDefaults] setValue:mapType forKey:@"mapType"];
    }
    if (currentMap == mapType.intValue) {
        return;
    }
    currentMap = mapType.intValue;
    [gmapView removeOverlays:gmapView.overlays];
    UIImageView *logo = [gmapView mapLogo];
    MapRulerView *ruler = (MapRulerView*) [gmapView viewWithTag:kCRulerTag];
    if (ruler != nil) {
        CGRect rulerFrame = ruler.frame;
        rulerFrame.origin.x = -200;
    }
    CGRect frame = logo.frame;
    
    
    
//    JeppesenTileOverlay *overlay = [[JeppesenTileOverlay alloc] init];
//    overlay.showShipMap = YES;
    if (currentMap == MAP_CUSTOM) {
        MapTileOverlay *mapOverlay = [[MapTileOverlay alloc] init];
        [gmapView addOverlay:mapOverlay];
        [mapOverlay release];
//        overlay.showMap = YES;
        MapRulerView *ruler = [self reloadMapViewRuler];
        [gmapView addSubview:ruler];
        [ruler release];
        frame.origin.y = -100;
//    } else if (currentMap == MAP_OSM) {
//        //    // ----- Add our overlay layer to the map
//        OSMTileOverlay *overlay = [[OSMTileOverlay alloc] init];
//        [mapView addOverlay:overlay];
//        [overlay release];
//        UIImage *img = [UIImage imageNamed:@"osmLogo"];
//        [logo setImage:img];
//        frame = CGRectMake(10, self.view.bounds.size.height - 40, 90, 30);
    } else {
//        overlay.showMap = NO;
        UIImage *img = [UIImage imageNamed:@"google"];
        [logo setImage:img];
        frame = CGRectMake(240, self.view.bounds.size.height - 30, 69, 23);
    }
    ShipTileOverlay *shipOverlay = [[ShipTileOverlay alloc] init];
    [gmapView addOverlay:shipOverlay];
    [shipOverlay release];
//    [gmapView addOverlay:overlay];
//    [overlay release];
    logo.frame = frame;
}
//-(void)shipLoaded:(NSArray*)shipArray {
//    
//}
//-(void)startNewRequest {
//    number++;
//    NSLog(@"start new request:%d",number);
//    requesting = YES;
//    ASIHTTPRequest *req = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:taskUrl]];
//    req.delegate = self;
//    req.username=[NSString stringWithFormat:@"%d", number];
//    [req setTimeOutSeconds:30];
//    [req startAsynchronous];
//}
-(void)doNextTaskWithPrevUrl:(NSString*)prevUrl {
    
    if (prevUrl == nil || prevUrl != taskUrl) {
//        NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
//        [self performSelectorOnMainThread:@selector(startNewRequest) withObject:nil waitUntilDone:NO];
//        [p release];

        number++;
        NSLog(@"start new request:%d",number);
        requesting = YES;
        ASIHTTPRequest *req = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:taskUrl]];
        req.delegate = self;
        req.username=[NSString stringWithFormat:@"%d", number];
        [req setTimeOutSeconds:30];
        [req startAsynchronous];
        
    } else {
        taskUrl = nil;
        [self hideReloadProgress];
    }
}
//-(void)addTaskUrl:(NSString*)url {
//    BOOL startRequest = (taskUrl == nil);
//    taskUrl = [url retain];
//    if (startRequest) {
//        [self doNextTaskWithPrevUrl:nil];
////        NSLog(@"request start..........%@", url);
////        reloadReq = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
////        reloadReq.delegate = self;
////        [reloadReq startAsynchronous];
//    }
//}

-(void)showShipInRect {

    [self showReloadProgress];
    CLLocationCoordinate2D pt0 = [gmapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:nil];
    CLLocationCoordinate2D pt1 = [gmapView convertPoint:CGPointMake(gmapView.bounds.size.width, gmapView.bounds.size.height) toCoordinateFromView:nil];

    NSString *urlString = [INTERFACE_URL stringByAppendingFormat:@"checkVehicleDistribution&param_dleft=%f&param_dtop=%f&param_dright=%f&param_dbottom=%f&param_numlimit=99",pt0.longitude, pt0.latitude, pt1.longitude, pt1.latitude];
    
//    BOOL startRequest = (taskUrl == nil);
    taskUrl = [urlString retain];
    if (!requesting) {
        [self doNextTaskWithPrevUrl:nil];
    }

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
    if ([removeArray count] > 0) {
        [gmapView removeAnnotations:removeArray];
    }
    [removeArray release];
    removeArray = nil;
    
    for (id<TileOverlay> overlay in gmapView.overlays) {
        if ([overlay isKindOfClass:[ShipTileOverlay class]]) {
            return;
        }
    }
    ShipTileOverlay *shipOverlay = [[ShipTileOverlay alloc] init];
    [gmapView addOverlay:shipOverlay];
    [shipOverlay release];
}
-(void)reloadAll {


//    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    actView.hidesWhenStopped = YES;
//    [actView sizeToFit];
//    [actView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
////    actView.frame=CGRectMake(-10, 0, 10, 10);
//    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithCustomView:actView];
//    [reloadButton setImage:[UIImage imageNamed:@"reload.png"]];
//    self.navigationItem.rightBarButtonItem = reloadButton;
//    [reloadButton release];
//    [actView startAnimating];
//    [actView release];
    
}
#pragma mark - View Delegate

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(100.0f, 8.0f, 120.0f, 30.0f) ]; 
        [segmentedControl insertSegmentWithTitle:@"船队" atIndex:0 animated:YES];
        [segmentedControl insertSegmentWithTitle:@"关注" atIndex:1 animated:YES]; 
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
        //    segmentedControl.momentary = YES; 
        segmentedControl.multipleTouchEnabled=NO; 
        [segmentedControl addTarget:self action:@selector(segButtonSelected:) forControlEvents:UIControlEventValueChanged];     
        self.navigationItem.titleView = segmentedControl;
        [segmentedControl release]; 
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
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadMapViewOverlays];
    
//    UIImage* image = [goo image];
//    NSData* imagedata = UIImagePNGRepresentation(image);
//    [imagedata writeToFile:[[Util getDocumentPath] stringByAppendingString:@"/google.png"] atomically:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate *delegate = [AppDelegate getAppDelegate];
    if (delegate.showShip) {
        delegate.showShip = NO;
        MKMapRect r = [gmapView visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate(delegate.coord);
        r.origin.x = pt.x - r.size.width * 0.5;
        r.origin.y = pt.y - r.size.height * 0.5;
        [gmapView setVisibleMapRect:r animated:YES];
        
        for (int i = 0; i < [gmapView.annotations count]; i++) {
            id<MKAnnotation> annotation = [gmapView.annotations objectAtIndex:i];
            if ([annotation coordinate].latitude == delegate.coord.latitude && [annotation coordinate].longitude == delegate.coord.longitude) {
                [gmapView selectAnnotation:annotation animated:YES];
                break;
            }
        }
    }
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
	}
    MapOverlayView *overlayView = [[MapOverlayView alloc] initWithOverlay:overlay];
    
    return [overlayView autorelease];
}
- (MKAnnotationView *)mapView:(MKMapView *)m 
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[ShipAnnotation class]]) {
        static NSString *shipAnnoViewId = @"shipAnnoViewId";

//        CLLocationCoordinate2D coo = annotation.coordinate;
//        AppDelegate *delegate = [AppDelegate getAppDelegate];
//        int arrIndex = 0;
//        NSArray *array = delegate.myfav;
//        for (int i = 0; i < array.count; i++) {
//            ShipData *data = [array objectAtIndex:i];
//            if (coo.latitude == data.lat && coo.longitude == data.lon) {
//                arrIndex = i;
//                break;
//            }
//        }
//        ShipData *data = [delegate.myfav objectAtIndex:arrIndex];
        ShipAnnotationView *shipView = (ShipAnnotationView *)[gmapView dequeueReusableAnnotationViewWithIdentifier:shipAnnoViewId];
        if (shipView == nil) {
            shipView = [[[ShipAnnotationView alloc] initWithAnnotation:annotation 
                                                       reuseIdentifier:shipAnnoViewId] autorelease];

        }
//        shipView.arrayIndex = arrIndex;
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
    }
    return nil;
}
- (void)mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    if ([view isKindOfClass:[ShipAnnotationView class]]) {
        ShipAnnotationView *shipView = (ShipAnnotationView*)view;
        int index = shipView.arrayIndex;
        ShipDetailViewController *next = [[ShipDetailViewController alloc] initWithNibName:@"ShipDetailViewController"];
        AppDelegate *delegate = [AppDelegate getAppDelegate];
        NSArray *array = delegate.myfav;
        next.baseData = [array objectAtIndex:index];
        [self.navigationController pushViewController:next animated:YES];
    } else if ([view isKindOfClass:[TyphoonPointAnnotationView class]]) {
        
    }

}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    if (reloadReq) {
//        [reloadReq cancel];
////        [reloadReq release];
////        reloadReq = nil;
//    }
//    NSLog(@"zoomlevel : %f", [mapView getZoomLevel]);
    [self reloadMapViewRuler];
//    [NSThread detachNewThreadSelector:@selector(showShipInRect) toTarget:self withObject:nil];
    
//    NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
//    [self performSelectorOnMainThread:@selector(doPlayVideo) withObject:nil waitUntilDone:NO];
//    [p release];
    if (zoomLevel > 4) {
//        [self showReloadProgress];
        [self showShipInRect];
    } else {
        [self hideShipInRect];
    }
    
//    NSLog(@"regiondidchangeanimated");
}

#pragma mark - ASIHTTPRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    if (request.url.absoluteString != taskUrl) {
        NSLog(@"request finished, still have task.%@",request.username);
        requesting = NO;
        [self doNextTaskWithPrevUrl:request.url.absoluteString];
        return;
    }
    NSLog(@"request finished, should reload overlay.%@",request.username);
    NSString *json = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    if ([json length] > 2) {
//        [self reloadShipMapOverlaysWithShowShip:NO];
        
        for (id<TileOverlay> overlay in gmapView.overlays) {
            if ([overlay isKindOfClass:[ShipTileOverlay class]]) {
//                if ([overlay showShipMap]) {
                    [gmapView removeOverlay:overlay];
//                    [(id<TileOverlay>)overlay setShowShipMap:NO];
//                    [gmapView addOverlay:overlay];
//                }
                break;
            }
        }
        NSDictionary *dic = [json objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
        normalShipArray = [dic objectForKey:@"return"];
        [self addShipIconWithData:normalShipArray withAnnotationType:kCShipTypeNormal];
    } else {
//        [self reloadShipMapOverlaysWithShowShip:YES];
        BOOL exist = NO;
        for (id<TileOverlay> overlay in gmapView.overlays) {
            if ([overlay isKindOfClass:[ShipTileOverlay class]]) {
                exist = YES;
                break;
            }
        }
        if (!exist) {
            ShipTileOverlay *shipOverlay = [[ShipTileOverlay alloc] init];
            [gmapView addOverlay:shipOverlay];
            [shipOverlay release];
        }
        [[AppDelegate getAppDelegate] showShipCountOnTabbarWith:0];
    }
    requesting = NO;
//    taskUrl = nil; 
    [self hideReloadProgress];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    requesting = NO;
	NSError *error = [request error];
    NSLog(@"%@, url:%@", error,request.url.absoluteString);
    taskUrl = nil;
    [self hideReloadProgress];
//    NSLog(@"requestFailed");
//    [self doNextTaskWithPrevUrl:request.url.absoluteString];
}
@end
