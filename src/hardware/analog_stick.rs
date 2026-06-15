const DEADZONE: u16 = 1000;
const CENTER: u16 = (1 << 12) / 2;

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

    fn update(&mut self, analog_value: u16) {
        let mut new_dir = Direction::Center;

        if analog_value < CENTER.saturating_sub(DEADZONE) {
            new_dir = Direction::Negative;
        } else if analog_value > CENTER.saturating_add(DEADZONE) {
            new_dir = Direction::Positive;
        }

        if new_dir == self.dir {
            self.is_holding = true;
        } else {
            self.dir = new_dir;
            self.is_holding = false;
        }
    }

    fn get_hid_code(&mut self, neg_code: u8, pos_code: u8) -> Option<u8> {
        if self.is_holding {
            return None;
        }
        match self.dir {
            Direction::Center => None,
            Direction::Negative => Some(neg_code),
            Direction::Positive => Some(pos_code),
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
    pub fn update(&mut self, raw_x: u16, raw_y: u16) {
        self.axis_x.update(raw_x);
        self.axis_y.update(raw_y);
    }

    pub fn get_x_hid_code(&mut self) -> Option<u8> {
        // Left: 0x50, Right: 0x4F
        self.axis_x.get_hid_code(0x50, 0x4F)
    }

    pub fn get_y_hid_code(&mut self) -> Option<u8> {
        // Up: 0x52, Down: 0x51
        self.axis_y.get_hid_code(0x51, 0x52)
    }
}
