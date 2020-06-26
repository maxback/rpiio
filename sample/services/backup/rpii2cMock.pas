unit rpii2cMock;

interface

uses
  sysutils, classes, rpii2cAPI;

type

  { trpiI2CDevice }

  TrpiI2CDeviceMock = class(trpiI2CDeviceAbstract)
    public

      procedure closeDevice; override;

      procedure openDevice(address: cint); override;
      procedure setRegister(register: byte; value: byte); override;
      function getRegister(register: byte): byte; override;
      procedure writeByte(value: byte); override;
      procedure writeBytes(bytes: pointer; length: longint); override;
      function readByte: byte; override;
  end;

implementation

{ trpiI2CDevice }

procedure TrpiI2CDeviceMock.closeDevice;
begin
  exit;
end;

procedure TrpiI2CDeviceMock.openDevice(address: cint);
begin
  exit;
end;

procedure TrpiI2CDeviceMock.setRegister(register: byte; value: byte);
begin
  exit;
end;

function TrpiI2CDeviceMock.getRegister(register: byte): byte;
begin
  exit(byte);
end;

procedure TrpiI2CDeviceMock.writeByte(value: byte);
begin
 exit;
end;

procedure TrpiI2CDeviceMock.writeBytes(bytes: pointer; length: longint);
begin
  exit;
end;

function TrpiI2CDeviceMock.readByte: byte;
begin
  exit($33);
end;

end.
