# Making a MAME layout match a photo of the hardware

A workflow for an agent: given an image of a device's front panel, write or improve the machine's MAME layout (`mame/src/mame/layout/<name>.lay`) until the plugin's panel looks like the image. The plugin reloads the layout whenever the file changes, and its MCP server takes screenshots, so each change can be checked against the image in a few seconds, without building MAME.

## What you need

- A built muse tree (`./build.sh`, see the README) with the machine's ROMs in `~/.local/share/mame-plugin/<machine>/roms`.
- The reference image, ideally a straight front view. Crop it to the panel and note its size in pixels.
- ImageMagick (`magick`) for cropping, scaling and comparing images, and the `Read` tool to look at them.
- MAME's layout reference: `mame/docs/source/techspecs/layout_files.rst` (elements, components, views, groups, `repeat`, parameters, inputs and outputs). Existing layouts in `mame/src/mame/layout/` are good examples; `tx81z.lay` is small, `linn_linndrum.lay` uses groups, repeats and parameters.

## 1. Find out what the layout has to connect to

A layout draws artwork, but its buttons, LEDs and screens are bound to the driver:

- **Screens:** `<screen index="0">`, one per `screen_device` of the driver (`SCREEN(config, ...)` in `mame/src/mame/<maker>/<driver>.cpp`).
- **Buttons and knobs:** items with `inputtag="<port>" inputmask="<mask>"`, from the driver's `INPUT_PORTS_START` block (`PORT_START("P2")`, `PORT_BIT(0x40, ...)`). Adjusters (`PORT_ADJUSTER`) can be knobs or sliders: the plugins make them draggable and turn them into parameters (see `docs/layout-loader.md`).
- **LEDs and lamps:** items with `name="<output>"`, the names the driver gives its outputs (`m_leds[...]`, `output().set_value("led1", ...)`, `append_output("led1")`).
- **The layout's name:** `config.set_default_layout(layout_<name>)` and `#include "<name>.lh"` in the driver. A new layout needs nothing else: the build compiles `src/mame/layout/<name>.lay` for a driver that includes `<name>.lh`.

Write these down before drawing anything: the image tells you where things are, the driver what they are called.

## 2. Work on the layout with live reload

Link the repository's layout into the machine's data folder, where the plugins look for layout files, and start the stand-alone application with reloading on:

```sh
cd muse
ln -sf "$PWD/mame/src/mame/layout/<name>.lay" ~/.local/share/mame-plugin/<machine>/default.lay
MAME_PLUGIN_LAYOUTDEV=1 ./gearmulator/bin/plugins/Release/Standalone/MAME-<Machine> > /tmp/<machine>.log 2>&1 &
```

- Every save of the `.lay` file is shown within half a second, while the machine keeps running.
- A file that doesn't parse leaves the compiled layout on screen; MAME's error, with line and column, is in the log: `grep -i "error" /tmp/<machine>.log`. Check the log after every save: a screenshot of the old layout looks like "nothing changed".
- Only the panel is reloaded. The editor's size comes from the product's skin, not from the layout: `gearmulator/source/mame/<product>JucePlugin/skins/mameDefault/mameDefault.rcss` sets the `body` to the layout's natural size in `dp`. If the view's aspect changes, the panel is letterboxed in the old size until the skin is changed and the application rebuilt; restarting isn't enough. Crop the letterbox off screenshots meanwhile (the panel is centred at the window's width).
- For a machine without a plugin product yet, use `mpctest` instead (section 5).

Remove the link when done (`rm ~/.local/share/mame-plugin/<machine>/default.lay`); the next build compiles the edited file into the library.

## 3. Take screenshots over MCP

The application runs an MCP server (HTTP, JSON-RPC). Its port is in `~/.gearmulator_mcp.json`:

```sh
port=$(python3 -c "import json; print(json.load(open('$HOME/.gearmulator_mcp.json'))[0]['port'])")
mcp() { curl -s -X POST "http://127.0.0.1:$port/mcp" -H 'Content-Type: application/json' \
  -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"$1\",\"arguments\":${2:-{\}}}}"; }

mcp screenshot                      # {"path": "/tmp/gearmulator_screenshot.png"}
mcp get_gui_scale                   # {"scale": 126, "width": 1859, "height": 172}
mcp mouse_click_at '{"x":853,"y":90}'
mcp mouse_drag '{"fromX":885,"fromY":412,"toX":885,"toY":505}'
mcp exit                            # quit the application
```

