unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.ExtCtrls,Jpeg;

type
  TfMain = class(TForm)
    btnGetPhoto: TButton;
    ADOQuery1: TADOQuery;
    btnTest: TButton;
    Image1: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    Edit4: TEdit;
    Label3: TLabel;
    Edit5: TEdit;
    Label4: TLabel;
    Edit6: TEdit;
    Label5: TLabel;
    Button1: TButton;
    procedure btnGetPhotoClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    q_exec_count: integer;
  end;
  TMyThread = class(TThread)
  private
    { Private declarations }
  protected
    guid: string;
    luna_id: string;
    dir: string;
    folder: string;
    procedure Execute; override;
  end;

  TOrbThread = class(TThread)
  private
    { Private declarations }
  protected
    count_que: integer;
    procedure Execute; override;
  end;

var
  fMain: TfMain;
  MyThread: TMyThread;
  OrbThread: TOrbThread;

implementation

{$R *.dfm}

procedure TfMain.btnGetPhotoClick(Sender: TObject);
begin
  btnGetPhoto.Enabled:=false;
  OrbThread:=TOrbThread.Create(True);
  OrbThread.Priority:=tpNormal;
  OrbThread.Resume;
end;

{ TMyThread }

procedure TMyThread.Execute;
var
   MyADOQuery: TADOQuery;
begin
  try
    MyADOQuery:=TADOQuery.Create(nil);
    //MyADOQuery.ConnectionString:='Provider=OraOLEDB.Oracle.1;Password=!;Persist Security Info=True;User ID=esb_user;Data Source=PHOTODB_TEST'; //test
    //MyADOQuery.ConnectionString:='Provider=OraOLEDB.Oracle.1;Password=!;Persist Security Info=True;User ID=rmd_user;Data Source=PHOTODB'; //real
    MyADOQuery.ConnectionString:='Provider=OraOLEDB.Oracle.1;Password=!;Persist Security Info=True;User ID=rmd_user;Data Source=PHOTODBSTD'; //standby
    // Provider=OraOLEDB.Oracle.1;Password=!;Persist Security Info=True;User ID=rmd_user;Data Source=PHOTODB
    MyADOQuery.Close;
    MyADOQuery.SQL.Clear;
    MyADOQuery.SQL.Text:='select t.guid,a.data from esb_user.PHOTO_INFO t '+
              'join esb_user.PHOTO_DATA a on a.id = t.id '+
              'where t.guid = '+ QuotedStr(guid);
    MyADOQuery.Open;
    //TBlobField(MyADOQuery.FieldByName('Data')).SaveToFile('c:\1\'+luna_id+'.jpg');
    if not DirectoryExists(dir+folder) then ForceDirectories(dir+folder);
    if MyADOQuery.RecordCount > 0 then TBlobField(MyADOQuery.FieldByName('Data')).SaveToFile(dir+folder+'\'+luna_id+'.jpg');
  finally
    MyADOQuery.Free;
    if fMain.q_exec_count>0 then fMain.q_exec_count:=fMain.q_exec_count-1;
  end;
end;

procedure TfMain.btnTestClick(Sender: TObject);
begin

end;

procedure TfMain.Button1Click(Sender: TObject);
begin
  fMain.q_exec_count:=0;
  fMain.Label2.Caption:= 'Потоки на исполнении(1): '+IntToStr(fMain.q_exec_count);
end;

procedure TfMain.Timer1Timer(Sender: TObject);
begin
  fMain.q_exec_count:=0;
  fMain.Label2.Caption:= 'Потоки на исполнении(1): '+IntToStr(fMain.q_exec_count);
end;

{ TOrbThread }

procedure TOrbThread.Execute;
Var
   MyADOQuery: TADOQuery;
   dir: string;
   Hour, Min, Sec, MSec: Word;
   Year, Month, Day: Word;
   q: integer;
begin
  try
    q:=StrToInt(fMain.Edit6.Text);
    MyADOQuery:=TADOQuery.Create(nil);
    MyADOQuery.ConnectionString:=
      'Provider=OraOLEDB.Oracle.1;Password=;Persist Security Info=True;User ID=risk_alexey;Data Source=rdwh;Extended Properties=""';
    MyADOQuery.Close;
    MyADOQuery.SQL.Clear;
    MyADOQuery.SQL.Text:=
              'select t.folder,t.luna_id,t.guid1 '+
              'from PhotoDB_TASK t '+
              'where t.dt = (select max(dt) from PhotoDB_TASK) '+
              '      and nn between '+ fMain.Edit2.Text +' and '+ fMain.Edit3.Text +
              ' order by t.nn';
    MyADOQuery.Open;
    repeat
       DecodeTime(now,  Hour, Min, Sec, MSec);
       DecodeDate(now, Year, Month, Day);
       if (Hour <> StrToInt(fMain.Edit4.Text)) and (Day <> StrToInt(fMain.Edit5.Text)) then sleep(60000);
    until (Hour = StrToInt(fMain.Edit4.Text)) and (Day = StrToInt(fMain.Edit5.Text));

    MyADOQuery.First;
    dir:=fMain.Edit1.Text;
    fMain.q_exec_count:=0;
    while not(MyADOQuery.Eof) do begin
       inc(fMain.q_exec_count);
       MyThread:=TMyThread.Create(True);
       MyThread.guid:=MyADOQuery.FieldByName('guid1').AsString;
       MyThread.luna_id:=IntToStr(MyADOQuery.FieldByName('luna_id').AsInteger);
       MyThread.folder:=MyADOQuery.FieldByName('folder').AsString;
       MyThread.dir:=dir;
       MyThread.Priority:=tpNormal;
       MyThread.Resume;
       //sleep(50);
       DecodeTime(now,  Hour, Min, Sec, MSec);
       if (Hour >=9) and (Hour<=19) then begin   //замедление процесса в рабочее время
         if (MyADOQuery.RecNo > 1) and (MyADOQuery.RecNo mod q = 0) then begin
            fMain.Label1.Caption:= 'Номер файла: '+IntToStr(MyADOQuery.RecNo);
            //sleep(1*1000);
            repeat
               fMain.Label2.Caption:= 'Потоки на исполнении(1): '+IntToStr(fMain.q_exec_count);
               sleep(50);
            until fMain.q_exec_count < q;
         end;
       end else begin
         if (MyADOQuery.RecNo > 1) and (MyADOQuery.RecNo mod q = 0) then begin
            fMain.Label1.Caption:= 'Номер файла: '+IntToStr(MyADOQuery.RecNo);
            //sleep(1*1000);
            repeat
               fMain.Label2.Caption:= 'Потоки на исполнении(2): '+IntToStr(fMain.q_exec_count);
               sleep(50);
            until fMain.q_exec_count < q*3;
         end;
       end;
       MyADOQuery.Next;
    end;

  finally
    MyADOQuery.Free;
  end;
end;

end.
