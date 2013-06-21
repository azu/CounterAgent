//
// Created by azu on 2013/06/21.
// License MIT
//


#import "CounterAgent.h"


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


- (NSUInteger)countOfCurrentVersion {
    return [self loadCurrentCount];
}

- (void)countUp {
    NSUInteger countOfCurrentVersion = [self countOfCurrentVersion];
    [self saveCurrentCount:countOfCurrentVersion + 1];
}

- (void)runObserver:(id) observer selector:(SEL) selector whenCount:(NSUInteger) count {
    NSUInteger currentCount = [self countOfCurrentVersion];
    if (currentCount == count) {
        [observer performSelectorOnMainThread:selector withObject:nil waitUntilDone:YES];
    }
}

- (void)resetCount {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exists = [fileManager fileExistsAtPath:self.saveFilePath];
    NSError *error = nil;
    if (exists == YES) {
        [fileManager removeItemAtPath:self.saveFilePath error:&error];
    }
    if (error != nil) {
        NSLog(@"error = %@", [error localizedDescription]);
    }
}


#pragma mark - private
- (NSUInteger)loadCurrentCount {
    NSDictionary *countDict = [NSKeyedUnarchiver unarchiveObjectWithFile:self.saveFilePath];
    if (countDict == nil) {
        return 0;
    }
    return [countDict[self.appVersion] unsignedIntegerValue];
}

- (void)saveCurrentCount:(NSUInteger) count {
    NSDictionary *countDict = [NSKeyedUnarchiver unarchiveObjectWithFile:self.saveFilePath];
    NSMutableDictionary *mutableDict;
    if (countDict == nil) {
        mutableDict = [NSMutableDictionary dictionary];
    }else{
        mutableDict = [countDict mutableCopy];
    }
    [mutableDict setValue:@(count) forKey:self.appVersion];// count up
    BOOL successful = [NSKeyedArchiver archiveRootObject:mutableDict toFile:self.saveFilePath];
    if (successful == NO) {
        NSLog(@"fail save %@", self.saveFilePath);
    }
}


// current app's version
- (NSString *)appVersion {
    NSString *version = [[[NSBundle bundleForClass:[self class]] infoDictionary]
        objectForKey:@"CFBundleShortVersionString"];

    return version;
}

- (NSString *)saveFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
        NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"counter_agent.dat"];
    return path;
}
@end