- `tools/list` instead of `tools/call` lists all tools with their arguments.
- Screenshots are of the editor at its current size; coordinates of the mouse tools are in the same pixels. The size changes with the window and the GUI scale (`get_gui_scale`, `set_gui_scale`), so read it before using coordinates.
- Don't take screenshots of the desktop: `screenshot` captures only the plugin's editor.
- `mcp set_gui_scale '{"scale":200}'` gives screenshots twice as sharp for zoomed comparisons; mouse coordinates scale with it.
- `record_start`, `send_note` and `record_stop` capture the audio output with its peak and RMS, to check that a control does something. A level doesn't show a change of timbre (e.g. drawbars), so listen or compare spectra for those.
- `MAME_PLUGIN_NATIVELAYOUT=1` has the plugin draw the layout itself instead of showing MAME's rendering. Both should look the same; compare with the bitmap panel (the default) while matching a photo, since that is MAME's reference rendering.

## 4. Compare with the image

Scale the screenshot to the reference image's size (or the other way round), then compare side by side and as a difference image:

```sh
ref=panel.png; shot=/tmp/gearmulator_screenshot.png
size=$(magick identify -format "%wx%h" "$ref")
magick "$shot" -resize "$size!" shot.png
magick "$ref" shot.png -append side.png                                         # one above the other
magick "$ref" shot.png -compose difference -composite -auto-level diff.png      # bright = different
magick compare -metric RMSE "$ref" shot.png null: 2>&1                         # one number, lower is better
```

To measure positions, a small script that crops a region, scales it up and draws a labelled coordinate grid every 5 or 10 pixels is worth writing first: positions and sizes can then be read off directly. Pillow and numpy aren't installed system-wide; `uv venv` in the scratchpad and `uv pip install pillow numpy` give them. A median colour over a small area of the image (`numpy.median`) picks clean colours from a photo.

Look at `side.png` and `diff.png` with `Read`. Crop and zoom into one area at a time (`magick side.png -crop 300x120+X+Y -scale 300% zoom.png`): whole-panel images hide small offsets. A photo never matches pixel for pixel (lighting, perspective, printing); use the RMSE to see whether a change helped, and your eyes for whether it's right.

## 5. Without a plugin product: mpctest

`mpctest` (`mame/src/osd/plugin/test/mpctest.c`, build line in its header) runs any machine of the library and writes the panel as an image each second, without a window:

```sh
MPCTEST_OPTIONS="artpath=$HOME/art" MPCTEST_PANEL=/tmp/p MPCTEST_BOOT=60 \
  ./mpctest mame/libmame_synths.so <machine> ~/.local/share/mame-plugin/<machine>/roms /tmp/out.wav 4 /tmp/data
magick /tmp/p.0.3.ppm shot.png     # the panel after 3 seconds
```

The layout file goes to `$HOME/art/<machine>/default.lay`. `MPCTEST_PANEL_SCALE=2` renders at twice the natural size, `MPCTEST_CLICK=x,y,t0,t1[,x1,y1]` clicks or drags (several separated by `;`), and `MPCTEST_LAYOUT=1` also composes the panel from the layout description the native view uses, and reports how many pixels differ from MAME's rendering.

## 6. How to approach the layout

1. **Set the coordinate system from the image.** Make the view's bounds the image's size in pixels (`<bounds x="0" y="0" width="912" height="480"/>` on a background element), so positions measured in the image are the layout's coordinates. MAME scales the view to any size.
2. **Background first.** One element with the panel's colour, or the photo itself as an `<image>` component while you work: items placed on top of it show their offsets directly. Remove the photo before committing; MAME layouts are drawn, not photographs.
3. **Measure, don't guess.** Read positions and sizes of buttons, LEDs, the display and labels from the image (crop and zoom it, or find edges with `magick ... -crop` and look). Put the measured numbers into `<bounds>`.
4. **Use groups and repeats** for rows of identical controls: one `<group>` with parameters for the label and input, placed with `<repeat>`. It keeps the file short and the spacing exact.
5. **Bind as you go.** Give each button its `inputtag`/`inputmask` and each LED its `name`, then click it over MCP and check the machine reacts (the display changes, the LED lights). An unbound button looks right and does nothing.
6. **Iterate one area at a time:** edit, save, check the log, screenshot, compare the zoomed area, repeat. Commit when an area matches.
7. **Text:** layout `<text>` uses MAME's font; match size and position, not the typeface. Small print that MAME can't render legibly at the panel's size can be left out. The text fills its bounds' height, and its capitals are about half of it: for a 9 pixel cap height, use a height of about 18. If the text is wider than its bounds it is squeezed horizontally, so a width set to the measured width of the printed text imitates a condensed panel font. MAME has no bold; drawing a text twice, half a pixel apart, looks bold when scaled up, but item bounds are rounded to whole pixels in the native view, so at 100 % some labels come out bold and others not. Don't.

