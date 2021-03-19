<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Tetris
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(400,400)
$Form.text                       = "Form"
$Form.TopMost                    = $false

$SCORE                           = New-Object system.Windows.Forms.Label
$SCORE.text                      = "label"
$SCORE.AutoSize                  = $true
$SCORE.width                     = 25
$SCORE.height                    = 10
$SCORE.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$LEVEL                           = New-Object system.Windows.Forms.Label
$LEVEL.text                      = "label"
$LEVEL.AutoSize                  = $true
$LEVEL.width                     = 25
$LEVEL.height                    = 10
$LEVEL.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Form.controls.AddRange(@($SCORE,$LEVEL));

$Global:Counter = 0;
# Används för att lagra samtliga objekt som har skapat
$Global:Objects1 = @();
$Global:Objects2 = @();
$Global:Objects3 = @();
$Global:Objects4 = @();

$Global:ObjectsPos = [System.Collections.ArrayList]@();

$Global:Speed = 10;
$Global:ChangePosX = 0;
$Global:ChangePosY = 0;
$Global:CurrentLevel = 1;
$Global:KeppingScore = 0;

# Skapa en timer som uppdaterar planen och objektet.
$timer1 = New-Object System.Windows.Forms.Timer;
$timer1.Interval = 5;

# Create pen and brush objects 
$myBrush = new-object Drawing.SolidBrush black;

# Get the form's graphics object
$formGraphics = $form.createGraphics()

