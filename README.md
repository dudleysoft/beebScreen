# beebScreen library

This is the first official source release of the beebScreen library for the PiTubeDirect and ARM7TDMI co-processors for the BBC Microcomputer.

## Intro

This library provides a series of functions which link to the BBC Host and allow modern C coded applications and game to convert their video
output to a format that will display on the BBC Micro's screen, the library has grown from it's initial simple roots to it's current state
where it supports a lot of functionality to make down porting simple. It supports the VideoNULA if you have it which allows for 16 colours from
a full 12bit palette, or dithering down to the standard BBC palette (1bit RGB).

## Setup

The library is designed to be simple to use, dump your C project files into the folder, add them to **OBJ** list in the *Makefile*
Replace the video init/shutdown/flip functions in the project (most projects keep this stuff fairly encapsulated), replace the input handling
to use beebScreen to read the keyboard/mouse (yes beebScreen has mouse support if it uses the standard ADVAL 7,8 and 9 method and can be easily
modified to read the mouse coordinates directly from the standard memory location for the mouse in the host's RAM.)

The all you need to do is run **make**.

## Basics

Firstly call **beebScreen_Init** which takes the beeb video mode and init flags.

Next create a memory buffer (or use the one provided by the game), call **beebScreen_SetBuffer** to tell
beebScreen where the client video buffer is, currently only 8BPP is supported, along with the width and height
of the buffer (beebScreen automagically scales to the selected output resolution)

If you are using NULA then there are functions to convert the palette to a NULA palette, including reducing to a dynamic 16 colours
palette.

In the flip function simply call **beebScreen_Flip** and let beebScreen take care of everything for you, when this returns the BBC will
be displaying the contents of the current client display buffer on it's screen.

## Documentation

Look at beebScreen/beebScreen.h for details on all the functions and defines, a more detailed description of how to use the library will come
at a later point, for now you can take a look at https://github.com/dudleysoft/beebQuake/blob/master/vid_beeb.c for an example of how it's used in
a real life situation.
