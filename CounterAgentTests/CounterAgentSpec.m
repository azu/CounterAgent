//
// Created by azu on 2013/06/21.
// License MIT
//


#import "Kiwi.h"
#import "CounterAgent.h"

@interface CounterAgentSpec : KWSpec
@end


@implementation CounterAgentSpec

void (^when)(NSString *, KWVoidBlock) = ^(NSString *aDescription, KWVoidBlock aBlock) {
    NSString *whenContext = [NSString stringWithFormat:@"when %@", aDescription];
    contextWithCallSite(nil, whenContext, aBlock);
};

+ (void)successCall {
}

+ (void)failCall {
    fail(@"this test case fail");
}

+ (void)buildExampleGroups {
    describe(@"CounterAgent", ^{
        __block CounterAgent *counterAgent;
        beforeEach(^{
            counterAgent = [[CounterAgent alloc] init];
        });

        afterEach(^{
            [counterAgent resetCount];
            counterAgent = nil;
        });
        describe(@"-countOfCurrentVersion", ^{
            context(@"when first time", ^{
                it(@"should return 0", ^{
                    NSUInteger result = [counterAgent countOfCurrentVersion];
                    [[theValue(result) should] equal:theValue(0)];
                });
            });
            context(@"after countUp", ^{
                NSUInteger countUp = 3;
                beforeEach(^{
                    [counterAgent stub:@selector(loadCurrentCount) andReturn:theValue(countUp)];
                });
                it(@"should return number of count", ^{
                    NSUInteger result = [counterAgent countOfCurrentVersion];
                    [[theValue(result) should] equal:theValue(countUp)];
                });
            });
        });
        describe(@"-countUp", ^{
            context(@"when call method", ^{
                NSUInteger currentCount = 0;
                it(@"should call save method", ^{
                    [[counterAgent should] receive:@selector(saveCurrentCount:)];
                    [counterAgent countUp];
                });

                it(@"count up countOfCurrent", ^{
                    [counterAgent countUp];
                    NSUInteger result = [counterAgent countOfCurrentVersion];
                    [[theValue(result) should] equal:theValue(currentCount + 1)];
                });
            });
        });
        describe(@"-runObserver:selector:whenCount:", ^{
            describe(@"when count is 0", ^{
                int currentCount = 0;
                beforeEach(^{
                    [counterAgent stub:@selector(loadCurrentCount) andReturn:theValue(currentCount)];
                });
                it(@"should be call", ^{
                    [[self should] receive:@selector(successCall)];
                    [counterAgent runObserver:self selector:@selector(successCall) whenCount:0];
                });
            });
            describe(@"when count is 10", ^{
                NSUInteger currentCount = 10;
                beforeEach(^{
                    [counterAgent stub:@selector(loadCurrentCount) andReturn:theValue(currentCount)];
                });
                it(@"should be call", ^{
                    [[self should] receive:@selector(successCall)];
                    [counterAgent runObserver:self selector:@selector(successCall) whenCount:currentCount];
                });
            });
            describe(@"when count is over current count", ^{
                NSUInteger currentCount = 0;
                beforeEach(^{
                    [counterAgent stub:@selector(loadCurrentCount) andReturn:theValue(currentCount)];
                });
                it(@"should not called", ^{
                    [counterAgent runObserver:self selector:@selector(failCall) whenCount:currentCount + 1];
                });
            });
            context(@"twice call , when same count ", ^{
                NSUInteger currentCount = 1;
                beforeEach(^{
                    [counterAgent stub:@selector(loadCurrentCount) andReturn:theValue(currentCount)];
                });
                it(@"should be called once", ^{
                    [[self should] receive:@selector(successCall) withCount:1];
                    [counterAgent runObserver:self selector:@selector(successCall) whenCount:currentCount];
                    [counterAgent runObserver:self selector:@selector(successCall) whenCount:currentCount];
                });
            });
        });
    });
}

@end