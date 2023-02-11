'-----------------------------------------------------------------------
'        This file contains all SUBs that are not BMP related
'-----------------------------------------------------------------------

'Creates a footnote at the bottom of the window
Sub Presentation
    Locate 30, 2: Color 15: Print "Created by:";
    Locate 30, 14: Color 2: Print "Anthony Vallad";
    Locate 30, 56: Color 15: Print "V.";
    Locate 30, 59: Color 1: Print "2023 - V0.5.1 - Alpha";
End Sub

'Clears area to black
Sub Clear_text (y_pos, x_pos, width, height)
    line$=""

    For f = 1 to width
        Line$ = line$ + " "
    Next f

    For f = y_pos to y_pos + height - 1
        LOCATE f, x_pos: Color 4: Print Line$
    Next f
End Sub

'Shows the list of keyboard controls
Sub Show_parameters (y_pos, x_pos)
    Shared mode$, precision, view_size#, x_coord#, y_coord#, nbzoom, parameters_height, xC#, yC#, C_step#

    Clear_text y_pos, x_pos, 28 - x_pos, parameters_height

    zoom = 4 / view_size# '4 = default view_size

    'Title
    Locate y_pos + 0, x_pos: Color 15: Print "       Parameters"
    Locate y_pos + 1, x_pos: Color 8: Print "_________________________"

    'Content
    If mode$ = "Mandelbrot" Then
        Locate y_pos + 2, x_pos: Color 15: Print "x:"
        Locate y_pos + 2, x_pos + 3: Color 2: Print RS$(x_coord#)
        Locate y_pos + 3, x_pos: Color 15: Print "y:"
        Locate y_pos + 3, x_pos + 3: Color 2: Print RS$(y_coord#)
        Locate y_pos + 4, x_pos: Color 15: Print "Max iterations:"
        Locate y_pos + 4, x_pos + 16: Color 2: Print RS$(precision)
        Locate y_pos + 5, x_pos: Color 15: Print "Zoom:"
        Locate y_pos + 5, x_pos + 6: Color 2: Print "x"; RS$(zoom)
        Locate y_pos + 6, x_pos: Color 15: Print "Zoomed    times."
        Locate y_pos + 6, x_pos + 7: Color 2: Print RS$(nbzoom)
    ElseIf mode$ = "Julia" Then
        Locate y_pos + 2, x_pos: Color 15: Print "xC:"
        Locate y_pos + 2, x_pos + 4: Color 2: Print RS$(xC#)
        Locate y_pos + 3, x_pos: Color 15: Print "yC:"
        Locate y_pos + 3, x_pos + 4: Color 2: Print RS$(yC#)
        Locate y_pos + 4, x_pos: Color 15: Print "C step:"
        Locate y_pos + 4, x_pos + 8: Color 2: Print RS$(C_step#)
        Locate y_pos + 5, x_pos: Color 15: Print "x:"
        Locate y_pos + 5, x_pos + 3: Color 2: Print RS$(x_coord#)
        Locate y_pos + 6, x_pos: Color 15: Print "y:"
        Locate y_pos + 6, x_pos + 3: Color 2: Print RS$(y_coord#)
        Locate y_pos + 7, x_pos: Color 15: Print "Max iterations:"
        Locate y_pos + 7, x_pos + 16: Color 2: Print RS$(precision)
        Locate y_pos + 8, x_pos: Color 15: Print "Zoom:"
        Locate y_pos + 8, x_pos + 6: Color 2: Print "x"; RS$(zoom)
        Locate y_pos + 9, x_pos: Color 15: Print "Zoomed    times."
        Locate y_pos + 9, x_pos + 7: Color 2: Print RS$(nbzoom)
    End If
End Sub

'Shows BMP creation information
Sub Show_bmp_information (y_pos, x_pos)
    Shared mode$, file_name$, color_settings, longueur, hauteur, precision, cycles_nb#, cycle_length, parameters_height, xC#, yC#

    Clear_text y_pos, x_pos, 28 - x_pos, parameters_height

    zoom = 4 / view_size# '4 = default view_size

    'Title
    Locate y_pos + 0, x_pos: Color 15: Print "     BMP Information"
    Locate y_pos + 1, x_pos: Color 8: Print "_________________________"

    'Content
    Locate y_pos + 2, x_pos: Color 15: Print "Name:"
    Locate y_pos + 2, x_pos + 6: Color 2: Print file_name$
    Locate y_pos + 3, x_pos: Color 15: Print "Max iterations:"
    Locate y_pos + 3, x_pos + 16: Color 2: Print RS$(precision)
    Locate y_pos + 4, x_pos: Color 15: Print "Color profile:"
    Locate y_pos + 4, x_pos + 15: Color 2: Print RS$(color_settings)
    If color_settings = 1 Then
        Locate y_pos + 5, x_pos: Color 15: Print "Nb cycles:"
        Locate y_pos + 5, x_pos + 11: Color 2: Print RS$(cycles_nb#)
    ElseIf color_settings = 2 Then
        Locate y_pos + 5, x_pos: Color 15: Print "Cycle length:"
        Locate y_pos + 5, x_pos + 14: Color 2: Print RS$(cycle_length)
    End If
    Locate y_pos + 6, x_pos: Color 15: Print "Resolution:"
    Locate y_pos + 6, x_pos + 12: Color 2: Print RS$(longueur); "x" ;RS$(hauteur)
End Sub

'Shows the list of keyboard controls
Sub Show_controls (y_pos, x_pos)
    Clear_text y_pos, x_pos, 28 - x_pos, 28 - y_pos

    'Title
    Locate y_pos + 0, x_pos: Color 15: Print "        Controls"
    Locate y_pos + 1, x_pos: Color 8: Print "_________________________"

    'Content
    Locate y_pos + 2, x_pos: Color 15: Print "      to target / zoom in"
    Locate y_pos + 2, x_pos: Color 2: Print "ENTER"
    Locate y_pos + 3, x_pos: Color 15: Print "       to zoom out"
    Locate y_pos + 3, x_pos: Color 2: Print "BACKSP"
    Locate y_pos + 4, x_pos: Color 15: Print "    to return to menu"
    Locate y_pos + 4, x_pos: Color 2: Print "ESC"
    Locate y_pos + 5, x_pos: Color 15: Print "  to save parameters"
    Locate y_pos + 5, x_pos: Color 2: Print "S"
    Locate y_pos + 6, x_pos: Color 15: Print "  to load parameters"
    Locate y_pos + 6, x_pos: Color 2: Print "L"
    Locate y_pos + 7, x_pos: Color 15: Print "  to set max iterations"
    Locate y_pos + 7, x_pos: Color 2: Print "M"
    Locate y_pos + 8, x_pos: Color 15: Print "  to reset all parameters"
    Locate y_pos + 8, x_pos: Color 2: Print "R"
    Locate y_pos + 9, x_pos: Color 15: Print "  toggle crosshair display"
    Locate y_pos + 9, x_pos: Color 2: Print "H"
    Locate y_pos + 10, x_pos: Color 15: Print "  toggle fullscreen"
    Locate y_pos + 10, x_pos: Color 2: Print "F"
    Locate y_pos + 11, x_pos: Color 15: Print "   toggle color profiles"
    Locate y_pos + 11, x_pos: Color 2: Print "F5"
End Sub

'Shows the list of keyboard controls
Sub Show_status (y_pos, x_pos, line_1$, color_1, line_2$, color_2)

    Clear_text y_pos, x_pos, 28 - x_pos, 4

    'Title
    Locate y_pos + 0, x_pos: Color 15: Print "         Status"
    Locate y_pos + 1, x_pos: Color 8: Print "_________________________"

    'Content
    Locate y_pos + 2, x_pos: Color color_1: Print line_1$
    Locate y_pos + 3, x_pos: Color color_2: Print line_2$
End Sub

Sub Progress_bar (progress_bar_x_pos, progress_bar_y_pos, progress_bar_length, progress_bar_height, value_target, value_current)
    progress_bar_color_loading = 14
    progress_bar_color_finished = 2
    
    'Clear area
    Line (progress_bar_x_pos, progress_bar_y_pos) - (progress_bar_x_pos + progress_bar_length, progress_bar_y_pos + progress_bar_height), 0, BF

    'Vertical lines
    Line (progress_bar_x_pos, progress_bar_y_pos)-(progress_bar_x_pos, progress_bar_y_pos + progress_bar_height), 15
    Line (progress_bar_x_pos + progress_bar_length, progress_bar_y_pos)-(progress_bar_x_pos + progress_bar_length, progress_bar_y_pos + progress_bar_height), 15

    'Progress bar
    progress_bar_status = value_current / value_target
    progress_bar_status_length = progress_bar_x_pos + progress_bar_length * progress_bar_status

    'Makes sure it doesn't bleed to the left when starting
    If progress_bar_length * progress_bar_status < 2 Then
        progress_bar_status_length = progress_bar_status_length + 2
    End If

    If progress_bar_status < 1 Then
        Line (progress_bar_x_pos + 1, progress_bar_y_pos + 1) - (progress_bar_status_length - 1, progress_bar_y_pos + progress_bar_height - 1), progress_bar_color_loading, BF
    Else
        Line (progress_bar_x_pos + 1, progress_bar_y_pos + 1) - (progress_bar_status_length - 1, progress_bar_y_pos + progress_bar_height - 1), progress_bar_color_finished, BF
    End If
End Sub

'Create/display image inside explorer
Sub Explorer_create_image
    Shared viewing_name$, mode$, Display_crosshair, explorer_x_pos, explorer_y_pos, precision, explorer_height, x_coord#, y_coord#, view_size#, xC#, yC#, Image_array()
    Shared parameters_height

    time_start = TIMER
    date_start$ = DATE$

    'Left colums
    Show_status 2, 2, "Creating image...", 14, "", 0
    Show_parameters 7, 2

    'Display name
    Clear_text 1, 29, 50, 1
    Locate 28, 29: Color 15: Print "Exploring:"
    If mode$ = "Mandelbrot" Then
        Locate 28, 40: Color 2: Print "The Mandelbrot Set"
    ElseIf mode$ = "Julia" Then
        Locate 28, 40: Color 2: Print "Julia's Sets"
    End If

    'Starting coordinates (in pixels)
    x = explorer_x_pos
    y = explorer_y_pos + explorer_height

    'Convert to old variables for calculations
    pas# = view_size# / 400
    debutx# = x_coord# - 200 * pas#
    debuty# = y_coord# - 200 * pas#

    'Grey frame around viewer with an offset of 1 extruding (before image is created)
    Line (explorer_x_pos - 1, explorer_y_pos - 1)-(explorer_x_pos + 401, explorer_y_pos + 401), 8, B

    'Image creation
    If mode$ = "Mandelbrot" Then
        xC# = debutx# 'C points a traiter
        Do
            yC# = debuty#
            Do
                'y = y - 1
                C = 0 'Compteur de boucles (max = precision)
                flag = 0 'Sortie du cercle de rayon 2
                x1# = 0 'Coordonnees de z0
                y1# = 0
                Do
                    x2# = x1# * x1# - y1# * y1# + xC# 'Coordonnees de z2+C
                    y2# = 2 * x1# * y1# + yC#
                    If x2# * x2# + y2# * y2# > 4 Then flag = 1
                    x1# = x2#
                    y1# = y2#
                    C = C + 1
                Loop Until C = precision Or flag = 1

                'Draws pixel
                Print_explorer_pixel x, y, C

                'Saves pixel to array
                array_x = x - explorer_x_pos
                array_y = explorer_y_pos + explorer_height - y
                Image_array(array_x, array_y) = C

                y = y - 1
                yC# = yC# + pas#
            Loop Until y = explorer_y_pos -1
            x = x + 1
            y = explorer_y_pos + explorer_height
            xC# = xC# + pas#

            'Progress bar
            Progress_bar 10, 65, 195, 6, explorer_x_pos + 401 - explorer_x_pos, x - explorer_x_pos

            'Old progress bar
            'Progress_bar explorer_x_pos - 1, explorer_y_pos + explorer_height + 10, explorer_height + 2, 10, explorer_x_pos + 401 - explorer_x_pos, x - explorer_x_pos
        Loop Until x = explorer_x_pos + 401
    ElseIf mode$ = "Julia" Then
        xcal# = debutx#
        Do
            ycal# = debuty#
            Do
                'y = y - 1
                C = 0 'Compteur de boucles (max = precision)
                flag = 0 'Sortie du cercle de rayon 2
                x1# = xcal# 'Coordonnees de z0
                y1# = ycal#
                Do
                    x2# = x1# * x1# - y1# * y1# + xC# 'Coordonnees de z2+C
                    y2# = 2 * x1# * y1# + yC#
                    If x2# * x2# + y2# * y2# > 4 Then flag = 1
                    x1# = x2#
                    y1# = y2#
                    C = C + 1
                Loop Until C = precision Or flag = 1

                'Draws pixel
                Print_explorer_pixel x, y, C

                'Saves pixel to array
                array_x = x - explorer_x_pos
                array_y = explorer_y_pos + explorer_height - y
                Image_array(array_x, array_y) = C

                y = y - 1
                'yC# = yC# + pas#
                ycal# = ycal# + pas#
            Loop Until y = explorer_y_pos -1
            x = x + 1
            y = explorer_y_pos + explorer_height
            'xC# = xC# + pas#
            xcal# = xcal# + pas#

            'Progress bar
            Progress_bar 10, 65, 195, 6, explorer_x_pos + 401 - explorer_x_pos, x - explorer_x_pos

            'Old progress bar
            'Progress_bar explorer_x_pos - 1, explorer_y_pos + explorer_height + 10, explorer_height + 2, 10, explorer_x_pos + 401 - explorer_x_pos, x - explorer_x_pos
        Loop Until x = explorer_x_pos + 401
    End If

    'Crosshair
    Crosshair_display 8, 7

    'Display status
    Show_status 2, 2, "Image created", 2, "Elapsed: " + Elapsed_time$(time_start, date_start$, TIMER, DATE$), 7
End Sub

'Color profiles inside (for explorer)
Sub Print_explorer_pixel(x, y, C)
    Shared color_profile, precision

    If color_profile = 1 Then 'Visible light spectrum - Set precision to 12 to see color palette
        If C MOD 10 = 9 Then 
            couleur = 12
        ElseIf C MOD 10 = 8 Then 
            couleur = 14
        ElseIf C MOD 10 = 7 Then 
            couleur = 10
        ElseIf C MOD 10 = 6 Then 
            couleur = 2
        ElseIf C MOD 10 = 5 Then 
            couleur = 3
        ElseIf C MOD 10 = 4 Then 
            couleur = 11
        ElseIf C MOD 10 = 3 Then 
            couleur = 9
        ElseIf C MOD 10 = 2 Then 
            couleur = 1 'Beginning circle
        ElseIf C MOD 10 = 1 Then 
            couleur = 5
        ElseIf C MOD 10 = 0 Then 
            couleur = 4
        End If
    ElseIf color_profile = 2 Then 'Old colors - Default
        For f = 1 to 10
            If C < (100 - f * 10 + 9) * precision / 100 Then couleur = 10
            If C < (100 - f * 10 + 8) * precision / 100 Then couleur = 9
            If C < (100 - f * 10 + 7) * precision / 100 Then couleur = 13
            If C < (100 - f * 10 + 6) * precision / 100 Then couleur = 12
            If C < (100 - f * 10 + 5) * precision / 100 Then couleur = 11
            If C < (100 - f * 10 + 4) * precision / 100 Then couleur = 14
            If C < (100 - f * 10 + 3) * precision / 100 Then couleur = 4
            If C < (100 - f * 10 + 2) * precision / 100 Then couleur = 3
            If C < (100 - f * 10 + 1) * precision / 100 Then couleur = 2
            If C < (100 - f * 10 + 0) * precision / 100 Then couleur = 1
        Next f

        If C < 16 Then couleur = C
    ElseIf color_profile = 3 Then 'Old colors - Red dragon
        For f = 1 to 10
            If C < (100 - f * 10 + 9) * precision / 100 Then couleur = 10
            If C < (100 - f * 10 + 8) * precision / 100 Then couleur = 9
            If C < (100 - f * 10 + 7) * precision / 100 Then couleur = 13
            If C < (100 - f * 10 + 6) * precision / 100 Then couleur = 12
            If C < (100 - f * 10 + 5) * precision / 100 Then couleur = 11
            If C < (100 - f * 10 + 4) * precision / 100 Then couleur = 14
            If C < (100 - f * 10 + 3) * precision / 100 Then couleur = 4
            If C < (100 - f * 10 + 2) * precision / 100 Then couleur = 3
            If C < (100 - f * 10 + 1) * precision / 100 Then couleur = 2
            If C < (100 - f * 10 + 0) * precision / 100 Then couleur = 1
        Next f
    End If

    'Black areas
    If C <= 1 Then couleur = 0
    If C = precision Then couleur = 0

    'Draws pixel
    PSet (x, y), couleur
End Sub

'Reloads explorer image using array
Sub Reload_explorer
    Shared explorer_width, explorer_height, Image_array()

    'Coordinates of the beginning of the image
    viewer_x = 220 ' 0 < x < 279
    viewer_y = 20 ' 0 < y < 79

    width = explorer_width - 1
    height = explorer_height - 1

    For x = 0 to width
        For y = 0 to height
            'Locate 1, 1: Color 15: Print Image_array(x, y)
            C = Image_array(x, y)
            
            x_pixel = x + viewer_x
            y_pixel = viewer_y + explorer_height - y

            'Draws pixel
            Print_explorer_pixel x_pixel, y_pixel, C
        Next y
    Next x

    'Crosshair
    Crosshair_display 8, 7
End Sub

'Creates a grid on viewer
Sub Grid_display
    grid_color = 0

    'Create grid lines
    For xa = 220 To 620 Step 20
        Line (xa, 20)-(xa, 420), grid_color
    Next xa
    For ya = 20 To 420 Step 20
        Line (220, ya)-(620, ya), grid_color
    Next ya
End Sub

Sub Crosshair_display (crosshair_size, crosshair_color)
    Shared Display_crosshair, explorer_x_pos, explorer_y_pos, explorer_height

    crosshair_x = explorer_x_pos + explorer_height / 2
    crosshair_y = explorer_y_pos + explorer_height / 2

    If Display_crosshair = 1 Then
        'Crosshair
        Line (crosshair_x - crosshair_size, crosshair_y)-(crosshair_x + crosshair_size, crosshair_y), crosshair_color
        Line (crosshair_x, crosshair_y - crosshair_size)-(crosshair_x, crosshair_y + crosshair_size), crosshair_color
    End If
End Sub

'Display visor
Sub Visor_display (x, y, size)
    Shared visor_step
    half_size = size / 2

    'External squares
    Line (x - half_size - 2, y - half_size - 2)-(x + half_size + 2, y + half_size + 2), 15, b
    Line (x - half_size - 1, y - half_size - 1)-(x + half_size + 1, y + half_size + 1), 15, b
    Line (x - half_size, y - half_size)-(x + half_size, y + half_size), 0, b 'Internal

    'Small internal squares (Step indicator)
    Line (x - 10, y - 10)-(x + 10, y + 10), 0, b 'Small black
    Line (x - visor_step, y - visor_step)-(x + visor_step, y + visor_step), 15, b 'Step indicator

    'Crosshair
    Line (x - 8, y)-(x + 8, y), 15
    Line (x, y - 8)-(x, y + 8), 15
End Sub

'Update C coordinates (Julia)
Sub Update_C
    Shared xC#, yC#

    'Display status
    Show_status 2, 2, "New xC:", 15, "", 0
    Locate 5, 2: Color 2: Input xC_coord

    'Display status
    Show_status 2, 2, "New yC:", 15, "", 0
    Locate 5, 2: Color 2: Input yC_coord

    xC# = xC_coord
    yC# = yC_coord

    Explorer_create_image
End Sub

'Update max iterations
Sub Update_max_iterations
    Shared precision

    'Display status
    Show_status 2, 2, "Set max iterations to:", 15, "", 0
    Locate 5, 2: Color 2: Input precision

    Explorer_create_image
End Sub

'Save image parameters to a file
Sub Save_variables (file_name$, x_coord#, y_coord#, view_size#, nbzoom, precision)
    Shared mode$, xC#, yC#

    'Creates Data folder when necesarry
    Shell "md Data"

    If mode$ = "Mandelbrot" Then
        Shell "md Data\Mandelbrot"
        mode_path$ = "Data/Mandelbrot/"
    ElseIf mode$ = "Julia" Then
        Shell "md Data\Julia"
        mode_path$ = "Data/Julia/"
    End If

    Open mode_path$ + file_name$ + ".txt" For Output As #1
        Print #1, x_coord#
        Print #1, y_coord#
        Print #1, view_size#
        Print #1, nbzoom
        Print #1, precision
        If mode$ = "Julia" Then
            Print #1, xC#
            Print #1, yC#
        End If
    Close #1

    'Display status
    Show_status 2, 2, "Parameters saved", 2, "", 0
End Sub

'Load image parameters from a file
Sub Load_variables
    Shared mode$, x_coord#, y_coord#, view_size#, nbzoom, precision, xC#, yC#

    'Display status
    Show_status 2, 2, "Load parameters file:", 15, "", 0
    Locate 5, 2: Color 2: Input file_name$

    If mode$ = "Mandelbrot" Then
        Shell "md Data\Mandelbrot"
        mode_path$ = "Data/Mandelbrot/"
    ElseIf mode$ = "Julia" Then
        Shell "md Data\Julia"
        mode_path$ = "Data/Julia/"
    End If

    If _FILEEXISTS(mode_path$ + file_name$ + ".txt") = -1 Then
        Open mode_path$ + file_name$ + ".txt" For Input As #1
            Input #1, x_coord#
            Input #1, y_coord#
            Input #1, view_size#
            Input #1, nbzoom
            Input #1, precision
            If mode$ = "Julia" Then
                Input #1, xC#
                Input #1, yC#
            End If
        Close #1
    Else
        'Error message
        Show_status 2, 2, "File not found!", 4, "", 0

        Exit Sub
    End If

    Explorer_create_image
End Sub

'Save log for bmp creation
Sub Save_log (full_folder_path$, start_from_image_nb)
    Shared video_name$, mode$, x_coord_end#, y_coord_end#, view_size_end#, xC_start#, xC_end#, yC_start#, yC_end#, precision_min, precision_max, longueur, hauteur, color_settings, cycles_nb#, cycle_length, video_mode, ni
    Shared file_name$, x_coord#, y_coord#, view_size#, precision, xC#, yC# 'Image specific
    
    If video_name$ <> "" Then 'Video
        log_file_path$ = full_folder_path$ + "/data.txt"
    ElseIf file_name$ <> "" Then 'Image
        If color_settings = 1 Then
            log_file_path$ = full_folder_path$ + file_name$ + " - " + RS$(precision) + "max - cp" + RS$(color_settings) + "."+ RS$(cycles_nb#) + " - " + RS$(longueur) + "x" + RS$(hauteur) + ".txt"
        Elseif color_settings = 2 Then
            log_file_path$ = full_folder_path$ + file_name$ + " - " + RS$(precision) + "max - cp" + RS$(color_settings) + "."+ RS$(cycle_length) + " - " + RS$(longueur) + "x" + RS$(hauteur) + ".txt"
        End If
    End If

    Open log_file_path$ For Output As #1
        If ni > 1 Then 'Video specific
            Print #1, "Video name:              "; video_name$
            Print #1, "x:                       "; RS$(x_coord_end#)
            Print #1, "y:                       "; RS$(y_coord_end#)
            Print #1, "Size:                    "; RS$(view_size_end#)
            Print #1, "max_iterations_start:    "; RS$(precision_min)
            Print #1, "max_iterations_end:      "; RS$(precision_max)
            Print #1, "Video mode:              "; RS$(video_mode)
        Else 'Image specific
            Print #1, "Image name:              "; file_name$
            Print #1, "x:                       "; RS$(x_coord#)
            Print #1, "y:                       "; RS$(y_coord#)
            Print #1, "Size:                    "; RS$(view_size#)
            Print #1, "max_iterations:          "; RS$(precision)
        End If
        
        Print #1, "Mode:                    "; mode$
        
        If mode$ = "Julia" Then 'Julia specific
            If ni > 1 Then 'Video specific
                Print #1, "xC_start:                "; RS$(xC_start#)
                Print #1, "xC_end:                  "; RS$(xC_end#)
                Print #1, "yC_start:                "; RS$(yC_start#)
                Print #1, "yC_end:                  "; RS$(yC_end#)
            Else
                Print #1, "xC:                      "; RS$(xC#)
                Print #1, "yC:                      "; RS$(yC#)
            End If
        End If
        
        Print #1, "Resolution:              "; RS$(longueur); "x"; RS$(hauteur)
        Print #1, "color_settings:          "; RS$(color_settings)

        If color_settings = 1 Then
            Print #1, "Number of cycles:        "; RS$(cycles_nb#)
        Elseif color_settings = 2 Then
            Print #1, "Length of cycle:         "; RS$(cycle_length)
        End If

        Print #1, "Number of images:        "; RS$(ni)

        If ni > 1 Then 'Video specific
            Print #1, "Start from image nb:     "; RS$(start_from_image_nb)
        End If
    Close #1
End Sub

Sub Load_dragged_file (dragged_file_path$)
    Shared video_name$, mode$, x_coord_end#, y_coord_end#, view_size_end#, precision_min, precision_max, longueur, hauteur, color_settings, cycles_nb#, cycle_length, video_mode, ni, first_image_nb
    Shared file_name$, x_coord#, y_coord#, view_size#, precision, xC#, yC# 'Image specific

    'Open file
    OPEN dragged_file_path$ FOR INPUT AS #1
        'Parse lines
        DO UNTIL EOF(1)
            'Input #1, current_line$
            Line Input #1, current_line$

            'Video Name
            IF LEFT$(current_line$, 11) = "Video name:" THEN
                video_name$ = MID$(current_line$, 26)
            END IF

            'Image Name
            IF LEFT$(current_line$, 11) = "Image name:" THEN
                file_name$ = MID$(current_line$, 26)
            END IF

            'Mode
            IF LEFT$(current_line$, 5) = "Mode:" THEN
                mode$ = MID$(current_line$, 26)
            END IF

            'Video specific
            If video_name$ <> "" Then
                'X - Video
                IF LEFT$(current_line$, 2) = "x:" THEN
                    x_coord_end# = VAL(MID$(current_line$, 26))
                END IF

                'Y - Video
                IF LEFT$(current_line$, 2) = "y:" THEN
                    y_coord_end# = VAL(MID$(current_line$, 26))
                END IF

                'Size - Video
                IF LEFT$(current_line$, 5) = "Size:" THEN
                    view_size_end# = VAL(MID$(current_line$, 26))
                END IF

                'Max iterations - start
                IF LEFT$(current_line$, 21) = "max_iterations_start:" THEN
                    precision_min = VAL(MID$(current_line$, 26))
                END IF

                'Max iterations - end
                IF LEFT$(current_line$, 19) = "max_iterations_end:" THEN
                    precision_max = VAL(MID$(current_line$, 26))
                END IF
            End If

            'Image specific
            If file_name$ <> "" Then
                'X - Image
                IF LEFT$(current_line$, 2) = "x:" THEN
                    x_coord# = VAL(MID$(current_line$, 26))
                END IF

                'Y - Image
                IF LEFT$(current_line$, 2) = "y:" THEN
                    y_coord# = VAL(MID$(current_line$, 26))
                END IF

                'Size - Image
                IF LEFT$(current_line$, 5) = "Size:" THEN
                    view_size# = VAL(MID$(current_line$, 26))
                END IF

                'Max iterations - Image
                IF LEFT$(current_line$, 15) = "max_iterations:" THEN
                    precision = VAL(MID$(current_line$, 26))
                END IF

                'xC - Image
                IF LEFT$(current_line$, 3) = "xC:" THEN
                    xC# = VAL(MID$(current_line$, 26))
                END IF

                'yC - Image
                IF LEFT$(current_line$, 3) = "yC:" THEN
                    yC# = VAL(MID$(current_line$, 26))
                END IF
            End If

            'Resolution
            IF LEFT$(current_line$, 11) = "Resolution:" THEN
                resolution$ = MID$(current_line$, 26)
                separation_pos = INSTR(1, resolution$, "x")
                longueur = VAL(LEFT$(resolution$, separation_pos - 1))
                hauteur = VAL(RIGHT$(resolution$, LEN(resolution$) - separation_pos))
            END IF

            'Color settings
            IF LEFT$(current_line$, 15) = "color_settings:" THEN
                color_settings = VAL(MID$(current_line$, 26))
            END IF

            'Cycles nb
            IF LEFT$(current_line$, 17) = "Number of cycles:" THEN
                cycles_nb# = VAL(MID$(current_line$, 26))
            END IF

            'Cycle length
            IF LEFT$(current_line$, 16) = "Length of cycle:" THEN
                cycle_length = VAL(MID$(current_line$, 26))
            END IF

            'Video mode
            IF LEFT$(current_line$, 11) = "Video mode:" THEN
                video_mode = VAL(MID$(current_line$, 26))
            END IF

            'Number of images
            IF LEFT$(current_line$, 17) = "Number of images:" THEN
                ni = VAL(MID$(current_line$, 26))
            END IF

            'Start with image number
            IF LEFT$(current_line$, 20) = "Start from image nb:" THEN
                first_image_nb = VAL(MID$(current_line$, 26))
            END IF
        LOOP
    Close #1
End Sub