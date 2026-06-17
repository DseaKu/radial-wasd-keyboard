use diy_game_pad::app::App;
use diy_game_pad::bluetooth::BluetoothDevice;
use diy_game_pad::hardware::InputPeripherals;
use esp_idf_hal::peripherals::Peripherals;

fn main() -> anyhow::Result<()> {
    // Necessary for ESP-IDF to link properly
    esp_idf_sys::link_patches();
    // Initialize standard logging
    esp_idf_svc::log::EspLogger::initialize_default();

    // Set a custom panic hook to log errors and prevent immediate reboot
    std::panic::set_hook(Box::new(|info| {
        log::error!("APPLICATION PANIC!");
        log::error!("{}", info);
        loop {
            std::thread::sleep(std::time::Duration::from_secs(10));
        }
    }));

    // Initialize core peripherals and devices
    let peripherals = Peripherals::take().unwrap();
    let input_peripherals = InputPeripherals::new(peripherals)?;
    let bluetooth_device = BluetoothDevice::new()?;

    // Create and run the application
    let mut app = App::new(input_peripherals, bluetooth_device);

    app.run()
}
