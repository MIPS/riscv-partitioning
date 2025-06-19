# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**_NOTE:_** PROJECTS BUILT USING THE TEMPLATE SHOULD UPDATE THE BELOW SECTIONS AS-NEEDED.

## [0.7.x]
- Rename "WorldGuard" to "RISC-V Worlds" for the system concept and "World-ID" for the ISA
- Rework the proposal into 4 sub-proposals, in a layered manner
- Break the World-ID ISA (and NS-Req ISA) into smaller extensions
- Discuss "RoT-mode"

## [0.6.4] - 2025-04-17
- Reusable build system (used by sPMP too)
- Move chapter 3 (external config) into chapter 2 (arch)
- 16-bit maximum for WIDs
- Add "register visibility"
- Add stub appendices
- Remove MIPS logo and copyright

## [0.6.3] - 2025-04-01
- Fix: mwid is no longer constrained by mwidlist.
- Update optional ePMP tracking of NS-Attr.
- Retouches.

## [0.6.2] - 2025-03-14
- Updated logo and copyright.
- Numerous retouches.

## [0.6.1] - 2025-03-13
- Power-on defaults
- Updated title, trademark notes, etc.
- Remove "WID-sampling" workaround.
- Numerous fixes, retouches, and clarifications

## [0.6.0] - 2025-03-10
- Hypervisor support
- Convert from 32-bit to XLEN-bit
- Clarify TZ/NS-Attr support via PMA and/or ePMP/eIOPMP config
- Change of title

## [0.5.0] - 2025-03-06
- Significant updates based on internal review

## [0.1.0] - 2025-02-25
- Initial conversion to asciidoc
