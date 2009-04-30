//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedItem.h"
#import "NewsFeedTableViewCell.h"
#import "NSDate+LighthouseStringHelpers.h"

@interface NewsFeedViewController (Private)

+ (NSArray *)dummyData;

@end

@implementation NewsFeedViewController

@synthesize delegate;

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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tv
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFeedItem * item = [newsItems objectAtIndex:indexPath.row];
    return [NewsFeedTableViewCell heightForContent:item];
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

    cell.newsFeedItem = [newsItems objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate userDidSelectNewsItem:[newsItems objectAtIndex:indexPath.row]];
}

#pragma mark Dummy data

+ (NSArray *)dummyData
{
    NSArray * authors =
        [NSArray arrayWithObjects:
        @"John A. Debay",
        @"John A. Debay",
        @"Doug Kurth",
        @"John A. Debay",
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

    NSArray * titles =
        [NSArray arrayWithObjects:
        @"Code Watch: Add followed users to user info view [#231]",
        @"Changeset [33b9d1aafd6c05920cec8a7bf386a5ec7a56c435] by "
         "John A. Debay",
        @"Code Watch: Add following to user info view [#232]",
        @"Code Watch: App Store Description was posted",
        @"Code Watch: Set background color for modal views [#233]",
        @"[Milestone] Code Watch: 1.1.1",
        @"Code Watch: Set background color for modal views [#233]",
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
        @"changeset",
        @"ticket",
        @"message",
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
        NewsFeedItem * item = [[NewsFeedItem alloc] init];

        [item setValue:[authors objectAtIndex:i] forKey:@"author"];
        [item setValue:[pubDates objectAtIndex:i] forKey:@"published"];
        [item setValue:[titles objectAtIndex:i] forKey:@"title"];
        [item setValue:[entityTypes objectAtIndex:i] forKey:@"type"];

        [items addObject:item];

        [item release];
    }

    return items;
}

@end
