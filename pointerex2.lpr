program pointerex2;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, crt, SysUtils;
  { you can add units after this }

type
  PDetail = ^TDetail;
  TDetail = record
    KodeBarang: string;
    NamaBarang: string;
    Qty: Integer;
    Harga: Double;
    Jumlah: Double;
    Next: PDetail;
  end;

var
  InvoiceNo, InvoiceName: string;
  FirstDetail, CurrentDetail, TempDetail: PDetail;
  i: Integer;
  Key: Char;

// Prosedur untuk menambahkan detail barang
procedure AddDetail(const KodeBarang, NamaBarang: string; Qty: Integer; Harga: Double);
var
  NewDetail: PDetail;
begin
  New(NewDetail);
  NewDetail^.KodeBarang := KodeBarang;
  NewDetail^.NamaBarang := NamaBarang;
  NewDetail^.Qty := Qty;
  NewDetail^.Harga := Harga;
  NewDetail^.Jumlah := Qty * Harga;
  NewDetail^.Next := nil;

  if FirstDetail = nil then
    FirstDetail := NewDetail
  else
  begin
    TempDetail := FirstDetail;
    while TempDetail^.Next <> nil do
      TempDetail := TempDetail^.Next;
    TempDetail^.Next := NewDetail;
  end;
end;

// Prosedur untuk menampilkan header invoice dan detail barang
procedure DisplayInvoice;
var
  Count: Integer;
begin
  ClrScr;
  // Tampilkan header invoice
  WriteLn('===============================');
  WriteLn('         DETAIL INVOICE        ');
  WriteLn('===============================');
  WriteLn('Nomor Invoice : ', InvoiceNo);
  WriteLn('Nama Invoice  : ', InvoiceName);
  WriteLn('-------------------------------');
  WriteLn;

  // Tampilkan detail barang
  WriteLn(Format('%-10s %-20s %-5s %-10s %-10s', ['Kode', 'Nama Barang', 'Qty', 'Harga', 'Jumlah']));
  WriteLn('--------------------------------------------------------------');

  TempDetail := FirstDetail;
  Count := 0;

  while TempDetail <> nil do
  begin
    WriteLn(Format('%-10s %-20s %-5d %-10.2f %-10.2f',
      [TempDetail^.KodeBarang, TempDetail^.NamaBarang, TempDetail^.Qty, TempDetail^.Harga, TempDetail^.Jumlah]));
    TempDetail := TempDetail^.Next;
    Inc(Count);
  end;

  WriteLn;
  WriteLn('Tekan [N] untuk Next, [Q] untuk Keluar');
end;

begin
  // Input header invoice
  ClrScr;
  Write('Masukkan Nomor Invoice : '); ReadLn(InvoiceNo);
  Write('Masukkan Nama Invoice  : '); ReadLn(InvoiceName);

  // Tambahkan beberapa data detail barang
  AddDetail('BRG001', 'Barang A', 2, 50000);
  AddDetail('BRG002', 'Barang B', 1, 75000);
  AddDetail('BRG003', 'Barang C', 5, 20000);
  AddDetail('BRG004', 'Barang D', 3, 30000);
  AddDetail('BRG005', 'Barang E', 4, 15000);

  CurrentDetail := FirstDetail;
  repeat
    DisplayInvoice;
    Key := ReadKey;
  until (Key = 'q') or (Key = 'Q');

  // Membersihkan memori
  while FirstDetail <> nil do
  begin
    TempDetail := FirstDetail;
    FirstDetail := FirstDetail^.Next;
    Dispose(TempDetail);
  end;
end.

