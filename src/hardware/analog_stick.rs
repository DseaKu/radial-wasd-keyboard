use crate::types::{AdcValue, HidCode};

// Configuration constants for the analog stick
const DEADZONE: AdcValue = AdcValue(600);
const CENTER: AdcValue = AdcValue(1800);

// HID Key Codes (WASD)
const KEY_W: HidCode = HidCode(0x1A);
const KEY_A: HidCode = HidCode(0x04);
const KEY_S: HidCode = HidCode(0x16);
const KEY_D: HidCode = HidCode(0x07);

const KEY_RELEASE: HidCode = HidCode(0x00);

/// Physical position of an axis relative to its deadzone.
#[derive(Default, PartialEq, Copy, Clone)]
enum Position {
    #[default]
    Center,
    Negative,
    Positive,
}

/// State machine to handle transitions between positions.
#[derive(Default, PartialEq, Copy, Clone)]
enum State {
    #[default]
    Centered,
    JustTilted,
    HoldingTilt,
    JustReleased,
}

#[derive(Default)]
struct Axis {
    position: Position,
    state: State,
}

impl Axis {
    /// Maps the current state to a HID code. Returns None if no action is needed.
    fn to_hid_code(&self, negative: HidCode, positive: HidCode) -> Option<HidCode> {
        // Filter out idle and holding states to avoid report spam
        if self.state == State::Centered || self.state == State::HoldingTilt {
            return None;
        }
        if self.state == State::JustReleased {
            return Some(KEY_RELEASE);
        }
        match self.position {
            Position::Center => None,
            Position::Negative => Some(negative),
            Position::Positive => Some(positive),
        }
    }

    /// Determines the physical position based on raw ADC value.
    fn update_position(&self, val: AdcValue) -> Position {
        if val < CENTER.saturating_sub(DEADZONE) {
            Position::Negative
        } else if val > CENTER.saturating_add(DEADZONE) {
            Position::Positive
        } else {
            Position::Center
        }
    }

    /// Updates the internal state based on the current position.
    fn update_state(&self, new_pos: Position) -> State {
        match (&self.state, new_pos) {
            (State::Centered, Position::Center) => State::Centered,
            (State::Centered, _) => State::JustTilted,

            (State::JustTilted, Position::Center) => State::JustReleased,
            (State::JustTilted, _) => State::HoldingTilt,

            (State::HoldingTilt, Position::Center) => State::JustReleased,
            (State::HoldingTilt, _) => State::HoldingTilt,

            (State::JustReleased, Position::Center) => State::Centered,
            (State::JustReleased, _) => State::JustTilted,
        }
    }

    fn update(&mut self, val: AdcValue) {
        self.position = self.update_position(val);
        self.state = self.update_state(self.position);
    }
}

/// Represetns a 2-axis analog stick.
#[derive(Default)]
pub struct AnalogStick {
    axis_x: Axis,
    axis_y: Axis,
}

impl AnalogStick {
    /// Updates the state of both axes with new ADC values.
    pub fn update(&mut self, x: AdcValue, y: AdcValue) {
        self.axis_x.update(x);
        self.axis_y.update(y);
    }

    pub fn get_x_hid_code(&self) -> Option<HidCode> {
        self.axis_x.to_hid_code(KEY_A, KEY_D)
    }

    pub fn get_y_hid_code(&self) -> Option<HidCode> {
        self.axis_y.to_hid_code(KEY_W, KEY_S)
    }
}
