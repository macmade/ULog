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
 * @header      Base.hpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#ifndef ULOG_BASE_H
#define ULOG_BASE_H

/*!
 * @define      ULOG_EXTERN_C_BEGIN
 * @abstract    Extern "C" start / C++ compatibility
 */
#ifdef __cplusplus
#define ULOG_EXTERN_C_BEGIN     extern "C" {
#else
#define ULOG_EXTERN_C_BEGIN     
#endif

/*!
 * @define      ULOG_EXTERN_C_END
 * @abstract    Extern "C" end / C++ compatibility
 */
#ifdef __cplusplus
#define ULOG_EXTERN_C_END       }
#else
#define ULOG_EXTERN_C_END       
#endif

ULOG_EXTERN_C_BEGIN

/*!
 * @define      ULOG_EXPORT
 * @abstract    Definition for exported symbols
 */
#if defined( _WIN32 )
#if defined( ULOG_DLL_BUILD ) && defined( __cplusplus )
#define ULOG_EXPORT             __declspec( dllexport )
#elif defined( ULOG_DLL_BUILD ) && !defined( __cplusplus )
#define ULOG_EXPORT             __declspec( dllexport )
#elif defined( __cplusplus )
#define ULOG_EXPORT             __declspec( dllimport )
#else
#define ULOG_EXPORT             __declspec( dllimport )
#endif
#else
#define ULOG_EXPORT             
#endif

ULOG_EXTERN_C_END

#endif /* ULOG_BASE_H */
