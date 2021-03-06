unit uWorkWithDeskStatement;

interface

Type
  //??????? ??? ????????????? ???????????? ?????? ?? ?????
	TArrEvailDiag = array [1..2*13-1] of Boolean;
  TArrEvailVert = array [1..13] of Boolean;
  TArrQueensStatic = array [1..13] of Integer;

  //??????, ???????????? ??? ?????? ???????
  TCellsAvail = record
		CheckDiagDown,
    CheckDiagUp: TArrEvailDiag;
    CheckHorizontal,
    CheckVertical:TArrEvailVert;
  end;

//Procedure of marking Desk
procedure MarkDesk (var ADesk:TCellsAvail; const VertInd, HorInd, ANumOfQueens:integer);

//Dismark desk
procedure DismarkDesk (var ADesk:TCellsAvail; const VertInd, HorInd, ANumOfQueens:integer);

//Initialization
procedure InitDesk (var ADesk:TCellsAvail);

//Checks marker of position
function CheckMark (const ADesk:TCellsAvail; const AHor, AVert, ANumOfQueens:integer):boolean;

//Check correct position


implementation


//Procedure of marking Desk
procedure MarkDesk (var ADesk:TCellsAvail; const VertInd, HorInd, ANumOfQueens:integer);
begin
  ADesk.CheckDiagUp[VertInd-HorInd+ANumOfQueens] := False;
  ADesk.CheckDiagDown[VertInd+HorInd-1] := False;
  ADesk.CheckVertical[VertInd] := False;
  ADesk.CheckHorizontal[HorInd] := False;
end;

//Dismark desk
procedure DismarkDesk (var ADesk:TCellsAvail; const VertInd, HorInd, ANumOfQueens:integer);
begin
  ADesk.CheckDiagUp[VertInd-HorInd+ANumOfQueens] := True;
  ADesk.CheckDiagDown[VertInd+HorInd-1] := True;
  ADesk.CheckVertical[VertInd] := True;
  ADesk.CheckHorizontal[HorInd] := True;

end;

//Initialization
procedure InitDesk (var ADesk:TCellsAvail);
var i:Integer;
begin
  for i := Low(ADesk.CheckDiagUp) to High(ADesk.CheckDiagUp) do
  begin
    ADesk.CheckDiagDown[i] := True;
    ADesk.CheckDiagUp[i] := True;
  end;

  for i := Low(ADesk.CheckVertical) to High(ADesk.CheckVertical) do
  begin
    ADesk.CheckVertical[i] := True;
    ADesk.CheckHorizontal[i] := True;
  end;
end;

//Checks marker of position                                                                    
function CheckMark (const ADesk:TCellsAvail; const AHor, AVert, ANumOfQueens:integer):boolean;
begin
  Result := not (ADesk.CheckDiagUp[AVert-AHor+ANumOfQueens] and
            ADesk.CheckDiagDown[AHor+AVert-1] and
            ADesk.CheckHorizontal[AHor] and ADesk.CheckVertical[AVert]);

end;

end.
