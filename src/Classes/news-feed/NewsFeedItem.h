//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsFeedItem : NSObject
{
    NSString * identifier;
    NSString * link;
    NSDate * published;
    NSDate * updated;
    NSString * author;
    NSString * title;
    NSString * content;
}

@property (nonatomic, copy, readonly) NSString * identifier;
@property (nonatomic, copy, readonly) NSString * link;
@property (nonatomic, copy, readonly) NSDate * published;
@property (nonatomic, copy, readonly) NSDate * updated;
@property (nonatomic, copy, readonly) NSString * author;
@property (nonatomic, copy, readonly) NSString * title;
@property (nonatomic, copy, readonly) NSString * content;

+ (id)newsItemWithId:(NSString *)anId link:(NSString *)aLink
    published:(NSDate *)aPubDate updated:(NSDate *)anUpdatedDate
    author:(NSString *)anAuthor title:(NSString *)aTitle
    content:(NSString *)aContent;

- (id)initWithId:(NSString *)anId link:(NSString *)aLink
    published:(NSDate *)aPubDate updated:(NSDate *)anUpdatedDate
    author:(NSString *)anAuthor title:(NSString *)aTitle
    content:(NSString *)aContent;

@end
