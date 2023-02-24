ULog
====

[![Build Status](https://img.shields.io/github/actions/workflow/status/macmade/ULog/ci-mac.yaml?label=macOS&logo=apple)](https://github.com/macmade/ULog/actions/workflows/ci-mac.yaml)
[![Build Status](https://img.shields.io/github/actions/workflow/status/macmade/ULog/ci-win.yaml?label=Windows&logo=windows)](https://github.com/macmade/ULog/actions/workflows/ci-win.yaml)
[![Issues](http://img.shields.io/github/issues/macmade/ULog.svg?logo=github)](https://github.com/macmade/ULog/issues)
![Status](https://img.shields.io/badge/status-active-brightgreen.svg?logo=git)
![License](https://img.shields.io/badge/license-mit-brightgreen.svg?logo=open-source-initiative)  
[![Contact](https://img.shields.io/badge/follow-@macmade-blue.svg?logo=twitter&style=social)](https://twitter.com/macmade)
[![Sponsor](https://img.shields.io/badge/sponsor-macmade-pink.svg?logo=github-sponsors&style=social)](https://github.com/sponsors/macmade)

Table of Contents
-----------------

 1. [About](#1)
     1. [Motivation](#1-1)
     2. [Features](#1-2)
     3. [Customisation](#1-3)
 2. [Usage](#2)
 3. [Building ULog](#3)
     1. [macOS / iOS](#3-1)
     2. [Unix / Linux](#3-2)
     3. [Windows](#3-3)
 4. [License](#4)
 5. [Repository Infos](#5)

<a name="1"></a>
1 - About
---------

ULog is a unified cross-platform logging framework for C, C++, Objective-C, Swift, C# and ASL.

<a name="1-1"></a>
### 1.1 - Motivation

...

<a name="1-2"></a>
### 1.2 - Features

#### 1.2.1 - Cross-Platform

...

#### 1.2.2 - Thread Safety

...

### 1.2.3 - Graphical Interface

...

#### 1.2.4 - Customisation

...

<a name="1-3"></a>
### 1.3 - Customisation

...

<a name="2"></a>
2 - Usage
---------

...

<a name="3"></a>
3 - Building ULog
-----------------

<a name="3-1"></a>
### 3.1 - macOS / iOS

An Xcode project is provided, containing the following targets:

 - **`ULog.framework`**: macOS framework
 - **`ULog.a`**: macOS static library
 - **`ULog-iOS.a`** iOS static library
   
_Note that the ULog GUI is only available for macOS at the moment._

If using the static library on macOS, please include the following XIB files in your target application:

 - `ULogLogWindowController.xib`
 - `ULogSettingsWindowController.xib`****
   
<a name="3-2"></a>
### 3.2 - Unix / Linux

Use the provided makefile, with the `make` command.  
A static library and a dynamic library will be build for the current architecture:

 - **`libulog.a`**: static library
 - **`libulog.so`**: dynamic library

_Note that the ULog GUI is not available for Unix / Linux at the moment._

<a name="3-3"></a>
### 3.3 - Windows

A VisualStudio solution is provided, containing the following projects:

 - **`ULog_Static_V140XP`**: VS 2015 static library with XP support
 - **`ULog_Static_V120XP`**: VS 2013 static library with XP support
 - **`ULog_DLL_V140XP`**: VS 2015 DLL with XP support
 - **`ULog_DLL_V120XP`**: VS 2013 DLL with XP support

_Note that the ULog GUI is not available for Windows at the moment._

<a name="4"></a>
4 - License
-----------

ULog is released under the terms of the MIT License.

<a name="5"></a>
5 - Repository Infos
--------------------

    Owner:			Jean-David Gadina - XS-Labs
    Web:			www.xs-labs.com
    Blog:			www.noxeos.com
    Twitter:		@macmade
    GitHub:			github.com/macmade
    LinkedIn:		ch.linkedin.com/in/macmade/
    StackOverflow:	stackoverflow.com/users/182676/macmade
