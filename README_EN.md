# BXB Stage Effects - Complete Documentation

Special effects control system (particles, fire, smoke, fireworks) for FiveM.

## ⚠️ IMPORTANT - Obfuscated Files

**ATTENTION:** The files `client.lua` and `server.lua` are **OBFUSCATED** and **MUST NOT BE MODIFIED**.

- ✅ **Modify ONLY:** `config.lua` and `permissions.lua`
- ❌ **DO NOT modify:** `client.lua`, `server.lua`, `html/script.js`, `html/style.css`, `html/index.html`

All configuration is done through the `config.lua` file. It is not necessary and not allowed to modify the obfuscated files.

## Commands

*   `/efeitos` - Opens the special effects control panel. (Requires admin permission)

---

## Simplified Configuration (config.lua)

The configuration has been simplified for easier use. You only need to configure:

1. **Stage Area** (allowed zone)
2. **Button name** (Label)
3. **Effect** (pre-configured effect name)
4. **Coordinates** (where the effect will appear)
5. **Rotation** (optional, default 0.0)

### 1. Allowed Zones

Configure where commands can be used:

```lua
Config.AllowedZones = {
    {
        Coords = vector3(1109.93, -694.79, 57.42), -- Stage center coordinates
        Radius = 50.0 -- Radius in meters
    }
}
```

---

### 2. Available Effects

#### PARTICULAS (Interaction: "hold" - Hold to activate)

| Effect Name | Description |
|-------------|-------------|
| **Fire** | Fire flames (fast burst) |
| **Smoke** | Continuous smoke/vapor |
| **Spark** | Sparks (burst) |
| **Confetti** | Colored confetti (burst) |

#### FIREWORKS (Interaction: "toggle" - Click to turn on)

| Effect Name | Description |
|-------------|-------------|
| **Color 1** | Colorful fireworks (red/white/blue) |
| **Color 2** | Colorful fireworks (green/red/white) |
| **White** | White fireworks |
| **Stars** | Star-shaped fireworks (with prop) |

---

### 3. Configuration Structure

#### PARTICULAS Category

```lua
{
    Label = "PARTICULAS",        -- REQUIRED: Must be exactly "PARTICULAS"
    Items = {
        {
            Label = "Fire",              -- Button name
            Effect = "Fire",             -- Effect name (see table above)
            Coords = vector3(x, y, z),   -- Coordinates where it will appear
            Rotation = 0.0                -- Rotation (optional, default 0.0)
        }
    }
}
```

**Note:** `Interaction` and `ShowStop` are automatically set:
- `Interaction = "hold"` (hold to activate)
- `ShowStop = false` (does not show STOP ALL)

#### FIREWORKS Category

```lua
{
    Label = "FIREWORKS",         -- REQUIRED: Must be exactly "FIREWORKS"
    Items = {
        {
            Label = "Color 1",
            Effect = "Color 1",
            Coords = vector3(x, y, z),   -- Single coordinate
            Rotation = 0.0
        },
        -- OR multiple coordinates:
        {
            Label = "White",
            Effect = "White",
            Coords = {
                vector3(x1, y1, z1),
                vector3(x2, y2, z2),
                vector3(x3, y3, z3)
            },
            Rotation = 0.0
        }
    }
}
```

**Note:** `Interaction` and `ShowStop` are automatically set:
- `Interaction = "toggle"` (click to turn on, continues until stopped)
- `ShowStop = true` (shows STOP ALL button)

---

### 4. Complete Configuration Example

