unit umail;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Math, rpii2cAPI, rpii2cMock;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnGetRegisterI2c: TButton;
    btnReadByteI2c: TButton;
    btnOpenI2c: TButton;
    btnCloseI2c: TButton;
    btnSetRegisterI2c: TButton;
    btnWriteBytesI2c: TButton;
    edtAddress: TEdit;
    edtRegister: TEdit;
    edtBytes: TEdit;
    edtValueRegister: TEdit;
    gbAbout: TGroupBox;
    gbOpenCloseI2c: TGroupBox;
    gbSetGetRegisterI2c: TGroupBox;
    gbWriteReadBytesI2c: TGroupBox;
    lbAbout: TLabel;
    mmLog: TMemo;
    PageControl: TPageControl;
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
  private
    FoI2cServiceMock: TrpiI2CDeviceMock;
    FoI2cService: trpiI2CDeviceAbstract;
    procedure log(const method, parameters, returned: string);
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
     FoI2cService.openDevice(StrToInt(edtAddress.Text));
     log(m, edtAddress.Text, 'void');
  except
    on E:Exception do
       log(m, edtAddress.Text, e.ClassName + ': ' + e.ToString);
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
  sl := TStringList.Create;
  try
     m := 'writeByte';
     try
       sl.CommaText := edtBytes.Text;
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
  rpii2cMock
end;

procedure TfrmMain.log(const method, parameters, returned: string);
var
  line: string;
begin
  line := Format('[%s - %s] Parameters: [%s], returned: [%s]',
    [DateToStr(Now), method, parameters, returned]);
  StatusBar.Panels[0].Text := line;
  mmLog.Lines.add(line);
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

