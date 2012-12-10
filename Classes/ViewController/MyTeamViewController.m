//
//  mycompSecondViewController.m
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyTeamViewController.h"
//#import "ShipData.h"
#import "ShipDetailViewController.h"
#import "SectionHeaderView.h"
//#import "MyFavDetailViewController.h"

@implementation MyTeamViewController
@synthesize shipListTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的船队";//NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"myteamLogo"];
        
//        UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload.png"] style:UIBarButtonItemStylePlain target:self action:@selector(reloadAll)];
//        self.navigationItem.rightBarButtonItem = searchButton;
//        RELEASE_SAFELY(searchButton);
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [ApplicationDelegate displayHUD:self words:@"正在读取"];
    shipListTableView.delegate = self;
    openSectionIndex = NSNotFound;
    NSString *operid = ApplicationDelegate.opeid;
    groupDetail = [[NSMutableDictionary alloc] init];
    sectionHeaders = [[NSMutableDictionary alloc] init];
//    prevSectionIndex = NSNotFound;
    [Util getCompanyGroups:operid onComp:^(NSObject *responseData) {
        if (responseData != nil) {
            NSDictionary *dic = ((NSArray*)responseData)[0];
            groupArray = [[NSArray alloc] initWithObjects:dic, nil];
        } else {
            groupArray = [[NSArray alloc] init];
        }
        [ApplicationDelegate dismissHUD];
        [shipListTableView reloadData];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark- TableView DataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [groupArray count];
//    return [myFav count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (flag[section]) {
        NSArray *tempArray = groupDetail[[@"section" stringByAppendingFormat:@"%d", section]];
        if (tempArray == nil) {
            return 0;
        } else {
            return [tempArray count];
        }
//        return [[teamArray objectAtIndex:section] count];
//        return myFav.count;
    } else {
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = groupDetail[[@"section" stringByAppendingFormat:@"%d", indexPath.section]][indexPath.row];
    for (NSDictionary *shipdict in ApplicationDelegate.myShipsTeam) {
        if ([shipdict[@"shipid"] isEqualToString:dic[@"shipid"]]) {
            ShipDetailViewController *next = [[ShipDetailViewController alloc] initWithNibName:@"ShipDetailViewController" bundle:nil];
            next.shipdict = shipdict;
            [self.navigationController pushViewController:next animated:YES];
            RELEASE_SAFELY(next);
            break;
        }
    }
////    ShipDetailViewController *next = [[ShipDetailViewController alloc] initWithNibName:@"ShipDetailViewController" bundle:nil];
////    next.baseData = [myFav objectAtIndex:indexPath.row];
//    MyFavDetailViewController *next = [[MyFavDetailViewController alloc] initWithNibName:@"MyFavDetailViewController" bundle:nil];
//    next.favArray = [teamArray objectAtIndex:indexPath.section];
//    next.openSectionIndex = indexPath.row;
//    next.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
//    next.groupId = [[[teamArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"groupId"];
//    [self.navigationController pushViewController:next animated:YES];
//    
//    [next release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionTableIdntifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionTableIdntifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionTableIdntifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBg.png"]]];
//        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBg_on.png"]]];
    }
    NSDictionary *dic = groupDetail[[@"section" stringByAppendingFormat:@"%d", indexPath.section]][indexPath.row];
    NSString *title = dic[@"shipcnname"];
    if (title == nil) {
        title = dic[@"shipname"];
    }
    cell.textLabel.text = [@"    " stringByAppendingString: title];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (sectionArray[section] == nil) {

    if (sectionHeaders[[@"section" stringByAppendingFormat:@"%d", section]] == nil) {
        sectionHeaders[[@"section" stringByAppendingFormat:@"%d", section]] =
            [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, shipListTableView.bounds.size.width, 42)
                                                    title:groupArray[section][@"groupname"]
                                                    forSection:section
                                                    delegate:self
                                                    openStatus:flag[section]];
    }
    
    return sectionHeaders[[@"section" stringByAppendingFormat:@"%d", section]];
//        sectionArray[section] = header;
//    }
//    return sectionArray[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 42;
}
#pragma mark - SectionHeaderView Delegate and methods
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    flag[section] = NO;
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [self.shipListTableView numberOfRowsInSection:section];
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [self.shipListTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
//    NSLog(@"section header closed : delete %d rows from section %d", countOfRowsToDelete, section);
    openSectionIndex = NSNotFound;

}
-(void)reloadTableViewFromSection:(NSInteger) section andHeaderView:(SectionHeaderView*)sectionHeader {
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [groupDetail[[@"section" stringByAppendingFormat:@"%d", section]] count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }

    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    if (openSectionIndex != NSNotFound) {
		flag[openSectionIndex] = NO;
        [sectionHeaders[[@"section" stringByAppendingFormat:@"%d", openSectionIndex]] toggleAction:NO];
        NSInteger countOfRowsToDelete = [groupDetail[[@"section" stringByAppendingFormat:@"%d", openSectionIndex]] count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:openSectionIndex]];
        }
        
    }
    
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (openSectionIndex == NSNotFound || section < openSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    //    NSLog(@"section header opened : insert %d rows into section %d", countOfRowsToInsert, section);
    // Apply the updates.
    [shipListTableView beginUpdates];
    [shipListTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [shipListTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [shipListTableView endUpdates];
    openSectionIndex = section;
//    prevSectionIndex = section;
    RELEASE_SAFELY(indexPathsToInsert);
    RELEASE_SAFELY(indexPathsToDelete);
}
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	flag[section] = YES;

    if (groupDetail[[@"section" stringByAppendingFormat:@"%d", section]] == nil) {
        [ApplicationDelegate displayHUD:self words:@"正在读取"];
        [Util getMobilesInfoWithOperId:ApplicationDelegate.opeid groupId:groupArray[section][@"groupid"] onComp:^(NSObject *responseData) {
            if (responseData != nil) {
                groupDetail[[@"section" stringByAppendingFormat:@"%d", section]] = responseData;
            } else {
                groupDetail[[@"section" stringByAppendingFormat:@"%d", section]] = [[NSArray alloc] init];
            }
            [ApplicationDelegate dismissHUD];
            [self reloadTableViewFromSection:section andHeaderView:sectionHeaderView];
        }];
    } else {
        [self reloadTableViewFromSection:section andHeaderView:sectionHeaderView];
    }
}
@end