function Create_objects ( $Object_type ) {

    # Object_type: SQUARE, RECTANGEL, LSHAPE, TRIANGEL
    
    $Global:Objects1 += New-Object system.Windows.Forms.Button;
    $Global:Objects2 += New-Object system.Windows.Forms.Button;
    $Global:Objects3 += New-Object system.Windows.Forms.Button;
    $Global:Objects4 += New-Object system.Windows.Forms.Button;

    switch ( $Object_type ) {
        
        "SQUARE"    {
        
                         $X1 = $Form.Size.Width/2 + 70; $Y1 = 30; 
                         $X2 = $Form.Size.Width/2 + 90; $Y2 = 30; 
                         $X3 = $Form.Size.Width/2 + 70; $Y3 = 50; 
                         $X4 = $Form.Size.Width/2 + 90; $Y4 = 50; 
        
                    }
        "RECTANGEL" { 
                         
                         $X1 = $Form.Size.Width/2 + 50;  $Y1 = 30;
                         $X2 = $Form.Size.Width/2 + 70;  $Y2 = 30;
                         $X3 = $Form.Size.Width/2 + 90;  $Y3 = 30;
                         $X4 = $Form.Size.Width/2 + 110; $Y4 = 30;
                    }
        "LSHAPE"    { 
                         
                         $X1 = $Form.Size.Width/2 + 70;  $Y1 = 30;
                         $X2 = $Form.Size.Width/2 + 90;  $Y2 = 30;
                         $X3 = $Form.Size.Width/2 + 110; $Y3 = 30;
                         $X4 = $Form.Size.Width/2 + 110; $Y4 = 50;
                    }
        "TRIANGEL"  { 
                        
                         $X1 = $Form.Size.Width/2 + 90;  $Y1 = 30;
                         $X2 = $Form.Size.Width/2 + 70;  $Y2 = 50;
                         $X3 = $Form.Size.Width/2 + 90;  $Y3 = 50;
                         $X4 = $Form.Size.Width/2 + 110; $Y4 =  50;
                    }
    }

   
    
    # Kan använda Tag för att avgöra vilken form till den kan få och det beror även på vilken objekt typ som den är.

    $Global:Objects1[$Global:Counter].width                    = 20
    $Global:Objects1[$Global:Counter].height                   = 20
    $Global:Objects1[$Global:Counter].Name                     = $Object_type
    $Global:Objects1[$Global:Counter].Tag                      = 0;
    $Global:Objects1[$Global:Counter].location                 = New-Object System.Drawing.Point($X1, $Y1) #10, 20
    $Global:Objects1[$Global:Counter].Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $Global:Objects1[$Global:Counter].Enabled                  = $False


    $Global:Objects2[$Global:Counter].width                    = 20
    $Global:Objects2[$Global:Counter].height                   = 20
    $Global:Objects2[$Global:Counter].Name                     = $Object_type
    $Global:Objects2[$Global:Counter].Tag                      = 0;
    $Global:Objects2[$Global:Counter].location                 = New-Object System.Drawing.Point($X2, $Y2) #35, 20
    $Global:Objects2[$Global:Counter].Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $Global:Objects2[$Global:Counter].Enabled                  = $False

    $Global:Objects3[$Global:Counter].width                    = 20
    $Global:Objects3[$Global:Counter].height                   = 20
    $Global:Objects3[$Global:Counter].Name                     = $Object_type
    $Global:Objects3[$Global:Counter].Tag                      = 0;
    $Global:Objects3[$Global:Counter].location                 = New-Object System.Drawing.Point($X3, $Y3) #55, 20
    $Global:Objects3[$Global:Counter].Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $Global:Objects3[$Global:Counter].Enabled                  = $False

    $Global:Objects4[$Global:Counter].width                    = 20
    $Global:Objects4[$Global:Counter].height                   = 20
    $Global:Objects4[$Global:Counter].Name                     = $Object_type
    $Global:Objects4[$Global:Counter].Tag                      = 0;
    $Global:Objects4[$Global:Counter].location                 = New-Object System.Drawing.Point($X4, $Y4) #75, 20
    $Global:Objects4[$Global:Counter].Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $Global:Objects4[$Global:Counter].Enabled                  = $False

    $Form.controls.AddRange(@($Global:Objects1[$Global:Counter],$Global:Objects2[$Global:Counter],$Global:Objects3[$Global:Counter],$Global:Objects4[$Global:Counter]));
    
    if ( $Global:Counter -gt 0 ) {
        
        $ThisPosision = random -MAX 4;
        $Global:Objects1[$Global:Counter-1].Tag = $ThisPosision;
        $Global:Objects2[$Global:Counter-1].Tag = $ThisPosision;
        $Global:Objects3[$Global:Counter-1].Tag = $ThisPosision;
        $Global:Objects4[$Global:Counter-1].Tag = $ThisPosision;
    } 

    $Global:Counter++;

    #Direkt efter man har tagit kontroll över objektet skapas ett nytt
}

