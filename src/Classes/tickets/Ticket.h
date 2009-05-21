//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ticket : NSObject
{
    NSString * description;
    NSString * message;
    NSDate * creationDate;
}

@property (nonatomic, copy, readonly) NSString * description;
@property (nonatomic, copy, readonly) NSString * message;
@property (nonatomic, copy, readonly) NSDate * creationDate;

- (id)initWithDescription:(NSString *)aDescription message:(NSString*)aMessage
    creationDate:(NSDate *)aCreationDate;

- (NSComparisonResult)compare:(Ticket *)anotherTicket;

@end
