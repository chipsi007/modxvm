﻿/**
 * Clock in hangar
 * Часы в ангаре
 */
{
  "clock": {
    "enabled": true,
    "x": -15,
    "y": 40,
    "width": 300,
    "height": 60,
    "topmost": true,                // true - place at top of other windows, false - at bottom
    "align": "right",               // horizontal alignment of field at screen ("left", "center", "right")
    "valign": "top",                // vertical alignment of field at screen ("top", "center", "bottom")
    "textAlign": "right",           // horizontal alignment of text in field ("left", "center", "right")
    "textVAlign": "center",         // vertical alignment of text in field ("top", "center", "bottom")
    "alpha": 100,                   // transparency in percents (0..100)
    "rotation": 0,                  // rotation in degrees (0..360)
    "borderColor": null,            // if set, draw border with specified color ("0xXXXXXX")
    "bgColor": null,                // if set, draw background with specified color ("0xXXXXXX")
    "antiAliasType": "advanced",    // anti aliasing mode ("advanced" or "normal")
    // Macros available (case sensitive):
    // {{Y}}   - full year (4 digits)
    // {{M}}   - month number (1-12)
    // {{MM}}  - short month name (Jan)
    // {{MMM}} - full month name (January)
    // {{D}}   - day number (1-31)
    // {{W}}   - short weekday name (Mon)
    // {{WW}}  - full weekday name (Monday)
    // {{h}}   - hour
    // {{m}}   - minute
    // {{s}}   - second
    "format": "<font face='$FieldFont'><font size='19'>{{W}} {{D%02d}} {{MM}}</font><font size='26'> {{h%02d}}:{{m%02d}}</font></font>",
    "shadow": {
      "enabled": true,
      "distance": 0,             // (in pixels)
      "angle": 0,                // (0.0 .. 360.0)
      "color": "0x000000",       // "0xXXXXXX"
      "alpha": 70,               // (0 .. 100)
      "blur": 4,                 // (0.0 .. 255.0)
      "strength": 2              // (0.0 .. 255.0)
    }
  }
}
