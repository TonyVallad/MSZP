'-----------------------------------------------------------------------
'           File containing all subs used for creating BMPs
'-----------------------------------------------------------------------

'Load color settings and palette
SUB Load_Color_Settings
    Shared start_with$, low_threshold_start, low_threshold_end, fade_to_black, cycle_length, nb_colors_used, palette_pos#(), palette_color()

    'File path
    file_path$ = "color-settings.txt"

    'Variables
    start_with$ = ""
    fade_to_black = 0
    'cycle_length = 0
    nb_colors_used = 0

    color_index = 0
    comma_pos = 0

    'Open file
    OPEN file_path$ FOR INPUT AS #1

    'Parse lines
    DO UNTIL EOF(1) OR current_line$ = "- End of settings -"
        'Input #1, current_line$
        Line Input #1, current_line$

        'Start from
        IF current_line$ = "Start from = white" THEN
            start_with$ = "white"
        ELSEIF current_line$ = "Start from = black" THEN
            start_with$ = "black"
        END IF

        'Low_threshold_start
        IF LEFT$(current_line$, 21) = "low_threshold_start =" THEN
           low_threshold_start = VAL(MID$(current_line$, 22))
        END IF

        'Low_threshold_end
        IF LEFT$(current_line$, 19) = "low_threshold_end =" THEN
           low_threshold_end = VAL(MID$(current_line$, 20))
        END IF

        'Fade to black
        IF current_line$ = "Fade to black = 1" THEN
            fade_to_black = 1
        ELSEIF current_line$ = "Fade to black = 0" THEN
            fade_to_black = 0
        END IF

        'Number of colors
        IF LEFT$(current_line$, 18) = "Number of colors =" THEN
            nb_colors_used = VAL(MID$(current_line$, 19))
        END IF

        'Color data
        IF LEFT$(current_line$, 1) = "[" THEN
            line$ = current_line$ 'useless but not harmful...

            color_index = color_index + 1

            line$ = MID$(line$, 2, len(line$)) 'Removes "["
            comma_pos = INSTR(1, line$, ",")
            palette_pos#(color_index) = VAL(LEFT$(line$, comma_pos - 1))
            
            line$ = MID$(line$, comma_pos + 1, len(line$) - comma_pos) 'Removes previous ","
            comma_pos = INSTR(1, line$, ",")
            palette_color(color_index, 1) = VAL(LEFT$(line$, comma_pos - 1))

            line$ = MID$(line$, comma_pos + 1, len(line$) - comma_pos) 'Removes previous ","
            comma_pos = INSTR(1, line$, ",")
            palette_color(color_index, 2) = VAL(LEFT$(line$, comma_pos - 1))
            
            line$ = MID$(line$, comma_pos + 1, len(line$) - comma_pos) 'Removes previous ","
            line$ = LEFT$(line$, len(line$) - 1) 'Removes "]"
            palette_color(color_index, 3) = VAL(line$)

            IF palette_color(color_index, 1) > 255 THEN palette_color(color_index, 1) = 255
            IF palette_color(color_index, 2) > 255 THEN palette_color(color_index, 2) = 255
            IF palette_color(color_index, 3) > 255 THEN palette_color(color_index, 3) = 255
            IF palette_color(color_index, 1) < 0 THEN palette_color(color_index, 1) = 0
            IF palette_color(color_index, 2) < 0 THEN palette_color(color_index, 2) = 0
            IF palette_color(color_index, 3) < 0 THEN palette_color(color_index, 3) = 0
        END IF
    LOOP

    'Duplicate first color to position 1
    palette_pos#(nb_colors_used + 1) = 1
    palette_color(nb_colors_used + 1, 1) = palette_color(1, 1)
    palette_color(nb_colors_used + 1, 2) = palette_color(1, 2)
    palette_color(nb_colors_used + 1, 3) = palette_color(1, 3)
    nb_colors_used = nb_colors_used + 1

    'Close file
    CLOSE #1
END SUB

