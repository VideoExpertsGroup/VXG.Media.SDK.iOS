//
//  Url.m
//  MediaPlayerSDKTest2
//
//  Created by Max Koutsanov on 6/21/19.
//

#import "Url.h"
@interface Url() {
    UrlType type;
    NSString* url;
    NSString* name;
    UIImage*  image;
    MediaPlayerConfig* config;
    void* userDefinedData;
}

@end

@implementation Url

- (id) initWithParam:(NSString*)paramName
                 url:(NSString*)paramUrl
               image:(UIImage*)paramImage {
    self = [super init];
    if(self) {
        type = URL_TYPE_STANDARD;
        name = paramName;
        url = paramUrl;
        image = paramImage;
        config = [[MediaPlayerConfig alloc] init]; // default
    }
    return self;
}

-(id)initWithConfig:(NSString*)paramName
             config:(MediaPlayerConfig*)paramCconfig {
    self = [super init];
    if(self) {
        type = URL_TYPE_STANDARD;
        url = (paramCconfig != nil) ? paramCconfig.connectionUrl : @"";
        name = paramName;
        image = nil;
        config = paramCconfig;
    }
    return self;
}

- (void)setType: (UrlType)val { type = val; }
- (UrlType)getType { return type; }

- (void)setUrl: (NSString *)newUrl { url = newUrl; }
- (NSString*)getUrl { return url; }

- (void)setName: (NSString *)newName { name = newName; }
- (NSString*)getName { return name; }

- (void)setImage: (UIImage*)newImage { image = newImage; }
- (UIImage*)getImage { return image; }

- (void)setUserDefined: (void*) userDefined { self->userDefinedData = userDefined; }
- (void*)getUserDefined { return userDefinedData; }

- (MediaPlayerConfig*)getConfig {
    return config;
}

-(BOOL)isEqual:(id)otherObj {
    Url *other = (Url*)otherObj;
    Boolean first = [[self getUrl] isEqualToString: [other getUrl]];
    Boolean second = [[self getName] isEqualToString: [other getName]];
    return (first && second);
}

@end

