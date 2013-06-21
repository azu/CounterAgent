//
// Created by azu on 2013/06/21.
// License MIT
//


#import "Kiwi.h"
#import "CounterAgent.h"

@interface CounterAgentStepSpec : KWSpec

@end

@implementation CounterAgentStepSpec

+ (void)buildExampleGroups {
    describe(@"CounterAgentStep", ^{
        __block CounterAgent *counterAgent;
        beforeEach(^{
            counterAgent = [[CounterAgent alloc] init];
        });
        afterAll(^{
            [counterAgent resetCount];
            counterAgent = nil;
        });
        context(@"when ver 1.0", ^{
            beforeEach(^{
                [counterAgent stub:@selector(appVersion) andReturn:@"1.0"];
            });
            it(@"count up: start is 0", ^{
                [counterAgent countUp];
                NSUInteger result = [counterAgent countOfCurrentVersion];
                [[theValue(result) should] equal:theValue(1)];
            });
            context(@"when ver 1.1", ^{
                beforeEach(^{
                    [counterAgent stub:@selector(appVersion) andReturn:@"1.1"];
                });
                it(@"count up: start is 0", ^{
                    [counterAgent countUp];
                    NSUInteger result = [counterAgent countOfCurrentVersion];
                    [[theValue(result) should] equal:theValue(1)];
                });
            });
            context(@"when ver 1.2", ^{
                beforeEach(^{
                    [counterAgent stub:@selector(appVersion) andReturn:@"1.2"];
                });
                it(@"count up: start is 0", ^{
                    [counterAgent countUp];
                    NSUInteger result = [counterAgent countOfCurrentVersion];
                    [[theValue(result) should] equal:theValue(1)];
                });
            });
            it(@"count up from 1", ^{
                [counterAgent countUp];
                NSUInteger result = [counterAgent countOfCurrentVersion];
                [[theValue(result) should] equal:theValue(2)];
            });
        });
    });
}

@end