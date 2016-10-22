/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2016 Jean-David Gadina - www.xs-labs.com
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
 * @file        MessageColors.m
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#import <ULog/ULog.h>

#if !defined( TARGET_OS_IOS ) || TARGET_OS_IOS == 0

@interface ULogColorTheme()

@end

@implementation ULogColorTheme

+ ( BOOL )supportsSecureCoding
{
    return YES;
}

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        self.emergencyColors = [ ULogMessageColors new ];
        self.alertColors     = [ ULogMessageColors new ];
        self.criticalColors  = [ ULogMessageColors new ];
        self.errorColors     = [ ULogMessageColors new ];
        self.warningColors   = [ ULogMessageColors new ];
        self.noticeColors    = [ ULogMessageColors new ];
        self.infoColors      = [ ULogMessageColors new ];
        self.debugColors     = [ ULogMessageColors new ];
    }
    
    return self;
}

- ( instancetype )initWithCoder: ( NSCoder * )coder
{
    if( ( self = [ super init ] ) )
    {
        self.emergencyColors = [ coder decodeObjectForKey: @"EmergencyColors" ];
        self.alertColors     = [ coder decodeObjectForKey: @"AlertColors" ];
        self.criticalColors  = [ coder decodeObjectForKey: @"CriticalColors" ];
        self.errorColors     = [ coder decodeObjectForKey: @"ErrorColors" ];
        self.warningColors   = [ coder decodeObjectForKey: @"WarningColors" ];
        self.noticeColors    = [ coder decodeObjectForKey: @"NoticeColors" ];
        self.infoColors      = [ coder decodeObjectForKey: @"InfoColors" ];
        self.debugColors     = [ coder decodeObjectForKey: @"DebugColors" ];
    }
    
    return self;
}

- ( void )encodeWithCoder: ( NSCoder * )coder
{
    [ coder encodeObject: self.emergencyColors forKey: @"EmergencyColors" ];
    [ coder encodeObject: self.alertColors     forKey: @"AlertColors" ];
    [ coder encodeObject: self.criticalColors  forKey: @"CriticalColors" ];
    [ coder encodeObject: self.errorColors     forKey: @"ErrorColors" ];
    [ coder encodeObject: self.warningColors   forKey: @"WarningColors" ];
    [ coder encodeObject: self.noticeColors    forKey: @"NoticeColors" ];
    [ coder encodeObject: self.infoColors      forKey: @"InfoColors" ];
    [ coder encodeObject: self.debugColors     forKey: @"DebugColors" ];
}

+ ( instancetype )defaultTheme
{
    return [ self xsTheme ];
}

+ ( instancetype )xcodeTheme
{
    static dispatch_once_t  once;
    static ULogColorTheme * theme = nil;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            theme = [ self new ];
            
            theme.emergencyColors.backgroundColor   = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.emergencyColors.foregroundColor   = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.emergencyColors.timeColor         = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.emergencyColors.sourceColor       = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.emergencyColors.levelColor        = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.emergencyColors.messageColor      = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.alertColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.alertColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.alertColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.alertColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.alertColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.alertColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.criticalColors.backgroundColor    = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.criticalColors.foregroundColor    = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.criticalColors.timeColor          = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.criticalColors.sourceColor        = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.criticalColors.levelColor         = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.criticalColors.messageColor       = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.errorColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.errorColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.errorColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.errorColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.errorColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.errorColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.warningColors.backgroundColor     = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.warningColors.foregroundColor     = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.warningColors.timeColor           = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.warningColors.sourceColor         = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.warningColors.levelColor          = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.warningColors.messageColor        = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.noticeColors.backgroundColor      = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.noticeColors.foregroundColor      = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.noticeColors.timeColor            = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.noticeColors.sourceColor          = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.noticeColors.levelColor           = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.noticeColors.messageColor         = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.infoColors.backgroundColor        = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.infoColors.foregroundColor        = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.infoColors.timeColor              = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.infoColors.sourceColor            = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.infoColors.levelColor             = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.infoColors.messageColor           = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.debugColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.debugColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.debugColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.debugColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.debugColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.debugColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
        }
    );
    
    return theme;
}

