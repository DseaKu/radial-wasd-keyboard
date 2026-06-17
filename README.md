# DIY Analog-WASD Keyboard

> [!CAUTION] **Status: Under Development**  
> This project is currently in early development. Features and APIs are subject
> to change. See the [Future Roadmap](#future-roadmap) for planned improvements.

## Overview

This is a keyboard replacement for the left hand, designed to solve "movement
finger conflict." Instead of using three fingers for WASD movement, this device
uses an **analog stick** for movement, freeing your fingers to stay positioned
over action keys (like E, R, F, Shift, Ctrl) without interrupting your movement.

> [!NOTE] **Development Hardware**: This project is currently developed and
> tested on an **ESP32-C3**.

It uses an ESP32 to act as a Bluetooth Low Energy (BLE) Human Interface Device
(HID), mapping analog stick input to standard keyboard signals.

- **BLE HID Support**: Appears as a standard Bluetooth Keyboard to your device.
- **Analog Stick to Keyboard Mapping**: Uses a state machine to convert analog
  input into discrete key presses with deadzone support.
- **Modular Architecture**: Decoupled Bluetooth, hardware abstraction, and
  application logic.
- **Embedded Rust**: Built using `esp-idf-hal` and `esp32-nimble`.

## Software Prerequisites

1. **Rust Toolchain**: Install via [rustup](https://rustup.rs/).
2. **ESP-IDF Prerequisites**: Follow the
   [esp-idf-template](https://github.com/esp-rs/esp-idf-template) guide for
   setting up your environment (LLVM, etc.).
3. **Cargo ESPFLASH**: Install using `cargo install cargo-espflash`.

## Building and Flashing

### 1. Build the project

```bash
cargo build
```

### 2. Flash to ESP32

Ensure your ESP32 is connected via USB.

```bash
cargo espflash flash --release --monitor
```

## Project Structure

- `src/bin/main.rs`: Entry point, system initialization, and wiring.
- `src/app.rs`: Main application loop and HID report coordination.
- `src/bluetooth.rs`: BLE stack management and HID service configuration.
- `src/hardware/`:
  - `mod.rs`: Peripheral management layer.
  - `analog_stick.rs`: State machine for joystick-to-key mapping.
  - `hardware_bridge_esp32.rs`: ESP32-specific ADC implementation.
- `src/types.rs`: Shared value types (AdcValue, HidCode).

## Configuration

The analog stick deadzone and key mappings can be adjusted in
`src/hardware/analog_stick.rs`, this will change See the
[Future Roadmap](#future-roadmap).

```rust
const DEADZONE: AdcValue = AdcValue(600);
const CENTER: AdcValue = AdcValue(1800);

// Default WASD mapping
const KEY_W: HidCode = HidCode(0x1A);
const KEY_A: HidCode = HidCode(0x04);
const KEY_S: HidCode = HidCode(0x16);
const KEY_D: HidCode = HidCode(0x07);
```

## Future Roadmap

- [ ] **Standard Key Support**: Add support for buttons.
- [ ] **Custom Key Mapping**: Implement a way to remap keys.
- [ ] **Platform Portability**: Support for other microcontrollers, if
      requested, but I can't promise to implement them ;-)
