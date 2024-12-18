program detailbarang;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes,crt, SysUtils
  { you can add units after this };

type
  PDetail = ^TDetail;
  TDetail = record
    KodeBarang: string;
    NamaBarang: string;
    Qty: Integer;
    Harga: Double;
    Total: Double;
    Next: PDetail;
  end;

var
  FirstDetail, TempDetail: PDetail;
  KodeBarang, NamaBarang: string;
  Qty: Integer;
  Harga: Double;
  Key: Char;
  RowPosition: Integer = 6;  // Posisi awal untuk menampilkan data

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
  NewDetail^.Total := Qty * Harga;
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

// Prosedur untuk menampilkan satu detail barang
procedure DisplayDetail(AData: PDetail);
begin
  GotoXY(1, RowPosition);
  WriteLn(Format('%-10s %-20s %-7d %-10.2f %-10.2f',
    [AData^.KodeBarang, AData^.NamaBarang, AData^.Qty, AData^.Harga, AData^.Total]));
  Inc(RowPosition);  // Pindah ke baris berikutnya untuk data selanjutnya
end;

// Prosedur untuk menampilkan header tabel
procedure DisplayHeader;
begin
  ClrScr;
  RowPosition := 6;
  GotoXY(1, 2);
  WriteLn('=======================================================================');
  WriteLn('               DETAIL BARANG YANG DIINPUT                              ');
  WriteLn('=======================================================================');
  WriteLn(Format('%-10s %-20s %-7s %-10s %-10s', ['Kode', 'Nama Barang', 'Qty', 'Harga', 'Total']));
  WriteLn('-----------------------------------------------------------------------');
end;

// Prosedur untuk menginput detail barang secara berurutan
procedure InputDetail;
begin
  GotoXY(1, RowPosition + 2);
  Write('Masukkan Kode Barang  : '); ReadLn(KodeBarang);
  Write('Masukkan Nama Barang  : '); ReadLn(NamaBarang);
  Write('Masukkan Qty          : '); ReadLn(Qty);
  Write('Masukkan Harga Satuan : '); ReadLn(Harga);
  AddDetail(KodeBarang, NamaBarang, Qty, Harga);

  // Tampilkan data terakhir yang baru ditambahkan
  TempDetail := FirstDetail;
  while TempDetail^.Next <> nil do
    TempDetail := TempDetail^.Next;
  DisplayDetail(TempDetail);
end;

begin
  FirstDetail := nil; // Inisialisasi linked list kosong

  DisplayHeader; // Tampilkan header di awal

  repeat
    InputDetail;          // Input data barang

    // Tampilkan pesan navigasi di bawah data terakhir
    GotoXY(1, RowPosition + 1);
    Write('Tekan [A] untuk Tambah Data, [Q] untuk Keluar: ');
    Key := ReadKey;

    // Hapus pesan sebelumnya agar tidak menumpuk
    GotoXY(1, RowPosition + 1);
    ClrEol; // Menghapus teks di baris ini

  until (Key = 'q') or (Key = 'Q');

  // Membersihkan memori
  while FirstDetail <> nil do
  begin
    TempDetail := FirstDetail;
    FirstDetail := FirstDetail^.Next;
    Dispose(TempDetail);
  end;

  GotoXY(1, RowPosition + 4);
  WriteLn('Program selesai. Tekan Enter untuk keluar...');
  ReadLn;

end.

