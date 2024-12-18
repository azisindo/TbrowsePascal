program detailcrud;

{$mode objfpc}{$H+}

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
  GotoXY(1, RowPosition + 3);
  Write('Masukkan Nama Barang  : '); ReadLn(NamaBarang);
  GotoXY(1, RowPosition + 4);
  Write('Masukkan Qty          : '); ReadLn(Qty);
  GotoXY(1, RowPosition + 5);
  Write('Masukkan Harga Satuan : '); ReadLn(Harga);

  // Menambahkan barang ke dalam list
  AddDetail(KodeBarang, NamaBarang, Qty, Harga);

  // Tampilkan data terakhir yang baru ditambahkan
  TempDetail := FirstDetail;
  while TempDetail^.Next <> nil do
    TempDetail := TempDetail^.Next;
  DisplayDetail(TempDetail);

  // Bersihkan input area untuk input barang berikutnya
  GotoXY(1, RowPosition + 2);
  ClrEol;  // Hapus kode barang
  GotoXY(1, RowPosition + 3);
  ClrEol;  // Hapus nama barang
  GotoXY(1, RowPosition + 4);
  ClrEol;  // Hapus qty
  GotoXY(1, RowPosition + 5);
  ClrEol;  // Hapus harga
end;

// Prosedur untuk mengedit detail barang
procedure EditDetail;
var
  EditIndex, i: Integer;
  TempIndex: Integer;
begin
  GotoXY(1, RowPosition + 2);
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
    GotoXY(1, RowPosition + 2);
    WriteLn('Data Lama:');
    WriteLn(Format('Kode Barang : %s', [TempDetail^.KodeBarang]));
    WriteLn(Format('Nama Barang : %s', [TempDetail^.NamaBarang]));
    WriteLn(Format('Qty         : %d', [TempDetail^.Qty]));
    WriteLn(Format('Harga       : %.2f', [TempDetail^.Harga]));
    WriteLn(Format('Total       : %.2f', [TempDetail^.Total]));

    // Input ulang untuk edit data
    GotoXY(1, RowPosition + 7);
    Write('Masukkan Kode Barang  : '); ReadLn(KodeBarang);
    GotoXY(1, RowPosition + 8);
    Write('Masukkan Nama Barang  : '); ReadLn(NamaBarang);
    GotoXY(1, RowPosition + 9);
    Write('Masukkan Qty          : '); ReadLn(Qty);
    GotoXY(1, RowPosition + 10);
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
    GotoXY(1, RowPosition + 2);
    WriteLn('Data tidak ditemukan!');
    ReadLn;
  end;
end;

begin
  FirstDetail := nil; // Inisialisasi linked list kosong

  DisplayHeader; // Tampilkan header di awal

  repeat
    DisplayHeader;
    TempDetail := FirstDetail;
    while TempDetail <> nil do
    begin
      DisplayDetail(TempDetail);
      TempDetail := TempDetail^.Next;
    end;

    // Tampilkan pilihan untuk input atau edit
    GotoXY(1, RowPosition + 1);
    Write('Tekan [A] untuk Tambah Data, [E] untuk Edit Data, [Q] untuk Keluar: ');
    Key := ReadKey;

    case Key of
      'a', 'A': InputDetail;  // Input data baru
      'e', 'E': EditDetail;   // Edit data
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