function changeShape () {

    $ThisPosision = $Global:Objects1[$Global:Counter-1].Tag; #Denna måste vara konstant.
    $Object_type = $Global:Objects1[$Global:Counter-1].Name;

    #Write-Host "SHAPE: $($ThisPosision)"
    #Write-Host "TYPE: $($Object_type)"
    
    $ChangePosision = @{
                         X1 = -1 
                         Y1 = -1
                         X2 = -1 
                         Y2 = -1
                         X3 = -1 
                         Y3 = -1
                         X4 = -1 
                         Y4 = -1
                       };

    switch ( $Object_type ) {

        "SQUARE"    { 
                        $ChangePosision["X1"] = ($Form.Size.Width/2 + 0) - 115; # Justeras till spelplan. Storlek 20x20
                        $ChangePosision["Y1"] = 20;
                        $ChangePosision["X2"] = ($Form.Size.Width/2 + 20) - 115; # Justeras till spelplan. Storlek 20x20
                        $ChangePosision["Y2"] = 20;
                        $ChangePosision["X3"] = ($Form.Size.Width/2 + 0) - 115; # Justeras till spelplan. Storlek 20x20
                        $ChangePosision["Y3"] = 40;
                        $ChangePosision["X4"] = ($Form.Size.Width/2 + 20) - 115; # Justeras till spelplan. Storlek 20x20
                        $ChangePosision["Y4"] = 40;
                            
                        break;
                    }
        "RECTANGEL" { 

                        if ( $ThisPosision -eq 0 ) { 
                            $ChangePosision["X1"] = (($Form.Size.Width/2 + 0) - 135); # Justeras till spelplan. Storlek 20x20
                            $ChangePosision["Y1"] = 20;
                            $ChangePosision["X2"] = (($Form.Size.Width/2 + 20) - 135); # Justeras till spelplan. Storlek 20x20
                            $ChangePosision["Y2"] = 20;
                            $ChangePosision["X3"] = (($Form.Size.Width/2 + 40) - 135); # Justeras till spelplan. Storlek 20x20
                            $ChangePosision["Y3"] = 20;
                            $ChangePosision["X4"] = (($Form.Size.Width/2 + 60) - 135); # Justeras till spelplan. Storlek 20x20
                            $ChangePosision["Y4"] = 20;

                        } elseif ( $ThisPosision -eq 1 ) { 
                            $ChangePosision["X1"] = ($Form.Size.Width/2 - 110); # Justeras till spelplan. Storlek 20x20
                            $ChangePosision["Y1"] = 20;
                            $ChangePosision["X2"] = ($Form.Size.Width/2 - 110); # Justeras till spelplan. Storlek 20x20
                            $ChangePosision["Y2"] = 40;
                            $ChangePosision["X3"] = ($Form.Size.Width/2 - 110); # Justeras till spelplan. Storlek 20x20
                            $ChangePosision["Y3"] = 60;
                            $ChangePosision["X4"] = ($Form.Size.Width/2 - 110); # Justeras till spelplan. Storlek 20x20
                            $ChangePosision["Y4"] = 80;
                        } 
                        break;
                    }
        "LSHAPE"    { 

                        if ( $ThisPosision -eq 0 ) { # 0
                            $ChangePosision["X1"] = $Form.Size.Width/2 - 135; # Justeras till spelplan. 125
                            $ChangePosision["Y1"] = 20;
                            $ChangePosision["X2"] = $Form.Size.Width/2 - 115; # Justeras till spelplan. 105
                            $ChangePosision["Y2"] = 20;
                            $ChangePosision["X3"] = $Form.Size.Width/2 - 95; # Justeras till spelplan. 85
                            $ChangePosision["Y3"] = 20;
                            $ChangePosision["X4"] = $Form.Size.Width/2 - 95; # Justeras till spelplan. 85
                            $ChangePosision["Y4"] = 40;


                        } elseif ( $ThisPosision -eq 1 ) { # 1
                            $ChangePosision["X1"] = $Form.Size.Width/2 - 125; # Justeras till spelplan.
                            $ChangePosision["Y1"] = 20;
                            $ChangePosision["X2"] = $Form.Size.Width/2 - 125; # Justeras till spelplan. 
                            $ChangePosision["Y2"] = 40;
                            $ChangePosision["X3"] = $Form.Size.Width/2 - 105; # Justeras till spelplan. 
                            $ChangePosision["Y3"] = 40;
                            $ChangePosision["X4"] = $Form.Size.Width/2 - 85; # Justeras till spelplan. 
                            $ChangePosision["Y4"] = 40;

                        } elseif ( $ThisPosision -eq 2 ) { # 2
                            $ChangePosision["X1"] = $Form.Size.Width/2 - 110; # Justeras till spelplan.
                            $ChangePosision["Y1"] = 20;
                            $ChangePosision["X2"] = $Form.Size.Width/2 - 110; # Justeras till spelplan.
                            $ChangePosision["Y2"] = 40;
                            $ChangePosision["X3"] = $Form.Size.Width/2 - 110; # Justeras till spelplan. 
                            $ChangePosision["Y3"] = 60;
                            $ChangePosision["X4"] = $Form.Size.Width/2 - 90; # Justeras till spelplan. 
                            $ChangePosision["Y4"] = 60;

                        } elseif ( $ThisPosision -eq 3 ) { # 3
                            $ChangePosision["X1"] = $Form.Size.Width/2 - 110; # Justeras till spelplan.
                            $ChangePosision["Y1"] = 20;
                            $ChangePosision["X2"] = $Form.Size.Width/2 - 90; # Justeras till spelplan. 
                            $ChangePosision["Y2"] = 20; 
                            $ChangePosision["X3"] = $Form.Size.Width/2 - 90; # Justeras till spelplan.
                            $ChangePosision["Y3"] = 40;
                            $ChangePosision["X4"] = $Form.Size.Width/2 - 90; # Justeras till spelplan. 

                            $ChangePosision["Y4"] = 60;
                        }
                        break;
                    }
        "TRIANGEL"  { 

                        if ( $ThisPosision -eq 0 ) { #0
                            $ChangePosision["X1"] = $Form.Size.Width/2 - 115; # Justeras till spelplan.  115
                            $ChangePosision["Y1"] = 20;
                            $ChangePosision["X2"] = $Form.Size.Width/2 - 135; # Justeras till spelplan.  135
                            $ChangePosision["Y2"] = 40;
                            $ChangePosision["X3"] = $Form.Size.Width/2 - 115; # Justeras till spelplan.  115
                            $ChangePosision["Y3"] = 40;
                            $ChangePosision["X4"] = $Form.Size.Width/2 - 95; # Justeras till spelplan.   95
                            $ChangePosision["Y4"] = 40;

                        } elseif ( $ThisPosision -eq 1 ) { #1
                            $ChangePosision["X1"] = $Form.Size.Width/2 - 115; # Justeras till spelplan.  +90
                            $ChangePosision["Y1"] = 20;
                            $ChangePosision["X2"] = $Form.Size.Width/2 - 135; # Justeras till spelplan.  +70
                            $ChangePosision["Y2"] = 20; 
                            $ChangePosision["X3"] = $Form.Size.Width/2 - 115; # Justeras till spelplan.  +90
                            $ChangePosision["Y3"] = 40;
                            $ChangePosision["X4"] = $Form.Size.Width/2 - 95; # Justeras till spelplan. +110
                            $ChangePosision["Y4"] = 20;

                        } elseif ( $ThisPosision -eq 2 ) { #2
                            $ChangePosision["X1"] = $Form.Size.Width/2 - 115; # Justeras till spelplan.  +90
                            $ChangePosision["Y1"] = 20;
                            $ChangePosision["X2"] = $Form.Size.Width/2 - 115; # Justeras till spelplan.  +70
                            $ChangePosision["Y2"] = 40; 
                            $ChangePosision["X3"] = $Form.Size.Width/2 - 93; # Justeras till spelplan.  +90
                            $ChangePosision["Y3"] = 40;
                            $ChangePosision["X4"] = $Form.Size.Width/2 - 115; # Justeras till spelplan. +110
                            $ChangePosision["Y4"] = 60;

                        } elseif ( $ThisPosision -eq 3 ) { #3
                            $ChangePosision["X1"] = $Form.Size.Width/2 - 93; # Justeras till spelplan.  +90
                            $ChangePosision["Y1"] = 20;
                            $ChangePosision["X2"] = $Form.Size.Width/2 - 93; # Justeras till spelplan.  +70
                            $ChangePosision["Y2"] = 40; 
                            $ChangePosision["X3"] = $Form.Size.Width/2 - 115; # Justeras till spelplan.  +90
                            $ChangePosision["Y3"] = 40;
                            $ChangePosision["X4"] = $Form.Size.Width/2 - 93; # Justeras till spelplan. +110
                            $ChangePosision["Y4"] = 60;
                        }
                        break;
                    }
    }
    return $ChangePosision;
}

