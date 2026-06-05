use crate::hardware::InputPeripherals;
use esp_hal::time::{Duration, Instant};

const SLEEP_TIME: u64 = 20;
const X_THRESHOLD: u16 = 350;
const X: u16 = 2325;

pub struct App {
    ip: InputPeripherals,
}
#[derive(Default)]
pub enum Dir {
    #[default]
    Center,
    Left,
    Right,
}
impl Dir {
    pub fn from_x_axis(x: u16) -> Self {
        if X + X_THRESHOLD < x {
            Self::Right
        } else if X - X_THRESHOLD > x {
            Self::Left
        } else {
            Self::Center
        }
    }

    pub const fn as_str(&self) -> &'static str {
        match self {
            Self::Left => "Left",
            Self::Right => "Right",
            Self::Center => "Center", // Exhaustive match prevents future bugs
        }
    }
}

impl App {
    pub fn new(ip: InputPeripherals) -> Self {
        Self { ip }
    }

    pub fn run(&mut self) -> ! {
        loop {
            let x = self.ip.analog_stick.get_x();
            let y = self.ip.analog_stick.get_y();

            let dir = Dir::from_x_axis(x);
            esp_println::print!(
                "\rx|y {:4} | {:4}   \n\rDir: {:10}   \x1B[1A",
                x,
                y,
                dir.as_str()
            );

            self.sleep(SLEEP_TIME)
        }
    }

    fn sleep(&self, time: u64) {
        let delay_start = Instant::now();
        while delay_start.elapsed() < Duration::from_millis(time) {}
    }
}
