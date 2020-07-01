program rpiio_sample;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, umail, rpii2cMock, rpii2cAPI, rpigpioAPI, rpigpioMock
  {$IFDEF UNIX}
  , rpii2c in '../rpii2c.pas',
  rpigpio  in '../rpigpio.pas'
  {$ENDIF}
  { you can add units after this };

{$R *.res}

{$IFDEF UNIX}
var
  oI2cService: TrpiI2CDevice;
  oGPIOService: TrpiGPIO;
  {$ENDIF}
begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
{$IFDEF UNIX}
    oI2cService := TrpiI2CDevice.Create;
    oGPIOService := TrpiGPIO.Create;
    try
      frmMain.DefineService(oI2cService, oGPIOService);
      Application.Run;
  finally
    oGPIOService.Free;
    oI2cService.Free;
  end;
{$ELSE}
    Application.Run;
{$ENDIF}
end.

