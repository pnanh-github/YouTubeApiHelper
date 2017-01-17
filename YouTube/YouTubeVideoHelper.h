//
//  YouTubeVideoHelper.h
//  
//
//  Created by Pham Nhat Anh on 1/16/17.
//  Copyright © 2017 Pham Nhat Anh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLRYouTube.h"
#import "YTPlayerView.h"

typedef void (^ UploadCompletionBlock)(GTLRServiceTicket *callbackTicket,
GTLRYouTube_Video *uploadedVideo,
NSError *callbackError);
typedef void (^ CompletionBlock)(BOOL staus);
typedef void (^ GetDataCompletionBlock)(id data,BOOL status);
typedef void (^ ProgressBlock)(GTLRServiceTicket *ticket, unsigned long long numberOfBytesRead, unsigned long long dataLength);

@interface YouTubeVideoHelper : NSObject

@property (nonatomic, strong)  GTLRYouTubeService *servive;
@property (nonatomic, copy) NSString* apiKey;
@property (nonatomic, strong) id <GTMFetcherAuthorizationProtocol> authorizer;
-(void) uploadVideo:(NSURL*) fileURL withName:(NSString*) videoName description:(NSString*) descriptionText progress:(ProgressBlock) pBlock andCompletion:(UploadCompletionBlock) completion;
-(void) uploadVideoSimple:(NSURL*) fileURL withName:(NSString*) videoName description:(NSString*) descriptionText andCompletion:(CompletionBlock) completion;
-(void) search:(NSString*) textSearch withType:(NSString*) type pageToken:(NSString*) token andCompletion:(GetDataCompletionBlock) completion;
-(void) getChannelDetail:(NSString*) channelId andCompletion:(GetDataCompletionBlock) completion;
-(void) getPlaylistOfChannel:(NSString*) channelId andCompletion:(GetDataCompletionBlock) completion;
-(void) getVideosOfList:(NSString*) playlistId withPage:(NSString*) pageToken andCompletion:(GetDataCompletionBlock) completion;
-(instancetype)init;
-(instancetype)initWithKey:(NSString*) apiKey andAuthorizer:(id <GTMFetcherAuthorizationProtocol>) authorizer;
+ (id)sharedInstance;
@end
