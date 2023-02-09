
# Readme - Mandelbrot Set Zoomer Program - Version 0.5 - Alpha

## Installation

Note: To download .exe I will create a release as soon as I understand how it works ;)

1. Extract the content of the .zip file to a new folder.
2. Run MSZP.exe

The program will create its own folders when needed. (Data, Photos...)


## Changelog

### New in V 0.5
- Added Julia sets exploration and updated explorer functions to be compatible.
- Updated BMP Creation to work with new file paths and both modes. (Julia video mode has yet to be updated)
- Made it possible to create a BMP image from the explorer by pressing 'B'.
  Resolution choices and color profiles are the same as on the BMP creation page.
- Created an 'Elapsed time' function. (max 1 date change)
- Added a visual indicator of visor step size for targetting mode. (small white square in the center of the visor)
- Made it possible to increment C coordinates from explorer. (use arrow keys when not in targetting mode) (Julia only of course) [step fixed at 0.02 for now]
- Created a new color palette system along with a 'color-settings.txt' file to be able to edit palette and other settings. (loaded at the beginning of every BMP creation)
- Color profiles 1 & 2 are now using color palette.
  * 1 changes based on number of cycles to max iterations.
  * 2 changes based on length of cycle.
- Updated version numbers to be more *traditional*
- Updated BMP creation to support 4k/8k/16k/32k bitmaps!
- Added color gradient smoothing.
- Improved the fade in from black or white around the entire sets. (now custumizable from color-settings.txt)
- Added BMP information when creating it from the explorer.
- Added a controls page.
- Added option to change C coordinates step on Julia explorer. (Page up/down)
- Added an error message if file is not found.

### From V 0.1 to V 0.4:
- Added program icon and text in title bar.
- Modified the code to display the y axis correctly. (used to be inverted because y coordinates are inverted in SCREEN 12 in QBasic...)
  Wasn't much of a problem since the set is symetric vertically but the coordinates were negative upwards which bothered me and could be confusing!
- Blocked zooming after zoom level 25 because the image would get messed up after that. Would be even worse when creating a BMP.
- Added a 'Reset' command. (Press 'R')
- Updated the controls menu.
- Tried my best to use center of image coordinates + size of visible area instead of the old 'debutx', 'debuty' and 'pas' variables.
  They were annoying to work with and not instinctive.
- Made an array for the image inside the viewer (explorer), so as to correct incompatible old GPU commands, making the visor work properly again. (and facilitating color profile switching)
- Saved iterations count instead of pixel color inside image array. (to be able to swap color profiles without having to recreate the image everytime)
- Improved default color profile inside explorer. (toggle with old one by pressing 'F5', which can be useful for visibility sometimes)
  - The new color profile is based on the visible light spectrum and changes for every iteration.
  - Old color settings still available by pressing 'F5' comprised of 10 colors repeating every 10% of max iterations. (except for the first 16 iterations which are fixed: pixel color equals to QBasic color number of the iteration)
- Improved the column left of the explorer so it looks nicer and so it's more tolerant to changes.
- Improved resolution selection menu and added some options.
- Improved 'Video Mode 1' so it zooms in smoother and so the colors progress better. (added a zoom coefficient, so parameters update proportionally)
- Added parameters in folder and file names for a better experience.
- Added log file (data.txt) for same reason.
- Added some more options when creating a video, making it possible to continue an interupted video creation.
- Saved max iterations in files in 'Data' folder so they become the recommended value when creating a BMP or video. (or even when loading parameters in the explorer)
- Updated appearance of explorer page.
- Added a small crosshair in the explorer (Press H to toggle display)
- Display inputs and status messages somewhere more visible and convenient on the explorer page. (Status box)
- Updated grid display so it looks nicer and doesn't clutter the view.
- Updated visor display so it is easier to see and looks nicer.
- Added fullscreen functionality. (Toggle by pressing 'F' or 'F11' in menu or explorer)
- Added a zoom out functionality. (press 'Backspace')
- Created a 'Progress_bar' SUB and replaced existing ones.
  + added a new one for the explorer so we can clearly see where it's at.
  + added one showing the total progress of a video creation. (nb images)
- Made it so pressing 'Esc' while in targetting mode exits targetting mode.
- Enable fine tuning for visor. (use 'PageUp' and 'PageDown' to adjust visor step distance)
    - 20 px (default)
    - 10 px
    - 5 px

*Note: Still a few things to do... and some parts to redesign, but at least it 
mostly works now ! (even better than it used to actually...)*


## Folder / File architecture (not up to date)

### When saving parameters

When saving parameters or creating a BMP from the explorer a file is created inside the folder 'Mandelbrot' or 'Julia' located in the 'Data' folder with the name of your choosing.
Inside this file you will find the following information:
- x_coord (center x coordinate)
- y_coord (center y coordinate)
- view_size (size of the object of the image inside the set)
- nb_zoom (number of times you zoomed in to get to that point)
- max_iterations (max iterations set in explorer at the time of the save)
- xC (x coordinate of C) (Julia only)
- yC (y coordinate of C) (Julia only)

### When creating a BMP image:

When creating BMP files, they will be located inside the 'Mandelbrot' or 'Julia' folder located inside the 'Images' folder.
The name of each file will contain the following information:
- name
- max iterations (max)
- color profile (cp)
- resolution

### When creating a BMP video: (multiple BMP images)

When creating videos, the software will create one image after another.
It will create a folder inside the 'Mandelbrot' or 'Julia' folder located inside the "Videos" folder.
The name of each folder inside this folder will contain the following information:
- name
- video mode (vm)
- color profile (cp)

Then the software will create a series of BMP files inside the folder created specifically for the video.

Warning: Unlike when creating a single image (where choosing a different resolution, color profile or max iterations creates a different file), in video mode it will overwrite any existing files.

A log file called "data.txt" will be created in the same folder as the images if you wish to get the parameters to continue the video making process in case of any interuption. (or any other reason)
It will contain the following parameters :
- max_iterations_start
- max_iterations_end
- resolution
- color_settings


## Todo list

### ASAP

- Look into creating PNGs instead of BMPs. (size matters! xD)
- Make it possible to drag and drop a data file onto the .exe to auto-start BMP creation.
- Fix default parameters display when creating a BMPs from explorer.
- Add a preview button based on color profile.
- Fix video creation. (Julia)
- Add 'Elapsed time' to video creation.
- Add a video mode menu. (might not be necesarry)
- Make it possible to continue video creation by openning log file.
- Add an offset option for palette system in color-settings.txt.
- Create different display profiles for 'BMP Creation' function. (right now 
  using 'stealth modes')
- Make it possible to change zoom amount on targetting screen. (visor size)
- Change variable names to make them clearer and avoid using the same names. (and use DIM)
- Use _FLOAT variables to be able to zoom in further. (possibly?)

### Later

- Add the option to enter coordinates ? (not sure about that one...)
- Make BMPs videos from the explorer. (maybe not...)
- Add an 'About' section to talk a little bit about why I finished it so late 
  and why I even bothered. xD

## Notes

Disclaimer: Since this program is written in QBasic it can only use 1 CPU Thread to make calculations. (as far as I know...) 
I'm only working on it because this was my first software and it has sentimental value to me.
I want to see it finished.

If my AMD Ryzen 9 5900X was sentient, it probably would be frustrated as f*** ! xD

Now that this is said... have fun !