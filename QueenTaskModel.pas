Unit QueenTaskModel;

interface

Type
	//Массивы для представления расположения ферзей по Вирту
	TArrEvail=array of Boolean;
  TArrQueens= array of Integer;

  //Стек, используемый для поиска решений
  TPtStackOfAvail=^TStackOfAvail;
  TStackOfAvail = record
		CheckDiagDown,
    CheckDiagUp,
    CheckVertical:TArrEvail;
		PtOnNext:TPtStackOfAvail;
  end;

  //Список всевозможных решений
  TPtListOfSolutions=^TListOfSolutions;
  TListOfSolutions = record
  	QueensPosition: TArrQueens;
    FoundSolution: Boolean;
    PtOnPred, PtOnNext: TPtListOfSolutions;
  end;

  TMode = (GameMode, FindWords);



//--------------------------------------------------------------------------------------------
//Раздел описания подпрограмм
//Процедура ввода размеров доски
Procedure InputSizeChessDesk (var Size:Integer);

//Процедура установки размеров массивов
Procedure SetSizeDesk (const Size:Integer;
					             var ACheckDiagDown, ACheckDiagUp, ACheckVertical:TArrEvail;
                       var AQuensPosition:TArrQueens);

//Процедуры для работы со стеком
Procedure CreateElementStack (var APtHeadStack:TPtStackOfAvail);

Procedure DeleteElementStack (var APtStack:TPtStackOfAvail);

//Процедуры для работы со списком
Procedure CreateElementList (var APtList: TPtListOfSolutions);

Procedure DeleteElementList (var APtList: TPtListOfSolutions);

//Процедура вывода решений
Procedure OutputOfSolutions (PtList:TPtListOfSolutions);

//Процедура поиска решений
Procedure FindSolutions (const Size:integer; var PntListSolut:TPtListOfSolutions; var ACntSolut:integer);

//Функция поиска головы списка
Function FindListStart (APtOnList:TPtListOfSolutions):TPtListOfSolutions;

//Процедура выбора режима
Procedure ChooseMode (var AMode:TMode);

//Compare solutions
function ItIsNewSolution (ListSol:TPtListOfSolutions; var ADesk:TArrQueens):boolean;

