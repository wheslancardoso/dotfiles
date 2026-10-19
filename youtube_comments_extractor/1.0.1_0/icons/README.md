# Icon Generation Instructions

Since Chrome extensions require PNG icons and we can't generate binary files directly,
you'll need to create the icons yourself. Here are your options:

## Option 1: Use the SVG and Convert

1. Open `icon.svg` in a browser or image editor
2. Export/save as PNG in three sizes:
   - 16x16 pixels → save as `icon16.png`
   - 48x48 pixels → save as `icon48.png`
   - 128x128 pixels → save as `icon128.png`

## Option 2: Online Converter

1. Go to https://convertio.co/svg-png/ or similar
2. Upload `icon.svg`
3. Convert and resize to the three sizes needed

## Option 3: Use ImageMagick (if installed)

```bash
convert -background none icon.svg -resize 16x16 icon16.png
convert -background none icon.svg -resize 48x48 icon48.png
convert -background none icon.svg -resize 128x128 icon128.png
```

## Option 4: Create Simple Placeholder Icons

You can also use any YouTube-related icon or create simple colored squares temporarily.
The extension will work without icons, but Chrome will show a default puzzle piece icon.

## Quick Fix: Remove Icons Temporarily

If you want to test the extension immediately without icons, edit `manifest.json`:

1. Remove the `"default_icon"` section from `"action"`
2. Remove the `"icons"` section

The extension will still work, just without a custom icon.
