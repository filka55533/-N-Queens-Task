unit ufPlayForm;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ufChooseSize, ufHelp, ExtCtrls, jpeg, StdCtrls, Buttons,
  uWorkWithDeskStatement, QueenTaskModel, uWorkWithFiles;

const
  NameOfQueen = 'Queen';
  StartInterval = 1000;

type
  TMessages = (tmNil, tmFindNew, tmFindOld, tmIncrClick, tmFindAll);

  //Arrays for work with dynamic components
  TImgList = array [1..13] of TImage;
  TNotationList = array [1..2*13] of TLabel;


  //Stack of users moves
  TPtUsersMoves = ^TUsersMoves;
  TUsersMoves = record
    PtOnNext: TPtUsersMoves;
    PredPos: array ['x'..'y'] of integer;
    NumberOfQueen:integer;
  end;

  //Record for moving
  TMovingQueen = record
    Number:Integer;
    IsItClicked:Boolean;
    NameQueen: integer;
  end;

  TfrmPlay = class(TForm)
    mmMainMenu: TMainMenu;
    mniGame: TMenuItem;
    mniHelp: TMenuItem;
    mniNewGame: TMenuItem;
    mniOpen: TMenuItem;
    mniSave: TMenuItem;
    dlgSaveGame: TSaveDialog;
    dlgOpenGame: TOpenDialog;
    pnlLandDesk: TPanel;
    imgDesk: TImage;
    pnlRightSide: TPanel;
    mmoMoves: TMemo;
    btnBackMove: TButton;
    pbGreenCell: TPaintBox;
    lblTimeLeft: TLabel;
    tmrTimePlay: TTimer;
    lblTimeNow: TLabel;
    lblMessage: TLabel;
    lblCombinFindName: TLabel;
    lblCombProress: TLabel;
    btnStarNewGame: TButton;
    btnToStop: TButton;
    mniDemonstration: TMenuItem;
    lblHerzTemp: TLabel;
    edtHerzChoose: TEdit;
    btnAccept: TButton;
    btnReply: TButton;
    btnStop_Start: TButton;
    procedure mniNewGameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mniSaveClick(Sender: TObject);
    procedure mniOpenClick(Sender: TObject);


    //Мои методы
    procedure StartGame;

    //Draw
    procedure DrawDesk;
    procedure DrawQueens (var AQueenNames: TImgList);
    procedure DrawNotation(var ANotationList: TNotationList);

    //ReDraw
    procedure ReDrawQueens(ANumQueen:Integer = 0;AcordX:Integer = 0; ACordY:integer = 0);
    procedure ReDrawCell (AColor:TColor; X, Y:Integer);


    procedure MoveQueen (Sender:TObject);
    procedure imgDeskMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgDeskMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    //Work with stack of moves
    procedure CreateElementOfMovesStack (var APointer: TPtUsersMoves);
    procedure DeleteElementOfMovesStack (var APointer: TPtUsersMoves);
    procedure WriteMoves;
    procedure btnBackMoveClick(Sender: TObject);
    procedure tmrTimePlayTimer(Sender: TObject);

    //Check achievment of solution
    procedure CheckFindingSolution;

    procedure RecProgres;
    procedure btnStarNewGameClick(Sender: TObject);
    procedure btnToStopClick(Sender: TObject);
    procedure mniDemonstrationClick(Sender: TObject);

    procedure EndGame;

    //Demonstr Mode
    procedure StartDemonstrationMode;
    procedure DrawQueensDemontr;   
    procedure btnAcceptClick(Sender: TObject);
    procedure btnReplyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnStop_StartMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mniGameClick(Sender: TObject);
    procedure mniHelpClick(Sender: TObject);

    //Procedure of writing in file
    procedure WriteRecords;

  private

    NumberOfQueens: Integer;

    IsItInGame: Boolean;
    IsItDemonstration: Boolean;

    DarkColour, LightColour: TColor;
    CellSize: Integer;

    //Queens for game
    QueensList: TImgList;

    //Notation of the desk
    DeskNotation: TNotationList;

    //Record for checkin' moving queen
    MovingQueen:TMovingQueen;
    UsersMoves:TPtUsersMoves;

    //StatementOfDesk
    DeskCellsState: TCellsAvail;
    TimeFromStart: Integer;

    //List of users solutions
    ListOfUsersSolutions: TPtListOfSolutions;
    CountOfFindingSolutions, CountTotalSolutions: Integer;

    MessageForUser: TMessages;

  public

  end;

