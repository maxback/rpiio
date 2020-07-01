unit rpigpioAPI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  RPIGPIO_INPUT                 = 0;
  RPIGPIO_OUTPUT                = 1;
  RPIGPIO_PWM_OUTPUT            = 2;
  RPIGPIO_LOW                   = false;
  RPIGPIO_HIGH                  = true;
  RPIGPIO_PUD_OFF               = 0;
  RPIGPIO_PUD_DOWN              = 1;
  RPIGPIO_PUD_UP                = 2;

  // PWM

  RPIGPIO_PWM_CONTROL           = 0;
  RPIGPIO_PWM_STATUS            = 4;
  RPIGPIO_PWM0_RANGE            = 16;
  RPIGPIO_PWM0_DATA             = 20;
  RPIGPIO_PWM1_RANGE            = 32;
  RPIGPIO_PWM1_DATA             = 36;

  RPIGPIO_PWMCLK_CNTL           = 160;
  RPIGPIO_PWMCLK_DIV            = 164;

  RPIGPIO_PWM1_MS_MODE          = $8000;  // Run in MS mode
  RPIGPIO_PWM1_USEFIFO          = $2000;  // Data from FIFO
  RPIGPIO_PWM1_REVPOLAR         = $1000;  // Reverse polarity
  RPIGPIO_PWM1_OFFSTATE         = $0800;  // Ouput Off state
  RPIGPIO_PWM1_REPEATFF         = $0400;  // Repeat last value if FIFO empty
  RPIGPIO_PWM1_SERIAL           = $0200;  // Run in serial mode
  RPIGPIO_PWM1_ENABLE           = $0100;  // Channel Enable

  RPIGPIO_PWM0_MS_MODE          = $0080;  // Run in MS mode
  RPIGPIO_PWM0_USEFIFO          = $0020;  // Data from FIFO
  RPIGPIO_PWM0_REVPOLAR         = $0010;  // Reverse polarity
  RPIGPIO_PWM0_OFFSTATE         = $0008;  // Ouput Off state
  RPIGPIO_PWM0_REPEATFF         = $0004;  // Repeat last value if FIFO empty
  RPIGPIO_PWM0_SERIAL           = $0002;  // Run in serial mode
  RPIGPIO_PWM0_ENABLE           = $0001;  // Channel Enable


type
  TrpiGPIOAbstract = class(TObject)
      function initialise(newPi: boolean): boolean; virtual; abstract;
      procedure shutdown; virtual; abstract;

      procedure setPinMode(pin, mode: byte); virtual; abstract;
      function readPin(pin: byte): boolean; inline; virtual; abstract;
      procedure clearPin(pin: byte); inline; virtual; abstract;
      procedure setPin(pin: byte); inline; virtual; abstract;
      procedure setPullupMode(pin, mode: byte); virtual; abstract;
      procedure PWMWrite(pin: byte; value: longword); inline; virtual; abstract;
  end;


implementation

end.

