//
//  TTLinkParser.h
//  TTDemo
//
//  Created by liuxj on 2018/5/3.
//  Copyright © 2018年 iwm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTLinkParser : NSObject

+ (instancetype)sharedParser;

/**
  * 传入待解析对象返回解析完成后的富文本，可以在子线程操作
  */
- (NSAttributedString *)parsedLinkAttributedStringWithContent:(NSString *)content;

@end