var
  frmPlay: TfrmPlay;

implementation

{$R *.dfm}

procedure TfrmPlay.mniNewGameClick(Sender: TObject);
var ChooseSize: TfrmChooseSize;
    ResMR:Integer;
begin
  ChooseSize := TfrmChooseSize.Create(nil);
  mniSaveClick(nil);

  //Выбор количества ферзей пользователем
  ResMR := ChooseSize.ShowModal;
  if (ResMR = mrOk) then
  begin
    NumberOfQueens := StrToInt(ChooseSize.cbbSizeBox.Text) ;
    IsItInGame := True;
  end;
  ChooseSize.Destroy;
  StartGame;
end;

procedure TfrmPlay.FormCreate(Sender: TObject);
var i:integer;
begin
  for i:=1 to High(TImgList) do
    Self.QueensList[i] := nil;

  for i := 1 to High(TNotationList) do
    Self.DeskNotation[i] := nil;


  ListOfUsersSolutions := nil;

  NumberOfQueens := 5;
  IsItInGame := False;
  IsItDemonstration := False;
  DarkColour := clDkGray;
  LightColour := clWhite;
  DoubleBuffered := True;
  btnReply.Visible := False;
end;

procedure TfrmPlay.mniSaveClick(Sender: TObject);
var AFile:TSaveFile;
    PtSolutions: TPtListOfSolutions;
    RecForSave: TFieldsForFile;
    OrdNum: Integer;
begin
  if IsItInGame and dlgSaveGame.Execute then
  begin
    AssignFile(AFile, dlgSaveGame.FileName+'.bin');
    Rewrite(AFile);

    PtSolutions := ListOfUsersSolutions;
    RecForSave.CountOfQueens := NumberOfQueens;
    RecForSave.LeftedTime := TimeFromStart;
    RecForSave.TotalNum := CountOfFindingSolutions;

    OrdNum := 1;
    while PtSolutions <> nil do
    begin
      if PtSolutions^.FoundSolution then
      begin
        RecForSave.OrdNumPos := OrdNum;
        write(AFile, RecForSave);
        inc(OrdNum);
      end;
      PtSolutions := PtSolutions^.PtOnPred;
    end;

    CloseFile(AFile);
  end;
end;

procedure TfrmPlay.mniOpenClick(Sender: TObject);
var AFileToOpen:TSaveFile;
    ARec:TFieldsForFile;
    PtList:TPtListOfSolutions;
    Counter:Integer;
begin
  if dlgOpenGame.Execute then
  begin
    AssignFile(AFileToOpen, dlgOpenGame.FileName);
    Reset(AFileToOpen);
    Read(AFileToOpen, ARec);
    NumberOfQueens := ARec.CountOfQueens;
    StartGame;
    TimeFromStart := ARec.LeftedTime;
    CountOfFindingSolutions := ARec.TotalNum;
    RecProgres;

    PtList := ListOfUsersSolutions;
    Counter := 1;
    while not Eof(AFileToOpen) do
    begin

      if Counter = ARec.OrdNumPos then
      begin
        PtList^.FoundSolution := True;
        Read(AFileToOpen, ARec);
      end;

      inc(Counter);
    end;

    CloseFile(AFileToOpen);
  end;
end;


