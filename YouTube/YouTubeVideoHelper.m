//
//  YouTubeVideoHelper.m
//  
//
//  Created by Pham Nhat Anh on 1/16/17.
//  Copyright © 2017 Pham Nhat Anh. All rights reserved.
//

#import "YouTubeVideoHelper.h"
#import <GTMSessionFetcher/GTMSessionFetcher.h>
#import "GTLRFramework.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AFNetworking/AFNetworking.h>

@implementation YouTubeVideoHelper


#pragma mark - Upload Video
-(void)uploadVideo:(NSURL *)fileURL withName:(NSString *)videoName description:(NSString *)descriptionText progress:(ProgressBlock)pBlock andCompletion:(UploadCompletionBlock)completion{
    if(self.authorizer && [self.authorizer canAuthorize]){
        if(self.apiKey){
            self.servive.APIKey = self.apiKey;
            self.servive.authorizer = self.authorizer;
            GTLRYouTube_VideoStatus *status = [GTLRYouTube_VideoStatus object];
            status.privacyStatus = @"public";
            
            // Snippet.
            GTLRYouTube_VideoSnippet *snippet = [GTLRYouTube_VideoSnippet object];
            snippet.title = videoName;
            NSString *desc = descriptionText;
            if (desc.length > 0) {
                snippet.descriptionProperty = desc;
            }
            GTLRYouTube_Video *video = [GTLRYouTube_Video object];
            video.status = status;
            video.snippet = snippet;
            
            NSError *fileError;
            if (![fileURL checkPromisedItemIsReachableAndReturnError:&fileError]) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedString(@"File Error.", nil),
                                           NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"File Error.", nil),
                                           NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"File Error.", nil)
                                           };
                NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain
                                                     code:-1
                                                 userInfo:userInfo];
                completion(nil,nil,error);

            }
            // Get a file handle for the upload data.
            NSString *filename = [fileURL lastPathComponent];
            NSString *mimeType = [self MIMETypeForFilename:filename
                                           defaultMIMEType:@"video/mp4"];
            GTLRUploadParameters *uploadParameters =
            [GTLRUploadParameters uploadParametersWithFileURL:fileURL
                                                     MIMEType:mimeType];
            uploadParameters.uploadLocationURL = nil;
            GTLRYouTubeQuery_VideosInsert *query =
            [GTLRYouTubeQuery_VideosInsert queryWithObject:video
                                                      part:@"snippet,status"
                                          uploadParameters:uploadParameters];
            //Progress Block
            query.executionParameters.uploadProgressBlock = pBlock;
            [self.servive executeQuery:query completionHandler:completion];
        }else{
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"ApiKey not found.", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"ApiKey not found.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ApiKey not found.", nil)
                                       };
            NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain
                                                 code:-1
                                             userInfo:userInfo];
            completion(nil,nil,error);
        }
    }else{
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Unauthorized.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Unauthorized.", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Unauthorized.", nil)
                                   };
        NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain
                                             code:-1
                                         userInfo:userInfo];
        completion(nil,nil,error);
    }
}
-(void)uploadVideoSimple:(NSURL *)fileURL withName:(NSString *)videoName description:(NSString *)descriptionText andCompletion:(CompletionBlock)completion{
    if(self.authorizer && [self.authorizer canAuthorize]){
        if(self.apiKey){
            self.servive.APIKey = self.apiKey;
            self.servive.authorizer = self.authorizer;
            GTLRYouTube_VideoStatus *status = [GTLRYouTube_VideoStatus object];
            status.privacyStatus = @"public";
            
            // Snippet.
            GTLRYouTube_VideoSnippet *snippet = [GTLRYouTube_VideoSnippet object];
            snippet.title = videoName;
            NSString *desc = descriptionText;
            if (desc.length > 0) {
                snippet.descriptionProperty = desc;
            }
            GTLRYouTube_Video *video = [GTLRYouTube_Video object];
            video.status = status;
            video.snippet = snippet;
            
            NSError *fileError;
            if (![fileURL checkPromisedItemIsReachableAndReturnError:&fileError]) {
                completion(FALSE);
            }
            // Get a file handle for the upload data.
            NSString *filename = [fileURL lastPathComponent];
            NSString *mimeType = [self MIMETypeForFilename:filename
                                           defaultMIMEType:@"video/mp4"];
            GTLRUploadParameters *uploadParameters =
            [GTLRUploadParameters uploadParametersWithFileURL:fileURL
                                                     MIMEType:mimeType];
            uploadParameters.uploadLocationURL = nil;
            GTLRYouTubeQuery_VideosInsert *query =
            [GTLRYouTubeQuery_VideosInsert queryWithObject:video
                                                      part:@"snippet,status"
                                          uploadParameters:uploadParameters];
            query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                              unsigned long long numberOfBytesRead,
                                                              unsigned long long dataLength) {
                
                
            };
            [self.servive executeQuery:query completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, GTLRYouTube_Video *uploadedVideo, NSError * _Nullable callbackError) {
                if (callbackError == nil) {
                    completion(TRUE);
                } else {
                    completion(FALSE);
                }
            }];
        }else{
            completion(FALSE);
        }
    }else{
         completion(FALSE);
    }
}

