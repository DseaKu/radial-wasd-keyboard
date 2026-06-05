use crate::hardware::Hardware;
use esp_hal::time::{Duration, Instant};

const SLEEP_TIME: u64 = 20;

pub struct App {
    hw: Hardware,
}

impl App {
    pub fn new(hw: Hardware) -> Self {
        Self { hw }
    }

    pub fn run(&mut self) -> ! {
        loop {
            let x = self.hw.get_joy_stick_x();
            let y = self.hw.get_joy_stick_y();

            esp_println::print!("\rx|y {:4} | {:4}", x, y);

            self.sleep(SLEEP_TIME)
        }
    }

    fn sleep(&self, time: u64) {
        let delay_start = Instant::now();
        while delay_start.elapsed() < Duration::from_millis(time) {}
    }
}
