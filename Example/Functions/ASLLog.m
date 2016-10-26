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
 * @file        ASLLog.c
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#import <ULog/ULog.h>
#import <stdlib.h>
#import "ASLLog.h"
#import <asl.h>

void ASLLog( int * i )
{
    int        x;
    aslclient  c;
    NSString * s;
    
    if( i == NULL )
    {
        return;
    }
    
    x = *( i );
    s = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleName" ];
    c = asl_open( s.UTF8String, NULL, 0 );
    
    asl_log( c, NULL, ASL_LEVEL_EMERG,   "Emergency from ASL: %i", x++ );
    asl_log( c, NULL, ASL_LEVEL_ALERT,   "Alert from ASL: %i", x++ );
    asl_log( c, NULL, ASL_LEVEL_CRIT,    "Critical from ASL: %i", x++ );
    asl_log( c, NULL, ASL_LEVEL_ERR,     "Error from ASL: %i", x++ );
    asl_log( c, NULL, ASL_LEVEL_WARNING, "Warning from ASL: %i", x++ );
    asl_log( c, NULL, ASL_LEVEL_NOTICE,  "Notice from ASL: %i", x++ );
    asl_log( c, NULL, ASL_LEVEL_INFO,    "Info from ASL: %i", x++ );
    asl_log( c, NULL, ASL_LEVEL_DEBUG,   "Debug from ASL: %i", x++ );
    
    *( i ) = x;
    
    asl_close( c );
}