procedure TfrmPlay.StartGame;
var i:Integer;
begin
  tmrTimePlay.Interval := 500;
  pnlLandDesk.Visible := True;
  pnlRightSide.Visible := True;
  btnToStop.Visible := true;
  btnBackMove.Visible := True;
  lblTimeLeft.Visible := True;
  lblTimeNow.Visible := True;
  lblCombinFindName.Visible := True;
  lblCombProress.Visible := True;

  IsItInGame := True;
  IsItDemonstration := False;
  mmoMoves.Clear;
  InitDesk(Self.DeskCellsState);
  tmrTimePlay.Enabled := True;
  lblTimeLeft.Show;
  lblTimeNow.Show;
  MessageForUser := tmNil;

  lblHerzTemp.Visible := False;
  btnAccept.Visible := False;
  btnStop_Start.Visible := False;
  edtHerzChoose.Visible := False;
  btnStarNewGame.Visible := False;
  btnReply.Visible := False;

  //Уничтожение ферзей
  for i := 1 to High(QueensList) do
  begin
    if QueensList[i] <> nil then
    begin
      QueensList[i].Destroy;
      QueensList[i] := nil;
    end;
  end;

  for i := 1 to High(DeskNotation) do
    if DeskNotation[i] <> nil then
    begin
      DeskNotation[i].Destroy;
      DeskNotation[i] := nil;
    end;


  DrawDesk;
  DrawNotation(DeskNotation);
  imgDesk.Visible := True;
  DrawQueens(QueensList);

  with MovingQueen do
  begin
    Number := 0;
    IsItClicked := False;
    NameQueen := 1;
  end;

  //ClearList
  FindListStart(ListOfUsersSolutions);
  while (ListOfUsersSolutions <> nil)  do
  begin
    if (ListOfUsersSolutions^.PtOnNext <> nil)  then
    begin
      ListOfUsersSolutions := ListOfUsersSolutions^.PtOnNext;
      Dispose(ListOfUsersSolutions^.PtOnPred);
    end
    else
      begin
        Dispose(ListOfUsersSolutions);
        ListOfUsersSolutions := nil;
      end;
  end;

  //Find solutions
  CountOfFindingSolutions := 0;
  FindSolutions(NumberOfQueens, ListOfUsersSolutions, CountTotalSolutions);
  FindListStart(ListOfUsersSolutions);
  lblCombinFindName.Visible := True;
  RecProgres;

  //Clear users moves
  while UsersMoves <> nil do
    DeleteElementOfMovesStack(UsersMoves);

  //Time initializaton
  TimeFromStart := 0;

end;

procedure TfrmPlay.DrawDesk;
var X, Y, WidthOfDesk:Integer;
    CountX, CountY: Integer;
    IsItLight, IsItMark: Boolean;
begin

  with pnlLandDesk do
  begin
    if Width > Height then
      WidthOfDesk := Height-2-45
    else
      WidthOfDesk := Width-2-45;

    Self.CellSize := ((WidthOfDesk-NumberOfQueens) div (NumberOfQueens+1));
    WidthOfDesk := (Self.CellSize*NumberOfQueens)+1;

  end;



  with imgDesk do
  begin

    Left := (pnlLandDesk.Width+pnlLandDesk.Left)-WidthOfDesk-CellSize;
    Top := 0;

    Picture.Bitmap.Width := WidthOfDesk;
    Picture.Bitmap.Height := WidthOfDesk;
    Width := WidthOfDesk;
    Height := WidthOfDesk;


    for CountX := NumberOfQueens downto 1 do
    begin
      X := 0;
      Y := (CountX-1)*Self.CellSize;
      IsItLight := (odd(NumberOfQueens-CountX));
      for CountY := 1 to NumberOfQueens do
      begin
        IsItMark :=  CheckMark(Self.DeskCellsState, CountY, CountX, NumberOfQueens);

        with Canvas.Brush do
        if IsItMark then
            Color := clRed
        else
          if IsItLight then
            Color := LightColour
          else
            Color := DarkColour;

        Canvas.Rectangle(X,Y,X+Self.CellSize+1,Y+Self.CellSize+1);

        IsItLight := not IsItLight;
        X := X + Self.CellSize;

      end;
    end;
  end;
end;

//Создание и прорисовка ферзей на начальной позиции
procedure TfrmPlay.DrawQueens (var AQueenNames: TImgList);
var i:integer;
    QueenSize:Integer;
