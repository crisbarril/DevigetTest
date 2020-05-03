
import UIKit

// If we have a MockAppDelegate (i.e. we're running unit tests), use that to avoid executing initialisation code in AppDelegate
let appDelegateClass: AnyClass = NSClassFromString("MockAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
