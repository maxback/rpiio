unit rpigpioMock;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, rpigpioAPI;

type

  { TrpiGPIOMock }

  TrpiGPIOMock = class(TrpiGPIOAbstract)
    public
      function initialise(newPi: boolean): boolean; override;
      procedure shutdown; override;

      procedure setPinMode(pin, mode: byte); override;
      function readPin(pin: byte): boolean; override;
      procedure clearPin(pin: byte); override;
      procedure setPin(pin: byte); override;
      procedure setPullupMode(pin, mode: byte); override;
      procedure PWMWrite(pin: byte; value: longword); override;
  end;



implementation

{ TrpiGPIOMock }

function TrpiGPIOMock.initialise(newPi: boolean): boolean;
begin
  exit(true);
end;

procedure TrpiGPIOMock.shutdown;
begin
  exit;
end;

procedure TrpiGPIOMock.setPinMode(pin, mode: byte);
begin
  exit;
end;

function TrpiGPIOMock.readPin(pin: byte): boolean;
begin
  exit( (pin and $01) = $01);
end;

procedure TrpiGPIOMock.clearPin(pin: byte);
begin
  exit;
end;

procedure TrpiGPIOMock.setPin(pin: byte);
begin
  exit;
end;

procedure TrpiGPIOMock.setPullupMode(pin, mode: byte);
begin
  exit;
end;

procedure TrpiGPIOMock.PWMWrite(pin: byte; value: longword);
begin
  exit;
end;

end.

