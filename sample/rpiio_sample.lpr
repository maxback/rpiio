program rpiio_sample;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, umail, rpii2cMock, rpii2cAPI
  {$IFDEF UNIX}
  , rpii2c in '../rpii2c.pas'
  {$ENDIF}
  { you can add units after this };

{$R *.res}

{$IFDEF UNIX}
var
  I2cService: trpiI2CDevice;
  {$ENDIF}
begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
{$IFDEF UNIX}
    I2cService := TrpiI2CDevice.Create;
    try
        frmMain.DefineService(I2cService);
        Application.Run;
  finally
    I2cService.Free;
  end;
{$ELSE}
    Application.Run;
{$ENDIF}
end.

