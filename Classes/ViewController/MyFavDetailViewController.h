//
//  MyFavDetailViewController.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"
#import <Foundation/Foundation.h>
@interface MyFavDetailViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, SectionHeaderViewDelegate,UISearchBarDelegate> {
    
    NSMutableArray* myFav;
//    int openSectionIndex;
    BOOL flag[100];
    SectionHeaderView* sectionArray[100];
    
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *searchResults;
    NSArray *searchType;
}
@property (retain, nonatomic) IBOutlet UITableView *favItemTableView;
//@property (nonatomic, retain) NSMutableArray* myFav;
@property (nonatomic, assign) int openSectionIndex;
@property (nonatomic, retain) NSArray* favArray;
@property (nonatomic,retain) NSString *groupId;


@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, copy) NSMutableArray *searchResults;
@property (nonatomic, retain) NSArray *searchType;

@end
