---
name: Pak Khata Ledger & POS
colors:
  surface: '#effdf3'
  surface-dim: '#cfddd4'
  surface-bright: '#effdf3'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#e9f7ed'
  surface-container: '#e3f1e7'
  surface-container-high: '#ddece2'
  surface-container-highest: '#d8e6dc'
  on-surface: '#121e18'
  on-surface-variant: '#3f4940'
  inverse-surface: '#27332d'
  inverse-on-surface: '#e6f4ea'
  outline: '#6f7a70'
  outline-variant: '#bfc9be'
  surface-tint: '#126c3b'
  primary: '#005129'
  on-primary: '#ffffff'
  primary-container: '#0f6b3a'
  on-primary-container: '#95e9ab'
  inverse-primary: '#85d89c'
  secondary: '#006d39'
  on-secondary: '#ffffff'
  secondary-container: '#8df5ac'
  on-secondary-container: '#00723b'
  tertiary: '#8c110a'
  on-tertiary: '#ffffff'
  tertiary-container: '#ae2c20'
  on-tertiary-container: '#ffcac2'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#a0f5b7'
  primary-fixed-dim: '#85d89c'
  on-primary-fixed: '#00210d'
  on-primary-fixed-variant: '#00522a'
  secondary-fixed: '#90f8ae'
  secondary-fixed-dim: '#74db94'
  on-secondary-fixed: '#00210d'
  on-secondary-fixed-variant: '#005229'
  tertiary-fixed: '#ffdad5'
  tertiary-fixed-dim: '#ffb4a9'
  on-tertiary-fixed: '#410000'
  on-tertiary-fixed-variant: '#8e130c'
  background: '#effdf3'
  on-background: '#121e18'
  surface-variant: '#d8e6dc'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
  currency-display:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  currency-ledger:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '700'
    lineHeight: 22px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-sm: 0.75rem
  margin: 1rem
  margin-tablet: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

The design system establishes a high-trust, dignified, and tactile fintech interface crafted explicitly for Pakistani merchants, traders, and shopkeepers. It balances the cultural familiarity of traditional ledger books (*khata*) with the efficiency of modern point-of-sale systems. 

The aesthetic is grounded, authoritative, and frictionless—rejecting ephemeral tech trends in favor of crystal-clear legibility, immediate numeric comprehension, and ergonomic reliability under challenging field conditions (harsh sunlight, one-handed thumb entry, repetitive daily transactions). Visual rhythm relies on structured warm neutrals, generous touch areas, deliberate typographic hierarchy, and unambiguous monetary semantics that inspire fiscal confidence.

## Colors

The palette is engineered around high functional contrast and deep cultural resonance, leading with national green and strictly segregated credit/debit signifiers.

### Core Swatches
- **Primary Brand:** `#0F6B3A` (Deep Pakistan Green) — anchor for primary actions, top navigation app bars, key active toggles. Hover/Press: `#0B5530`. Tint fill: `#E6F2EB`. Deep dark surface: `#0A4A2A`.
- **Receive / Credit / Jama (Positive):** `#178A4C` over badge/tint `#E8F6EE`. Applied to incoming cash, debts settled by customers, positive cash drawer balances.
- **Pay / Debit / Udhaar / Danger (Negative):** `#C0392B` over badge/tint `#FBEBE9`. Applied to supplier payables, overdue accounts, money owed, loss states.
- **Alert / Due Soon / Low Stock (Warning):** `#D98A00` over badge/tint `#FFF4DB`. Applied to expiring credit terms, restocking alerts, pending verification.
- **System / Analytical (Info):** `#2F5D8C` over badge/tint `#E9F0F8`. Applied to reports, audit trails, device pairing indicators.

### Neutrals
- **Canvas / App Canvas:** `#F6F7F5` (Warm off-white, reduces glare under outdoor sunlight).
- **Surface Elevation 1 (Cards, sheets):** `#FFFFFF`.
- **Surface Elevation 2 (Grouped lists, secondary wells):** `#F0F2EE`.
- **Borders & Dividers:** `#E3E6E1`.
- **Text Primary (Headings, monetary values):** `#14201A`.
- **Text Secondary (Subheads, field labels):** `#5B6760`.
- **Text Tertiary (Timestamps, placeholders):** `#8A948E`.

## Typography

Typography prioritizes rapid numeric parsing and cross-lingual legibility. 

- **Primary Display & Headings:** Plus Jakarta Sans delivers a friendly, contemporary, yet authoritative character for high-level summaries and dashboard metrics.
- **Interface & Transaction Body:** Inter is selected for its neutral precision, high x-height, and robust rendering across low-cost Android displays.
- **Tabular Figures Requirement:** All numerical interfaces, ledger rows, checkout totals, and balance displays must enforce OpenType tabular figures (`font-variant-numeric: tabular-nums; font-feature-settings: "tnum" 1;`). Currency denominations should always consistently align decimals and prefixes (e.g., `Rs. 45,250.00`).

## Layout & Spacing

The layout is built on a responsive 4-column fluid mobile grid upgrading to 8 columns on 7-inch to 10-inch counter tablets. 

