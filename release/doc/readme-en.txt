﻿Content:
  1. Common information
  2. Install
  3. Update
  4. Additional information about config file

-----------------------------------------------------------
1. COMMON INFORMATION
-----------------------------------------------------------

  This mod have many features, like:
    * Customizable vehicle markers
    * Disable Postmortem Panel
    * Vehicle Icons Mirroring Controlling
    * Players Panel Controlling (width, transparency, content)
    * Clock at battle loading screen
    * Player, clan icon
    * Different vehicle icon sets as for the team, well as for ears, battle loading screen, etc.
    * Players statistics
    * Capture bar additional information
    * Customizable minimap
    * Display extended statistics in the company and user info windows
    * Show info about tank in squad window
    * Enemy spotted status at right side panel
    * Crew autoloading mod
    * Displaying ping before login to the server or battle

  Project site:  http://www.modxvm.com/

  Support:       http://www.koreanrandom.com/forum/topic/1383-xvm
  FAQ:           http://www.modxvm.com/en/faq/
  User configs:  http://www.koreanrandom.com/forum/forum/50-custom-configurations

-----------------------------------------------------------
2. INSTALL
-----------------------------------------------------------

  1. Unzip archive to game folder:
     Right click to archive -> "Extract all..." -> select game folder -> "Extract"

  2. You do not need to setup anything by default.

    If you want special settings, you need to rename boot config file:
      \res_mods\xvm\configs\xvm.xc.sample to xvm.xc
    Instructions for setting it up are inside.

    All possible config options you can see in
      \res_mods\xvm\configs\@Default\

    Note: If you want to change the config manually, use Notepad, DO NOT use MS Word,
    WordPad and such editors.

  3. If XVM incorrectly detects the language of the game client,
    then in the configuration file (by default \res_mods\xvm\configs\@default\@xvm.xc)
    change the value of the variable "language" from "auto" to the language code.
    The language code must match the name of the file in the \res_mods\xvm\l10n\ (for example, "en").

  4. There is possibility to install nightly builds of XVM.
    You can download nightly builds on http://nightly.modxvm.com/

-----------------------------------------------------------
3. UPDATE
-----------------------------------------------------------

  1. Unzip archive to game folder:
     Right click to archive -> "Extract all..." -> select game folder -> "Extract"

  2. Do NOT do anything else.

