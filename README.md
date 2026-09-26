# World Cup 2026

An arcade, FIFA-style football game that runs entirely in your browser. Pick a national team and play a full match against the CPU, rendered live on `<canvas>` with a TV-style broadcast tele camera.

## Features

- **11v11 matches** against the CPU with kick-offs, throw-ins, corners, goal kicks, offside and full time.
- **All 48 nations** of the 2026 World Cup, each with kits (including away strips) and per-player skill ratings.
- **Broadcast camera**: a pseudo-3D tele cam that follows the ball, with crowd and stadium parallax.
- **Deep controls**: charged shots and passes (hold to power up), through balls, lofted chips, player switching, standing and slide tackles, contain.
- **Practice mode**: a free-form pitch with a lone keeper.
- **Rebindable keys**, saved in `localStorage`.

## Controls

| Action | Key |
| --- | --- |
| Move | Arrow keys |
| Sprint | `E` |
| Shot | `D` |
| Short pass | `S` |
| Long pass | `A` |
| Through pass | `W` |
| Lofted through ball | `Q` + `W` |
| Switch player | `Q` |
| Contain / jockey | `C` |

Shots and passes charge while the key is held and fire on release: hold longer for more power.

## Tech stack

React 19, Vite, Tailwind CSS v4, TypeScript, and an HTML5 Canvas game engine driven by `requestAnimationFrame`.

## Getting started

```bash
npm install
npm run dev        # http://localhost:5173
```
