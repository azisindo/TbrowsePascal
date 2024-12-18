program pointerex;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes ,crt ,SysUtils
  { you can add units after this };

type
  PRow = ^TRow;
  TRow = record
    Data: string;
    Next: PRow;
  end;

var
  FirstRow, CurrentRow, TempRow: PRow;
  i: Integer;
  Key: Char;

procedure AddRow(var Head: PRow; const AData: string);
var
  NewRow: PRow;
begin
  New(NewRow);
  NewRow^.Data := AData;
  NewRow^.Next := nil;

  if Head = nil then
    Head := NewRow
  else
  begin
    TempRow := Head;
    while TempRow^.Next <> nil do
      TempRow := TempRow^.Next;
    TempRow^.Next := NewRow;
  end;
end;

procedure DisplayRows(StartRow: PRow; MaxRows: Integer);
var
  Count: Integer;
begin
  ClrScr;
  TempRow := StartRow;
  Count := 0;
  while (TempRow <> nil) and (Count < MaxRows) do
  begin
    WriteLn(TempRow^.Data);
    TempRow := TempRow^.Next;
    Inc(Count);
  end;
end;

begin
  // Menambahkan data ke dalam list
  for i := 1 to 10 do
  begin
    AddRow(FirstRow, 'Data Baris ke-' + IntToStr(i));
  end;

  CurrentRow := FirstRow;
  repeat
    DisplayRows(CurrentRow, 5);  // Menampilkan 5 baris per halaman
    WriteLn;
    WriteLn('Tekan [N] untuk Next, [Q] untuk Keluar');
    Key := ReadKey;
    if (Key = 'n') or (Key = 'N') then
    begin
      if CurrentRow <> nil then
      begin
        for i := 1 to 5 do  // Pindah 5 baris ke bawah
        begin
          if CurrentRow^.Next <> nil then
            CurrentRow := CurrentRow^.Next;
        end;
      end;
    end;
  until (Key = 'q') or (Key = 'Q');

  // Membersihkan memori
  while FirstRow <> nil do
  begin
    TempRow := FirstRow;
    FirstRow := FirstRow^.Next;
    Dispose(TempRow);
  end;


end.

