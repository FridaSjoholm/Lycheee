//
//  AppDelegate.h
//  Spotify-app
//
//  Created by Frida Sjoholm on 1/17/17.
//  Copyright © 2017 Frida Sjoholm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <SafariServices/SafariServices.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SPTAudioStreamingDelegate>
@property (strong, nonatomic) UIWindow *window;


@end

