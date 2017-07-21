#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import "Account.h"


@interface KeychainWrapper : NSObject


+ (NSData *)searchKeychainObj:(NSString *)username;

+ (void)deleteKeyChainObj:(NSString *)username;

+ (BOOL)createKeychainObj:(Account *)account;

+ (BOOL)updateKeychainObj:(Account *)account;

+ (NSString *)getStringForKey:(NSString *)key;

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key;

@end