- (NSString *)MIMETypeForFilename:(NSString *)filename
                  defaultMIMEType:(NSString *)defaultType {
    NSString *result = defaultType;
    NSString *extension = [filename pathExtension];
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                            (__bridge CFStringRef)extension, NULL);
    if (uti) {
        CFStringRef cfMIMEType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
        if (cfMIMEType) {
            result = CFBridgingRelease(cfMIMEType);
        }
        CFRelease(uti);
    }
    return result;
}

#pragma mark - Search
-(void)search:(NSString *)textSearch withType:(NSString *)type pageToken:(NSString *)token andCompletion:(GetDataCompletionBlock)completion{
    if(self.apiKey){
        NSInteger numOfRecords = 10;
        NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&maxResults=%li&type=%@&key=%@",textSearch,(long)numOfRecords,type,
                         self.apiKey];
        if(token){
            url = [url stringByAppendingFormat:@"&pageToken=%@",token];
        }
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"items"] isKindOfClass:[NSArray class]]){
                completion([responseObject objectForKey:@"items"],TRUE);
            }else{
                completion(nil,FALSE);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil,FALSE);
        }];
    }else{
        completion(nil, FALSE);
    }
    
}

#pragma mark - Get Channel Detail
-(void)getChannelDetail:(NSString *)channelId andCompletion:(GetDataCompletionBlock)completion{
    if(self.apiKey){
        NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&id=%@&key=%@",channelId,self.apiKey];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"items"] isKindOfClass:[NSArray class]]){
                completion([responseObject objectForKey:@"items"],TRUE);
            }else{
                completion(nil,FALSE);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil,FALSE);
        }];
    }else{
        completion(nil, FALSE);
    }
}

#pragma mark - Get Playlist 
-(void)getPlaylistOfChannel:(NSString *)channelId andCompletion:(GetDataCompletionBlock)completion{
    if(self.apiKey){
        NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlists?part=snippet&channelId=%@&key=%@",channelId,self.apiKey];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"items"] isKindOfClass:[NSArray class]]){
                completion([responseObject objectForKey:@"items"],TRUE);
            }else{
                completion(nil,FALSE);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil,FALSE);
        }];
    }else{
        completion(nil, FALSE);
    }
}

#pragma mark - Get Videos in Playlist
-(void)getVideosOfList:(NSString *)playlistId withPage:(NSString *)pageToken andCompletion:(GetDataCompletionBlock)completion{
    if(self.apiKey){
        NSInteger numOfRecords = 10;
        NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=%@&maxResults=%li&key=%@",playlistId,(long)numOfRecords,self.apiKey];
        if(pageToken){
            url = [url stringByAppendingFormat:@"&pageToken=%@",pageToken];
        }
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"items"] isKindOfClass:[NSArray class]]){
                completion([responseObject objectForKey:@"items"],TRUE);
            }else{
                completion(nil,FALSE);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil,FALSE);
        }];
    }else{
        completion(nil, FALSE);
    }
}

#pragma mark - Init Methods
-(instancetype)init{
    if(!self){
        self = [super init];
    }
    self.servive = [[GTLRYouTubeService alloc] init];
    return self;
}
-(instancetype)initWithKey:(NSString *)apiKey andAuthorizer:(id<GTMFetcherAuthorizationProtocol>)authorizer{
    if(!self){
        self = [super init];
    }
    self.servive = [[GTLRYouTubeService alloc] init];
    self.apiKey = apiKey;
    self.authorizer = authorizer;
    return self;
}
+(id)sharedInstance{
    static YouTubeVideoHelper *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.servive = [[GTLRYouTubeService alloc] init];
    });
    return sharedMyManager;
}



@end