- **Canvas Margins:** Mobile phones default to a strict `1rem` (16px) margin, maximizing screen real estate for dense inventory matrices and ledger tables. Tablet counter displays expand to `1.5rem` (24px).
- **Component Ergonomics:** Touch targets across POS and transaction inputs must meet or exceed a strict minimum height and width of `48px` to facilitate high-speed thumb entry.
- **Rhythm:** Spacing follows an 8pt increment model with a 4pt sub-scale (`space-xs: 4px`, `space-sm: 8px`, `space-md: 16px`, `space-lg: 24px`, `space-xl: 32px`). Vertical card stacks utilize `space-md` separation to maintain clear grouping without wasting vertical scroll depth.

## Elevation & Depth

This design system avoids loud skeuomorphism, employing instead a grounded, clean tactile elevation model driven by low-contrast outlines and warm, diffused ambient shadows.

- **Base Layer (Canvas):** Colored with `#F6F7F5`. Flat, recession plane.
- **Level 1 (Cards, Ledger Sheets, Form Panels):** Pure white `#FFFFFF` surface enclosed by a fine 1px border in `#E3E6E1`. Shadow: `0 1px 3px rgba(20, 32, 26, 0.04), 0 4px 12px rgba(20, 32, 26, 0.02)`.
- **Level 2 (Dropdowns, Bottom Sheets, Sticky POS Summaries):** Pure white `#FFFFFF` with border `#E3E6E1`. Shadow: `0 4px 16px rgba(20, 32, 26, 0.08), 0 12px 32px rgba(20, 32, 26, 0.04)`.
- **Level 3 (Modal Dialogs, Transaction Approvals):** Pure white `#FFFFFF` with a darkened ambient backdrop blur (`rgba(10, 74, 42, 0.4)` tint), casting shadow `0 16px 48px rgba(15, 107, 58, 0.12)`.

## Shapes

The shape vocabulary employs deliberate, calibrated corner geometry that reflects tailored fintech refinement:

- **Cards and Modal Containers:** Fixed corner radius of `16px` (`rounded-xl` / `1rem`), providing a soft framing that encloses tabular records cleanly.
- **Primary and Action Buttons:** Fixed corner radius of `14px`, maintaining a modern, ergonomic press state while visibly separating functional actions from rounded content cards.
- **Input Fields & Form Selectors:** Fixed corner radius of `12px`, structured for distinct tactile separation during data entry.
- **Status Pills, Value Badges, and Chips:** Full pill radius (`9999px`) to immediately isolate quantitative state tags from transactional UI blocks.

## Components

### Buttons
- **Primary Action (e.g., "Add Entry", "Complete Sale"):** Solid `#0F6B3A` fill, white text, 14px border radius. Height: 52px (minimum 48px). Active/Pressed state transitions to `#0B5530`.
- **Semantic Action - Got / Cash In (Jama):** Solid `#178A4C` fill with white text, or tint `#E8F6EE` with `#178A4C` text.
- **Semantic Action - Gave / Credit Out (Udhaar):** Solid `#C0392B` fill with white text, or tint `#FBEBE9` with `#C0392B` text.
- **Secondary Action:** Surface-2 `#F0F2EE` fill, border 1px `#E3E6E1`, `#14201A` text.
- **Tertiary / Ghost:** Transparent background, `#0F6B3A` text, 48px minimum touch envelope.

### Cards & Ledger Tiles
- **Customer / Supplier Khata Tile:** 16px radius, white background, 1px `#E3E6E1` border. Houses customer name, last transaction relative date, and a dual-line right-aligned balance. Balances owed to the shopkeeper render in `#178A4C`; balances the shopkeeper owes render in `#C0392B`.
- **Metrics Summary Card:** Features subtle tinted background pills indicating net position (+Rs. 124,500 in green tint; -Rs. 12,000 in red tint) paired with large tabular figures (`currency-display`).

### Input Fields & Keypads
- **Standard Inputs:** Height 52px, 12px border radius, `#FFFFFF` background, 1px `#E3E6E1` border. Focused state: 2px border in `#0F6B3A` with no offset ring.
- **Currency Input Field:** Large dedicated input row with fixed `Rs.` prefix in `#5B6760` and bold oversized tabular digits (`headline-lg`) in `#14201A`.
- **Quick-Amount Chips:** Horizontal scroll collection of pill-shaped buttons (+100, +500, +1,000, +5,000) using `#F0F2EE` background, `#14201A` text, and 40px touch height.

### Chips & Badges
- **Status Pills:** Height 28px, padding `0 10px`, text style `label-sm`.
  - *Settled:* `#E8F6EE` background, `#178A4C` text.
  - *Unpaid / Overdue:* `#FBEBE9` background, `#C0392B` text.
  - *Partial / Due Soon:* `#FFF4DB` background, `#D98A00` text.
  - *Official Receipt / Bank:* `#E9F0F8` background, `#2F5D8C` text.

### Selection Controls
- **Radio & Checkboxes:** 22px × 22px frame, 6px radius for checkboxes, full circle for radios. Unchecked: 1.5px border `#8A948E`. Checked: solid `#0F6B3A` fill with white indicator icon. Guaranteed 48px invisible touch padding target.

### Transaction Row (Ledger Entry)
- Split row format with date stamp and item note on left (`body-md` and `body-sm`). Right column utilizes tabular figures with green text (`+Rs. 1,200`) or red text (`-Rs. 850`) stacked with the running balance in `#5B6760`.