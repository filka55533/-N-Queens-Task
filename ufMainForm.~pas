unit ufMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, ufPlayForm, ufRecords;

type
  TfrmMainChooseMode = class(TForm)
    pnlLeftAlign: TPanel;
    imgBackGround: TImage;
    btnToPlay: TButton;
    btnRecords: TButton;
    btnExit: TButton;
    procedure btnToPlayClick(Sender: TObject);
    procedure btnExitMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRecordsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainChooseMode: TfrmMainChooseMode;

implementation

{$R *.dfm}

procedure TfrmMainChooseMode.btnToPlayClick(Sender: TObject);
var PlayRezhim: TfrmPlay;
begin
  Visible := False;
  PlayRezhim := TfrmPlay.Create(nil);
  PlayRezhim.ShowModal;
  PlayRezhim.Destroy;
  Close;
end;

procedure TfrmMainChooseMode.btnExitMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Self.Close
end;

procedure TfrmMainChooseMode.btnRecordsClick(Sender: TObject);
var WndwRecords:TfrmRecords;
    RecFile: TextFile;
    s: string;
begin
  WndwRecords := TfrmRecords.Create(nil);
  WndwRecords.Show;
  if FileExists('Records.txt') then
  begin
    AssignFile(RecFile, 'Records.txt');
    Reset(RecFile);
    while not Eof(RecFile) do
    begin
      Readln(RecFile, s);
      WndwRecords.mmoRecords.Lines.Add(s);
    end;
  end;
end;

end.