'Color profiles inside (for explorer)
Sub Get_pixel_color_BMP ()
    Shared color_settings, start_with$, low_threshold_start, low_threshold_end, fade_to_black, cycle_length, nb_colors_used, precision, r, g, b, r$, g$, b$, color_error_counter, C, palette_pos#(), palette_color()

    'Frequencies (or resonances) - Used for old color profile. To delete
    'r_freq = 745
    'g_freq = 882
    'b_freq = 957
    r_freq = 438
    g_freq = 666
    b_freq = 957

    'Amplitude (how wide the tolerance goes for that color)
    r_amp = 55
    g_amp = 40
    b_amp = 48

    '_________________________________________ Color Setings

    'Color settings
    If color_settings = 1 Then 'Color palette - Number of cycles
        color_length = int(cycle_length / nb_colors_used)

        'Separating C int and decimal for MOD to work (color smoothing)
        C_int = int(C)
        C_dec = C - int(C)

        position_in_cycle# = (C_int MOD cycle_length) / cycle_length + C_dec / cycle_length

        GetRGBValues nb_colors_used, position_in_cycle#

        'Start from white/black
        If start_with$ = "white" Then 'Start from white
            If C > low_threshold_start and C < low_threshold_end Then
                r = int(r + (255 - r) * (low_threshold_end - C) / (low_threshold_end - low_threshold_start))
                g = int(g + (255 - g) * (low_threshold_end - C) / (low_threshold_end - low_threshold_start))
                b = int(b + (255 - b) * (low_threshold_end - C) / (low_threshold_end - low_threshold_start))
            ElseIf C < low_threshold_start Then
                r = 255
                g = 255
                b = 255
            End If
        ElseIf start_with$ = "black" Then 'Start from black
            If C > low_threshold_start and C < low_threshold_end Then
                r = int(r * (c - low_threshold_start) / (low_threshold_end - low_threshold_start))
                g = int(g * (c - low_threshold_start) / (low_threshold_end - low_threshold_start))
                b = int(b * (c - low_threshold_start) / (low_threshold_end - low_threshold_start))
            ElseIf C < low_threshold_start Then
                r = 0
                g = 0
                b = 0
            End If
        End If

        'Fade to black
        If fade_to_black = 1 Then
            If precision >= cycle_length Then
                If C > (precision - (0.5 * color_length)) Then 'To fix
                    r = int(r * (precision - C) / (0.5 * color_length))
                    g = int(g * (precision - C) / (0.5 * color_length))
                    b = int(b * (precision - C) / (0.5 * color_length))
                End If
            ElseIf C > 0.85 * precision Then
                r = int(r * (precision - C) / (precision * 0.15))
                g = int(g * (precision - C) / (precision * 0.15))
                b = int(b * (precision - C) / (precision * 0.15))
            End If
        End If

        'Black if C = max iterations
        If C = precision Then
            r = 0
            g = 0
            b = 0
        End If
    Elseif color_settings = 2 Then 'Color palette - Cycle length
        color_length = int(cycle_length / nb_colors_used)
        position_in_cycle# = (C MOD cycle_length) / cycle_length

        GetRGBValues nb_colors_used, position_in_cycle#

        'Start from white/black
        If start_with$ = "white" Then 'Start from white
            If C > low_threshold_start and C < low_threshold_end Then
                r = int(r + (255 - r) * (low_threshold_end - C) / (low_threshold_end - low_threshold_start))
                g = int(g + (255 - g) * (low_threshold_end - C) / (low_threshold_end - low_threshold_start))
                b = int(b + (255 - b) * (low_threshold_end - C) / (low_threshold_end - low_threshold_start))
            ElseIf C < low_threshold_start Then
                r = 255
                g = 255
                b = 255
            End If
        ElseIf start_with$ = "black" Then 'Start from black
            If C > low_threshold_start and C < low_threshold_end Then
                r = int(r * (c - low_threshold_start) / (low_threshold_end - low_threshold_start))
                g = int(g * (c - low_threshold_start) / (low_threshold_end - low_threshold_start))
                b = int(b * (c - low_threshold_start) / (low_threshold_end - low_threshold_start))
            ElseIf C < low_threshold_start Then
                r = 0
                g = 0
                b = 0
            End If
        End If

        'Fade to black
        'fade_to_black = 1 'Forced "on" for testing
        If fade_to_black = 1 Then
            If precision >= cycle_length Then
                If C > (precision - (0.5 * color_length)) Then 'To fix
                    r = int(r * (precision - C) / (0.5 * color_length))
                    g = int(g * (precision - C) / (0.5 * color_length))
                    b = int(b * (precision - C) / (0.5 * color_length))
                End If
            ElseIf C > 0.85 * precision Then
                r = int(r * (precision - C) / (precision * 0.15))
                g = int(g * (precision - C) / (precision * 0.15))
                b = int(b * (precision - C) / (precision * 0.15))
            End If
        End If

        'Black if C = max iterations
        If C = precision Then
            r = 0
            g = 0
            b = 0
        End If
    Elseif color_settings = 3 Then 'Green/blue on black background
        r = 0
        If C < precision / 2 Then
            g = 255 - Int((C / precision) * 2 * 255)
        Else
            g = Int((1 - (C / precision)) * 2 * 255)
        End If
        b = 255 - Int((C / precision) * 255)
    Elseif color_settings = 4 Then 'To identify/fix
        IF c < precision / 5 THEN g = 255 - ((INT((c / precision) * 255 / 5)) + INT(precision / 5))
        IF c < 1 * precision / 5 THEN g = ((INT((c / precision) * 255 / 5)) + INT(1 * precision / 5))
        IF c < 1 * precision / 5 THEN r = 255 - ((INT((c / precision) * 255 / 5)) + INT(1 * precision / 5))
        IF c < 2 * precision / 5 THEN b = ((INT((c / precision) * 255 / 5)) + INT(2 * precision / 5))
        IF c < 2 * precision / 5 THEN g = 255 - ((INT((c / precision) * 255 / 5)) + INT(2 * precision / 5))
    Elseif color_settings = 5 Then 'To identify/fix
        IF C < 4 * precision / 4 and C > 3 * precision / 4 THEN
            r = INT(4 * C / (precision / 4) * 255)
            g = 255
            b = INT(4 * C / (precision / 4) * 255)
        Elseif C < 3 * precision / 4 and C > 2 * precision / 4 THEN
            r = 255 - INT(3 * C / (precision / 4) * 255)
            g = INT(3 * C / (precision / 4) * 255)
            b = 0
        Elseif C < 2 * precision / 4 AND C > 1 * precision / 4 THEN
            r = INT((C - 1 * presicion / 4) / (precision / 4) * 255)
            g = 0
            b = 255 - INT((C - 1 * presicion / 4) / (precision / 4) * 255)
        Elseif C < 1 * precision / 4 Then
            r = 0
            g = 0
            B = Int((C - 0 * presicion / 4) / (precision / 4) * 255)
        Else
            r = 0
            g = 0
            c = 0
        End If
    Elseif color_settings = 6 Then 'Green/purple on black background
    
        B = 255 - Int((C / precision) * 255)
        If C < precision / 2 Then
            g = 255 - Int((C / precision) * 2 * 255)
        Else
            g = Int((1 - (C / precision)) * 2 * 255)
        End If
        r = 255 - Int((C / precision) * 255)
    Elseif color_settings = 7 Then
        'A gradient of colors from red to blue, with green in the middle
        If C < Precision / 2 Then
        r = 255 - Int((C / Precision) * 2 * 255)
        g = Int((C / Precision) * 2 * 255)
        b = 0
        Else
        r = 0
        g = 255 - Int((1 - (C / Precision)) * 2 * 255)
        b = Int((1 - (C / Precision)) * 2 * 255)
        End If
    Elseif color_settings = 8 Then
        'A gradient of colors from yellow to purple, with red, green, and blue all increasing and decreasing at different rates
        r = Int((C / Precision) * 255)
        g = Int((1 - (C / Precision)) * 255)
        b = Int((C / Precision) * 255)
    Elseif color_settings = 9 Then
        'A gradient of colors from black to white, with each color channel increasing at a different rate
        r = Int((C / Precision) * 255 / 3)
        g = Int((1 - (C / Precision)) * 255 / 3)
        b = Int((C / Precision) * 255 / 3)
    Elseif color_settings = 10 Then
        'White to black with blue and green in the middle
        If C < precision / 4 Then
            r = 255
            g = Int((C / (precision / 4)) * 255)
            b = Int((C / (precision / 4)) * 255)
        Elseif C < 2 * precision / 4 Then
            r = Int((1 - (C / (precision / 4))) * 255)
            g = 255
            b = Int(((C - (precision / 4)) / (precision / 4)) * 255)
        Elseif C < 3 * precision / 4 Then
            r = Int((1 - ((C - (2 * precision / 4)) / (precision / 4))) * 255)
            g = Int((1 - ((C - (2 * precision / 4)) / (precision / 4))) * 255)
            b = 255
        Else
            r = 0
            g = 0
            b = Int((1 - ((C - (3 * precision / 4)) / (precision / 4))) * 255)
        End If
    Elseif color_settings = 11 Then
        'Red
        if (C <= (r_freq - r_amp)) Or (C >= (r_freq + r_amp)) Or (C = Precision) Then
            r = 0
        Elseif (C < r_freq) Then
            r = 255 - (r_freq - C) / r_amp * 255
        Elseif (C > r_freq) Then
            r = 255 - (C - r_freq) / r_amp * 255
        Else
            r = 255
        End If

        'Green
        if (C <= (g_freq - g_amp)) Or (C >= (g_freq + g_amp)) Or (C = Precision) Then
            g = 0
        Elseif (C < g_freq) Then
            g = 255 - (g_freq - C) / g_amp * 255
        Elseif (C > g_freq) Then
            g = 255 - (C - g_freq) / g_amp * 255
        Else
            g = 255
        End If

        'Blue
        if (C <= (b_freq - b_amp)) Or (C >= (b_freq + b_amp)) Or (C = Precision) Then
            b = 0
        Elseif (C < b_freq) Then
            b = 255 - (b_freq - C) / b_amp * 255
        Elseif (C > b_freq) Then
            b = 255 - (C - b_freq) / b_amp * 255
        Else
            b = 255
        End If
    End If

    'Color overflow correction
    color_error = 0
    If r > 255 Then
        r = 255
        color_error = 1
    Elseif r < 0 Then
        r = 0
        color_error = 1
    End If
    If g > 255 Then
        g = 255
        color_error = 1
    Elseif g < 0 Then
        g = 0
        color_error = 1
    End If
    If b > 255 Then
        b = 255
        color_error = 1
    Elseif b < 0 Then
        b = 0
        color_error = 1
    End If

    'Color overflow counter
    If color_error = 1 Then
        color_error_counter = color_error_counter + 1
    End If

    'Saves RGB values in strings
    b$ = Chr$(b)
    g$ = Chr$(g)
    r$ = Chr$(r)
