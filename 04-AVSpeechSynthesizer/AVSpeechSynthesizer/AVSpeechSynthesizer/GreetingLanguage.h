//
//  GreetingLanguage.h
//  AVSpeechSynthesizer
//
//  Created by mac on 16/1/31.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface GreetingLanguage : NSObject

+ (NSArray *)listOfGreetings;
+ (instancetype)greetingLanguageWithBCP47:(NSString *)bcp47 name:(NSString *)name greeting:(NSString *)greeting;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bcp47;
@property (nonatomic, strong) NSString *greeting;

- (AVSpeechUtterance *)greetingUtterance;

@end
