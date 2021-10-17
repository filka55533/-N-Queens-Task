Unit QueenTaskModel;

interface

Type
	//������� ��� ������������� ������������ ������ �� �����
	TArrEvail=array of Boolean;
  TArrQueens= array of Integer;

  //����, ������������ ��� ������ �������
  TPtStackOfAvail=^TStackOfAvail;
  TStackOfAvail = record
		CheckDiagDown,
    CheckDiagUp,
    CheckVertical:TArrEvail;
		PtOnNext:TPtStackOfAvail;
  end;

  //������ ������������ �������
  TPtListOfSolutions=^TListOfSolutions;
  TListOfSolutions = record
  	QueensPosition: TArrQueens;
    FoundSolution: Boolean;
    PtOnPred, PtOnNext: TPtListOfSolutions;
  end;

  TMode = (GameMode, FindWords);



//--------------------------------------------------------------------------------------------
//������ �������� �����������
//��������� ����� �������� �����
Procedure InputSizeChessDesk (var Size:Integer);

//��������� ��������� �������� ��������
Procedure SetSizeDesk (const Size:Integer;
					             var ACheckDiagDown, ACheckDiagUp, ACheckVertical:TArrEvail;
                       var AQuensPosition:TArrQueens);

//��������� ��� ������ �� ������
Procedure CreateElementStack (var APtHeadStack:TPtStackOfAvail);

Procedure DeleteElementStack (var APtStack:TPtStackOfAvail);

//��������� ��� ������ �� �������
Procedure CreateElementList (var APtList: TPtListOfSolutions);

Procedure DeleteElementList (var APtList: TPtListOfSolutions);

//��������� ������ �������
Procedure OutputOfSolutions (PtList:TPtListOfSolutions);

//��������� ������ �������
Procedure FindSolutions (const Size:integer; var PntListSolut:TPtListOfSolutions; var ACntSolut:integer);

//������� ������ ������ ������
Function FindListStart (APtOnList:TPtListOfSolutions):TPtListOfSolutions;

//��������� ������ ������
Procedure ChooseMode (var AMode:TMode);

//Compare solutions
function ItIsNewSolution (ListSol:TPtListOfSolutions; var ADesk:TArrQueens):boolean;

