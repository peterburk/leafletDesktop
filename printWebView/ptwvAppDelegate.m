//
//  ptwvAppDelegate.m
//  Leaflet Desktop
//
//  Created by Peter Burkimsher on 06/07/2014.
//

#import "ptwvAppDelegate.h"
#import <Cocoa/Cocoa.h>
#import <AppKit/NSAccessibility.h>
#import <Carbon/Carbon.h>

@implementation ptwvAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;



/*
 *
 *
 *
 *
 *
 * * * * * * * * * * * Peter's code begins here * * * * * * * * * *
 *
 *
 *
 *
 *
 */

/*
 * applicationDidFinishLaunching: This runs when the application initialises
 * Starts the process by loading the HTML page into the frame. 
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    // Hide the application's windows so it doesn't distract the user.
    // Hide it from the dock using Info.plist > UIElement > YES
    [[NSRunningApplication currentApplication] hide];
    
    // Load the HTML file representing our desktop. This file is stored inside the app bundle.
    NSString* appPath = [[NSBundle mainBundle] bundlePath];
    NSString* webURL = [[NSString alloc] initWithFormat:@"file://%@/Contents/Resources/desktop.html", appPath];
    // Open the file
    
    // NSLog(webURL);
    
    [[_yourWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:webURL]]];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame*)frame
{
//    NSLog(@"webview loaded");    
    
    // When the page is "loaded", move the old desktop.
    // This also delays the page-to-image capture slightly, which is necessary to ensure that the map is fully loaded. 
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(moveOldDesktop) userInfo:nil repeats:NO];
    
    // [self printWebView];
    
}

/*
 * moveOldDesktop: Deletes the previous DesktopOld.png file, and renames Desktop.png to DesktopOld.png. 
 */
-(void)moveOldDesktop
{
    // Save the desktop pictures inside the app. That way it's not a hard-coded path.
    NSString* appPath = [[NSBundle mainBundle] bundlePath];
    NSString* oldPath = [[NSString alloc] initWithFormat:@"%@/Contents/Resources/Desktop.png", appPath];
    NSString* newPath = [[NSString alloc] initWithFormat:@"%@/Contents/Resources/DesktopOld.png", appPath];
    
    // Delete the DesktopOld.png file (the new path of the current desktop)
    [[NSFileManager defaultManager] removeItemAtPath:newPath error:nil];
    
    // Rename the current desktop picture to DesktopOld.
    [[NSFileManager defaultManager] movePath:oldPath toPath:newPath handler:nil];
    
    // Set the desktop picture to the DesktopOld file.
    // This is necessary to stop the screen flashing white when changing desktop.
    [self setOldDesktop];
}

/*
 * setOldDesktop: Sets the desktop picture to the DesktopOld.png file.
 */
-(void)setOldDesktop
{
    // Find the DesktopOld file
    NSString* appPath = [[NSBundle mainBundle] bundlePath];
    NSString* filePath = [[NSString alloc] initWithFormat:@"%@/Contents/Resources/DesktopOld.png", appPath];
    
    // Set the desktop picture (workspace screen image)
    NSWorkspace *sws = [NSWorkspace sharedWorkspace];
    
    // Load the image as a URL
    NSURL *image = [NSURL fileURLWithPath:filePath];
    
    // Catch errors
    NSError *err = nil;
    
    // For every screen
    for (NSScreen *screen in [NSScreen screens])
    {
        // Get the previous desktop image
        NSDictionary *opt = [sws desktopImageOptionsForScreen:screen];
        
        // Set the new desktop image
        [sws setDesktopImageURL:image forScreen:screen options:opt error:&err];
        
        // If there's an error, log it.
        if (err) {
            NSLog(@"%@",[err localizedDescription]);
        }else{
            //            NSNumber *scr = [[screen deviceDescription] objectForKey:@"NSScreenNumber"];
        }
    }
    
    // Capture a new desktop picture through our web view
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(imageWebView) userInfo:nil repeats:NO];
}

/*
 * imageWebView: Loads a web page and saves it as an image.
 */
