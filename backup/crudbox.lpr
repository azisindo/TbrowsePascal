program crudbox;

{$mode objfpc}{$H+}

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, crt, SysUtils
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
  FirstDetail, TempDetail, PrevDetail: PDetail;
  KodeBarang, NamaBarang: string;
  Qty: Integer;
  Harga: Double;
  Key: Char;
  RowPosition: Integer = 6;  // Posisi awal untuk menampilkan data
  CurrentPage: Integer = 1;  // Halaman saat ini
  RowsPerPage: Integer = 3;  // Jumlah baris per halaman
  TotalRows: Integer = 0;    // Jumlah total baris

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

  // Update TotalRows setelah menambahkan data
  Inc(TotalRows);
end;

// Prosedur untuk menampilkan satu detail barang
procedure DisplayDetail(AData: PDetail);
begin
  GotoXY(2, RowPosition);
  WriteLn(Format('| %-10s | %-20s | %-7d | %-10.2f | %-10.2f |',
    [AData^.KodeBarang, AData^.NamaBarang, AData^.Qty, AData^.Harga, AData^.Total]));
  Inc(RowPosition);  // Pindah ke baris berikutnya untuk data selanjutnya
end;

// Prosedur untuk menampilkan header tabel dengan box
procedure DisplayHeader;
begin
  ClrScr;
  RowPosition := 6;

  // Menampilkan box untuk header
  GotoXY(1, 2);
  WriteLn('+------------+----------------------+---------+------------+------------+');
  WriteLn('| Kode      | Nama Barang          | Qty     | Harga      | Total      |');
  WriteLn('+------------+----------------------+---------+------------+------------+');
end;

// Prosedur untuk menampilkan semua detail barang dengan halaman
procedure DisplayDetailsPage(Page: Integer);
var
  TempIndex, i: Integer;
  TempDetail: PDetail;
begin
  TempDetail := FirstDetail;
  TempIndex := 1;

  // Menampilkan halaman yang sesuai
  while (TempDetail <> nil) and (TempIndex <= (Page * RowsPerPage)) do
  begin
    if (TempIndex > ((Page - 1) * RowsPerPage)) then
      DisplayDetail(TempDetail);
    TempDetail := TempDetail^.Next;
    Inc(TempIndex);
  end;
end;

// Prosedur untuk menginput detail barang secara berurutan
procedure InputDetail;
begin
  GotoXY(2, RowPosition + 2);
  Write('Masukkan Kode Barang  : '); ReadLn(KodeBarang);
  GotoXY(2, RowPosition + 3);
  Write('Masukkan Nama Barang  : '); ReadLn(NamaBarang);
  GotoXY(2, RowPosition + 4);
  Write('Masukkan Qty          : '); ReadLn(Qty);
  GotoXY(2, RowPosition + 5);
  Write('Masukkan Harga Satuan : '); ReadLn(Harga);

  // Menambahkan barang ke dalam list
  AddDetail(KodeBarang, NamaBarang, Qty, Harga);

  // Tampilkan data terakhir yang baru ditambahkan
  TempDetail := FirstDetail;
  while TempDetail^.Next <> nil do
    TempDetail := TempDetail^.Next;
  DisplayDetail(TempDetail);

  // Bersihkan input area untuk input barang berikutnya
  GotoXY(2, RowPosition + 2);
  ClrEol;  // Hapus kode barang
  GotoXY(2, RowPosition + 3);
  ClrEol;  // Hapus nama barang
  GotoXY(2, RowPosition + 4);
  ClrEol;  // Hapus qty
  GotoXY(2, RowPosition + 5);
  ClrEol;  // Hapus harga
end;

// Prosedur untuk mengedit detail barang
procedure EditDetail;
var
  EditIndex, i: Integer;
  TempIndex: Integer;
