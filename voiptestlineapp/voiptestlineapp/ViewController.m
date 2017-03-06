//
//  ViewController.m
//  voiptestlineapp
//
//  Created by Aleksandr Smirnov on 06.03.17.
//  Copyright © 2017 Line App. All rights reserved.
//

#import "ViewController.h"
#import <PushKit/PushKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <PKPushRegistryDelegate, AVAudioRecorderDelegate>
{
    PKPushRegistry *_pushRegistry;
//    AVAudioSession *_session;
//    AVAudioRecorder *_audioRecorder;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    _pushRegistry.delegate = self;
    _pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
//    // retrieve avaudiosession instance
//    _session = [AVAudioSession sharedInstance];
//    // set category
//    NSError *errRet;
//    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    [_session setActive:YES error:&errRet];
//    
//    
//    NSArray *dirPaths;
//    NSString *docsDir;
//    
//    dirPaths = NSSearchPathForDirectoriesInDomains(
//                                                   NSDocumentDirectory, NSUserDomainMask, YES);
//    docsDir = dirPaths[0];
//    
//    NSString *soundFilePath = [docsDir
//                               stringByAppendingPathComponent:@"sound.caf"];
//    
//    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
//    
//    NSDictionary *recordSettings = [NSDictionary
//                                    dictionaryWithObjectsAndKeys:
//                                    [NSNumber numberWithInt:AVAudioQualityMin],
//                                    AVEncoderAudioQualityKey,
//                                    [NSNumber numberWithInt:16],
//                                    AVEncoderBitRateKey,
//                                    [NSNumber numberWithInt: 2],
//                                    AVNumberOfChannelsKey,
//                                    [NSNumber numberWithFloat:44100.0],
//                                    AVSampleRateKey,
//                                    nil];
//    
//    NSError *error = nil;
//    
//    _audioRecorder = [[AVAudioRecorder alloc]
//                      initWithURL:soundFileURL
//                      settings:recordSettings
//                      error:&error];
//    _audioRecorder.delegate = self;
//    [_audioRecorder prepareToRecord];
}

- (void)recordAudio{
//    
//    if (!_audioRecorder.recording)
//    {
//        NSError *errRet;
//        [_session setCategory:AVAudioSessionCategoryRecord error:&errRet];
//        [_session setActive:YES error:&errRet];
//        NSLog(@"Started Recording");
//        [_audioRecorder recordForDuration:5.0];
//    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type{
    if([credentials.token length] == 0) {
        NSLog(@"voip token NULL");
        return;
    }
    
//    NSString *token = [[credentials.token description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"PushCredentials: %@", credentials.token);
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type
{
    NSDictionary *payloadDict = payload.dictionaryPayload[@"aps"];
    
    NSLog(@"didReceiveIncomingPushWithPayload: %@", payloadDict);
    NSString *message = payloadDict[@"alert"];
    
    NSLog(@"%@", message);
    
    [self sendLocalNotificationsWithMessage:message];
//    [self recordAudio];
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
    NSLog(@"Finished Recording");
}

- (void)sendLocalNotificationsWithMessage:(NSString *)message {
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = message;
        localNotification.applicationIconBadgeNumber = 1;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"VoIP Notification"
                                                                                     message:message
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
