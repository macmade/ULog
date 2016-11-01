#!/bin/bash

make

if [ "$TRAVIS_OS_NAME" == "osx" ]; then
    
    xctool -project "ULog.xcodeproj" -scheme "ULog - Mac Framework" build
    xctool -project "ULog.xcodeproj" -scheme "ULog - Mac Static Library" build
    xctool -project "ULog.xcodeproj" -scheme "ULog - iOS Static Library" build
    xctool -project "Example-Mac.xcodeproj" -scheme "ULog Example - Mac" build
    xctool -project "Example-iOS.xcodeproj" -scheme "ULog Example - iOS" build
    
fi
