use crate::types::{AdcValue, HidCode};

const DEADZONE: AdcValue = AdcValue(1000);
const CENTER: AdcValue = AdcValue((1 << 12) / 2);

#[derive(Default, PartialEq, Copy, Clone)]
enum Direction {
    #[default]
    Center,
    Negative,
    Positive,
}

// enum StickState {
//     hold,
//     pressed,
//     released,
// }
#[derive(Default)]
struct Axis {
    dir: Direction,
    is_holding: bool,
    // state: StickState,
}

impl Axis {
    fn new() -> Self {
        Self {
            dir: Direction::default(),
            is_holding: false,
        }
    }

    fn update(&mut self, val: AdcValue) {
        let mut new_dir = Direction::Center;

        if val < CENTER.saturating_sub(DEADZONE) {
            new_dir = Direction::Negative;
        } else if val > CENTER.saturating_add(DEADZONE) {
            new_dir = Direction::Positive;
        }

        if new_dir == self.dir {
            self.is_holding = true;
        } else {
            self.dir = new_dir;
            self.is_holding = false;
        }
    }

    fn get_hid_code(&mut self, negative: HidCode, positive: HidCode) -> Option<HidCode> {
        if self.is_holding {
            return None;
        }
        match self.dir {
            Direction::Center => None,
            Direction::Negative => Some(negative),
            Direction::Positive => Some(positive),
        }
    }
}

#[derive(Default)]
pub struct AnalogStick {
    axis_x: Axis,
    axis_y: Axis,
}

impl AnalogStick {
    pub fn new() -> Self {
        Self {
            axis_x: Axis::new(),
            axis_y: Axis::new(),
        }
    }
    pub fn update(&mut self, x: AdcValue, y: AdcValue) {
        self.axis_x.update(x);
        self.axis_y.update(y);
    }

    pub fn get_x_hid_code(&mut self) -> Option<HidCode> {
        // Left: 0x50, Right: 0x4F
        self.axis_x.get_hid_code(HidCode(0x50), HidCode(0x4F))
    }

    pub fn get_y_hid_code(&mut self) -> Option<HidCode> {
        // Up: 0x52, Down: 0x51
        self.axis_y.get_hid_code(HidCode(0x51), HidCode(0x52))
    }
}