- (void)imageWebView
{
    // The image that we will save
    NSBitmapImageRep *imageRep = [_yourWebView
                                  bitmapImageRepForCachingDisplayInRect:[_yourWebView frame]];
    // Save the image as a bitmap
    [_yourWebView cacheDisplayInRect:[_yourWebView frame] toBitmapImageRep:imageRep];
    
    // Set the image format to PNG
    NSData *data = [imageRep representationUsingType: NSPNGFileType properties: nil];
    
    // Set the destination path
    NSString* appPath = [[NSBundle mainBundle] bundlePath];
    NSString* filePath = [[NSString alloc] initWithFormat:@"%@/Contents/Resources/Desktop.png", appPath];
    
    // Save the image to the path
    [data writeToFile:filePath atomically: NO];
    
    // Set the new desktop picture to that image
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setNewDesktop) userInfo:nil repeats:NO];
}

/*
 * setNewDesktop: Sets the desktop picture to Desktop.png.
 */
-(void)setNewDesktop
{
    // The path of the Desktop.png file
    NSString* appPath = [[NSBundle mainBundle] bundlePath];
    NSString* filePath = [[NSString alloc] initWithFormat:@"%@/Contents/Resources/Desktop.png", appPath];
    
    // Set the desktop picture (workspace screen image)
    NSWorkspace *sws = [NSWorkspace sharedWorkspace];
    
    // Load the image as a URL
    NSURL *image = [NSURL fileURLWithPath:filePath];
    
    // Catch errors
    NSError *err = nil;
    
    // For every screen
    for (NSScreen *screen in [NSScreen screens])
    {
        // Get the previous desktop image
        NSDictionary *opt = [sws desktopImageOptionsForScreen:screen];
        
        // Set the new desktop image
        [sws setDesktopImageURL:image forScreen:screen options:opt error:&err];
        
        // If there's an error, log it.
        if (err) {
            NSLog(@"%@",[err localizedDescription]);
        }else{
            //            NSNumber *scr = [[screen deviceDescription] objectForKey:@"NSScreenNumber"];
        }
    }
    
    // Quit the app
    [self quit];
    
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(quit) userInfo:nil repeats:NO];
}

/*
 * quit: Quits the app.
 */
- (void)quit
{
    // Quit the app
    [[NSApplication sharedApplication] terminate:0];
}

/*
 * printWebView: Prints a web page to PDF. Deprecated.
 */
- (void)printWebView
{
    NSPrintInfo *printInfo = [NSPrintInfo sharedPrintInfo];
    
    // This is your chance to modify printInfo if you need to change
    // the page orientation, margins, etc
    
    NSPrintInfo *sharedInfo;
    NSPrintOperation *printOp;
    NSMutableDictionary *printInfoDict;
    NSMutableDictionary *sharedDict;
    
    sharedInfo = [NSPrintInfo sharedPrintInfo];
    sharedDict = [sharedInfo dictionary];
    printInfoDict = [NSMutableDictionary dictionaryWithDictionary:
                     sharedDict];
    [printInfoDict setObject:NSPrintSaveJob
                      forKey:NSPrintJobDisposition];
    [printInfoDict setObject:@"/Users/peter/Desktop/Print/travels.pdf" forKey:NSPrintSavePath];
    
    
    printInfo = [[NSPrintInfo alloc] initWithDictionary: printInfoDict];
    [printInfo setOrientation:NSLandscapeOrientation];
    [printInfo setTopMargin:0.0];
    [printInfo setBottomMargin:0.0];
    [printInfo setLeftMargin:0.0];
    [printInfo setRightMargin:0.0];
    [printInfo setHorizontalPagination:NSFitPagination];
    [printInfo setVerticalPagination:NSFitPagination];
    
    printOp = [_yourWebView.mainFrame.frameView
               printOperationWithPrintInfo:printInfo];
    
    
    [printOp setShowPanels:NO];
    [printOp runOperation];
}




/*
 * 
 *
 *
 *
 *
 * * * * * * * * * * * Everything from this point on is just Apple's auto-generated code * * * * * * * * * * 
 * 
 * 
 *
 *
 *
 */



// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "peterburk.printWebView" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"peterburk.printWebView"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"printWebView" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"printWebView.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