```lua
Config = {}

-- 1. Allowed Zone
Config.AllowedZones = {
    {
        Coords = vector3(1109.93, -694.79, 57.42),
        Radius = 50.0
    }
}

-- 2. Categories and Effects
Config.Categories = {
    {
        Label = "PARTICULAS",
        Items = {
            {
                Label = "Fire",
                Effect = "Fire",
                Coords = vector3(1109.93, -694.79, 57.42),
                Rotation = 0.0
            },
            {
                Label = "Smoke",
                Effect = "Smoke",
                Coords = vector3(1109.93, -694.79, 57.42),
                Rotation = 0.0
            },
            {
                Label = "Spark",
                Effect = "Spark",
                Coords = vector3(1109.93, -694.79, 57.42),
                Rotation = 0.0
            },
            {
                Label = "Confetti",
                Effect = "Confetti",
                Coords = vector3(1109.93, -694.79, 57.42),
                Rotation = 0.0
            }
        }
    },
    {
        Label = "FIREWORKS",
        Items = {
            {
                Label = "Color 1",
                Effect = "Color 1",
                Coords = {
                    vector3(1098.82, -700.15, 73.12),
                    vector3(1097.75, -689.26, 73.12)
                },
                Rotation = 0.0
            },
            {
                Label = "Color 2",
                Effect = "Color 2",
                Coords = {
                    vector3(1114.15, -671.89, 81.27),
                    vector3(1120.28, -713.18, 76.73)
                },
                Rotation = 0.0
            },
            {
                Label = "White",
                Effect = "White",
                Coords = {
                    vector3(1120.0, -692.0, 60.0),
                    vector3(1128.0, -692.0, 60.0),
                    vector3(1124.0, -688.0, 60.0),
                    vector3(1124.0, -696.0, 60.0)
                },
                Rotation = 0.0
            },
            {
                Label = "Stars",
                Effect = "Stars",
                Coords = {
                    vector3(1126.71, -696.02, 57.42),
                    vector3(1125.87, -688.28, 57.42)
                },
                Rotation = 0.0
            }
        }
    }
}
```

---

### 5. Configuration Parameters

#### Category

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `Label` | string | ✅ Yes | Category name in menu. Must be exactly **"PARTICULAS"** or **"FIREWORKS"** |
| `Items` | table | ✅ Yes | List of effects (array of items) |

**Automatic Values (not configurable):**
- **PARTICULAS**: `Interaction = "hold"`, `ShowStop = false`
- **FIREWORKS**: `Interaction = "toggle"`, `ShowStop = true`

#### Item (Effect)

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `Label` | string | ✅ Yes | Button name in menu |
| `Effect` | string | ✅ Yes | Pre-configured effect name (see effects table) |
| `Coords` | vector3/table | ✅ Yes | Single coordinate or array of coordinates |
| `Rotation` | number | ❌ No | Effect rotation (default: 0.0) |

---

### 6. Coordinates

You can use a single coordinate or multiple coordinates:

**Single coordinate:**
```lua
Coords = vector3(1109.93, -694.79, 57.42)
```

**Multiple coordinates (array):**
```lua
Coords = {
    vector3(1109.93, -694.79, 57.42),
    vector3(1110.22, -687.66, 57.24),
    vector3(1111.68, -700.24, 57.24)
}
```

**Note about Props:** 
- For **PARTICULAS** (hold): The system automatically creates a `prop_cs_pour_tube` prop at each coordinate
- For **FIREWORKS** (toggle): Props are NOT created, EXCEPT for the "Stars" effect which always has props
- Particles appear 0.15 units above the prop (or coordinate if there's no prop)

---

### 7. How It Works

#### PARTICULAS Category (Interaction: "hold")
- **Hold button:** Effect activates and continues while button is pressed
- **Release button:** Effect stops immediately
- **Props:** Automatically created at all coordinates

#### FIREWORKS Category (Interaction: "toggle")
- **Click button:** Effect starts and continues until stopped
- **Click "STOP ALL":** Stops all active effects in the category
- **Props:** NOT automatically created (except for "Stars")

---

### 8. Tips

1. **Coordinates:** Use a coordinate editor (like MLO Editor) to get precise coordinates
2. **Testing:** Always test effects in-game to verify coordinates are correct
3. **Multiple Coordinates:** Use multiple coordinates to create effects at several points simultaneously
4. **Rotation:** Rotation is optional, use only if you need to adjust the effect direction

---

## Permissions (permissions.lua)

The `permissions.lua` file controls access to the effects panel.

### Adding Admins

Edit `Config.Admins` to add IDs:

```lua
Config.Admins = {
    "discord:1234567890123456",
    "discord:9876543210987654"
}
```

---

## Support

For problems or questions, check:
1. If coordinates are correct
2. If the effect name is correct (see available effects table)
3. If allowed zones are configured
4. If the config structure is correct