function NextShape () {

    $CurrentShape = $Global:Objects1[$Global:Counter -1].Tag;
    $Object_type = $Global:Objects1[$Global:Counter-1].Name;
    
    switch ( $Object_type ) {

        "SQUARE"    { 
                        #1
                    }
        "RECTANGEL" { 
                        #2
                        if ( $CurrentShape -le 0 ) {
                            
                            $CurrentShape++;

                        } else {
                            
                            $CurrentShape = 0;
                        }
                        break;
                    }
        "LSHAPE"    { 
                        #4
                        if ( $CurrentShape -le 2 ) {
                            
                            $CurrentShape++;

                        } else {
                            
                            $CurrentShape = 0;
                        }
                        break;
                    }
        "TRIANGEL"  { 
                        #4
                        if ( $CurrentShape -le 2 ) {
                            
                            $CurrentShape++;

                        } else {
                            
                            $CurrentShape = 0;
                        }
                        break;
                    }
    }
    $Global:Objects1[$Global:Counter -1].Tag = $CurrentShape;
    $Global:Objects2[$Global:Counter -1].Tag = $CurrentShape;
    $Global:Objects3[$Global:Counter -1].Tag = $CurrentShape;
    $Global:Objects4[$Global:Counter -1].Tag = $CurrentShape;

    $ChangePosision = changeShape;

    $Global:Objects1[$Global:Counter-1].location = New-Object System.Drawing.Point($ChangePosision.X1, $ChangePosision.Y1);
    $Global:Objects2[$Global:Counter-1].location = New-Object System.Drawing.Point($ChangePosision.X2, $ChangePosision.Y2);
    $Global:Objects3[$Global:Counter-1].location = New-Object System.Drawing.Point($ChangePosision.X3, $ChangePosision.Y3);
    $Global:Objects4[$Global:Counter-1].location = New-Object System.Drawing.Point($ChangePosision.X4, $ChangePosision.Y4);
    UpdateWindow;
}