-----------------------------------------------------------
4. ADDITIONAL INFORMATION ABOUT CONFIG FILE
-----------------------------------------------------------

  Mod config files:
    \res_mods\xvm\configs\@Default\
  You can select ready config file from \res_mods\xvm\configs\user configs\ directory

  All possible config options you can see in this file:
    \res_mods\xvm\configs\@Default\


  Supported HTML tags:
    http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#htmlText

  WARNING: Macros in this file is not actual, see macros.txt and macros-hangar.txt for actual macros

  Macros available:
    In players panel, battle loading screen, statistic form and vehicle markers:
      {{nick}}        - player nickname with clan name
      {{name}}        - player nickname without clan name
      {{clan}}        - clan name with brackets (empty if no clan)
      {{clannb}}      - clan name without brackets
      {{squad}}       - value 'sq' for own squad, empty for others
      {{squad-num}}   - number of squad, empty if not in squad
      {{vehicle}}     - vehicle name
      {{vehiclename}} - internal vehicle name (usa-M24_Chaffee)
      {{vtype}}       - vehicle type
      {{level}}       - vehicle level (Arabic numerals)
      {{rlevel}}      - vehicle level (Roman numerals)
      {{hp}}          - current health points
      {{hp-ratio}}    - current health ratio (without '%' sign)
      {{hp-max}}      - maximum health points
      {{c:hp}}        - color depending on current health points (only in vehicle markers)
      {{c:hp-ratio}}  - color depending on current health ratio (only in vehicle markers)
      {{c:vtype}}     - color depending on vehicle type
      {{c:system}}    - system color (disable override color)
      {{a:hp}}        - transparency depending on current health points (only in vehicle markers)
      {{a:hp-ratio}}  - transparency depending on current health ratio (only in vehicle markers)
      {{l10n:blownUp}} - localizated text "Blown-up!", only in "blowupMessage"
      {{battletier}}  - guessed current battle tier
      + statistics macros (see below)

    In players panel, battle loading screen, statistic form only:
      {{frags}}       - current frags
      {{alive}}       - 'alive' for alive, '' for dead

    In vehicle markers only:
      {{turret}}      - stock turret marker:
                          "*" symbol - stock turret, cannot mount top gun
                          "'" symbol - stock turret, top gun is possible
                          empty - top turret
      {{dmg}}         - damage health points
      {{dmg-ratio}}   - damage health ratio (without '%' sign)
      {{dmg-kind}}    - damage kind (attack, fire, ramming, ...)
      {{c:dmg}}       - color depending on damage source
      {{c:dmg-kind}}  - color depending on damage kind

    In Hits Log:
      {{n}}           - total number of hits
      {{n-player}}    - number of hits for each player
      {{dmg}}         - last hit value
      {{dmg-total}}   - total sum of hits
      {{dmg-avg}}     - average damage during the battle
      {{dmg-player}}  - sum of hits for each player
      {{dead}}        - tank's death marker
      {{nick}}        - player nickname with clan name
      {{name}}        - player nickname without clan name
      {{clan}}        - clan name with brackets (empty if no clan)
      {{clannb}}      - clan name without brackets
      {{vehicle}}     - vehicle name
      {{vehiclename}} - internal vehicle name (usa-M24_Chaffee)
      {{vtype}}       - vehicle type
      {{level}}       - vehicle level (Arabic numerals)
      {{rlevel}}      - vehicle level (Roman numerals)
      {{dmg-kind}}    - damage kind (attack, fire, ramming, ...)
      {{c:dmg-kind}}  - color depending on damage kind
      {{c:vtype}}     - color depending on vehicle type
      {{l10n:Hits}}   - localizated text "Hits"
      {{l10n:Total}}  - localizated text "Total"
      {{l10n:Last}}   - localizated text "Last"

    In HP Left:
      {{nick}}        - player nickname with clan name
      {{name}}        - player nickname without clan name
      {{clan}}        - clan name with brackets (empty if no clan)
      {{clannb}}      - clan name without brackets
      {{vehicle}}     - vehicle name
      {{vehiclename}} - internal vehicle name (usa-M24_Chaffee)
      {{vtype}}       - vehicle type
      {{level}}       - vehicle level (Arabic numerals)
      {{rlevel}}      - vehicle level (Roman numerals)
      {{hp}}          - current health points
      {{hp-ratio}}    - current health ratio (without '%' sign)
      {{hp-max}}      - maximum health points
      {{c:vtype}}     - color depending on vehicle type
      {{c:hp}}        - color depending on current health points
      {{c:hp-ratio}}  - color depending on current health ratio
      {{l10n:hpLeftTitle}}  - localizated text "Hitpoints left:", only in "header"

    In Capture bar:
      {{points}}      - points already captured
      {{extra}}       - extra text section; is shows only when timeleft and number of capturers was calculated successfully
      {{tanks}}       - number of capturers; cant define if more than 3; can be placed only inside extra section
      {{time}}        - time left to full capture; minutes and seconds;  can be placed only inside extra section
      {{time-sec}}    - time left to full capture; seconds only;         can be placed only inside extra section
      {{speed}}       - capture speed in points per second;              can be placed only inside extra section
      {{l10n:enemyBaseCapture}}     - localizated text "Base capture by allies!"
      {{l10n:enemyBaseCaptured}}    - localizated text "Base captured by allies!"
      {{l10n:allyBaseCapture}}      - localizated text "Base capture by enemies!"
      {{l10n:allyBaseCaptured}}     - localizated text "Base captured by enemies!"
      {{l10n:Timeleft}}             - localizated text "Timeleft"
      {{l10n:Capturers}}            - localizated text "Capturers"

    In Minimap:
      {{level}}         - subject level
      {{vehicle}}       - subject full vehicle type
      {{vehicle-class}} - places special symbol depending on subject vehicle class
      {{cellsize}}      - minimap cell side size
      {{vehiclename}}   - returns vehicle system name - usa-M24_Chaffee
      {{vehicle-short}} - shortened vehicle name

    In Squad:
      {{level}}          - vehicle level (Arabic numerals)
      {{rlevel}}         - vehicle level (Roman numerals)
      {{vtype}}          - vehicle class (text substitution from config)
      {{vtype-l}}        - vehicle class (text substitution from locale)
      {{battletier-min}} - minimal vehicle battle tier
      {{battletier-max}} - maximal vehicle battle tier

    Statistics macros:
      * Network services on the XVM site (www.modxvm.com) must be activated.

      {{avglvl}}      - average level (tier) of tanks
      {{eff}}         - player efficiency: http://wot-news.com/index.php/stat/calc/en/
      {{eff:4}}       - player efficiency aligned from left to 4 chars
      {{teff}}, {{e}} - player per-vehicle efficiency: http://www.koreanrandom.com/forum/topic/1643-
      {{wn6}}         - WN6 rating: http://www.koreanrandom.com/forum/topic/2575-
      {{wn8}}         - WN8 rating: http://www.koreanrandom.com/forum/topic/2575-
      {{xeff}}        - XVM Scale for efficiency (values 00-99, XX for Tops)
      {{xwn6}}        - XVM Scale for WN6 (values 00-99, XX for Tops)
      {{xwn8}}        - XVM Scale for WN8 (values 00-99, XX for Tops)
      {{rating}}      - GWR (Global Win Ratio)
      {{rating:3}}    - GWR aligned from left to 3 chars
      {{battles}}     - total battles count
      {{wins}}        - total wins count
      {{kb}}          - number of kilo-battles (total battles count divided by 1000)
      {{kb:3}}        - number of kilo-battles aligned from left to 3 chars
      {{t-rating}}    - vehicle win ratio
      {{t-rating:3}}  - vehicle win ratio aligned from left to 3 chars
      {{t-battles}}   - total battles count for current vehicle
      {{t-battles:4}} - number of battles for current vehicle aligned from left to 4 chars
      {{t-wins}}      - total wins count for current vehicle
      {{t-kb}}        - number of kilo-battles for current vehicle
      {{t-kb-0}}      - number of kilo-battles for current vehicle with leading zero
      {{t-kb:4}}      - number of kilo-battles for current vehicle aligned from left to 4 chars
      {{t-hb}}        - number of hecto-battles for current vehicle (hecto = 100)
      {{t-hb:3}}      - number of hecto-battles for current vehicle aligned from left to 3 chars
      {{tdb}}, {{tdb:4}} - average damage for current tank - damage/battles
      {{tdv}} - average damage efficiency for tank - damage/(battles*maxHP)
      {{tfb}} - average frags per battle for current tank
      {{tsb}} - average number of spotted enemies per battle for current tank
      {{c:tdb}}, {{c:tdv}}, {{c:tfb}}, {{c:tsb}} - dynamic colors for this macros
      {{c:eff}}       - color depending on player efficiency
      {{c:e}}         - color depending on player per-vehicle efficiency
      {{c:wn6}}       - color depending on WN6 rating
      {{c:wn8}}       - color depending on WN8 rating
      {{c:xeff}}      - color depending on XVM Scale for efficiency
      {{c:xwn6}}      - color depending on XVM Scale for WN6
      {{c:xwn8}}      - color depending on XVM Scale for WN8
      {{c:rating}}    - color depending on GWR
      {{c:kb}}        - color depending on kilo-battles
      {{c:avglvl}}    - color depending on average level of tanks
      {{c:t-rating}}  - color depending on current vehicle win ratio
      {{c:t-battles}} - color depending on current vehicle battles
      Any color macro you can change to transparency macro (e.g. {{a:tdb}}).

      Extended macros formatting rules:
        {{name[:norm][%[flag][width][.prec]type][~suf][?rep][|def]}}
        name  - macro name

        :norm - value normalization, for example {{hp-ratio:300}} returns values in range 0..300

        flag  - "-" for left align, else right align
                "0" for filling with leading zeros
        width - minimum width
        prec  - depended from the type:
                - maximum width for strings
                - number of digits after comma for float numbers
                - offset of ASCII table for numbers as ASCII char (default 129)
        type  - type
                s - string
                d, i - integer number
                f, F - float number
                x, X - hex number
                a - number as ascii char

        suf   - suffix added at the end
        rep   - value replacement, returned instead of the regular value if the value is present
        def   - default value, set when value is absent:

    Details: http://en.wikipedia.org/wiki/Printf
    For example:
      {{name%-16.16s}}      - cut names longer 10 chars, and fill names shorter 10 chars and align left
      {{kb%4.01f~k|----}}   - width 4 chars, exactly 1 char after comma, align right
                              if kb==null, display "----"

    Localization macros usage - {{l10n:localizationKey}}
      Macros are just links to translations in file res_mods/xvm/l10n/XX.xc file (XX means language code).
      If the translation is not found, "localizationKey" is displayed.

      Capture bar example
        /l10n/en.xc
          "enemyBaseCaptured": "Base captured by allies!"
        captureBar.xc
          "captureDoneFormat":    "<font size='17' color='#FFCC66'>{{l10n:enemyBaseCaptured}}</font>"

        formated: "<font size='17' color='#FFCC66'>Base captured by allies!</font>"

      More about localization at wiki: https://code.google.com/p/wot-xvm/wiki/LocalizingXVM

  "format" field examples:
    1. Show number of kilo-battles, efficiency and GWR without changing a color:
      "{{kb}} {{xwn8}} {{rating}}"
    2. The same, but with each number colored by its value:
      "<font color='{{c:kb}}'>{{kb}}</font> <font color='{{c:xwn8}}'>{{xwn8}}</font> <font color='{{c:rating}}'>{{rating}}</font>"
    3. Same as 2, but with aligned columns:
      "<font face='Consolas' size='11'><font color='{{c:kb}}'>{{kb:3}}</font> <font color='{{c:xwn8}}'>{{xwn8}}</font> <font color='{{c:rating}}'>{{rating:3}}</font></font>"
    4. Show GWR colored by xwn:
      "<font color='{{c:xwn8}}'>{{rating}}</font>"

  Dynamic color and transparency usage examples:
    "color": "{{c:xwn8}}" - color depending on xwn
    "alpha": "{{a:hp}}" - transparency depending on current health

  Clan and players icons.
  Config parameter battle/clanIconsFolder set path to clan icons root folder.

  All icons are loading automatically from game region subfolder (RU/EU/US/... or
  ID for player's account id).

  To add your clan or player icon, just copy icon file to:
    \res_mods\xvm\res\clanicons\[REGION]\clan\ (for clan)
    \res_mods\xvm\res\clanicons\[REGION]\nick\ (for single player)
    \res_mods\xvm\res\clanicons\ID\ (for single player by accountId)
  Also you can create default clan and player icons:
    \res_mods\xvm\res\clanicons\[REGION]\clan\default.png (for default clan)
    \res_mods\xvm\res\clanicons\[REGION]\nick\default.png (for default player)
  Search order is:
    ID/<accountId>.png -> nick/<playerName>.png -> clan/<clan>.png -> clan/default.png -> nick/default.png
  TOP 150 clans are added to mod archive by default.
  Full archive with all clans can be downloaded separately:
    http://www.modxvm.com/en/download-xvm/
    Files: clanicons-full-RU-XXX.zip (RU), clanicons-full-EU-XXX.zip (EU), clanicons-full-NA-XXX.zip (NA),
    clanicons-full-ASIA-XXX.zip (ASIA), clanicons-full-KR-XXX.zip (KR)

  6-th sense image.
  To change sixth sense indicator place alternative PNG image to
   \res_mods\xvm\res\SixthSense.png.

  Hit Log.
  Negative x, y values allow to bind the text to the right and bottom edges for
  the same behavior with different screen resolutions.

  Clock in battle and in battle loading screen.
  Format: PHP Date: http://php.net/date
  For example:
      "clockFormat": "H:i"          => 01:23
      "clockFormat": "Y.m.d H:i:s"  => 2013.05.20 01:23:45

  Efficiency ranges for {{teff}}, {{e}}.
    TEFF       E
    0..299     1 - very bad player
    300..499   2 - bad player
    500..699   3 - poor
    700..899   4 - below average
    900..1099  5 - average
    1100..1299 6 - above average
    1300..1549 7 - good
    1550..1799 8 - great
    1800..1999 9 - master
    2000+      E - Expert (top-100 players on this vehicle)
