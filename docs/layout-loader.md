# Native MAME layouts in the gearmulator UI

Plan for showing a machine's MAME layout with the gearmulator UI (RmlUi) instead of a bitmap that MAME draws in software.

## Where we are

- MAME resolves the machine's layout, builds a primitive list for the panel's size, and the library draws it in software into an RGBA buffer (`mp_panel_frame`). `PanelView` (`mameJucePlugin/mamePanel.cpp`) shows that buffer in a canvas of the skin and passes mouse events back as pointer input (`mp_panel_pointer`). MAME does the hit testing.
- Frames are only drawn when the panel changes, so an idle panel costs nothing. Each change redraws the whole panel at its full window size, though, and the software renderer was a third of the TX81Z Standalone's CPU time before the change detection went in.
- Layouts that leave knobs and sliders to a Lua script get them from `plugin_layout_controls` (`src/osd/plugin/pluginlayout.cpp`): knobs are dragged vertically, sliders along their travel, and the script's warning is hidden. Their values live in MAME's `cfg/` files, not in the plugin state.
- The look is MAME's: blurry or blocky when scaled, and the controls are pointer events, not gearmulator controls (no automation, no MIDI learn, no skin styling).

## What layouts need

Survey of `src/mame/layout` (2044 layouts):

- Our three machines use only basic layout features. TX81Z: 96 elements, text, rects, disks, one image, one screen (the LCD), two views, `add` and `multiply` blending. EX-20: 255 elements of text and rects, one view. LinnDrum: 315 elements, `repeat` and `param` (46), `animate` (sliders), a `simplecounter` (knob values), a `led7seg`, a collection, and a script.
- 52 layouts have a script. 31 of them are the shared "slider and knob library" (LinnDrum, DMX, TR-707, Prophet-5, Matrix-12, Xpander, Six-Trak, Source, MPC60/2000XL/3000, Akai S2000/S3000, Virus A/B/C/Rack, D-70, PG-1000, KN5000/7000, …). Four are the Ensoniq "keys and sliders" library (VFX, VFX-SD, SD-1, SD-1 32). The other 17 belong to non-music machines (touch screens, pinball displays, custom draw callbacks) and are out of scope.
- Blending: 338 layouts use `blend`, mostly `add` (1720 times) and `multiply` (929).

So a loader that covers the standard components, states, animation, blending and the two script libraries covers every music layout in MAME.

## Approach

Three ways to get there:

1. **Reimplement layouts in the GUI.** Parse the `.lay` XML in gearmulator and draw every component (rect, disk, text, image, LED segments, dot matrices, counters, reels) with RmlUi. Most flexible, but it duplicates `rendlay.cpp`: groups, repeats, parameters, views and component drawing. The look would differ from MAME's, especially text and LED segments.
2. **MAME describes, the GUI composes (proposed).** MAME keeps loading and resolving the layout: groups, repeats, parameters and views are already expanded once the machine runs. The library exports the resolved view as a list of items, and draws each element's look per state into an image, at the size the GUI asks for, with MAME's own component code. The GUI builds one RmlUi element per item, shows the image for the item's current state, and moves animated items. Screens stay live textures. Clicks and drags become direct input writes. The GUI never parses XML and the look stays MAME's, but sharp at any size, and composing on the GPU costs almost nothing.
3. **Keep the bitmap.** That's what we have. It works, but leaves the scaling, control and integration issues.

The rest of this plan is option 2.

## Design

### Library C API (mame_plugin.h, API 7)

All calls work on the current view and are made from the GUI thread, like the panel calls.

- `mp_layout_describe(instance, buffer, size)`: the resolved view as one blob (JSON, or a flat binary record list). Rebuilt when the view or its visibility changes (`mp_layout_serial`). It holds:
  - the view's bounds and aspect;
  - its elements: id, name, number of states, default state;
  - its items in drawing order: element id, bounds (or the bounds per state for animated items), colour, blend mode, the state source (an output name, an input port and mask, or fixed), the animation source, the clickable input (port, mask), and its collection;
  - the screens: index, bounds, native size;
  - the collections and visibility toggles, and the views to choose from.