begin

  QueenSize := Trunc(0.9*CellSize);

  for i := 1 to NumberOfQueens do
  begin

    AQueenNames[i] := TImage.Create(frmPlay);
    AQueenNames[i].Parent := Self.pnlLandDesk;
    AQueenNames[i].Name := NameOfQueen+IntToStr(i);

    if IsItInGame then
      AQueenNames[i].OnClick := MoveQueen;

    AQueenNames[i].Left := Self.pnlLandDesk.Left + Self.pnlLandDesk.Width-CellSize+Round(0.05*CellSize);
    AQueenNames[i].Top := (i-1)*CellSize+Round(0.05*CellSize);

    AQueenNames[i].Width := QueenSize;
    AQueenNames[i].Height := QueenSize;


    AQueenNames[i].Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'QueenIMG.jpg');
    AQueenNames[i].Stretch := True;

    AQueenNames[i].Visible := True;


  end;
end;

procedure TfrmPlay.MoveQueen(Sender: TObject);
var s:string[8];
    CordX, CordY:integer;
begin
  if not MovingQueen.IsItClicked then
  begin
    s := (Sender as TImage).Name;
    while not (s[1] in ['1'..'9']) do
      Delete(s, 1, 1);

    MovingQueen.NameQueen := StrToInt(s);

    //CreateElementOfStack
    CreateElementOfMovesStack(UsersMoves);

    UsersMoves^.NumberOfQueen := MovingQueen.NameQueen;
    if (Sender as TImage).Left > (imgDesk.Left + imgDesk.Width) then
    begin
      UsersMoves^.PredPos['x'] := 0;
      UsersMoves^.PredPos['y'] := 0;
    end
    else
      begin
        CordX := ((Sender as TImage).Left - imgDesk.Left) div CellSize + 1;
        CordY := ((Sender as TImage).Top - imgDesk.Top) div CellSize + 1;
        UsersMoves^.PredPos['x'] := CordX;
        UsersMoves^.PredPos['y'] := CordY;
        DismarkDesk(DeskCellsState,CordY,CordX,NumberOfQueens);
        DrawDesk;
      end;

    MovingQueen.IsItClicked := True;
  end;
end;

procedure TfrmPlay.imgDeskMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);

var CellClr:TColor;
    i:integer;
begin
  if IsItInGame and MovingQueen.IsItClicked then
    with imgDesk do
    begin
      CellClr := Picture.BitMap.Canvas.Pixels[X, Y];
      if (CellClr <> clBlack) and (CellClr <> clGreen) and (not CheckMark(DeskCellsState, X div CellSize + 1, Y div CellSize +1, NumberOfQueens) ) then
      begin
        DrawDesk;
        for i:=1 to NumberOfQueens do
          QueensList[i].Invalidate;
        Self.ReDrawCell(clGreen, X, Y);
      end;

    end;

end;

procedure TfrmPlay.ReDrawCell(AColor: TColor; X, Y: Integer);
begin

  X := (X div CellSize)*CellSize;
  Y := (Y div CellSize)*CellSize;

  with imgDesk do
    if (X < Width) and (Y < Height) then
    begin
      Picture.Bitmap.Canvas.Brush.Color := AColor;
      Picture.Bitmap.Canvas.Rectangle(X, Y, X+CellSize+1, Y+ CellSize+1);
      Refresh;

    end;

end;

procedure TfrmPlay.imgDeskMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var Qun:TImage;
begin
  if (MovingQueen.IsItClicked) and (IsItInGame) and (Button = mbLeft)  then
  begin
    Qun := Self.QueensList[MovingQueen.NameQueen];
    with Qun do
    begin

      X := (X div CellSize);
      Y := (Y div CellSize);

      if CheckMark(DeskCellsState,X+1, Y+1, NumberOfQueens) then
        MessageForUser := tmIncrClick
      else
      begin
        MarkDesk(Self.DeskCellsState, Y+1, X+1, NumberOfQueens);

        X := X*CellSize;
        Y := Y*CellSize;
        Left := X + Round(CellSize*0.05)+imgDesk.Left;
        Top := Y + Round(0.05*CellSize)+imgDesk.Top;
        MovingQueen.IsItClicked := not MovingQueen.IsItClicked;
        Inc(MovingQueen.Number);
        ReDrawQueens;

        //Record of last move
        WriteMoves;
        DrawDesk;

        CheckFindingSolution;
      end;
    end;
  end;
