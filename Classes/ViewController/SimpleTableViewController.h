//
//  SimpleTableViewController.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SimpleTableViewController : UITableViewController
{
    int  idx[3];
}

@property (nonatomic, retain) NSArray *dataSource;

@end
