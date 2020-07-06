unit umail;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Math, rpii2cAPI, rpigpioAPI, rpii2cMock, rpigpioMock;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnCloseI2c: TButton;
    btnSetPullUpMode: TButton;
    btnReadPinGPIO: TButton;
    btnClearPinGPIO1: TButton;
    btnSetPinMode: TButton;
    btnShutdownGPIO: TButton;
    btnGetRegisterI2c: TButton;
    btnInitGPIO: TButton;
    btnReadByteI2c: TButton;
    btnOpenI2c: TButton;
    btnSetRegisterI2c: TButton;
    btnWriteBytesI2c: TButton;
    btnSetPinGPIO: TButton;
    btnPWMWritePinGPIO: TButton;
    btnWriteStringI2c: TButton;
    cbIsNewPIGPIO: TCheckBox;
    cbAutoReadI2c: TCheckBox;
    edtAddress: TEdit;
    edtPinToRWGPIO: TEdit;
    edtValuePWMGPIO: TEdit;
    edtRegister: TEdit;
    edtBytes: TEdit;
    edtPinToConfigModeGPIO: TEdit;
    edtValueRegister: TEdit;
    gbAbout: TGroupBox;
    gbOpenCloseI2c: TGroupBox;
    gbInitShutdownGPIO: TGroupBox;
    gbSetGetRegisterI2c: TGroupBox;
    gbPinModeGPIO: TGroupBox;
    gbWriteReadBytesI2c: TGroupBox;
    gbReadWriteGPIO: TGroupBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    lbPinPWMAlert: TLabel;
    lbAbout: TLabel;
    lbconfiguredPinsGPIO: TListBox;
    lbPinModesGPIO: TListBox;
    lbPinPullUpModesGPIO: TListBox;
    lbTryConfigGPIO: TLabel;
    mmReadI2c: TMemo;
    mmLog: TMemo;
    PageControl: TPageControl;
        pnModesGPIO: TPanel;
    ScrollBoxMain: TScrollBox;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    lbTryConfigI2c: TStaticText;
    StatusBar: TStatusBar;
    TimerautoI2c: TTimer;
    tsRpii2c: TTabSheet;
    tsRpiio: TTabSheet;
    procedure btnClearPinGPIO1Click(Sender: TObject);
    procedure btnCloseI2cClick(Sender: TObject);
    procedure btnSetPullUpModeClick(Sender: TObject);
    procedure btnGetRegisterI2cClick(Sender: TObject);
    procedure btnInitGPIOClick(Sender: TObject);
    procedure btnOpenI2cClick(Sender: TObject);
    procedure btnPWMWritePinGPIOClick(Sender: TObject);
    procedure btnReadByteI2cClick(Sender: TObject);
    procedure btnReadPinGPIOClick(Sender: TObject);
    procedure btnSetPinGPIOClick(Sender: TObject);
    procedure btnSetPinModeClick(Sender: TObject);
    procedure btnSetRegisterI2cClick(Sender: TObject);
    procedure btnShutdownGPIOClick(Sender: TObject);
    procedure btnWriteBytesI2cClick(Sender: TObject);
    procedure btnWriteStringI2cClick(Sender: TObject);
    procedure cbAutoReadI2cClick(Sender: TObject);
    procedure edtPinToConfigModeGPIOChange(Sender: TObject);
    procedure edtPinToRWGPIOChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbconfiguredPinsGPIOClick(Sender: TObject);
    procedure lbconfiguredPinsGPIODblClick(Sender: TObject);
    procedure lbPinModesGPIOClick(Sender: TObject);
    procedure lbPinPullUpModesGPIOClick(Sender: TObject);
    procedure TimerautoI2cTimer(Sender: TObject);
  private
    FslPinModes: TStringList;
    FslPullUpModes: TStringList;
    FoI2cServiceMock: TrpiI2CDeviceMock;
    FoGPIOServiceMock: TrpiGPIOMock;

    FoI2cService: trpiI2CDeviceAbstract;
    FoGPIOService: TrpiGPIOAbstract;
    procedure GetReponseI2c;
    procedure log(const method, parameters, returned: string; const comment: string = '');
  public
    procedure DefineService(const I2cService: trpiI2CDeviceAbstract;
    const poGPIOService: TrpiGPIOAbstract);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }


procedure TfrmMain.btnClearPinGPIO1Click(Sender: TObject);
const
  m = 'FoGPIOService.clearPin';
begin
  try
     FoGPIOService.clearPin(StrToInt(edtPinToRWGPIO.Text));
     log(m, edtPinToRWGPIO.Text, 'void');
  except
    on E:Exception do
    begin
       lbTryConfigGPIO.Visible := true;
       log(m, edtPinToRWGPIO.Text, e.ClassName + ': ' + e.ToString);
    end;
  end;
end;

procedure TfrmMain.btnSetPullUpModeClick(Sender: TObject);
const
  m = 'FoGPIOService.setPullupMode';
var
  params: string;
begin
  params := '?';
  try
     params := edtPinToConfigModeGPIO.Text + ',' +
       lbPinPullUpModesGPIO.Items.Strings[lbPinPullUpModesGPIO.ItemIndex];

     FoGPIOService.setPullupMode(byte(StrToInt(edtPinToConfigModeGPIO.Text)),
       byte(lbPinPullUpModesGPIO.ItemIndex));

    if lbconfiguredPinsGPIO.Items.IndexOf(edtPinToConfigModeGPIO.Text) < 0 then
      lbconfiguredPinsGPIO.Items.Add(edtPinToConfigModeGPIO.Text);

    FslPullUpModes.Values[edtPinToConfigModeGPIO.Text] := IntToStr(lbPinPullUpModesGPIO.ItemIndex);

     log(m, params, 'void');
  except
    on E:Exception do
    begin
       lbTryConfigGPIO.Visible := true;
       log(m, params, e.ClassName + ': ' + e.ToString);
    end;
  end;
end;


procedure TfrmMain.btnOpenI2cClick(Sender: TObject);
const
  m = 'openDevice';
var
  addr: byte;
begin
  try
    lbTryConfigI2c.Visible := false;
    addr := byte(StrToInt(edtAddress.Text));
     FoI2cService.openDevice(addr);
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

procedure TfrmMain.btnPWMWritePinGPIOClick(Sender: TObject);
const
  m = 'FoGPIOService.PWMWrite';
var
  params: string;
begin
  params := '?';
  try
     params := edtPinToRWGPIO.Text + ', ' + edtValuePWMGPIO.Text;

     FoGPIOService.PWMWrite(StrToInt(edtPinToRWGPIO.Text),
      StrToInt(edtValuePWMGPIO.Text));
     log(m, params, 'void');
  except
    on E:Exception do
    begin
       lbTryConfigGPIO.Visible := true;
       log(m, params, e.ClassName + ': ' + e.ToString);
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

procedure TfrmMain.btnReadPinGPIOClick(Sender: TObject);
const
  m = 'FoGPIOService.readPin';
begin
  edtValuePWMGPIO.Text := '';
  try
     if FoGPIOService.readPin(StrToInt(edtPinToRWGPIO.Text)) then
       edtValuePWMGPIO.Text := '1'
     else
       edtValuePWMGPIO.Text := '0';

     log(m, edtPinToRWGPIO.Text, edtValuePWMGPIO.Text);
  except
    on E:Exception do
       log(m, edtPinToRWGPIO.Text, e.ClassName + ': ' + e.ToString);

  end;
end;

procedure TfrmMain.btnSetPinGPIOClick(Sender: TObject);
const
  m = 'FoGPIOService.setPin';
begin
  try
     FoGPIOService.setPin(StrToInt(edtPinToRWGPIO.Text));
     log(m, edtPinToRWGPIO.Text, 'void');
  except
    on E:Exception do
    begin
       lbTryConfigGPIO.Visible := true;
       log(m, edtPinToRWGPIO.Text, e.ClassName + ': ' + e.ToString);
    end;
  end;
end;

procedure TfrmMain.btnSetPinModeClick(Sender: TObject);
const
  m = 'FoGPIOService.setPinMode';
var
  params: string;
