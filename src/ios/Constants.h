#import <Foundation/Foundation.h>

// Used to specify the Application used in Keychain accessing
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define CREDENTIALS @"__CREDENTIALS__"

@interface Constants : NSObject

@end
