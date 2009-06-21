//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDiffHelpers.h"

@interface TicketDiffHelpers (Private)

+ (NSString *)findNextValueForKey:(NSNumber *)key inDiffs:(NSArray *)diffs
    fromIndex:(NSUInteger)index;
+ (NSString *)displayNameForAttribute:(NSInteger)ticketAttribute;

@end

@implementation TicketDiffHelpers

+ (NSString *)descriptionFromDiffs:(NSArray *)diffs atIndex:(NSUInteger)index
    withUserNames:(NSDictionary *)userNames
    milestoneNames:(NSDictionary *)milestoneNames
{
    TicketDiff * diff = [diffs objectAtIndex:index];
    NSMutableString * text = [NSMutableString stringWithCapacity:0];

    for (NSNumber * key in [diff allKeys]) {
        id value = [diff objectForKey:key];
        id newValue =
            [[self class]
            findNextValueForKey:key inDiffs:diffs fromIndex:index + 1];

        NSDictionary * displayNameMapping;
        NSInteger keyAsInt = [key intValue];
        switch(keyAsInt) {
            case kTicketAttributeAssignedTo:
                displayNameMapping = userNames;
                break;
            case kTicketAttributeMilestone:
                displayNameMapping = milestoneNames;
                break;
            default:
                displayNameMapping = nil;
        }

        NSString * valueDisplayName =
            displayNameMapping ?
            [displayNameMapping objectForKey:value] : [value description];
        valueDisplayName = valueDisplayName ? valueDisplayName : @"";
        NSString * newValueDisplayName =
            displayNameMapping ?
            [displayNameMapping objectForKey:newValue] : [newValue description];
        newValueDisplayName = newValueDisplayName ? newValueDisplayName : @"";

        NSString * displayNameForAttribute =
            [self displayNameForAttribute:keyAsInt];
        [text appendFormat:@"→ %@ changed from '%@' to '%@'\n",
            displayNameForAttribute, valueDisplayName, newValueDisplayName];
    }

    return text;
}

+ (NSInteger)ticketAttributeFromString:(NSString *)string
{
    TicketAttribute attribute;
    if ([string isEqual:@"state"])
        attribute = kTicketAttributeState;
    else if ([string isEqual:@"assigned_user"])
        attribute = kTicketAttributeAssignedTo;
    else if ([string isEqual:@"milestone"])
        attribute = kTicketAttributeMilestone;
    else if ([string isEqual:@"tag"])
        attribute = kTicketAttributeTags;
    else
        attribute = UNKNOWN_TICKET_ATTRIBUTE;

    return attribute;
}

+ (NSString *)findNextValueForKey:(NSNumber *)key inDiffs:(NSArray *)diffs
    fromIndex:(NSUInteger)index
{
    NSString * nextValue = nil;

    for (int i = index; i < [diffs count] && !nextValue; i++) {
        TicketDiff * diff = [diffs objectAtIndex:i];
        nextValue = [diff objectForKey:key];
    }

    return nextValue ? nextValue : @"";
}

+ (NSString *)displayNameForAttribute:(NSInteger)ticketAttribute
{
    NSString * displayName;

    switch(ticketAttribute) {
        case kTicketAttributeState:
            displayName = @"State";
            break;
        case kTicketAttributeAssignedTo:
            displayName = @"Assigned user";
            break;
        case kTicketAttributeMilestone:
            displayName = @"Milestone";
            break;
        case kTicketAttributeTags:
            displayName = @"Tags";
            break;
        default:
            displayName = @"Unknown attribute";
    }

    return displayName;
}

@end