implementation

	//��������� ����� �������� �����
  Procedure InputSizeChessDesk (var Size:Integer);
  Var s:string;
      Error:Integer;
  Begin
    writeln ('������� ����� ��������� �����:');

    Repeat
      readln (s);
      val (s,Size,Error);
      if Error<>0 then
      	writeln('������! ��������� ������������ �������� ������!')
      else
      	if (Size<=4) or (Size>=20) then
        begin
        	writeln ('������! ������� ����� ������� � �������� ���������!');
          Error:=1;
        end;

    Until Error=0;
  End;

  //��������� ��������� �������� ��������
	Procedure SetSizeDesk (const Size:Integer;
					       	       var ACheckDiagDown, ACheckDiagUp, ACheckVertical:TArrEvail;
                  	     var AQuensPosition:TArrQueens);
  Var i:Integer;
  Begin
  	//������������� ��������-���������
    SetLength (ACheckDiagDown,2*Size-1);

    for i := Low(ACheckDiagDown) to High(ACheckDiagDown) do
    	ACheckDiagDown[i]:=True;

    ACheckDiagUp:=Copy(ACheckDiagDown);

    SetLength(ACheckVertical, Size);
    for i := Low(ACheckVertical) to High(ACheckVertical) do
			ACheckVertical[i]:=True;


    //������������� ������� ������������ ������
    SetLength(AQuensPosition,Size);
    for i := Low(AQuensPosition) to High(AQuensPosition) do
    	AQuensPosition[i] := -1;
  End;


	//��������� �������� �������� �����
	Procedure CreateElementStack (var APtHeadStack:TPtStackOfAvail);
  Var TempPoint:TPtStackOfAvail;
  Begin
		New(TempPoint);
    TempPoint^.PtOnNext:=APtHeadStack;
    APtHeadStack:=TempPoint;
  End;

  //��������� �������� �������� �� ������� �����
  Procedure DeleteElementStack (var APtStack:TPtStackOfAvail);
  Var TempPoint:TPtStackOfAvail;
  Begin
    if APtStack<>nil then
    begin
    	TempPoint:=APtStack^.PtOnNext;
      Dispose(APtStack);
      APtStack:=TempPoint;
    end;
  End;

	//��������� ��� �������� �������� � ������ � ����������� �������
  Procedure CreateElementList (var APtList: TPtListOfSolutions);
	Var TempPoint:TPtListOfSolutions;
  Begin
    New(TempPoint);
    if APtList<>nil then
    begin
    	TempPoint^.PtOnNext:=APtList^.PtOnNext ;

      if TempPoint^.PtOnNext <> nil then
    		TempPoint^.PtOnNext^.PtOnPred:=TempPoint;

    	TempPoint^.PtOnPred:=APtList;
    	APtList^.PtOnNext:=TempPoint;
    	APtList:=TempPoint;
    end
    else
    begin
      TempPoint^.PtOnPred := nil;
      TempPoint^.PtOnNext := nil;
      APtList := TempPoint;
    end;
    APtList^.FoundSolution := false;
  End;

  //��������� �������� �������� �� ������
  Procedure DeleteElementList (var APtList: TPtListOfSolutions);
  Var TempPoint:TPtListOfSolutions;
      IsItNil:Boolean;
  Begin
    if APtList <> nil then
    begin
      TempPoint := APtList;

			//�������� ��������� �������� ������ � ������ ������
      if APtList^.PtOnPred <> nil then
      begin
      	APtList := APtList^.PtOnPred;
        IsItNil := false;
      end
      else
      begin
				APtList := APtList^.PtOnNext;
        IsItNil := true;
      end;

      if APtList <> nil then
        if IsItNil then
      		APtList^.PtOnPred := nil
        else
        begin
          APtList^.PtOnNext := TempPoint^.PtOnNext;
          if TempPoint^.PtOnNext <> nil then
          	TempPoint^.PtOnNext^.PtOnPred := APtList;
        end;

      Dispose(TempPoint);
    end;
  End;

  //��������� ������ �������
	Procedure OutputOfSolutions (PtList:TPtListOfSolutions);
  Var Count,i, j:Integer;
  Begin
    PtList := FindListStart(PtList);
  	Count:=1;

  	while PtList<>nil do
    begin
    	Writeln(Count,'-�� ������� ������:');
  		for i := High(PtList^.QueensPosition) downto Low(PtList^.QueensPosition) do
      begin
      	for j := Low(PtList^.QueensPosition) to High(PtList^.QueensPosition) do
        	if PtList^.QueensPosition[i] = j then
          	write ('1':3)
          else
          	write ('0':3);
        writeln;
      end;
      PtList := PtList^.PtOnNext;
			Inc(Count);
    end;

  End;

  //��������� ������ �������
	Procedure FindSolutions (const Size:integer; var PntListSolut:TPtListOfSolutions; var ACntSolut:integer);
  Var PointOnStack: TPtStackOfAvail;
  		ParamOfQueens: integer;       //������� ��� �������� �� ������� �������
      Queens: TArrQueens;              //������ ������������ ������
      fl:Boolean;

  Begin
    PointOnStack := nil;
    //��������� ��������� �������� �������� � �������� �����
    CreateElementStack(PointOnStack);
		SetSizeDesk(Size,PointOnStack^.CheckDiagDown,PointOnStack^.CheckDiagUp,PointOnStack^.CheckVertical, Queens);
    ACntSolut := 0;

		//�������� ������ �������
    PntListSolut := nil;
 		ParamOfQueens := 0;
		Repeat
      if (Queens[ParamOfQueens]<>High(Queens)) then
      begin
      	Inc(Queens[ParamOfQueens]);

        //�������� ������� ������ ������ �� ������ ���������
        fl := PointOnStack^.CheckDiagDown[ParamOfQueens-Queens[ParamOfQueens]+Size-1];

				//�������� ������� ������ ������ �� ������� ���������
      	fl := fl and PointOnStack^.CheckDiagUp[ParamOfQueens+Queens[ParamOfQueens]];

        //�������� ������� ������� ������ ������ �� ���������
        fl := fl and PointOnStack^.CheckVertical[Queens[ParamOfQueens]];

        if fl then
        begin
          if ParamOfQueens<High(Queens) then
  				begin

            //�������� ������ �������� � �����. �������� �������� ��� ��� ����������� ������
          	CreateElementStack(PointOnStack);
          	PointOnStack^.CheckDiagDown :=  Copy(PointOnStack^.PtOnNext^.CheckDiagDown);
          	PointOnStack^.CheckDiagUp := Copy(PointOnStack^.PtOnNext^.CheckDiagUp);
          	PointOnStack^.CheckVertical := Copy(PointOnStack^.PtOnNext^.CheckVertical);

            //������� ������� ���������� � ����������
 	   	    	PointOnStack^.CheckDiagDown[ParamOfQueens-Queens[ParamOfQueens]+Size-1] := false;
  	       	PointOnStack^.CheckDiagUp[ParamOfQueens+Queens[ParamOfQueens]] := false;
      	  	PointOnStack^.CheckVertical[Queens[ParamOfQueens]] := false;

            //������������� ��� ������ ������������ ���������� �����
            inc(ParamOfQueens);
          end
          else
          	begin
              CreateElementList(PntListSolut);
              PntListSolut^.QueensPosition := Copy(Queens);
              Inc(ACntSolut);
            end;

        end;
      end
      else
      begin
      	Queens[ParamOfQueens] := -1;
        DeleteElementStack(PointOnStack);
        Dec(ParamOfQueens);
      end;

    until PointOnStack = nil;
  End;

  //������� ������ ������ ������
	Function FindListStart (APtOnList:TPtListOfSolutions):TPtListOfSolutions;
	Begin
    if APtOnList <> nil then
  	while APtOnList^.PtOnPred <> nil do
  		APtOnList := APtOnList^.PtOnPred;

  	Result := APtOnList;
	End;

  //��������� ������ ������ �������������
	Procedure ChooseMode (var AMode:TMode);
  var s:string;
  		Key, ErrorCode:Integer;
	Begin
    repeat
      writeln ('�������� �����. ������� ��:');
    	writeln ('1 - ����� ������ ����������');
    	writeln ('2 - ����� ������ ����������');
    	writeln;

    	readln (s);
      val (s,Key,ErrorCode);
      if ErrorCode = 0 then
      begin
      	case Key of
					1: AMode := FindWords;
          2: AMode := GameMode;
          else
          begin
            writeln ('������! ����� ������� ���� 1-��, ���� 2-�� �����');
            ErrorCode := 1;
          end;
        end;
      end
      else
      	writeln ('������! �� ����� �������� ������');

      writeln;
    until ErrorCode = 0;
   End;


//Compare solutions
function ItIsNewSolution (ListSol:TPtListOfSolutions; var ADesk:TArrQueens):boolean;    {$Optimization off}
var APointer:TPtListOfSolutions;
    fl:boolean;
    Equal:boolean;
    i: integer;
begin
  APointer := ListSol;
  fl := true;
  while fl and (APointer <> nil) do
  begin
    i := Low(ADesk);
    Equal := True;
    while Equal and (i <= High(Adesk)) do
    if APointer^.QueensPosition[i] = ADesk[i] then
      Inc(i)
    else
      Equal := not Equal;

    if Equal then
    begin
      if APointer^.FoundSolution =False then
      begin
        APointer^.FoundSolution := true;
        Result := True;
      end
      else
        Result := False;

      fl := false;
    end
    else
      APointer := APointer^.PtOnPred;
  end;

end;

end.
