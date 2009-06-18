//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynchronousResponseProcessor.h"
#import "LighthouseApiServiceDelegate.h"

@class TicketDataCollector;

@interface SearchAllTicketsResponseProcessor : AsynchronousResponseProcessor
{
    id projectKey;
    NSString * searchString;
    NSUInteger page;
    id object;
    id<LighthouseApiServiceDelegate> delegate;

    TicketDataCollector * collector;
}

@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, copy, readonly) NSString * searchString;
@property (nonatomic, assign, readonly) NSUInteger page;
@property (nonatomic, retain, readonly) id object;
@property (nonatomic, assign, readonly) id<LighthouseApiServiceDelegate>
    delegate;

+ (id)processorWithSearchString:(NSString *)aSearchString
                           page:(NSUInteger)aPage
                       delegate:(id<LighthouseApiServiceDelegate>)aDelegate;
+ (id)processorWithProjectKey:(id)aProjectKey
                 searchString:(NSString *)aSearchString
                         page:(NSUInteger)aPage
                       object:(id)anObject
                     delegate:(id<LighthouseApiServiceDelegate>)aDelegate;

- (id)initWithSearchString:(NSString *)aSearchString
                      page:(NSUInteger)aPage
                  delegate:(id<LighthouseApiServiceDelegate>)aDelegate;
- (id)initWithProjectKey:(id)aProjectKey
            searchString:(NSString *)aSearchString
                    page:(NSUInteger)aPage
                  object:(id)anObject
                delegate:(id<LighthouseApiServiceDelegate>)aDelegate;

@end
