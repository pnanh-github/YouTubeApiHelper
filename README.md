# YouTubeApiHelper
A simple wrapper for YouTube data API 3.0 support new Google Authentication method (Google/Sign-In).

This library can:
- Upload video
- Get Channel's info
- Get Playlists list
- Get Videos list
- View youtube video in app

## Required Frameworks:
- GoogleAPIClientForREST
- AFNetworking
- Google/SignIn (optional)

## Install:
- Drag "YouTube" directory to your Xcode project.
- Import class: "YouTubeVideoHelper.h"
- Create new YouTubeVideoHelper object and setup apikey & authorizer (login required for upload video) for this object.

```
YouTubeVideoHelper *helper = [YouTubeVideoHelper sharedInstance];
helper.apiKey = API_KEY;
helper.authorizer = [GIDSignIn sharedInstance].currentUser.authentication.fetcherAuthorizer;

```

## Syntax
Check the demo project: Example App

## Info:
- [Youtube Data API v3 Doc](https://developers.google.com/youtube/v3/)
- [Obtain API key from Google API Console](https://console.developers.google.com)

##License

MIT License (MIT)

```
Copyright (c) 2017 Pham Nhat Anh

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

```