begin
  params := '?';
  try
     params := edtPinToConfigModeGPIO.Text + ',' +
       lbPinModesGPIO.Items.Strings[lbPinModesGPIO.ItemIndex];

     FoGPIOService.setPinMode(byte(StrToInt(edtPinToConfigModeGPIO.Text)),
       byte(lbPinModesGPIO.ItemIndex));

     if lbconfiguredPinsGPIO.Items.IndexOf(edtPinToConfigModeGPIO.Text) < 0 then
       lbconfiguredPinsGPIO.Items.Add(edtPinToConfigModeGPIO.Text);

     FslPinModes.Values[edtPinToConfigModeGPIO.Text] := IntToStr(lbPinModesGPIO.ItemIndex);

     log(m, params, 'void');
  except
    on E:Exception do
    begin
       lbTryConfigGPIO.Visible := true;
       log(m, params, e.ClassName + ': ' + e.ToString);
    end;
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

procedure TfrmMain.btnShutdownGPIOClick(Sender: TObject);
const
  m = 'FoGPIOService.shutdown';
begin
  try
     FoGPIOService.shutdown;
     log(m, 'void', 'void');
  except
    on E:Exception do
    begin
       lbTryConfigGPIO.Visible := true;
       log(m, 'void', e.ClassName + ': ' + e.ToString);
    end;
  end;
end;

procedure TfrmMain.btnWriteBytesI2cClick(Sender: TObject);
var
  sl: TStringList;
  bytes: array[0..255] of Byte;
  i: integer;
  len: longint;
  m, s: string;
begin
  sl := TStringList.Create;
  try
     m := 'writeByte';
     try
       s := StringReplace(edtBytes.Text, ' ', ',', [Rfreplaceall]);
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
       TimerautoI2c.Enabled := cbAutoReadI2c.Checked;
    except
      on E:Exception do
         log(m, edtBytes.Text, e.ClassName + ': ' + e.ToString);
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmMain.btnWriteStringI2cClick(Sender: TObject);
const
  m = 'writeBytes';
var
  s: string;
begin
 try
   s := edtBytes.Text;
   FoI2cService.writeBytes(@s[1], Length(s));
   log(m, s, 'void');
   sleep(2000);
   GetReponseI2c;
   TimerautoI2c.Enabled := cbAutoReadI2c.Checked;
  except
  on E:Exception do
     log(m, edtBytes.Text, e.ClassName + ': ' + e.ToString);
  end;
end;

procedure TfrmMain.cbAutoReadI2cClick(Sender: TObject);
begin
end;

procedure TfrmMain.edtPinToConfigModeGPIOChange(Sender: TObject);
begin
  lbPinPWMAlert.Visible := (edtPinToConfigModeGPIO.Text = '12') or
    (edtPinToConfigModeGPIO.Text = '13') or
    (edtPinToConfigModeGPIO.Text = '18') or
    (edtPinToConfigModeGPIO.Text = '19') or
    (edtPinToConfigModeGPIO.Text = '40') or
    (edtPinToConfigModeGPIO.Text = '41') or
    (edtPinToConfigModeGPIO.Text = '45');
end;


procedure TfrmMain.edtPinToRWGPIOChange(Sender: TObject);
begin
  btnClearPinGPIO1.Enabled := StrToIntDef(edtPinToRWGPIO.Text, -1) <> -1;
  btnSetPinGPIO.Enabled := StrToIntDef(edtPinToRWGPIO.Text, -1) <> -1;
  btnReadPinGPIO.Enabled := StrToIntDef(edtPinToRWGPIO.Text, -1) <> -1;

  btnPWMWritePinGPIO.Enabled := (edtPinToRWGPIO.Text = '12') or
    (edtPinToRWGPIO.Text = '13') or
    (edtPinToRWGPIO.Text = '18') or
    (edtPinToRWGPIO.Text = '19') or
    (edtPinToRWGPIO.Text = '40') or
    (edtPinToRWGPIO.Text = '41') or
    (edtPinToRWGPIO.Text = '45');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
const
  ITEM = '%1:d - %0:s';
