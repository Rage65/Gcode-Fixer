param ([string]$file)
$lines = Get-Content $file
$index = 0
$Headder = @"
(v1.6-af)
(Machine)
( vendor: Langmuir)
( model: CrossfirePro XL)
( description: Generic Cutting Machine)
(kerf width for 6061 T6 aluminum with below settings is 1/16" or 1.58mm)
G90 G94 (sets the machine to use absolute positioning and sets feedrate in units per minute)
G17 (Select the XY plane for circular interpolation)
G21 (Set units to mm. G20 is inches.)
H0 (Clears any tool offset in machine, or can instruct selection of first option in machine tool offset table)
(Setting Torch initial Height)
G92 Z0. (Sets current position of Z-axis to zero)
G38.2 Z-127. F2540. (G38.2 initiates probing move with stop upon contact. Down along z-axis for 127mm or before contact. Feedrate for move of 2540mm/min.)
G38.4 Z12.7 F508. (G38.4 is probe move up. Up along z-axis 12.7mm. Feedrate of 508 mm/min.)
G92 Z0. (Above commands seem to find material surface and this command then somehow sets z-axis zero to that surface!)
G0 Z1.0 (IHS Springback + Backlash) (Moves machine up z-axis by value to allow for machine or material springback and/or backlash.)
G92 Z0. (Sets current position of Z-axis to zero)
"@
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match [regex]::Escape("N30")) {
        $index = $i
        break
    }
}
if ($index -gt 0) {
    $lines = @($Headder) + $lines[$index..($lines.Count - 1)]
}
$lines = $lines -replace '^\s*N\d+\s*', '' 
$lines = $lines -replace 'P100', 'P1' 
$lines += "(PS2000)" 
$path = $file + ".nc"
Set-Content -Path $path -Value $lines
