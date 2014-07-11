//
//  ptwvAppDelegate.h
//  printWebView
//
//  Created by Peter Burkimsher on 06/07/2014.
//  Copyright (c) 2014 Peter Burkimsher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface ptwvAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;
@property (weak) IBOutlet WebView *yourWebView;

@end
