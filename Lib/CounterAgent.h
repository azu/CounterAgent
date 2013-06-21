//
// Created by azu on 2013/06/21.
// License MIT
//


#import <Foundation/Foundation.h>


@interface CounterAgent : NSObject
#pragma mark - count
- (NSUInteger)countOfCurrentVersion;
#pragma mark - count up
- (void)countUp;
#pragma mark - fire event
- (void)runObserver:(id) observer selector:(SEL) selector whenCount:(NSUInteger) count;
#pragma mark - reset
- (void)resetCount;
@end