//
//  TTLinkParser.m
//  TTDemo
//
//  Created by liuxj on 2018/5/3.
//  Copyright © 2018年 iwm. All rights reserved.
//

#import "TTLinkParser.h"

static NSString *const kFullRegexPattern = @"<a herf=\\S*>\\S*</a>";
static NSString *const kContentRegexPattern = @">\\S*<";
static NSString *const kLinkRegexPattern = @"\"\\S*\"";

@interface TTLinkParser()

@property (nonatomic, strong) NSRegularExpression *fullRegexPattern;//匹配全部
@property (nonatomic, strong) NSRegularExpression *contentRegexPattern;//匹配文字部分
@property (nonatomic, strong) NSRegularExpression *linkRegexPattern;//匹配链接部分

@end

@implementation TTLinkParser

#pragma mark - Singleton

+ (instancetype)sharedParser {
    static dispatch_once_t onceToken;
    static TTLinkParser *sharedParser;
    dispatch_once(&onceToken, ^{
        sharedParser = [[TTLinkParser alloc] init];
    });
    return sharedParser;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fullRegexPattern = [[NSRegularExpression alloc] initWithPattern:kFullRegexPattern
                                                                 options:NSRegularExpressionCaseInsensitive
                                                                   error:nil];
        
        _contentRegexPattern = [[NSRegularExpression alloc] initWithPattern:kContentRegexPattern
                                                                    options:NSRegularExpressionCaseInsensitive
                                                                      error:nil];
        
        _linkRegexPattern = [[NSRegularExpression alloc] initWithPattern:kLinkRegexPattern
                                                                 options:NSRegularExpressionCaseInsensitive
                                                                   error:nil];
    }
    return self;
}

#pragma mark - Public Method

- (NSAttributedString *)parsedLinkAttributedStringWithContent:(NSString *)content {
    if (content.length <= 0 || !content) {
        return nil;
    }
    
    NSMutableAttributedString *attibuteContent = [[NSMutableAttributedString alloc] init];
    
    //记录当次匹配的开始位置
    NSInteger cursorLoc = 0;
    //得到所有匹配
    NSArray *matchs = [self.fullRegexPattern matchesInString:content
                                                     options:NSMatchingReportProgress
                                                       range:NSMakeRange(0, content.length)];
    
    for (NSTextCheckingResult *result in matchs) {
        NSRange fullRange = result.range;
        //得到前面部分内容 : 欢迎使用探探，在使用过程中有疑问请
        NSString *preStr = [content substringWithRange:NSMakeRange(cursorLoc, fullRange.location - cursorLoc)];
        NSAttributedString *preAttStr = [[NSAttributedString alloc] initWithString:preStr];
        [attibuteContent appendAttributedString:preAttStr];
        
        //得到需要处理部分的内容<a herf="tantanapp://feedback">反馈</a>
        NSString *toParseString = [content substringWithRange:fullRange];
        
        //得到内容的边界 >反馈<
        NSRange contentRange = [self.contentRegexPattern rangeOfFirstMatchInString:toParseString
                                                                           options:NSMatchingReportProgress
                                                                             range:NSMakeRange(0, toParseString.length)];
        NSString *contentString = nil;
        //判断内容存在
        if (NSMaxRange(contentRange) < toParseString.length && content.length > 2) {
            contentString = [toParseString substringWithRange:NSMakeRange(contentRange.location + 1, contentRange.length - 2)];
        }else {
            contentString = toParseString;
        }
        
        NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc] initWithString:contentString];
        
        //得到链接的边界"tantanapp://feedback"
        NSRange linkRange = [self.linkRegexPattern rangeOfFirstMatchInString:toParseString
                                                                     options:NSMatchingReportProgress
                                                                       range:NSMakeRange(0, toParseString.length)];
        //链接存在的判断
        if (NSMaxRange(linkRange) < toParseString.length && linkRange.length > 2) {
            NSString *linkString = [toParseString substringWithRange:NSMakeRange(linkRange.location + 1, linkRange.length - 2)];
            [contentAtt addAttribute:NSLinkAttributeName
                               value:[NSURL URLWithString:linkString]
                               range:NSMakeRange(0, contentAtt.length)];
        }
        
        if (contentAtt) {
            [attibuteContent appendAttributedString:contentAtt];
        }
        
        cursorLoc = NSMaxRange(fullRange);
    }
    
    if (cursorLoc < content.length) {
        NSAttributedString *subAttributedString = [[NSAttributedString alloc] initWithString:[content substringFromIndex:cursorLoc]];
        [attibuteContent appendAttributedString:subAttributedString];
    }
    
    return attibuteContent.copy;
}

#pragma mark - Getter & Setter

@end
