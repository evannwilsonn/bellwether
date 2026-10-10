---
name: Bellwether
description: U.S. markets and macro read as a seismograph station record.
colors:
  drum-paper: "#f3f4ee"
  drum-face: "#e7ebe2"
  grid-ruling: "rgba(60,86,64,.09)"
  rule-hair: "#cdd4c8"
  rule-firm: "#aeb8a9"
  station-ink: "#1c1b22"
  ink-secondary: "#46454f"
  ink-tertiary: "#65646e"
  recording-pen: "#4a2a96"
  pen-wash: "rgba(74,42,150,.10)"
  regime-band: "rgba(74,42,150,.05)"
  event-pen: "#c3102e"
  event-wash: "rgba(195,16,46,.13)"
  smoked-paper: "#141318"
  smoked-drum: "#1b1a20"
  smoked-grid: "rgba(185,162,255,.06)"
  smoked-rule-hair: "#2e2d35"
  smoked-rule-firm: "#45434e"
  smoked-ink: "#ebe9f1"
  smoked-ink-secondary: "#bdbbc8"
  smoked-ink-tertiary: "#93919f"
  smoked-pen: "#b9a2ff"
  smoked-pen-wash: "rgba(185,162,255,.12)"
  smoked-event-pen: "#ff6474"
  smoked-event-wash: "rgba(255,100,116,.16)"
typography:
  display:
    fontFamily: "Anybody, Red Hat Text, system-ui, sans-serif"
    fontSize: "clamp(38px, 6.4vw, 68px)"
    fontWeight: 900
    lineHeight: 0.9
    letterSpacing: "-0.01em"
    fontVariation: "'wdth' 150"
  headline:
    fontFamily: "Anybody, Red Hat Text, system-ui, sans-serif"
    fontSize: "26px"
    fontWeight: 800
    lineHeight: 1.1
    letterSpacing: "0.01em"
    fontVariation: "'wdth' 125"
  bulletin:
    fontFamily: "Red Hat Text, system-ui, sans-serif"
    fontSize: "clamp(19px, 2vw, 23px)"
    fontWeight: 500
    lineHeight: 1.42
  body:
    fontFamily: "Red Hat Text, system-ui, sans-serif"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.55
  reading:
    fontFamily: "Red Hat Mono, ui-monospace, Menlo, monospace"
    fontSize: "22px"
    fontWeight: 600
    lineHeight: 1.2
    fontFeature: "tnum"
  channel-code:
    fontFamily: "Red Hat Mono, ui-monospace, Menlo, monospace"
    fontSize: "15px"
    fontWeight: 700
    letterSpacing: "0.04em"
  label:
    fontFamily: "Red Hat Mono, ui-monospace, Menlo, monospace"
    fontSize: "12px"
    fontWeight: 500
    letterSpacing: "0.06em"
  axis:
    fontFamily: "Red Hat Mono, ui-monospace, Menlo, monospace"
    fontSize: "10.5px"
    fontWeight: 500
rounded:
  none: "0px"
spacing:
  xs: "6px"
  sm: "10px"
  md: "14px"
  lg: "24px"
  xl: "34px"
components:
  span-button:
    backgroundColor: "transparent"
    textColor: "{colors.station-ink}"
    typography: "{typography.label}"
    rounded: "{rounded.none}"
    padding: "8px 13px"
    height: "40px"
  span-button-active:
    backgroundColor: "{colors.station-ink}"
    textColor: "{colors.drum-paper}"
  cursor-bar:
    backgroundColor: "{colors.drum-paper}"
    textColor: "{colors.station-ink}"
    padding: "9px 14px"
  channel-label:
    backgroundColor: "{colors.drum-paper}"
    textColor: "{colors.station-ink}"
    typography: "{typography.channel-code}"
    padding: "10px 12px"
    width: "172px"
  channel-trace:
    backgroundColor: "{colors.drum-face}"
  catalogue-row-active:
    backgroundColor: "{colors.event-wash}"
    textColor: "{colors.event-pen}"
---