end;

procedure TfrmPlay.ReDrawQueens(ANumQueen:Integer = 0;AcordX:Integer = 0; ACordY:integer = 0);
var i, YCoord:Integer;
begin

  YCoord := imgDesk.Top;
  for i := 1 to NumberOfQueens do
    if (QueensList[i].Left = Self.pnlLandDesk.Left + Self.pnlLandDesk.Width-CellSize+Round(0.05*CellSize)) then
    begin
      QueensList[i].Top := YCoord+Round(0.05*CellSize);
      YCoord := YCoord+CellSize;
    end;

  if ANumQueen <> 0 then
  begin
    if (AcordX = 0) or (ACordY = 0) then
    begin
      QueensList[ANumQueen].Top := YCoord +Round(0.05*CellSize);
      QueensList[ANumQueen].Left := Self.pnlLandDesk.Left+
                                    Self.pnlLandDesk.Width-CellSize+
                                    Round(0.05*CellSize);
    end
    else
      begin
        QueensList[ANumQueen].Top := imgDesk.Top +(AcordY-1)*CellSize+Round(0.05*CellSize);
        QueensList[ANumQueen].Left := imgDesk.Left + (ACordX-1)*CellSize+Round(0.05*CellSize);
      end;

  end;
end;

procedure TfrmPlay.DrawNotation(var ANotationList: TNotationList);
var i:Integer;
begin
  for i := 1 to NumberOfQueens do
  begin
    ANotationList[i] := TLabel.Create(pnlLandDesk);
    ANotationList[i].Parent := pnlLandDesk;

    ANotationList[i].Caption := IntToStr(NumberOfQueens-i+1);
    ANotationList[i].Font.Name := 'Calibri';
    ANotationList[i].Font.Size := Round(0.25*CellSize);

    ANotationList[i].Width := Round(0.5*CellSize);
    ANotationList[i].Height := Round(0.5*CellSize);

    ANotationList[i].Left := imgDesk.Left-round(0.5*CellSize);
    if Length(ANotationList[i].Name) > 1 then
      ANotationList[i].Left := ANotationList[i].Left - round(0.5*CellSize);

    ANotationList[i].Top := imgDesk.Top +(i-1)*CellSize+round(0.25*CellSize);
  end;

  for i := NumberOfQueens+1 to 2*NumberOfQueens do
  begin
    ANotationList[i] := TLabel.Create(pnlLandDesk);
    ANotationList[i].Parent := pnlLandDesk;

    ANotationList[i].Caption := chr(Ord('A')+i-NumberOfQueens-1);
    ANotationList[i].Font.Name := 'Calibri';
    ANotationList[i].Font.Size := Round(0.25*CellSize);

    ANotationList[i].Width := Round(0.5*CellSize);
    ANotationList[i].Height := Round(0.5*CellSize);

    ANotationList[i].Left := imgDesk.Left + (i-NumberOfQueens-1)*CellSize+round(0.375*CellSize);
    ANotationList[i].Top := imgDesk.Top + imgDesk.Height + Round(0.125*CellSIze);

  end;
end;

//Create stack
procedure TfrmPlay.CreateElementOfMovesStack(var APointer: TPtUsersMoves);
var TempPnt:TPtUsersMoves;
begin
  New(TempPnt);
  TempPnt^.PtOnNext := APointer;
  APointer := TempPnt;
end;

//Delete element of stack
procedure TfrmPlay.DeleteElementOfMovesStack(var APointer: TPtUsersMoves);
var TempPnt:TPtUsersMoves;
begin
  if APointer <> nil then
    begin
    	TempPnt:=APointer^.PtOnNext;
      Dispose(APointer);
      APointer:=TempPnt;
    end;
end;

//Output of moves
procedure TfrmPlay.WriteMoves;
var s:string;
begin
  s := IntToStr(MovingQueen.Number)+'.'+'Q';
  with QueensList[MovingQueen.NameQueen] do
  begin
    s := s + chr(Ord('a') + ((Left - imgDesk.Left) div CellSize));
    s := s + IntToStr(NumberOfQueens  - ((Top - imgDesk.Top) div CellSize));
    mmoMoves.Lines.Add(s);
  end;

