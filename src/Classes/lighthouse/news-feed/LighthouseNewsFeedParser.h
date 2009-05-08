//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsFeedItem;

@interface LighthouseNewsFeedParser : NSObject
{
    NewsFeedItem * currentItem;
    NSString * context;
    NSMutableString * value;

    NSMutableArray * feed;
}

- (id)init;

- (NSArray *)parse:(NSData *)xml;

@end
