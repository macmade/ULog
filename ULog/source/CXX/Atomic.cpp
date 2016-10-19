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
 * @file        Atomic.cpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#include <ULog/ULog.h>
#include <ULog/CXX/Atomic.hpp>

#if defined( _WIN32 )
#include <SDKDDKVer.h>
#include <Windows.h>
#elif defined( __APPLE__ )
#include <libkern/OSAtomic.h>
#endif

namespace ULog
{
    namespace Atomic
    {
        int32_t Increment32( volatile int32_t * value )
        {
            #if defined( _WIN32 )
            
            return InterlockedIncrement( ( volatile LONG * )value );
            
            #elif defined( __APPLE__ )
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return OSAtomicIncrement32( value );
            #pragma clang diagnostic pop
            
            #elif defined( __has_builtin ) && __has_builtin( __sync_add_and_fetch )
            
            return __sync_add_and_fetch( value, 1 );
            
            #else
            
            #error "ULog::Atomic::Increment32 is not implemented for the current platform"
            
            #endif
        }

        int64_t Increment64( volatile int64_t * value )
        {
            #if defined( _WIN32 )
            
            return InterlockedIncrement64( ( volatile LONGLONG * )value );
            
            #elif defined( __APPLE__ )
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return OSAtomicIncrement64( value );
            #pragma clang diagnostic pop
            
            #elif defined( __has_builtin ) && __has_builtin( __sync_add_and_fetch )
            
            return __sync_add_and_fetch( value, 1 );
            
            #else
            
            #error "ULog::Atomic::Increment64 is not implemented for the current platform"
            
            #endif
        }

        int32_t Decrement32( volatile int32_t * value )
        {
            #if defined( _WIN32 )
            
            return InterlockedDecrement( ( volatile LONG * )value );
            
            #elif defined( __APPLE__ )
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return OSAtomicDecrement32( value );
            #pragma clang diagnostic pop
            
            #elif defined( __has_builtin ) && __has_builtin( __sync_add_and_fetch )
            
            return __sync_add_and_fetch( value, -1 );
            
            #else
            
            #error "ULog::Atomic::Decrement32 is not implemented for the current platform"
            
            #endif
        }

        int64_t Decrement64( volatile int64_t * value )
        {
            #if defined( _WIN32 )
            
            return InterlockedDecrement64( ( volatile LONGLONG * )value );
            
            #elif defined( __APPLE__ )
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return OSAtomicDecrement64( value );
            #pragma clang diagnostic pop
            
            #elif defined( __has_builtin ) && __has_builtin( __sync_add_and_fetch )
            
            return __sync_add_and_fetch( value, -1 );
            
            #else
            
            #error "ULog::Atomic::Decrement64 is not implemented for the current platform"
            
            #endif
        }

        bool CompareAndSwap32( int32_t oldValue, int32_t newValue, volatile int32_t * value )
        {
            #if defined( _WIN32 )
            
            return ( InterlockedCompareExchange( ( volatile LONG * )value, newValue, oldValue ) == oldValue ) ? true : false;
            
            #elif defined( __APPLE__ )
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return ( OSAtomicCompareAndSwap32( oldValue, newValue, value ) ) ? true : false;
            #pragma clang diagnostic pop
            
            #elif defined( __has_builtin ) && __has_builtin( __sync_bool_compare_and_swap )
            
            return __sync_bool_compare_and_swap( value, oldValue, newValue );
            
            #else
            
            #error "ULog::Atomic::CompareAndSwap32 is not implemented for the current platform"
            
            #endif
        }

        bool CompareAndSwap64( int64_t oldValue, int64_t newValue, volatile int64_t * value )
        {
            #if defined( _WIN32 )
            
            return ( InterlockedCompareExchange64( ( volatile LONGLONG * )value, newValue, oldValue ) == oldValue ) ? true : false;
            
            #elif defined( __APPLE__ )
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return ( OSAtomicCompareAndSwap64( oldValue, newValue, value ) ) ? true : false;
            #pragma clang diagnostic pop
            
            #elif defined( __has_builtin ) && __has_builtin( __sync_bool_compare_and_swap )
            
            return __sync_bool_compare_and_swap( value, oldValue, newValue );
            
            #else
            
            #error "ULog::Atomic::CompareAndSwap64 is not implemented for the current platform"
            
            #endif
        }

        bool CompareAndSwapPointer( void * oldValue, void * newValue, void * volatile * value )
        {
            #if defined( _WIN32 )
            
            return ( InterlockedCompareExchangePointer( value, newValue, oldValue ) == oldValue ) ? true : false;
            
            #elif defined( __APPLE__ )
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return ( OSAtomicCompareAndSwapPtr( oldValue, newValue, value ) ) ? true : false;
            #pragma clang diagnostic pop
            
            #elif defined( __has_builtin ) && __has_builtin( __sync_bool_compare_and_swap )
            
            return __sync_bool_compare_and_swap( value, oldValue, newValue );
            
            #else
            
            #error "ULog::Atomic::CompareAndSwapPointer is not implemented for the current platform"
            
            #endif
        }
    }
}
