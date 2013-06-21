# CounterAgent [![Build Status](https://travis-ci.org/azu/CounterAgent.png?branch=master)](https://travis-ci.org/azu/CounterAgent)

Simple Count Manager

## Installation

	pod 'CounterAgent', :podspec => 'https://raw.github.com/azu/CounterAgent/master/CounterAgent.podspec'

## Usage

``` objc
@interface CounterAgent : NSObject
#pragma mark - count
- (NSUInteger)countOfCurrentVersion;
#pragma mark - count up
- (void)countUp;
#pragma mark - fire event when match count
- (void)runObserver:(id) observer selector:(SEL) selector whenCount:(NSUInteger) count;
#pragma mark - reset
- (void)resetCount;
@end
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

# LICENSE

MIT
