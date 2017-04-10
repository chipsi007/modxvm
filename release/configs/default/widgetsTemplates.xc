﻿/**
 * Widgets templates.
 * Шаблоны виджетов.
 */
{
  "test": {
    "enabled": false,
    // layer - "bottom", "normal" (default), "top".
    // слой - "bottom", "normal" (по-умолчанию), "top".
    "layer": "normal",
    "type": "extrafield",
    "formats": [
      {
        "x": 99,
        "y": 99,
        "width": 200,
        "height": 100,
        "borderColor": "0xFFFFFF",
        "screenHAlign": "right",
        "textFormat": { "color": "0x222222", "size": 15 },
        "format": "TEST TEST TEST TEST\nTEST TEST TEST TEST\nTEST TEST TEST TEST\n"
      },
      {
        "x": 100,
        "y": 100,
        "width": 200,
        "height": 100,
        "borderColor": "0xFFFF00",
        "textFormat": { "color": "0xF4EFE8", "size": 15 },
        "format": "TEST TEST TEST TEST\nTEST TEST TEST TEST\nTEST TEST TEST TEST\n"
      }
    ]
  },
  "test2": {
    "enabled": false,
    // layer - "bottom", "normal" (default), "top".
    // слой - "bottom", "normal" (по-умолчанию), "top".
    "layer": "top",
    "type": "extrafield",
    "formats": [
      {
        "x": 300,
        "y": 500,
        "width": 200,
        "height": 100,
        "borderColor": "0x00FF00",
        "textFormat": { "color": "0xF4EFE8", "size": 15 },
        "format": "TEST2 TEST2 TEST2 TEST2\nTEST2 TEST2 TEST2 TEST2\nTEST2 TEST2 TEST2 TEST2\n"
      }
    ]
  }
}