### Generating the layout

A panel has a few hundred items. A script that writes the `.lay` (Python, with the measurements, colours and port mappings in one place) is easier to iterate than editing XML: each run rewrites the file, live reload shows it. Things that worked for the EX-20 (`wersiex20.lay`):

- **Artwork as SVG:** rounded boxes, outlines, connector lines, bezels, logos and switches can be one `<image>` element whose `<data>` holds an SVG (`<![CDATA[<svg ...>...</svg>]]>`), with the image's coordinates as its `viewBox`. MAME draws it sharp at any size. Its SVG renderer (nanosvg) does paths, rects, circles, fills and strokes, but no text: labels stay layout `<text>` items over it. Stroking a path in white and then again thinner in the background colour gives inline (outlined) lettering for a logo.
- **The view's bounds can be part of the image:** keep the image's pixels as coordinates and set the view to the panel itself (e.g. `x="5" y="4"`), leaving out the photo's border.
- **Buttons with LEDs:** one item per button with both `name="<led output>"` and `inputtag`/`inputmask`; the element has a state 0 and 1 image (LED off and on). The state follows the LED, a click presses the input.
- **Sliders:** an item with `<animate inputtag="<port>" inputmask="0xff"/>` and two `<bounds state="0" .../>`, `<bounds state="255" .../>` for the ends of its travel, on an analog port (`IPT_POSITIONAL`, `IPT_PADDLE`, adjusters), is dragged by the plugins without any script.
- **What depends on several outputs:** an item follows one output, and layouts can't combine outputs without a script, which the plugins don't run. Have the driver publish the combined state as an output of its own, the way display devices publish a character per output (`vfd0`…), and give the element one component per value (`<text state="9" .../>`, `<image state="9">`). The EX-20's function matrix shows a different overlay for each combination of its E–H LEDs from the driver's `matrix_page` output.
- **LEDs behind shift registers:** a driver that sets its LED outputs on every shift clock shows the partly shifted patterns too, and a key scan through the same registers shows its walking bit as LEDs. Log the clocks with the machine time first (a file, as the plugins don't show stderr) to see how the firmware uses them, then publish the LEDs when a burst has ended (a timer restarted by each clock, `ex20.cpp`'s `panel_burst_end`). Polling at intervals can land inside a burst or a scan.
- **Decoration for what the driver lacks:** controls of the hardware without an input (a reset button, unemulated faders) can be drawn without a binding, but say so in the commit.

### Keep the iterations

Copy each generated layout and its screenshot to a numbered pair (`NN_layout.xml`, `NN_shot.png`) in a folder the user can look at (e.g. `mocks/<machine>/wip/`, ignored by git), together with the generator, so the work can be followed and an earlier step compared or restored.

## 7. Checking the result

- No errors in the log for the final file.
- Every input of the driver's front panel is reachable by a click, every LED lights when it should.
- `MPCTEST_LAYOUT=1` reports (almost) no differences, so the native view shows it the same way.
- Every control the layout binds is read by the driver. A port that exists isn't necessarily used: the EX-20's drawbar and volume ports were bound in the layout but the driver returned fixed values for them, left from its development. Check the driver's read handlers for commented-out reads and hard-coded values.
- The stand-alone application loads the `libmame_synths.so` beside it (`gearmulator/bin/plugins/Release/Standalone/`), which `build.sh` copies there. After building only the MAME library (`make -C mame ...`, see `build.sh`) to try a driver change, copy it there yourself.
- Remove the link and build (`FORMATS="Standalone" ./build.sh`; the default formats, CLAP and VST3, don't rebuild the stand-alone applications), then start the application: the compiled layout is the one you edited, the window has the skin's new size, and the native view (`MAME_PLUGIN_NATIVELAYOUT=1`) looks the same at 100 % scale.
