#import <Foundation/Foundation.h>

@interface GlobalVars : NSObject
{
    NSString *_groupName;
    NSString *_teamId;
}

+ (GlobalVars *)sharedInstance;

@property(strong, nonatomic, readwrite) NSString *groupName;
@property(strong, nonatomic, readwrite) NSString *teamId;

@end