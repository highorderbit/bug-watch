//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedTableViewCell.h"
#import "NSDate+LighthouseStringHelpers.h"

@interface NewsFeedViewController (Private)

+ (NSArray *)dummyData;

@end

@implementation NewsFeedViewController

- (void)dealloc
{
    [newsItems release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    newsItems = [[[self class] dummyData] retain];
}

/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
*/

/*
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
*/

/*
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];  // Releases the view if it doesn't have a
                                      // superview

    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section
{
    return newsItems.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"NewsFeedTableViewCell";

    NewsFeedTableViewCell * cell = (NewsFeedTableViewCell *)
        [tv dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray * nib =
        [[NSBundle mainBundle]
          loadNibNamed:@"NewsFeedTableViewCell"
                 owner:self
               options:nil];

        cell = [nib objectAtIndex:0];
    }

    [cell updateView:[newsItems objectAtIndex:indexPath.row]];

    return cell;
}

- (void)          tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController =
    //     [[AnotherViewController alloc]
    //      initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)        tableView:(UITableView *)tv
    canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)     tableView:(UITableView *)tv
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView
         deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
               withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the
        // array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)     tableView:(UITableView *)tv
    moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
           toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)        tableView:(UITableView *)tv
    canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark Dummy data

+ (NSArray *)dummyData
{
    NSArray * authors =
        [NSArray arrayWithObjects:
        @"John A. Debay",
        @"John A. Debay",
        @"Doug Kurth",
        @"Doug Kurth",
        @"Doug Kurth",
        @"Doug Kurth",
        @"John A. Debay",
        @"John A. Debay",
        @"Doug Kurth",
        @"John A. Debay",
        nil
        ];

    NSArray * pubDates =
        [NSArray arrayWithObjects:
        [NSDate dateWithLighthouseString:@"2009-04-29T10:22:06-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-29T10:21:54-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-29T10:16:53-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-29T10:16:32-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-29T09:38:58-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-28T23:24:43-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-28T22:30:53-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-28T22:29:56-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-28T22:28:42-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-28T20:59:40-06:00"],
        nil
        ];

    NSArray * bodies =
        [NSArray arrayWithObjects:
        @"Code Watch: Add followed users to user info view [#231]",
        @"Code Watch: Add following to user info view [#232]",
        @"Code Watch: Opening user location in maps doesn't work [#234]",
        @"Code Watch: Set background color for modal views [#233]",
        @"Code Watch: Set background color for modal views [#233]",
        @"[Milestone] Code Watch: 1.1.1",
        @"Code Watch: Make location cell clicks in user info view open maps "
         "[#229]",
        @"Code Watch: Better distinguish private and public repo icons [#235]",
        @"Code Watch: Better distinguish private and public repo icons [#235]",
        @"Code Watch: Opening user location in maps doesn't work [#234]",
        //@"Code Watch: Add privacy icon to repo name cells [#228]",
        //@"Code Watch: Set background color for modal views [#233]",
        //@"Code Watch: Add disclosure indicators to news feed [#225]",
        nil
        ];

    NSArray * entityTypes =
        [NSArray arrayWithObjects:
        @"ticket",
        @"ticket",
        @"ticket",
        @"ticket",
        @"ticket",
        @"milestone",
        @"ticket",
        @"ticket",
        @"ticket",
        @"ticket",
        nil
        ];

    NSMutableArray * items = [NSMutableArray array];
    for (int i = 0; i < authors.count; ++i) {
        NSMutableDictionary * attrs = [[NSMutableDictionary alloc] init];

        [attrs setObject:[authors objectAtIndex:i] forKey:@"author"];
        [attrs setObject:[pubDates objectAtIndex:i] forKey:@"pubDate"];
        [attrs setObject:[bodies objectAtIndex:i] forKey:@"body"];
        [attrs setObject:[entityTypes objectAtIndex:i] forKey:@"entityType"];

        [items addObject:attrs];

        [attrs release];
    }

    return items;
}

@end
