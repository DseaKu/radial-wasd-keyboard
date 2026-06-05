#![no_std]
#![no_main]
#![deny(
    clippy::mem_forget,
    reason = "mem::forget is generally not safe to do with esp_hal types, especially those \
    holding buffers for the duration of a data transfer."
)]
#![deny(clippy::large_stack_frames)]

use esp_hal::clock::CpuClock;
use esp_hal::main;
use esp_hal::time::{Duration, Instant};

use diy_game_pad::hardware::Hardware;

const LOOP_DELAY: u64 = 50;
// This creates a default app-descriptor required by the esp-idf bootloader.
// For more information see: <https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-reference/system/app_image_format.html#application-description>
esp_bootloader_esp_idf::esp_app_desc!();

#[allow(
    clippy::large_stack_frames,
    reason = "it's not unusual to allocate larger buffers etc. in main"
)]
#[main]
fn main() -> ! {
    esp_println::logger::init_logger_from_env();
    esp_println::println!("Init!");

    let config = esp_hal::Config::default().with_cpu_clock(CpuClock::max());
    let peripherals = esp_hal::init(config);

    let mut hw = Hardware::init(peripherals);

    loop {
        // hw.led.toggle();

        let analog_value = nb::block!(hw.adc.read_oneshot(&mut hw.adc_pin)).unwrap();
        esp_println::println!("analog Value: {}", analog_value);

        let delay_start = Instant::now();
        while delay_start.elapsed() < Duration::from_millis(LOOP_DELAY) {}
    }

    // for inspiration have a look at the examples at https://github.com/esp-rs/esp-hal/tree/esp-hal-v1.1.0/examples
}
