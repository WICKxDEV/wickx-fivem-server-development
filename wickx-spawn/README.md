# wickx-spawn
Spawn Selector for WKX-Core Framework :eagle:

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
- [wickx-houses](https://github.com/wickxcore-framework/wickx-houses) - Lets player select the house
- [wickx-apartment](https://github.com/wickxcore-framework/wickx-apartment) - Lets player select the apartment
- [wickx-garages](https://github.com/wickxcore-framework/wickx-garages) - For house garages

## Screenshots
![Spawn selector](https://i.imgur.com/nz0mPGe.png)

## Features
- Ability to select spawn after selecting the character

## Installation
### Manual
- Download the script and put it in the `[wickx]` directory.
- Add the following code to your server.cfg/resouces.cfg
```
ensure wickx-core
ensure wickx-spawn
ensure wickx-apartments
ensure wickx-garages
```

## Configuration
An example to add spawn option
```
WKX.Spawns = {
    ["spawn1"] = { -- Needs to be unique
        coords = vector4(1.1, -1.1, 1.1, 180.0), -- Coords player will be spawned
        location = "spawn1", -- Needs to be unique
        label = "Spawn 1 Name", -- This is the label which will show up in selection menu.
    },
    ["spawn2"] = { -- Needs to be unique
        coords = vector4(1.1, -1.1, 1.1, 180.0), -- Coords player will be spawned
        location = "spawn2", -- Needs to be unique
        label = "Spawn 2 Name", -- This is the label which will show up in selection menu.
    },
}
```
