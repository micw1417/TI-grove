# build.ps1

# ----------------------------
#  Directories
# ----------------------------
$BUILDDIR = "build"
$OBJDIR   = "$BUILDDIR\obj"
$BINDIR   = "$BUILDDIR\bin"
$OUT      = "$BINDIR\blink.elf"

# Create build directories if missing
New-Item -ItemType Directory -Force -Path $OBJDIR, $BINDIR | Out-Null

# TI Directories
$TI_CSS_DIR = "C:\ti\ccs1281\ccs"
$DEBUG_BIN_DIR = "$TI_CSS_DIR\css_base\DebugServer\bin"
$DEBUG_DRIVERS_DIR = "$TI_CSS_DIR\css_base\DebugServer\drivers"

# ----------------------------
# Compiler & MCU settings
# ----------------------------
$CC      = "msp430-elf-gcc"
$MCU     = "-mmcu=msp430g2553"
$INCLUDES= "-IC:\ti\msp430-gcc\include"
$LINKER  = "-LC:\ti\msp430-gcc\include"
$env:PATH = "$DEBUG_BIN_DIR;$DEBUG_DRIVERS_DIR;" + $env:PATH
$DEBUG = "mspdebug"
# Compiler flags
$CFLAGS  = @(
    "-Og",  # Optimize for debugging
    "-g",   # Generate debug info
    "-Wall" # All warnings
)



# ----------------------------
# Clean mode
# ----------------------------
if ($args[0] -eq "clean") {
    Remove-Item "$BUILDDIR\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Cleaned build files"
    exit
}

# ----------------------------
# Flash mode
# ----------------------------
if ($args[0] -eq "flash") {
    if (!(Test-Path $OUT)) {
        Write-Host "ELF not found. Build first."
        exit 1
    }

    Write-Host "Flashing $OUT to MSP430..."
    & $DEBUG tilib "prog $OUT"
    exit
}
# ----------------------------
# Gather source files
# ----------------------------
$SRCPATH = "src"
$SRC = Get-ChildItem -Filter *.c -Path $SRCPATH

# Manual specific if wanted
# $SRC = @(
    #     "src\main.c",
    #     "src\led.c")

# Map source files to object files
$OBJ = $SRC | ForEach-Object { Join-Path $OBJDIR ($_.BaseName + ".o") }

# ----------------------------
# Compile each source file
# ----------------------------
for ($i = 0; $i -lt $SRC.Count; $i++) {
    $srcFile = $SRC[$i].FullName
    $objFile = $OBJ[$i]
    
    # Only compile if object is missing or source is newer
    if (!(Test-Path $objFile) -or ($SRC[$i].LastWriteTime -gt (Get-Item $objFile).LastWriteTime)) {
        Write-Host "Compiling $($SRC[$i].Name) → $objFile"
        & $CC $MCU $INCLUDES $CFLAGS "-c" $srcFile "-o" $objFile
    } else {
        Write-Host "Skipping $($SRC[$i].Name), up-to-date"
    }
}

# ----------------------------
# Link object files into final executable
# ----------------------------
Write-Host "Linking to $OUT"
& $CC $MCU $LINKER $OBJ "-o" $OUT
Write-Host "Build complete: $OUT"