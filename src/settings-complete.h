#include "Arduino.h"

//######################### INFOS ####################################
/* This is a config-file for ESPuino complete with port-expander PCA9555.
   PCB: tba
   Infos: tba
   Caveats: None
   Status: Test in progress...
*/

//################## GPIO-configuration ##############################
#ifdef SD_MMC_1BIT_MODE
    // uSD-card-reader (via SD-MMC 1Bit)
    //
    // SD_MMC uses fixed pins
    //  (MOSI)    15  CMD
    //  (SCK)     14  SCK
    //  (MISO)     2  D0
#else
    // SPI-SD IS NOT SUPPORTED BY THIS PCB - DON'T USE INTERNAL SD-READER!
    #define SPISD_CS                    99          // GPIO for chip select (SD)
    #ifndef SINGLE_SPI_ENABLE
        #define SPISD_MOSI              99          // GPIO for master out slave in (SD) => not necessary for single-SPI
        #define SPISD_MISO              99          // GPIO for master in slave ou (SD) => not necessary for single-SPI
        #define SPISD_SCK               99          // GPIO for clock-signal (SD) => not necessary for single-SPI
    #endif
#endif

// RFID (via SPI)
#define RST_PIN                         99          // Not necessary for RC522 but has to be set anyway; so let's use a dummy-number
#define RFID_CS                         21          // GPIO for chip select (RFID)
#define RFID_MOSI                       23          // GPIO for master out slave in (RFID)
#define RFID_MISO                       19          // GPIO for master in slave out (RFID)
#define RFID_SCK                        18          // GPIO for clock-signal (RFID)

#ifdef RFID_READER_TYPE_PN5180
    #define RFID_BUSY                   32          // PN5180 BUSY PIN
    #define RFID_RST                    22          // PN5180 RESET PIN
    #define RFID_IRQ                    99          // PN5180 IRQ PIN (only needed for low power card detection)
#endif
// I2S (DAC)
#define I2S_DOUT                        25          // Digital out (I2S)
#define I2S_BCLK                        27          // BCLK (I2S)
#define I2S_LRC                         26          // LRC (I2S)

// Rotary encoder
#ifdef USEROTARY_ENABLE
    #define ROTARYENCODER_CLK           35          // If you want to reverse encoder's direction, just switch GPIOs of CLK with DT (in software or hardware)
    #define ROTARYENCODER_DT            34
    #define ROTARYENCODER_BUTTON        105
#endif

// Amp enable (optional)
#define GPIO_PA_EN                      112         // To enable amp for loudspeaker (GPIO or port-channel)
#define GPIO_HP_EN                      113         // To enable amp for headphones (GPIO or port-channel)

// Control-buttons (set to 99 to DISABLE; 0->39 for GPIO; 100->115 for port-expander)
#define NEXT_BUTTON                     102         // Button 0: GPIO to detect next
#define PREVIOUS_BUTTON                 103         // Button 1: GPIO to detect previous
#define PAUSEPLAY_BUTTON                100         // Button 2: GPIO to detect pause/play
#define BUTTON_4                        104         // Button 4: unnamed optional button
#define BUTTON_5                        101         // Button 5: unnamed optional button

// Channels of port-expander can be read cyclic or interrupt-driven. It's strongly recommended to use the interrupt-way!
// Infos: https://forum.espuino.de/t/einsatz-des-port-expanders-pca9555/306
#ifdef PORT_EXPANDER_ENABLE
    #define PE_INTERRUPT_PIN              4         // GPIO that is used to receive interrupts from port-expander
#endif

// I2C-configuration (necessary for RC522 [only via i2c - not spi!] or port-expander)
#if defined(RFID_READER_TYPE_MFRC522_I2C) || defined(PORT_EXPANDER_ENABLE)
    #define ext_IIC_CLK                 33           // i2c-SCL (clock)
    #define ext_IIC_DATA                5            // i2c-SDA (data)
#endif

// Wake-up button => this also is the interrupt-pin if port-expander is enabled!
// Please note: only RTC-GPIOs (0, 4, 12, 13, 14, 15, 25, 26, 27, 32, 33, 34, 35, 36, 39, 99) can be used! Set to 99 to DISABLE.
// Please note #2: this button can be used as interrupt-pin for port-expander. If so, all pins connected to port-expander can wake up ESPuino.
#define WAKEUP_BUTTON                   ROTARYENCODER_BUTTON // Defines the button that is used to wake up ESPuino from deepsleep.

// (optional) Power-control
#define POWER                           13          // GPIO used to drive transistor-circuit, that switches off peripheral devices while ESP32-deepsleep

// (optional) Neopixel
#define LED_PIN                         12          // GPIO for Neopixel-signaling

// (optinal) Headphone-detection
#ifdef HEADPHONE_ADJUST_ENABLE
    #define DETECT_HP_ON_HIGH                       // Per default headphones are supposed to be connected if HT_DETECT is LOW. DETECT_HP_ON_HIGH will change this behaviour to HIGH.
    #define HP_DETECT                   107         // GPIO that detects, if there's a plug in the headphone jack or not
#endif

// (optional) Monitoring of battery-voltage via ADC
#ifdef MEASURE_BATTERY_VOLTAGE
    #define VOLTAGE_READ_PIN            39          // GPIO used to monitor battery-voltage.
    constexpr float referenceVoltage = 3.3;         // Reference-voltage
    constexpr float offsetVoltage = 0.55;           // If voltage measured by ESP isn't 100% accurate, you can add a correction-value here
#endif

// (optional) For measuring battery-voltage a voltage-divider is necessary. Their values need to be configured here.
#ifdef MEASURE_BATTERY_VOLTAGE
    constexpr uint16_t rdiv1 = 100;                 // Rdiv1 of voltage-divider (kOhms)
    constexpr uint16_t rdiv2 = 33;                  // Rdiv2 of voltage-divider (kOhms) => used to measure voltage via ADC!
#endif

// (Optional) remote control via infrared
#ifdef IR_CONTROL_ENABLE
    #define IRLED_PIN                   0           // GPIO where IR-receiver is connected (only tested with VS1838B)
    #define IR_DEBOUNCE                 200         // Interval in ms to wait at least for next signal (not used for actions volume up/down)

    // Actions available. Use your own remote control and have a look at the console for "Command=0x??". E.g. "Protocol=NEC Address=0x17F Command=0x68 Repeat gap=39750us"
    // Make sure to define a hex-code not more than once as this will lead to a compile-error
    // https://forum.espuino.de/t/neues-feature-fernsteuerung-per-infrarot-fernbedienung/265
    #define RC_PLAY                     0x68            // command for play
    #define RC_PAUSE                    0x67            // command for pause
    #define RC_NEXT                     0x6b            // command for next track of playlist
    #define RC_PREVIOUS                 0x6a            // command for previous track of playlist
    #define RC_FIRST                    0x6c            // command for first track of playlist
    #define RC_LAST                     0x6d            // command for last track of playlist
    #define RC_VOL_UP                   0x1a            // Command for volume up (one step)
    #define RC_VOL_DOWN                 0x1b            // Command for volume down (one step)
    #define RC_MUTE                     0x1c            // Command to mute ESPuino
    #define RC_SHUTDOWN                 0x2a            // Command for deepsleep
    #define RC_BLUETOOTH                0x72            // Command to enable/disable bluetooth
    #define RC_FTP                      0x65            // Command to enable FTP-server
#endif