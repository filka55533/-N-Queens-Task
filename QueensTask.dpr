program QueensTask;

uses
  Forms,
  ufMainForm in 'ufMainForm.pas' {frmMainChooseMode},
  ufPlayForm in 'ufPlayForm.pas' {frmPlay},
  ufChooseSize in 'ufChooseSize.pas' {frmChooseSize},
  uWorkWithDeskStatement in 'uWorkWithDeskStatement.pas',
  ufToStop in 'ufToStop.pas' {frmToStop},
  uWorkWithFiles in 'uWorkWithFiles.pas',
  ufHelp in 'ufHelp.pas' {frmHelp},
  ufRecords in 'ufRecords.pas' {frmRecords};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMainChooseMode, frmMainChooseMode);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.CreateForm(TfrmRecords, frmRecords);
  Application.Run;
end.
