'-----------------------------------------------------------------------
'                            Main Program
'-----------------------------------------------------------------------

DECLARE SUB Load_Color_Settings ()
DECLARE SUB Presentation ()
DECLARE SUB Clear_text ()
DECLARE SUB Show_parameters ()
DECLARE SUB Show_controls ()
DECLARE SUB Show_status ()
DECLARE SUB Progress_bar ()
DECLARE SUB BMPjulia () 'Obsolete
DECLARE SUB BMPmandelbrot () 'Obsolete
DECLARE SUB BMP_Creator ()
DECLARE SUB Get_pixel_color_BMP ()
DECLARE SUB GetRGBValues ()
DECLARE SUB Save_log ()
DECLARE SUB Resolution_select ()
DECLARE SUB BMP_color_profile_select ()
DECLARE SUB Explorer_create_image ()
DECLARE SUB Print_explorer_pixel()
DECLARE SUB Reload_explorer ()
DECLARE SUB Grid_display ()
DECLARE SUB Crosshair_display ()
DECLARE SUB Visor_display ()
DECLARE SUB Save_variables ()
DECLARE SUB Load_variables ()
DECLARE SUB Update_C ()

'Text inside software title bar
_Title "Mandelbrot Set Zoomer Program - 2023 - V0.5 - Alpha"

'Program icon - Must be in QB64 install folder (for some reason...)
$ExeIcon:'set.ico'

'Sets up graphics display of 640x480 pixels and a color depth of 16 colors
Screen 12

'-----------------------------------------------------------------------
'                              Main Menu
'-----------------------------------------------------------------------

'For viewer (preview image) inside software
explorer_width = 400
explorer_height = 400
DIM Image_array (explorer_width, explorer_height)

'Color palette
DIM palette_pos# (15) 'Position in cycle (from 0 to 1)
DIM palette_color (15, 3) '15 colors max for the moment - RGB values

Main_menu: '__________________________________________________ Main menu

'Reset all variables
numeroimage = 1
ni = 1
f = 1
precision_default = 250
C_step# = 0.02 'Default C step
Display_crosshair = 1 'To toggle crosshair display

Cls
Presentation

'load color settings and palette
Load_Color_Settings


mandelbrot_menu_height = 8
Locate mandelbrot_menu_height, 32: Color 15: Print "Mandelbrot Set"

Locate mandelbrot_menu_height + 2, 25: Color 15: Print "Press    to explore set"
Locate mandelbrot_menu_height + 2, 31: Color 2: Print "F1"

Locate mandelbrot_menu_height + 3, 25: Color 15: Print "Press    to create BMP image"
Locate mandelbrot_menu_height + 3, 31: Color 2: Print "F2"

Locate mandelbrot_menu_height + 4, 25: Color 15: Print "Press    to create BMP video" 'Video Mode 1 for now
Locate mandelbrot_menu_height + 4, 31: Color 2: Print "F3"

julia_menu_height = 15
Locate julia_menu_height, 34: Color 15: Print "Julia Sets"

Locate julia_menu_height + 2, 25: Color 15: Print "Press    to explore sets"
Locate julia_menu_height + 2, 31: Color 2: Print "F5"
Locate julia_menu_height + 2, 50: Color 14: Print "New!"

Locate julia_menu_height + 3, 25: Color 15: Print "Press    to create BMP image"
Locate julia_menu_height + 3, 31: Color 2: Print "F6"

Locate julia_menu_height + 4, 25: Color 15: Print "Press    to create BMP video"
Locate julia_menu_height + 4, 31: Color 4: Print "F7"

