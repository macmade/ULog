/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2016 Jean-David Gadina - www-xs-labs.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

/*!
 * @header      ColorTheme.h
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#ifndef ULOG_OBJC_COLOR_THEME_H
#define ULOG_OBJC_COLOR_THEME_H

#if !defined( TARGET_OS_IOS ) || TARGET_OS_IOS == 0

#if defined( __has_feature ) && __has_feature( objc_modules )
@import Cocoa;
#else
#import <Cocoa/Cocoa.h>
#endif

#include <ULog/Base.h>
#include <ULog/OBJC/MessageColors.h>

@interface ULogColorTheme: NSObject < NSSecureCoding, NSCopying >

@property( atomic, readwrite, strong ) ULogMessageColors * emergencyColors;
@property( atomic, readwrite, strong ) ULogMessageColors * alertColors;
@property( atomic, readwrite, strong ) ULogMessageColors * criticalColors;
@property( atomic, readwrite, strong ) ULogMessageColors * errorColors;
@property( atomic, readwrite, strong ) ULogMessageColors * warningColors;
@property( atomic, readwrite, strong ) ULogMessageColors * noticeColors;
@property( atomic, readwrite, strong ) ULogMessageColors * infoColors;
@property( atomic, readwrite, strong ) ULogMessageColors * debugColors;

+ ( instancetype )defaultTheme;
+ ( instancetype )civicTheme;
+ ( instancetype )duskTheme;
+ ( instancetype )midnightTheme;
+ ( instancetype )sunsetTheme;
+ ( instancetype )xcodeTheme;
+ ( instancetype )xsTheme;

@end

#endif

#endif /* ULOG_OBJC_COLOR_THEME_H */
