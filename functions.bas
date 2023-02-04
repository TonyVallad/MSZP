'-----------------------------------------------------------------------
'           This file contains all functions used in MSZP
'-----------------------------------------------------------------------

'Removes leading space and adds a leading 0 when necesarry
FUNCTION RS$(num#)
    temp$ = STR$(num#)
    WHILE LEFT$(temp$,1) = " "
        temp$ = RIGHT$(temp$, LEN(temp$)-1)
    WEND
    'Adds leading 0 when necesarry
    IF LEFT$(temp$,1) = "." THEN
        temp$ = "0" + temp$
    END IF

    'Sends back string
    RS$ = temp$
END FUNCTION

'Round function
FUNCTION ROUND#(num, dec)
    'Sends back rounded value
    ROUND# = INT(num * 10^dec + 0.5) / 10^dec
END FUNCTION

'Converts an integer to a string of ASCII characters
FUNCTION IntToASCII$(num)
    a% = Int(num / 256 ^ 3)
    b% = Int((num - a% * 256 ^ 3) / 256 ^ 2)
    c% = Int((num - a% * 256 ^ 3 - b% * 256 ^ 2) / 256)
    d% = Int(num - a% * 256 ^ 3 - b% * 256 ^ 2 - c% * 256)

    'Sends back ASCII code
    IntToASCII$ = Chr$(d%) + Chr$(c%) + Chr$(b%) + Chr$(a%)
END FUNCTION

'Calculates elapsed time - Works with max 1 date change.
FUNCTION Elapsed_time$(time_start, date_start$, time_end, date_end$)
    Elapsed_time$ = ""

    If date_start$ = date_end$ Then
        elapsed_in_seconds = time_end - time_start
    Else
        elapsed_in_seconds = 86400 - time_start + time_end
    End If

    hours = int(elapsed_in_seconds / 3600)
    minutes = int((elapsed_in_seconds MOD 3600) / 60)
    seconds = int(elapsed_in_seconds MOD 60)

    If hours > 0 Then
        Elapsed_time$ = RS$(hours) + "h " + RS$(minutes) + "m " + RS$(seconds) + "s"
    ElseIf minutes > 0 Then
        Elapsed_time$ = RS$(minutes) + "m " + RS$(seconds) + "s"
    Else
        Elapsed_time$ = RS$(seconds) + "s"
    End If
END FUNCTION