'Listen to keyboard and take action
Do
    w$ = InKey$

    'F1 - Explore Mandelbrot set
    If w$ = Chr$(0) + Chr$(59) Then
        mode$ = "Mandelbrot"
        'Old default parameters
        pas# = 4 / ROUND(explorer_height, 0) 'Only using the round function to convert variable to decimal (I get an error otherwise)
        debutx# = -2
        debuty# = -2
        'xp# = -2
        'yp# = -2

        'New default parameters
        x_coord# = 0
        y_coord# = 0
        view_size# = 4
        explorer_x_pos = 220 ' 0 < x < 279
        explorer_y_pos = 20 ' 0 < y < 79

        nbzoom = 0
        precision = precision_default

        color_profile = 1

        parameters_height = 7

        GoTo Label_explorer_page
    End If

    'F2 - Create BMP
    If w$ = Chr$(0) + Chr$(60) Then
        mode$ = "Mandelbrot"
        
        Load_Color_Settings

        GoSub Label_BMP_Creator_Page
        
        If file_error = 1 Then
            LOCATE 1, 1: Color 4: PRINT "File not found!"
        Else
            Locate 18, 11: Color 2: Print "Image created, press any key to return to the main menu"
        End If
        
        Do
            w$ = InKey$
        Loop Until w$ <> ""
        GoTo Main_menu
    End If

    'F3 - Create BMP video
    If w$ = Chr$(0) + Chr$(61) Then
        mode$ = "Mandelbrot"
       'GoSub Label_Video_Mode_2
        GoSub Label_Video_Mode_1
        
        If file_error = 1 Then
            LOCATE 1, 1: Color 4: PRINT "File not found!"
        Else
            Locate 18, 11: Color 2: Print "Images created, press any key to return to the main menu"
        End If

        Do
            w$ = InKey$
        Loop Until w$ <> ""
        GoTo Main_menu
    End If
    
    'F4
    'If w$ = Chr$(0) + Chr$(62) Then
    '    
    'End If

    'F5 - Explore Julia sets
    If w$ = Chr$(0) + Chr$(63) Then
        'Old default parameters
        pas# = 4 / ROUND(explorer_height, 0) 'Only using the round function to convert variable to decimal (I get an error otherwise)
        debutx# = -2
        debuty# = -2
        'xp# = -2
        'yp# = -2

        'New default parameters
        x_coord# = 0
        y_coord# = 0
        view_size# = 4
        explorer_x_pos = 220 ' 0 < x < 279
        explorer_y_pos = 20 ' 0 < y < 79

        nbzoom = 0
        precision = precision_default

        'Default C for Julia Explorer
        'xC# = -.53
        'yC# = -.5
        xC# = -0.512511498387847167
        yC# = 0.521295573094847167

        color_profile = 1

        mode$ = "Julia"
        parameters_height = 10

        GoTo Label_explorer_page
    End If

    'F6 - Create Julia BMP
    If w$ = Chr$(0) + Chr$(64) Then
        mode$ = "Julia"

        Load_Color_Settings
        
        GoSub Label_BMP_Creator_Page
        
        If file_error = 1 Then
            LOCATE 1, 1: Color 4: PRINT "File not found!"
        Else
            Locate 18, 11: Color 2: Print "Image created, press any key to return to the main menu"
        End If

        Do
            w$ = InKey$
        Loop Until w$ <> ""
        GoTo Main_menu
    End If

    'F7 - Create Julia BMP video - To remake completely
    If w$ = Chr$(0) + Chr$(65) Then
       mode$ = "Julia"
       'GoSub Label_Video_Mode_2
        GoSub Label_Video_Mode_1
        
        If file_error = 1 Then
            LOCATE 1, 1: Color 4: PRINT "File not found!"
        Else
            Locate 18, 11: Color 2: Print "Images created, press any key to return to the main menu"
        End If

        Do
            w$ = InKey$
        Loop Until w$ <> ""
        GoTo Main_menu
    End If

    'C - See controls
    If w$ = "c" Or w$ = "C" and mode$ = "Julia" Then
        Goto Label_controls_page
    End If

    'Toggle fullscreen (stretched)
    If w$ = "f" Or w$ = "F" Or w$ = Chr$(0) + Chr$(133) Then
        If Display_fullscreen = 1 Then
            Display_fullscreen = 0
            _FULLSCREEN
        Else
            Display_fullscreen = 1
            _FULLSCREEN off
        End If
    End If

    'Esc - Quit program
    If w$ = Chr$(27) Then
        Stop
    End If
Loop

'-----------------------------------------------------------------------
'                            Explorer Page
'-----------------------------------------------------------------------

Label_explorer_page: '____________________________________ Explorer page

Cls
Presentation

Explorer_create_image

Label_explorer_controls: '____________________________ Explorer controls

