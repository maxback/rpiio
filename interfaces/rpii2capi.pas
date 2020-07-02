unit rpii2cAPI;

{$mode objfpc}{$H+}

interface

uses
{$IFDEF UNIX}
  baseunix,
{$ENDIF}
  Classes, SysUtils;

type

{$IFDEF Windows}
 trpiI2CHandle = integer;
 cint = integer;
 {$ELSE}
   trpiI2CHandle = cint;
 {$ENDIF}

  trpiI2CDeviceAbstract = class(TObject)
      procedure closeDevice; virtual; abstract;

      procedure openDevice(address: cint); virtual; abstract;
      procedure setRegister(register: byte; value: byte); virtual; abstract;
      function getRegister(register: byte): byte; virtual; abstract;
      procedure writeByte(value: byte); virtual; abstract;
      procedure writeBytes(bytes: pointer; length: longint); virtual; abstract;
      function readByte: byte; virtual; abstract;
  end;


implementation

end.

