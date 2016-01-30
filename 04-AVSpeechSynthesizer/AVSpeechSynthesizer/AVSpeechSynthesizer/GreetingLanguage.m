//
//  GreetingLanguage.m
//  AVSpeechSynthesizer
//
//  Created by mac on 16/1/31.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "GreetingLanguage.h"

@implementation GreetingLanguage

+ (instancetype)greetingLanguageWithBCP47:(NSString *)bcp47 name:(NSString *)name greeting:(NSString *)greeting {
    GreetingLanguage *greetingLanguage = [[GreetingLanguage alloc] init];
    greetingLanguage.name = name;
    greetingLanguage.bcp47 = bcp47;
    greetingLanguage.greeting = greeting;
    
    return greetingLanguage;
}

+ (NSArray *)listOfGreetings {
    return @[
             [GreetingLanguage greetingLanguageWithBCP47:@"zh-CN" name:@"Chinese" greeting:@"Ni hao"],
             [GreetingLanguage greetingLanguageWithBCP47:@"en-US" name:@"English (American)" greeting:@"Howdy!"],
             [GreetingLanguage greetingLanguageWithBCP47:@"en-AU" name:@"English (Australia)" greeting:@"G'day!"],
             [GreetingLanguage greetingLanguageWithBCP47:@"en-GB" name:@"English (British)" greeting:@"How do you do?"],
             [GreetingLanguage greetingLanguageWithBCP47:@"fr-FR" name:@"French" greeting:@"Bonjour"],
             [GreetingLanguage greetingLanguageWithBCP47:@"de-DE" name:@"German" greeting:@"Guten Tag"],
             [GreetingLanguage greetingLanguageWithBCP47:@"it-IT" name:@"Italian" greeting:@"Buongiorno"],
             [GreetingLanguage greetingLanguageWithBCP47:@"ja-JP" name:@"Japanese" greeting:@"Kon'nichiwa"],
             [GreetingLanguage greetingLanguageWithBCP47:@"pt-PT" name:@"Portugese" greeting:@"Olá"],
             [GreetingLanguage greetingLanguageWithBCP47:@"ru-RU" name:@"Russian" greeting:@"privet"],
             [GreetingLanguage greetingLanguageWithBCP47:@"es-ES" name:@"Spanish" greeting:@"¡Hola!"],
             [GreetingLanguage greetingLanguageWithBCP47:@"th-TH" name:@"Thai" greeting:@"Sawadee Khaa"]
             ];
}

- (AVSpeechUtterance *)greetingUtterance {
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:self.bcp47];
    
    AVSpeechUtterance *utterance;
    
    if (voice) {
        utterance = [AVSpeechUtterance speechUtteranceWithString:self.greeting];
        utterance.voice = voice;
        utterance.rate *= 0.7;
    }
    
    return utterance;
}

@end