'Listen to keyboard and take action
Do
    w$ = InKey$

    'Esc - Goto main menu
    If w$ = Chr$(27) Then
        GoTo Main_menu
    End If

    'Save parameters
    If w$ = "s" Or w$ = "S" Then
        'File name input
        Show_status 2, 2, "Save parameters file as:", 15, "", 0
        Locate 5, 2: Color 2: Input file_name$

        Save_variables file_name$, x_coord#, y_coord#, view_size#, nbzoom, precision
    End If

    'Load parameters
    If w$ = "l" Or w$ = "L" Then
        Load_variables
    End If

    'Reset to default parameters
    If w$ = "r" Or w$ = "R" Then
        x_coord# = 0
        y_coord# = 0
        view_size# = 4
        precision = precision_default
        nbzoom = 0

        Explorer_create_image
    End If

    'Change max iterations
    If w$ = "m" Or w$ = "M" Then
        Update_max_iterations
    End If

    'Change C coordinates
    If (w$ = "c" Or w$ = "C") and mode$ = "Julia" Then
        Update_C
    End If

    'Create BMP from explorer
    If w$ = "b" Or w$ = "B" Then
        'Saves explorer parameters
        max_iterations_explorer = precision

        'Image name input
        Show_status 2, 2, "Image name:", 15, "", 0
        Locate 5, 2: Color 2: Input file_name$
        'file_name$ = "Preview" 'Forced for testing
        
        'Creates "Images" folders
        Shell "md Images"
        If mode$ = "Mandelbrot" Then
            Shell "md Images\Mandelbrot"
            mode_path$ = "Images/Mandelbrot/"
        ElseIf mode$ = "Julia" Then
            Shell "md Images\Julia"
            mode_path$ = "Images/Julia/"
        End If
        'mode_path$ = "Images/" 'Forced for preview - to delete

        'Max iterations input
        Show_status 2, 2, "Max iterations:", 15, "By default:" + Str$(precision), 7
        Locate 5, 2: Color 2: Input set_max_iterations
        If set_max_iterations > 2 Then
            precision = set_max_iterations
        End If

        'Color settings selection
        Show_status 2, 2, "Select color profile", 15, "Press F1 - F2", 14
        'color_settings = 2 'Forced for testing - to be replaced by inkey$
        Do
            w$ = InKey$

            If w$ = Chr$(0) + Chr$(59) Then 'F1
                color_settings = 1
            End If
        
            If w$ = Chr$(0) + Chr$(60) Then 'F2
                color_settings = 2
            End If
        
            If w$ = Chr$(27) Then 'Esc
                Stop
            End If
        Loop Until w$ <> ""
        

        If color_settings = 1 Then
            Show_status 2, 2, "Number of cycles:", 15, "By default: 1", 7
            Locate 5, 2: Color 2: Input user_input$
            cycles_nb# = VAL(user_input$)
            If cycles_nb# <= 0 or cycles_nb# > 10000 Then
                cycles_nb# = 1
                cycle_length = int(precision / cycles_nb#)
            Else
                cycle_length = int(precision / cycles_nb#)
            End If
        Elseif color_settings = 2 Then
            Show_status 2, 2, "Cycle length:", 15, "By default: " + RS$(precision), 7
            Locate 5, 2: Color 2: Input user_input$
            cycle_length = VAL(user_input$)
            If cycle_length <= 2 or cycle_length > 1000000 Then
               cycle_length = precision
            End If
        End If

        'Load color settings
        Load_Color_Settings

        'Resolution selection
        Show_status 2, 2, "Select resolution", 15, "Press F1 - F8", 14
        longueur = 0
        Do
            w$ = InKey$

            If w$ = Chr$(0) + Chr$(59) Then 'F1
                longueur = 1024
                hauteur = 768
            End If
        
            If w$ = Chr$(0) + Chr$(60) Then 'F2
                longueur = 1440
                hauteur = 900
            End If
        
            If w$ = Chr$(0) + Chr$(61) Then 'F3
                longueur = 1920
                hauteur = 1080
            End If
        
            If w$ = Chr$(0) + Chr$(62) Then 'F4
                longueur = 2560
                hauteur = 1440
            End If
        
            If w$ = Chr$(0) + Chr$(63) Then 'F5
                longueur = 3840
                hauteur = 2160
            End If

            If w$ = Chr$(0) + Chr$(64) Then 'F6
                longueur = 7680
                hauteur = 4320
            End If

            If w$ = Chr$(0) + Chr$(65) Then 'F7
                longueur = 15360
                hauteur = 8640
            End If

            If w$ = Chr$(0) + Chr$(66) Then 'F8
                longueur = 30720
                hauteur = 17280
            End If
        
            If w$ = Chr$(27) Then 'Esc
                Stop
            End If
        Loop Until longueur > 0

        
        full_file_name$ = file_name$ + " - " + RS$(precision) + "max - cp" + RS$(color_settings) + " - " + RS$(longueur) + "x" + RS$(hauteur) + ".bmp"
        file_path$ = mode_path$ + full_file_name$

        time_start = TIMER
        date_start$ = DATE$

        BMP_creator_stealth = 1

        'Saves Data file
        Save_variables file_name$, x_coord#, y_coord#, view_size#, nbzoom, precision

        'Show information box
        Show_bmp_information parameters_height + 8, 2

        'Creates BMP
        BMP_Creator

        'Reset parameters for explorer
        precision = max_iterations_explorer
        set_max_iterations = precision_default
    End If

    'F11 - Toggle fullscreen (stretched)
    If w$ = "f" Or w$ = "F" Or w$ = Chr$(0) + Chr$(133) Then
        If Display_fullscreen = 1 Then
            Display_fullscreen = 0
            _FULLSCREEN
        Else
            Display_fullscreen = 1
            _FULLSCREEN off
        End If
    End If

    'Toggle crosshair
    If w$ = "h" Or w$ = "H" Then
        If Display_crosshair = 1 Then
            Display_crosshair = 0
        Else
            Display_crosshair = 1
        End If

        'Reloads explorer
        Reload_explorer
    End If

    'F1 - See controls
    If w$ = Chr$(0) + Chr$(59) Then
        Show_controls 16, 2
    End If

    'F5 - Toggle color profiles
    If w$ = Chr$(0) + Chr$(63) Then
        nb_color_profiles = 2
        If color_profile < nb_color_profiles Then
            color_profile = color_profile + 1
        Else
            color_profile = 1
        End if

        'Reloads explorer
        Reload_explorer
    End If

    'Backspace - Zoom out
    If w$ = Chr$(8) Then
        If nbzoom > 1 Then
            view_size# = (view_size# / 120) * explorer_height
            nbzoom = nbzoom - 1
            GoTo Label_explorer_page
        ElseIf nbzoom = 1 Then
            x_coord# = 0
            y_coord# = 0
            view_size# = 4
            nbzoom = nbzoom - 1
            GoTo Label_explorer_page
        End If
    End If

    If w$ = Chr$(0) + Chr$(75) and mode$ = "Julia" Then 'Left arrow - Decrease xC
        xC# = xC# - C_step#
        Goto Label_explorer_page
    End If

    If w$ = Chr$(0) + Chr$(77) and mode$ = "Julia" Then 'Right arrow - Increase xC
        xC# = xC# + C_step#
        Goto Label_explorer_page
    End If

    If w$ = Chr$(0) + Chr$(72) and mode$ = "Julia" Then 'Down arrow - Decrease yC
        yC# = yC# - C_step#
        Goto Label_explorer_page
    End If

    If w$ = Chr$(0) + Chr$(80) and mode$ = "Julia" Then 'Up arrow - Increase yC
        yC# = yC# + C_step#
        Goto Label_explorer_page
    End If

    If w$ = Chr$(0) + Chr$(73) Then 'PageUp
        If C_step# < 0.1 Then
            C_step# = C_step# * 2
            Show_parameters 7, 2
        End If
    End If

    If w$ = Chr$(0) + Chr$(81) Then 'PageDown
        If C_step# > 0.00002 Then
            C_step# = C_step# / 2
            Show_parameters 7, 2
        End If
    End If

    'Makes sure we can't zoom after zoom 25
    If nbzoom > 24 and w$ = Chr$(13) Then
        Show_status 2, 2, "Zoom limit reached!", 14, "", 0
        w$ = ""
    End If
Loop Until w$ = Chr$(13)

'Coordinates of the center of the visor
visor_center_x = explorer_x_pos + explorer_width / 2
visor_center_y = explorer_y_pos + explorer_height / 2
visor_size = 120
visor_step = 20
x_moov# = 0
y_moov# = 0
pas# = view_size# / ROUND(explorer_height, 0)

Label_targetting: '__________________________________________ Targetting

    'Reloads explorer
    Reload_explorer
    'Grid_display
    Grid_display
    'Crosshair
    Crosshair_display 8, 7 'Size, color
    'Visor display
    Visor_display visor_center_x, visor_center_y, visor_size

    'Listen to keyboard and take action
    Do
        w$ = InKey$

        'Enter - Zoom in
        If w$ = Chr$(13) Then
            x_coord# = x_coord# + x_moov#
            y_coord# = y_coord# + y_moov#
            view_size# = (view_size# / explorer_height) * 120 '120 = visor width (could have used width or height since it's a square)
            nbzoom = nbzoom + 1
            GoTo Label_explorer_page
        End If

        'Backspace - Zoom out
        If w$ = Chr$(8) Then
            If nbzoom > 1 Then
                view_size# = (view_size# / 120) * explorer_height
                nbzoom = nbzoom - 1
                GoTo Label_explorer_page
            ElseIf nbzoom = 1 Then
                x_coord# = 0
                y_coord# = 0
                view_size# = 4
                nbzoom = nbzoom - 1
                GoTo Label_explorer_page
            End If
        End If

        'Save parameters
        If w$ = "s" Or w$ = "S" Then
            'File name input
            Show_status 2, 2, "Save parameters file as:", 15, "", 0
            Locate 5, 2: Color 2: Input file_name$

            Save_variables file_name$, x_coord#, y_coord#, view_size#, nbzoom, precision
        End If

        'F11 - Toggle fullscreen (stretched)
        If w$ = "f" Or w$ = "F" Or w$ = Chr$(0) + Chr$(133) Then
            If Display_fullscreen = 1 Then
                Display_fullscreen = 0
                _FULLSCREEN
            Else
                Display_fullscreen = 1
                _FULLSCREEN off
            End If
        End If

        If w$ = Chr$(0) + Chr$(75) Then 'Left arrow
            visor_center_x = visor_center_x - visor_step
            x_moov# = x_moov# - visor_step * pas#
            Goto Label_targetting
        End If

        If w$ = Chr$(0) + Chr$(77) Then 'Right arrow
            visor_center_x = visor_center_x + visor_step
            x_moov# = x_moov# + visor_step * pas#
            Goto Label_targetting
        End If

        If w$ = Chr$(0) + Chr$(72) Then 'Down arrow
            visor_center_y = visor_center_y - visor_step
            y_moov# = y_moov# + visor_step * pas#
            Goto Label_targetting
        End If

        If w$ = Chr$(0) + Chr$(80) Then 'Up arrow
            visor_center_y = visor_center_y + visor_step
            y_moov# = y_moov# - visor_step * pas#
            Goto Label_targetting
        End If

        If w$ = Chr$(0) + Chr$(73) Then 'PageUp
            If visor_step < 20 Then
                visor_step = visor_step * 2
            End If

            Goto Label_targetting
        End If

        If w$ = Chr$(0) + Chr$(81) Then 'PageDown
            If visor_step > 5 Then
                visor_step = visor_step / 2
            End If

            Goto Label_targetting
        End If

        'Esc - Gets out of targetting mode
        If w$ = Chr$(27) Then
            'Reloads explorer
            Reload_explorer
            GoTo Label_explorer_controls
        End If
    Loop
Return

'-----------------------------------------------------------------------
'                           BMP Creation Page
'-----------------------------------------------------------------------

Label_BMP_Creator_Page: '___________________________________ BMP Creator
    Cls
    Presentation
    Locate 14, 20: Color 15: Print "Image Name: "
    Locate 15, 20: Color 2: Print "This will be the name of the BMP file"
    Locate 14, 32: Color 2: Input file_name$ 'No more 8 character limit with QB64

    'Path selection
    If mode$ = "Mandelbrot" Then
        'Shell "md Data\Mandelbrot"
        mode_path$ = "Data/Mandelbrot/"
    ElseIf mode$ = "Julia" Then
        'Shell "md Data\Julia"
        mode_path$ = "Data/Julia/"
    End If

    If _FILEEXISTS(mode_path$ + file_name$ + ".txt") = 0 Then
        file_error = 1
        Return
    End If

    'Load parameters from file
    Open mode_path$ + file_name$ + ".txt" For Input As #1
        Input #1, x_coord#
        Input #1, y_coord#
        Input #1, view_size#
        Input #1, nbzoom
        Input #1, precision_default
        If mode$ = "Julia" Then
            Input #1, xC#
            Input #1, yC#
        End If
    Close #1

    Cls
    Presentation
    Locate 14, 20: Color 15: Print "Max iterations: "
    Locate 15, 20: Color 14: Print "By default:"; Str$(precision_default)
    Locate 14, 36: Color 2: Input precision
    If precision < 2 Then
        precision = precision_default
    End If

    'Color settings selection
    BMP_color_profile_select

    If color_settings = 1 Then
        Cls
        Presentation
        Locate 14, 20: Color 15: Print "Number of cycles: "
        Locate 15, 20: Color 15: Print "By default: 1"
        Locate 14, 41: Color 2: Input user_input$
        
        cycles_nb# = VAL(user_input$)
        If cycles_nb# <= 0 or cycles_nb# > 10000 Then
            cycles_nb# = 1
            cycle_length = int(precision / cycles_nb#)
        Else
            cycle_length = int(precision / cycles_nb#)
        End If
    Elseif color_settings = 2 Then
        Cls
        Presentation
        Locate 14, 20: Color 15: Print "Cycle length: "
        Locate 15, 20: Color 15: Print "By default: " + RS$(precision)
        Locate 14, 34: Color 2: Input user_input$
        
        cycle_length = VAL(user_input$)
        If cycle_length <= 2 or cycle_length > 1000000 Then
            cycle_length = precision
        End If
    End If

    'Load color settings
    Load_Color_Settings

    'Resolution selection
    Resolution_select

    'Creates "Images" folders
    Shell "md Images"
    If mode$ = "Mandelbrot" Then
        Shell "md Images\Mandelbrot"
        mode_path$ = "Images/Mandelbrot/"
    ElseIf mode$ = "Julia" Then
        Shell "md Images\Julia"
        mode_path$ = "Images/Julia/"
    End If

    full_file_name$ = file_name$ + " - " + RS$(precision) + "max - cp" + RS$(color_settings) + " - " + RS$(longueur) + "x" + RS$(hauteur) + ".bmp"
    file_path$ = mode_path$ + full_file_name$

    time_start = TIMER
    date_start$ = DATE$

    BMP_creator_stealth = 0

    BMP_Creator

    'Reset variables
    precision_default = 250
    xC# = -0.512511498387847167
    yC# = 0.521295573094847167
Return

'-----------------------------------------------------------------------
'                       Mandelbrot - Video Mode 1 [Important]
'-----------------------------------------------------------------------

Label_Video_Mode_1: '______________________________________ Video Mode 1
    Cls
    Presentation
    If error1 = 1 Then
        Locate 16, 20: Color 4: Print "Need data file name to create video"
    End If
    Locate 14, 20: Color 15: Print "Data file name: "
    Locate 14, 36: Color 2: Input video_name$ 'No more 8 character limit with QB64
    If video_name$ = "" Then
        error1 = 1
        GoTo Label_Video_Mode_1
    End If

    'Path selection
    If mode$ = "Mandelbrot" Then
        'Shell "md Data\Mandelbrot"
        mode_path$ = "Data/Mandelbrot/"
    ElseIf mode$ = "Julia" Then
        'Shell "md Data\Julia"
        mode_path$ = "Data/Julia/"
    End If

    If _FILEEXISTS(mode_path$ + video_name$ + ".txt") = 0 Then
        file_error = 1
        Return
    End If

    'Loads data from file about target image ("pas" calculated for 200x200 image)
    Open mode_path$ + video_name$ + ".txt" For Input As #1
        Input #1, x_coord_end#
        Input #1, y_coord_end#
        Input #1, view_size_end#
        Input #1, nbzoom
        Input #1, precision_default
    Close #1

    CLS
    Presentation
    Locate 14, 20: Color 15: Print "Starting max iterations: "
    Locate 15, 20: Color 14: Print "By default: 2"
    Locate 14, 45: Color 2: Input precision_min
    If precision_min < 2 or precision_min > precision_max Then
        precision_min = 2
    End If

    CLS
    Presentation
    Locate 14, 20: Color 15: Print "End max iterations: "
    Locate 15, 20: Color 14: Print "By default:"; Str$(precision_default)
    Locate 14, 40: Color 2: Input precision_max
    If precision_max < 2 Then
        precision_max = precision_default
    End If

    Cls
    Presentation
    Locate 14, 20: Color 15: Print "Nb images: "
    Locate 15, 20: Color 15: Print "2 < nb images < 5000"
    Locate 14, 31: Color 2: Input ni
    If ni < 2 Or ni > 5000 Then
        ni = 2
    End If

    Cls
    Presentation
    Locate 14, 20: Color 15: Print "Start from image nb: "
    Locate 15, 20: Color 15: Print "By default: 1"
    Locate 14, 41: Color 2: Input first_image_nb
    If first_image_nb < 2 Or first_image_nb > ni Then
        first_image_nb = 1
    End If

    'Color settings selection
    BMP_color_profile_select

    If color_settings = 1 Then
        Cls
        Presentation
        Locate 14, 20: Color 15: Print "Number of cycles: "
        Locate 15, 20: Color 15: Print "By default: 1"
        Locate 14, 41: Color 2: Input user_input$
        
        cycles_nb# = VAL(user_input$)
        If cycles_nb# <= 0 or cycles_nb# > 10000 Then
            cycles_nb# = 1
            cycle_length = int(precision_max / cycles_nb#)
            'cycle_length = int(precision / cycles_nb#)
        Else
            cycle_length = int(precision_max / cycles_nb#)
            'cycle_length = int(precision / cycles_nb#)
        End If
    Elseif color_settings = 2 Then
        'Show_status 2, 2, "Cycle length:", 15, "By default: " + RS$(precision), 7
        'Locate 5, 2: Color 2: Input user_input$
        
        Cls
        Presentation
        Locate 14, 20: Color 15: Print "Cycle length: "
        Locate 15, 20: Color 15: Print "By default: " + RS$(precision_max)
        Locate 14, 34: Color 2: Input user_input$
        
        cycle_length = VAL(user_input$)
        If cycle_length <= 2 or cycle_length > 1000000 Then
            cycle_length = precision_max
        End If
    End If

    'Load color settings
    Load_Color_Settings

    'Resolution selection
    Resolution_select

    precision = precision_min

    'Initiate variables
    x_coord# = 0
    y_coord# = 0
    view_size# = 4
    view_size_start# = 4
    time_start = TIMER
    date_start$ = DATE$

    'To delete once I've managed video modes
    video_mode = 1

    'Creates the "Video" directory if needed - No check but seems to work...
    Shell "md Videos"
    If mode$ = "Mandelbrot" Then
        Shell "md Videos\Mandelbrot"
        mode_path$ = "Videos/Mandelbrot/"
    ElseIf mode$ = "Julia" Then
        Shell "md Videos\Julia"
        mode_path$ = "Videos/Julia/"
    End If

    full_folder_path$ = mode_path$ + video_name$ + " - vm" + RS$(video_mode) + " - cp" + RS$(color_settings)
    Shell "md " + chr$(34) + full_folder_path$ + chr$(34)

    'Saves log file
    Save_log full_folder_path$

    precision_range = precision_max - precision_min

    'w# = zoom coeficient
    w# = (view_size_start# / view_size_end#) ^ (1 / (ni - 1))

    'Information display setting
    BMP_creator_stealth = 0

    'Discards first image when necesarry
    If first_image_nb > 1 Then
        first_image_nb = first_image_nb - 1
        discard_first = 1
    Else
        discard_first = 0
    End If

    For f = first_image_nb To ni
        'Creates file name
        num$ = Str$(f)
        num$ = Right$(num$, Len(num$) - 1)
        num$ = Right$("000000" + num$, 6)
        imagename$ = full_folder_path$ + "/I-" + num$
        full_file_name$ = imagename$ + ".bmp"
        file_path$ = full_file_name$

        'Calculates max iterations
        a# = (f - 1) / (ni - 1)
        a# = (exp(a#) - 1) / (exp(1) - 1)
        precision = int(precision_min + precision_range * a#)

        'Discards first image when necesarry, creates image otherwise
        If f = first_image_nb and discard_first = 1 Then
            'Nothing here
        Else
            BMP_Creator
        End If

        'New parameters
        view_size# = view_size_start# / (w# ^ f)
        x_coord# = x_coord_end# * (1 - (1 / w# ^ f))
        y_coord# = y_coord_end# * (1 - (1 / w# ^ f))
    Next f

    'Reset variables
    precision_default = 250
Return

'-----------------------------------------------------------------------
'                         Julia - Video Mode 1
'-----------------------------------------------------------------------

videobmpjuliasp1:
    Cls
    Presentation
    If error1 = 1 Then
        Locate 16, 20: Color 4: Print "Need video name to create folder"
    End If
    Locate 14, 20: Color 15: Print "Video name: "
    Locate 14, 31: Color 2: Input video_name$ 'No more 8 character limit with QB64
    If video_name$ = "" Then
        error1 = 1
        GoTo videobmpjuliasp1
    End If

    Cls
    Presentation
    Locate 14, 20: Color 15: Print "Max iterations: "
    Locate 15, 20: Color 14: Print "By default:"; Str$(precision_default)
    Locate 14, 36: Color 2: Input precision
    If precision < 2 Then
        precision = precision_default
    End If

    Cls
    Presentation
    Locate 14, 20: Color 15: Print "Nb images: "
    Locate 14, 39: Color 15: Print "2 < nb images < 5000"
    Locate 14, 31: Color 2: Input ni
    If ni < 2 Or ni > 5000 Then
        ni = 2
    End If

    pas# = .01
    debutx# = -2
    debuty# = -2

    debutx# = debutx# - .6 * (pas# / .01)
    debuty# = debuty# + .08 * (pas# / .01)
    pas# = pas# / 2

    longueur = 1024
    hauteur = 768

    xC# = 0
    yC# = 0

    Shell "md " + video_name$

    For f = 1 To ni
        num$ = Str$(f)
        num$ = Right$(num$, Len(num$) - 1)
        num$ = Right$("0000" + num$, 4)
        imagename$ = video_name$ + "/I-" + num$
        name$ = "Videos/" + imagename$ + ".bmp"
        BMPjulia
        xC# = xC# - .008
    Next f
Return

'-----------------------------------------------------------------------
'                            Controls Page - Todo
'-----------------------------------------------------------------------

Label_controls_page: '____________________________________ Controls page
    Cls
    Presentation

    menu_top_margin = 4
    menu_left_margin = 6

    Locate menu_top_margin, menu_left_margin + 30: Color 15: Print "Controls"

    Locate menu_top_margin + 3, menu_left_margin: Color 15: Print "Press       to target / zoom in"
    Locate menu_top_margin + 3, menu_left_margin + 6: Color 2: Print "ENTER"

    Locate menu_top_margin + 4, menu_left_margin: Color 15: Print "Press           to zoom out"
    Locate menu_top_margin + 4, menu_left_margin + 6: Color 2: Print "BACKSPACE"

    Locate menu_top_margin + 5, menu_left_margin: Color 15: Print "Press            to aim / change C coord (Julia, when not targetting)"
    Locate menu_top_margin + 5, menu_left_margin + 6: Color 2: Print "Arrow keys"

    Locate menu_top_margin + 6, menu_left_margin: Color 15: Print "Press              to change targetting step / change C step"
    Locate menu_top_margin + 6, menu_left_margin + 6: Color 2: Print "PAGE UP/DOWN"

    Locate menu_top_margin + 7, menu_left_margin: Color 15: Print "Press   to save parameters"
    Locate menu_top_margin + 7, menu_left_margin + 6: Color 2: Print "S"

    Locate menu_top_margin + 8, menu_left_margin: Color 15: Print "Press   to load parameters"
    Locate menu_top_margin + 8, menu_left_margin + 6: Color 2: Print "L"

    Locate menu_top_margin + 9, menu_left_margin: Color 15: Print "Press   to reset"
    Locate menu_top_margin + 9, menu_left_margin + 6: Color 2: Print "R"

    Locate menu_top_margin + 10, menu_left_margin: Color 15: Print "Press   to set max parameters"
    Locate menu_top_margin + 10, menu_left_margin + 6: Color 2: Print "M"

    Locate menu_top_margin + 11, menu_left_margin: Color 15: Print "Press   to create a BMP"
    Locate menu_top_margin + 11, menu_left_margin + 6: Color 2: Print "B"

    Locate menu_top_margin + 12, menu_left_margin: Color 15: Print "Press   to fullscreen"
    Locate menu_top_margin + 12, menu_left_margin + 6: Color 2: Print "F"

    Locate menu_top_margin + 13, menu_left_margin: Color 15: Print "Press   to set C coordinates"
    Locate menu_top_margin + 13, menu_left_margin + 6: Color 2: Print "C"

    Locate 26, 20: Color 2: Print "Press any key to return to the main menu"

    Do
        w$ = InKey$
    Loop Until w$ <> ""

    GoTo Main_menu
RETURN

'-----------------------------------------------------------------------
'                            Included files
'-----------------------------------------------------------------------

'QB64 needs the following lines to be commented (do not uncomment!)

'SUBs files
'$INCLUDE: 'bmp-subs.bas'
'$INCLUDE: 'other-subs.bas'

'Functions files
'$INCLUDE: 'functions.bas'