/* vim: set ai noet ts=4 sw=4 tw=115: */
//
// Copyright (c) 2014 Nikolay Zapolnov (zapolnov@gmail.com).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
#import "FBSession+ExtraMethods.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FBSession (ExtraMethods)

+(void)queryAvatarURLForUser:(NSString *)userID completion:(void(^)(NSString * url))completion
{
	NSString * url = [NSString
		stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&redirect=false", userID];

	NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
		completionHandler:^(NSURLResponse * response, NSData * data, NSError * error)
	{
		if (error || !data)
		{
			if (completion)
				completion(nil);
			return;
		}

		NSString * url;
		@try
		{
			id json = [NSJSONSerialization JSONObjectWithData:data
				options:NSJSONReadingAllowFragments error:nil];
			url = json[@"url"];
		}
		@catch (id e)
		{
			NSLog(@"Unable to fetch Facebook avatar URL: %@", e);
			if (completion)
				completion(nil);
			return;
		}

		if (completion)
			completion(url);
	}];
}

@end
