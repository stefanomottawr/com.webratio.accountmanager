#import <Cordova/CDV.h>

@interface AM : CDVPlugin


- (void)setUsername:(CDVInvokedUrlCommand*)command;

- (void)clear:(CDVInvokedUrlCommand*)command;

- (void)setToken:(CDVInvokedUrlCommand*)command;

- (void)getToken:(CDVInvokedUrlCommand*)command;

- (void)setPassword:(CDVInvokedUrlCommand*)command;

- (void)getPassword:(CDVInvokedUrlCommand*)command;

- (void)enableSharing:(CDVInvokedUrlCommand*)command;

- (void)setPackage:(CDVInvokedUrlCommand*)command;

- (void)getDeviceId:(CDVInvokedUrlCommand*)command;

@end

@interface CDVAlertView : UIAlertView {}

@property (nonatomic, copy) NSString* callbackId;

@end