end;

procedure TfrmPlay.btnBackMoveClick(Sender: TObject);
var APtNow, APtOnNext:TPtUsersMoves;
begin
  //Back for move
  if IsItInGame and (not MovingQueen.IsItClicked) and(MovingQueen.Number <> 0) and (UsersMoves <> nil) then
  begin
    mmoMoves.Lines.Delete(mmoMoves.Lines.Count-1);
    APtNow := UsersMoves;
    APtOnNext := UsersMoves^.PtOnNext;
    Dec(MovingQueen.Number);

    //Delete stack and find position for pred queen
    with QueensList[UsersMoves^.NumberOfQueen] do
      DismarkDesk(DeskCellsState,(Top-imgDesk.Top) div CellSize +1,(Left-imgDesk.Left) div CellSize + 1,NumberOfQueens );

    UsersMoves := APtNow;
    UsersMoves^.PtOnNext := APtOnNext;
    ReDrawQueens(UsersMoves^.NumberOfQueen, UsersMoves^.PredPos['x'],UsersMoves^.PredPos['y']);
    DeleteElementOfMovesStack(UsersMoves);

    if UsersMoves <> nil then
    begin
      MovingQueen.NameQueen := UsersMoves^.NumberOfQueen;
      with QueensList[UsersMoves^.NumberOfQueen] do
        MarkDesk(DeskCellsState,(Top-imgDesk.Top) div CellSize +1,(Left-imgDesk.Left) div CellSize + 1   ,NumberOfQueens );

    end;
    DrawDesk;
  end
  else
    if MovingQueen.IsItClicked then
    begin
      MovingQueen.IsItClicked := false;
      DeleteElementOfMovesStack(UsersMoves);
    end;
end;

procedure TfrmPlay.tmrTimePlayTimer(Sender: TObject);
var s:string;
    sec, min, hour:integer;
begin
  if IsItInGame then
  begin
    Inc(TimeFromStart);
    hour := TimeFromStart div 7200;
    min := (TimeFromStart div 120) mod 60;
    sec := (TimeFromStart div 2) mod 60;

    s:=IntToStr(hour)+':';
    if hour < 10 then
      s := '0'+s;

    if min < 10 then
      s:= s+'0';
    s:= s + IntToStr(Min)+':';

    if sec < 10 then
    s:= s+'0';

    s := s + IntToStr(sec);
    lblTimeNow.Caption := s;
    tmrTimePlay.Enabled := true;

     if (MessageForUser <> tmNil) then
    begin
      case MessageForUser of
        tmFindNew: s := 'Найдена новая комбинация ферзей!';
        tmFindOld: s := 'Вы ввели уже найденную вами комбинацию!';
        tmIncrClick: s := 'Вы не можете поставить на данную позицию ферзя';
        tmFindAll:
        begin
          s := 'Вы нашли все комбинации!';
          IsItInGame := False;
          btnStarNewGame.Visible := True;
          WriteRecords;
        end;
      end;
      lblMessage.Width := Length(s)*lblMessage.Font.Size;
      lblMessage.Caption := s;
      lblMessage.left := (pnlRightSide.Width div 2) - (lblMessage.Width div 3);
      lblMessage.Visible := true;
      MessageForUser := tmNil
    end
    else
      lblMessage.Visible := False;
  end
  else
    if IsItDemonstration then
      DrawQueensDemontr;
end;

procedure TfrmPlay.CheckFindingSolution;
var i, CordX, CordY: Integer;
    MatrixDesk: TArrQueens;
    fl: Boolean;