+ ( instancetype )duskTheme
{
    static dispatch_once_t  once;
    static ULogColorTheme * theme = nil;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            theme = [ self new ];
            
            theme.emergencyColors.backgroundColor   = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.emergencyColors.foregroundColor   = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.emergencyColors.timeColor         = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.emergencyColors.sourceColor       = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.emergencyColors.levelColor        = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.emergencyColors.messageColor      = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.alertColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.alertColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.alertColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.alertColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.alertColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.alertColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.criticalColors.backgroundColor    = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.criticalColors.foregroundColor    = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.criticalColors.timeColor          = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.criticalColors.sourceColor        = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.criticalColors.levelColor         = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.criticalColors.messageColor       = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.errorColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.errorColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.errorColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.errorColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.errorColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.errorColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.warningColors.backgroundColor     = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.warningColors.foregroundColor     = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.warningColors.timeColor           = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.warningColors.sourceColor         = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.warningColors.levelColor          = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.warningColors.messageColor        = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.noticeColors.backgroundColor      = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.noticeColors.foregroundColor      = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.noticeColors.timeColor            = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.noticeColors.sourceColor          = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.noticeColors.levelColor           = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.noticeColors.messageColor         = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.infoColors.backgroundColor        = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.infoColors.foregroundColor        = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.infoColors.timeColor              = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.infoColors.sourceColor            = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.infoColors.levelColor             = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.infoColors.messageColor           = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.debugColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.debugColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.debugColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.debugColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.debugColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.debugColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
        }
    );
    
    return theme;
}

+ ( instancetype )sunsetTheme
{
    static dispatch_once_t  once;
    static ULogColorTheme * theme = nil;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            theme = [ self new ];
            
            theme.emergencyColors.backgroundColor   = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.emergencyColors.foregroundColor   = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.emergencyColors.timeColor         = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.emergencyColors.sourceColor       = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.emergencyColors.levelColor        = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.emergencyColors.messageColor      = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.alertColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.alertColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.alertColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.alertColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.alertColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.alertColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.criticalColors.backgroundColor    = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.criticalColors.foregroundColor    = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.criticalColors.timeColor          = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.criticalColors.sourceColor        = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.criticalColors.levelColor         = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.criticalColors.messageColor       = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.errorColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.errorColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.errorColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.errorColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.errorColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.errorColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.warningColors.backgroundColor     = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.warningColors.foregroundColor     = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.warningColors.timeColor           = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.warningColors.sourceColor         = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.warningColors.levelColor          = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.warningColors.messageColor        = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.noticeColors.backgroundColor      = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.noticeColors.foregroundColor      = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.noticeColors.timeColor            = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.noticeColors.sourceColor          = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.noticeColors.levelColor           = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.noticeColors.messageColor         = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.infoColors.backgroundColor        = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.infoColors.foregroundColor        = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.infoColors.timeColor              = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.infoColors.sourceColor            = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.infoColors.levelColor             = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.infoColors.messageColor           = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.debugColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.debugColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.debugColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.debugColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.debugColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.debugColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
        }
    );
    
    return theme;
}

+ ( instancetype )xsTheme
{
    static dispatch_once_t  once;
    static ULogColorTheme * theme = nil;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            theme = [ self new ];
            
            theme.emergencyColors.backgroundColor   = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.emergencyColors.foregroundColor   = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.emergencyColors.timeColor         = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.emergencyColors.sourceColor       = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.emergencyColors.levelColor        = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.emergencyColors.messageColor      = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.alertColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.alertColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.alertColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.alertColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.alertColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.alertColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.criticalColors.backgroundColor    = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.criticalColors.foregroundColor    = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.criticalColors.timeColor          = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.criticalColors.sourceColor        = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.criticalColors.levelColor         = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.criticalColors.messageColor       = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.errorColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.errorColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.errorColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.errorColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.errorColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.errorColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.warningColors.backgroundColor     = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.warningColors.foregroundColor     = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.warningColors.timeColor           = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.warningColors.sourceColor         = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.warningColors.levelColor          = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.warningColors.messageColor        = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.noticeColors.backgroundColor      = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.noticeColors.foregroundColor      = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.noticeColors.timeColor            = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.noticeColors.sourceColor          = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.noticeColors.levelColor           = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.noticeColors.messageColor         = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.infoColors.backgroundColor        = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.infoColors.foregroundColor        = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.infoColors.timeColor              = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.infoColors.sourceColor            = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.infoColors.levelColor             = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.infoColors.messageColor           = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.debugColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.debugColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.debugColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.debugColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.debugColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.debugColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
        }
    );
    
    return theme;
}