function getObject ( $random ) {
    
    #SQUARE, RECTANGEL, LSHAPE, TRIANGEL

    switch ( $random ) {

        0 { return "SQUARE";    }
        1 { return "RECTANGEL"; }
        2 { return "LSHAPE";    }
        3 { return "TRIANGEL";  }
        
    }
}

function random ( $MAX ) {
    
    Return Get-Random -Maximum $MAX;
}

$form.add_paint({
        
       $formGraphics.DrawRectangle($myBrush, 10, 10, $Form.Size.Width/2, $Form.Size.Height-100);
       $formGraphics.DrawRectangle($myBrush, $Form.Size.Width/2 + 30, 10, $Form.Size.Width/3.2, $Form.Size.Height/2.8);
})

 function UpdateWindow () {
        
        
        $ChangePosision = @{};
        
        $SCORE.location  = New-Object System.Drawing.Point(($Form.Size.Width/2 + 30), ($Form.Size.Height/2.8 + 45)); #252,189   - 65
        $SCORE.Text      = "SCORE: $Global:KeppingScore";
        $LEVEL.location  = New-Object System.Drawing.Point(($Form.Size.Width/2 + 30), ($Form.Size.Height/2.8 + 64)); #252,208   - 84
        $LEVEL.Text      = "LEVEL: $Global:CurrentLevel";

        if ( $Global:Counter -gt 0 ) {

            $ChangePosision = changeShape;
        
            $ChangePosision["X1"] += $Global:ChangePosX;
            $ChangePosision["X2"] += $Global:ChangePosX;
            $ChangePosision["X3"] += $Global:ChangePosX;
            $ChangePosision["X4"] += $Global:ChangePosX; 
            
            $ChangePosision["Y1"] += $Global:ChangePosY;
            $ChangePosision["Y2"] += $Global:ChangePosY;
            $ChangePosision["Y3"] += $Global:ChangePosY;
            $ChangePosision["Y4"] += $Global:ChangePosY;

            $Global:Objects1[$Global:Counter-1].location = New-Object System.Drawing.Point($ChangePosision.X1, $ChangePosision.Y1);
            $Global:Objects2[$Global:Counter-1].location = New-Object System.Drawing.Point($ChangePosision.X2, $ChangePosision.Y2);
            $Global:Objects3[$Global:Counter-1].location = New-Object System.Drawing.Point($ChangePosision.X3, $ChangePosision.Y3);
            $Global:Objects4[$Global:Counter-1].location = New-Object System.Drawing.Point($ChangePosision.X4, $ChangePosision.Y4);
        }
}


