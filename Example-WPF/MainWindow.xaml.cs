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
 * @file        MainWindow.xaml.cs
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

using System.Windows;

namespace ULog.WPF
{
    public partial class MainWindow: Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void _StartStop( object sender, RoutedEventArgs e )
        {
            this.Started = ( this.Started ) ? false : true;
        }

        public static DependencyProperty StartedProperty = DependencyProperty.Register
        (
            "Started",
            typeof( bool ),
            typeof( MainWindow ),
            new PropertyMetadata
            (
                false,
                ( o, e ) =>
                {
                    MainWindow w;

                    w = o as MainWindow;

                    if( w == null )
                    {
                        return;
                    }

                    if( ( bool )( e.NewValue ) )
                    {
                        System.Console.WriteLine( "Starting logs..." );
                    }
                    else
                    {
                        System.Console.WriteLine( "Stopping logs..." );
                    }
                }
            )
        );

        public bool Started
        {
            get
            {
                return ( bool )GetValue( StartedProperty );
            }

            set
            {
                SetValue( StartedProperty, value );
            }
        }
    }
}
