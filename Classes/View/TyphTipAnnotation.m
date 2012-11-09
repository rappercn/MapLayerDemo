//
//  TyphTipAnnotation.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TyphTipAnnotation.h"

@implementation TyphTipAnnotation
@synthesize timeString, typhoonName;
-(id) initWithTyphoonTime:(NSString *)tString typhoonName:(NSString *)tName {
    self = [super init];
    timeString = [tString retain];
    typhoonName = [tName retain];
    return self;
}
@end
