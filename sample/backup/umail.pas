unit umail;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Math, rpii2cAPI, rpii2cMock;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnCloseI2c: TButton;
    btnGetRegisterI2c: TButton;
    btnOpenI2c: TButton;
    btnReadByteI2c: TButton;
    btnSetRegisterI2c: TButton;
    btnWriteBytesI2c: TButton;
    edtAddress: TEdit;
    edtBytes: TEdit;
    edtRegister: TEdit;
    edtValueRegister: TEdit;
    gbAbout: TGroupBox;
    gbOpenCloseI2c: TGroupBox;
    gbSetGetRegisterI2c: TGroupBox;
    gbWriteReadBytesI2c: TGroupBox;
    lbAbout: TLabel;
    lbTryConfigI2c: TLabel;
    mmLog: TMemo;
    PageControl: TPageControl;
    ScrollBoxMain: TScrollBox;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StatusBar: TStatusBar;
    tsRpii2c: TTabSheet;
    tsRpiio: TTabSheet;
    procedure btnCloseI2cClick(Sender: TObject);
    procedure btnGetRegisterI2cClick(Sender: TObject);
    procedure btnOpenI2cClick(Sender: TObject);
    procedure btnReadByteI2cClick(Sender: TObject);
    procedure btnSetRegisterI2cClick(Sender: TObject);
    procedure btnWriteBytesI2cClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FoI2cServiceMock: TrpiI2CDeviceMock;
    FoI2cService: trpiI2CDeviceAbstract;
    procedure log(const method, parameters, returned: string; const comment: string = '');
  public
    procedure DefineService(const I2cService: trpiI2CDeviceAbstract);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.btnOpenI2cClick(Sender: TObject);
const
  m = 'openDevice';
begin
  try
    lbTryConfigI2c.Visible := false;
     FoI2cService.openDevice(StrToInt(edtAddress.Text));
     log(m, edtAddress.Text, 'void');
  except
    on E:Exception do
    begin
      lbTryConfigI2c.Visible := true;
       log(m, edtAddress.Text, e.ClassName + ': ' + e.ToString,
         'Refer to https://www.raspberrypi-spy.co.uk/2014/11/' +
         'enabling-the-i2c-interface-on-the-raspberry-pi/ or another refs ' +
         'to enable I2C');
    end;
  end;
end;

procedure TfrmMain.btnReadByteI2cClick(Sender: TObject);
const
  m = 'readByte';
begin
  try
     edtBytes.Text := FoI2cService.readByte.ToString;
     log(m, 'void', edtBytes.Text);
  except
    on E:Exception do
      log(m, '', e.ClassName + ': ' + e.ToString);
  end;
end;

procedure TfrmMain.btnSetRegisterI2cClick(Sender: TObject);
const
  m = 'setRegister';
begin
  try
     FoI2cService.setRegister(Byte(StrToInt(edtRegister.Text)),
       Byte(StrToInt(edtValueRegister.Text)));
     log(m, edtRegister.Text + ', ' + edtValueRegister.Text, 'void');
  except
    on E:Exception do
       log(m, edtRegister.Text + ', ' + edtValueRegister.Text,
         e.ClassName + ': ' + e.ToString);
  end;
end;

procedure TfrmMain.btnWriteBytesI2cClick(Sender: TObject);
var
  sl: TStringList;
  bytes: array[0..255] of Byte;
  i: integer;
  len: longint;
  m: string;
begin
  s := StringReplace(edtBytes.Text, ' ', ',', [Rfreplaceall]);
  sl := TStringList.Create;
  try
     m := 'writeByte';
     try
       sl.CommaText := s;
       if sl.Count = 1 then
         FoI2cService.writeByte(Byte(sl[0].ToInteger))
       else
       begin
         m := 'writeBytes';
         len := Math.min(sl.Count, Length(bytes));
         for i := 0 to len-1 do
           bytes[i] := Byte(sl[i].ToInteger);

         FoI2cService.writeBytes(@bytes, len);
       end;
       log(m, edtBytes.Text, 'void');
    except
      on E:Exception do
         log(m, edtBytes.Text, e.ClassName + ': ' + e.ToString);
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FoI2cServiceMock := TrpiI2CDeviceMock.Create;
  //default
  DefineService(FoI2cServiceMock);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FoI2cServiceMock.Free;
end;

procedure TfrmMain.log(const method, parameters, returned: string; const comment: string);
var
  line: string;
begin
  line := Format('[%s - %s] Parameters: [%s], returned: [%s]',
    [DateTimeToStr(Now), method, parameters, returned]);
  StatusBar.Panels[0].Text := line;
  mmLog.Lines.Insert(0, line);
  if comment <> EmptyStr then
    mmLog.Lines.Insert(1, line);

end;

procedure TfrmMain.btnCloseI2cClick(Sender: TObject);
const
  m = 'closeDevice';
begin
  try
    FoI2cService.closeDevice;
    log(m, 'void', 'void');
  except
    on E:Exception do
       log(m, 'void', e.ClassName + ': ' + e.ToString);
  end;
end;

procedure TfrmMain.btnGetRegisterI2cClick(Sender: TObject);
const
  m = 'getRegister';
begin
  try
    edtValueRegister.Text := FoI2cService.getRegister(Byte(StrToInt(edtRegister.Text))).ToString;
    log(m, edtRegister.Text, edtValueRegister.Text);
  except
    on E:Exception do
       log(m, edtRegister.Text, e.ClassName + ': ' + e.ToString);
  end;
end;

procedure TfrmMain.DefineService(const I2cService: trpiI2CDeviceAbstract);
begin
  FoI2cService := I2cService;
end;

end.

