//
//  TyphoonPointAnnotation.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TyphoonPointAnnotation.h"

@implementation TyphoonPointAnnotation
@synthesize typhoonSpeed;
//@synthesize timeString, typhoonName, typhoonSpeed;
//@synthesize title, subTitle;
//-(id) initWithTyphoonTime:(NSString *)tString typhoonName:(NSString *)tName typhoonSpeed:(float)tSpeed {
//    self = [super init];
//    timeString = [tString retain];
//    typhoonName = [tName retain];
//    typhoonSpeed = tSpeed;
//    return self;
//}
-(id) initWithTitle:(NSString *)ttl subTitle:(NSString *)subTtl {
    self = [super init];
    self.title = ttl;
    self.subtitle = subTtl;
    return self;
}
@end
