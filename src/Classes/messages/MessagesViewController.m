//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageTableViewCell.h"
#import "Message.h"

@implementation MessagesViewController

@synthesize delegate, sortedKeyCache;

- (void)dealloc {
    [messages release];
    [postedByDict release];
    [projectDict release];
    [numResponsesDict release];
    [sortedKeyCache release];

    [super dealloc];
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [[messages allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"MessageTableViewCell";

    MessageTableViewCell * cell =
        (MessageTableViewCell *)
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }

    LighthouseKey * messageKey = [self.sortedKeys objectAtIndex:indexPath.row];
    Message * message = [messages objectForKey:messageKey];
    [cell setTitleText:message.title];
    [cell setCommentText:message.message];
    [cell setDate:message.postedDate];
    
    NSString * postedByName = [postedByDict objectForKey:messageKey];
    [cell setAuthorName:postedByName];
    
    NSUInteger numResponses =
        [[numResponsesDict objectForKey:messageKey] intValue];
    [cell setNumResponses:numResponses];

    NSString * projectName = [projectDict objectForKey:messageKey];
    [cell setProjectName:projectName];

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LighthouseKey * messageKey = [self.sortedKeys objectAtIndex:indexPath.row];
    [delegate selectedMessageKey:messageKey];
}

#pragma mark UITableViewDelegate implementation

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id messageKey = [self.sortedKeys objectAtIndex:indexPath.row];
    Message * message = [messages objectForKey:messageKey];

    return [MessageTableViewCell heightForTitle:message.title
        comment:message.message];
}

#pragma mark MessagesViewController implementation

- (void)setMessages:(NSDictionary *)someMessages
    postedByDict:(NSDictionary *)aPostedByDict
    projectDict:(NSDictionary *)aProjectDict
    numResponsesDict:(NSDictionary *)aNumResponsesDict
{
    self.sortedKeyCache = nil;

    NSDictionary * tempMessages = [someMessages copy];
    [messages release];
    messages = tempMessages;

    NSDictionary * tempPostedByDict = [aPostedByDict copy];
    [postedByDict release];
    postedByDict = tempPostedByDict;

    NSDictionary * tempProjectDict = [aProjectDict copy];
    [projectDict release];
    projectDict = tempProjectDict;

    NSDictionary * tempNumResponsesDict = [aNumResponsesDict copy];
    [numResponsesDict release];
    numResponsesDict = tempNumResponsesDict;

    [self.tableView reloadData];
}

- (NSArray *)sortedKeys
{
    if (!self.sortedKeyCache)
        self.sortedKeyCache =
            [messages keysSortedByValueUsingSelector:@selector(compare:)];

    return sortedKeyCache;
}

@end