begin
  //Check of finalization
  if MovingQueen.Number >= NumberOfQueens then
  begin
    fl := True;
    i := 1;
    while fl and (i<=NumberOfQueens) do
      if QueensList[i].Left >= imgDesk.Left + imgDesk.Width then
        fl := false
      else
        inc(i);


    if fl then
    begin
      //Fill array according Virt theory
      SetLength(MatrixDesk, NumberOfQueens);
      for i := 1 to NumberOfQueens do
      begin
        CordX := (QueensList[i].Left - imgDesk.Left) div CellSize;
        CordY := (QueensList[i].Top - imgDesk.Top) div CellSize;
        MatrixDesk[CordX] := CordY;
      end;


      if ItIsNewSolution(ListOfUsersSolutions, MatrixDesk) then
      begin
        Inc(CountOfFindingSolutions);

        if CountOfFindingSolutions = CountTotalSolutions then
          MessageForUser := tmFindAll
        else
          MessageForUser := tmFindNew;
        RecProgres;
      end
      else
        MessageForUser := tmFindOld;
    end;
  end;
end;

procedure TfrmPlay.RecProgres;
var s:string;
    Mid:integer;
begin
  s := IntToStr(CountOfFindingSolutions)+'/'+IntToStr(CountTotalSolutions);
  Mid := lblCombinFindName.Width div 2;
  lblCombProress.Width := Length(s)*(lblCombProress.Font.Size+3);
  lblCombProress.Left := lblCombinFindName.Left + Mid - lblCombProress.Width div 2;
  lblCombProress.Caption := s;
  lblCombProress.Visible := True;
end;

procedure TfrmPlay.btnStarNewGameClick(Sender: TObject);
begin
  mniNewGameClick(Sender);
end;

procedure TfrmPlay.btnToStopClick(Sender: TObject);
begin
  IsItInGame := False;
  lblMessage.Visible := True;
  lblMessage.Caption := 'Вы закончили игру';
  btnStarNewGame.Visible := True;
end;

procedure TfrmPlay.mniDemonstrationClick(Sender: TObject);
var ChooseSize: TfrmChooseSize;
    ResMR:Integer;
begin
  EndGame;
  ChooseSize := TfrmChooseSize.Create(nil);
  if IsItInGame then
    dlgSaveGame.Execute;
  //Выбор количества ферзей пользователем
  ResMR := ChooseSize.ShowModal;
  if (ResMR = mrOk) then
  begin
    NumberOfQueens := StrToInt(ChooseSize.cbbSizeBox.Text) ;
    IsItDemonstration := True;
  end;
  ChooseSize.Destroy;
  StartDemonstrationMode;
end;

procedure TfrmPlay.EndGame;
begin
  pnlRightSide.Visible := false;
  IsItInGame := false;
  pnlLandDesk.Visible := False;
  imgDesk.Visible := false;
end;

procedure TfrmPlay.StartDemonstrationMode;
var i:Integer;
begin
  pnlLandDesk.Visible := True;
  pnlRightSide.Visible := True;

  lblTimeLeft.Visible := False;
  lblTimeNow.Visible := False;
  lblMessage.Visible := False;
  lblCombinFindName.Visible := True;
  lblCombProress.Visible := True;

  btnBackMove.Visible := false;
  btnStarNewGame.Visible := False;
  btnToStop.Visible := False;
  tmrTimePlay.Interval := StartInterval;

  lblHerzTemp.Visible := True;
  btnAccept.Visible := True;
  btnStop_Start.Visible := True;
  edtHerzChoose.Visible := True;
  edtHerzChoose.Text := IntToStr(tmrTimePlay.Interval);

  IsItInGame := False;
  IsItDemonstration := True;
  mmoMoves.Clear;
  InitDesk(Self.DeskCellsState);

  //Уничтожение ферзей
  for i := 1 to High(QueensList) do
  begin
    if QueensList[i] <> nil then
    begin
      QueensList[i].Destroy;
      QueensList[i] := nil;
    end;
  end;

  for i := 1 to High(DeskNotation) do
    if DeskNotation[i] <> nil then
    begin
      DeskNotation[i].Destroy;
      DeskNotation[i] := nil;
    end;

  FindListStart(ListOfUsersSolutions);
  while (ListOfUsersSolutions <> nil)  do
  begin
    if (ListOfUsersSolutions^.PtOnNext <> nil)  then
    begin
      ListOfUsersSolutions := ListOfUsersSolutions^.PtOnNext;
      Dispose(ListOfUsersSolutions^.PtOnPred);
    end
    else
      begin
        Dispose(ListOfUsersSolutions);
        ListOfUsersSolutions := nil;
      end;
  end;

  //Find solutions
  CountOfFindingSolutions := 0;
  FindSolutions(NumberOfQueens, ListOfUsersSolutions, CountTotalSolutions);
  FindListStart(ListOfUsersSolutions);

  //Clear users moves
  while UsersMoves <> nil do
    DeleteElementOfMovesStack(UsersMoves);

  DrawDesk;
  DrawNotation(DeskNotation);
  DrawQueens(QueensList);
  imgDesk.Visible := True;
  DrawQueensDemontr;
