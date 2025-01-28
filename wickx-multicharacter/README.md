# wickx-multicharacter
Multi Character Feature for WKX-Core Framework :people_holding_hands:

Added support for setting default number of characters per player per Rockstar license

# License

    WKXCore Framework
    Copyright (C) 2021 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>


## Dependencies
- [wickx-core](https://github.com/wickxcore-framework/wickx-core)
- [wickx-spawn](https://github.com/wickxcore-framework/wickx-spawn) - Spawn selector
- [wickx-apartments](https://github.com/wickxcore-framework/wickx-apartments) - For giving the player a apartment after creating a character.
- [wickx-clothing](https://github.com/wickxcore-framework/wickx-clothing) - For the character creation and saving outfits.
- [wickx-weathersync](https://github.com/wickxcore-framework/wickx-weathersync) - For adjusting the weather while player is creating a character.

## Screenshots
![Character Selection](https://cdn.discordapp.com/attachments/934470871333105674/1014215694394589294/unknown.png)
![Character Registration](https://cdn.discordapp.com/attachments/934470871333105674/1014215687700488304/unknown.png)

## Features
- Ability to create up to 5 characters and delete any character.
- Ability to see character information during selection.

## Installation
### Manual
- Download the script and put it in the `[wickx]` directory.
- Add the following code to your server.cfg/resouces.cfg
```
ensure wickx-core
ensure wickx-multicharacter
ensure wickx-spawn
ensure wickx-apartments
ensure wickx-clothing
ensure wickx-weathersync
```
