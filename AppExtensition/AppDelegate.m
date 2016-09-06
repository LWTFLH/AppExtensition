//
//  AppDelegate.m
//  AppExtensition
//
//  Created by 李伟 on 16/9/2.
//  Copyright © 2016年 TFLH. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HomeController.h"
#import "HomeController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeController alloc] init]];
    [self.window makeKeyAndVisible];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openScheme:) name:@"open" object:nil];

    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    NSLog(@"<absoluteString>%@",url.absoluteString);
    NSLog(@"%@",url);
    NSLog(@"%@",url.scheme);
    NSLog(@"%@",url.query);
    NSLog(@"<parameterString>%@",url.parameterString);
    NSLog(@"<host>%@",url.host);
    
    if ([url.host isEqualToString:@"lw"]) {
        self.window.rootViewController = [[HomeController alloc]init];
    }
    
    return  YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