# Design System: Bellwether

## Overview

**Creative North Star: "The Station Record"**

Bellwether is a seismic station's drum record and event bulletin, not a fintech terminal and not a broadsheet. Pale ruled drum paper (smoked charcoal in dark) carries one violet recording pen for every trace; a red event pen marks drawdown events and nothing else. A heavy station plate opens the page, a data-written bulletin sentence states where the market stands, and a seven-channel helicorder (SPX, DD, VIX, 10Y, WTI, AU, CAPE) runs on one shared time axis under one cursor.

The density is instrument-grade: hairline rules divide everything, no cards, no shadows, no rounding. Every reading is set in mono with tabular figures; prose is reserved for the bulletin, channel names and notes. Missing data is drawn as a gap and labelled "no reading", never interpolated.

**Key Characteristics:**
- One violet pen for all traces; red only for drawdown events.
- Line style, not colour, carries meaning: solid recorded, dashed inflation-adjusted, dotted CPI.
- Square corners, 1-2px ink rules, flat paper.
- Wide Anybody for the plate and section heads; Red Hat Mono for every number.
- Light and dark are equal citizens, both AA.

## Colors

A two-pen palette on drum paper: near-neutral greenish paper, violet-black ink, one violet pen and one red event pen. Dark mode swaps to the `smoked-*` tokens, applied via `prefers-color-scheme` or `data-theme`.

### Primary
- **Recording Pen Violet** (recording-pen; smoked-pen in dark): every plotted trace, cursor dots, sector share bars, focus outline, key swatches. Traces at 1.6px solid, real series at 1.5px dashed `5 3`.

### Secondary
- **Event Pen Red** (event-pen; smoked-event-pen): drawdown event numbers (E1...), trough dots, catalogue numbers, depth figures and depth bars, the event line in the cursor bar. The **event wash** fills each event span through every channel (full strength on DD, 45% opacity elsewhere) and highlights the active catalogue row.

### Neutral
- **Drum Paper** (drum-paper / smoked-paper): page, cursor bar, channel label column.
- **Drum Face** (drum-face / smoked-drum): the helicorder trace area, under an 18px grid ruling (grid-ruling).
- **Station Ink** (station-ink / smoked-ink): text, plate rule, record frame, cursor line, active span button fill.
- **Secondary and Tertiary Ink**: names, notes, labels, axis text, CPI dotted trace.
- **Hairline and Firm Rules** (rule-hair, rule-firm): row dividers and channel dividers, VIX regime thresholds (dashed `2 3`), zero lines.
- **Pen Wash and Regime Band**: the area under the DD trace, and alternating faint VIX regime zones.

### Named Rules
**The Two Pens Rule.** Violet records, red marks events. Red never decorates, never signals "down" on a generic number, and never appears outside drawdown events and their catalogue.

**The Dash Not Colour Rule.** Real versus nominal and CPI versus yield are told apart by dash pattern on the same pen, so meaning survives without colour.

## Typography

**Display Font:** Anybody (variable width), falling back to Red Hat Text
**Body Font:** Red Hat Text (with system-ui)
**Label/Mono Font:** Red Hat Mono (with ui-monospace, Menlo)

**Character:** A stamped, extra-wide station plate over a plain technical text face and a mono that reads like an instrument printout.

### Hierarchy
- **Display** (900, clamp 38-68px, 0.9, width 150%, uppercase): the BELLWETHER station plate only. Phone: 40px at width 118%.
- **Headline** (800, 26px, 1.1, width 125%, uppercase): section heads (The record, Event catalogue, Index composition, Station log, Calibration).
- **Bulletin** (Red Hat Text 500, clamp 19-23px, 1.42, max 46ch, key figures in 600): the data-written lead sentence.
- **Body** (400, 16px, 1.55; notes 13.5-14px in secondary ink, max 62-80ch).
- **Reading** (Mono 600, 22px bulletin / 17px channel / 15px cursor bar date at 700, tabular): live values.
- **Channel code** (Mono 700, 15px, 0.04em): SPX, DD, VIX...
- **Label** (Mono 500, 12px, 0.06-0.08em, uppercase, tertiary ink): reading names, table headers, control caption.
- **Axis** (Mono 500, 10.5px): tick labels; in-trace notes add a drum-coloured 3px halo stroke.

