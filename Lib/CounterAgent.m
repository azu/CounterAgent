//
// Created by azu on 2013/06/21.
// License MIT
//


#import "CounterAgent.h"


@interface CounterAgent ()
@property(nonatomic, strong) NSMutableArray *executedSelectors;
@end

@implementation CounterAgent {

}

extern const struct CounterAgentAttributes {
    __unsafe_unretained NSString *currentVersion;
    __unsafe_unretained NSString *total;
} CounterAgentAttributes;

const struct CounterAgentAttributes CounterAgentAttributes = {
    .currentVersion = @"CounterAgent.currentVersion",
    .total = @"CounterAgent.total"
};

- (id)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    _executedSelectors = [NSMutableArray array];

    return self;
}


- (NSUInteger)countOfCurrentVersion {
    return [self loadCurrentCount];
}

+ (void)countUp {
    NSUInteger countOfCurrentVersion = [self loadCurrentCount];
    [self saveCurrentCount:countOfCurrentVersion + 1];
}

- (void)countUp {
    NSUInteger countOfCurrentVersion = [self countOfCurrentVersion];
    [self saveCurrentCount:countOfCurrentVersion + 1];
}

- (void)runObserver:(id) observer selector:(SEL) selector whenCount:(NSUInteger) count {
    NSUInteger currentCount = [self countOfCurrentVersion];
    NSString *selectorString = NSStringFromSelector(selector);
    NSString *executedSelectorString = [NSString stringWithFormat:@"%@-%d",
                                                                  selectorString,
                                                                  count];
    if (currentCount == count && ![self.executedSelectors containsObject:executedSelectorString]) {
        [observer performSelectorOnMainThread:selector withObject:nil waitUntilDone:YES];
        [self.executedSelectors addObject:executedSelectorString];
    }
}

- (void)resetCount {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exists = [fileManager fileExistsAtPath:self.saveFilePath];
    NSError *error = nil;
    if (exists) {
        [fileManager removeItemAtPath:self.saveFilePath error:&error];
    }
    if (error != nil) {
        NSLog(@"error = %@", [error localizedDescription]);
    }
}


#pragma mark - private + Class Method
+ (NSUInteger)loadCurrentCount {
    NSDictionary *countDict = [NSKeyedUnarchiver unarchiveObjectWithFile:self.saveFilePath];
    if (countDict == nil) {
        return 0;
    }
    return [countDict[self.appVersion] unsignedIntegerValue];
}

- (NSUInteger)loadCurrentCount {
    return [[self class] loadCurrentCount];
}

+ (void)saveCurrentCount:(NSUInteger) count {
    NSDictionary *countDict = [NSKeyedUnarchiver unarchiveObjectWithFile:self.saveFilePath];
    NSMutableDictionary *mutableDict;
    if (countDict == nil) {
        mutableDict = [NSMutableDictionary dictionary];
    } else {
        mutableDict = [countDict mutableCopy];
    }
    [mutableDict setValue:@(count) forKey:self.appVersion];// count up
    BOOL successful = [NSKeyedArchiver archiveRootObject:mutableDict toFile:self.saveFilePath];
    if (!successful) {
        NSLog(@"fail save %@", self.saveFilePath);
    }
}

- (void)saveCurrentCount:(NSUInteger) count {
    [[self class] saveCurrentCount:count];
}

// current App's version
+ (NSString *)appVersion {
    NSString *version = [[[NSBundle bundleForClass:[self class]] infoDictionary]
        objectForKey:@"CFBundleShortVersionString"];
    return version;
}

- (NSString *)appVersion {
    return [[self class] appVersion];
}

+ (NSString *)saveFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
        NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"counter_agent.dat"];
    return path;
}

- (NSString *)saveFilePath {
    return [[self class] saveFilePath];

}
@end