# Changelog

All notable changes to Pigeon Crouch are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html):

- **Major** versions can need changes to your configuration or other resources. Read the **Upgrade notes**.
- **Minor** versions add features without breaking existing setups.
- **Patch** versions fix bugs only.

## [Unreleased]

First release.

### Highlights

- Crouch on Left Ctrl, with GTA's own crouched walk and aim
- In place of Ctrl's stealth mode on foot
- No crouch-jumping
- A `crouching` state bag, exports and an event for other resources
- 23 languages

### Added

- Crouching with one key (Left Ctrl by default, which players can change in GTA's key bindings) or `/crouch`, with GTA's crouched walk (`move_ped_crouched`) and aim (`move_ped_crouched_strafing`).
- `Config.ReplaceStealth` to turn off Ctrl's stealth mode on foot, so the key only crouches.
- `Config.BlockJump` to turn off jumping while crouched.
- The crouched walk put back if another resource resets it, and standing up in vehicles, water, falls, climbs, ragdolls and death.
- A replicated `crouching` player state bag, `IsCrouching` and `SetBlocked` client exports, and a local `pigeon-crouch:changed` event.
- Key binding name in 23 languages, following ox_lib's language with `Config.Locale = 'auto'`.
- Update checker from the Pigeon Studios version registry.

[Unreleased]: https://github.com/pigeon-studios-uk/pigeon-crouch/commits/main
