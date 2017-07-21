#import "KeychainWrapper.h"
#import "Constants.h"
#import "GlobalVars.h"


@implementation KeychainWrapper

+ (BOOL)createKeychainObj:(Account *)account {

    NSDictionary *accountValues = [[NSDictionary alloc] initWithObjectsAndKeys:account.username, @"username", account.password, @"password", account.token, @"token", nil];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accountValues];
    NSMutableDictionary *dictionary = [self setupSearchDirectoryForIdentifier:CREDENTIALS];
    [dictionary setObject:data forKey:(__bridge id)kSecValueData];
    [dictionary setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];

    // Add
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);

    // If the addition was successful, return YES.  Otherwise quit (return NO)
    if (status == errSecSuccess) {
        return YES;
    } else {
        return NO;
    }

}

+ (BOOL)updateKeychainObj:(Account *)account {

    // Set dictionary preferences
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:CREDENTIALS];

    NSData *accountData = [self searchKeychainObj:CREDENTIALS];
    NSDictionary *accountDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:accountData];
    NSString *username = [accountDictionary objectForKey:@"username"];
    NSString *password = [accountDictionary objectForKey:@"password"];
    NSString *token = [accountDictionary objectForKey:@"token"];
    // set Username
    if(account.username != (id)[NSNull null]){
        if ([account.username compare: @""] != NSOrderedSame) {
            username = account.username;
        }
    } else {
        username = nil;
    }
    //set Password
    if(account.password != (id)[NSNull null]){
        if ([account.password compare: @""] != NSOrderedSame) {
            password = account.password;
        }
    } else {
        password = nil;
    }
    // set Token
    if(account.token != (id)[NSNull null]){
        if ([account.token compare: @""] != NSOrderedSame) {
            token = account.token;
        }
    } else {
        token = nil;
    }
    // Set data
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *accountValues = [[NSDictionary alloc] initWithObjectsAndKeys: username, @"username", password, @"password", token, @"token", nil];
    NSData *dataUpdate = [NSKeyedArchiver archivedDataWithRootObject:accountValues];
    [updateDictionary setObject:dataUpdate forKey:(__bridge id)kSecValueData];

    // Update
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary, (__bridge CFDictionaryRef)updateDictionary);

    // If the update was successful, return YES.  Otherwise quit (return NO)
    if (status == errSecSuccess) {
        return YES;
    } else {
        return NO;
    }

}

+ (void)deleteKeyChainObj:(NSString *)username {

    // Set dictionary preferences
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:CREDENTIALS];
    CFDictionaryRef dictionary = (__bridge CFDictionaryRef)searchDictionary;

    // Delete
    SecItemDelete(dictionary);
}

+ (NSMutableDictionary *)setupSearchDirectoryForIdentifier:(NSString *)identifier {

    // Setup dictionary to access keychain
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];

    // Specify we are using a Password (vs Certificate, Internet Password, etc)
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

    // Uniquely identify this keychain accesser
    GlobalVars *globals = [GlobalVars sharedInstance];
    if ([globals.groupName compare: @"NO_SHARE"] != NSOrderedSame) {
        // if the application shares the keychain with others
        [searchDictionary setObject:globals.teamId forKey:(__bridge id)kSecAttrService];
        NSString * groupIdentifier = [[globals.teamId stringByAppendingString:@"."] stringByAppendingString:globals.groupName];
        [searchDictionary setObject:groupIdentifier forKey:(__bridge id)kSecAttrAccessGroup];
    } else {
        // if the application does not share the keychain
        [searchDictionary setObject:APP_NAME forKey:(__bridge id)kSecAttrService];
    }

    // Uniquely identify the account who will be accessing the keychain
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];

    return searchDictionary;
}

+ (NSData *)searchKeychainObj:(NSString *)identifier {

    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:identifier];
    // Limit search results to one
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];

    // Specify we want NSData/CFData returned
    [searchDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];

    // Search
    NSData *result = nil;
    CFTypeRef foundDict = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &foundDict);

    if (status == noErr) {
        result = (__bridge_transfer NSData *)foundDict;
    } else {
        result = nil;
    }

    return result;
}


+ (NSString *)getStringForKey:(NSString *)key
{
    NSData *data = [self searchKeychainObj:key];
    if (data) {
      NSDictionary *dictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
      return [dictionary objectForKey:@"value"];
    }
    return nil;    
}


+ (BOOL)setString:(NSString *)value forKey:(NSString *)key
{
    NSDictionary *dataValues = [[NSDictionary alloc] initWithObjectsAndKeys:value, @"value", nil];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataValues];
    NSMutableDictionary *dictionary = [self setupSearchDirectoryForIdentifier:key];
    [dictionary setObject:data forKey:(__bridge id)kSecValueData];
    [dictionary setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];

    // Add
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);

    // If the addition was successful, return YES.  Otherwise quit (return NO)
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;   
}


@end