begin
  GotoXY(2, RowPosition + 2);
  WriteLn('Masukkan nomor baris yang ingin diedit (1, 2, 3, ...): ');
  ReadLn(EditIndex);

  TempDetail := FirstDetail;
  TempIndex := 1;

  // Menelusuri list sampai baris yang dipilih
  while (TempDetail <> nil) and (TempIndex < EditIndex) do
  begin
    TempDetail := TempDetail^.Next;
    Inc(TempIndex);
  end;

  if TempDetail <> nil then
  begin
    // Menampilkan data lama sebelum diedit
    GotoXY(2, RowPosition + 2);
    WriteLn('Data Lama:');
    WriteLn(Format('Kode Barang : %s', [TempDetail^.KodeBarang]));
    WriteLn(Format('Nama Barang : %s', [TempDetail^.NamaBarang]));
    WriteLn(Format('Qty         : %d', [TempDetail^.Qty]));
    WriteLn(Format('Harga       : %.2f', [TempDetail^.Harga]));
    WriteLn(Format('Total       : %.2f', [TempDetail^.Total]));

    // Input ulang untuk edit data
    GotoXY(2, RowPosition + 7);
    Write('Masukkan Kode Barang  : '); ReadLn(KodeBarang);
    GotoXY(2, RowPosition + 8);
    Write('Masukkan Nama Barang  : '); ReadLn(NamaBarang);
    GotoXY(2, RowPosition + 9);
    Write('Masukkan Qty          : '); ReadLn(Qty);
    GotoXY(2, RowPosition + 10);
    Write('Masukkan Harga Satuan : '); ReadLn(Harga);

    // Perbarui detail barang yang telah dipilih
    TempDetail^.KodeBarang := KodeBarang;
    TempDetail^.NamaBarang := NamaBarang;
    TempDetail^.Qty := Qty;
    TempDetail^.Harga := Harga;
    TempDetail^.Total := Qty * Harga;

    // Tampilkan kembali detail barang yang telah diperbarui
    DisplayHeader;
    TempDetail := FirstDetail;
    while TempDetail <> nil do
    begin
      DisplayDetail(TempDetail);
      TempDetail := TempDetail^.Next;
    end;
  end
  else
  begin
    GotoXY(2, RowPosition + 2);
    WriteLn('Data tidak ditemukan!');
    ReadLn;
  end;
end;

// Prosedur untuk menghapus detail barang
procedure DeleteDetail;
var
  DeleteIndex, i: Integer;
  TempIndex: Integer;
begin
  GotoXY(2, RowPosition + 2);
  WriteLn('Masukkan nomor baris yang ingin dihapus (1, 2, 3, ...): ');
  ReadLn(DeleteIndex);

  TempDetail := FirstDetail;
  PrevDetail := nil;
  TempIndex := 1;

  // Menelusuri list sampai baris yang dipilih
  while (TempDetail <> nil) and (TempIndex < DeleteIndex) do
  begin
    PrevDetail := TempDetail;
    TempDetail := TempDetail^.Next;
    Inc(TempIndex);
  end;

  if TempDetail <> nil then
  begin
    // Menghapus baris yang dipilih
    if PrevDetail = nil then
      FirstDetail := TempDetail^.Next  // Menghapus data pertama
    else
      PrevDetail^.Next := TempDetail^.Next;  // Menghapus data tengah/akhir

    Dispose(TempDetail);  // Bebaskan memori

    // Menampilkan kembali data setelah penghapusan
    DisplayHeader;
    TempDetail := FirstDetail;
    while TempDetail <> nil do
    begin
      DisplayDetail(TempDetail);
      TempDetail := TempDetail^.Next;
    end;
  end
  else
  begin
    GotoXY(2, RowPosition + 2);
    WriteLn('Data tidak ditemukan!');
    ReadLn;
  end;
end;

// Prosedur untuk melakukan scroll halaman
procedure ScrollPage;
begin
  // Memeriksa apakah kita sudah berada di halaman terakhir
  if CurrentPage * RowsPerPage >= TotalRows then
    CurrentPage := 1  // Jika sudah di halaman terakhir, kembali ke halaman pertama
  else
    Inc(CurrentPage);  // Jika belum, pindah ke halaman berikutnya
end;

begin
  FirstDetail := nil; // Inisialisasi linked list kosong
  TotalRows := 0; // Menginisialisasi jumlah baris

  DisplayHeader; // Tampilkan header di awal

  repeat
    DisplayHeader;
    DisplayDetailsPage(CurrentPage);  // Menampilkan data per halaman

    // Tampilkan pilihan untuk input, edit, atau hapus
    GotoXY(1, RowPosition + 1);
    Write('Tekan [A] untuk Tambah Data, [E] untuk Edit Data, [D] untuk Hapus Data, [S] untuk Lanjutkan Scroll, [Q] untuk Keluar: ');
    Key := ReadKey;

    case Key of
      'a', 'A': InputDetail;  // Input data baru
      'e', 'E': EditDetail;   // Edit data
      'd', 'D': DeleteDetail; // Hapus data
      's', 'S': ScrollPage;   // Scroll halaman
    end;

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