### Named Rules
**The Printout Rule.** Every number is Red Hat Mono with tabular figures, and uses a true minus (−).

## Layout

Single column, max 1280px, 24px side padding (16px on phone), sections separated by 34px heads and hairline rules like a printed record. The plate sits on a 2px ink rule; the bulletin pairs the lead sentence with a two-column readings grid (stacks under 980px). The helicorder is a 1.5px ink frame: a sticky cursor bar on top, a year ruler, then channels as full-width strips in a 172px label column plus a trace column sharing one x axis (6px left, 46px right gutter for ticks). Channel heights 100-150px, scaled to 72% on phone. Station log and calibration sit side by side (36px gap), stacking under 980px.

Under 700px the channel label becomes a row above its trace (code, name, reading right-aligned), the ruler label cell drops, and the bulletin readings move below the record so SPX and DD land in the first screen. Secondary table columns hide; inline bars drop.

## Elevation & Depth

Flat. No shadows anywhere; depth is the drum face sitting one tone off the paper inside an ink frame, and the sticky cursor bar separates by its paper fill and 1.5px ink rule.

### Named Rules
**The Flat Paper Rule.** Nothing lifts. Separation is a rule line or a tone step, never a shadow or a card.

## Shapes

Square corners throughout (0px). Rules come in three weights: 1px hairline (rows, channel dividers), 1.5px ink (record frame, control border, table head rule), 2px ink (plate and footer rules). Tags in the cursor bar are 1px currentColor boxes. Data marks: 3px event dots, 3.5px hollow cursor dots with a 2px pen stroke, 8px-tall inline bars.

## Components

### Drum Span Control
A segmented, square-cornered group in a 1.5px ink border, mono 600 13px, min 40px tall, captioned by an uppercase mono label. The pressed segment inverts to ink fill on paper text (`aria-pressed`).

### Helicorder
- **Cursor bar:** sticky, live-polite; date in mono 700, phase and VIX regime as outlined tags, active event line in event red, a keyboard hint (desktop only).
- **Channel:** label cell (code, name, band key, live reading) on paper; trace cell on drum face with grid ruling and crosshair cursor. One ink cursor line through all channels; pointer hover/tap or arrow keys (Page, Home, End) step it.
- **Gaps:** null months break the path; a dashed tertiary rule and "no reading after ..." note mark where a series stops, and readings say "no reading".
- **Key:** below the frame, mono swatches for recorded, inflation-adjusted, CPI and drawdown event.

### Tables (Event catalogue, Index composition, Calibration)
Mono, right-aligned, tabular; uppercase label headers over a 1.5px ink rule, 1px hairline rows, 10px 8px cells. Catalogue rows are focusable; hover or the cursor's current event fills the row with event wash, and selecting one moves the cursor to its trough. Composition bars use the pen; depth bars use the event pen.

### Station Log
Ruled list: mono `LOG 01` index, a bold 17px mono count, a secondary-ink sentence. A `WARN` row closes it.

## Do's and Don'ts

### Do:
- **Do** plot every series in recording-pen violet and distinguish series by dash (`5 3` real, `1 3` round CPI).
- **Do** run the event wash through every channel so one drawdown reads across all instruments.
- **Do** draw missing data as a gap with a "no reading" note.
- **Do** keep numbers in Red Hat Mono with tabular figures and true minus signs.
- **Do** tune light and dark together and keep both at AA.

### Don't:
- **Don't** use event red for anything but drawdown events and their catalogue.
- **Don't** add shadows, cards or rounded corners.
- **Don't** interpolate or zero-fill a missing month.
- **Don't** let colour alone carry a regime, phase or series; pair it with a label, tag or dash.
- **Don't** drift toward a fintech terminal or a newsprint broadsheet.
