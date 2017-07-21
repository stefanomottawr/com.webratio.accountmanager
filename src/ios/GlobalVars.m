#import "GlobalVars.h"

@implementation GlobalVars

@synthesize groupName = _groupName;
@synthesize teamId = _teamId;

+ (GlobalVars *)sharedInstance {
    static dispatch_once_t onceToken;
    static GlobalVars *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalVars alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _groupName = @"NO_SHARE";
        _teamId = @"NO_TEAM_ID";
    }
    return self;
}

@end