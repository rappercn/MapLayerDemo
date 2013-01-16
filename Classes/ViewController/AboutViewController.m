//
//  AboutViewController.m
//  BaoChuanWang
//
//  Created by zhengxuan on 1/15/13.
//
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *leftApp = nil;
    NSArray *rightApp = nil;
    if(type == 0){
        //show.text = @"app";
        self.title = @"关于宝船";
        leftApp = [[[NSArray alloc ] initWithObjects:
                             @"版本:",
                             @"联系电话:",
                             @"传真:",
                             @"地址:",
                             @"邮编:",
                             nil] autorelease];
        rightApp = [[[NSArray alloc ] initWithObjects:
                              @"1.3.2.121229",
                              @"010-65293372/3906",
                              @"010-65299466",
                              @"北京朝阳区安外外馆后身一号",
                              @"100011",
                              nil] autorelease];
    }else{
        self.title = @"关于用户";
        leftApp = [[[NSArray alloc ] initWithObjects:
                              @"用户名称:",
                              @"公司名称:",
                              @"注册时间:",
                              nil] autorelease];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        rightApp = [[[NSArray alloc ] initWithObjects:
                               [def objectForKey:@"dispname"],
                               [def objectForKey:@"comname"],
                               [def objectForKey:@"regdate"],
                               nil] autorelease];
    }
    
    for (int i = 0; i < leftApp.count; i++) {
        UILabel *label;
        label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5+i*28 , 103, 21)];
        
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = UITextAlignmentLeft;
        label.text = leftApp[i];
        [label sizeToFit];
        [self.view addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(116, 5+i*28 , 150, 21)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = rightApp[i];
        [label sizeToFit];
        [self.view addSubview:label];
        [label release];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //[show release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setShow:nil];
    [super viewDidUnload];
}
@end
