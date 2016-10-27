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
 * @file        main.cpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#include "stdafx.h"
#include <iostream>
#include <thread>
#include <Windows.h>
#include "../Example/CLog.h"
#include "../Example/CXXLog.hpp"

static void start( void );
static void start( void )
{
    int x;
    int i;

    i = 0;
    x = 1;

    while( 1 )
    {
        if( x % 2 == 0 )
        {
            CXXLog( &i );
        }
        else
        {
            CLog( &i );
        }

        x++;

        Sleep( 1000 );
    }
}

int main( void )
{
    std::cerr << "ULog Example - Win"
              << std::endl
              << std::endl
              << " - Press any key to start logging."
              << std::endl
              << " - Then press any key to exit."
              << std::endl
              << std::endl;

    getchar();

    {
        std::thread t
        (
            []()
            {
                start();
            }
        );

        t.detach();
    }

    getchar();

    return 0;
}