+ ( instancetype )bareBonesTheme
{
    static dispatch_once_t  once;
    static ULogColorTheme * theme = nil;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            theme = [ self new ];
            
            theme.emergencyColors.backgroundColor   = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.emergencyColors.foregroundColor   = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.emergencyColors.timeColor         = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.emergencyColors.sourceColor       = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.emergencyColors.levelColor        = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.emergencyColors.messageColor      = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.alertColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.alertColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.alertColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.alertColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.alertColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.alertColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.criticalColors.backgroundColor    = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.criticalColors.foregroundColor    = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.criticalColors.timeColor          = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.criticalColors.sourceColor        = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.criticalColors.levelColor         = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.criticalColors.messageColor       = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.errorColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.errorColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.errorColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.errorColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.errorColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.errorColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.warningColors.backgroundColor     = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.warningColors.foregroundColor     = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.warningColors.timeColor           = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.warningColors.sourceColor         = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.warningColors.levelColor          = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.warningColors.messageColor        = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.noticeColors.backgroundColor      = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.noticeColors.foregroundColor      = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.noticeColors.timeColor            = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.noticeColors.sourceColor          = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.noticeColors.levelColor           = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.noticeColors.messageColor         = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.infoColors.backgroundColor        = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.infoColors.foregroundColor        = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.infoColors.timeColor              = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.infoColors.sourceColor            = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.infoColors.levelColor             = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.infoColors.messageColor           = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.debugColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.debugColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.debugColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.debugColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.debugColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.debugColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
        }
    );
    
    return theme;
}

+ ( instancetype )civicTheme
{
    static dispatch_once_t  once;
    static ULogColorTheme * theme = nil;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            theme = [ self new ];
            
            theme.emergencyColors.backgroundColor   = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.emergencyColors.foregroundColor   = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.emergencyColors.timeColor         = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.emergencyColors.sourceColor       = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.emergencyColors.levelColor        = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.emergencyColors.messageColor      = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.alertColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.alertColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.alertColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.alertColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.alertColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.alertColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.criticalColors.backgroundColor    = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.criticalColors.foregroundColor    = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.criticalColors.timeColor          = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.criticalColors.sourceColor        = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.criticalColors.levelColor         = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.criticalColors.messageColor       = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.errorColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.errorColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.errorColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.errorColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.errorColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.errorColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.warningColors.backgroundColor     = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.warningColors.foregroundColor     = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.warningColors.timeColor           = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.warningColors.sourceColor         = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.warningColors.levelColor          = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.warningColors.messageColor        = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.noticeColors.backgroundColor      = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.noticeColors.foregroundColor      = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.noticeColors.timeColor            = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.noticeColors.sourceColor          = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.noticeColors.levelColor           = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.noticeColors.messageColor         = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.infoColors.backgroundColor        = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.infoColors.foregroundColor        = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.infoColors.timeColor              = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.infoColors.sourceColor            = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.infoColors.levelColor             = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.infoColors.messageColor           = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.debugColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.debugColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.debugColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.debugColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.debugColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.debugColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
        }
    );
    
    return theme;
}

+ ( instancetype )midnightTheme
{
    static dispatch_once_t  once;
    static ULogColorTheme * theme = nil;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            theme = [ self new ];
            
            theme.emergencyColors.backgroundColor   = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.emergencyColors.foregroundColor   = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.emergencyColors.timeColor         = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.emergencyColors.sourceColor       = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.emergencyColors.levelColor        = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.emergencyColors.messageColor      = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.alertColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.alertColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.alertColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.alertColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.alertColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.alertColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.criticalColors.backgroundColor    = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.criticalColors.foregroundColor    = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.criticalColors.timeColor          = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.criticalColors.sourceColor        = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.criticalColors.levelColor         = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.criticalColors.messageColor       = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.errorColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.errorColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.errorColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.errorColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.errorColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.errorColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.warningColors.backgroundColor     = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.warningColors.foregroundColor     = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.warningColors.timeColor           = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.warningColors.sourceColor         = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.warningColors.levelColor          = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.warningColors.messageColor        = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.noticeColors.backgroundColor      = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.noticeColors.foregroundColor      = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.noticeColors.timeColor            = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.noticeColors.sourceColor          = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.noticeColors.levelColor           = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.noticeColors.messageColor         = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.infoColors.backgroundColor        = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.infoColors.foregroundColor        = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.infoColors.timeColor              = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.infoColors.sourceColor            = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.infoColors.levelColor             = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.infoColors.messageColor           = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            theme.debugColors.backgroundColor       = ULOG_HEXCOLOR( 0x161A1D, 1 );
            theme.debugColors.foregroundColor       = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            theme.debugColors.timeColor             = ULOG_HEXCOLOR( 0x5A773C, 1 );
            theme.debugColors.sourceColor           = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            theme.debugColors.levelColor            = ULOG_HEXCOLOR( 0x996633, 1 );
            theme.debugColors.messageColor          = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
        }
    );
    
    return theme;
}

@end

#endif
