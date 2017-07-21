#import "AM.h"
#import "Account.h"
#import "Constants.h"
#import "KeychainWrapper.h"
#import "GlobalVars.h"

@interface AM ()

@end

@implementation AM

- (void)clear:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    // delete the account from the keychain
    @try {
    [KeychainWrapper deleteKeyChainObj:CREDENTIALS];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException * e) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;

}

- (void)setToken:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString* token = [command.arguments objectAtIndex:0];

    Account *accountUpdated = [[Account alloc] init];
    accountUpdated.username = @"";
    accountUpdated.password = @"";
    accountUpdated.token = token;

    // add the account to the keychain
    @try {
        BOOL isCreated = [KeychainWrapper createKeychainObj:accountUpdated];
        // if the Credentials obj wasn't already set --> create
        if (isCreated) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            // if the Credentials obj was already set --> update
            BOOL isUpdated = [KeychainWrapper updateKeychainObj:accountUpdated];
            if (isUpdated) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Token not set"];
            }
        }
    }
    @catch (NSException * e) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
    }


    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
}

- (void)getToken:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    // Retrieve token
    @try {
        NSData *accountData = [KeychainWrapper searchKeychainObj:CREDENTIALS];
        NSDictionary *accountDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:accountData];
        NSString *token = [accountDictionary objectForKey:@"token"];
        if (token == nil || [token length] == 0) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Token not found"];
        }
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:token];

    }
    @catch (NSException * e) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
}

- (void)setPassword:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString* password = [command.arguments objectAtIndex:0];

    Account *accountUpdated = [[Account alloc] init];
    accountUpdated.username = @"";
    accountUpdated.password = password;
    accountUpdated.token = @"";

    // add the account to the keychain
    @try {
        BOOL isCreated = [KeychainWrapper createKeychainObj:accountUpdated];
        // if the Credentials obj wasn't already set --> create
        if (isCreated) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            // if the Credentials obj was already set --> update
            BOOL isUpdated = [KeychainWrapper updateKeychainObj:accountUpdated];
            if (isUpdated) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Password not set"];
            }
        }
    }
    @catch (NSException * e) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
}

- (void)getPassword:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    // Retrieve password
    @try {
        NSData *accountData = [KeychainWrapper searchKeychainObj:CREDENTIALS];
        NSDictionary *accountDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:accountData];
        NSString *password = [accountDictionary objectForKey:@"password"];
        if (password == nil || [password length] == 0) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Password not found"];
        }
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:password];

    }
    @catch (NSException * e) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
}

- (void)setUsername:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString* username = [command.arguments objectAtIndex:0];
    
    // create an account object with the username and password values
    Account *account = [[Account alloc] init];
    account.username = username;
    account.password = @"";
    account.token = @"";

    // add the account to the keychain
    @try {
        BOOL isCreated = [KeychainWrapper createKeychainObj:account];
        // if the Credentials obj wasn't already set --> create
        if (isCreated) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            // if the Credentials obj was already set --> update
            BOOL isUpdated = [KeychainWrapper updateKeychainObj:account];
            if (isUpdated) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Username not set"];
            }
        }
    }
    @catch (NSException * e) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
}

- (void)getUsername:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    // Retrieve username
    @try {
        NSData *accountData = [KeychainWrapper searchKeychainObj:CREDENTIALS];
        NSDictionary *accountDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:accountData];
        NSString *username = [accountDictionary objectForKey:@"username"];
        if (username == nil || [username length] == 0) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Username not found"];
        }
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:username];
    }
    @catch (NSException * e) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
}

- (void)enableSharing:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;

    // check args
    NSString* group = [command.arguments objectAtIndex:0];
    if (group == nil || [group length] == 0) {
     pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Group Id can not be null or empty"];
     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
     return;
    }

    NSString* teamId = [command.arguments objectAtIndex:1];
    if (teamId == nil || [teamId length] == 0) {
     pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Team Id can not be null or empty"];
     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
     return;
    }

    GlobalVars *globals = [GlobalVars sharedInstance];
    globals.groupName = group;
    globals.teamId = teamId;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
}

- (void)setPackage:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
}

- (void)getDeviceId:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    @try {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *uuidUserDefaults = [defaults objectForKey:@"uuid"];
        NSString *uuid = [KeychainWrapper getStringForKey:@"uuid"];
        if ( uuid && !uuidUserDefaults ) {
            [defaults setObject:uuid forKey:@"uuid"];
            [defaults synchronize];
        }  else if ( !uuid && !uuidUserDefaults ) {
            NSString *uuidString = [[NSUUID UUID] UUIDString];
            [KeychainWrapper setString:uuidString forKey:@"uuid"];
            [defaults setObject:uuidString forKey:@"uuid"];
            [defaults synchronize];
            uuid = [KeychainWrapper getStringForKey:@"uuid"];
        } else if ( ![uuid isEqualToString:uuidUserDefaults] ) {
            [KeychainWrapper setString:uuidUserDefaults forKey:@"uuid"];
            uuid = [KeychainWrapper getStringForKey:@"uuid"];
        }
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:uuid];
    }
    @catch (NSException * e) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
}


- (void)loginPrompt:(CDVInvokedUrlCommand*)command {
    
    NSString* message = [command argumentAtIndex:0];
    NSString* title = [command argumentAtIndex:1];
    NSArray* buttons = [command argumentAtIndex:2];
    NSString* usernameDefault = [command argumentAtIndex:3];
    BOOL usernameReadonly = [[command argumentAtIndex:4] boolValue];
    
    CDVAlertView* alertView = [[CDVAlertView alloc]
                               initWithTitle:title
                               message:message
                               delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:nil];
    
    alertView.callbackId = command.callbackId;
    
    NSUInteger count = [buttons count];
    
    for (int n = 0; n < count; n++) {
        [alertView addButtonWithTitle:[buttons objectAtIndex:n]];
    }
    
    
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    UITextField* userField = [alertView textFieldAtIndex:0];
    if (usernameDefault.length > 0) {
        [userField setText:usernameDefault];
    }
    userField.placeholder = @"Username";
    [userField setEnabled: !usernameReadonly];
    
    UITextField* pwdField = [alertView textFieldAtIndex:1];
    pwdField.placeholder = @"Password";
    
    
    [alertView show];
}

/**
 * Callback invoked when an alert dialog's buttons are clicked.
 */
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CDVAlertView* cdvAlertView = (CDVAlertView*)alertView;
    CDVPluginResult* result;
    
    // Determine what gets returned to JS based on the alert view type.
    if (alertView.alertViewStyle == UIAlertViewStyleDefault) {
        // For alert and confirm, return button index as int back to JS.
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:(int)(buttonIndex + 1)];
    } else {
        // For prompt, return button index and input text back to JS.
        NSString* username = [[alertView textFieldAtIndex:0] text];
        NSString* password = [[alertView textFieldAtIndex:1] text];
        NSDictionary* info = @{
                               @"buttonIndex":@(buttonIndex + 1),
                               @"username":(username ? username : [NSNull null]),
                               @"password":(password ? password : [NSNull null])
                               };
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
    }
    [self.commandDelegate sendPluginResult:result callbackId:cdvAlertView.callbackId];
}

@end