- `mp_layout_element_image(instance, element, state, width, height, rgba)`: one element in one state, drawn by MAME's components into an RGBA buffer. This needs a small public helper on `layout_element` in `rendlay.h`, next to the getters added for the knobs.
- `mp_layout_states(instance, serial, states, count)`: the current element state and animation state of every item. A list of small integers is cheap to poll every frame; the serial tells whether anything changed.
- `mp_layout_screen(instance, index, rgba, serial)`: a screen's current bitmap at its native size, when it changed. The GUI scales it.
- `mp_layout_input(instance, item, pressed)` presses an item's clickable input. `mp_layout_field(instance, port, mask, value)` sets an adjuster or analog field, for knobs and sliders. It's the same mechanism the note map uses for the LinnDrum pads today.

The existing `mp_panel_*` calls stay as a fallback, for layouts the loader can't show yet.

### gearmulator side

- A `LayoutView` replaces `PanelView` when the layout is supported. It builds a container element sized to the view's aspect, with one absolutely positioned child per item. Positions are in layout units, scaled with the container.
- **Images:** one texture per element, state and pixel size, requested from the library and cached. On a scale change, the visible ones are drawn again at the new size. `GenerateTexture` in juceRmlUi's renderer takes the RGBA data. The juceRmlUi canvas element already does the same for one texture.
- **States:** each frame, `mp_layout_states` is polled, and changed items switch their texture or bounds.
- **Blending:** `add` and `multiply` need blend modes in juceRmlUi's renderers (JUCE/OpenGL and Metal). If that turns out to be costly, the library can bake an item's blended look into its image, for the common case of a static background.
- **Screens:** one canvas per screen, updated from `mp_layout_screen`.
- **Input:** buttons send `mp_layout_input` on press and release. Knobs and sliders behave like those of `plugin_layout_controls`, moved to the GUI: a vertical drag for knobs, along the travel for sliders, writing with `mp_layout_field`.
- **Collections and views:** entries in the plugin menu, replacing what MAME's UI offers.

### Scripts

- **Slider and knob library (31 layouts):** the controls it adds are recognised by the same rules `plugin_layout_controls` uses: an item animated by an adjuster or analog field is a slider, an item with such an input is a knob. Knob dots rotate with the value, as the library does with `KNOB_DOT_ANGLE_SPAN`. The script's "warning" collection is hidden.
- **Keys and sliders library (4 Ensoniq layouts):** piano keys and sliders that only write to their ports. A later milestone.
- **Other scripts:** not supported. Those layouts stay on the bitmap fallback.

### Parameters

In a later step, knobs and sliders become gearmulator parameters, generated from the layout's adjuster and analog fields. That brings automation, MIDI learn and the shared knob styling. Their values are then saved with the plugin state, which fixes the TODO item about LinnDrum settings in `cfg/`.

## Status

Milestone 1 is done (MAME API 8): `mp_layout_describe`, `mp_layout_states`, `mp_layout_element_image` and `mp_layout_screen`, with `layout_element::draw_state()` added to `rendlay`. `MPCTEST_LAYOUT=1` composes frames from them in plain C next to MAME's own:

| Machine | Panel | Pixels that differ |
|---|---|---|
| LinnDrum (with a slider dragged) | 912 x 480 | 0 |
| EX-20 | 1301 x 480 | 0 |
| TX81Z | 735 x 68 | about 100, all in the LCD |

Things learned on the way, which the GUI side has to follow:

- The panel target stretches the view to the size it's given. A GUI should size its canvas from the view's aspect (`mp_layout_info::aspect`).
- Element items are drawn at their bounds rounded to whole pixels, and their images at exactly that size, so they need no scaling.
- Screens have no blend mode of their own in a layout (MAME's -1); their quads replace what's below, so the library reports `MP_LAYOUT_BLEND_NONE`. Their image is the last completed frame (`screen_device::curbitmap()`), not the bitmap being drawn.
- MAME's software renderer doesn't filter screens, and ignores an image's alpha for `none` and `multiply`. The remaining TX81Z difference is where MAME's fixed-point stepping repeats a different LCD row when scaling 21 rows to 24.4 pixels. The GUI scales screens on the GPU anyway.
- Item states are captured on the emulation thread (the items' bindings read outputs and inputs), element images are drawn on the GUI thread under the panel's drawing lock, so the emulation never builds a frame meanwhile.

Not in milestone 1 yet: input (`mp_layout_input`, `mp_layout_field`), the views and collections to choose from, and scrolled items (flagged `MP_LAYOUT_SCROLLED`, none in our machines).

Milestone 2 is done: `nativelayout = 1` in `mame-plugin.ini` (or `MAME_PLUGIN_NATIVELAYOUT=1`) has the editor draw the panel itself (`mameJucePlugin/mameLayout.cpp`).

- `ElemLayout`, an RmlUi element over the skin's panel canvas, draws one textured quad per item. Element images are drawn by MAME at the item's size in pixels and cached per element, state, orientation and size; screens are textures of their own size, scaled by the GPU.
- Blending: RmlUi's renderers (OpenGL 3 and 2, Metal, software) only blend with alpha. Where items add or multiply, the region is composited on the CPU exactly as MAME does, up to its last such item, and drawn as one texture in that place. On the TX81Z that's the LCD, composited again when its screen changes. Blend modes in the renderers can replace this later.
- The mouse goes to MAME in view coordinates (`mp_layout_pointer`, API 8), handled like the bitmap panel's clicks: MAME presses the clickable items (with `clickthrough`), and the knobs and sliders of `plugin_layout_controls` follow drags. `mp_layout_input` presses an item's input directly, for hosts that do their own hit testing.
- TX81Z, EX-20 and LinnDrum look the same as with MAME's rendering. The EX-20, whose display changes all the time, costs 4.8% of a core for the GUI instead of 6.3%.

Milestone 3 is done: the EX-20's and LinnDrum's panels work natively, with the LinnDrum's knobs and sliders dragged as on the bitmap panel; its counters and LED digits are elements MAME draws. Two things found on the way:

- Without a bitmap panel the render target keeps the layout's natural size, and view coordinates are mapped through the target's visible area, as MAME maps its pixels back. That area can be a little smaller than the target; mapping across the whole target put clicks about 1% off, enough to miss a knob.
- The library merged a queued pointer event with the next one when the buttons were the same, so a press followed by a move became a press at the end of the drag: a knob, which measures from where the drag began, didn't move. Only moves are merged now, which fixes quick drags on the bitmap panel too.

Not yet: the views and collections to choose from, and scrolled items.

## Milestones

1. **API and check tool.** `mp_layout_describe`, `mp_layout_element_image`, `mp_layout_states` and `mp_layout_screen` in the library. mpctest composes a frame from them in plain C and compares it with MAME's own rendering. The difference should be small, which validates the description before any GUI work.
2. **TX81Z in the GUI.** `LayoutView` with images, states, the LCD screen and buttons, behind a switch with `PanelView` as the fallback. Blend modes in juceRmlUi.
3. **EX-20 and LinnDrum.** Many lamps and buttons; animation, knobs and sliders, `simplecounter`, `led7seg` and collections. The LinnDrum's knob dots replace the counters, as its script does.
4. **Parameters.** Knobs and sliders as gearmulator parameters, saved with the state.
5. **More layouts.** The Ensoniq keys and sliders, skins that add gearmulator widgets around or over a layout, and a check over the music layouts in MAME for anything still missing.

## Open questions

- Blend modes in juceRmlUi: are they available in both renderers, or do they have to be added?
- Item count: the LinnDrum has a few hundred items. RmlUi should handle that, but it needs checking at the largest layouts (Virus, MPC).
- Text sizes: elements are drawn per pixel size, so text stays sharp. Fine scale changes, like dragging the window, may need a lower-resolution image in the meantime, redrawn when the scaling stops.
- Hit testing of overlapping items: the item list is in drawing order, so the topmost clickable item wins, as in MAME. Items marked `clickthrough` need the same handling.

## Not covered

The LinnDrum's CPU load (about 40 % of a core) comes from its analog audio emulation, not from the panel, and this plan doesn't change it.
