unit ufRecords;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmRecords = class(TForm)
    pnlBack: TPanel;
    mmoRecords: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var    frmRecords: TfrmRecords;

implementation

{$R *.dfm}

procedure TfrmRecords.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if Action = caFree	then
    Self.Destroy;
end;

end.