end;

procedure TfrmPlay.DrawQueensDemontr;
var i, tmpY:Integer;
begin
  if ListOfUsersSolutions <> nil then
  begin
    Inc(CountOfFindingSolutions);
    mmoMoves.Clear;
    for i:=1 to NumberOfQueens do
    begin
      TmpY := ListOfUsersSolutions^.QueensPosition[i-1];

      mmoMoves.Lines.Add(IntToStr(i)+'. Q'+chr(TmpY+ord('a'))+IntToStr(i));

      TmpY:= TmpY*CellSize;
      QueensList[i].Left := imgDesk.Left + TmpY + Round(0.05*CellSize);
      QueensList[i].Top := imgDesk.Top + (NumberOfQueens-i)*CellSize + Round(0.05*CellSize);
      QueensList[i].Invalidate;
    end;
    RecProgres;
    ListOfUsersSolutions := ListOfUsersSolutions^.PtOnPred;
    tmrTimePlay.Enabled := True;
  end
  else
    btnReply.Visible := true;

end;

procedure TfrmPlay.btnAcceptClick(Sender: TObject);
var s:string;
    Num, Error:Integer;
begin
  s := edtHerzChoose.Text;
  Val(S, Num, Error);
  if Error = 0 then
    if Num>=100 then
      tmrTimePlay.Interval := Num
    else
    begin
      tmrTimePlay.Interval := 100;
      ShowMessage('Нельзя устанавливать частоту ниже, чем 100 мс');
    end
  else
    ShowMessage('Недопустимые данные');
end;

procedure TfrmPlay.btnReplyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  btnReply.Visible := false;
  FindListStart(ListOfUsersSolutions);
  CountOfFindingSolutions := 0;
  StartDemonstrationMode;
end;

procedure TfrmPlay.btnStop_StartMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if btnStop_Start.Caption = 'Остановить' then
  begin
    tmrTimePlay.Enabled := false;
    btnStop_Start.Caption := 'Продолжить';
  end
  else
    begin
      tmrTimePlay.Enabled := True;
      btnStop_Start.Caption := 'Остановить';
    end;
end;

procedure TfrmPlay.mniGameClick(Sender: TObject);
begin
  if IsItInGame then
    mniSave.Enabled := True
  else
    mniSave.Enabled := False;
end;

procedure TfrmPlay.mniHelpClick(Sender: TObject);
var WndwAbout: TfrmHelp;
begin
  WndwAbout := TfrmHelp.Create(Self);
  WndwAbout.Visible := True;
end;

procedure TfrmPlay.WriteRecords;
var AFile: TextFile;
    Time: integer;
    s:string;
begin
  AssignFile(AFile, 'Records.txt');
  if not FileExists('Records.txt') then
    Rewrite(AFile)
  else
    Append(AFile);

  s := 'Время – ';
  Time := TimeFromStart div 7200;
  if Time < 10 then
    s:= s + '0';
  s := s +IntToStr(Time)+':';

  Time := (TimeFromStart div 120) mod 60;
  if Time < 10 then
    s:= s + '0';
  s := s + IntToStr(Time)+':';

  Time := (TimeFromStart div 2) mod 60;
  if Time < 10 then
    s:= s + '0';
  s := s + IntToStr(Time);

  Writeln(AFile, s);
  s := 'Количество ферзей: ' + IntToStr(NumberOfQueens);
  Writeln (AFile, s);
  s := '----------------------';
  Writeln (AFile, S);
  CloseFile(AFile);
end;

end.
