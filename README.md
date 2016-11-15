# KiSS

Kingdom Hall Sound System

## Description
 
1. Manage different audio input:
    - all microphones on Hall (connected via multiplexer)
    - playback Kingdom Melodies (local files)
2. Broadcast selected input: 
    - send signal on speakers
    - record to file 

Application use VLC library. Goal of this project is to write apropriate interface to use on Kingdom Hall. Selected technology is Qt5 QML.

## Repository structure

* *conf* configuration files needed for app (epected to be next to application binary)
* *kiss-light* version of UI build with QtWidgets (doesn't require OpenGL support)
* *kiss-qml* main version of UI base on QtQuick (needs OpenGL support in OS)
* *plugin* library based on libVLC providing all backend functionality 


## Troubleshooting

1. **After building against new version of Qt program crash with info:** QMetaType::registerType: Binary compatibility break -- Size mismatch for type 'QPaintBufferCacheEntry' [1024]. Previously registered size 16, now registering size 0.
This is because VLC library uses Qt as well. In order to fix this you have to rebuild VLC plugins with new Qt version. You must:
  1. find vlc/plugins/plugins.dat file (on linux in /usr/lib)
  2. remove it and generate new with using vlc-cache-gen: 
~~~
cd /usr/lib/vlc
rm plugins/plugins.dat
./vlc-cache-gen plugins
~~~