function NewGame () {
    
    # Problem efter återställning. Den försöker att flytta objekten med nu är de försvunna.
    $Global:Objects1.Clear()
    $Global:Objects2.Clear()
    $Global:Objects3.Clear()
    $Global:Objects4.Clear()
    $Global:Counter = 0;
    $Global:ChangePosX = 0;
    $Global:ChangePosY = 0;
    GetLevel;
    ######################################################################################

    Create_objects ( getObject ( random -MAX 3 ) ) # Create_objects ( $Object_type )
    Create_objects ( getObject ( random -MAX 3 ) ) # Create_objects ( $Object_type )
    #Create_objects ( getObject ( 0 ) ) # Create_objects ( $Object_type )
    #Create_objects ( getObject ( 0 ) ) # Create_objects ( $Object_type )
    UpdateWindow;
    GetLevel;
    $timer1.Start();
}

function GetLevel () {
    
    Switch ( $Global:Level ) {
        
        1  { $Global:Speed = 1; }
        2  { $Global:Speed = 2; }
        3  { $Global:Speed = 3; }
        4  { $Global:Speed = 4; }
        5  { $Global:Speed = 5; }
        6  { $Global:Speed = 6; }
        7  { $Global:Speed = 7; }
        8  { $Global:Speed = 8; }
        9  { $Global:Speed = 9; }
        10 { $Global:Speed = 9; }
        11 { $Global:Speed = 10; }
        12 { $Global:Speed = 11; }
        13 { $Global:Speed = 12; }
        14 { $Global:Speed = 13; }
        15 { $Global:Speed = 14; }
        16 { $Global:Speed = 15; }
        17 { $Global:Speed = 16; }
        18 { $Global:Speed = 17; }
        19 { $Global:Speed = 18; }
        20 { $Global:Speed = 19; }
        21 { $Global:Speed = 20; }
    }
}

function NewLevel () {
    
    $Global:Objects1.Clear()
    $Global:Objects2.Clear()
    $Global:Objects3.Clear()
    $Global:Objects4.Clear()
    $Global:Counter = 0;
    $Global:ChangePosX = 0;
    $Global:ChangePosY = 0;
    $Global:CurrentLevel++;
    GetLevel;
    UpdateWindow;
}

