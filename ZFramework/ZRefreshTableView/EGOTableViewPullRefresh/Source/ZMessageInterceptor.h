//
//  ZMessageInterceptor.h
//
//  From http://stackoverflow.com/questions/3498158/intercept-obj-c-delegate-messages-within-a-subclass
//

#import <Foundation/Foundation.h>

@interface ZMessageInterceptor : NSObject

@property (nonatomic, weak) id receiver;
@property (nonatomic, weak) id middleMan;

@end