implementation

	//Процедура ввода размеров доски
  Procedure InputSizeChessDesk (var Size:Integer);
  Var s:string;
      Error:Integer;
  Begin
    writeln ('Введите длину шахматной доски:');

    Repeat
      readln (s);
      val (s,Size,Error);
      if Error<>0 then
      	writeln('Ошибка! Проверьте корректность вводимых данных!')
      else
      	if (Size<=4) or (Size>=20) then
        begin
        	writeln ('Ошибка! Размеры доски указаны в неверном диапазоне!');
          Error:=1;
        end;

    Until Error=0;
  End;

  //Процедура установки размеров массивов
	Procedure SetSizeDesk (const Size:Integer;
					       	       var ACheckDiagDown, ACheckDiagUp, ACheckVertical:TArrEvail;
                  	     var AQuensPosition:TArrQueens);
  Var i:Integer;
  Begin
  	//Инициализация массивов-признаков
    SetLength (ACheckDiagDown,2*Size-1);

    for i := Low(ACheckDiagDown) to High(ACheckDiagDown) do
    	ACheckDiagDown[i]:=True;

    ACheckDiagUp:=Copy(ACheckDiagDown);

    SetLength(ACheckVertical, Size);
    for i := Low(ACheckVertical) to High(ACheckVertical) do
			ACheckVertical[i]:=True;


    //Инициализация массива расположения ферзей
    SetLength(AQuensPosition,Size);
    for i := Low(AQuensPosition) to High(AQuensPosition) do
    	AQuensPosition[i] := -1;
  End;


	//Процедура создания элемента стека
	Procedure CreateElementStack (var APtHeadStack:TPtStackOfAvail);
  Var TempPoint:TPtStackOfAvail;
  Begin
		New(TempPoint);
    TempPoint^.PtOnNext:=APtHeadStack;
    APtHeadStack:=TempPoint;
  End;

  //Процедура удаления элемента из вершины стека
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

	//Процедура для создания элемента в списке в определённой позиции
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

  //Процедура удаления элемента из списка
  Procedure DeleteElementList (var APtList: TPtListOfSolutions);
  Var TempPoint:TPtListOfSolutions;
      IsItNil:Boolean;
  Begin
    if APtList <> nil then
    begin
      TempPoint := APtList;

			//Проверка вхождения элемента списка в начало списка
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

  //Процедура вывода решений
	Procedure OutputOfSolutions (PtList:TPtListOfSolutions);
  Var Count,i, j:Integer;
  Begin
    PtList := FindListStart(PtList);
  	Count:=1;

  	while PtList<>nil do
    begin
    	Writeln(Count,'-ое решение задачи:');
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

  //Процедура поиска решений
	Procedure FindSolutions (const Size:integer; var PntListSolut:TPtListOfSolutions; var ACntSolut:integer);
  Var PointOnStack: TPtStackOfAvail;
  		ParamOfQueens: integer;       //Счётчик для указаний на элемент массива
      Queens: TArrQueens;              //Массив расположения ферзей
      fl:Boolean;

  Begin
    PointOnStack := nil;
    //Установка начальных размеров массивов и создание стека
    CreateElementStack(PointOnStack);
		SetSizeDesk(Size,PointOnStack^.CheckDiagDown,PointOnStack^.CheckDiagUp,PointOnStack^.CheckVertical, Queens);
    ACntSolut := 0;

		//Создание списка решений
    PntListSolut := nil;
 		ParamOfQueens := 0;
		Repeat
      if (Queens[ParamOfQueens]<>High(Queens)) then
      begin
      	Inc(Queens[ParamOfQueens]);

        //Проверка наличия других ферзей на нижней диагонали
        fl := PointOnStack^.CheckDiagDown[ParamOfQueens-Queens[ParamOfQueens]+Size-1];

				//Проверка наличия других ферзей на верхней диагонали
      	fl := fl and PointOnStack^.CheckDiagUp[ParamOfQueens+Queens[ParamOfQueens]];

        //Проверка условия наличия других ферзей по вертикали
        fl := fl and PointOnStack^.CheckVertical[Queens[ParamOfQueens]];

        if fl then
        begin
          if ParamOfQueens<High(Queens) then
  				begin

            //Создание нового элемента в стеке. Передача массивов как при рекурсивном спуске
          	CreateElementStack(PointOnStack);
          	PointOnStack^.CheckDiagDown :=  Copy(PointOnStack^.PtOnNext^.CheckDiagDown);
          	PointOnStack^.CheckDiagUp := Copy(PointOnStack^.PtOnNext^.CheckDiagUp);
          	PointOnStack^.CheckVertical := Copy(PointOnStack^.PtOnNext^.CheckVertical);

            //Пометка занятых вертикалей и диагоналей
 	   	    	PointOnStack^.CheckDiagDown[ParamOfQueens-Queens[ParamOfQueens]+Size-1] := false;
  	       	PointOnStack^.CheckDiagUp[ParamOfQueens+Queens[ParamOfQueens]] := false;
      	  	PointOnStack^.CheckVertical[Queens[ParamOfQueens]] := false;

            //Инициализация для поиска расположения следующего ферзя
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

  //Функция поиска головы списка
	Function FindListStart (APtOnList:TPtListOfSolutions):TPtListOfSolutions;
	Begin
    if APtOnList <> nil then
  	while APtOnList^.PtOnPred <> nil do
  		APtOnList := APtOnList^.PtOnPred;

  	Result := APtOnList;
	End;

  //Процедура выбора режима пользователем
	Procedure ChooseMode (var AMode:TMode);
  var s:string;
  		Key, ErrorCode:Integer;
	Begin
    repeat
      writeln ('Выберите режим. Нажмите на:');
    	writeln ('1 - режим вывода комбинаций');
    	writeln ('2 - режим поиска комбинаций');
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
            writeln ('Ошибка! Нужно выбрать либо 1-ый, либо 2-ой режим');
            ErrorCode := 1;
          end;
        end;
      end
      else
      	writeln ('Ошибка! Вы ввели неверные данные');

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