begin
  FslPinModes := TStringList.Create;
  FslPullUpModes := TStringList.Create;

  lbPinModesGPIO.Items.Add(ITEM, ['RPIGPIO_INPUT', RPIGPIO_INPUT]);
  lbPinModesGPIO.Items.Add(ITEM, ['RPIGPIO_OUTPUT', RPIGPIO_OUTPUT]);
  lbPinModesGPIO.Items.Add(ITEM, ['RPIGPIO_PWM_OUTPUT', RPIGPIO_PWM_OUTPUT]);

  lbPinPullUpModesGPIO.Items.Add(ITEM, ['RPIGPIO_PUD_OFF', RPIGPIO_PUD_OFF]);
  lbPinPullUpModesGPIO.Items.Add(ITEM, ['RPIGPIO_PUD_DOWN', RPIGPIO_PUD_DOWN]);
  lbPinPullUpModesGPIO.Items.Add(ITEM, ['RPIGPIO_PUD_UP', RPIGPIO_PUD_UP]);


  FoI2cServiceMock := TrpiI2CDeviceMock.Create;
  FoGPIOServiceMock := TrpiGPIOMock.Create;

  //default
  DefineService(FoI2cServiceMock, FoGPIOServiceMock);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FoI2cServiceMock.Free;
  FoGPIOServiceMock.Free;
  FslPinModes.Free;
  FslPullUpModes.Free;
end;

procedure TfrmMain.lbconfiguredPinsGPIOClick(Sender: TObject);
begin
  edtPinToConfigModeGPIO.Text :=
    lbconfiguredPinsGPIO.Items.strings[lbconfiguredPinsGPIO.ItemIndex];

  lbPinModesGPIO.ItemIndex := StrToIntDef(FslPinModes.Values[edtPinToConfigModeGPIO.Text], -1);
  lbPinPullUpModesGPIO.ItemIndex := StrToIntDef(FslPullUpModes.Values[edtPinToConfigModeGPIO.Text], -1);

end;

procedure TfrmMain.lbconfiguredPinsGPIODblClick(Sender: TObject);
begin
  edtPinToRWGPIO.Text :=
    lbconfiguredPinsGPIO.Items.strings[lbconfiguredPinsGPIO.ItemIndex];
end;

procedure TfrmMain.lbPinModesGPIOClick(Sender: TObject);
begin
  btnSetPinMode.Enabled := lbPinModesGPIO.ItemIndex >= 0;
end;

procedure TfrmMain.lbPinPullUpModesGPIOClick(Sender: TObject);
begin
  btnSetPullUpMode.Enabled := lbPinPullUpModesGPIO.ItemIndex >= 0;
end;


procedure TfrmMain.GetReponseI2c;
var
  buff: array[0..30] of byte;
  read: longint;
  i: integer;
  sread: string;
begin
  read := FoI2cService.readBytes(@buff[0], 30);
  sread := EmptyStr;
  if read > 0 then
  begin
    for i := 0 to read-1 do
    begin
      sread := sread + ' #'+IntToStr(buff[i]);
      mmReadI2c.Lines.text := mmReadI2c.Lines.text +
        Char(buff[i]);
    end;
  end;
  log('read.Bytes', 'buff, 30', IntToStr(read) + ' -> ' + sread);
end;


procedure TfrmMain.TimerautoI2cTimer(Sender: TObject);
begin
  GetReponseI2c;
  TimerautoI2c.Enabled := cbAutoReadI2c.Checked;
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

procedure TfrmMain.btnInitGPIOClick(Sender: TObject);
const
  m = 'FoGPIOService.initialise';
begin
  try
     FoGPIOService.initialise(cbIsNewPIGPIO.Checked);
     log(m, cbIsNewPIGPIO.Checked.ToString(), 'void');
  except
    on E:Exception do
    begin
       lbTryConfigGPIO.Visible := true;
       log(m, cbIsNewPIGPIO.Checked.ToString(), e.ClassName + ': ' + e.ToString);
    end;
  end;
end;

procedure TfrmMain.DefineService(const I2cService: trpiI2CDeviceAbstract;
    const poGPIOService: TrpiGPIOAbstract);
begin
  FoI2cService := I2cService;
  FoGPIOService := poGPIOService;
end;

end.