function collisionControl () {

    ## Lagrar stillastående objekt
    $Object = New-Object -Type PSObject -Property @{
            'x' = $Global:Objects1[$Global:Counter-1].Location.X,$Global:Objects2[$Global:Counter-1].Location.X,$Global:Objects3[$Global:Counter-1].Location.X,$Global:Objects4[$Global:Counter-1].Location.X
            'y' = $Global:Objects1[$Global:Counter-1].Location.Y,$Global:Objects2[$Global:Counter-1].Location.Y,$Global:Objects3[$Global:Counter-1].Location.Y,$Global:Objects4[$Global:Counter-1].Location.Y
    }

    ## vänster vägg
    #if ( $Global:Objects1[$Global:Counter-1].Location.X -le 20 -or $Global:Objects2[$Global:Counter-1].Location.X -le 20 -or $Global:Objects3[$Global:Counter-1].Location.X -le 20 -or $Global:Objects4[$Global:Counter-1].Location.X -le 20 ) {
    if ( $Global:Objects1[$Global:Counter-1].Location.X -le 0 -or $Global:Objects2[$Global:Counter-1].Location.X -le 0 -or $Global:Objects3[$Global:Counter-1].Location.X -le 0 -or $Global:Objects4[$Global:Counter-1].Location.X -le 0 ) {
        
        ## Anledningen till att den hoppar in till mitten är för att $Global:ChangePosX är en summa av alla vänster eller höger tryckningar.
        ## Det vill säga för att röra sig till exempelvis vänster vägg trycks knappen -20*3 = -60 alltså måste förändringen vara minus det.

        $Global:ChangePosX = $Global:ChangePosX + 20;
    }
     
    ## Höger vägg
    if ($Global:Objects1[$Global:Counter-1].Location.X -ge $Form.Size.Width/2 -or $Global:Objects2[$Global:Counter-1].Location.X -ge $Form.Size.Width/2 -or $Global:Objects3[$Global:Counter-1].Location.X -ge $Form.Size.Width/2 -or $Global:Objects4[$Global:Counter-1].Location.X -ge $Form.Size.Width/2 ) {

        $Global:ChangePosX = $Global:ChangePosX - 20;
    }

    ## Golv
    if ( $Global:Objects1[$Global:Counter-1].Location.Y -ge 330 -or $Global:Objects2[$Global:Counter-1].Location.Y -ge 330 -or $Global:Objects3[$Global:Counter-1].Location.Y -ge 330 -or $Global:Objects4[$Global:Counter-1].Location.Y -ge 330 ) { #312
        
        Write-Host $Global:Objects1[$Global:Counter-1].Location.X;
        Write-Host $Global:Objects1[$Global:Counter-1].Location.Y;
        $Global:ObjectsPos.Add($Object)
        $Global:ChangePosX = 0;
        $Global:ChangePosY = 0;
        #Create_objects ( getObject ( random -MAX 3 ) ) # Create_objects ( $Object_type )
        Create_objects ( getObject ( 0 ) ) # Create_objects ( $Object_type )
        UpdateWindow;
    } 

    $x = @();

    ## Objekt
    for ( $i=0; $i -lt $Global:ObjectsPos.Count; $i++ ) {
  
        if ( ($Global:ObjectsPos[$i].x[0] -eq $Global:Objects1[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[0] -eq ($Global:Objects1[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[0] -eq $Global:Objects2[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[0] -eq ($Global:Objects2[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[0] -eq $Global:Objects3[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[0] -eq ($Global:Objects3[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[0] -eq $Global:Objects4[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[0] -eq ($Global:Objects4[$Global:Counter-1].Location.Y + 20)) ) {
                Write-Host "Träff x1, y1";
                $Global:ObjectsPos.Add($Object)
                $Global:ChangePosX = 0;
                $Global:ChangePosY = 0;
                #Create_objects ( getObject ( random -MAX 3 ) ) # Create_objects ( $Object_type )
                Create_objects ( getObject ( 0 ) ) # Create_objects ( $Object_type )
                UpdateWindow;
            
        } elseif ( ($Global:ObjectsPos[$i].x[1] -eq $Global:Objects1[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[1] -eq ($Global:Objects1[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[1] -eq $Global:Objects2[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[1] -eq ($Global:Objects2[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[1] -eq $Global:Objects3[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[1] -eq ($Global:Objects3[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[1] -eq $Global:Objects4[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[1] -eq ($Global:Objects4[$Global:Counter-1].Location.Y + 20)) ) { 
                Write-Host "Träff x2, y2";
                $Global:ObjectsPos.Add($Object)
                $Global:ChangePosX = 0;
                $Global:ChangePosY = 0;
                #Create_objects ( getObject ( random -MAX 3 ) ) # Create_objects ( $Object_type )
                Create_objects ( getObject ( 0 ) ) # Create_objects ( $Object_type )
                UpdateWindow;
            
        } elseif ( ($Global:ObjectsPos[$i].x[2] -eq $Global:Objects1[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[2] -eq ($Global:Objects1[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[2] -eq $Global:Objects2[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[2] -eq ($Global:Objects2[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[2] -eq $Global:Objects3[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[2] -eq ($Global:Objects3[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[2] -eq $Global:Objects4[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[2] -eq ($Global:Objects4[$Global:Counter-1].Location.Y + 20)) ) { 
                Write-Host "Träff x3, y3";
                $Global:ObjectsPos.Add($Object)
                $Global:ChangePosX = 0;
                $Global:ChangePosY = 0;
                #Create_objects ( getObject ( random -MAX 3 ) ) # Create_objects ( $Object_type )
                UpdateWindow;
            
        } elseif ( ($Global:ObjectsPos[$i].x[3] -eq $Global:Objects1[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[3] -eq ($Global:Objects1[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[3] -eq $Global:Objects2[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[3] -eq ($Global:Objects2[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[3] -eq $Global:Objects3[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[3] -eq ($Global:Objects3[$Global:Counter-1].Location.Y + 20)) -or ($Global:ObjectsPos[$i].x[3] -eq $Global:Objects4[$Global:Counter-1].Location.X -and $Global:ObjectsPos[$i].y[3] -eq ($Global:Objects4[$Global:Counter-1].Location.Y + 20)) ) { 
                Write-Host "Träff x4, y4";
                $Global:ObjectsPos.Add($Object)
                $Global:ChangePosX = 0;
                $Global:ChangePosY = 0;
                #Create_objects ( getObject ( random -MAX 3 ) ) # Create_objects ( $Object_type )
                Create_objects ( getObject ( 0 ) ) # Create_objects ( $Object_type )
                UpdateWindow;
       }
   }


   ## TAK
   if ( ($Global:ObjectsPos[$Global:Counter-3].y -contains $Global:Objects1[$Global:Counter-1].Location.Y -or $Global:ObjectsPos[$Global:Counter-3].y -contains $Global:Objects2[$Global:Counter-1].Location.Y -or $Global:ObjectsPos[$Global:Counter-3].y -contains $Global:Objects3[$Global:Counter-1].Location.Y -or $Global:ObjectsPos[$Global:Counter-3].y -contains $Global:Objects4[$Global:Counter-1].Location.Y) -and ($Global:Objects1[$Global:Counter-1].Location.Y -eq 20 -or $Global:Objects2[$Global:Counter-1].Location.Y -eq 20 -or $Global:Objects3[$Global:Counter-1].Location.Y -eq 20 -or $Global:Objects4[$Global:Counter-1].Location.Y -eq 20) ){
         
        Write-Host "träff: tak"
        $timer1.Stop();
   }
}


$form.Add_KeyDown({
   
    Switch ( $_.KeyCode ) {

        "N" { Write-Host "New Game"; NewGame;                      } # Flytta första pjäs till spelplan och skapa en ny pjäs.
        "A" { $Global:ChangePosX = $Global:ChangePosX - 20; debug; } # VÄNSTER
        "D" { $Global:ChangePosX = $Global:ChangePosX + 20; debug; } # HÖGER      
        "S" { Write-Host "Ändra form"; NextShape                   } # Ändra form

        "P" { Write-Host "Paus"; $timer1.Stop();                   } 
        "R" { Write-Host "Resume"; $timer1.Start();                } 
        "U" { $Global:ChangePosY = $Global:ChangePosY - 10; debug; } # NER
       #"S" { $Global:ChangePosY = $Global:ChangePosY + 20; debug; } # NER

    }

}); $form.KeyPreview = $true

function debug () {
  <#
    Write-Host "POS1: $($Global:Objects1[$Global:Counter-1].Location)";
    Write-Host "POS2: $($Global:Objects2[$Global:Counter-1].Location)";
    Write-Host "POS3: $($Global:Objects3[$Global:Counter-1].Location)";
    Write-Host "POS4: $($Global:Objects4[$Global:Counter-1].Location)";
    #>
}

$timer1.add_Tick({
    
    $Global:ChangePosY = $Global:ChangePosY + 2;
    UpdateWindow;
    $form.Refresh();
    collisionControl;
});

$Form.ShowDialog();
