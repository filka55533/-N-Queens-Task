unit ufHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmHelp = class(TForm)
    pnlBackGround: TPanel;
    mmoHelp: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHelp: TfrmHelp;

implementation

{$R *.dfm}

procedure TfrmHelp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Action = caFree	then
   Self.Destroy;
end;

end.