End Sub

'Get RGB values from color palette
Sub GetRGBValues (nb_colors_used, position_in_cycle#)
    Shared palette_color(), palette_pos#(), r, g, b

    'Reset
    r = 0
    g = 0
    b = 0

    For i = 1 TO nb_colors_used
        IF position_in_cycle# >= palette_pos#(i) AND position_in_cycle# < palette_pos#(i + 1) THEN
            r = int(palette_color(i, 1) + (palette_color(i + 1, 1) - palette_color(i, 1)) * (position_in_cycle# - palette_pos#(i)) / (palette_pos#(i + 1) - palette_pos#(i)))
            g = int(palette_color(i, 2) + (palette_color(i + 1, 2) - palette_color(i, 2)) * (position_in_cycle# - palette_pos#(i)) / (palette_pos#(i + 1) - palette_pos#(i)))
            b = int(palette_color(i, 3) + (palette_color(i + 1, 3) - palette_color(i, 3)) * (position_in_cycle# - palette_pos#(i)) / (palette_pos#(i + 1) - palette_pos#(i)))
            EXIT FOR
        END IF
    NEXT i
END Sub

'Creates BMP for both modes
Sub BMP_Creator
    Shared mode$, file_path$, full_file_name$, longueur, hauteur, precision, ni, f, time_start, date_start$, color_settings, precision_min, precision_max, x_coord#, y_coord#, view_size#, w#, r$, g$, b$, color_error_counter, C, xC#, yC#, BMP_creator_stealth

    'Obsolete ?
    pas# = view_size# / hauteur
    debutx# = x_coord# - (longueur / 2 * pas#)
    debuty# = y_coord# - (hauteur / 2 * pas#)

    'Creates bitmap file
    Open file_path$ For Binary As #2

    '_______________________________________________________ File header
    taille = 54 + (longueur * hauteur * 3)
    filesize$ = IntToASCII$(taille)

    offset = 54
    offset$ = IntToASCII$(offset)

    'File header
    a$ = "BM" + filesize$ + String$(4, Chr$(0)) + offset$

    'Output file header to file
    Put #2, 1, a$

    '_______________________________________________________ Bitmap header
    header_size = 40
    headersize$ = IntToASCII$(header_size)

    width$ = IntToASCII$(longueur)

    height$ = IntToASCII$(hauteur)

    sizeimage$ = IntToASCII$(longueur * hauteur * 3)

    nbplan = 1
    nbplan$ = IntToASCII$(nbplan)

    nbpp = 24
    nbpp$ = IntToASCII$(nbpp)

    'Bitmap header - Tried splitting in 2 for 4k and 8k images, but doesn't work
    B$ = headersize$ + width$ + height$ + Left$(nbplan$, 2) + Left$(nbpp$, 2) + String$(4, Chr$(0)) + sizeimage$ + String$(16, Chr$(0))

    'Output bitmap header to file
    Put #2, 15, B$

    'Reset variables
    color_error_counter = 0
    total_pixels = 0
    color_error_percent# = 0
    DIM AS LONG compteur
    DIM AS DOUBLE xx, yy
    compteur = 0 'To get position for writing in BMP file
    x = 0
    y = 0

    '____________________________________________________ BMP Creator Page

    'Display parameters and progress bar
    If BMP_creator_stealth = 0 Then
        Cls
        Presentation

        'Progress bar for nb images
        If ni > 1 Then
            Progress_bar 80, 255, 500, 6, ni - 1, f - 1
        End If

        Locate 5, 11: Color 15: Print "X Coord:"
        Locate 5, 45: Color 14: Print RS$(x_coord#)
        Locate 6, 11: Color 15: Print "Y Coord:"
        Locate 6, 45: Color 14: Print RS$(y_coord#)
        Locate 7, 11: Color 15: Print "View size:"
        Locate 7, 45: Color 14: Print RS$(view_size#)
        Locate 8, 11: Color 15: Print "Max iterations:"
        If ni > 1 Then
            Locate 8, 45: Color 14: Print RS$(precision); " ("; RS$(precision_min); "-"; RS$(precision_max); ")"
        Else
            Locate 8, 45: Color 14: Print RS$(precision)
        End If
        If mode$ = "Julia" Then
            Locate 9, 11: Color 15: Print "xC:"
            Locate 9, 45: Color 14: Print RS$(xC#)
            Locate 10, 11: Color 15: Print "yC:"
            Locate 10, 45: Color 14: Print RS$(yC#)
        End If

        Locate 12, 11: Color 15: Print "File name:"
        Locate 12, 22: Color 14: Print full_file_name$
        Locate 13, 11: Color 15: Print "Resolution:"
        Locate 13, 23: Color 14: Print RS$(longueur); "x"; RS$(hauteur)
        Locate 14, 11: Color 15: Print "Color settings:"
        Locate 14, 27: Color 14: Print RS$(color_settings)

        If ni > 1 Then
            Locate 15, 11: Color 15: Print "Zoom coeficient:"
            Locate 15, 45: Color 14: Print RS$(w#)
        End If
        Locate 18, 11: Color 14: Print "Creating image:"
    Else
        'Display status
        Show_status 2, 2, "Creating BMP image...", 14, "", 0
    End If

    'Image Content
    If mode$ = "Mandelbrot" Then
        yC# = debuty# 'C points a traiter
        Do
            xC# = debutx#
            Do
                C = 0 'Compteur de boucles (max = precision)
                flag = 0 'Sortie du cercle de rayon 2
                x1# = 0 'Coordonnees de z0
                y1# = 0
                Do
                    x2# = x1# * x1# - y1# * y1# + xC# 'Coordonnees de z2+C
                    y2# = 2 * x1# * y1# + yC#
                    If x2# * x2# + y2# * y2# > 24 Then flag = 1
                    x1# = x2#
                    y1# = y2#
                    C = C + 1
                Loop Until C = precision Or flag = 1

                'Color gradient smoothing - Log-log
                'Calculate how fast it's leaving the circle to get decimals
                If flag = 1 Then
                    'Decimal iteration
                    xx = Log(x2# * x2# + y2# * y2#) / 2
                    yy = Log(xx / Log(2)) / Log(2)
                    C = C + 1 - yy
                End If

                'Total number of pixels
                total_pixels = total_pixels + 1

                'New sub to get RGB values from C
                Get_pixel_color_BMP

                'Saving pixel to file
                compteur = compteur + 1
                Put #2, 54 + compteur, b$
                compteur = compteur + 1
                Put #2, 54 + compteur, g$
                compteur = compteur + 1
                Put #2, 54 + compteur, r$

                x = x + 1
                xC# = xC# + pas#
            Loop Until x = longueur
            
            'Progress bar
            If BMP_creator_stealth = 0 Then
                'Display nb images progression
                Locate 18, 27: Color 2: Print RS$(f); "/"; RS$(ni)
                
                'Progress bar
                Progress_bar 80, 246, 500, 6, hauteur - 1, y
            Else
                'Progress bar
                Progress_bar 10, 65, 195, 6, hauteur - 1, y
            End If

            yC# = yC# + pas#
            y = y + 1
            x = 0
        Loop Until y = hauteur
    ElseIf mode$ = "Julia" Then
        ycal# = debuty#
        Do
            xcal# = debutx#
            Do
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

                'Color gradient smoothing - Log-log
                If flag = 1 Then
                    'Decimal iteration
                    xx = Log(x2# * x2# + y2# * y2#) / 2
                    yy = Log(xx / Log(2)) / Log(2)
                    C = C + 1 - yy
                End If

                'Total number of pixels
                total_pixels = total_pixels + 1

                'New sub to get RGB values from C
                Get_pixel_color_BMP

                '_________________________________________ Saving pixel to file

                compteur = compteur + 1
                Put #2, 54 + compteur, b$
        
                compteur = compteur + 1
                Put #2, 54 + compteur, g$
        
                compteur = compteur + 1
                Put #2, 54 + compteur, r$
            
                xcal# = xcal# + pas#

                x = x + 1
            Loop Until x = longueur
            
            'Progress bar
            If BMP_creator_stealth = 0 Then
                'Display nb images progression
                Locate 18, 27: Color 2: Print RS$(f); "/"; RS$(ni)
                
                'Progress bar
                Progress_bar 80, 250, 500, 8, hauteur - 1, y
            Else
                'Progress bar
                Progress_bar 10, 65, 195, 6, hauteur - 1, y
            End If

            ycal# = ycal# + pas#

            y = y + 1
            x = 0
        Loop Until y = hauteur
    End If

    'End information display
    If BMP_creator_stealth = 0 Then
        Locate 20, 11: Color 15: Print "Number of images:"; ni
        Locate 21, 11: Color 15: Print "Elapsed time: "; Elapsed_time$(time_start, date_start$, TIMER, DATE$)

        'Color errors display - To test color profiles, remove afterwards
        color_profile_test = 0
        If color_profile_test = 1 Then
            color_error_percent# = color_error_counter / total_pixels * 100
            If color_error_counter = 0 Then
                color_error_color = 2
            Elseif color_error_percent# < 5 Then
                color_error_color = 14
            Else
                color_error_color = 4
            End If
            Locate 23, 11: Color 15: Print "Number pixels with color errors: "
            Locate 23, 44: Color color_error_color: Print  RS$(color_error_counter); "/"; RS$(total_pixels); " ("; RS$(ROUND(color_error_percent#, 2)); "%)"
        End If
    Else
        'Display status
        Show_status 2, 2, "BMP image created", 2, "Elapsed: " + Elapsed_time$(time_start, date_start$, TIMER, DATE$), 7
    End If

    '_______________________________________________________________ End
    Close #2

End Sub

Sub BMPjulia 'Obsolete
    Shared var, var$, video_name$, longueur, hauteur, xC#, yC#, precision, debutx#, debuty#, pas#

    Open video_name$ For Binary As #2

    '_______________________________________________________ Entete du fichier
    taille = 54 + (longueur * hauteur * 3)
    filesize$ = IntToASCII$(taille)

    offset = 54
    offset$ = IntToASCII$(offset)

    a$ = "BM" + filesize$ + String$(4, Chr$(0)) + offset$

    Put #2, 1, a$ '-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/ Output in file

    '_______________________________________________________ Entete du Bitmap
    header_size = 40
    headersize$ = IntToASCII$(header_size)

    var = longueur
    width$ = IntToASCII$(longueur)

    var = hauteur
    height$ = IntToASCII$(hauteur)

    image_size = longueur * hauteur * 3
    sizeimage$ = IntToASCII$(image_size)

    nbplan = 1
    nbplan$ = IntToASCII$(nbplan)

    nbpp = 24
    nbpp$ = IntToASCII$(nbpp)

    B$ = headersize$ + width$ + height$ + Left$(nbplan$, 2) + Left$(nbpp$, 2) + String$(4, Chr$(0)) + sizeimage$ + String$(16, Chr$(0))

    Put #2, 15, B$ '-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/ Output in file

    '_______________________________________________________ Image
    Cls
    Presentation

    compteur = 0
    r$ = ""
    g$ = ""
    B$ = ""

    x = 0
    y = 0

    Line (79, 248)-(79, 262), 15
    Line (581, 248)-(581, 262), 15

    ycal# = debuty#
    Do
        xcal# = debutx#
        Do
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
        
            'b = 0
            'g = 60
            'r = 120
        
            a = 0
            If a = 1 Then
                B = Int((C / precision) * 255)
                If C < precision / 2 Then
                    g = Int((C / precision) * 2 * 255)
                Else
                    g = 255 - Int((1 - (C / precision)) * 2 * 255)
                    'g = INT((1 - (c / precision)) * 2 * 255)
                End If
                r = Int((C / precision) * 255)
            Else
                B = 255 - Int((C / precision) * 255)
                If C < precision / 2 Then
                    g = 255 - Int((C / precision) * 2 * 255)
                Else
                    g = Int((1 - (C / precision)) * 2 * 255)
                End If
                r = 255 - Int((C / precision) * 255)
            End If

            If C < 2 Then
                B = 255
                g = 255
                r = 255
            End If
        
            compteur = compteur + 1
            B$ = Chr$(B)
            Put #2, 54 + compteur, B$
        
            compteur = compteur + 1
            r$ = Chr$(g)
            Put #2, 54 + compteur, r$
        
            compteur = compteur + 1
            g$ = Chr$(r)
            Put #2, 54 + compteur, g$
        
            xcal# = xcal# + pas#
            x = x + 1
        Loop Until x = longueur
  
        compteur2 = compteur2 + 1
        loading = 500 * (compteur2 / hauteur)
        Line (80, 250)-(loading + 80, 260), 2, BF
        ycal# = ycal# + pas#
        y = y + 1
        x = 0
    Loop Until y = hauteur

    '_______________________________________________________________ End
    Close #2

    'Log file
    'Open "Photos/Log.txt" For Append As #3
        'archive$ = name$ + "/" + Str$(xC#) + "/" + Str$(yC#) + "/" + Str$(precision)
        'Print #3, archive$
    'Close #3

End Sub

Sub BMPmandelbrot 'Obsolete
    Shared name$, longueur, hauteur, precision, ni, f, imagename$, time_start$, color_settings, precision_min, precision_max, x_coord#, y_coord#, view_size#, w#

    pas# = view_size# / hauteur
    debutx# = x_coord# - (longueur / 2 * pas#)
    debuty# = y_coord# - (hauteur / 2 * pas#)

    'Creates bitmap file
    Open name$ For Binary As #2

    '_______________________________________________________ File header
    taille = 54 + (longueur * hauteur * 3)
    filesize$ = IntToASCII$(taille)

    offset = 54
    offset$ = IntToASCII$(offset)

    'File header
    a$ = "BM" + filesize$ + String$(4, Chr$(0)) + offset$

    'Output file header to file
    Put #2, 1, a$

    '_______________________________________________________ Bitmap header
    header_size = 40
    headersize$ = IntToASCII$(header_size)

    width$ = IntToASCII$(longueur)

    height$ = IntToASCII$(hauteur)

    sizeimage$ = IntToASCII$(longueur * hauteur * 3)

    nbplan = 1
    nbplan$ = IntToASCII$(nbplan)

    nbpp = 24
    nbpp$ = IntToASCII$(nbpp)

    'Bitmap header
    B$ = headersize$ + width$ + height$ + Left$(nbplan$, 2) + Left$(nbpp$, 2) + String$(4, Chr$(0)) + sizeimage$ + String$(16, Chr$(0))

    'Output bitmap header to file
    Put #2, 15, B$

    'Reset variables
    color_error_counter = 0
    color_error = 0
    total_pixels = 0
    color_error_percent# = 0
    compteur = 0
    x = 0
    y = 0

    '_______________________________________________________ Color settings (variables)
    'color_settings = 3

    'Frequencies (or resonances)
    'r_freq = 745
    'g_freq = 882
    'b_freq = 957
    r_freq = 438
    g_freq = 666
    b_freq = 957

    'Amplitude (how wide the tolerance goes for that color)
    r_amp = 55
    g_amp = 40
    b_amp = 48

    '_______________________________________________________ Image
    Cls
    Presentation

    'Progress bar
    If ni > 1 Then
        Progress_bar 80, 257, 500, 10, ni - 1, f - 1
    End If

    Locate 5, 11: Color 15: Print "X Coord:"
    Locate 5, 45: Color 14: Print RS$(x_coord#)
    Locate 6, 11: Color 15: Print "Y Coord:"
    Locate 6, 45: Color 14: Print RS$(y_coord#)
    Locate 7, 11: Color 15: Print "View size: (not in pixels)"
    Locate 7, 45: Color 14: Print RS$(view_size#)
    Locate 9, 11: Color 15: Print "Max iterations: (precision)"
    If ni > 1 Then
        Locate 9, 45: Color 14: Print RS$(precision); " ("; RS$(precision_min); "-"; RS$(precision_max); ")"
    Else
        Locate 9, 45: Color 14: Print RS$(precision)
    End If
    Locate 11, 11: Color 15: Print "File name:"
    Locate 11, 45: Color 14: Print imagename$

    Locate 13, 11: Color 15: Print "Resolution:"
    Locate 13, 45: Color 14: Print RS$(longueur); "x"; RS$(hauteur)
    Locate 14, 11: Color 15: Print "Color settings:"
    Locate 14, 45: Color 14: Print RS$(color_settings)

    Locate 15, 11: Color 14: Print "Zoom coeficient: " ; RS$(w#)

    Locate 18, 11: Color 14: Print "Creating image:"

    Locate 22, 11: Color 15: Print "Startup time:  " + time_start$

    'Image content
    yC# = debuty# 'C points a traiter
    Do
        xC# = debutx#
        Do
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

            '_________________________________________ Color Setings

            'Color settings
            If color_settings = 1 Then 'RGB set to certain frequencies
                'Red
                If (((Precision - C) Mod r_freq) < r_amp) Then
                    r_diff = (Precision - C) Mod r_freq
                Elseif (((Precision - C) Mod r_freq) > (r_freq - r_amp)) Then
                    r_diff = r_freq - ((Precision - C) Mod r_freq)
                Else
                    r_diff = 99999 'could be anything, gonna be too much
                End If

                If C = Precision Then
                    r = 0
                Elseif (r_diff < r_amp) Then
                    r = 255 - (r_diff / r_amp) * 255
                Else
                    r = 0
                End If

                'Green
                If (((Precision - C) Mod g_freq) < g_amp) Then
                    g_diff = (Precision - C) Mod g_freq
                Elseif (((Precision - C) Mod g_freq) > (g_freq - g_amp)) Then
                    g_diff = g_freq - ((Precision - C) Mod g_freq)
                Else
                    g_diff = 99999 'could be anything, gonna be too much
                End If

                If C = Precision Then
                    g = 0
                Elseif (g_diff < g_amp) Then
                    g = 255 - (g_diff / g_amp) * 255
                Else
                    g = 0
                End If

                'Blue
                If (((Precision - C) Mod b_freq) < b_amp) Then
                    b_diff = (Precision - C) Mod b_freq
                Elseif (((Precision - C) Mod b_freq) > (b_freq - b_amp)) Then
                    b_diff = b_freq - ((Precision - C) Mod b_freq)
                Else
                    b_diff = 99999 'could be anything, gonna be too much
                End If

                If C = Precision Then
                    b = 0
                Elseif (b_diff < b_amp) Then
                    b = 255 - (b_diff / b_amp) * 255
                Else
                    b = 0
                End If
            Elseif color_settings = 2 Then 'Green/purple on white background
                B = Int((C / precision) * 255)
                If C < precision / 2 Then
                    g = Int((C / precision) * 2 * 255)
                Else
                    g = 255 - Int((1 - (C / precision)) * 2 * 255)
                    'g = INT((1 - (c / precision)) * 2 * 255)
                End If
                r = Int((C / precision) * 255)
            Elseif color_settings = 3 Then 'Green/purple on black background
                'r = 255 - Int((C / precision) * 255)
                r = 0
                If C < precision / 2 Then
                    g = 255 - Int((C / precision) * 2 * 255)
                Else
                    g = Int((1 - (C / precision)) * 2 * 255)
                End If
                b = 255 - Int((C / precision) * 255)
            Elseif color_settings = 4 Then 'To identify/fix
                IF c < precision / 5 THEN g = 255 - ((INT((c / precision) * 255 / 5)) + INT(precision / 5))
                IF c < 1 * precision / 5 THEN g = ((INT((c / precision) * 255 / 5)) + INT(1 * precision / 5))
                IF c < 1 * precision / 5 THEN r = 255 - ((INT((c / precision) * 255 / 5)) + INT(1 * precision / 5))
                IF c < 2 * precision / 5 THEN b = ((INT((c / precision) * 255 / 5)) + INT(2 * precision / 5))
                IF c < 2 * precision / 5 THEN g = 255 - ((INT((c / precision) * 255 / 5)) + INT(2 * precision / 5))
            Elseif color_settings = 5 Then 'To identify/fix
                IF C < 4 * precision / 4 and C > 3 * precision / 4 THEN
                    r = INT(4 * C / (precision / 4) * 255)
                    g = 255
                    b = INT(4 * C / (precision / 4) * 255)
                Elseif C < 3 * precision / 4 and C > 2 * precision / 4 THEN
                    r = 255 - INT(3 * C / (precision / 4) * 255)
                    g = INT(3 * C / (precision / 4) * 255)
                    b = 0
                Elseif C < 2 * precision / 4 AND C > 1 * precision / 4 THEN
                    r = INT((C - 1 * presicion / 4) / (precision / 4) * 255)
                    g = 0
                    b = 255 - INT((C - 1 * presicion / 4) / (precision / 4) * 255)
                Elseif C < 1 * precision / 4 Then
                    r = 0
                    g = 0
                    B = Int((C - 0 * presicion / 4) / (precision / 4) * 255)
                Else
                    r = 0
                    g = 0
                    c = 0
                End If
            Elseif color_settings = 6 Then 'Green/purple on black background
            
                B = 255 - Int((C / precision) * 255)
                If C < precision / 2 Then
                    g = 255 - Int((C / precision) * 2 * 255)
                Else
                    g = Int((1 - (C / precision)) * 2 * 255)
                End If
                r = 255 - Int((C / precision) * 255)
            Elseif color_settings = 7 Then 'Inverted grayscale
                'Inverted grayscale
                r = Int((C / precision) * 255)
                g = Int((C / precision) * 255)
                b = Int((C / precision) * 255)
            Elseif color_settings = 8 Then 'Grayscale
                'Grayscale
                r = 255 - Int((C / precision) * 255)
                g = 255 - Int((C / precision) * 255)
                b = 255 - Int((C / precision) * 255)
            Elseif color_settings = 9 Then
                'A gradient of colors from red to blue, with green in the middle
                If C < Precision / 2 Then
                r = 255 - Int((C / Precision) * 2 * 255)
                g = Int((C / Precision) * 2 * 255)
                b = 0
                Else
                r = 0
                g = 255 - Int((1 - (C / Precision)) * 2 * 255)
                b = Int((1 - (C / Precision)) * 2 * 255)
                End If
            Elseif color_settings = 10 Then
                'A gradient of colors from yellow to purple, with red, green, and blue all increasing and decreasing at different rates
                r = Int((C / Precision) * 255)
                g = Int((1 - (C / Precision)) * 255)
                b = Int((C / Precision) * 255)
            Elseif color_settings = 11 Then
                'A gradient of colors from black to white, with each color channel increasing at a different rate
                r = Int((C / Precision) * 255 / 3)
                g = Int((1 - (C / Precision)) * 255 / 3)
                b = Int((C / Precision) * 255 / 3)
            Elseif color_settings = 12 Then 'White to black with blue and green in the middle
                If C < precision / 4 Then
                    r = 255
                    g = Int((C / (precision / 4)) * 255)
                    b = Int((C / (precision / 4)) * 255)
                Elseif C < 2 * precision / 4 Then
                    r = Int((1 - (C / (precision / 4))) * 255)
                    g = 255
                    b = Int(((C - (precision / 4)) / (precision / 4)) * 255)
                Elseif C < 3 * precision / 4 Then
                    r = Int((1 - ((C - (2 * precision / 4)) / (precision / 4))) * 255)
                    g = Int((1 - ((C - (2 * precision / 4)) / (precision / 4))) * 255)
                    b = 255
                Else
                    r = 0
                    g = 0
                    b = Int((1 - ((C - (3 * precision / 4)) / (precision / 4))) * 255)
                End If
            Else 'Default color setting - doesn't change with precision
                'Red
                if (C <= (r_freq - r_amp)) Or (C >= (r_freq + r_amp)) Or (C = Precision) Then
                    r = 0
                Elseif (C < r_freq) Then
                    r = 255 - (r_freq - C) / r_amp * 255
                Elseif (C > r_freq) Then
                    r = 255 - (C - r_freq) / r_amp * 255
                Else
                    r = 255
                End If

                'Green
                if (C <= (g_freq - g_amp)) Or (C >= (g_freq + g_amp)) Or (C = Precision) Then
                    g = 0
                Elseif (C < g_freq) Then
                    g = 255 - (g_freq - C) / g_amp * 255
                Elseif (C > g_freq) Then
                    g = 255 - (C - g_freq) / g_amp * 255
                Else
                    g = 255
                End If

                'Blue
                if (C <= (b_freq - b_amp)) Or (C >= (b_freq + b_amp)) Or (C = Precision) Then
                    b = 0
                Elseif (C < b_freq) Then
                    b = 255 - (b_freq - C) / b_amp * 255
                Elseif (C > b_freq) Then
                    b = 255 - (C - b_freq) / b_amp * 255
                Else
                    b = 255
                End If
            End If

            'Color error
            color_error = 0

            If r > 255 Then
                r = 255
                color_error = 1
            Elseif r < 0 Then
                r = 0
                color_error = 1
            End If

            If g > 255 Then
                g = 255
                color_error = 1
            Elseif g < 0 Then
                g = 0
                color_error = 1
            End If

            If b > 255 Then
                b = 255
                color_error = 1
            Elseif b < 0 Then
                b = 0
                color_error = 1
            End If

            If color_error = 1 Then
                color_error_counter = color_error_counter + 1
            End If

            'Reset color error (flag)
            color_error = 0

            'number of total pixels
            total_pixels = total_pixels + 1

            '_________________________________________ Saving pixel to file

            compteur = compteur + 1
            B$ = Chr$(B)
            Put #2, 54 + compteur, B$
      
            compteur = compteur + 1
            g$ = Chr$(g)
            Put #2, 54 + compteur, g$
      
            compteur = compteur + 1
            r$ = Chr$(r)
            Put #2, 54 + compteur, r$
        
            x = x + 1
            xC# = xC# + pas#
        Loop Until x = longueur

        'Progress bar
        'compteur2 = compteur2 + 1
        'loading = 500 * (compteur2 / hauteur)
        'Line (80, 250)-(loading + 80, 260), 2, BF
        
        Locate 18, 27: Color 2: Print RS$(f); "/"; RS$(ni)
        
        'Progress bar
        Progress_bar 80, 244, 500, 10, hauteur - 1, y

        yC# = yC# + pas#
        y = y + 1
        x = 0
    Loop Until y = hauteur

    Locate 23, 11: Color 15: Print "Finist time:   "; Time$
    Locate 24, 11: Color 15: Print "Number of images:"; ni

    'Color errors display
    color_error_percent# = color_error_counter / total_pixels * 100
    If color_error_counter = 0 Then
        color_error_color = 2
    Elseif color_error_percent# < 5 Then
        color_error_color = 14
    Else
        color_error_color = 4
    End If
    Locate 26, 11: Color 15: Print "Number pixels with color errors: "
    Locate 26, 44: Color color_error_color: Print  RS$(color_error_counter); "/"; RS$(total_pixels); " ("; RS$(ROUND(color_error_percent#, 2)); "%)"

    '_______________________________________________________________ End
    Close #2

End Sub

Sub Resolution_select
    Shared longueur, hauteur

    Cls
    Presentation
    Locate 8, 25: Color 15: Print "Normal resolutions:"
    Locate 10, 25: Color 2: Print "F1"
    Locate 10, 28: Color 15: Print "- 1024 x 768"
    Locate 11, 25: Color 2: Print "F2"
    Locate 11, 28: Color 15: Print "- 1440 x 900"
    Locate 12, 25: Color 2: Print "F3"
    Locate 12, 28: Color 15: Print "- 1920 x 1080"
    Locate 13, 25: Color 2: Print "F4"
    Locate 13, 28: Color 15: Print "- 2560 x 1440"

    Locate 16, 25: Color 15: Print "UHD Resolutions:"
    Locate 18, 25: Color 14: Print "F5"
    Locate 18, 28: Color 15: Print "- 3840 x 2160 (4k)"
    Locate 19, 25: Color 14: Print "F6"
    Locate 19, 28: Color 15: Print "- 7680 x 4320 (8k)"
    Locate 20, 25: Color 14: Print "F7"
    Locate 20, 28: Color 15: Print "- 15360 x 8640 (16k)"
    Locate 21, 25: Color 14: Print "F8"
    Locate 21, 28: Color 15: Print "- 30720 x 17280 (32k)"
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
End Sub

Sub BMP_color_profile_select
    Shared color_settings

    Cls
    Presentation
    Locate 8, 25: Color 2: Print "Choose color profile:"
    Locate 9, 25: Color 2: Print "F1"
    Locate 9, 28: Color 15: Print "- Use palette system (nb cycles)"
    Locate 10, 25: Color 2: Print "F2"
    Locate 10, 28: Color 15: Print "- Use palette system (cycle length)"
    Locate 11, 25: Color 2: Print "F3"
    Locate 11, 28: Color 15: Print "- Green/blue on black background"
    'Locate 12, 25: Color 4: Print "F4"
    'Locate 12, 28: Color 15: Print "- To identify/fix"
    'Locate 13, 25: Color 4: Print "F5"
    'Locate 13, 28: Color 15: Print "- To identify/fix"

    'Default color settings
    color_settings = 0

    Do
        w$ = InKey$

        If w$ = Chr$(0) + Chr$(59) Then 'F1
            color_settings = 1
        End If
    
        If w$ = Chr$(0) + Chr$(60) Then 'F2
            color_settings = 2
        End If
    
        If w$ = Chr$(0) + Chr$(61) Then 'F3
            color_settings = 3
        End If
    
        ' If w$ = Chr$(0) + Chr$(62) Then 'F4
        '     color_settings = 4
        ' End If
    
        ' If w$ = Chr$(0) + Chr$(63) Then 'F5
        '     color_settings = 5
        ' End If
    
        'If w$ = Chr$(0) + Chr$(67) Then 'F9
        '    color_settings = 9
        'End If
    
        'If w$ = Chr$(0) + Chr$(68) Then 'F10
        '    color_settings = 10
        'End If
    
        If w$ = Chr$(27) Then 'Esc
            Stop
        End If
    Loop Until color_settings > 0
End Sub